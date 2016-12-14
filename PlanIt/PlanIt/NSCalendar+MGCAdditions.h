//
//  NSCalendar+MGCAdditions.h
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import <Foundation/Foundation.h>


@interface NSCalendar (MGCAdditions)

+ (NSCalendar*)mgc_calendarFromPreferenceString:(NSString*)string;

- (NSDate*)mgc_startOfDayForDate:(NSDate*)date;
- (NSDate*)mgc_nextStartOfDayForDate:(NSDate*)date;
- (NSDate*)mgc_startOfWeekForDate:(NSDate*)date;
- (NSDate*)mgc_nextStartOfWeekForDate:(NSDate*)date;
- (NSDate*)mgc_startOfMonthForDate:(NSDate*)date;
- (NSDate*)mgc_nextStartOfMonthForDate:(NSDate*)date;
- (NSDate*)mgc_startOfYearForDate:(NSDate*)date;
- (NSUInteger)mgc_indexOfWeekInMonthForDate:(NSDate*)date;

- (BOOL)mgc_isDate:(NSDate*)date1 sameDayAsDate:(NSDate*)date2;
- (BOOL)mgc_isDate:(NSDate*)date1 sameMonthAsDate:(NSDate*)date2;

@end
