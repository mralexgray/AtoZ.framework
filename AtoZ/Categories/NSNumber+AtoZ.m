//
//  NSNumber+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSNumber+AtoZ.h"

@implementation NSNumber (AtoZ)


- (NSString *)prettyBytes {
float bytes = [self longValue];
NSUInteger unit = 0;

if(bytes < 1) return @"-";

while(bytes > 1024) {
	bytes = bytes / 1024.0;
	unit++;
}

if(unit > 5) return @"HUGE";

NSString *unitString = [[NSArray arrayWithObjects:@"Bytes", @"KB", @"MB", @"GB", @"TB", @"PB", nil] objectAtIndex:unit];

if(unit == 0) {
	return [NSString stringWithFormat:@"%d %@", (int)bytes, unitString];
} else {
	return [NSString stringWithFormat:@"%.2f %@", (float)bytes, unitString];
}
}


+(NSNumber *)zero {
	return [NSNumber numberWithInt:0];
}

+(NSNumber *)one {
	return [NSNumber numberWithInt:1];
}

+(NSNumber *)two {
	return [NSNumber numberWithInt:2];
}

-(NSNumber *)abs {
	return [NSNumber numberWithDouble:fabs(self.doubleValue)];
}

-(NSNumber *)negate {
	return [NSNumber numberWithDouble:-self.doubleValue];
}

-(NSNumber *)transpose {
	return [NSNumber numberWithDouble:(1 / self.doubleValue)];
}

-(NSArray *)times:(id (^)(void))block {
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

-(NSArray *)to:(NSNumber *)to {
	return [self to:to by:[NSNumber numberWithDouble:1.0]];
}

-(NSArray *)to:(NSNumber *)to by:(NSNumber *)by {
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
		[re addObject:[NSNumber numberWithDouble:gamma]];
	}
	
	return re;
}


@end
