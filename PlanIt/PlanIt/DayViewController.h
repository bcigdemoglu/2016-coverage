//
//  DayViewController.h
//  Calendar
//

//

#import "MGCDayPlannerEKViewController.h"
#import "MainViewController.h"


@protocol DayViewControllerDelegate <MGCDayPlannerEKViewControllerDelegate, CalendarViewControllerDelegate, UIViewControllerTransitioningDelegate>

@end


@interface DayViewController : MGCDayPlannerEKViewController <CalendarViewControllerNavigation>

@property (nonatomic, weak) id<DayViewControllerDelegate> delegate;

@end

