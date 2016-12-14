//
//  MGCTimedEventsViewLayout.h
//  Graphical Calendars Library for iOS
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>

static NSString* const DimmingViewKind = @"DimmingViewKind";

typedef enum : NSUInteger
{
    TimedEventCoveringTypeClassic = 0,
    TimedEventCoveringTypeComplex  = 1 << 0,
} TimedEventCoveringType;


@protocol MGCTimedEventsViewLayoutDelegate;
@class MGCEventCellLayoutAttributes;


// Custom invalidation context for MGCTimedEventsViewLayout
@interface MGCTimedEventsViewLayoutInvalidationContext: UICollectionViewLayoutInvalidationContext

@property (nonatomic) BOOL invalidateDimmingViews;  // set to true if layout attributes of dimming views must be recomputed
@property (nonatomic) BOOL invalidateEventCells;  // set to true if layout attributes of event cells must be recomputed
@property (nonatomic) NSMutableIndexSet *invalidatedSections;   // sections whose layout attributes (dimming views or event cells) must be recomputed - if nil, recompute everything

@end


// This collection view layout is responsible for the layout of event views in the timed-events part
// of the day planner view.
@interface MGCTimedEventsViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MGCTimedEventsViewLayoutDelegate> delegate;
@property (nonatomic) CGSize dayColumnSize;
@property (nonatomic) CGFloat minimumVisibleHeight;  // if 2 cells overlap, and the height of the uncovered part of the upper cell is less than this value, the column is split
@property (nonatomic) BOOL ignoreNextInvalidation;  // for some reason, UICollectionView reloadSections: messes up with scrolling and animations so we have to stick with using reloadData even when only individual sections need to be invalidated. As a workaroud, we explicitly invalidate them with custom context, and set this flag to YES before calling reloadData
@property (nonatomic) TimedEventCoveringType coveringType;  // how to handle event covering

@end


@protocol MGCTimedEventsViewLayoutDelegate <UICollectionViewDelegate>

// x and width of returned rect are ignored
- (CGRect)collectionView:(UICollectionView*)collectionView layout:(MGCTimedEventsViewLayout*)layout rectForEventAtIndexPath:(NSIndexPath*)indexPath;
- (NSArray*)collectionView:(UICollectionView*)collectionView layout:(MGCTimedEventsViewLayout*)layout dimmingRectsForSection:(NSUInteger)section;

@end
