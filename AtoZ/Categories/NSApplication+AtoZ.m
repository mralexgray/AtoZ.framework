
#import <AtoZ/AtoZ.h>
#import <AtoZUniversal/AtoZUniversal.h>
#import "NSApplication+AtoZ.h"

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#import <sys/xattr.h>
#else
#import <CoreServices/CoreServices.h>
#endif
#import <libkern/OSAtomic.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <unistd.h>
#import <dirent.h>
#import <sys/stat.h>


void SetDockIconImage(NSImage*i) { NSDockTile *dock = NSApplication.sharedApplication.dockTile; NSImageView *iv;

  dock.contentView  = iv = [NSImageView.alloc initWithFrame:(NSRect){0,0,512,512}];
  iv.imageScaling   = NSImageScaleProportionallyUpOrDown;
  iv.image          = i;   [dock display];
}

@implementation NSMenu (SBAdditions)

+ (INST) menuWithItems:(NSA*)items { NSMenu *m = self.new;  m.itemArray = items;  return m; }

- (void)   setItemArray:(NSA*)items { for (NSMI*m in items) [self addItem:m]; }

- (NSMI*) selectedItem {

	return [self.itemArray filterOne:^BOOL(NSMenuItem *item) { return [item state] == NSOnState; }];
}

- (void) selectItem:(NSMenuItem *)menuItem {

  [self.itemArray each:^(NSMenuItem *i){ [i setState:(i == menuItem ? NSOnState : NSOffState)]; }];
}

- (NSMI*) selectItemWithRepresentedObject: representedObject {

	NSMenuItem *selectedItem = nil;
	for (NSMenuItem *item in [self itemArray])
	{
		id repObject = [item representedObject];
		BOOL equal = (!repObject && !representedObject) || [repObject isEqualTo:representedObject];
		[item setState:(equal ? (selectedItem ? NSOffState : NSOnState) : NSOffState)];
		if (equal)
		{
			if (!selectedItem)
				selectedItem = item;
		}
	}
	return selectedItem;
}

- (void) deselectItems {
	for (NSMenuItem *item in [self itemArray])
	{
		[item setState:NSOffState];
	}
}

- (NSMI*) addItemWithTitle:(NSS*)aString target:target action:(SEL)aSelector tag:(NSInteger)tag {

  NSMenuItem *item = NSMenuItem.new;
	[item setTitle:aString];
	[item setTarget:target];
	[item setAction:aSelector];
	[item setTag:tag];
	[self addItem:item];
	return item;
}

- (NSMI*) addItemWithTitle:(NSString *)aString representedObject:representedObject target:target action:(SEL)aSelector {
	NSMenuItem *item = [[NSMenuItem.alloc init] autorelease];
	[item setTitle:aString];
	[item setTarget:target];
	[item setAction:aSelector];
	[item setRepresentedObject:representedObject];
	[self addItem:item];
	return item;
}

@end

_Text const kShowDockIconUserDefaultsKey = @"ShowDockIcon";

@implementation NSApplication (AtoZ)

+ infoValueForKey:_Text_ key { return AZAPPBUNDLE.localizedInfoDictionary[key] ?: AZAPPBUNDLE.infoDictionary[key]; }

- _IsIt_ showsDockIcon { return [AZUSERDEFS bFK:kShowDockIconUserDefaultsKey]; }

	/** this should be called from the application delegate's applicationDidFinishLaunching method or from some controller object's awakeFromNib method neat dockless hack using Carbon from <a href="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it" title="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it">http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-...</a> */
	
- (void) setShowsDockIcon:(BOOL)flag {

	if (flag) {
		ProcessSerialNumber psn = { 0, kCurrentProcess };
		// display dock icon
		TransformProcessType(&psn, kProcessTransformToForegroundApplication);
		// enable menu bar
		SetSystemUIMode(kUIModeNormal, 0);

		// switch to Dock.app
		if ([[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil] == NO) {
			NSLog(@"Could not launch application with identifier 'com.apple.dock'.");
		}

		// switch back
		[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	}
}

- _IsIt_ launchAtLogin {

  LSSharedFileListItemRef loginItem = self.loginItem;

  BOOL result = loginItem ? YES : NO;

  if (loginItem) CFRelease(loginItem);

  return result;
}

- _Void_ setLaunchAtLogin:(BOOL)launchAtLogin {

  if (launchAtLogin == self.launchAtLogin) return;


  LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);

  if (launchAtLogin) {
    CFURLRef appUrl = (__bridge CFURLRef)[[NSBundle mainBundle] bundleURL];
    LSSharedFileListItemRef itemRef = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL,
                                                                    NULL, appUrl, NULL, NULL);
    if (itemRef) CFRelease(itemRef);

  } else {

    LSSharedFileListItemRef loginItem = self.loginItem;

    LSSharedFileListItemRemove(loginItemsRef, loginItem);
    if (loginItem != nil) CFRelease(loginItem);
  }

  if (loginItemsRef) CFRelease(loginItemsRef);
}

#pragma mark Private Login Item Shit

- (LSSharedFileListItemRef)loginItem {

  NSURL *bundleURL = AZAPPBUNDLE.bundleURL;

  LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);

  if (!loginItemsRef) return NULL;

  NSArray *loginItems = CFBridgingRelease(LSSharedFileListCopySnapshot(loginItemsRef, nil));

  LSSharedFileListItemRef result = NULL;

  for (id item in loginItems) {

    LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
    CFURLRef itemURLRef;

    if (LSSharedFileListItemResolve(itemRef, 0, &itemURLRef, NULL) == noErr) {
      NSURL *itemURL = (__bridge NSURL *)itemURLRef;

      if ([itemURL isEqual:bundleURL]) {
        result = itemRef;
        break;
      }
    }
  }

  if (result) CFRetain(result);
  CFRelease(loginItemsRef);

  return result;
}

@end



@implementation NSProcessInfo (Extensions)

// From http://developer.apple.com/mac/library/qa/qa2004/qa1361.html
- _IsIt_ isDebuggerAttached {
	struct kinfo_proc info;
	info.kp_proc.p_flag = 0;

	int mib[4];
	mib[0] = CTL_KERN;
	mib[1] = KERN_PROC;
	mib[2] = KERN_PROC_PID;
	mib[3] = getpid();
	size_t size = sizeof(info);
	int result = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);

	return !result && (info.kp_proc.p_flag & P_TRACED);  // We're being debugged if the P_TRACED flag is set
}

@end




@implementation NSWorkspace (SystemInfo)

+ (NSString*) systemVersion {
	SInt32 versionMajor, versionMinor, versionBugFix;

	OSErr maj = Gestalt(gestaltSystemVersionMajor, &versionMajor);
	OSErr min = Gestalt(gestaltSystemVersionMinor, &versionMinor);
	OSErr bug = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);

	if (maj != noErr || min != noErr || bug != noErr)
		return nil;

	return $(@"%d.%d.%d", versionMajor, versionMinor, versionBugFix);
}

@end


#import <Carbon/Carbon.h>
#import <objc/runtime.h>
#import <AtoZ/AtoZ.h>


@implementation NSControl (ActionBlock)

- (void) blockAct { if (self.actionBlock) self.actionBlock(self); }
- (void) setActionBlock:(void (^)(id x))actionBlock { objc_setAssociatedObject(self,  @selector(actionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

	self.target = self;
	self.action = @selector(blockAct);
}
- (void (^)(id x)) actionBlock { return FETCH; }
@end

#if __LP64__
// This method is not public in 64-bit, but still exists within the Carbon framework so we just declare it exists and link to Carbon.
extern void SetMenuItemProperty(	MenuRef	  menu,					MenuItemIndex item,
										  	OSType	  propertyCreator,	OSType		  propertyTag,
										  	ByteCount  propertySize,		const	void	  *propertyData);
#endif
@interface NSMenu (Private)
- _menuImpl; - (void)makeDark;
@end
// Menus have a private implementation object, which is "always" a NSCarbonMenuImpl instance.
// Private method which sets the Dark property
@protocol NSCarbonMenuImplProtocol <NSObject>
- (MenuRef)_principalMenuRef;
@end
// NSCarbonMenuImpl is a class, but since it's not public, using a prot. to get at the method we want works easily.
@interface NSMenuDarkMaker : NSObject		@end
// Helper class used to set darkness after the Carbon MenuRef has been created. (The MenuRef doesn't exist until tracking starts.)
@implementation NSMenuDarkMaker {	NSMenu *mMenu;		}
-   initWithMenu:(NSMenu *)menu	{ return self = super.init ? [AZNOTCENTER addObserver:self selector:@selector(beginTracking:)
																											  name:NSMenuDidBeginTrackingNotification object:mMenu = menu], self : nil;		}
- (void) dealloc;								{	mMenu = nil; [AZNOTCENTER removeObserver:self];	}
- (void) beginTracking:(NSNOT*)note		{		[mMenu makeDark];	}
@end
@implementation NSMenu (Dark)							static int MAKE_DARK_KEY;
- (void)setDark:(BOOL)isDark;	{

	isDark ? objc_setAssociatedObject(self, &MAKE_DARK_KEY, [NSMenuDarkMaker.alloc initWithMenu:self], OBJC_ASSOCIATION_RETAIN)
	:	objc_setAssociatedObject(self, &MAKE_DARK_KEY, nil, OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)dark						{	return objc_getAssociatedObject(self, &MAKE_DARK_KEY) != nil;	}
- (void)makeDark					{	// Make it dark

	id impl = [self _menuImpl];
	if ([impl respondsToSelector:@selector(_principalMenuRef)]) {	MenuRef m = [impl _principalMenuRef];
		if (m) {	char on = 1; SetMenuItemProperty(m, 0, 'dock', 'dark', 1, &on);	}
	}
	for (NSMenuItem *item in self.itemArray)	[item.submenu makeDark];	// Make all submenus dark too
}
@end
@implementation NSMenu (AtoZ)
+ (NSM*) menuWithTitlesAndActions:(NSString*)firstTitle,...{

	azva_list_to_nsarrayBLOCKSAFE(firstTitle, menus);
	NSA *titles = [menus filter:^BOOL(id object) {  return ISA(object,NSS.class); }];
	NSA *blocks = [menus arrayWithoutArray:titles];
	__block NSM *menu = NSMenu.new;
	[menu addItems:[titles map:^id(NSS*title){

		return [NSMI itemWithTitle:NSLocalizedString(title, nil)
						keyEquivalent:@"" block:[blocks normal:[titles indexOfObject:title]]];
	}]];
	return menu;
}
@end

@implementation NSMenuItem (AtoZ)
- initWithTitle:(NSString*)aString    target:target
         action:(SEL)aSelector keyEquivalent:(NSS*)keyEquivalent
                           representedObject:representedObject {
	if (!(self = super.init)) return self;
	[self setTitle:aString];
	[self setTarget:target];
	[self setAction:aSelector];
	[self setRepresentedObject:representedObject];
	[self setKeyEquivalent:keyEquivalent];

	return self;
}

SYNTHESIZE_ASC_CAST(actionBlock, setActionBlock, MItemBlk);

//@synthesizeAssociation(NSMenuItem,actionBlock)

//+ (void)initialize {
//
//	objc_msgSend(self, NSSelectorFromString(@"swizzleInstanceSelector:withNewSelector:"), @selector(action),@selector(swizzleAction));
//  [super initialize];
//}
//
//- (SEL) swizzleAction {
//	return !self.actionBlock ? [self swizzleAction] : [self setTarget:self], @selector(blockActionWrapper:);
//}

+ _Kind_ itemWithTitle:_Text_ title keyEquivalent:_Text_ key block:(MENUBLK)block {

  NSMenuItem *i = [self.alloc initWithTitle:title action:NULL keyEquivalent:key];
	i.target = i;
	i.action = @selector(act:);
	i.actionBlock = [block copy];
	return i;
}
//- (void)blockActionWrapper:(id)sender { self.actionBlock(self); }

//
//	objc_setAssociatedObject(self, @selector(menuAction:), nil, OBJC_ASSOCIATION_RETAIN);  //qBlockActionKey
//	if (block == nil) return    [self setTarget:nil],   [self setAction:NULL];
//	objc_setAssociatedObject(self, @selector(menuAction:), block, OBJC_ASSOCIATION_RETAIN);
//	[self setTarget:self];
//	[self setAction:@selector(menuAction:)];			//    objc_setAssociatedObject(self, qBlockActionKey, block, OBJC_ASSOCIATION_RETAIN);
//}



//-        (void) setActionBlock:(MItemBlk)blk { [self setAssociatedAction:blk]; }

//- (MenuItemBlock) associatedAction								{ return FETCH; }

//- (void) setAssociatedAction:(MItemBlk)blk { COPY(@selector(associatedAction), blk); }

+ (instancetype) menuWithTitle:(NSString*)tit key:(NSS*)k action:(id)blck {

	NSMenuItem *menu = [[self allocWithZone:[NSMenu menuZone]] initWithTitle:tit action:@selector(act:) keyEquivalent:k];
	[menu setTarget:menu];
	[menu setEnabled:YES];

	if (blck) menu.actionBlock = [blck copy]; return menu;
}
- (void) act:(NSMenuItem*)act {	if ([act actionBlock]) [act actionBlock](act); }
@end

