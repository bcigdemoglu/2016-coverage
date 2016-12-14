//
//  WeekViewController.h
//  Calendar
//

#import "MGCDayPlannerEKViewController.h"
#import "MainViewController.h"


@protocol WeekViewControllerDelegate <MGCDayPlannerEKViewControllerDelegate, CalendarViewControllerDelegate, UIViewControllerTransitioningDelegate>

@end


@interface WeekViewController : MGCDayPlannerEKViewController <CalendarViewControllerNavigation>

@property (nonatomic, weak) id<WeekViewControllerDelegate> delegate;
@property (nonatomic) BOOL showDimmedTimeRanges;

@end
