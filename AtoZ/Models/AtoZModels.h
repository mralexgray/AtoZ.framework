//
//  AZDock.h
//  AtoZ
//
//  Created by Alex Gray on 9/12/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

//#import "AtoZFunctions.h"
//#import "AtoZUmbrella.h"
#import "AZObject.h"
#import "AtoZModels.h"
#import <Cocoa/Cocoa.h>

@interface AZFolder : BaseModel  <BaseModel, NSCopying, NSMutableCopying, NSFastEnumeration>



+ (id) appFolder;
+ (id) samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items;
+ (id) instanceWithFiles:(NSArray*)files;
+ (id) instanceWithPaths:(NSArray*)strings;

@end

@interface AZDock : BaseModel
@property (readonly) NSArray *dock;
@property (readonly) NSArray *dockSorted;
@property (nonatomic, assign) AZDockSort sortOrder;
@end

@interface AZColor : BaseModel
@property (nonatomic, readonly) CGFloat 	brightness;
@property (nonatomic, readonly) CGFloat 	saturation;
@property (nonatomic, readonly) CGFloat 	hue;
@property (nonatomic, readonly) CGFloat 	hueComponent;

@property (nonatomic, assign)	CGFloat 	percent;
@property (nonatomic, assign) 	NSUInteger 	count;
@property (nonatomic, strong)	NSString 	*name;
@property (nonatomic, strong)	NSColor	 	*color;
+ (instancetype) instanceWithObject:(NSDictionary*)dic;
+ (instancetype) colorWithColor:(NSColor*)color andDictionary:(NSDictionary*)dic;
- (NSArray*) az_colorsForImage:(NSImage*)image;

@end

//extern NSString *const AtoZFileUpdated;
	//@class AJSiTunesResult;
