//
//  MGCEventKitSupport.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//


#import <EventKitUI/EventKitUI.h>


typedef void(^EventSaveCompletionBlockType)(BOOL);


@interface MGCEventKitSupport : NSObject

@property (nonatomic, readonly) EKEventStore *eventStore;
@property (nonatomic, readonly) BOOL accessGranted;

- (instancetype)initWithEventStore:(EKEventStore*)eventStore;
- (void)checkEventStoreAccessForCalendar:(void (^)(BOOL accessGranted))completion;
- (void)saveEvent:(EKEvent*)event completion:(void (^)(BOOL saved))completion;

@end


@interface MGCEKEventViewController: EKEventViewController

@end
