//  DSFavIconFinder.m
//  DSFavIcon
//  Created by Fabio Pelosin on 04/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.

#import "AZFavIconManager.h"

CGFloat screenScale(void) {
#if TARGET_OS_IPHONE
	return [UIScreen mainScreen].scale;
#else
	return [NSScreen mainScreen].backingScaleFactor;
#endif
}

CGSize sizeInPixels(UINSImage *icon) {
	CGSize size = icon.size;
	#if TARGET_OS_IPHONE
	size.width *= icon.scale;
	size.height *= icon.scale;
	#endif
	return size;
}


@interface AZFavIconManager ()
@property (STRNG,NATOM) NSOperationQueue *operationQue;
@property (STRNG,NATOM) NSMutableDictionary *operationsPerURL;
@end

@implementation AZFavIconManager

#pragma mark - Initialization
+ (AZFavIconManager*)sharedInstance
{
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^{  sharedInstance = [self new]; });
	return sharedInstance;
}

- (id)init
{
	 if (!(self = [super init])) return nil;
	_cache = [AZFavIconCache sharedCache];
	_operationQue = [[NSOperationQueue alloc] init];
	_operationQue.maxConcurrentOperationCount = 20;
	_operationsPerURL = [NSMD new];
	_placehoder = [NSIMG monoIconNamed:@"130"];
	_discardRequestsForIconsWithPendingOperation = YES;
	_useAppleTouchIconForHighResolutionDisplays  = NO;
	return self;
}


#pragma mark - Public methods

- (void)cancelRequests {	[_operationQue cancelAllOperations]; _operationsPerURL = [NSMutableDictionary new]; }

- (void)clearCache {		[self cancelRequests];				[_cache removeAllObjects];						}

- (BOOL)hasOperationForURL:(NSURL*)url {	return [_operationsPerURL objectForKey:url] != nil;					}

- (UINSImage*)cachedIconForURL:(NSURL *)url {	return [_cache imageForKey:[self keyForURL:url]];				}


+ (UINSImage*)iconForURL:(NSURL *)url downloadHandler:(void (^)(UINSImage *icon))downloadHandler
{

	return [[AZFavIconManager sharedInstance] iconForURL:url downloadHandler:downloadHandler];
}

- (UINSImage*)iconForURL:(NSURL *)url downloadHandler:(void (^)(UINSImage *icon))downloadHandler
{
	UINSImage *cachedImage = [_cache imageForKey:[self keyForURL:url]];//[self cachedIconForURL:url];
	if (cachedImage) 																			return cachedImage;
	if (_discardRequestsForIconsWithPendingOperation && [_operationsPerURL objectForKey:url]) 	return _placehoder;

	DSFavIconOperationCompletionBlock completionBlock = ^(UINSImage *icon) {
		if (icon) {
			[_operationsPerURL removeObjectForKey:url];
			[_cache setImage:icon forKey:[self keyForURL:url]];
			dispatch_async(dispatch_get_main_queue(), ^{  downloadHandler(icon); });
		}
	};
	AZFavIconOperation *op = [AZFavIconOperation operationWithURL:url
											   relationshipsRegex:[self acceptedRelationshipAttributesRegex]
													 defaultNames:[self defaultNames]
												  completionBlock:completionBlock];

	// Prevent starting an operation for an icon that has been downloaded in the meanwhile.
	op.preFlightBlock = ^BOOL (NSURL *url) {
		UINSImage *icon = [self cachedIconForURL:url];
		if (icon) {
			dispatch_async(dispatch_get_main_queue(), ^{ downloadHandler(icon); });
			return false;
		} else
			return true;
	};
	op.acceptanceBlock = ^BOOL (UINSImage *icon) {
		CGSZ size 		   = sizeInPixels(icon);
		return size.width >= (16 * screenScale()) && size.height >= (16.f * screenScale());
	};

	[_operationsPerURL setObject:op forKey:url];
	[_operationQue  addOperation:op];
	return self.placehoder;
}
#pragma mark - Private methods

- (NSString*)keyForURL:(NSURL *)url {	return [url host];	}


- (NSS *)acceptedRelationshipAttributesRegex {
//	NSArray *array = @[ @"shortcut icon", @"icon" ];
//	if (_useAppleTouchIconForHighResolutionDisplays && screenScale() > 1.f) {
//		array = @[ @"shortcut icon", @"icon", @"apple-touch-icon" ];
//	} else {
//		array = @[ @"shortcut icon", @"icon" ];
//	}
//	return [@[@"shortcut icon", @"icon", @"apple-touch-icon" ] componentsJoinedByString:@"|"];
	return @"icon|apple-touch-icon";// ] componentsJoinedByString:@"|"];
}

-(NSArray*)defaultNames;
{
	static NSA *_defNames = nil;
		//  if (_useAppleTouchIconForHighResolutionDisplays && screenScale() > 1.f) {
	return _defNames = _defNames ?: @[ @"apple-touch-icon-precomposed.png", @"apple-touch-icon.png", @"touch-icon-iphone.png", @"favicon.ico"].copy;
	//	} else {
		//		return @[ @"apple-touch-icon.png"];//favicon.ico" ];
		//	}
}

@end

//  DSFavIconOperation.m
//  DSFavIcon
//  Created by Fabio Pelosin on 05/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//	#import "DSFavIconOperation.h"

NSS *const kDSFavIconOperationDidStartNetworkActivity = @"kDSFavIconOperationDidStartNetworkActivity";
NSS *const kDSFavIconOperationDidEndNetworkActivity   = @"kDSFavIconOperationDidEndNetworkActivity";

@implementation AZFavIconOperation

+ (AZFavIconOperation*)operationWithURL: (NSURL*)url
					 relationshipsRegex: (NSS*)relationshipsRegex
						   defaultNames: (NSA*)defaultNames
						completionBlock: (DSFavIconOperationCompletionBlock)completion;
{
	AZFavIconOperation* result 	= [self new];
	result.url 					= url;
	result.relationshipsRegex 	= relationshipsRegex;
	result.defaultNames		 	= defaultNames;
	result.completion 			= completion;
	return result;
}

- (BOOL)isIconValid:(UINSImage*)icon {	return _acceptanceBlock ? icon != nil && _acceptanceBlock(icon) : icon != nil; }

- (void)main
{
	if (self.isCancelled)                             return;
	if (_preFlightBlock ) if (!_preFlightBlock(_url)) return;

	UINSImage *icon = [self searchURLForImages:_url withNames:_defaultNames];

	if (![self isIconValid:icon] && !self.isCancelled) {
		NSURLRequest *request = [NSURLRequest requestWithURL:_url];
		NSURLResponse *response;

		[AZNOTCENTER postNotificationName:kDSFavIconOperationDidStartNetworkActivity object:self];
		NSData *htmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		[AZNOTCENTER postNotificationName:kDSFavIconOperationDidEndNetworkActivity object:self];

		icon = ![self isIconValid:icon] && !self.isCancelled ? [self searchURLForImages:response.URL withNames:_defaultNames] ?: icon :
			   ![self isIconValid:icon] && !self.isCancelled ? [self iconFromHTML:htmlData textEncodingName:response.textEncodingName url:response.URL] : icon;
	}
	_completion(icon);
}

- (UINSImage*)searchURLForImages:(NSURL *)url withNames:(NSArray *)names
{
	__block UINSImage *icon;
	NSURL *baseURL = [NSURL URLWithString:$(@"%@://%@", [url scheme], [url host])];
	[names enumerateObjectsUsingBlock:^(NSS *iconName, NSUInteger idx, BOOL *stop) {
		if (!self.isCancelled) {
			NSURL *iconURL = [NSURL URLWithString:iconName relativeToURL:baseURL];
			[AZNOTCENTER postNotificationName:kDSFavIconOperationDidStartNetworkActivity object:self];
			NSData *data = [NSData dataWithContentsOfURL:iconURL];
			[AZNOTCENTER postNotificationName:kDSFavIconOperationDidEndNetworkActivity object:self];
			UINSImage *newIcon = [[UINSImage alloc] initWithData:data];
			if (newIcon) {
				icon = newIcon;
				*stop = [self isIconValid:icon];
			}
		} else *stop = YES;
	}];
	return icon;
};

- (UINSImage*)iconFromHTML:(NSData*)htmlData textEncodingName:(NSS*)textEncodingName url:(NSURL*)url
{
	__block NSS *html;
	if (textEncodingName) {
		CFStringEncoding cfencoding 	= CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)textEncodingName);
		NSStringEncoding encoding 		= CFStringConvertEncodingToNSStringEncoding(cfencoding);
		html = [[NSS alloc] initWithData:htmlData encoding:encoding];
	}
	if (!html) {
		// As the reported encoded might be incorrect we try the common ones if there is not html
		[@[@(NSUTF8StringEncoding),@(NSISOLatin1StringEncoding),@(NSUTF16StringEncoding),@(NSISOLatin2StringEncoding)] enumerateObjectsUsingBlock:^(NSNumber *encoding, NSUInteger idx, BOOL *stop) {
			html = [[NSS alloc] initWithData:htmlData encoding:[encoding integerValue]];
			*stop = (html != nil);
		}];
	}

	NSS *quotes		 	= @"(?:\"|')";
	NSS *rel_pattern	= [NSS stringWithFormat:@"rel=%@(%@)%@", quotes, _relationshipsRegex, quotes];
	NSS *link_pattern	= [NSS stringWithFormat:@"<link[^>]*%@[^>]*/?>", rel_pattern];
	NSRegularExpression *link_tag_regex   = [NSRegularExpression regularExpressionWithPattern:link_pattern options:NSRegularExpressionCaseInsensitive error:nil];

	__block UINSImage *icon;
	[link_tag_regex enumerateMatchesInString:html options:0 range:NSMakeRange(0, html.length) usingBlock:^(NSTextCheckingResult *link_tag_result, NSMatchingFlags flags, BOOL *stop) {
		if (!self.isCancelled) {
			NSS *link_tag				= [html substringWithRange:link_tag_result.range];
			NSS *href_pattern			= $(@"href=%@([^\"']*)%@", quotes, quotes);
			NSRegularExpression *href_regex   = [NSRegularExpression regularExpressionWithPattern:href_pattern options:NSRegularExpressionCaseInsensitive error:nil];
			NSTextCheckingResult* href_result = [href_regex firstMatchInString:link_tag options:0 range:NSMakeRange(0, link_tag.length)];
			NSS *href_value = [link_tag substringWithRange:[href_result rangeAtIndex:1]];
			if (href_value) {
				NSURL* iconURL = [NSURL URLWithString:href_value relativeToURL:url];
				[AZNOTCENTER postNotificationName:kDSFavIconOperationDidStartNetworkActivity object:self];
				NSData *data = [NSData dataWithContentsOfURL:iconURL];
				[AZNOTCENTER postNotificationName:kDSFavIconOperationDidEndNetworkActivity object:self];
				if (data)
				{
					UINSImage   *newIcon = [[UINSImage alloc] initWithData:data];
					if (newIcon) {	icon = newIcon;
						           *stop = [self isIconValid:icon];	}
				}
			}
		} else	*stop = true;
	}];
	return icon;
}

@end


NSData *UINSImagePNGRepresentation(UINSImage *image) {
#if TARGET_OS_IPHONE
	return UIImagePNGRepresentation(image);
#else
	NSBitmapImageRep *bitmapRep;
	[image lockFocus];
 	bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
	[image unlockFocus];
	return [bitmapRep representationUsingType:NSPNGFileType properties:Nil];

//	return [bitmapRep representationUsingType:NSPNGFileType properties:Nil];
//	CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)[image TIFFRepresentation], NULL);
//	CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
//	CGImageRef copyImageRef = CGImageCreateCopyWithColorSpace (imageRef, CGColorSpaceCreateDeviceRGB());
//	if (copyImageRef == NULL) {
//		// The color space of the image likely to be indexed.
//		CGRect imageRect  = CGRectMake(0, 0, image.size.width, image.size.height);
//		NSUInteger width  = CGImageGetWidth(imageRef);
//		NSUInteger height = CGImageGetHeight(imageRef);
//		CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
//		CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
//		CGContextDrawImage(context, imageRect, imageRef);
//		copyImageRef = CGBitmapContextCreateImage(context);
//	}
//
//	NSMutableData *data = [NSMutableData new];
//	CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)(data), kUTTypePNG, 1, NULL);
//	CGImageDestinationAddImage(destination, copyImageRef, nil);
//	CGImageDestinationFinalize(destination);
//
//	CFRelease(sourceRef);
//	CGImageRelease(imageRef);
//	CGImageRelease(copyImageRef);
//	return data;
#endif
}

@interface  AZFavIconCache ()
@property (assign, nonatomic) dispatch_queue_t queue;
@property (nonatomic, retain) NSFileManager *fileManager;
@end

@implementation AZFavIconCache

+ (AZFavIconCache *)sharedCache
{
	static AZFavIconCache *sharedCache = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{		sharedCache = [self new];	});
	return sharedCache;
}

- (id)init
{
	if (!(self = [super init])) return nil;
	_queue 		 	= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
	_fileManager 	= [NSFileManager defaultManager];
	_cacheDirectory = LogAndReturn([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
						  							 stringByAppendingPathComponent:@"/com.mrgray.atoz.favicons"]);
	if (![_fileManager fileExistsAtPath:_cacheDirectory]) [_fileManager createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	return self;
}

- (void)removeAllObjects
{
	[_fileManager      removeItemAtPath:_cacheDirectory error:nil];
	[_fileManager createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	[super removeAllObjects];
}

- (UINSImage*)imageForKey:(NSS*)key
{
//	if (![self hasPropertyForKVCKey:@"key"]) return nil;
	UINSImage *image = [self objectForKey:key];
	if (!image) {
		NSS *path = [self pathForImage:image key:key];
		image = [[UINSImage alloc] initWithContentsOfFile:path];
		if (image) [self setObject:image forKey:key];
	}
	return image ?: nil;
}

- (void)setImage:(UINSImage *)image forKey:(NSS*)key
{
	if (!image || !key)	return;
	[self setObject:image forKey:key];
	dispatch_async(_queue, ^{
		NSS *path = [self pathForImage:image key:key];
//		NSLog(@"%@", path);
		[image saveAs:path];
//		NSData *imageData = UINSImagePNGRepresentation(image);
//		if (imageData) [imageData writeToFile:path atomically:NO];
	});
}

#pragma mark - Private Methods

- (NSS*)pathForImage:(UINSImage*)image key:(NSS*)key
{
	NSS*path = key;
#if TARGET_OS_IPHONE
	if (image.scale == 2.0f)	 path = [key stringByAppendingString:@"@2x"];
#endif
	path = [key stringByAppendingString:@".png"];
	return [_cacheDirectory stringByAppendingPathComponent:path];
}

@end

