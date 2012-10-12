//
//  AZCSSColorExtraction.m
//  AtoZ
//
//  Created by Alex Gray on 9/9/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZCSSColorExtraction.h"
#import <AtoZ/AtoZ.h>

@implementation AZCSSColorExtraction
//- (NSArray*)quantize:(NSString*)imagePath{
- (id)init
{
    self = [super init];
    if (self) {

	NSImage *i = [[NSImage systemImages]randomElement];
	NSLog(@"colors  %@", [i quantize]);
	
    }
    return self;
}
- (NSArray*)colorsInStyleSheet:(NSString*)text{
}
//
//	# |color| will be an array of 5 elements (5 regex groups)
//	# group 1: hex
//	# group 2,3,4: rgb respectively notes: handles rgba but ignores opacity
//	# group 5: a color (as an English word -- ex. white)
//		color_array = page_source.scan(/color\s*:\s*(#[0-9A-Fa-f]{3,6}+)\s*|rgba?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*|color\s*:\s*(white|aqua|black|blue|fuchsia|gray|green|lime|maroon|navy|olive|orange|purple)/)
//									   color_array.each{|color|
//#puts color.inspect
//										   if color[0] != nil
//											   color = color[0].downcase
//											   color = expand_hex(color) if color.length == 4 # usually length 3 but including '#' so use length 4
//												   elsif color[1] != nil
//												   color = "#" + color[1].to_i.to_s(16) + color[2].to_i.to_s(16) + color[3].to_i.to_s(16)
//# below is the case that you have r: 0 g: 0 b: 0 => #000 .... need to expand
//												   color = expand_hex(color) if color.length == 4 # usually length 3 but including '#' so use length 4
//													   else
//														   color = color[4].downcase
//														   hex_color = get_hex(color)
//														   color = hex_color if hex_color != nil # try to assign a hex value, if not, will remain as is.
//															   end
//#puts color
//															   if @color_map[color] == nil
//																   @color_map[color] = 1
//																   else
//																	   @color_map[color] += 1
//																	   end
//																	   }
//									   }
//}
@end
