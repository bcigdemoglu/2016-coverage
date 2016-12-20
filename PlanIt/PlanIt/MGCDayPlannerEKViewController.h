//
//  MGCDayPlannerEKViewController.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "MGCDayPlannerViewController.h"


@protocol MGCDayPlannerEKViewControllerDelegate;


@interface MGCDayPlannerEKViewController : MGCDayPlannerViewController<UIPopoverPresentationControllerDelegate>

@property (nonatomic) NSCalendar *calendar;
@property (nonatomic) NSSet *visibleCalendars;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, readonly) EKEventStore *eventStore;
@property (nonatomic, weak) id<MGCDayPlannerEKViewControllerDelegate> delegate;

/** designated initializer */
- (instancetype)initWithEventStore:(EKEventStore*)eventStore;
- (void)reloadEvents;

@end


@protocol MGCDayPlannerEKViewControllerDelegate<NSObject>


@optional

- (void)showEditControllerForEventOfType:(MGCEventType)type atIndex:(NSUInteger)index date:(NSDate*)date;

- (void)dayPlannerEKEViewController:(MGCDayPlannerEKViewController*)vc willPresentEventViewController:(EKEventViewController*)eventViewController;

- (UINavigationController*)dayPlannerEKViewController:(MGCDayPlannerEKViewController*)vc navigationControllerForPresentingEventViewController:(EKEventViewController*)eventViewController;

@end
