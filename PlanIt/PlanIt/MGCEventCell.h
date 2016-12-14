//
//  MGCEventCell.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>


@class MGCEventView;

// This collection view cell is used by the day planner view's subviews timedEventsView
// and allDayEventsView.
// It is the parent view for event content views, which are subclasses of MGCEventView.
@interface MGCEventCell : UICollectionViewCell

@property (nonatomic) MGCEventView *eventView;	// content view of the event cell
@property (nonatomic) CGFloat visibleHeight;	// height of the visible portion of the cell (set via MGCEventCellLayoutAttributes)

@end
