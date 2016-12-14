//
//  MGCEventCellLayoutAttributes.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//  Get the latest version from here:
//
//  Distributed under the MIT License
//

#import <UIKit/UIKit.h>


@interface MGCEventCellLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic) CGFloat visibleHeight;  // height of the visible portion of the cell
@property (nonatomic) NSUInteger numberOfOtherCoveredAttributes;    // number of events which share a time section with this attribute

@end
