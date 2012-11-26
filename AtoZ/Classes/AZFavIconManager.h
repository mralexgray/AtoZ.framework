//
//  DSFavIconFinder.h
//  DSFavIcon
//  Created by Fabio Pelosin on 04/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.

#import "AtoZ.h"


extern CGFloat screenScale(void);
extern CGSize sizeInPixels(UINSImage *image);


@class  AZFavIconCache;
/** DSFavIconManager is a complete solution for managing Favicons.*/
@interface AZFavIconManager : NSObject
/** Returns the shared singleton. */
+ (AZFavIconManager *) sharedInstance;
/** Placeholder image for favicons. Defaults to [UIImage imageNamed:@"favicon"]. */
@property (NATOM, STRNG) UINSImage *placehoder;
/** The DSFavIconCache instance used by the current manager. Defaults to [DSFavIconCache sharedCache] */
@property (NATOM, STRNG) AZFavIconCache *cache;

/** Wether requests for the icon of an URL already in the queue should be discarded (useful in tables). Defaults to false. */
@property BOOL discardRequestsForIconsWithPendingOperation;
/** Wether it should attempt to retrieve apple touch icons if the size of the favicon is less than 16 logical points. Defaults to false. */
@property BOOL useAppleTouchIconForHighResolutionDisplays;

/** Returns the image for an icon if it has already been downloaded.
 @param url   The URL for which the icon is requested.
 @return	  The icon or nil if the icon is not available in the cache.  */
- (UINSImage*)cachedIconForURL:(NSURL *)url;

/** Returns the image for an icon. If the icon has already been downloaded it is returned immediately.
		UIImageView *imageView;
		imageView.image = [[DSFavIconManager sharedInstance] iconForURL:url completionBlock:^(UIImage *icon) {
			imageView.image = icon;
		}];

 @param url			   The URL for which the icon is requested.
 @param downloadHandler   A handler to be called when and only if an icon is downloaded.
						  This handler is always called in the dispatch queue associated with the application’s main thread.
 @return				  The icon if it is already available, otherwise the placeholder image is returned.  */
- (UINSImage*)iconForURL:(NSURL *)url downloadHandler:(void (^)(UINSImage *icon))downloadHandler;
+ (UINSImage*)iconForURL:(NSURL *)url downloadHandler:(void (^)(UINSImage *icon))downloadHandler;

/** Cancels all the pending queues. */
- (void)cancelRequests;
/** Clears the caches (memory and disk) and cancels pending queues. */
- (void) clearCache;

-(NSArray*)defaultNames;

@end

typedef void (^DSFavIconOperationCompletionBlock)(UINSImage *icon);
typedef BOOL (^DSFavIconOperationAcceptanceBlock)(UINSImage *icon);
typedef BOOL (^DSFavIconOperationPreflightBlock)(NSURL *url);

extern NSString *const kDSFavIconOperationDidStartNetworkActivity;
extern NSString *const kDSFavIconOperationDidEndNetworkActivity;
extern NSData *UINSImagePNGRepresentation(UINSImage *image);

@interface AZFavIconOperation : NSOperation

@property (nonatomic, strong) NSURL *url;
@property (strong, nonatomic) NSArray *defaultNames;
@property (strong, nonatomic) NSString *relationshipsRegex;
@property (nonatomic, copy) DSFavIconOperationCompletionBlock completion;
@property (nonatomic, copy) DSFavIconOperationAcceptanceBlock acceptanceBlock;
@property (nonatomic, copy) DSFavIconOperationPreflightBlock  preFlightBlock;

+ (AZFavIconOperation*)operationWithURL:(NSURL*)url
					 relationshipsRegex:(NSString*)relationshipsRegex
						   defaultNames:(NSArray*)defaultNames
						completionBlock:(DSFavIconOperationCompletionBlock)completion;

@end

@interface AZFavIconCache : NSCache

+ (AZFavIconCache *)sharedCache;
- (UINSImage *)imageForKey:(NSString *)key;
- (void)setImage:(UINSImage *)image forKey:(NSString *)key;
- (void)removeAllObjects;//  builklt-in method

@property (nonatomic, retain) NSString *cacheDirectory;

@end