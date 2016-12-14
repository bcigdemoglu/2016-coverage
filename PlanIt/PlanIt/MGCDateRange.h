//
//  MGCDateRange.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License

#import <Foundation/Foundation.h>


@interface MGCDateRange : NSObject<NSCopying>

@property (nonatomic, copy) NSDate *start;      // start of the range
@property (nonatomic, copy) NSDate *end;        // end of the range (excluding)
@property (nonatomic, readonly) BOOL isEmpty;   // range is empty is start is equal to end

+ (instancetype)dateRangeWithStart:(NSDate*)start end:(NSDate*)end;
- (instancetype)initWithStart:(NSDate*)start end:(NSDate*)end;

- (BOOL)isEqualToDateRange:(MGCDateRange*)range;
- (NSDateComponents*)components:(NSCalendarUnit)unitFlags forCalendar:(NSCalendar*)calendar;
- (BOOL)containsDate:(NSDate*)date;
- (void)intersectDateRange:(MGCDateRange*)range;
- (BOOL)intersectsDateRange:(MGCDateRange*)range;
- (BOOL)includesDateRange:(MGCDateRange*)range;
- (void)unionDateRange:(MGCDateRange*)range;
- (void)enumerateDaysWithCalendar:(NSCalendar*)calendar usingBlock:(void (^)(NSDate *day, BOOL *stop))block;

@end
