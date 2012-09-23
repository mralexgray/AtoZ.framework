//
//  AZDock.h
//  AtoZ
//
//  Created by Alex Gray on 9/12/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZFunctions.h"
#import "AtoZUmbrella.h"
#import "AtoZ.h"

@interface AZFiles : BaseModel

@property (nonatomic, assign) AZDockSort sortOrder;
@property (nonatomic, retain) NSArray *dock;
@property (nonatomic, retain) NSArray *dockSorted;
@property (nonatomic, retain) NSArray *appCategories;

@property (nonatomic, strong) NSArray *appFolderSorted;
@property (nonatomic, strong) NSArray *appFolder;
@property (nonatomic, strong) NSArray *appFolderStrings;

@end

@interface AZFile : BaseModel
//	@property (weak)	id itunesDescription;
//	@property (weak)	id itunesResults;
//	@property (strong, nonatomic)	AJSiTunesResult *itunesInfo;
//	@property (strong, nonatomic)  	NSImage	 * 	icon;

@property (strong, nonatomic) NSString *  calulatedBundleID;
@property (strong, nonatomic) NSString *  path;
@property (strong, nonatomic) NSString *  name;
@property (strong, nonatomic) NSColor  *  color;
@property (strong, nonatomic) NSColor  *  customColor;
@property (strong, nonatomic) NSColor  *  labelColor;
@property (assign, nonatomic) NSNumber *  labelNumber;
@property (strong, nonatomic) NSArray  *  colors;
@property (strong, nonatomic) NSImage  *  image;
@property (nonatomic, readonly)	CGFloat	  hue;
@property (nonatomic, readonly)	BOOL	  hasLabel;

@property (nonatomic, assign)	AZWindowPosition		position;

+ (instancetype) dummy;
+ (instancetype) forAppNamed:		(NSString*)appName;
+ (instancetype) instanceWithPath:	(NSString *)path;
+ (instancetype) instanceWithImage:(NSImage *)image;
+ (instancetype) instanceWithColor:	(NSColor*)color;
	//+ (instancetype) instanceWithObject:(id)object;
- (void)setActualLabelColor:(NSColor *)aLabelColor;

@end

@interface AZDockItem : AZFile
+ (instancetype)instanceWithPath:(NSString *)path;
@property (nonatomic, assign) 	CGPoint		dockPoint;
@property (nonatomic, assign) 	CGPoint		dockPointNew;
@property (nonatomic, assign) 	NSUInteger	spot;
@property (nonatomic, assign) 	NSUInteger 	spotNew;
@property (nonatomic, readonly)	BOOL		isRunning;
@property (nonatomic, assign)	BOOL		needsToMove;
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

extern NSString *const AtoZFileUpdated;
	//@class AJSiTunesResult;
