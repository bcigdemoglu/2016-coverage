//
//  MGCDayPlannerViewController.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>
#import "MGCDayPlannerView.h"
@class MGCCalendarHeaderView;


/*! 
 *  The MGCDayPlannerViewController class creates a controller object that manages a day planner view.
 */
@interface MGCDayPlannerViewController : UIViewController <MGCDayPlannerViewDelegate, MGCDayPlannerViewDataSource>

/*! Returns the day planner view managed by the controller object. */
@property(nonatomic, retain) MGCDayPlannerView *dayPlannerView;

/*! Returns the calendar header view managed by the controller object. */
@property (nonatomic) MGCCalendarHeaderView *headerView;

@property (nonatomic, assign) BOOL showsWeekHeaderView;

@end
