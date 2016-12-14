//
//  MGCInteractiveEventCell.h
//  Graphical Calendars Library for iOS
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>
#import "MGCEventView.h"


// This is the interactive view shown when the user taps and holds on an event view.
// If permitted, the view can be dragged around in order to move the event.
@interface MGCInteractiveEventView : UIView

@property (nonatomic) MGCEventView *eventView;		// event view - this is a copy of the view that was tapped
@property (nonatomic) BOOL forbiddenSignVisible;	// set to YES to show a prohibited sign above the view. It indicates the event cannot be moved to that date or time.

@end
