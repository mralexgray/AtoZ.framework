//
//  AZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/7/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AZColor : BaseModel
@property (NATOM) CGFloat 	brightness, saturation, hue, hueComponent, percent;
@property (NATOM)	NSUInteger 	total, count;
@property (NATOM, STRNG)	NSString 	*name;
@property (NATOM, STRNG)	NSColor	 	*color;

+ (instancetype) instanceWithObject:(NSDictionary*)dic;
//+ (instancetype) colorWithColor:(NSColor*)color andDictionary:(NSDictionary*)dic;
//- (NSA*) az_colorsForImage:(NSImage*)image;
+ (instancetype) instanceWithColor:(NSColor*)color count:(NSUI)c total:(NSUI) totes;

@end
