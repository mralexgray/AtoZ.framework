
//  AtoZiTunes.h
//  AtoZiTunes

//  Created by Alex Gray on 7/27/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.


#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AtoZ/AtoZ.h>
#import "AJSiTunesAPI.h"

@interface AtoZiTunes : BaseModel  <AJSiTunesAPIDelegate>//NSObject
//{
//	@private
//	NSArray *_searchResults;
//	AJSiTunesAPI *_iTunesAPIController;
//}
@property (nonatomic, retain) AJSiTunesAPI *iTunesAPIController;
@property (nonatomic, retain) NSArray *searchResults;
+ (NSArray*) resultsForName:(NSString*)name;
//- (NSString *)stringFromClass;


@end
