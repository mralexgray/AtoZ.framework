//
//  GIF.h
//  GIFs
//
//  Created by orta therox on 12/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@class GIF;
@protocol ORGIFSource <NSObject>

- (void) setTumblrURLOrSearchString:(NSString*)_;
- (void) gotGIF:(void(^)(GIF*))block;
//- (void) getNextGIFs;
//- (NSInteger) numberOfGifs;
//- (GIF*) gifAtIndex:(NSInteger)index;

@end


@interface GIF : NSObject <NSCoding>

- (id)initWithRedditDictionary:(NSDictionary *)dictionary;
- (id)initWithDownloadURL:(NSString *)downloadURL thumbnail:(NSString *)thumbnail andSource:(NSString *)source;

- (NSString *)imageUID;
- (NSString *)imageRepresentationType;

- (id) imageRepresentation;
- (NSURL *)downloadURL;
- (NSURL *)sourceURL;

@property (strong) NSDate *dateAdded;

@end
