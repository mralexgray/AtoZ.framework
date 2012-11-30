//
//  NSNumber+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSNumber+AtoZ.h"

@implementation NSNumber (AtoZ)

- (NSString *)prettyBytes
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
+(NSNumber *)zero {
	return @0;
}

+(NSNumber *)one {
	return @1;
}

+(NSNumber *)two {
	return @2;
}

-(NSNumber *)abs {
	return @(fabs(self.doubleValue));
}

-(NSNumber *)negate {
	return @(-self.doubleValue);
}

-(NSNumber *)transpose {
	return @(1 / self.doubleValue);
}

- (NSNumber *)increment {
	return @([self intValue]+1);
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
	return [self to:to by:@1.0];
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
		[re addObject:@(gamma)];
	}
	
	return re;
}
@end
