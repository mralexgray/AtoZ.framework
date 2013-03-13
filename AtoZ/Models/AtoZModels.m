	//
	//  AZDock.m
	//  AtoZ
	//
	//  Created by Alex Gray on 9/12/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import "AtoZModels.h"
#import "AtoZFunctions.h"


NSString *TagsDefaultsKey = @"tags";

@implementation Tweet
@synthesize screenNameString, createdAtDate, createdAtString, tweetTextString;

- (id)initWithJSON:(NSDictionary *)JSONObject;
{
	if (self != super.init ) return nil;
	self.screenNameString 			= 					  JSONObject [@"from_user"];
	NSDateFormatter *dateFormatter 	= [NSDateFormatter.alloc 	 initWithProperties:
									@{ 	@"dateFormat" : @"EEE, d LLL yyyy HH:mm:ss Z",
										@"timeStyle"  : @(NSDateFormatterShortStyle),
										@"dateStyle"  : 	@(NSDateFormatterShortStyle),
										@"doesRelativeDateFormatting": 	  @(YES) }];
	self.createdAtDate 	 = [dateFormatter dateFromString:JSONObject[@"created_at"]];
	self.createdAtString = [dateFormatter stringFromDate:    	self.createdAtDate];
	self.tweetTextString = 										JSONObject[@"text"];
    return self;
}

@end
	//
	//@dynamic  appCategories;// = _appCategories,
	//@dynamic  sortOrder;// = _sortOrder,
	//@dynamic  appFolderStrings;// = _appFolderStrings,
	//@dynamic  _dock;// = _dock,
	//@dynamic  dockSorted;// = _dockSorted,
	//@dynamic  appFolder;// = _appFolder,
	//@dynamic  appFolderSorted;// = _appFolderSorted;

@implementation SizeObj
@synthesize width, height;

+(id)forSize:(NSSize)sz{

	return [[self alloc]initWithSize:sz];
}
- (id)initWithSize:(NSSize)sz {
	if (self = [super init]) {
		width  = sz.width;
		height = sz.height;
	}
	return self;
}

- (NSSize)sizeValue {
	return NSMakeSize(width, height);
}
@end
