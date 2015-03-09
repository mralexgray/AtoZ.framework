/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <Python/Python.h>

#import "NBBThemeEngine.h"

@implementation NBBThemeEngine

// singleton pattern
#pragma mark - Singleton

+ (NBBThemeEngine*)sharedThemeEngine
{
	static NBBThemeEngine* sharedThemeEngine = nil;
    if (sharedThemeEngine == nil) {
        sharedThemeEngine = [[super allocWithZone:NULL] init];
    }
    return sharedThemeEngine;
}

+ allocWithZone:(NSZone *)zone
{
    return [self sharedThemeEngine];// retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#ifndef PARTOF_AtoZ
- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
#endif

// end singleton pattern

- (id)init
{
    self = [super init];
    if (self) {
		NSLog(@"initializing NBB theme engine.");
		// initialize Python
		Py_Initialize(); // we must call Py_Initialize before attempting to load themes!
		_themedObjects = [[NSMutableSet alloc] init];
		_theme = nil;
    }
    return self;
}

- (void)dealloc
{
    [_theme release];
	[_themedObjects release];
	// shutdown Python
	Py_Finalize();

    [super dealloc];
}

- (Class <NBBThemable>)classReplacementForThemableClass:(Class <NBBThemable>) cls
{
	Class replacement = cls;
	if ([(Class)cls conformsToProtocol:@protocol(NBBThemable)]) {
		NSLog(@"replacing %@ with %@", cls, replacement);
		// TODO: actually implement this
	}
	return replacement;
}

- (void)swapView:(NSView*) source withView:(NSView*) dest persist:(BOOL) persist
{
	NSLog(@"swapping %@ with %@", source.identifier, dest.identifier);
	// !!!: adjust the "Auto Layout" constraints for the superview.
	// otherwise changing the frames is impossible. (instant reversion)
	// we could disable "Auto Layout", but let's try for compatibility

	// TODO: we need to either enforce that the 2 controls have the same superview
	// before accepting the drag operation
	// or modify this code to take two diffrent superviews into account

	// we are altering the constraints so iterate a copy!
	NSArray* constraints = [dest.superview.constraints copy];
	for (NSLayoutConstraint* constraint in constraints) {
		id first = constraint.firstItem;
		id second = constraint.secondItem;
		id newFirst = first;
		id newSecond = second;

		BOOL match = NO;
		if (first == dest) {
			newFirst = source;
			match = YES;
		}
		if (second == dest) {
			newSecond = source;
			match = YES;
		}
		if (first == source) {
			newFirst = dest;
			match = YES;
		}
		if (second == source) {
			newSecond = dest;
			match = YES;
		}
		if (match && newFirst) {
			[dest.superview removeConstraint:constraint];
			@try {
				NSLayoutConstraint* newConstraint = nil;
				newConstraint = [NSLayoutConstraint constraintWithItem:newFirst
															 attribute:constraint.firstAttribute
															 relatedBy:constraint.relation
																toItem:newSecond
															 attribute:constraint.secondAttribute
															multiplier:constraint.multiplier
															  constant:constraint.constant];
				newConstraint.shouldBeArchived = constraint.shouldBeArchived;
				newConstraint.priority = NSLayoutPriorityWindowSizeStayPut;
				[dest.superview addConstraint:newConstraint];
			}
			@catch (NSException *exception) {
				NSLog(@"Constraint exception: %@\nFor constraint: %@", exception, constraint);
			}
		}
	}
	[constraints release];

	NSMutableArray* newSourceConstraints = [NSMutableArray array];
	NSMutableArray* newDestConstraints = [NSMutableArray array];

	// again we need a copy since we will be altering the original
	constraints = [source.constraints copy];
	for (NSLayoutConstraint* constraint in constraints) {
		// WARNING: do not tamper with intrinsic layout constraints
		if ([constraint class] == [NSLayoutConstraint class]
			&& constraint.firstItem == source && constraint.secondItem == nil) {
			// this is a source constraint. we need to copy it to the destination.
			NSLayoutConstraint* newConstraint = nil;
			newConstraint = [NSLayoutConstraint constraintWithItem:dest
														 attribute:constraint.firstAttribute
														 relatedBy:constraint.relation
															toItem:nil
														 attribute:constraint.secondAttribute
														multiplier:constraint.multiplier
														  constant:constraint.constant];
			newConstraint.shouldBeArchived = constraint.shouldBeArchived;
			[newDestConstraints addObject:newConstraint];
			[source removeConstraint:constraint];
		}
	}
	[constraints release];

	// again we need a copy since we will be altering the original
	constraints = [dest.constraints copy];
	for (NSLayoutConstraint* constraint in constraints) {
		// WARNING: do not tamper with intrinsic layout constraints
		if ([constraint class] == [NSLayoutConstraint class] && constraint.firstItem == dest && constraint.secondItem == nil) {
			// this is a destination constraint. we need to copy it to the source.
			NSLayoutConstraint* newConstraint = nil;
			newConstraint = [NSLayoutConstraint constraintWithItem:source
														 attribute:constraint.firstAttribute
														 relatedBy:constraint.relation
															toItem:nil
														 attribute:constraint.secondAttribute
														multiplier:constraint.multiplier
														  constant:constraint.constant];
			newConstraint.shouldBeArchived = constraint.shouldBeArchived;
			[newSourceConstraints addObject:newConstraint];
			[dest removeConstraint:constraint];
		}
	}
	[constraints release];

	[dest addConstraints:newDestConstraints];
	[source addConstraints:newSourceConstraints];

	// auto layout makes setting the frame unnecissary, but
	// we do it because its possible that a module is not using auto layout
	NSRect srcRect = source.frame;
	NSRect dstRect = dest.frame;
	// round the coordinates!!!
	// otherwise we will have problems with persistant values
	srcRect.origin.x = round(srcRect.origin.x);
	srcRect.origin.y = round(srcRect.origin.y);
	dstRect.origin.x = round(dstRect.origin.x);
	dstRect.origin.y = round(dstRect.origin.y);

	source.frame = dstRect;
	dest.frame = srcRect;

	if (persist) {
		NSString* rectString = NSStringFromRect(srcRect);
		[[_theme prefrences] setObject:rectString forKey:dest.identifier];
		rectString = NSStringFromRect(dstRect);
		[[_theme prefrences] setObject:rectString forKey:source.identifier];
	}
}

// FIXME: updateLayout gets called twice before main window is loaded.
- (void)updateLayout
{
	// This is almost certainly true. 3rd party themes might use other objects, however.
	for (id <NBBThemable> obj in _themedObjects) {
		if ([obj isKindOfClass:[NSView class]]) {
			NSView* view = (NSView*)obj;
			NSLog(@"positioning %@", view.identifier);
			NSString* rectString = _theme.prefrences[view.identifier];
			if (rectString) {
				// because of "Auto Layout" we need to iterate all the subviews
				// and find the one matching the frame rect and swap the layout constraints
				NSRect frame = NSRectFromString(rectString);
				NSView* swapView = nil;

				for (NSView* sv in view.superview.subviews) {
					if (NSEqualRects(frame, sv.frame)
						&& [sv isKindOfClass:[view class]] // only swap objects that are compatible
						) {
						swapView = sv;
						break;
					}
				}
				if (swapView && swapView != view) {
					// no need to persist; this is being calld because it is already persistant.
					[self swapView:view withView:swapView persist:NO];
				}
			}
		}
	}
}

- (void) themeObject:(id <NBBThemable>) obj
{
	if (_theme && [obj conformsToProtocol:@protocol(NBBThemable)]) {
		if ([obj applyTheme:_theme]) {
			if (![_themedObjects containsObject:obj]) {
				[_themedObjects addObject:obj];
				// new themed object
				// register for its notifications
				/*
				 // register for frame change notifications so we can store new frames in the prefs
				 NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
				 [nc addObserver: self
				 selector: @selector( frameChanged: )
				 name: NSViewFrameDidChangeNotification
				 object: obj];
				 */
				[self updateLayout];
			}
		}
	} else {
		@throw([NSException exceptionWithName:@"NBBNoThemeLoadedException"
									   reason:@"ThemeEngine has no theme set"
									 userInfo:nil]);
	}
}

- (void)applyTheme:(NBBTheme*) theme
{
	if (theme == nil) {
		@throw([NSException exceptionWithName:@"NBBNotValidThemeException"
									   reason:[NSString stringWithFormat:@"Nil Theme applied. ThemeEngine requires a valid theme"]
									 userInfo:nil]);
	}

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	if (_theme) {
		[nc postNotificationName:@"NBBThemeWillChange" object:self userInfo:_theme.prefrences];
		[_theme release];
	}

	NSLog(@"Applying theme:%@", theme);
	_theme = [theme retain];
	for (id <NBBThemable> obj in _themedObjects) {
		[self themeObject:obj];
	}
	[self updateLayout];
	[nc postNotificationName:@"NBBThemeDidChange" object:self userInfo:_theme.prefrences];
}

- (void)frameChanged:(NSNotification*) notification
{
	/*
	id obj = [notification object];

	NSRect theFrame = [(NSControl*)obj frame];
	NSString* rectString = NSStringFromRect(theFrame);
	[[_theme prefrences] setObject:rectString forKey:[obj identifier]];
	 */
}

@end
