//
//  SampleObject.m
//  CoreAnimationListView
//
//  Created by Patrick Geiller on 07/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AZObject.h"
#import <objc/runtime.h>
@interface  AZObject ()
+ (void)setLastModifiedKey:(NSString*)key forInstance:(id)object;
@end

NSString *const AZObjectSharedInstanceUpdatedNotification = @"AZObjectSharedInstanceUpdatedNotification";

@implementation AZObject

+ (instancetype)instance
{
    return AH_AUTORELEASE([[self alloc] init]);
}

static BOOL loadingFromResourceFile = NO;

+ (instancetype)instanceWithObject:(id)object
{
		//return nil if object is nil
    return object? AH_AUTORELEASE([[self alloc] initWithObject:object]): nil;
}
- (NSString *)setterNameForClass:(Class)class
{
		//get class name
    NSString *className = NSStringFromClass(class);

		//strip NS prefix
    if ([className hasPrefix:@"NS"])
		{
        className = [className substringFromIndex:2];
		}

		//return setter name
    return [NSString stringWithFormat:@"setWith%@:", className];
}
- (instancetype)initWithObject:(id)object
{
    if ((self = [self init]))
		{
        Class class = [object class];
        while (true)
			{
            SEL setter = NSSelectorFromString([self setterNameForClass:class]);
            if ([self respondsToSelector:setter])
				{
                objc_msgSend(self, setter, object);
                return self;
				}
            if ([class superclass] == [NSObject class]) break;
            class = [class superclass];
			}
        [NSException raise:NSGenericException
                    format:@"%@ not implemented", [self setterNameForClass:class]];
		}
    return self;
}
+ (NSArray *)instancesWithArray:(NSArray *)array
{
	return [array map:^id(id obj) { return [self instanceWithObject:obj]; }];
}
+ (instancetype)instanceWithCoder:(NSCoder *)decoder     //return nil if coder is nil
{
    return decoder ? AH_AUTORELEASE([[self alloc] initWithCoder:decoder]) : nil;
}
//- (instancetype)initWithCoder:(NSCoder *)decoder
//{
//	if (YES) {
//		self = [super init];
//		if (self) {
//			for (NSString *name in [self allKeys])
//				[self setValue:[decoder decodeObjectForKey:name] forKey:name];
//		}
//			//		return self;
//	}
//	else {

			//([self respondsToSelector:@selector(enumerateIvarsUsingBlock:)]) {
			//    	if (self = [super init]) {
			//			[self enumerateIvarsUsingBlock:^(Ivar var, NSString *name, BOOL *cancel) {
			//				[self setValue:[decoder decodeObjectForKey:name] forKey:name];
			//			}];
			//		}
//		if ((self = [self init]))
//			[self respondsToSelector:@selector(setWithCoder:)]
//			?  	[self setWithCoder:decoder]
//			:   [NSException raise:NSGenericException format:@"setWithCoder: not implemented"];

//	}
//	return self;
//
//}

//@synthesize name, description, color;

//- (id)init
//{
//	if (![super init])	return nil;
//	self.name		= @"Sample";
//	self.description = @"description";
//	self.color		= [NSColor blueColor];
//	return	self;
//}
/*
	Key Value Bastard Observing (KVBO) is everything below.
	We overload setValue:forKey: to listen to all changes.
	We save self and the key name to static variables with the class method setLastModifiedKey:forInstance:
	setValue:forKey: then sets a new value for a dummy key (keyChanged) on a shared instance (a singleton for the observed class, here SampleObject).
	Changing this dummy key's value dispatches KVO notifications of our shared instance :any observer of that shared instance will receive all notifications of all changes of all instances of SampleObject.
	
	To receive KVBO notifications, register as an observer on the shared instance's dummy key.
	You'll need to setup a dummy key, its set method will be the notification recipient of KVBO.

		[myObserver bind:@"myKey" toObject:[SampleObject sharedInstance] withKeyPath:@"keyChanged" options:nil];
		
	myObserver's setMyKey will then be called for each change of any attribute of any instance.
*/
- (id)objectForKeyedSubscript:(NSString *)key
{
	return [self valueForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key
{
	if (isEmpty(object)) [self setValue:@"" forKey:key];
	else [self setValue:object forKey:key];
}

// setValue:forKey: overload to dispatch change notification to our shared instance
- (void)setValue:(id)value forKey:(NSString*)key
{
	[super setValue:value forKey:key];
	// If this is the shared instance, don't go any further
	if (self == [AZObject sharedInstance])	return;
	// Class method - set last modified
	[AZObject setLastModifiedKey:key forInstance:self];
	// Instance method - dummy setValue to dispatch notifications
	[[AZObject sharedInstance] setValue:self forKey:@"keyChanged"];
}

// sharedInstance

#pragma mark -
#pragma mark Singleton behaviour
static NSMutableDictionary *sharedInstances = nil;
+ (void)setSharedInstance:(AZObject *)instance
{
    if (![instance isKindOfClass:self])
		{
        [NSException raise:NSGenericException format:@"setSharedInstance: instance class does not match"];
		}
    sharedInstances = sharedInstances ?: [[NSMutableDictionary alloc] init];
    id oldInstance = sharedInstances[NSStringFromClass(self)];
    sharedInstances[NSStringFromClass(self)] = instance;
    if (oldInstance)
		{
        [[NSNotificationCenter defaultCenter] postNotificationName:AZObjectSharedInstanceUpdatedNotification object:oldInstance];
		}
}
+ (BOOL)hasSharedInstance
{
    return sharedInstances[NSStringFromClass(self)] != nil;
}
+ (instancetype)sharedInstance
{
    sharedInstances = sharedInstances ?: [[NSMutableDictionary alloc] init];
    id instance = sharedInstances[NSStringFromClass(self)];
    if (instance == nil)
		{
			//load or create instance
        [self reloadSharedInstance];

			//get loaded instance
        instance = sharedInstances[NSStringFromClass(self)];
		}
    return instance;
}
+ (void)reloadSharedInstance
{
    id instance = nil;
	instance = [[[self class]alloc]init];
	//set singleton
    [self setSharedInstance:instance];
}
+ (NSString *)resourceFile
{
		//used for every instance
    return [NSStringFromClass(self) stringByAppendingPathExtension:@"plist"];
}
+ (NSString *)saveFile
{
		//used to save shared (singleton) instance
    return [NSStringFromClass(self) stringByAppendingPathExtension:@"plist"];
}
//	returns our the singleton instance that will be used for global observing
//+ (AZObject*)sharedInstance
//{
//	static AZObject* singleton;
//	@synchronized(self)
//	singleton = singleton  ? singleton : [[AZObject alloc] init];
//	return singleton;
//}
// class methods for last modified key and instance - these are held as static data

static AZObject* lastModifiedInstance;
static NSString* lastModifiedKey;

+ (void)setLastModifiedKey:(NSString*)key forInstance:(id)object
{
	lastModifiedKey			= key;
	lastModifiedInstance	= object;
}
+ (AZObject*)lastModifiedInstance	{	return lastModifiedInstance;	}
+ (NSString*)lastModifiedKey			{	return lastModifiedKey;			}

// keyChanged - dummy key set by setValue:forKey: on our shared instance, used to dispatch KVO notifications
- (AZObject*)keyChanged	{	return [AZObject sharedInstance];	}

- (void)setKeyChanged:(AZObject*)sampleObject	{}

// Holds metadata for subclasses of SMModelObject
static NSMutableDictionary *keyNames = nil, *nillableKeyNames = nil;
// Before this class is first accessed, we'll need to build up our associated metadata, basically
// just a list of all our property names so we can quickly enumerate through them for various methods.
// Also we maintain a separate list of property names that can be set to nil (type ID) for fast dealloc.
+ (void) initialize {

	keyNames = keyNames ? [NSMutableDictionary new] : keyNames, nillableKeyNames = [NSMutableDictionary new];
	NSMutableArray *names = [NSMutableArray new], *nillableNames = [NSMutableArray new];

	for (Class cls = self; cls != [AZObject class]; cls = [cls superclass]) {
		unsigned int varCount;
		Ivar *vars = class_copyIvarList(cls, &varCount);
		for (int i = 0; i < varCount; i++) {
			Ivar var = vars[i];
			NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(var)];
			[names addObject:name];
			if (ivar_getTypeEncoding(var)[0] == _C_ID) [nillableNames addObject:name];
			[name release];
		}
		free(vars);
	}
	keyNames[(id)self] = names;
	nillableKeyNames[(id)self] = nillableNames;
	[names release], [nillableNames release];
}

- (NSArray *)allKeys {	return keyNames[[self class]];	}

- (NSArray *)nillableKeys {	return nillableKeyNames[[self class]];	}

// NSCoder implementation, for unarchiving
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
		for (NSString *name in [self allKeys]) [self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
	}
	return self;
}

	// NSCoder implementation, for archiving
- (void) encodeWithCoder:(NSCoder *)aCoder {
	for (NSString *name in [self allKeys]) [aCoder encodeObject:[self valueForKey:name] forKey:name];
}

// Automatic dealloc.
- (void) dealloc {
	for (NSString *name in [self nillableKeys]) [self setValue:nil forKey:name];
	[super dealloc];
}

	// NSCopying implementation
- (id) copyWithZone:(NSZone *)zone
{
	id copied = [[[self class] alloc] init];
	for (NSString *name in [self allKeys]) [copied setValue:[self valueForKey:name] forKey:name];
	return copied;
}

// We implement the NSFastEnumeration protocol to behave like an NSDictionary - the enumerated values are our property (key) names.
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
								  objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
	return [[self allKeys] countByEnumeratingWithState:state objects:buffer count:len];
}

//- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {  return [[self allKeys] countByEnumeratingWithState:state objects:stackbuf count:len]; }

	// Override isEqual to compare model objects by value instead of just by pointer.
- (BOOL) isEqual:(id)other {

	if ([other isKindOfClass:[self class]]) {

		for (NSString *name in [self allKeys]) {
			id a = [self valueForKey:name];
			id b = [other valueForKey:name];

				// extra check so a == b == nil is considered equal
			if ((a || b) && ![a isEqual:b])
				return NO;
		}

		return YES;
	}
	else return NO;
}

	// Must override hash as well, this is taken directly from RMModelObject, basically
	// classes with the same layout return the same number.
- (NSUInteger)hash {
	return (NSUInteger)[self allKeys];
}

- (void)writeLineBreakToString:(NSMutableString *)string withTabs:(NSUInteger)tabCount {
	[string appendString:@"\n"];
	for (int i=0;i<tabCount;i++) [string appendString:@"\t"];
}

	// Prints description in a nicely-formatted and indented manner.
- (void) writeToDescription:(NSMutableString *)description withIndent:(NSUInteger)indent {

	[description appendFormat:@"<%@ %p", NSStringFromClass([self class]), self];

	for (NSString *name in [self allKeys]) {

		[self writeLineBreakToString:description withTabs:indent];

		id object = [self valueForKey:name];

		if ([object isKindOfClass:[AZObject class]]) {
			[object writeToDescription:description withIndent:indent+1];
		}
		else if ([object isKindOfClass:[NSArray class]]) {

			[description appendFormat:@"%@ =", name];

			for (id child in object) {
				[self writeLineBreakToString:description withTabs:indent+1];

				if ([child isKindOfClass:[AZObject class]])
					[child writeToDescription:description withIndent:indent+2];
				else
					[description appendString:[child description]];
			}
		}
		else if ([object isKindOfClass:[NSDictionary class]]) {

			[description appendFormat:@"%@ =", name];

			for (id key in object) {
				[self writeLineBreakToString:description withTabs:indent];
				[description appendFormat:@"\t%@ = ",key];

				id child = object[key];

				if ([child isKindOfClass:[AZObject class]])
					[child writeToDescription:description withIndent:indent+2];
				else
					[description appendString:[child description]];
			}
		}
		else {
			[description appendFormat:@"%@ = %@", name, object];
		}
	}

	[description appendString:@">"];
}

	// Override description for helpful debugging.
- (NSString *) description {
	NSMutableString *description = [NSMutableString string];
	[self writeToDescription:description withIndent:1];
	return description;
}
#pragma mark -Unique identifier generation
+ (NSString *)newUniqueIdentifier
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return AH_RETAIN(CFBridgingRelease(identifier));
}

- (NSString *)uniqueID {    return _uniqueID  = _uniqueID ? _uniqueID :[[self class] newUniqueIdentifier]; }

@end
