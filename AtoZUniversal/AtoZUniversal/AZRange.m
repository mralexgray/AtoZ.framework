
#import <AtoZUniversal/AtoZUniversal.h>

#define ddsprintf(FORMAT, ARGS... )  [NSString stringWithFormat: (FORMAT), ARGS]


NSString * DDNSStringFromBOOL(BOOL b)
{
	return b ? @"YES" : @"NO";
}

#if TARGET_OS_IPHONE
#define NSStringFromPoint NSStringFromCGPoint
#define NSStringFromRect NSStringFromCGRect
#define NSStringFromSize NSStringFromCGSize
#endif

NSString * DDToStringFromTypeAndValueAlt(const char * typeCode, void * value)
{
	if (strcmp(typeCode, @encode(NSPoint)) == 0)
	{
		return NSStringFromPoint(*(NSPoint *)value);
	}
	else if (strcmp(typeCode, @encode(NSSize)) == 0)
	{
		return NSStringFromSize(*(NSSize *)value);
	}
	else if (strcmp(typeCode, @encode(NSRect)) == 0)
	{
		return NSStringFromRect(*(NSRect *)value);
	}
	else if (strcmp(typeCode, @encode(Class)) == 0)
	{
		return NSStringFromClass(*(Class *)value);
	}
	else if (strcmp(typeCode, @encode(SEL)) == 0)
	{
		return NSStringFromSelector(*(SEL *)value);
	}
	else if (strcmp(typeCode, @encode(NSRange)) == 0)
	{
		return NSStringFromRange(*(NSRange *)value);
	}
	else if (strcmp(typeCode, @encode(id)) == 0)
	{
		return ddsprintf(@"%@", value);//*(id *)value);
	}
	else if (strcmp(typeCode, @encode(BOOL)) == 0)
	{
		return DDNSStringFromBOOL(*(BOOL *)value);
	}

	return ddsprintf(@"? <%s>", typeCode);
}


//NSValue * AZVpoint	(NSPoint pnt)		{ return [NSValue valueWithPoint:pnt];			}
//NSValue * AZVrect 	(NSRect rect) 		{ return [NSValue valueWithRect: rect]; 		}
//NSValue * AZVsize 	(NSSize size) 		{ return [NSValue valueWithSize: size]; 		}
//NSValue * AZV3d	 	(CATransform3D t) { return [NSValue valueWithCATransform3D:t]; }
//NSValue * AZVrng	 	(NSRange rng) 		{ return [NSValue valueWithRange:rng]; 		}


//typedef char(^charBlock)(id); = ^char(id o) { return [o charValue]; };
//typedef short				(^shortBlock)(id) = ^char(id o) { return [o charValue]; };
//typedef unsigned short	(^uShortBlock)(id);
//typedef int					(^intBlock)(id);
//typedef unsigned int		(^uIntBlock)(id);



//#import "AZRange.h"

//void     AZRangeElongate(RNG r) {  r.length++; }


void parseStringIntoNSInteger(NSString* str,NSInteger*pNum){
	if(str == nil)
	{
		*pNum = 0;
		return;// NO;
	}
	
	errno = 0;
	
	// On LP64, NSInteger = long = 64 bit
	// Otherwise, NSInteger = int = long = 32 bit
	
	*pNum = strtol([str UTF8String], NULL, 10);
	
	if(errno != 0)
		return;// NO;
	else
		return;// YES;
}


@implementation AZRange @dynamic range;

+ (BOOL) canGetRangeFromString:(NSString*)s {

  return [s = [s stringByReplacingOccurrencesOfString:@" " withString:@""] // stringWithoutSpaces;
                                            hasPrefix:@"{"]                     &&
                                         [s hasSuffix:@"}"]                     &&
                               [[s substringWithRange:(NSRange){1,s.length-1}]
                          componentsSeparatedByString:@","].count == 2          &&
                  [[s stringByTrimmingCharactersInSet:
   [NSCharacterSet characterSetWithCharactersInString:@" {,}-+0123456789"]]
                                      isEqualToString:@""];
}

+ (RNG*) rangeFromString:(NSString*)s { AZRange *result = self.class.new;

  NSRange comma = [s rangeOfString:@","], p = [s rangeOfString:@"}"];
	NSString *str1 = [s substringWithRange:(NSRange){1, comma.location -1}],
           *str2 = [s substringWithRange:(NSRange){NSMaxRange(comma), p.location - NSMaxRange(comma)}];
	
  if (str1) result.location = str1.integerValue;
	if (str2) result.length   = str2.integerValue; //if(found2) parseStringIntoNSInteger(str2,result.length);
	return result;
}

+ (instancetype) rangeWithNSRange:(NSRange)r { AZRange *new = self.class.new; new.range = r; return new; }

- (BOOL) isValidNSRange { return self.location >= 0 && self.length >= 0; }

- (NSRange) range { return NSMakeRange(self.isValidNSRange ? self.location : NSNotFound, self.isValidNSRange ? self.length : NSNotFound); }
- _Void_ setRange:(NSRange)range { self.location = range.location; self.length = range.length; }

- (RNG*) push   { self.location++; return self; }
- (RNG*) pull   { self.location--; return self; }
- (RNG*) expand { self.length++;   return self; }
- (RNG*) shrink { self.length--;   return self; }


// NSRange will ignore '-' characters, but not '+' characters
//  NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"-+0123456789"];
//	NSScanner *scanner = [NSScanner scannerWithString:s];
//	[scanner setCharactersToBeSkipped:cset.invertedSet];
//	BOOL found1 = [scanner scanCharactersFromSet:cset intoString:&str1];
//	BOOL found2 = [scanner scanCharactersFromSet:cset intoString:&str2];
//
//  if(found1) parseStringIntoNSInteger(,

+ (NSSet*) keyPathsForValuesAffectingMax          { return [NSSet setWithObjects:@"length", @"location", nil]; }
+ (NSSet*) keyPathsForValuesAffectingStringValue  { return [NSSet setWithObjects:@"length", @"location", nil]; }

- (NSInteger) max         { return _location + _length; }
- (NSString*) stringValue { return [NSString stringWithFormat:@"{%ld,%ld}", _location, _length]; }

+ (RNG*) rangeAtLocation:(NSInteger)loc 
                  length:(NSInteger)len { AZRange *e = self.new; e.location = loc; e.length = len; return e; }

- (RNG*) unionRange:(RNG*)r2 { RNG *z = $RNG( MIN(self.location, r2.location),0); return $RNG(z.location,MAX(self.max, r2.max) - z.location); }

- (BOOL) isEqual:(id)r2 { if(![r2 isKindOfClass:self.class]) return NO;   AZRange* z2 = r2;

  /*! Comparison basis:  Which range would you encouter first if you

    1. started at location (NOT zero, necesssarily)
ane 2. began walking towards infinity.
  
  If you encouter both ranges at the same time, which range would end first.
  */
	
	return  self.location < z2.location ? NSOrderedAscending
        : self.location > z2.location ? NSOrderedDescending
        : self.length   < z2.length   ? NSOrderedAscending
        : self.length   > z2.length   ? NSOrderedDescending : NSOrderedSame;
}
- (NSUInteger) hash { return self.isValidNSRange ? self.max : NSNotFound - self.max; }

- (NSString*) description { return [NSString stringWithFormat:@"%@ (%@)", super.description, self.stringValue]; }

@end
