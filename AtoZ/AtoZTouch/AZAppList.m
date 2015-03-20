
#import "AZAppList.h"

#import <ImageIO/ImageIO.h>
#import <SpringBoard/SpringBoard.h>
#import <CaptainHook/CaptainHook.h>
#import <dlfcn.h>
#import <CoreGraphics/CoreGraphics.h>
#import <libkern/OSAtomic.h>

#define ROCKETBOOTSTRAP_LOAD_DYNAMIC
#import "LightMessaging/LightMessaging.h"

CHDeclareClass(SBApplicationController);
CHDeclareClass(SBIconModel);
CHDeclareClass(SBIconViewMap);

@interface SBIconViewMap : NSObject { SBIconModel *_model; } _RO SBIconModel* iconModel; + _Kind_ switcherMap; + _Kind_ homescreenMap; @end

@interface UIImage (Private)
+ _Kind_ _applicationIconImageForBundleIdentifier:_Text_ bid                         format:(int)fmt scale:_Flot_ s;
+ _Kind_ _applicationIconImageForBundleIdentifier:_Text_ bid roleIdentifier:_Text_ _ format:(int)fmt scale:_Flot_ s;
@end

Text *const ALIconLoadedNotification = @"ALIconLoadedNotification",
     *const ALDisplayIdentifierKey   = @"ALDisplayIdentifier",
     *const ALIconSizeKey            = @"ALIconSize";

enum {  ALMessageIdGetApplications, ALMessageIdIconForSize, ALMessageIdValueForKey,
        ALMessageIdValueForKeyPath, ALMessageIdGetApplicationCount
};

static LMConnection connection = { MACH_PORT_NULL, "applist.datasource" };

@interface SBIconModel ()

- (SBApplicationIcon *)applicationIconForDisplayIdentifier:(NSString *)displayIdentifier;

@end

__attribute__((visibility("hidden"))) @interface AZAppListImpl : AZAppList @end

static AZAppList *sharedApplicationList;

typedef NS_ENUM(int, LADirectAPI) {
	LADirectAPINone,
	LADirectAPIApplicationIconImageForBundleIdentifier,
	LADirectAPIApplicationIconImageForBundleIdentifierRoleIdentifier
};

static LADirectAPI supportedDirectAPI;

@implementation AZAppList { @private NSMutableDictionary *cachedIcons; OSSpinLock spinLock; }

+ (instancetype) list { static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    if (self == [AZAppList class] && !CHClass(SBIconModel)) sharedApplicationList = [[self alloc] init];
  });
  return sharedApplicationList;
}

extern CFTypeRef MGCopyAnswer(CFStringRef query) __attribute__((weak_import));

static BOOL IsIpad(void) {

	BOOL result = NO;
	if (&MGCopyAnswer != NULL) {
		CFNumberRef answer = MGCopyAnswer(CFSTR("ipad"));
		if (answer) {
			result = [(id)answer boolValue];
			CFRelease(answer);
		}
	}
	return result;
}

- init { if (!(self = super.init)) return nil;

  if (sharedApplicationList) {
    [self release];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Only one instance of AZAppList is permitted at a time! Use [AZAppList sharedApplicationList] instead." userInfo:nil];
  }
  @autoreleasepool {
    cachedIcons = @{}.mutableCopy;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didReceiveMemoryWarning)
                                               name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
  }
  if ([UIImage respondsToSelector:@selector(_applicationIconImageForBundleIdentifier:format:scale:)]) {

    // Workaround iOS 7's fake retina mode bugs on iPad
    if ((kCFCoreFoundationVersionNumber < 800.00) || (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) || !IsIpad())
      supportedDirectAPI = LADirectAPIApplicationIconImageForBundleIdentifier;
  } else if ([UIImage respondsToSelector:@selector(_applicationIconImageForBundleIdentifier:roleIdentifier:format:scale:)])
    supportedDirectAPI = LADirectAPIApplicationIconImageForBundleIdentifierRoleIdentifier;

	return self;
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
	[cachedIcons release];
	[super dealloc];
}

- (NSInteger)applicationCount { LMResponseBuffer buffer;

	return (LMConnectionSendTwoWay(&connection, ALMessageIdGetApplicationCount, NULL, 0, &buffer)) ? 0 : LMResponseConsumeInteger(&buffer);
}

- (NSString*) description {
	return [NSString stringWithFormat:@"<AZAppList: %p applicationCount=%ld>", self, (long)self.applicationCount];
}

- (void)didReceiveMemoryWarning {
	OSSpinLockLock(&spinLock);
	[cachedIcons removeAllObjects];
	OSSpinLockUnlock(&spinLock);
}

- (NSDictionary*) apps { return [self appsFilteredUsingPredicate:nil]; }

- (NSDictionary*) appsFilteredUsingPredicate:(NSPredicate*)predi { LMResponseBuffer buffer; id result;

	return (LMConnectionSendTwoWayData(&connection, ALMessageIdGetApplications,
                                    (CFDataRef)[NSKeyedArchiver archivedDataWithRootObject:predi], &buffer)) ? nil :

  [(result = LMResponseConsumePropertyList(&buffer)) isKindOfClass:NSDictionary.class] ? result : nil;
}

- valueForKeyPath:(NSString*)kp forDisplayIdentifier:(NSString*)displayID { LMResponseBuffer buffer;

	return !kp || !displayID ? nil :

	 (LMConnectionSendTwoWayPropertyList(&connection, ALMessageIdValueForKeyPath, @{                @"key": kp,
                                                                                      @"displayIdentifier": displayID}, &buffer)) ? nil :
         LMResponseConsumePropertyList(&buffer);
}

- valueForKey:(NSString*)key forDisplayIdentifier:(NSString *)displayID { 	LMResponseBuffer buffer;

  return !key || !displayID ? nil :

  (LMConnectionSendTwoWayPropertyList(&connection, ALMessageIdValueForKey, @{@"key": key, @"displayIdentifier": displayID}, &buffer)) ? nil

    :   LMResponseConsumePropertyList(&buffer);
}

- (void)postNotificationWithUserInfo:(NSDictionary *)userInfo {

	[NSNotificationCenter.defaultCenter postNotificationName:ALIconLoadedNotification object:self userInfo:userInfo];
}

- (CGImageRef)copyIconOfSize:(AZAppIconSize)iconSize forDisplayIdentifier:(NSString *)displayIdentifier
{
	if (iconSize <= 0)
		return NULL;
	NSString *key = [displayIdentifier stringByAppendingFormat:@"#%f", (CGFloat)iconSize];
	OSSpinLockLock(&spinLock);
	CGImageRef result = (CGImageRef)cachedIcons[key];
	if (result) {
		result = CGImageRetain(result);
		OSSpinLockUnlock(&spinLock);
		return result;
	}
	OSSpinLockUnlock(&spinLock);
	if (iconSize == AZAppIconSizeSmall) {
		switch (supportedDirectAPI) {
			case LADirectAPINone:
				break;
			case LADirectAPIApplicationIconImageForBundleIdentifier:
				result = [UIImage _applicationIconImageForBundleIdentifier:displayIdentifier format:0 scale:[UIScreen mainScreen].scale].CGImage;
				if (result)
					goto skip;
				break;
			case LADirectAPIApplicationIconImageForBundleIdentifierRoleIdentifier:
				result = [UIImage _applicationIconImageForBundleIdentifier:displayIdentifier roleIdentifier:nil format:0 scale:[UIScreen mainScreen].scale].CGImage;
				if (result)
					goto skip;
				break;
		}
	}
	LMResponseBuffer buffer;
	if (LMConnectionSendTwoWayPropertyList(&connection, ALMessageIdIconForSize, @{@"iconSize": @(iconSize), @"displayIdentifier": displayIdentifier}, &buffer))
		return NULL;
	result = [LMResponseConsumeImage(&buffer) CGImage];
	if (!result)
		return NULL;
skip:
	OSSpinLockLock(&spinLock);
	cachedIcons[key] = (id)result;
	OSSpinLockUnlock(&spinLock);
	NSDictionary *userInfo = @{ALIconSizeKey: @(iconSize),
	                          ALDisplayIdentifierKey: displayIdentifier};
	if ([NSThread isMainThread])
		[self postNotificationWithUserInfo:userInfo];
	else
		[self performSelectorOnMainThread:@selector(postNotificationWithUserInfo:) withObject:userInfo waitUntilDone:YES];
	return CGImageRetain(result);
}

- (UIImage *)iconOfSize:(AZAppIconSize)iconSize forDisplayIdentifier:(NSString *)displayIdentifier
{
	CGImageRef image; if (!(image = [self copyIconOfSize:iconSize forDisplayIdentifier:displayIdentifier])) return nil;

	UIImage *result = [UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)] ?
                    [UIImage imageWithCGImage:image scale:(CGImageGetWidth(image) + CGImageGetHeight(image)) /
                                                          (CGFloat)(iconSize + iconSize) orientation:0] :
                    [UIImage imageWithCGImage:image];

	CGImageRelease(image);
	return result;
}

- (BOOL)hasCachedIconOfSize:(AZAppIconSize)iconSize forDisplayIdentifier:(NSString*)displayIdentifier {
	NSString *key = [displayIdentifier stringByAppendingFormat:@"#%f", (CGFloat)iconSize];
	OSSpinLockLock(&spinLock);
	id result = cachedIcons[key];
	OSSpinLockUnlock(&spinLock);
	return result != nil;
}

@end

@implementation AZAppListImpl

static void   processMessage(SInt32 messageId, mach_port_t replyPort, CFDataRef data) {
	switch (messageId) {
		case ALMessageIdGetApplications: {
			NSDictionary *result;
			if (data && CFDataGetLength(data)) {
				NSPredicate *predicate = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)data];
				@try {
					result = ISA(predicate,NSPredicate) ? [sharedApplicationList appsFilteredUsingPredicate:predicate] : [sharedApplicationList applications];
				}
				@catch (NSException *exception) {
					NSLog(@"AppList: In call to appsFilteredUsingPredicate:%@ trapped %@", predicate, exception);
					break;
				}
			} else {
				result = [sharedApplicationList applications];
			}
			LMSendPropertyListReply(replyPort, result);
			return;
		}
		case ALMessageIdIconForSize: {

			if (!data) break;

			NSDictionary *params = [NSPropertyListSerialization propertyListFromData:(NSData *)data mutabilityOption:0 format:NULL errorDescription:NULL];

			if (![params isKindOfClass:NSDictionary.class]) break;

      id iconSize = params[@"iconSize"];

      if (![iconSize respondsToSelector:@selector(floatValue)]) break;

			NSString *displayIdentifier = params[@"displayIdentifier"];

			if (![displayIdentifier isKindOfClass:[NSString class]]) break;

			CGImageRef result = [sharedApplicationList copyIconOfSize:[iconSize floatValue] forDisplayIdentifier:displayIdentifier];

      if (result) {

				LMSendImageReply(replyPort, [UIImage imageWithCGImage:result]);
				return CGImageRelease(result);
			}
			break;
		}
		case ALMessageIdValueForKeyPath:
		case ALMessageIdValueForKey: {
			if (!data)
				break;
			NSDictionary *params = [NSPropertyListSerialization propertyListFromData:(NSData *)data mutabilityOption:0 format:NULL errorDescription:NULL];
			if (![params isKindOfClass:[NSDictionary class]])
				break;
			NSString *key = params[@"key"];
			Class stringClass = [NSString class];
			if (![key isKindOfClass:stringClass])
				break;
			NSString *displayIdentifier = params[@"displayIdentifier"];
			if (![displayIdentifier isKindOfClass:stringClass])
				break;
			id result;
			@try {
				result = messageId == ALMessageIdValueForKeyPath ? [sharedApplicationList valueForKeyPath:key forDisplayIdentifier:displayIdentifier] : [sharedApplicationList valueForKey:key forDisplayIdentifier:displayIdentifier];
			}
			@catch (NSException *exception) {
				NSLog(@"AppList: In call to valueForKey%s:%@ forDisplayIdentifier:%@ trapped %@", messageId == ALMessageIdValueForKeyPath ? "Path" : "", key, displayIdentifier, exception);
				break;
			}
			LMSendPropertyListReply(replyPort, result);
			return;
		}
		case ALMessageIdGetApplicationCount: {
			LMSendIntegerReply(replyPort, [sharedApplicationList applicationCount]);
			return;
		}
	}
	LMSendReply(replyPort, NULL, 0);
}
static void machPortCallback(CFMachPortRef port, void*bytes, CFIndex size, void*info) {
	LMMessage *request = bytes;
	if (size < sizeof(LMMessage)) {
		LMSendReply(request->head.msgh_remote_port, NULL, 0);
		LMResponseBufferFree(bytes);
		return;
	}
	// Send Response
	const void     * data = LMMessageGetData(request);
	size_t         length = LMMessageGetDataLength(request);
	mach_port_t replyPort = request->head.msgh_remote_port;
	CFDataRef      cfdata = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, data ?: &data, length, kCFAllocatorNull);

	processMessage(request->head.msgh_id, replyPort, cfdata);

	if (cfdata) CFRelease(cfdata);

	LMResponseBufferFree(bytes);
}

- init {

	if (!(self = [super init])) return nil;
  kern_return_t err;
  if ((err  = LMStartService(connection.serverName, CFRunLoopGetCurrent(), machPortCallback)))
    NSLog(@"AppList: Unable to register mach server with error %x", err);
	return self;
}

- (NSDictionary *)apps {

	NSMutableDictionary *result = @{}.mutableCopy;
	for (SBApplication *app in CHSharedInstance(SBApplicationController).allApplications)
		result[app.displayIdentifier.description] = app.displayName.description;
	return result;
}

- (NSInteger) appCount { return CHSharedInstance(SBApplicationController).allApplications.count; }

- (NSDictionary *)appsFilteredUsingPredicate:(NSPredicate *)predicate
{
	NSMutableDictionary *result = @{}.mutableCopy;

	NSArray *apps = CHSharedInstance(SBApplicationController).allApplications;

  apps = !predicate ? apps : [apps filteredArrayUsingPredicate:predicate];

	for (SBApplication *app in apps) result[app.displayIdentifier.description] = app.displayName.description;
	return result;
}

- valueForKeyPath:(NSString*)kp forDisplayIdentifier:(NSString *)displayID {

	return [/* SBApplication */ [CHSharedInstance(SBApplicationController) applicationWithDisplayIdentifier:displayID] valueForKeyPath:kp];
}

- valueForKey:(NSString*)kp forDisplayIdentifier:(NSString *)displayID {

	return [/* SBApplication */ [CHSharedInstance(SBApplicationController) applicationWithDisplayIdentifier:displayID] valueForKey:kp];
}

- (CGImageRef)copyIconOfSize:(AZAppIconSize)iconSize forDisplayIdentifier:(NSString *)displayIdentifier
{

	SBIconModel *iconModel = [CHClass(SBIconViewMap) instancesRespondToSelector:@selector(iconModel)] ?
                           [[CHClass(SBIconViewMap) homescreenMap] iconModel] :
                           CHSharedInstance(SBIconModel);

  SBIcon *icon = [iconModel respondsToSelector:@selector(applicationIconForDisplayIdentifier:)] ?
                 [iconModel applicationIconForDisplayIdentifier:displayIdentifier] :
                 [iconModel respondsToSelector:@selector(iconForDisplayIdentifier:)] ?
                 [iconModel iconForDisplayIdentifier:displayIdentifier] : NULL;

  if (icon == NULL) return NULL;

	UIImage * image;
	BOOL  getIconImage = [icon respondsToSelector:@selector(getIconImage:)];
	SBApplication *app = [CHSharedInstance(SBApplicationController) applicationWithDisplayIdentifier:displayIdentifier];

	if (iconSize <= AZAppIconSizeSmall) {

		if ((image = getIconImage ? [icon getIconImage:0] : [icon smallIcon])) goto finish;

		if ([app respondsToSelector:@selector(pathForSmallIcon)]) {

			if ((image = [UIImage imageWithContentsOfFile:[app pathForSmallIcon]])) goto finish;
		}
	}

	if ((image = getIconImage ? [icon getIconImage:(kCFCoreFoundationVersionNumber >= 675.0) ? 2 : 1] : icon.icon)) goto finish;

	if ([app respondsToSelector:@selector(pathForIcon)]) image = [UIImage imageWithContentsOfFile:app.pathForIcon];

  if (!image) return NULL;

finish:
	return CGImageRetain(image.CGImage);
}

@end

CHConstructor
{
	CHAutoreleasePoolForScope();
	if (CHLoadLateClass(SBIconModel)) {
		CHLoadLateClass(SBIconViewMap);
		CHLoadLateClass(SBApplicationController);
		sharedApplicationList = [[AZAppListImpl alloc] init];
	}
}
