//
//  MGCTimeRowsView.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>
#import "MGCDayPlannerView.h"   // for MGCDayPlannerTimeMark enum


@protocol MGCTimeRowsViewDelegate;


// This view is used by the day planner view to draw the time lines.
// It is contained in a scrollview, which itself is a subview of the day planner view.
@interface MGCTimeRowsView : UIView

@property (nonatomic) NSCalendar *calendar;				// used to calculate current time
@property (nonatomic) CGFloat hourSlotHeight;			// height of a one-hour slot (default is 65)
@property (nonatomic) CGFloat insetsHeight;				// top and bottom margin height (default is 45)
@property (nonatomic) CGFloat timeColumnWidth;			// width of the time column on the left side (default is 40)
@property (nonatomic) NSTimeInterval timeMark;			// time from start of day for the mark that appears when an event is moved around - set to 0 to hide it
@property (nonatomic) BOOL showsCurrentTime;			// YES if shows red line for current time
@property (nonatomic, readonly) BOOL showsHalfHourLines; // returns YES if hourSlotHeight > 100
@property (nonatomic) NSRange hourRange;                // range of displayed hours
@property (nonatomic) UIFont *font;						// font used for time marks
@property (nonatomic) UIColor *timeColor;				// color used for time marks and lines
@property (nonatomic) UIColor *currentTimeColor;		// color used for current time mark and line
@property (nonatomic, weak) id<MGCTimeRowsViewDelegate> delegate;

@end


@protocol MGCTimeRowsViewDelegate<NSObject>

@optional

- (NSAttributedString*)timeRowsView:(MGCTimeRowsView*)view attributedStringForTimeMark:(MGCDayPlannerTimeMark)mark time:(NSTimeInterval)ti;

@end
