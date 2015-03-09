/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2013 Brad Allred
 *

 */

#import "NSWindow+NBBWindowProxy.h"
#import "NBBThemeEngine.h"

@implementation NSWindow (NBBWindowProxy)
+ allocWithZone:(NSZone *)zone
{
	NBBThemeEngine* themeEngine = [NBBThemeEngine sharedThemeEngine];
	self = [themeEngine classReplacementForThemableClass:self];
	return [super allocWithZone:zone];
}

- (NBBTheme*) theme
{
	if ([self conformsToProtocol:@protocol(NBBThemable)]) {
		return [NBBThemeEngine sharedThemeEngine].theme;
	}
	return nil;
}

@end
