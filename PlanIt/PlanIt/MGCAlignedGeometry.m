//
//  MGCAlignedGeometry.m
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License



#import <Foundation/Foundation.h>
#import "MGCAlignedGeometry.h"


CGRect MGCAlignedRect(CGRect rect)
{
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGRectMake(floorf(rect.origin.x * scale) / scale, floorf(rect.origin.y * scale) / scale, ceilf(rect.size.width * scale) / scale, ceilf(rect.size.height * scale) / scale);
}

CGRect MGCAlignedRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    return MGCAlignedRect(CGRectMake(x, y, width, height));
}

CGSize MGCAlignedSize(CGSize size)
{
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake(ceilf(size.width * scale) / scale, ceilf(size.height * scale) / scale);
}

CGSize MGCAlignedSizeMake(CGFloat width, CGFloat height)
{
    return MGCAlignedSize(CGSizeMake(width, height));
}

CGPoint MGCAlignedPoint(CGPoint point)
{
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGPointMake(floorf(point.x * scale) / scale, floorf(point.y * scale) / scale);
}

CGPoint MGCAlignedPointMake(CGFloat x, CGFloat y)
{
    return MGCAlignedPoint(CGPointMake(x, y));
}

CGFloat MGCAlignedFloat(CGFloat f)
{
    CGFloat scale = [UIScreen mainScreen].scale;
    return roundf(f * scale) / scale;
}

