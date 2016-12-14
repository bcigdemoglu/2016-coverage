//
//  MGCEventView.m
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import "MGCEventView.h"


@implementation MGCEventView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.visibleHeight = CGFLOAT_MAX;
        self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    self.selected = NO;
}

// if needed, implement in subclasses
- (void)didTransitionToEventType:(MGCEventType)toType
{
}

#pragma mark - NSCopying protocol

- (id)copyWithZone:(NSZone*)zone
{
    MGCEventView *cell = [[[self class] allocWithZone:zone] initWithFrame:self.frame];
    return cell;
}

@end
