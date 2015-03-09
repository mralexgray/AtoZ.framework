
#import <AtoZUniversal/AtoZUniversal.h>

@implementation NSData (AtoZ)
- _Text_ UTF16String  { return [NSS.alloc initWithData:self encoding:NSUTF16StringEncoding]; }
- _Text_ UTF8String   { return [NSS.alloc initWithData:self encoding: NSUTF8StringEncoding]; }
- _Text_ ASCIIString  { return [NSS.alloc initWithData:self encoding:NSASCIIStringEncoding]; }
@end

@implementation NSString (FromAtoZ)
+  (NSS*) stringFromArray:(NSA*)a; 					{

	return [self stringFromArray:a withDelimeter:@"" last:@""];
}
+  (NSS*) stringFromArray:(NSA*)a
               withSpaces:(BOOL)spaces
               onePerline:(BOOL)newl 				{
	return [self stringFromArray:a withDelimeter:spaces ? @" " : newl ? @"\n" : @"" last:spaces ? @" " : newl ? @"\n" : @""];
}
+  (NSS*) stringFromArray:(NSA*)a
            withDelimeter:(NSS*)del
                     last:(NSS*)last 				{
	if (!a.count) return nil;
	NSMS* outString = @"".mutableCopy;
  for (id x in a) [outString appendFormat:@"%@%@",x,del];
  [outString replaceCharactersInRange:NSMakeRange(outString.length-1,1) withString:last];
  return outString.copy;
}

- (BOOL) isFloatNumber
{
    BOOL valid = NO;
    NSCharacterSet *floatNumber = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    if ([self length] > 0 ) {
        valid = [floatNumber isSupersetOfSet:stringSet];
    }
    return valid;
}

- (BOOL)isIntegerNumber {
	NSRange range = NSMakeRange(0, self.length);
	if (range.length) {
		unichar character = [self characterAtIndex:0];
		if ((character == '+') || (character == '-')) {
			range.location = 1;
			range.length -= 1;
		}
		range = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_DecimalDigits_Inverted) options:0 range:range];
		return range.location == NSNotFound;
	}
	return NO;
}
- (NSS*)    withExt:(NSS*)e { return      [self stringByAppendingPathExtension:e]; }
- (NSS*) withString:(NSS*)s {	return !s ? self : [self stringByAppendingString:s]; }
- (NSS*)   withPath:(NSS*)p {	return      [self stringByAppendingPathComponent:p]; }

@end

@implementation NSParagraphStyle (AtoZ)
+ (NSParagraphStyle*) defaultParagraphStyleWithDictionary:(NSD*)d {	NSMutableParagraphStyle *s;
  s = self.defaultParagraphStyle.mutableCopy;
  [s setValuesForKeysWithDictionary:d]; return s;
}
@end

@implementation  NSC (AtoZRefugee)
+ (NSC*) r:(CGF)red g:(CGF)green b:(CGF)blue a:(CGF)trans {

  return
#if !TARGET_OS_IPHONE
  [self colorWithDeviceRed:red green:green blue:blue alpha:trans];
#else
  [self colorWithRed:red green:green blue:blue alpha:trans];
#endif
}

@end