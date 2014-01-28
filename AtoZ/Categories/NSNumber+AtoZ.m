//
//  NSNumber+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSNumber+AtoZ.h"

@implementation NSNumber (AtoZ)

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

- (NSN*)plus:(NSN*)toAdd {			/*	!! @YES = 1, @NO = 0  !! */
//	[@4.999 objCType] = d; [@YES objCType] = c; [@0 objCType] = i; [[NSN numberWithUnsignedInteger:66] objCType] = q

	return 	strcmp("d", self.objCType) ?  @(self.doubleValue   		 	+ toAdd.doubleValue 				):
				strcmp("c", self.objCType) ?	@(self.charValue      			+ toAdd.charValue   				):
				strcmp("i", self.objCType) ?	@(self.integerValue   			+ toAdd.integerValue  			):
				strcmp("q", self.objCType) ?	@(self.unsignedIntegerValue  	+ toAdd.unsignedIntegerValue  ):
				strcmp("f", self.objCType) ?	@(self.floatValue   				+ toAdd.floatValue				):
														@(self.longLongValue				+ toAdd.longLongValue			);
}
+ (NSN*)integerWithHexString:(NSS*)hexString;
{
  NSScanner *scanner = [NSScanner scannerWithString:hexString];  NSUInteger value;
  return [scanner scanHexInt:(NSInteger)&value] ? [NSNumber numberWithInteger:value] : nil;
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
-(NSA*)times:(id (^)(void))block {
	int n = self.intValue;
	
	if (n < 0) {
		return nil;
	}
	
	NSMutableArray *re = [[NSMutableArray alloc] initWithCapacity:n];
	
	for (int i = 0; i < n; i++) {
		id o = block();
		if (o) {
			[re addObject:o];
		}
	}
	
	return re;
}

-(NSA*)to:(NSN*)to {
	return [self to:to by:@1.0];
}

-(NSA*)to:(NSN*)to by:(NSN*)by {
	double alpha = self.doubleValue;
	double omega = to.doubleValue;
	double delta = by.doubleValue;
	
	if ((alpha > omega && delta > 0)
		|| (alpha < omega && delta < 0)
		) {
		delta = -delta;
	}
	
	BOOL (^_)(double) = delta > 0
	? ^(double g){ return (BOOL) (g <= omega); }
	: ^(double g){ return (BOOL) (g >= omega); }
	;
	
	NSMutableArray *re = NSMutableArray.new;
	
	for (double gamma = alpha; _(gamma); gamma += delta) {
		[re addObject:@(gamma)];
	}
	
	return re;
}


@end

@implementation NSNumber (Description)

- (NSS*)typeFormedDescription {
	if ([self.className isEqualToString:@"__NSCFNumber"]) {
		NSString *defaultDescription = [self description];
		if (strcmp(self.objCType, @encode(float)) == 0 || strcmp(self.objCType, @encode(double)) == 0) {
			if (![defaultDescription hasSubstring:@"."]) {
				return [defaultDescription stringByAppendingString:@".0"];
			}
		}
		return defaultDescription;
	} else if ([self.className isEqualToString:@"__NSCFBoolean"]) {
		return [self boolValue] ? @"YES" : @"NO";
	}
	return [self description];
}

@end


@implementation NSDecimalNumber (Description)

- (NSS*)typeFormedDescription {
	NSString *defaultDescription = [self description];
	if (strcmp(self.objCType, @encode(float)) == 0 || strcmp(self.objCType, @encode(double)) == 0) {
		if (![defaultDescription hasSubstring:@"."]) {
			return [defaultDescription stringByAppendingString:@".0"];
		}
	}
	return defaultDescription;
}

@end
