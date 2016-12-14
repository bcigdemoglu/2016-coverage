//
//  MGCEventCellLayoutAttributes.m
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//


#import "MGCEventCellLayoutAttributes.h"

@implementation MGCEventCellLayoutAttributes

- (BOOL)isEqual:(id)object
{
	if (![super isEqual:object])
		return NO;
	
	MGCEventCellLayoutAttributes* attribs = (MGCEventCellLayoutAttributes*)object;
	return (attribs.visibleHeight == self.visibleHeight);
}

- (id)copyWithZone:(NSZone*)zone
{
    MGCEventCellLayoutAttributes *attribs = [super copyWithZone:zone];
    attribs.visibleHeight = self.visibleHeight;
    return attribs;
}

@end
