//
//  THWebNamedColors.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 28.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZNamedColors : NSColorList

+(AZNamedColors *)namedColors;

+(NSString *)nameOfColor:(NSColor *)color;
+(NSString *)nameOfColor:(NSColor *)color savingDistance:(NSColor **)distance;

@end

@interface NSColor (AZNamedColors)

@property (RONLY) NSString *webName;

@end
