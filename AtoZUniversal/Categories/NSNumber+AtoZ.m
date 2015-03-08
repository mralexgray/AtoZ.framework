//
//  NSNumber+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <AtoZUniversal/AtoZUniversal.h>

@implementation NSNumber (AtoZ)

- (void) do:(void(^)(int ctr))block { [self.toArray each:^(NSN* obj) {  block(obj.intValue); }]; }

+ (NSN*) randomFloatBetween:(CGF)min :(CGF)max { return [self numberWithFloat:RAND_FLOAT_VAL(min, max)]; }

//- (NSUI) bitInUse { int is_in_use(int car_num) {
    // pow returns an int, but in_use will also be promoted to an int
    // so it doesn't have any effect; we can think of this as an operation
    // between chars
//    return in_use & pow(2, car_num);
//}

- (NSS*) hexString { return $(@"0x%08lx", (long)self.iV); }

- (NSUI) length {  return self.stringValue.length; }

+ (NSR) rectBy:(NSA*)sizes { return !sizes.count ? NSZeroRect :

  sizes.count == 1	? (NSRect){NSZeroPoint,                  [sizes[0] fV], [sizes[0] fV]} :
  sizes.count == 2  ? (NSRect){NSZeroPoint,                  [sizes[0] fV], [sizes[1] fV]} :
  sizes.count == 3  ? (NSRect){[sizes[0] fV], 0,             [sizes[1] fV], [sizes[3] fV]} :
                      (NSRect){[sizes[0] fV], [sizes[1] fV], [sizes[2] fV], [sizes[3] fV]} ;

  //NSMakeRect([sizes[0] fV], [sizes[1] fV], [sizes[2] fV], sizes.count == 4 ? [sizes[3] fV]:0);
}
- (NSA*) toArray { return [@0 to:self]; }

+ (NSNumber *) numberWithBytes:(const void *) bytes objCType:(const char *) type {
	if( ! strcmp( type, @encode( char ) ) ) {
		char *val = (char *) bytes;
		return [NSNumber numberWithChar:*val];
	} else if( ! strcmp( type, @encode( unsigned char ) ) ) {
		unsigned char *val = (unsigned char *) bytes;
		return [NSNumber numberWithUnsignedChar:*val];
	} else if( ! strcmp( type, @encode( BOOL ) ) ) {
		BOOL *val = (BOOL *) bytes;
		return [NSNumber numberWithBool:*val];
	} else if( ! strcmp( type, @encode( short ) ) ) {
		short *val = (short *) bytes;
		return [NSNumber numberWithShort:*val];
	} else if( ! strcmp( type, @encode( unsigned short ) ) ) {
		unsigned short *val = (unsigned short *) bytes;
		return [NSNumber numberWithUnsignedShort:*val];
	} else if( ! strcmp( type, @encode( int ) ) ) {
		int *val = (int *) bytes;
		return [NSNumber numberWithInt:*val];
	} else if( ! strcmp( type, @encode( unsigned ) ) ) {
		unsigned *val = (unsigned *) bytes;
		return [NSNumber numberWithUnsignedInt:*val];
	} else if( ! strcmp( type, @encode( long ) ) ) {
		long *val = (long *) bytes;
		return [NSNumber numberWithLong:*val];
	} else if( ! strcmp( type, @encode( unsigned long ) ) ) {
		unsigned long *val = (unsigned long *) bytes;
		return [NSNumber numberWithUnsignedLong:*val];
	} else if( ! strcmp( type, @encode( long long ) ) ) {
		long long *val = (long long *) bytes;
		return [NSNumber numberWithLongLong:*val];
	} else if( ! strcmp( type, @encode( unsigned long long ) ) ) {
		unsigned long long *val = (unsigned long long *) bytes;
		return [NSNumber numberWithUnsignedLongLong:*val];
	} else if( ! strcmp( type, @encode( float ) ) ) {
		float *val = (float *) bytes;
		return [NSNumber numberWithFloat:*val];
	} else if( ! strcmp( type, @encode( double ) ) ) {
		double *val = (double *) bytes;
		return [NSNumber numberWithDouble:*val];
	} else return nil;
}

- (NSN*) dividedBy:(CGF)f {  return @(self.fV / f); }

- (NSN*) plus:(NSN*)toAdd { return [self basicMathWith:toAdd add:YES]; }

- (NSN*) minus:(NSN*)toSub { return [self basicMathWith:toSub add:NO]; }

- (NSN*) basicMathWith:(NSN*)arg add:(BOOL)add {  /*	!! @YES = 1, @NO = 0  !! */

//	[@4.999 objCType] = d; [@YES objCType] = c; [@0 objCType] = i; [[NSN numberWithUnsignedInteger:66] objCType] = q

	return 	!strcmp("d", self.objCType) ?  @(self.doubleValue    + (add ? arg.doubleValue   : -arg.doubleValue   )):
          !strcmp("c", self.objCType) ?	@(self.charValue      + (add ? arg.charValue     : -arg.charValue      )):
          !strcmp("i", self.objCType) ?	@(self.iV             + (add ? arg.iV            : -arg.iV             )):
          !strcmp("q", self.objCType) ?	@(self.uIV            + (add ? arg.uIV           : -arg.uIV            )):
          !strcmp("f", self.objCType) ?	@(self.fV             + (add ? arg.fV            : -arg.fV            ) ):
                                        @(self.longLongValue  + (add ? arg.longLongValue : -arg.longLongValue)  );
}
- (NSN*)plusF:(CGF)toAdd  { return @(self.fV + toAdd); }
- (NSN*)minusF:(CGF)toSub { return @(self.fV - toSub); }
- (NSN*)plusI:(NSI)toAdd  { return @(self.iV + toAdd); }
- (NSN*)minusI:(NSI)toSub { return @(self.iV - toSub); }


+ (NSN*)integerWithHexString:(NSS*)hexString;
{
  NSScanner *scanner = [NSScanner scannerWithString:hexString];  NSUInteger value;
  return [scanner scanHexInt:(NSInteger)&value] ? [NSNumber numberWithInteger:value] : nil;
}
- (NSS*) sVal {

  NSNumberFormatter *formatter = NSNumberFormatter.new;
  formatter.roundingIncrement = @(0.01);
  formatter.numberStyle = NSNumberFormatterDecimalStyle;
  return [formatter stringFromNumber:self];
}

- (CFNumberType) type {  return CFNumberGetType((CFNumberRef)self); }

- (NSS*)prettyBytes
{
	float bytes = [self longValue];
	NSUInteger unit = 0;

	if ( bytes < 1 ) return @"-";
	while ( bytes > 1024 )
	{
		bytes = bytes / 1024.0;
		unit++;
	}
	NSString *unitString = @[@"Bytes", @"KB", @"MB", @"GB", @"TB", @"PB"][unit];
	return unit > 5 ? @"HUGE" : unit == 0 ? $(@"%d %@", (int)bytes, unitString) : $(@"%.2f %@", (float)bytes, unitString);
}
+(NSN*)zero {
	return @0;
}

+(NSN*)one {
	return @1;
}

+(NSN*)two {
	return @2;
}

-(NSN*)abs {
	return @(fabs(self.doubleValue));
}

-(NSN*)negate {
	return @(-self.doubleValue);
}

-(NSN*)transpose {
	return @(1 / self.doubleValue);
}

- (NSN*)increment {
	return @([self intValue]+1);
}
- (NSA*) ntimes:(id (^)(int index))block {
  return self.intValue < 0 ? nil :[@(self.intValue).toArray mapArray:^id(id obj) { return block([obj intValue]); }];
}
-(NSA*)times:(id (^)(void))block {

  return self.intValue < 0 ? nil
                           :[@(self.intValue).toArray mapArray:^id(id obj) { return block(); }];
}

-(NSA*)to:(NSN*)to {	return [self to:to by:@1.0]; }

-(NSA*)to:(NSN*)to by:(NSN*)by { 	NSMA *re = NSMA.new;

	double alpha = self.doubleValue, omega = to.doubleValue, delta = by.doubleValue;
	
	delta = (alpha > omega && delta) || (alpha < omega && delta < 0) ? -delta : delta;

	BOOL (^_)(double) = delta ? ^(double g){ return (BOOL) (g <= omega); }
                            : ^(double g){ return (BOOL) (g >= omega); };

	for (double gamma = alpha; _(gamma); gamma += delta) [re addObject:@(gamma)];
	return re;
}

@end


@implementation NSDecimalNumber (Description)

- (NSS*)typeFormedDescription {
	NSString *defaultDescription = [self description];
	if (strcmp(self.objCType, @encode(float)) == 0 || strcmp(self.objCType, @encode(double)) == 0) {
		if ([defaultDescription rangeOfString:@"."].location == NSNotFound) {
			return [defaultDescription stringByAppendingString:@".0"];
		}
	}
	return defaultDescription;
}

@end
