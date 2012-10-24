/*
 
 File: Circle+Archiving.m
 
 Abstract: Archiving support for Circle class.
 
 Version: 2.0
 

 */


#import "Circle.h"

@implementation Circle (Archiving)


- (id)initWithCoder:(NSCoder *)coder
{
	if (![coder allowsKeyedCoding])
	{
		NSLog(@"Circle only works with NSKeyedArchiver");
		return nil;
	}
	self.xLoc 			= [coder decodeFloatForKey:@"xLoc"];
	self.yLoc 			= [coder decodeFloatForKey:@"yLoc"];
	self.radius 		= [coder decodeFloatForKey:@"radius"];
	self.shadowOffset 	= [coder decodeFloatForKey:@"shadowOffset"];
	self.shadowAngle 	= [coder decodeFloatForKey:@"shadowAngle"];
	
	NSData *colorData 	= [coder decodeObjectForKey:@"color"];
	NSColor *newColor 	= [NSUnarchiver unarchiveObjectWithData:colorData];
	self.color 			= newColor;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	if (![coder allowsKeyedCoding])	{		NSLog(@"Circle only works with NSKeyedArchiver");	return;		}
	
	[coder encodeFloat:[self xLoc] 		    forKey:@"xLoc"			];
	[coder encodeFloat:[self yLoc] 		    forKey:@"yLoc"			];
	[coder encodeFloat:[self radius] 	    forKey:@"radius"		];
	[coder encodeFloat:[self shadowOffset]  forKey:@"shadowOffset"	];
	[coder encodeFloat:[self shadowAngle]   forKey:@"shadowAngle"	];
	
	NSData *colorData = [NSArchiver archivedDataWithRootObject:color];	[coder encodeObject:colorData forKey:@"color"];
}

@end


