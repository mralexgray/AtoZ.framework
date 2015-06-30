

#import "NSString+AtoZEnums.h"
#import <objc/runtime.h>
#import <AtoZ/AtoZ.h>

_IMPL Text (ISP)
+ _Text_ ISP { return [AtoZ ISP]; }
_FINI


_IMPL AZEnum
//@synthesize name, ordinal; //- (void) dealloc	{    name = nil    [super dealloc];	}
- (void) encodeWithCoder:(NSCoder *)aCoder	{    
		
		[@[@"name", @"eProperties"] do:^(id o){ [aCoder encodeObject:[self vFK:o] forKey:o]; }]; 
		[aCoder encodeInt:_ordinal forKey:@"ordinal"]; 
}
- initWithCoder:(NSCoder *)aDecoder	{	if (self != [super initWithCoder:aDecoder] ) return nil;
	
	// see if the enum name exists - it should
	NSString *ename = [aDecoder decodeObjectForKey:@"name"];
	NSLog(@"%@...%@", NSStringFromSelector(_cmd), ename);
//	id cls = [self class];
	if ([self.class respondsToSelector:NSSelectorFromString(ename)]) {
//	    [self release];
	    return [[@"a".classProxy vFK:AZCLSSTR] performString:ename];
	}
	// no enum for this name, so treat as normal, which is the best we can hope for currently
	_name = ename;// retain];
	_eProperties = [aDecoder decodeObjectForKey:@"properties"];// retain];
	_ordinal = [aDecoder decodeIntForKey:@"ordinal"];
   return self;
}

- (id) initWithName: (NSString *) aname ordinal: (int) anordinal properties: (NSDictionary *) aproperties
{
	if (!(self = super.init)) return nil;
	_name = [aname copy];// retain];
	_ordinal = anordinal;
	_eProperties = [aproperties copy];// retain];
	return self;
}

- (id)copyWithZone:(NSZone *)zone;	{
    // we're immutable, just retain ourselves again
    return self;// retain];
}
+ enumFromName: (NSString *) nam	{

    SEL sel = NSSelectorFromString(nam);	
	 return [self respondsToSelector: sel] ? [self performSelector: sel] : nil;
}
+ enumFromOrdinal: (int) ordinal
{
    // find first enum that has the corresponding 
	return [self.allEnums filterOne:^BOOL(AZEnum *retval) {
		return  (retval.ordinal == ordinal);
	}] ?: nil;
}

- (NSString *) description	{	  return _name;		}
- (NSString *) debugDescription
{
    if (_eProperties.count) {
	return [NSString stringWithFormat: @"<%@:%@ %@=%d %@>",NSStringFromClass([self class]), self, _name, _ordinal, _eProperties];
    } else {
	return [NSString stringWithFormat: @"<%@:%@ %@=%d>",NSStringFromClass([self class]), self, _name, _ordinal];
    }
}
- (NSUInteger) hash
{
    return [_name hash]; // use the hash of the string, that way "if two objects are
    // equal (as determined by the isEqual: method) they must have the same hash value"
}
- _IsIt_ isEqual: x {
	return x == self ?: ISA(x,self.class) || ISA(self,[x class]) ? [_name isEqualToString:[x vFK:@"name"]] : NO;
}

#pragma mark Accessing
static NSInteger sortByOrdinal(id left, id right, void *ctx) { return [left ordinal] - [right ordinal]; }

static NSMutableDictionary *gAllEnums = nil;

+ (NSArray *) allEnums {    // use the class as a key for what enum list we want - it's expensive to build on the fly
    if (!gAllEnums) 	gAllEnums = NSMutableDictionary.new;
    NSMutableArray *retval = [gAllEnums objectForKey:self]; 
    if (retval)	return retval;
    retval = NSMutableArray.new;
    [gAllEnums setObject:retval forKey:(id)self];
    // walk the class methods 
    unsigned int methodCount = 0;
    Method *mlist = class_copyMethodList(object_getClass(self), &methodCount);
    for (unsigned int i=0;i<methodCount;i++) {
	NSString *mname = NSStringFromSelector(method_getName(mlist[i]));
	if ([[mname uppercaseString] isEqualToString:mname]) { // entirely in uppercase, it's an enum
	    [retval addObject:[self performSelector: method_getName(mlist[i])]]; // call it to retrieve the singleton
	}
    }
    if ([retval count]) { // there may be no enums yet
	[retval sortUsingFunction:sortByOrdinal context:nil];
	// set up the next/prev cached variables
	AZEnum *last = [retval lastObject];
	last->isLastEnum = YES;
	((AZEnum *)[retval objectAtIndex:0])->isFirstEnum = YES;
	for (AZEnum *e in retval) {
	    e->previousWrappingEnum = last;
	    last->nextWrappingEnum = e;
	    e->isCacheValid = YES;
	    last = e;
	}
    }
    free(mlist);
    return retval;
}
+ (void) invalidateEnumCache // if you've done dynamic code loading and added an enum through a category, call this
{
    for (AZEnum *e in [gAllEnums objectForKey:self]) 	e->isCacheValid = NO;
    [gAllEnums removeObjectForKey:self];
}
// note the use of id make these no longer type safe
+ firstEnum
{
    NSArray *allEnums = [self allEnums];
    if ([allEnums count])
	return [[self allEnums] objectAtIndex:0];
    return nil;
}
+ lastEnum	{    return self.allEnums.lastObject;	}
- (id) previousEnum
{
    if (!isCacheValid) { [[self class] allEnums]; } // update cache
    return isFirstEnum ? nil : previousWrappingEnum;
}
- (id) nextEnum	{

    if (!isCacheValid) { [[self class] allEnums]; } // update cache
    return isLastEnum ? nil : nextWrappingEnum;
}
- (id) previousWrappingEnum	{
    if (!isCacheValid) { [self.class allEnums]; } // update cache
    return previousWrappingEnum;
}
- (id) nextWrappingEnum
{
    if (!isCacheValid) { [self.class allEnums]; } // update cache
    return nextWrappingEnum;
}
- (id) deltaEnum: (NSInteger) delta wrapping: (BOOL) wrapping
{
    NSArray *allEnums = self.class.allEnums;
    NSInteger index = [allEnums indexOfObject:self];
//    NSAssert1(index != NSNotFound, @"%@ does not exist in own classes list of enums", self);
    if (index == NSNotFound)
	return nil;
    index += delta;
    int count = [allEnums count];
    if (wrapping) {
	while (index < 0)
	    index += count;
	while (index >= count)
	    index -= count;
    } else {
	if (index <0 || index >= count)
	    return nil;
    }
    return [allEnums objectAtIndex:index];
}

#pragma mark dynamic ivar support
- (id)valueForUndefinedKey:(NSString *)key	{	return _eProperties[key];	}

// to speed this code up, should create a map from SEL to NSString mapping selectors to their keys.

// converts a getter selector to an NSString, equivalent to NSStringFromSelector().
NS_INLINE NSString *getterKey(SEL sel) {    return [NSString stringWithUTF8String:sel_getName(sel)];	}
// Generic accessor methods for property types id, double, and NSRect.
static id getProperty(AZEnum *self, SEL name) {    return [self->_eProperties objectForKey:getterKey(name)];	}
static __unused SEL getSelProperty(AZEnum *self, SEL name) {    return NSSelectorFromString([self->_eProperties objectForKey:getterKey(name)]);	}
#define TYPEDGETTER(type,Type,typeValue) static type get ## Type ## Property(AZEnum *self, SEL name) { return [[self->_eProperties objectForKey:getterKey(name)] typeValue];	}
TYPEDGETTER(double, Double, doubleValue)
TYPEDGETTER(float, Float, floatValue)
TYPEDGETTER(char, Char, charValue)
TYPEDGETTER(unsigned char, UnsignedChar, unsignedCharValue)
TYPEDGETTER(short, Short, shortValue)
TYPEDGETTER(unsigned short, UnsignedShort, unsignedShortValue)
TYPEDGETTER(int, Int, intValue)
TYPEDGETTER(unsigned int, UnsignedInt, unsignedIntValue)
TYPEDGETTER(long, Long, longValue)
TYPEDGETTER(unsigned long, UnsignedLong, unsignedLongValue)
TYPEDGETTER(long long, LongLong, longLongValue)
TYPEDGETTER(unsigned long long, UnsignedLongLong, unsignedLongLongValue)
TYPEDGETTER(BOOL, Bool, boolValue)
TYPEDGETTER(void *, Pointer, pointerValue)
//#ifdef UIKIT_EXTERN
#if TARGET_OS_IPHONE
static CGRect getCGRectProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGRectValue];
}
static CGPoint getCGPointProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGPointValue];
}
static CGSize getCGSizeProperty(GandEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGSizeValue];
}
#endif
//#ifdef NSKIT_EXTERN
static NSRect getNSRectProperty(AZEnum *self, SEL name) 		{ return [[self->_eProperties objectForKey:getterKey(name)] rectValue];	}
static NSPoint getNSPointProperty(AZEnum *self, SEL name) 	{ return [[self->_eProperties objectForKey:getterKey(name)] pointValue];	}
static NSSize getNSSizeProperty(AZEnum *self, SEL name) 		{ return [[self->_eProperties objectForKey:getterKey(name)] sizeValue];	}
//#endif

static const char* getPropertyType(objc_property_t property) {
    // parse the property attribues. this is a comma delimited string. the type of the attribute starts with the
    // character 'T' should really just use strsep for this, using a C99 variable sized array.
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            // return a pointer scoped to the autorelease pool. Under GC, this will be a separate block.
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute)] bytes];
        }
    }
    return "@";
}

static BOOL getPropertyInfo(Class cls, NSString *propertyName, Class *propertyClass, const char* *propertyType) {
    const char *name = [propertyName UTF8String];
    while (cls != NULL) {
        objc_property_t property = class_getProperty(cls, name);
        if (property) {
            *propertyClass = cls;
            *propertyType = getPropertyType(property);
            return YES;
        }
        cls = class_getSuperclass(cls);
    }
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)name {
    Class propertyClass;
    const char *propertyType;
    IMP accessor = NULL;
    const char *signature = NULL;
    // TODO:  handle more property types.
    if (strncmp("set", sel_getName(name), 3) == 0) {
        // choose an appropriately typed generic setter function. - we have no setters, enum properties are read only
    } else {
        // choose an appropriately typed getter function.
        if (getPropertyInfo(self, getterKey(name), &propertyClass, &propertyType)) {
            switch (propertyType[0]) {
		case _C_ID:
		    accessor = (IMP)getProperty, signature = "@@:"; break;
		case _C_CLASS:
		    accessor = (IMP)getProperty, signature = "#@:"; break;
		case _C_CHR:
		    accessor = (IMP)getCharProperty, signature = "c@:"; break;
		case _C_UCHR:
		    accessor = (IMP)getUnsignedCharProperty, signature = "C@:"; break;
		case _C_SHT:
		    accessor = (IMP)getShortProperty, signature = "s@:"; break;
		case _C_USHT:
		    accessor = (IMP)getUnsignedShortProperty, signature = "S@:"; break;
		case _C_INT:
		    accessor = (IMP)getIntProperty, signature = "i@:"; break;
		case _C_UINT:
		    accessor = (IMP)getUnsignedIntProperty, signature = "I@:"; break;
		case _C_LNG:
		    accessor = (IMP)getLongProperty, signature = "l@:"; break;
		case _C_ULNG:
		    accessor = (IMP)getUnsignedLongProperty, signature = "L@:"; break;
		case _C_LNG_LNG:
		    accessor = (IMP)getLongLongProperty, signature = "q@:"; break;
		case _C_ULNG_LNG:
		    accessor = (IMP)getUnsignedLongLongProperty, signature = "Q@:"; break;
		case _C_BOOL:
		    accessor = (IMP)getBoolProperty, signature = "B@:"; break;
		case _C_DBL:
		    accessor = (IMP)getDoubleProperty, signature = "d@:"; break;
		case _C_FLT:
		    accessor = (IMP)getFloatProperty, signature = "f@:"; break;
		case _C_PTR:
		    accessor = (IMP)getPointerProperty, signature = "^@:"; break;
		case _C_CHARPTR:
		    accessor = (IMP)getPointerProperty, signature = "*@:"; break;
		case _C_STRUCT_B:
//#ifdef UIKIT_EXTERN/
#ifndef TARGET_OS_MAC
		    if (strncmp(propertyType, "{_CGRect=", 9) == 0)
			accessor = (IMP)getCGRectProperty, signature = "{_CGRect}@:";
		    if (strncmp(propertyType, "{_CGPoint=", 10) == 0)
			accessor = (IMP)getCGPointProperty, signature = "{_CGPoint}@:";
		    if (strncmp(propertyType, "{_CGSize=", 9) == 0)
			accessor = (IMP)getCGSizeProperty, signature = "{_CGSize}@:";
#endif
//#ifdef NSKIT_EXTERN
		    if (strncmp(propertyType, "{_NSRect=", 9) == 0)
			accessor = (IMP)getNSRectProperty, signature = "{_NSRect}@:";
		    if (strncmp(propertyType, "{_NSPoint=", 10) == 0)
			accessor = (IMP)getNSPointProperty, signature = "{_NSPoint}@:";
		    if (strncmp(propertyType, "{_NSSize=", 9) == 0)
			accessor = (IMP)getNSSizeProperty, signature = "{_NSSize}@:";
//#endif
		    break;
            }
        }
    }
    if (accessor && signature) {
        class_addMethod(propertyClass, name, accessor, signature);
        return YES;
    }
    return NO;
}

@end


/*
@implementation AZEnum

- (void) encodeWithCoder:(NSCoder*)aCoder		{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_properties forKey:@"properties"];
    [aCoder encodeInt:_ordinal forKey:@"ordinal"];
}
- initWithCoder: (NSCoder*)aDecoder		{
	if (!(self = super.init)) return nil;
	// see if the enum name exists - it should
	NSS *ename 	= [aDecoder decodeObjectForKey:@"name"];
	SEL sel 		= NSSelectorFromString(ename);
	id cls 		= self.class;
	if ([cls respondsToSelector:sel]) {
	    [self release];
	    return [cls performSelectorWithoutWarnings:sel];
	}
	// no enum for this name, so treat as normal, which is the best we can hope for currently
	_name 			= ename;// retain];
	_properties 	= [aDecoder decodeObjectForKey:@"properties"];// retain];
	_ordinal 		= [aDecoder decodeIntForKey:@"ordinal"];
	return self;
}
- (id) initWithName:(NSS*)n ordinal:(int)o properties:(NSD*)props	{
   if (	self != [super init] ) return nil;
	_name 		= n;
	_ordinal 	= o;
	_properties = props;
    return self;
}
- (id) copyWithZone:(NSZone *)zone				{
    // we're immutable, just retain ourselves again
    return self;// retain];
}
+ enumFromName: (NSS *) nam			{
    SEL sel = NSSelectorFromString(nam);
    return [self respondsToSelector: sel] ? [self performSelector: sel] : nil;
}
+ enumFromOrdinal: (int) ordinal			{
    // find first enum that has the corresponding ordinal
   return [self.allEnums filterOne:^BOOL(AZEnum *retval) {
		return retval.ordinal == ordinal;
	}] ?: nil;
}
- (NSS *) description							{	return self.name; }
- (NSS *) debugDescription					{

//	return (self.propertyNames.count) 
//	?	$( @"<%@:%@ %@=%d %@>",AZCLSSTR, self, self.name, self.ordinal, self.properties):
return $( @"<%@:%@ %@=%d>",AZCLSSTR, self, self.name, self.ordinal);
}
- (NSUInteger) hash									{
    return [self.name hash]; // use the hash of the string, that way "if two objects are
    // equal (as determined by the isEqual: method) they must have the same hash value"
}
- _IsIt_ isEqual: (id) other						{
    if (other == self) return YES;
	return [other ISKINDA:self.class] || [self ISKINDA:[other class]] 
	?	SameString(self.name, [other vFK:@"name"]) : NO;
}
#pragma mark Accessing
static NSInteger sortByOrdinal(id left, id right, void *ctx)		{
    return [left ordinal] - [right ordinal];
}
static NSMutableDictionary *gAllEnums = nil;
+ (NSArray *) allEnums															{
   // use the class as a key for what enum list we want - it's expensive to build on the fly
   if (!gAllEnums) gAllEnums = NSMutableDictionary.new;
   NSMutableArray *retval = [gAllEnums objectForKey:self]; 
   if (retval)	return retval;
   retval = NSMutableArray.new;
   [gAllEnums setObject:retval forKey:NSStringFromClass(self.class)];
   // walk the class methods 
   unsigned int methodCount = 0;
   Method *mlist = class_copyMethodList(object_getClass(self), &methodCount);
	for (unsigned int i=0;i<methodCount;i++) {
		NSS *mname = NSStringFromSelector(method_getName(mlist[i]));
		if ([[mname uppercaseString] isEqualToString:mname]) // entirely in uppercase, it's an enum
			 [retval addObject:[self performSelector: method_getName(mlist[i])]]; // call it to retrieve the singleton
   }
   if ([retval count]) { // there may be no enums yet
		[retval sortUsingFunction:sortByOrdinal context:nil];
		// set up the next/prev cached variables
		AZEnum *last = [retval lastObject];
		last->_isLastEnum = YES;
		((AZEnum *)[retval objectAtIndex:0])->_isFirstEnum = YES;
		for (AZEnum *e in retval) {
			 e->_previousWrappingEnum = last;
			 last->_nextWrappingEnum = e;
			 e->_isCacheValid = YES;
			 last = e;
		}
	}
    free(mlist);
    return retval;
}
+ (void) invalidateEnumCache // if you've done dynamic code loading and added an enum through a category, call this
{
    for (AZEnum *e in [gAllEnums objectForKey:self]) 	e->_isCacheValid = NO;
    [gAllEnums removeObjectForKey:self];
}
// note the use of id make these no longer type safe
+ firstEnum		{
   
	NSArray *allEnums = [self allEnums];
	return allEnums.count ? self.allEnums[0] : nil;
}
+ lastEnum		{    return self.allEnums.lastObject;	}
- (id) previousEnum	{

    if (!_isCacheValid) { self.class.allEnums; } // update cache
    return _isFirstEnum ? nil : _previousWrappingEnum;
}
- (id) nextEnum		{
    if (!_isCacheValid) { self.class.allEnums; } // update cache
    return _isLastEnum ? nil : _nextWrappingEnum;
}
- (id) previousWrappingEnum	{
    if (!_isCacheValid) {	self.class.allEnums; } // update cache
    return _previousWrappingEnum;
}
- (id) nextWrappingEnum			{
    if (!_isCacheValid) { self.class.allEnums; } // update cache
    return _nextWrappingEnum;
}
- (id) deltaEnum: (NSInteger) delta wrapping: (BOOL) wrapping
{
    NSArray *allEnums = self.class.allEnums;
    NSInteger index = [allEnums indexOfObject:self];
//    NSAssert1(index != NSNotFound, @"%@ does not exist in own classes list of enums", self);
    if (index == NSNotFound)
	return nil;
    index += delta;
    int count = [allEnums count];
    if (wrapping) {
	while (index < 0)
	    index += count;
	while (index >= count)
	    index -= count;
    } else {
	if (index <0 || index >= count)
	    return nil;
    }
    return [allEnums objectAtIndex:index];
}

#pragma mark dynamic ivar support
- (id)valueForUndefinedKey:(NSS*) key	{	return self.properties[key];	}
// to speed this code up, should create a map from SEL to NSString mapping selectors to their keys.
// converts a getter selector to an NSString, equivalent to NSStringFromSelector().
NS_INLINE NSS *getterKey(SEL sel) {
    return $UTF8(sel_getName(sel));
}

// Generic accessor methods for property types id, double, and NSRect.
static id getProperty(AZEnum *self, SEL name) {
    return [self->_properties objectForKey:getterKey(name)];
}
static SEL getSelProperty(AZEnum *self, SEL name) {
    return NSSelectorFromString([self->_properties objectForKey:getterKey(name)]);
}
#define TYPEDGETTER(type,Type,typeValue) \
static type get ## Type ## Property(AZEnum *self, SEL name) {\
    return [[self->_properties objectForKey:getterKey(name)] typeValue];\
}
TYPEDGETTER(double, Double, doubleValue)
TYPEDGETTER(float, Float, floatValue)
TYPEDGETTER(char, Char, charValue)
TYPEDGETTER(unsigned char, UnsignedChar, unsignedCharValue)
TYPEDGETTER(short, Short, shortValue)
TYPEDGETTER(unsigned short, UnsignedShort, unsignedShortValue)
TYPEDGETTER(int, Int, intValue)
TYPEDGETTER(unsigned int, UnsignedInt, unsignedIntValue)
TYPEDGETTER(long, Long, longValue)
TYPEDGETTER(unsigned long, UnsignedLong, unsignedLongValue)
TYPEDGETTER(long long, LongLong, longLongValue)
TYPEDGETTER(unsigned long long, UnsignedLongLong, unsignedLongLongValue)
TYPEDGETTER(BOOL, Bool, boolValue)
TYPEDGETTER(void *, Pointer, pointerValue)
#ifdef UIKIT_EXTERN
static CGRect getCGRectProperty(AZEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGRectValue];
}
static CGPoint getCGPointProperty(AZEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGPointValue];
}
static CGSize getCGSizeProperty(AZEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] CGSizeValue];
}
#endif
#ifdef NSKIT_EXTERN
static NSRect getNSRectProperty(AZEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] rectValue];
}
static NSPoint getNSPointProperty(AZEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] pointValue];
}
static NSSize getNSSizeProperty(AZEnum *self, SEL name) {
    return [[self->properties objectForKey:getterKey(name)] sizeValue];
}
#endif

static const char* getPropertyType(objc_property_t property) {
    // parse the property attribues. this is a comma delimited string. the type of the attribute starts with the
    // character 'T' should really just use strsep for this, using a C99 variable sized array.
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            // return a pointer scoped to the autorelease pool. Under GC, this will be a separate block.
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute)] bytes];
        }
    }
    return "@";
}

static BOOL getPropertyInfo(Class cls, NSS *propertyName, Class *propertyClass, const char* *propertyType) {
    const char *name = [propertyName UTF8String];
    while (cls != NULL) {
        objc_property_t property = class_getProperty(cls, name);
        if (property) {
            *propertyClass = cls;
            *propertyType = getPropertyType(property);
            return YES;
        }
        cls = class_getSuperclass(cls);
    }
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)name {
    Class propertyClass;
    const char *propertyType;
    IMP accessor = NULL;
    const char *signature = NULL;
    // TODO:  handle more property types.
    if (strncmp("set", sel_getName(name), 3) == 0) {
        // choose an appropriately typed generic setter function. - we have no setters, enum properties are read only
    } else {
        // choose an appropriately typed getter function.
        if (getPropertyInfo(self, getterKey(name), &propertyClass, &propertyType)) {
            switch (propertyType[0]) {
		case _C_ID:
		    accessor = (IMP)getProperty, signature = "@@:"; break;
		case _C_CLASS:
		    accessor = (IMP)getProperty, signature = "#@:"; break;
		case _C_CHR:
		    accessor = (IMP)getCharProperty, signature = "c@:"; break;
		case _C_UCHR:
		    accessor = (IMP)getUnsignedCharProperty, signature = "C@:"; break;
		case _C_SHT:
		    accessor = (IMP)getShortProperty, signature = "s@:"; break;
		case _C_USHT:
		    accessor = (IMP)getUnsignedShortProperty, signature = "S@:"; break;
		case _C_INT:
		    accessor = (IMP)getIntProperty, signature = "i@:"; break;
		case _C_UINT:
		    accessor = (IMP)getUnsignedIntProperty, signature = "I@:"; break;
		case _C_LNG:
		    accessor = (IMP)getLongProperty, signature = "l@:"; break;
		case _C_ULNG:
		    accessor = (IMP)getUnsignedLongProperty, signature = "L@:"; break;
		case _C_LNG_LNG:
		    accessor = (IMP)getLongLongProperty, signature = "q@:"; break;
		case _C_ULNG_LNG:
		    accessor = (IMP)getUnsignedLongLongProperty, signature = "Q@:"; break;
		case _C_BOOL:
		    accessor = (IMP)getBoolProperty, signature = "B@:"; break;
		case _C_DBL:
		    accessor = (IMP)getDoubleProperty, signature = "d@:"; break;
		case _C_FLT:
		    accessor = (IMP)getFloatProperty, signature = "f@:"; break;
		case _C_PTR:
		    accessor = (IMP)getPointerProperty, signature = "^@:"; break;
		case _C_CHARPTR:
		    accessor = (IMP)getPointerProperty, signature = "*@:"; break;
		case _C_STRUCT_B:
#ifdef UIKIT_EXTERN
		    if (strncmp(propertyType, "{_CGRect=", 9) == 0)
			accessor = (IMP)getCGRectProperty, signature = "{_CGRect}@:";
		    if (strncmp(propertyType, "{_CGPoint=", 10) == 0)
			accessor = (IMP)getCGPointProperty, signature = "{_CGPoint}@:";
		    if (strncmp(propertyType, "{_CGSize=", 9) == 0)
			accessor = (IMP)getCGSizeProperty, signature = "{_CGSize}@:";
#endif
#ifdef NSKIT_EXTERN
		    if (strncmp(propertyType, "{_NSRect=", 9) == 0)
			accessor = (IMP)getNSRectProperty, signature = "{_NSRect}@:";
		    if (strncmp(propertyType, "{_NSPoint=", 10) == 0)
			accessor = (IMP)getNSPointProperty, signature = "{_NSPoint}@:";
		    if (strncmp(propertyType, "{_NSSize=", 9) == 0)
			accessor = (IMP)getNSSizeProperty, signature = "{_NSSize}@:";
#endif
		    break;
            }
        }
    }
    if (accessor && signature) {
        class_addMethod(propertyClass, name, accessor, signature);
        return YES;
    }
    return NO;
}

@end


@implementation NSString (AtoZEnums)


+ (NSD*) enumDictionary;
{

	return @{@"AZWindowPosition":
				@[@"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic"]};

}

+ (NSS*) eType:(NSS*)type v:(int)value {
	

}
- (int) enumValue { return  9; }

@end

*/
