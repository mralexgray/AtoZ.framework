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
- (id) normal:(NSUI)idx;
@property (RONLY) NSA* colors;
@end

