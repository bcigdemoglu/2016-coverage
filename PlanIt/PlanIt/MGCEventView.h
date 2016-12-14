//
//  MGCEventView.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>
#import "MGCReusableObjectQueue.h"
#import "MGCDayPlannerView.h"


/*! 
 *  MGCEventView is used by MGCDayPlannerView and MGCMonthPlannerView to present the content of single events.
 *	You can subclass this class or use the already existing subclass MGCStandardEventView, which supports the
 *	display of basic event properties such as title and location.
 *	You must register your custom class(es) with the day/month planner view object and when needed
 *  call dequeueReusableViewWithIdentifier:forEvent... methods to retrieve an instance of the appropriate class, 
 *	depending on the event being displayed.
 *
 *	Because event view objects may be copied by the day/month planner view, make sure your subclass conforms 
 *	to the NSCopying protocol and copies custom properties to new instances.
 */
@interface MGCEventView : UIView<MGCReusableObject, NSCopying>

/*! @brief		A string that identifies the purpose of the view.
 *	@discussion This is set by the day/month planner view and should not be set directly.
 */
@property (nonatomic, copy) NSString *reuseIdentifier;

/*! @brief		The selection state of the view.
 *	@discussion This should not be set directly. 
 *				To (de)select an event, use the selection methods of the day/month planner view.
 */
@property (nonatomic) BOOL selected;

/*! @brief		Height of the visible portion of the view.
 *	@discussion	If the view is partially hidden by an other event view, you can use this property
 *				to determine the available height to show the event content.
 *				You should not set this property directly.
 */
@property (nonatomic) CGFloat visibleHeight;

/*! @brief		This is called by the day planner view when an event view is dragged around and the
 *				target event type is changing.
 *	@discussion	By implementing this method in your subclass, you can change the way the view
 *				displays the content of the event.
 */
- (void)didTransitionToEventType:(MGCEventType)toType;

@end
