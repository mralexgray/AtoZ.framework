//
//  AZFavIconFinder.h
//  AZFavIcon
//  Created by Fabio Pelosin on 04/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.

#import "AtoZ.h"

#if TARGET_OS_IPHONE
#define NSImage UIImage
#endif
extern CGSize sizeInPixels(NSIMG *image);

@class  AZFavIconCache;
@interface AZFavIconManager : NSObject								/** AZFavIconManager is a complete solution for managing Favicons.*/
+ (AZFavIconManager*) sharedInstance;
@property (NATOM,STRNG) NSIMG 			*placehoder;			/** Placeholder image for favicons. Defaults to [UIImage imageNamed:@"favicon"]. */
@property (NATOM,STRNG) AZFavIconCache *cache;					/** The AZFavIconCache instance used b current manager. Defaults to [AZFavIconCache sharedCache] */

/** Are requests for icons with URLs already in queue discarded? (useful in tables). Defaults to false. */
@property BOOL discardRequestsForIconsWithPendingOperation;
/** Wether should attempt to retrieve appletouchicons if the size of the favicon is < 16 logical points. Defaults to false. */
@property BOOL useAppleTouchIconForHighResolutionDisplays;
/** Returns the image for an icon if it has already been downloaded.
 @param url   The URL for which the icon is requested.
 @return	  The icon or nil if the icon is not available in the cache.  */
- (NSIMG*)cachedIconForURL:(NSURL*)url;
/** Returns the image for an icon. If the icon has already been downloaded it is returned immediately.
	UIImageView *imageView;		imageView.image = [[AZFavIconManager sharedInstance] iconForURL:url completionBlock:^(UIImage *icon) { imageView.image = icon;	 }];
	@param url			   			The URL for which the icon is requested.
	@param downloadHandler   		A handler to be called when and only if an icon is downloaded.
						  					This handler is always called in the dispatch queue associated with the application’s main thread.
 	@return				  				The icon if it is already available, otherwise the placeholder image is returned.  */
- (NSIMG*) iconForURL:(NSURL*)url downloadHandler:(void(^)(NSIMG*icon))downloadHandler;
+ (NSIMG*) iconForURL:(NSURL*)url downloadHandler:(void(^)(NSIMG*icon))downloadHandler;
- (void) cancelRequests;			/** Cancels all the pending queues. */
- (void) clearCache;					/** Clears the caches (memory and disk) and cancels pending queues. */
- (NSA*) defaultNames;
@end

typedef void (^AZFavIconOperationCompletionBlock) (NSIMG*icon);
typedef BOOL (^AZFavIconOperationAcceptanceBlock) (NSIMG*icon);
typedef BOOL (^AZFavIconOperationPreflightBlock)  (NSURL *url);

extern  NSS * const kAZFavIconOperationDidStartNetworkActivity;
extern  NSS * const kAZFavIconOperationDidEndNetworkActivity;

@interface AZFavIconOperation : NSOperation

@property (NATOM,STRNG) NSURL *url;
@property (NATOM,STRNG) NSA	*defaultNames;
@property (NATOM,STRNG) NSS	*relationshipsRegex;
@property (nonatomic, copy) AZFavIconOperationCompletionBlock completion;
@property (nonatomic, copy) AZFavIconOperationAcceptanceBlock acceptanceBlock;
@property (nonatomic, copy) AZFavIconOperationPreflightBlock  preFlightBlock;

+ (AZFavIconOperation*)operationWithURL:(NSURL*)url	relationshipsRegex:(NSS*)relationshipsRegex
								 defaultNames:(NSA*)defNames 	completionBlock:(AZFavIconOperationCompletionBlock)completion;
@end

@interface AZFavIconCache : NSCache
+ (AZFavIconCache*) sharedCache;
- (NSIMG*) imageForKey: (NSS*)key;
- (void)setImage:			(NSIMG*)image forKey:(NSS*)key;
- (void)removeAllObjects;//  builklt-in method
@property (nonatomic, retain) NSString *cacheDirectory;
@end