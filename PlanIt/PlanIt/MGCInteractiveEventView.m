//
//  MGCInteractiveEventCell.m
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import "MGCInteractiveEventView.h"


@interface MGCInteractiveEventView ()

@property (nonatomic) CATextLayer *forbiddenSignLayer;

@end


@implementation MGCInteractiveEventView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		_forbiddenSignVisible = NO;
	}
	return self;
}

- (void)setEventView:(MGCEventView*)eventView
{
	if (eventView != _eventView) {
		[self.eventView removeFromSuperview];
		[self addSubview:eventView];
		
		eventView.selected = YES;
		[self setNeedsLayout];
		
		_eventView = eventView;
	}
}

- (void)setForbiddenSignVisible:(BOOL)forbiddenSignVisible
{
	if (_forbiddenSignVisible != forbiddenSignVisible) {
		self.forbiddenSignLayer.hidden = !forbiddenSignVisible;
		_forbiddenSignVisible = forbiddenSignVisible;
	}
}

- (CATextLayer*)forbiddenSignLayer
{
	if (_forbiddenSignLayer == nil) {
		_forbiddenSignLayer = [CATextLayer layer];
		_forbiddenSignLayer.string =   @"\u26D4"; //@"\U0001F6AB"; //@"\u20E0"
		_forbiddenSignLayer.fontSize = 16;
		_forbiddenSignLayer.contentsScale = [[UIScreen mainScreen] scale];
		_forbiddenSignLayer.alignmentMode = kCAAlignmentCenter;
		_forbiddenSignLayer.frame = CGRectMake(0,0,30,30);
		_forbiddenSignLayer.zPosition = 10;
		_forbiddenSignLayer.position = CGPointMake(0,0);
		
		[self.layer addSublayer:_forbiddenSignLayer];
	}
	return _forbiddenSignLayer;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.eventView.frame = self.bounds;
}

@end
