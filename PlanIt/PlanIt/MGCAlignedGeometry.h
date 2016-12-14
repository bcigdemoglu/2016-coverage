//
//  MGCAlignedGeometry.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License


// functions to align coordinates on pixel boundaries
#import <UIKit/UIKit.h>

CGRect MGCAlignedRect(CGRect rect);
CGRect MGCAlignedRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
CGSize MGCAlignedSize(CGSize size);
CGSize MGCAlignedSizeMake(CGFloat width, CGFloat height);
CGPoint MGCAlignedPoint(CGPoint point);
CGPoint MGCAlignedPointMake(CGFloat x, CGFloat y);
CGFloat MGCAlignedFloat(CGFloat f);
