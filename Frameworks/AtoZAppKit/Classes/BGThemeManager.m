//
//  BGThemeManager.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/15/08.
//


#import "BGThemeManager.h"

BGTheme * _themeKeyDecode (BGHUDView *_self) { 	BGThemeManager *b = BGThemeManager.keyedManager;		 				
	NSString *_aThemeKey = [_self valueForKey:@"themeKey"] ?: nil;		 					
	return   (BGHUDView *)_aThemeKey ? [b themeForKey:_aThemeKey] : b.activeTheme;
}

@implementation BGThemeManager
@synthesize activeTheme = _activeTheme;


//- (NSArray*) themeArray { return [[self.class.sharedManager themes]valueForKeyPath:@"themeKey"];}
- (BGTheme *)themeForKey:(NSString *)key {
	static BGTheme * chosenTheme = nil;
	//Make sure the key exists before we try to return it
	if ([chosenTheme.themeKey isEqualToString:key]) return chosenTheme;
	[_themes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([key isEqualToString:[obj themeKey]]) {
			chosenTheme = obj;
			NSLog(@"*** used NEW theme for key:%@ ... %@ ***", key, chosenTheme);
			*stop = YES;
		}
	}];
	return chosenTheme;
}
- (void) setActiveTheme:(BGTheme *)activeTheme {
	_activeTheme = activeTheme; 
	[NCENTER postNotificationName:AZThemeDidUpdateNotification object:self userInfo:@{@"themeKey": _activeTheme.themeKey, @"baseColor":_activeTheme.baseColor}];
}
- (BGTheme*)activeTheme {  return _activeTheme = _activeTheme ?: [self themeForKey:@"AZFlatTheme"]; }

+ (instancetype) sharedManager 	{ return  self.keyedManager; }
+ (instancetype) keyedManager		{
	static BGThemeManager *sharedThemeManager = nil;
   return sharedThemeManager = sharedThemeManager ?: ^{
	 	sharedThemeManager = [super allocWithZone:NULL].init;
		sharedThemeManager.themes = @[AZFlatTheme.new, BGGradientTheme.new, BGTheme.new, AZDebugTheme.new];
		return sharedThemeManager;
    }();
}
- (id)copyWithZone:	(NSZone*)zone	{    return self;						}
+ allocWithZone:	(NSZone*)zone	{    return [self keyedManager];	}
//-(void)initDefaultThemes {
	
	//Init our Dictionary for 2 defaults
//	self.themes = @{}.mutableCopy;

	//Add the default Flat and Gradient themes
//	[themes setObject: [[BGTheme alloc] init] forKey: @"flatTheme"];
//	[themes setObject: [[BGTheme alloc] init] forKey: @"azFlatTheme"];
//	[themes setObject: [[BGTheme alloc] init] forKey: @"gradientTheme"];
	
//	BGTheme *atoz = [AZFlatTheme 		new];
//	BGTheme *grad = [BGGradientTheme new];
//	BGTheme *flat = [BGTheme 			new];
//	self. themes = @{ @"flat":flat, @"atoz":atoz, @"gradientTheme":grad}.mutableCopy;
	//themes setObject: [[AZFlatTheme alloc] init] forKey: @"azFlatTheme"];
//	themes setObject:  forKey: @"gradientTheme"];

//	[themes setObject: [[BGGradientTheme alloc] init] forKey: @"gradientTheme"];
//	[themes setObject: [[BGGradientTheme alloc] init] forKey: @"gradientTheme"];
//	[themes setObject: [[BGGradientTheme alloc] init] forKey: @"flatTheme"];
//}


//- (void)setTheme:(BGTheme*)theme forKey:(NSString *)key {
//	[self.themes setObject:theme forKey:key];
//}


//- (id)retain; {
//    return self;
//}
//
//- (NSUInteger)retainCount; {
//    return NSUIntegerMax;  //denotes an object that cannot be released
//}
//
//- (void)release; {
//    //do nothing
//}
//
//- (id)autorelease; {
//    return self;
//}

@end

