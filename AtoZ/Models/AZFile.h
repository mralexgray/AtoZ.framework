//
//  AZFile.h
//  AtoZ
//
//  Created by Alex Gray on 9/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.

//	@property (weak)	id itunesDescription;
//	@property (weak)	id itunesResults;
//	@property (nonatomic, strong)	AJSiTunesResult *itunesInfo;
//	@property (nonatomic, strong)  	NSImage	 * 	icon;

//#import "AtoZ.h"
#import "AZObject.h"
#import "AtoZUmbrella.h"


@interface AZFile : BaseModel

@property (nonatomic, strong) NSString *  calulatedBundleID;
@property (nonatomic, strong) NSString *  path;
@property (nonatomic, strong) NSString *  name;
@property (nonatomic, strong) NSColor  *  color;
@property (nonatomic, strong) NSColor  *  customColor;
@property (nonatomic, strong) NSColor  *  labelColor;
@property (nonatomic, assign) NSNumber *  labelNumber;
@property (nonatomic, strong) NSArray  *  colors;
@property (nonatomic, strong) NSImage  *  image;
@property (nonatomic, assign)	CGFloat	  hue;
@property (nonatomic, readonly)	BOOL	  hasLabel;
@property (nonatomic, assign)	AZWindowPosition		position;

+ (instancetype) instanceWithName: 	(NSString*) appName;
+ (instancetype) instanceWithPath:	(NSString*) path;
+ (instancetype) instanceWithImage:	(NSImage*)  image;
+ (instancetype) instanceWithColor:	(NSColor*)  color;
- (void)setActualLabelColor:(NSColor *)aLabelColor;
@end

@interface AZDockApp : BaseModel

+ (instancetype)instanceWithPath:(NSString *)path;

@property (nonatomic, assign) 	CGPoint		dockPoint;
@property (nonatomic, assign) 	CGPoint		dockPointNew;
@property (nonatomic, assign) 	NSUInteger	spot;
@property (nonatomic, assign) 	NSUInteger 	spotNew;
@property (readonly)			BOOL		isRunning;
@end
