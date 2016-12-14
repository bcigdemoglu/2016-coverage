//
//  MGCDateRange.m
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//

#import "MGCDateRange.h"
#import "NSCalendar+MGCAdditions.h"

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, b) ((((NSUInteger)val) << b) | (((NSUInteger)val) >> (NSUINT_BIT - b)))


static NSDateFormatter *dateFormatter;

@interface MGCDateRange ()

@property (nonatomic, readonly) NSDateFormatter *dateFormatter;  // for debugging only

@end


@implementation MGCDateRange

- (void)checkIfValid
{
	NSAssert([self.start compare:self.end] != NSOrderedDescending, @"End date earlier than start date in DateRange object!");
}

+ (instancetype)dateRangeWithStart:(NSDate*)start end:(NSDate*)end
{
	return [[self alloc] initWithStart:start end:end];
}

- (instancetype)initWithStart:(NSDate*)start end:(NSDate*)end
{
	if (self = [super init]) {
		_start = [start copy];
		_end = [end copy];
	}
	
	[self checkIfValid];
	
	return self;
}

// for debugging
- (NSDateFormatter*)dateFormatter
{
	if (!dateFormatter) {
		dateFormatter = [NSDateFormatter new];
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		dateFormatter.timeStyle = NSDateFormatterMediumStyle;
	}
	return dateFormatter;
}

- (NSDateComponents*)components:(NSCalendarUnit)unitFlags forCalendar:(NSCalendar*)calendar
{
	[self checkIfValid];
	
	return [calendar components:unitFlags fromDate:self.start toDate:self.end options:0];
}

- (BOOL)containsDate:(NSDate*)date
{
	[self checkIfValid];
	
	return ([date compare:self.start] != NSOrderedAscending && [date compare:self.end] == NSOrderedAscending);
}

- (void)intersectDateRange:(MGCDateRange*)range
{
	[self checkIfValid];

	// range.end <= start || end <= range.start
    if ([range.end compare:self.start] != NSOrderedDescending || [self.end compare:range.start] != NSOrderedDescending) {
        self.end = self.start;
        return;
    }

	if ([self.start compare:range.start] == NSOrderedAscending) {
		self.start = range.start;
	}
	if ([range.end compare:self.end] == NSOrderedAscending) {
		self.end = range.end;
	}
}

- (BOOL)intersectsDateRange:(MGCDateRange*)range
{
	if ([range.end compare:self.start] != NSOrderedDescending || [self.end compare:range.start] != NSOrderedDescending)
		return NO;
	return YES;
}

- (BOOL)includesDateRange:(MGCDateRange*)range
{
	if ([range.start compare:self.start] == NSOrderedAscending || [self.end compare:range.end] == NSOrderedAscending)
		return NO;
	return YES;
}

- (void)unionDateRange:(MGCDateRange*)range
{
	[self checkIfValid];
	[range checkIfValid];
	
	self.start = [self.start earlierDate:range.start];
	self.end = [self.end laterDate:range.end];
}

- (void)enumerateDaysWithCalendar:(NSCalendar*)calendar usingBlock:(void (^)(NSDate *day, BOOL *stop))block
{
	NSDateComponents *comp = [NSDateComponents new];
	comp.day = 1;

	NSDate *date = self.start;
	BOOL stop = NO;
	
	while (!stop && [date compare:self.end] == NSOrderedAscending) {
		block(date, &stop);
		date = [calendar dateByAddingComponents:comp toDate:self.start options:0];
		comp.day++;
	}
}

- (BOOL)isEqualToDateRange:(MGCDateRange*)range
{
	return range && [range.start isEqualToDate:self.start] && [range.end isEqualToDate:self.end];
}

- (BOOL)isEmpty
{
    return [self.start isEqualToDate:self.end];
}

#pragma mark - NSObject

- (id)copyWithZone:(NSZone*)zone
{
    return [MGCDateRange dateRangeWithStart:self.start end:self.end];
}

- (BOOL)isEqual:(id)object
{
	if (self == object)
		return YES;
	
	if (![object isKindOfClass:[MGCDateRange class]])
		return NO;
	
	return [self isEqualToDateRange:(MGCDateRange*)object];
}

- (NSUInteger)hash
{
	return NSUINTROTATE([self.start hash], NSUINT_BIT / 2) ^ [self.end hash];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"[%@ - %@[", [self.dateFormatter stringFromDate:self.start], [self.dateFormatter stringFromDate:self.end]];
}

@end
