//
//  MGCCalendarHeaderCell.h
//  Calendar
//
//

#import <UIKit/UIKit.h>

@interface MGCCalendarHeaderCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *dayNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *dayNameLabel;
@property (nonatomic, strong) NSDate *date;

@end
