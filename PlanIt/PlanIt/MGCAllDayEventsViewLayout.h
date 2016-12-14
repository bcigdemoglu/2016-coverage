//
//  MGCAllDayEventsViewLayout.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>


static NSString* const MoreEventsViewKind = @"MoreEventsViewKind";

typedef enum : NSUInteger
{
	AllDayEventInsetNone = 0,
	AllDayEventInsetLeft  = 1 << 0,
	AllDayEventInsetRight = 1 << 1,
} AllDayEventInset;


@protocol MGCAllDayEventsViewLayoutDelegate;


// This collection view layout is responsible for the layout of event views in the all-day events part
// of the day planner view.
@interface MGCAllDayEventsViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MGCAllDayEventsViewLayoutDelegate> delegate;
@property (nonatomic) CGFloat dayColumnWidth;		// width of columns
@property (nonatomic) CGFloat eventCellHeight;		// height of an event cell
@property (nonatomic) CGFloat maxContentHeight;		// if the total content height, defined by the sum of the height of all stacked cells, is more than this value, then some cells will be hidden and a view at the bottom will indicate the number of hidden events

- (NSUInteger)numberOfHiddenEventsInSection:(NSInteger)section;

@end


@protocol MGCAllDayEventsViewLayoutDelegate<UICollectionViewDelegate>

- (NSRange)collectionView:(UICollectionView*)view layout:(MGCAllDayEventsViewLayout*)layout dayRangeForEventAtIndexPath:(NSIndexPath*)indexPath;

@optional

- (AllDayEventInset)collectionView:(UICollectionView*)view layout:(MGCAllDayEventsViewLayout*)layout insetsForEventAtIndexPath:(NSIndexPath*)indexPath;

@end
