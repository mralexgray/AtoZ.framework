//
//  AZ.m
//  AtoZ
//
//  Created by Alex Gray on 6/7/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZColor.h"

@implementation AZColor
//@synthesize     brightness,     saturation,hue, count, name,color, hueComponent,   total;


+ (instancetype)instanceWithColor:(NSColor *)color count:(NSUI)c total:(NSUI)totes {
    AZColor *cc = self.class.instance;
    cc.color = color;
    cc.count = c;
    cc.total = totes;
    return cc;
}

- (CGF)percent {    return _percent = self.count / self.total;
}

+ (instancetype)instanceWithObject:(NSDictionary *)dic {
    if (!dic[@"color"]) return nil;
    AZColor *color = [[self class] instanceWithColor:dic[@"color"]];
    color.name        =  dic [@"name"] ? dic [@"name"] : @"";
    color.count   =  dic [@"count"] ? [dic [@"count"] intValue] : 0;
    color.total   =  dic [@"percent"] ? (color.count / [dic [@"percent"] floatValue]) : 1;
    //	percent =dic [@"percent"] ? [dic [@"percent"] floatValue]  : 0;
    return color;
}

//-(CGFloat) saturation     {	return [_color saturationComponent]; }
//-(CGFloat) hue            {	return [_color hueComponent];		 }
//-(CGFloat) brightness     {	return [_color brightnessComponent]; }
//-(CGFloat) hueComponent {	return [color_ hueComponent];		        }

/*
   -(NSA*) colorsForImage:(NSImage*)image {

        @autoreleasepool {

                NSArray *rawArray = [image quantize];
                        // put all colors in a bag
                NSBag *allBag = [NSBag bag];
                for (id thing in rawArray ) [allBag add:thing];
                NSBag *rawBag = [NSBag bag];
                int total = 0;
                for ( NSColor *aColor in rawArray ) {
                                //get rid of any colors that account for less than 10% of total
                        if ( ( [allBag occurrencesOf:aColor] > ( .0005 * [rawArray count]) )) {
                                        // test for borigness
                                if ( [aColor isBoring] == NO ) {
                                        NSColor *close = [aColor closestNamedColor];
                                        total++;
                                        [rawBag add:close];
                                }
                        }
                }
                NSArray *exciting =     [[rawBag objects] filter:^BOOL(id object) {
                        NSColor *idColor = object;
                        return ([idColor isBoring] ? FALSE : TRUE);
                }];

                        //uh oh, too few colors
                if ( ([[rawBag objects]count] < 2) || (exciting.count < 2 )) {
                        for ( NSColor *salvageColor in rawArray ) {
                                NSColor *close = [salvageColor closestNamedColor];
                                total++;
                                [rawBag add:close];
                        }
                }
                NSMutableArray *colorsUnsorted = [NSMutableArray array];

                for (NSColor *idColor in [rawBag objects] ) {

                        AZColor *acolor = [AZColor instance];
                        acolor.color = idColor;
                        acolor.count = [rawBag occurrencesOf:idColor];
                        acolor.percent = ( [rawBag occurrencesOf:idColor] / (float)total );
                        [colorsUnsorted addObject:acolor];
                }
                rawBag = nil; allBag = nil;
                return [colorsUnsorted sortedWithKey:@"count" ascending:NO];
        }
   }

 */

@end
