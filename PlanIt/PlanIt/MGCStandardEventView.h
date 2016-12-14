//
//  MGCStandardEventView.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import "MGCEventView.h"


/*! Presentation styles for the view */
typedef NS_OPTIONS(NSUInteger, MGCStandardEventViewStyle) {
	MGCStandardEventViewStyleDefault = 0,		// transparent background
	MGCStandardEventViewStylePlain	 = 1 << 0,	// plain background
	MGCStandardEventViewStyleDot	 = 1 << 1,	// event details are preceded by a dot (e.g to indicate a timed event in the month planner view)
	MGCStandardEventViewStyleBorder	 = 1 << 2,	// view shows a left border (e.g timed events in the day planner view)
	MGCStandardEventViewStyleSubtitle = 1 << 3, // view shows the subtitle string
	MGCStandardEventViewStyleDetail  = 1 << 4	// view shows the detail string
};


/*! 
 *  This subclass of MGCEventView can be used to display the basic properties of an event
 *	in a way similar to iCal.
 *	It is the view class used by the EventKit specialized day/month planner view controllers.
 */
@interface MGCStandardEventView : MGCEventView

/*! Title of the event - displayed in bold */
@property (nonatomic, copy)	NSString *title;

/*! Subtitle - diplayed below the title or next to it if the view is not large enough. */
@property (nonatomic, copy)	NSString *subtitle;

/*! Detail - displayed with a smaller font and right aligned. */
@property (nonatomic, copy)	NSString *detail;

/*! The color is used for background or text, depending on the style. */
@property (nonatomic) UIColor *color;

/*! Style of the view. */
@property (nonatomic) MGCStandardEventViewStyle style;

/*! Font used to draw the event content. Defaults to system font. */
@property (nonatomic) UIFont *font;

@end
