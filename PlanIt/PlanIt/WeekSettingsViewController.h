//
//  WeekSettingsViewController.h
//  Calendar
//

#import <UIKit/UIKit.h>
#import "WeekViewController.h"


@protocol WeekSettingsViewControllerDelegate;


@interface WeekSettingsViewController : UITableViewController

@property (nonatomic) WeekViewController *weekViewController;

@end
