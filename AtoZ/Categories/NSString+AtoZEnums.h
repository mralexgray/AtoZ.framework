
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface AZEnum : NSObject<NSCopying, NSCoding> {  //    NSString *name;     int ordinal;
    // cached to speed up prev/next - these are all "assign", not that it matters because they are all singletons 
    id previousWrappingEnum;
    id nextWrappingEnum;
    BOOL isFirstEnum, isLastEnum, isCacheValid;
}
@property NSDictionary *eProperties;
@property (nonatomic) NSString *name;
@property (nonatomic) int ordinal;

+ enumFromName: (NSString *) name;
+ enumFromOrdinal: (int) ordinal;
+ (NSArray *) allEnums;

// note the use of id make these no longer type safe
+ firstEnum;
+ lastEnum;
@property (readonly) id previousEnum, nextEnum, previousWrappingEnum, nextWrappingEnum;
- (id) deltaEnum: (NSInteger) delta wrapping: (BOOL) wrapping;
// this should only be called from with the enum declaration methods
- (id) initWithName: (NSString *) name ordinal: (int) ordinal properties: (NSDictionary *) properties;
+ (void) invalidateEnumCache; // if you've done dynamic code loading and added an enum through a category, call this for each enum class modified
@end

// Macro to declare the enum implementation.  The name and ordinal value are the first two parameters, what follows is then a list of objects and keys for additional properties
// This list is used for +[NSDictionary  dictionaryWithObjectsAndKeys:]  - note that you do not need to specify a nil at the end (it is added automatically)
// These properties will be dynamically generated.  Currently, properties are restricted to objects, classes, SEL (encoded as strings), and scalar values.  
// Generic pointers (include c-strings) should be enocded via [NSValue valueWithPointer: ptr]
// Under UIKit, we also support CGPoint, CGSize, and CGRect (encoded as NSValue *)
// Under AppKit, we also support NSPoint, NSSize and NSRect (encoded as NSValue *)
// For now, encode all other structs as NSValues and make the property be of type NSValue *, or explicitly implement the property yourself
#define AZENUM(ename, evalue, eproperties...) \
+ ename { \
static id retval = nil; \
if (retval == nil) { \
retval = [self.alloc initWithName: @ #ename ordinal: evalue properties: [NSDictionary dictionaryWithObjectsAndKeys: eproperties, nil]]; \
}\
return retval;\
}

#if 0
/* So, for example: */
@interface Color : GandEnum
+ (Color *) RED;
+ (Color *) GREEN;
+ (Color *) BLUE;
@property (nonatomic, readonly) float hue;
@end

// ...
@implementation Color
@dynamic hue;
GANDENUM(RED, 0, [NSNumber numberWithFloat: 0.0], @"hue")
GANDENUM(GREEN, 1, [NSNumber numberWithFloat: 1./3.], @"hue")
GANDENUM(BLUE, 2, [NSNumber numberWithFloat: 2./3.], @"hue")
@end

void test()
{
    for (Color *c = Color.firstEnum; c != nil; c = c.nextEnum) {
	NSLog(@"Color: %@", c);
	if (c == Color.GREEN) {
	    NSLog(@"This is green, hue = %g", c.hue);
	}
    }
}
#endif

/**

@interface AZEnum : NSObject	<NSCopying, NSCoding> 
{
    NSString *_name;    int _ordinal;    NSDictionary *_properties;
    // cached to speed up prev/next - these are all "assign", not that it matters because they are all singletons 
    id _previousWrappingEnum;		id _nextWrappingEnum;
    BOOL _isFirstEnum, _isLastEnum, _isCacheValid;
}
@property (NATOM,STR) NSS *name;
@property (NATOM,	 ASS) int ordinal;

+ enumFromName: (NSString *) name;
+ enumFromOrdinal: (int) ordinal;
+ (NSA*) allEnums;
// note the use of id make these no longer type safe
+ firstEnum;
+ lastEnum;
@property (NATOM,RO) id previousEnum;
@property (NATOM,RO) id nextEnum;
@property (NATOM,RO) id previousWrappingEnum;
@property (NATOM,RO) id nextWrappingEnum;
- (id) deltaEnum: (NSI) delta wrapping: (BOOL) wrapping;
// this should only be called from with the enum declaration methods
- (id) initWithName:(NSS*)n ordinal:(int)o properties:(NSD*)props;
+ (void) invalidateEnumCache; // if you've done dynamic code loading and added an enum through a category, call this for each enum class modified
@end

// Macro to declare the enum implementation.  The name and ordinal value are the first two parameters, what follows is then a list of objects and keys for additional properties
// This list is used for +[NSDictionary  dictionaryWithObjectsAndKeys:]  - note that you do not need to specify a nil at the end (it is added automatically)
// These properties will be dynamically generated.  Currently, properties are restricted to objects, classes, SEL (encoded as strings), and scalar values.  
// Generic pointers (include c-strings) should be enocded via [NSValue valueWithPointer: ptr]
// Under UIKit, we also support CGPoint, CGSize, and CGRect (encoded as NSValue *)
// Under AppKit, we also support NSPoint, NSSize and NSRect (encoded as NSValue *)
// For now, encode all other structs as NSValues and make the property be of type NSValue *, or explicitly implement the property yourself
#define AZENUM(ename, evalue, eproperties...) \
+ ename { \
static id retval = nil; \
if (retval == nil) { \
retval = [self.alloc initWithName: @ #ename ordinal: evalue properties: [NSDictionary dictionaryWithObjectsAndKeys: eproperties, nil]]; \
}\
return retval;\
}

*/
#if 0
/* So, for example: */
@interface Color : AZEnum
+ (Color *) RED;
+ (Color *) GREEN;
+ (Color *) BLUE;
@property (NATOM,readonly) float hue;
@end

// ...

@implementation Color
@dynamic hue;
AZEnum(RED, 0, [NSNumber numberWithFloat: 0.0], @"hue")
AZEnum(GREEN, 1, [NSNumber numberWithFloat: 1./3.], @"hue")
AZEnum(BLUE, 2, [NSNumber numberWithFloat: 2./3.], @"hue")
@end

void test()
{
    for (Color *c = Color.firstEnum; c != nil; c = c.nextEnum) {
	NSLog(@"Color: %@", c);
	if (c == Color.GREEN) {
	    NSLog(@"This is green, hue = %g", c.hue);
	}
    }
}
#endif

//#define JROptions(ENUM_TYPENAME, ENUM_CONSTANTS...)											\
//	typedef NS_OPTIONS(NSUInteger, ENUM_TYPENAME) { ENUM_CONSTANTS  };					\
//	static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS; 		\
//   _JROptions_GenerateImplementation(ENUM_TYPENAME)
//
////--
/**
#define AZEnumDeclare(ENUM_TYPENAME, ENUM_CONSTANTS...) 												\
@interface ENUM_TYPENAME : AZEnum																			\
+ (
ENUM_TYPENAME ENUM_TYPENAME##
+ (Colore *) eRED;
+ (Colore *) eGREEN;
+ (Colore *) eBLUE;
@property (NATOM,readonly) float hue;
@end

	typedef NS_OPTIONS(NSUInteger, ENUM_TYPENAME) { ENUM_CONSTANTS	};									\
	extern NSDictionary* ENUM_TYPENAME##ByValue();  														\
	extern NSDictionary* ENUM_TYPENAME##ByLabel(); 															\
	extern NSString* ENUM_TYPENAME##ToString(int enumValue);												\
	extern BOOL ENUM_TYPENAME##FromString(NSString *enumLabel, ENUM_TYPENAME *enumValue);   	\
	static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS;

#define JROptionsDefine(ENUM_TYPENAME) _JROptions_GenerateImplementation(ENUM_TYPENAME)

//--

#define _JROptions_GenerateImplementation(ENUM_TYPENAME)  																\
	NSArray* _JROptionsParse##ENUM_TYPENAME##ConstantsString() {														\
		NSArray *stringPairs = [_##ENUM_TYPENAME##_constants_string componentsSeparatedByString:@","];		\
		NSMutableArray *labelsAndValues = NSMutableArray.new;																\
		NSNumber *lastValue = @(0);	  																  							\
		for (NSString *stringPair in stringPairs) {  																		\
			NSArray *labelAndValueString = [stringPair componentsSeparatedByString:@"="];	  						\
			NSString *label = labelAndValueString[0];																			\
			label = [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];			\
			NSString *valueString = labelAndValueString.count > 1 ? labelAndValueString[1] : nil;				\
		  	NSScanner *scanner = [NSScanner scannerWithString:valueString];											\
			NSUInteger aNumericValue;																								\
  			[scanner scanHexInt:(NSInteger)&aNumericValue];																	\
NSNumber *value = valueString ? [NSNumber numberWithInt:aNumericValue] 							\
													: @([lastValue intValue]+1);													\
			lastValue = value;	  																  									\
			[labelsAndValues addObject:label];	  																  				\
			[labelsAndValues addObject:value];   																				\
		}	  																  																\
		if (0) NSLog (@"DEBUG: stringPairs:%@ labelsandVals:%@", stringPairs, labelsAndValues);				\
		return labelsAndValues;	  																  									\
	}  																  																	\
	NSDictionary* ENUM_TYPENAME##ByValue() {	  																				\
		NSArray *constants = _JROptionsParse##ENUM_TYPENAME##ConstantsString();										\
		NSMutableDictionary *result = NSMutableDictionary.new;  															\
		for (NSUInteger i = 0; i < constants.count; i += 2) 	  															\
			[result setObject:constants[i] forKey:constants[i+1]];														\
		return result;	  																												\
	}	  																  																	\
	NSDictionary* ENUM_TYPENAME##ByLabel() {	  																				\
		NSArray *constants = _JROptionsParse##ENUM_TYPENAME##ConstantsString();										\
		NSMutableDictionary *result = NSMutableDictionary.new;		  													\
		for (NSUInteger i = 0; i < constants.count; i += 2) 	  															\
			[result setObject:(NSNumber*)constants[i+1] forKey:(NSString*)constants[i]];							\
		return result;	  																  												\
	}	  																  																	\
	NSString* ENUM_TYPENAME##ToString(int enumValue) {	  																	\
		NSString *result = [ENUM_TYPENAME##ByValue() objectForKey:[NSNumber numberWithInt:enumValue]];		\
		return result ?: [NSString stringWithFormat:@"<unknown "#ENUM_TYPENAME": %d>", enumValue];			\
	}	  																  																	\
	BOOL ENUM_TYPENAME##FromString(NSString *enumLabel, ENUM_TYPENAME *enumValue) {								\
		NSNumber *value = [ENUM_TYPENAME##ByLabel() objectForKey:enumLabel];											\
		if (value) { *enumValue = (ENUM_TYPENAME)[value intValue];	return YES;	} else return NO;				\
	}

 #define _JREnum_GenerateImplementation(ENUM_TYPENAME)  \
 NSArray* _JREnumParse##ENUM_TYPENAME##ConstantsString() {	\
 NSArray *stringPairs = [_##ENUM_TYPENAME##_constants_string componentsSeparatedByString:@","];	\
 __block int lastValue = -1;	\
 NSA *pairsies = [NSA arrayWithArrays:[stringPairs map:^NSA*(NSS* stringPair){\
 NSArray *labelAndValueString = [stringPair componentsSeparatedByString:@"="];	\
 NSString *label = [labelAndValueString objectAtIndex:0];	\
 label = [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];    \
 NSString *valueString = [labelAndValueString count] > 1 ? [labelAndValueString objectAtIndex:1] : nil;	\
 int value = valueString ? [valueString intValue] : lastValue + 1;	\
 lastValue = value;	\
 return @[label,[NSNumber numberWithInt:value]]; }]];\
 NSLog(@"pairsies:%@", pairsies); return pairsies;\
 }\
 
// JREnum.h semver:0.2 Original implementation by Benedict Cohen: http://benedictcohen.co.uk http://rentzsch.com https://github.com/rentzsch/JREnum

#define AZEnum(ENUM_TYPENAME, ENUM_CONSTANTS...)    \
static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS; \
_JREnum_GenerateImplementation(ENUM_TYPENAME)

#define AZEnumDeclare(ENUM_TYPENAME, ENUM_CONSTANTS...) \

extern NSDictionary* ENUM_TYPENAME##ByValue();  \
extern NSDictionary* ENUM_TYPENAME##ByLabel();  \
extern NSString* ENUM_TYPENAME##ToString(int enumValue);    \
extern BOOL ENUM_TYPENAME##FromString(NSString *enumLabel, ENUM_TYPENAME *enumValue);   \
static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS;

NSString *kViewNotSizable = @"kViewNotSizable";
NSString *kViewMinXMargin = @"kViewMinXMargin";
NSString *kViewWidthSizable = @"kViewWidthSizable";
NSString *kViewMaxXMargin = @"kViewMaxXMargin";
NSString *kViewMinYMargin = @"kViewMinYMargin";
NSString *kViewHeightSizable = @"kViewHeightSizable";
NSString *kViewMaxYMargin = @"kViewMaxYMargin";
//typedef enum {  \
//ENUM_CONSTANTS  \
//} ENUM_TYPENAME;    \

//--


#define JREnumDefine(ENUM_TYPENAME) \
_JREnum_GenerateImplementation(ENUM_TYPENAME)

//--

#define _JREnum_GenerateImplementation(ENUM_TYPENAME)  \
NSArray* _JREnumParse##ENUM_TYPENAME##ConstantsString() {	\
NSArray *stringPairs = [_##ENUM_TYPENAME##_constants_string componentsSeparatedByString:@","];	\
NSMutableArray *labelsAndValues = [NSMutableArray arrayWithCapacity:[stringPairs count]];	\
int lastValue = -1;	\
for (NSString *stringPair in stringPairs) {	\
NSArray *labelAndValueString = [stringPair componentsSeparatedByString:@"="];	\
NSString *label = [labelAndValueString objectAtIndex:0];	\
label = [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];    \
NSString *valueString = [labelAndValueString count] > 1 ? [labelAndValueString objectAtIndex:1] : nil;	\
int value = valueString ? [valueString intValue] : lastValue + 1;	\
lastValue = value;	\
[labelsAndValues addObject:label];	\
[labelsAndValues addObject:[NSNumber numberWithInt:value]];	\
}	\
return labelsAndValues;	\
}	\
\
NSDictionary* ENUM_TYPENAME##ByValue() {	\
NSArray *constants = _JREnumParse##ENUM_TYPENAME##ConstantsString();	\
NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[constants count] / 2];	\
for (NSUInteger i = 0; i < [constants count]; i += 2) {	\
NSString *label = [constants objectAtIndex:i];	\
NSNumber *value = [constants objectAtIndex:i+1];	\
[result setObject:label forKey:value];	\
}	\
return result;	\
}	\
\
NSDictionary* ENUM_TYPENAME##ByLabel() {	\
NSArray *constants = _JREnumParse##ENUM_TYPENAME##ConstantsString();	\
NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[constants count] / 2];	\
for (NSUInteger i = 0; i < [constants count]; i += 2) {	\
NSString *label = [constants objectAtIndex:i];	\
NSNumber *value = [constants objectAtIndex:i+1];	\
[result setObject:value forKey:label];	\
}	\
return result;	\
}	\
\
NSString* ENUM_TYPENAME##ToString(int enumValue) {	\
NSString *result = [ENUM_TYPENAME##ByValue() objectForKey:[NSNumber numberWithInt:enumValue]];	\
if (!result) {	\
result = [NSString stringWithFormat:@"<unknown "#ENUM_TYPENAME": %d>", enumValue];	\
}	\
return result;	\
}	\
\
BOOL ENUM_TYPENAME##FromString(NSString *enumLabel, ENUM_TYPENAME *enumValue) {	\
NSNumber *value = [ENUM_TYPENAME##ByLabel() objectForKey:enumLabel];	\
if (value) {	\
*enumValue = (ENUM_TYPENAME)[value intValue];	\
return YES;	\
} else {	\
return NO;	\
}	\
}
*/

@interface NSString (AtoZEnums)

//+ (NSD*) enumDictionary;
//+ (NSS*) stringForEnumType:(char *)type value:(int)value;
//- (int) enumValue;

@end
