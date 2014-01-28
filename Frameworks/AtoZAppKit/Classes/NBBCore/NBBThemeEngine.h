/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <Foundation/Foundation.h>
#ifdef PARTOF_AtoZ
#import "NBBWindow.h"
#import "NBBTheme.h"

#else
#import <NBBCore/NBBWindow.h>
#import <NBBCore/NBBTheme.h>
#endif
#import "NBBThemable.h"
/*
 The current plan for the theming engine:
 * themes will be loadable bundles (NSBundle) containing a subclass of NBBTheme ("abstract" base class)
 * module interfaces are built in IB
 * the theme engine will be "File owner" of all NIBs
 * NBB control subclasses (adopting NBBThemable protocol and category) act as "proxy" objects.
 * upon initializing an NBBThemable control the category will ask the engine
 (which in turn gets info from the active NBBTheme)
 which subclass (if any) should be initialized in its place (using the protocol method initWithTheme)
 * the special initializer passes the NBBTheme instance to the control
 the control uses this instance to configure its customizeable parameters
 
 This way themes can specify (if they choose) their own subclasses to achieve greater customization then
 our basic theming API will supply.
 
 The theme engine will use "Key Value Coding" to allow themes to create their own controls and wire them to module methods
 using cocoa bindings.
*/

@interface NBBThemeEngine : NSObject
{
@private
	NSMutableSet* _themedObjects;
}
@property(nonatomic, readonly) NBBTheme* theme;

+ (NBBThemeEngine*)sharedThemeEngine;

- (Class <NBBThemable>)classReplacementForThemableClass:(Class <NBBThemable>) cls;
- (void)themeObject:(id <NBBThemable>) obj;
- (void)swapView:(NSView*) source withView:(NSView*) dest persist:(BOOL) persist;
- (void)updateLayout;

/*
 This method will iterate the _themedObjects set and send an applyTheme message to each
*/
- (void)applyTheme:(NBBTheme*) theme;
@end
