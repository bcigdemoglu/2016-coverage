//
//  MGCEventCell.m
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import "MGCEventCell.h"
#import "MGCEventView.h"
#import "MGCEventCellLayoutAttributes.h"


@implementation MGCEventCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		self.visibleHeight = CGFLOAT_MAX;
	}
    return self;
}

- (void)setEventView:(MGCEventView*)eventView
{
	if (eventView != _eventView) {
		[self.eventView removeFromSuperview];
		[self.contentView addSubview:eventView];
		[self setNeedsLayout];
		
		_eventView = eventView;
		_eventView.visibleHeight = self.visibleHeight;
	}
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	self.eventView.selected = selected;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
	if ([layoutAttributes isKindOfClass:MGCEventCellLayoutAttributes.class]) {
		MGCEventCellLayoutAttributes *attribs = (MGCEventCellLayoutAttributes*)layoutAttributes;
		self.visibleHeight = attribs.visibleHeight;
	}
}

- (void)prepareForReuse
{
	[super prepareForReuse];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.eventView.frame = self.contentView.bounds;
}

@end
