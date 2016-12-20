//
//  MGCReusableObjectQueue.m
//  Graphical Calendars Library for iOS
//
//  Distributed under the MIT License
//  Get the latest version from here:
//

#import "MGCReusableObjectQueue.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Constant.h"

@interface MGCReusableObjectQueue ()

@property (nonatomic) NSMutableDictionary *reusableObjectsSets;
@property (nonatomic) NSMutableDictionary *objectClasses;
@property (nonatomic, readwrite) NSUInteger totalCreated;

@end


@implementation MGCReusableObjectQueue


- (instancetype)init
{
	if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		_reusableObjectsSets = [NSMutableDictionary new];
		_objectClasses = [NSMutableDictionary new];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (instancetype)defaultQueue
{
    static MGCReusableObjectQueue *queue;
    static dispatch_once_t onceToken;
	
    dispatch_once(&onceToken, ^{
        queue = [MGCReusableObjectQueue new];
    });
    
	return queue;
}

- (NSUInteger)count
{
	NSUInteger count = 0;
	for (NSString *identifier in self.reusableObjectsSets) {
		NSMutableSet *set = [self.reusableObjectsSets objectForKey:identifier];
		count += set.count;
	}
	return count;
}

- (void)registerClass:(Class)objectClass forObjectWithReuseIdentifier:(NSString*)identifier
{
    if (objectClass) {
        NSMutableSet *set = [self.reusableObjectsSets objectForKey:identifier];
		if (!set) {
			set = [NSMutableSet set];
			[self.reusableObjectsSets setObject:set forKey:identifier];
			[self.objectClasses setObject:NSStringFromClass(objectClass) forKey:identifier];
		}
    }
	else {
        [self.objectClasses removeObjectForKey:identifier];
		[self.reusableObjectsSets removeObjectForKey:identifier];
    }
}

- (void)enqueueReusableObject:(id<MGCReusableObject>)object
{
	[[self.reusableObjectsSets objectForKey:object.reuseIdentifier]addObject:object];
}

- (id<MGCReusableObject>)dequeueReusableObjectWithReuseIdentifier:(NSString *)identifier
{
    id<MGCReusableObject> object = [[self.reusableObjectsSets objectForKey:identifier] anyObject];
    if (object) {
		[[self.reusableObjectsSets objectForKey:identifier] removeObject:object];
		if ([object respondsToSelector:@selector(prepareForReuse)]) {
			[object prepareForReuse];
		}
	}
	else {
        object = [self newObjectWithReuseIdentifier:identifier];
        if (!object) {
            [NSException raise:@"Reuse queue exception" format:@"No class was registered for identifier %@", identifier];
        }
		self.totalCreated++;
    }
    
    return object;
}

- (id<MGCReusableObject>)newObjectWithReuseIdentifier:(NSString*)identifier
{
    NSString *class = [self.objectClasses objectForKey:identifier];
    if (class) {
        Class objectClass = NSClassFromString(class);
        id object = [[objectClass alloc]init];
        [object setReuseIdentifier:identifier];
		return object;
	}
	
	return nil;
}

- (void)removeAllObjects
{
    [self.reusableObjectsSets removeAllObjects];
}


@end
