//
//  NSString+AtoZEnums.h
//  AtoZ
//
//  Created by Alex Gray on 4/16/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/*

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
