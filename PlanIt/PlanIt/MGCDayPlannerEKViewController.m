//
//  MGCDayPlannerEKViewController.m
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <EventKitUI/EventKitUI.h>

#import "MGCDayPlannerEKViewController.h"
#import "MGCStandardEventView.h"
#import "NSCalendar+MGCAdditions.h"
#import "MGCDateRange.h"
#import "OSCache.h"
#import "MGCEventKitSupport.h"
#import "PlanIt-Swift.h"


typedef enum {
    TimedEventType = 1,
    AllDayEventType = 2,
    AnyEventType = TimedEventType|AllDayEventType
} EventType;


static const NSUInteger cacheSize = 400;	// size of the cache (in days)
static NSString* const EventCellReuseIdentifier = @"EventCellReuseIdentifier";


@interface MGCDayPlannerEKViewController () <UINavigationControllerDelegate, EKEventEditViewDelegate, EKEventViewDelegate>

@property (nonatomic) MGCEventKitSupport *eventKitSupport;
@property (nonatomic) dispatch_queue_t bgQueue;			// dispatch queue for loading events
@property (nonatomic) NSMutableOrderedSet *daysToLoad;	// dates for months of which we want to load events
@property (nonatomic) NSCache *eventsCache;
@property (nonatomic) NSUInteger createdEventType;
@property (nonatomic, copy) NSDate *createdEventDate;
@property (nonatomic) NSDate *eventDate;

@property (nonatomic) EKEvent* event;
@property (nonatomic) EKEventEditViewController* vcEdit;
@property (nonatomic) MGCEventType* mgcEvType;
@property (nonatomic) NSString* eventLocation;
@property (nonatomic) NSString* eventName;
@property (nonatomic) EventType* eventType;
@property (nonatomic) EKEventStore* store;

@end


@implementation MGCDayPlannerEKViewController

@synthesize calendar = _calendar;
@synthesize event;
@synthesize vcEdit;
//@synthesize mgcEventType = TimedEventType;

- (instancetype)initWithEventStore:(EKEventStore*)eventStore
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _eventKitSupport = [[MGCEventKitSupport alloc]initWithEventStore:eventStore];
    }
    return self;
}

- (void)reloadEvents
{
    for (NSDate *date in self.daysToLoad) {
        [self.dayPlannerView setActivityIndicatorVisible:NO forDate:date];
    }
    [self.daysToLoad removeAllObjects];
    
    [self.eventsCache removeAllObjects];
    
    MGCDateRange *adays = self.dayPlannerView.visibleDays;
    NSDate *d =[self.calendar mgc_nextStartOfDayForDate:adays.end];
    
    //[self fetchEventsForDate: d];
    [self fetchEventsInDateRange:self.dayPlannerView.visibleDays];
    [self.dayPlannerView reloadAllEvents];
}

- (void)showEditControllerForEventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date
{
    EKEvent *ev = [self eventOfType:type atIndex:index date:date];
    
    MGCEventView *view = [self.dayPlannerView eventViewOfType:type atIndex:index date:date];
    
    MGCEKEventViewController *eventController = [MGCEKEventViewController new];
    eventController.event = ev;
    eventController.delegate = self;
    eventController.allowsEditing = NO;
    eventController.allowsCalendarPreview = YES;
    eventController.delegate = self;
    
    UINavigationController *nc = nil;
    if ([self.delegate respondsToSelector:@selector(dayPlannerEKViewController:navigationControllerForPresentingEventViewController:)]) {
        nc = [self.delegate dayPlannerEKViewController:self navigationControllerForPresentingEventViewController:eventController];
    }
    
    if (nc) {
        [nc pushViewController:eventController animated:YES];
    }
    else {
        nc = [[UINavigationController alloc]initWithRootViewController:eventController];
        nc.modalPresentationStyle = UIModalPresentationPopover;
        eventController.presentationController.delegate = self;
        
        [self showDetailViewController:nc sender:self];
        
        CGRect visibleRect = CGRectIntersection(self.dayPlannerView.bounds, [self.dayPlannerView convertRect:view.bounds fromView:view]);
        UIPopoverPresentationController *popController = nc.popoverPresentationController;
        popController.permittedArrowDirections = UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight;
        popController.delegate = self;
        popController.sourceView = self.dayPlannerView;
        popController.sourceRect = visibleRect;
    }
}


-(void)seeSuggestions:(UIButton*)eventSender
{
    NSLog(@"Click");
    //[UIPopoverController dismissPopoverAnimated:NO];
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Calendar" bundle:NULL];

    LocationSearchTable *search = [sb instantiateViewControllerWithIdentifier:@"TEST"];
    search.date = self.eventDate;
    search.eventTypeNum = self.createdEventType;
    
    [self.vcEdit.editViewDelegate eventEditViewController:self.vcEdit didCompleteWithAction:1];
    
    search.event = self.event;
    search.vcEdit = self.vcEdit;
    search.mgcView = self;
    search.mgc = self.delegate;
    search.location = self.eventLocation;
    search.eventKit = self.eventKitSupport;
    search.mgcPlanView = self.dayPlannerView;
    search.mgcParent = self.parentViewController;
    search.eventName = self.eventName;
    //search.store = self.store;
    
    [self.navigationController pushViewController:search animated:YES];
    //search.eventType = self.mgcEventType;
    
    [self.eventKitSupport saveEvent:self.event completion:^(BOOL completion){
      [self.dayPlannerView endInteraction];
    }];
   
}


#pragma mark - Extra
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[UITableViewController class]]) {
        UITableView *tableView = ((UITableViewController *)viewController).tableView;
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"Coin" style:UIBarButtonItemStylePlain target:self action:@selector(changeToInAppScene:)];
        self.navigationItem.rightBarButtonItem = rightBar;
        
        for (NSInteger j = 0; j < [tableView numberOfSections]; ++j){
            for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                
                NSLog(@"cell => %@, row => %d, section => %d", cell.textLabel.text, i, j);
                
                if(j == 1 && i == 0) {
                  //  [cell removeFromSuperview];
                    UIButton *a = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    CGFloat width = cell.frame.size.width;
                    CGFloat height = cell.frame.size.height;
                    CGFloat x = cell.frame.origin.x;
                    //CGFloat y = cell.frame.origin.y;
                    a.frame = CGRectMake(x, 4.5f, width, height);
                    a.backgroundColor = [UIColor whiteColor];
                    [a addTarget:self action:@selector(seeSuggestions:) forControlEvents:UIControlEventTouchUpInside];
                    [a setTitle:@"See Suggestions" forState:UIControlStateNormal];
                    [cell addSubview:a];
                    
                    UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
                    cell.accessoryView = switchBtn;
                    switchBtn.backgroundColor = [UIColor whiteColor];
                    [switchBtn addTarget:self action:@selector(seeSuggestions:) forControlEvents:UIControlEventValueChanged];
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                   

                }else if (i == 4 && j == 1) {

                }
            }
        }

    }
}


/// public
//Edit controller for New events here!!!
- (void)showPopoverForNewEvent:(EKEvent*)ev
{

    EKEventEditViewController *eventController = [EKEventEditViewController new];
    eventController.event = ev;
    eventController.eventStore = self.eventStore;
    eventController.editViewDelegate = self; // called only when event is deleted
    eventController.modalInPopover = YES;
    eventController.modalPresentationStyle = UIModalPresentationPopover;
    eventController.presentationController.delegate = self;
    eventController.delegate = self;

    self.eventDate = ev.startDate;
    self.store = self.eventStore;
    self.event = ev;
    self.vcEdit = eventController;
    
    [self showDetailViewController:eventController sender:self];
    
    CGRect cellRect = [self.dayPlannerView rectForNewEventOfType:self.createdEventType atDate:self.createdEventDate];
    CGRect visibleRect = CGRectIntersection(self.dayPlannerView.bounds, cellRect);

    UIPopoverPresentationController *popController = eventController.popoverPresentationController;
    popController.permittedArrowDirections = UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight;
    popController.delegate = self;
    popController.sourceView = self.dayPlannerView;
    popController.sourceRect = visibleRect;
}

#pragma mark - UIViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    return [self initWithEventStore:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadEvents) name:EKEventStoreChangedNotification object:self.eventStore];
    
    self.eventsCache = [[OSCache alloc]init];
    self.eventsCache.countLimit = cacheSize;
    //self.eventsCache.delegate = self;
    
    self.bgQueue = dispatch_queue_create("MGCDayPlannerEKViewController.bgQueue", NULL);
    
    [self.eventKitSupport checkEventStoreAccessForCalendar:^(BOOL granted) {
        if (granted) {
            NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
            self.visibleCalendars = [NSSet setWithArray:calendars];
            [self reloadEvents];
        }
    }];
    
    self.dayPlannerView.calendar = self.calendar;
    [self.dayPlannerView registerClass:MGCStandardEventView.class forEventViewWithReuseIdentifier:EventCellReuseIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (NSCalendar*)calendar
{
    if (_calendar == nil) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (void)setCalendar:(NSCalendar*)calendar
{
    _calendar = calendar;
    self.dayPlannerView.calendar = calendar;
}

- (EKEventStore*)eventStore
{
    return self.eventKitSupport.eventStore;
}

- (void)setVisibleCalendars:(NSSet*)visibleCalendars
{
    _visibleCalendars = visibleCalendars;
    [self.dayPlannerView reloadAllEvents];
}

#pragma mark - Loading events

- (void)fetchEventsInDateRange:(MGCDateRange*)range
{
    range.start = [self.calendar mgc_startOfDayForDate:range.start];
    range.end = [self.calendar mgc_nextStartOfDayForDate:range.end];
    
    [range enumerateDaysWithCalendar:self.calendar usingBlock:^(NSDate *date, BOOL *stop) {
        NSDate *dayEnd = [self.calendar mgc_nextStartOfDayForDate:date];
        NSArray *events = [self fetchEventsFrom:date to:dayEnd calendars:nil];
        [self.eventsCache setObject:events forKey:date];
    }];
}

/*- (void) fetchEventsForDate:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate: date];
    [User getEventsWithDate:dateString completionHandler:^(NSString * _Nullable result) {
        NSArray *events = [User fetchCurrentEvents];
        [self.eventsCache setObject:events forKey:date];
    }];
    
}*/
- (NSArray*)fetchEventsFrom:(NSDate*)startDate to:(NSDate*)endDate calendars:(NSArray*)calendars
{
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];
    
    if (self.eventKitSupport.accessGranted) {
        NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
        if (events) {
            return [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
        }
    }
    
    return [NSArray array];
}

// returns the events dictionary for given date
// try to load it from the cache, or create it if needed
- (NSArray*)eventsForDay:(NSDate*)date
{
    NSDate *dayStart = [self.calendar mgc_startOfDayForDate:date];
    
    NSArray *events = [self.eventsCache objectForKey:dayStart];
    
    if (!events) {  // cache miss: create dictionary...
        NSDate *dayEnd = [self.calendar mgc_nextStartOfDayForDate:dayStart];
        events = [self fetchEventsFrom:dayStart to:dayEnd calendars:nil];
        [self.eventsCache setObject:events forKey:dayStart];
    }
    
    return events;
}

- (NSArray*)eventsOfType:(EventType)type forDay:(NSDate*)date
{
    NSArray *events = [self eventsForDay:date];
    
    NSMutableArray *filteredEvents = [NSMutableArray new];
    [events enumerateObjectsUsingBlock:^(EKEvent *ev, NSUInteger idx, BOOL *stop) {
        
        if ([self.visibleCalendars containsObject:ev.calendar]) {
            if (type & AllDayEventType && ev.isAllDay)
                [filteredEvents addObject:ev];
            else if (type & TimedEventType && !ev.isAllDay)
                [filteredEvents addObject:ev];
        }
    }];
    
    return filteredEvents;
}

- (EKEvent*)eventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date
{
    NSArray *events = nil;
    
    if (type == MGCAllDayEventType) {
        events = [self eventsOfType:AllDayEventType forDay:date];
    }
    else if (type == MGCTimedEventType) {
        events = [self eventsOfType:TimedEventType forDay:date];
    }
    
    return [events objectAtIndex:index];
}

- (void)bg_loadEventsAtDate:(NSDate*)date
{
    //NSLog(@"bg_loadEventsAtDate: %@", date);
    
    NSDate *dayStart = [self.calendar mgc_startOfDayForDate:date];
    
    [self eventsOfType:AnyEventType forDay:dayStart];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dayPlannerView reloadEventsAtDate:date];
        [self.dayPlannerView setActivityIndicatorVisible:NO forDate:dayStart];
    });
}

- (void)bg_loadOneDay
{
    __block NSDate *date;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ((date = [self.daysToLoad firstObject])) {
            [self.daysToLoad removeObject:date];
        }
        
        if (![self.dayPlannerView.visibleDays containsDate:date]) {
            date = nil;
        }
    });
    
    if (date) {
        [self bg_loadEventsAtDate:date];
    }
}

- (BOOL)loadEventsAtDate:(NSDate*)date
{
    NSDate *dayStart = [self.calendar mgc_startOfDayForDate:date];
    
    if (![self.eventsCache objectForKey:dayStart]) {
        [self.dayPlannerView setActivityIndicatorVisible:YES forDate:dayStart];
        
        if (!self.daysToLoad) {
            self.daysToLoad = [NSMutableOrderedSet orderedSet];
        }
        
        [self.daysToLoad addObject:dayStart];
        
        dispatch_async(self.bgQueue, ^{	[self bg_loadOneDay]; });
        
        return YES;
    }
    return NO;
}

#pragma mark - MGCDayPlannerViewDataSource

- (NSInteger)dayPlannerView:(MGCDayPlannerView*)weekView numberOfEventsOfType:(MGCEventType)type atDate:(NSDate*)date
{
    NSInteger count = 0;
    
    if (![self loadEventsAtDate:date]) {
        if (type == MGCAllDayEventType) {
            count = [[self eventsOfType:AllDayEventType forDay:date]count];
        }
        else {
            count = [[self eventsOfType:TimedEventType forDay:date]count];
            self.mgcEvType = type;
            self.eventType = TimedEventType;
        }
    }
    return count;
}

- (MGCEventView*)dayPlannerView:(MGCDayPlannerView*)view viewForEventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date
{
    EKEvent *ev = [self eventOfType:type atIndex:index date:date];
    MGCStandardEventView *evCell = (MGCStandardEventView*)[view dequeueReusableViewWithIdentifier:EventCellReuseIdentifier forEventOfType:type atIndex:index date:date];
    evCell.font = [UIFont systemFontOfSize:11];
    evCell.title = ev.title;
    evCell.subtitle = ev.location;
    evCell.color = [UIColor colorWithCGColor:ev.calendar.CGColor];
    evCell.style = MGCStandardEventViewStylePlain|MGCStandardEventViewStyleSubtitle;
    evCell.style |= (type == MGCAllDayEventType) ?: MGCStandardEventViewStyleBorder;
    return evCell;
}

- (MGCDateRange*)dayPlannerView:(MGCDayPlannerView*)view dateRangeForEventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date
{
    EKEvent *ev = [self eventOfType:type atIndex:index date:date];
    
    NSDate *end = ev.endDate;
    if (type == MGCAllDayEventType) {
        end = [self.calendar mgc_nextStartOfDayForDate:end];
    }
    
    return [MGCDateRange dateRangeWithStart:ev.startDate end:end];
}

- (BOOL)dayPlannerView:(MGCDayPlannerView*)view shouldStartMovingEventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date
{
    EKEvent *ev = [self eventOfType:type atIndex:index date:date];
    return ev.calendar.allowsContentModifications;
}

- (BOOL)dayPlannerView:(MGCDayPlannerView*)view canMoveEventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date toType:(MGCEventType)targetType date:(NSDate*)targetDate
{
	EKEvent *ev = [self eventOfType:type atIndex:index date:date];
	return ev.calendar.allowsContentModifications;
}

- (void)dayPlannerView:(MGCDayPlannerView*)view moveEventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date toType:(MGCEventType)targetType date:(NSDate*)targetDate
{
    EKEvent *ev = [self eventOfType:type atIndex:index date:date];
    
    if (ev) {
        NSDateComponents *duration = [self.calendar components:NSMinuteCalendarUnit fromDate:ev.startDate toDate:ev.endDate options:0];
        if (ev.allDay && targetType == MGCTimedEventType) {
            duration.minute = view.durationForNewTimedEvent / 60;
        }
        NSDate *end = [self.calendar dateByAddingComponents:duration toDate:targetDate options:0];
        
        // allDay property has to be set before start and end dates !
        ev.allDay = (targetType == MGCAllDayEventType);
        ev.startDate = targetDate;
        ev.endDate = end;
        
        [self.eventKitSupport saveEvent:ev completion:^(BOOL completion) {
            [self.dayPlannerView endInteraction];
        }];
    }
}

- (MGCEventView*)dayPlannerView:(MGCDayPlannerView*)view viewForNewEventOfType:(MGCEventType)type atDate:(NSDate*)date
{
    EKCalendar *defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
    MGCStandardEventView *evCell = [MGCStandardEventView new];
    evCell.title = NSLocalizedString(@"New Event", nil);
    evCell.color = [UIColor colorWithCGColor:defaultCalendar.CGColor];
    return evCell;
}

/**
 * Check the date to make sure it is correct and for popovercontroller
 */
- (void)dayPlannerView:(MGCDayPlannerView *)view createNewEventOfType:(EKEvent*)ev
{
    [self showPopoverForNewEvent:ev];
}
/**
 * Check the date to make sure it is correct and for popovercontroller
 */
- (void)dayPlannerView:(MGCDayPlannerView *)view createNewEventOfType:(MGCEventType)type atDate:(NSDate*)date
{
    // CONTROLLER HERE FOR LOCATION TRY THIS
    // and ADD LOCATION HERE
    
    self.createdEventType = type;
    self.createdEventDate = date;
    
    EKEvent *ev = [EKEvent eventWithEventStore:self.eventStore];
    ev.startDate = date;
    ev.location = @"default";
    
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = ((NSInteger) view.durationForNewTimedEvent) / (60 * 60 * 24);
    comps.hour = (((NSInteger) view.durationForNewTimedEvent) / (60 * 60)) - (comps.day * 24);
    comps.minute = (((NSInteger) view.durationForNewTimedEvent) / 60) - (comps.day * 24 * 60) - (comps.hour * 60);
    comps.second = ((NSInteger) round(view.durationForNewTimedEvent)) % 60;

    ev.endDate = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    ev.allDay = (type == MGCAllDayEventType) ? YES : NO;
    //Add location here
    
    [self showPopoverForNewEvent:ev];
}

#pragma mark - MGCDayPlannerViewDelegate

- (void)dayPlannerView:(MGCDayPlannerView*)view didSelectEventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date
{
    [self showEditControllerForEventOfType:type atIndex:index date:date];
}

- (void)dayPlannerView:(MGCDayPlannerView*)view willDisplayDate:(NSDate*)date
{
    //NSLog(@"will display %@", date);
    BOOL loading = [self loadEventsAtDate:date];
    if (!loading) {
        [self.dayPlannerView setActivityIndicatorVisible:NO forDate:date];
    }
}

- (void)dayPlannerView:(MGCDayPlannerView*)view didEndDisplayingDate:(NSDate*)date
{
    //NSLog(@"did end displaying %@", date);
    [self.daysToLoad removeObject:date];
}

#pragma mark - EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.eventLocation = self.event.location;
    self.eventName = self.event.title;
    self.event = controller.event;
    if (action == 1) {
        //ADD RATING HERE
    }
    
    [self.dayPlannerView endInteraction];
    self.event = controller.event;
    self.createdEventDate = nil;
}

#pragma mark - EKEventViewDelegate

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action
{
    [self.dayPlannerView deselectEvent];
    if (controller.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [controller.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIViewController*)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style
{
    if ([controller.presentedViewController isKindOfClass:EKEventEditViewController.class]) {
        return controller.presentedViewController;
    }
    else {
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:controller.presentedViewController];
        nc.delegate = self;
        return nc;
    }
}


- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view
{
    CGRect cellRect;
    if (self.createdEventDate) {
        cellRect = [self.dayPlannerView rectForNewEventOfType:self.createdEventType atDate:self.createdEventDate];
    }
    else {
        UIView *cell = self.dayPlannerView.selectedEventView;
        cellRect = [self.dayPlannerView convertRect:cell.bounds fromView:cell];
    }
    CGRect visibleRect = CGRectIntersection(self.dayPlannerView.bounds, cellRect);
    if (CGRectIsNull(visibleRect)) {
        rect->origin.x = cellRect.origin.x;
        rect->origin.y = fminf(cellRect.origin.y, CGRectGetMaxY(self.dayPlannerView.bounds));
        rect->size.width = cellRect.size.width;
    }
    else {
        *rect = visibleRect;
    }
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    [self.dayPlannerView deselectEvent];
}

#pragma mark - UINavigationControllerDelegate

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//}

@end

