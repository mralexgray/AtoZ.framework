//
//  THWebNamedColors.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 28.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZCSSColors : NSColorList

+(AZCSSColors *)webNamedColors;

+(NSString *)nameOfColor:(NSColor *)color;
+(NSString *)nameOfColor:(NSColor *)color 
          savingDistance:(NSColor **)distance;

@end

@interface NSColor (AZCSSColors)

@property (readonly) NSString *webName;

@end
