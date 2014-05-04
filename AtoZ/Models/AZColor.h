//
//  AZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/7/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZUmbrella.h"


//@interface AZGradient : BaseModel
//
//
///* gradients from palettes */
//+ (NSA*) gradientPalletteBetween:(NSC*)c1 and:(NSC*)c2 steps:(NSUI)steps;
//+ (NSA*) gradientPalletteBetween:(NSA*)colors steps:(NSUI)steps;
//+ (NSA*) gradientPalletteLooping:(NSA*)colors steps:(NSUI)steps;
//
//
//@end

@interface     AZColor : NSColor <NSCopying>

+ (INST)     colorWithColor:(NSC*)c;
//+ (INST) instanceWithObject:(NSD*)dic;
//+ (INST)  instanceWithColor:(NSC*)c
//															count:(NSUI)ct
//															total:(NSUI)tot;

//@property (NATOM)	 NSS * name;
@property (CP)     NSC * color;
//@property (NATOM)	NSUI 	 total,
//												 count;
@property CGF   brightness,
                saturation,
								hue;
//												 hueComponent,
//												 percent;
@end


//+ (instancetype) colorWithColor:(NSColor*)color andDictionary:(NSDictionary*)dic;
//- (NSA*) az_colorsForImage:(NSImage*)image;
