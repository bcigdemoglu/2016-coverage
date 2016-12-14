//
//  MGCDayColumnCell.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger
{
	MGCDayColumnCellAccessoryNone = 0,
	MGCDayColumnCellAccessoryDot = 1 << 0,		// draw a dot under the day label (e.g. to indicate events on that day)
	MGCDayColumnCellAccessoryMark = 1 << 1,		// draw a mark around the day figure (e.g. to indicate today)
	MGCDayColumnCellAccessoryBorder = 1 << 2,	// draw a border on the left side of the cell (day separator)
    MGCDayColumnCellAccessorySeparator = 1 << 3 // draw a thick border (week separator)
} MGCDayColumnCellAccessoryType;


// This collection view cell is used by the day planner view's subview dayColumnView.
// It is responsible for drawing the day header and vertical separator between columns.
// The day header displays the date, which can be marked, and eventually a dot below
// that can indicate the presence of events. It can also show an activity indicator which
// can be set visible while events are loading (see MGCDayPlannerView setActivityIndicatorVisible:forDate:)
@interface MGCDayColumnCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *dayLabel;						// label displaying dates
@property (nonatomic) MGCDayColumnCellAccessoryType accessoryTypes;		// presentation style of the view
@property (nonatomic) UIColor *markColor;								// color of the mark around the date (default is black)
@property (nonatomic) UIColor *dotColor;								// color of the dot (default is blue)
@property (nonatomic) UIColor *separatorColor;                          // color of the separator line (default is light gray)
@property (nonatomic) CGFloat headerHeight;								// height of the header

- (void)setActivityIndicatorVisible:(BOOL)visible;

@end
