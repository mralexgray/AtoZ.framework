// Copyright © 2009-2011 Cédric Luthi <http://0xced.blogspot.com>

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>

@interface NSObject ()
- (NSString *) debugDescription;
@end

static BOOL gColorize = YES;
static NSUInteger gIndentWidth = 4;
static NSUInteger gIndentLevel = 0;
static NSMutableSet *gObjects = nil;

static void swizzleDescription(const char *className)
{
	Class class = objc_lookUpClass(className);
	Method debugDescription = class_getInstanceMethod(class, @selector(debugDescription));
	Method fullDescription = class_getInstanceMethod(class, @selector(fullDescription));
	class_addMethod(class, @selector(debugDescription), class_getMethodImplementation(class, @selector(debugDescription)), method_getTypeEncoding(debugDescription));
	class_addMethod(class, @selector(fullDescription), class_getMethodImplementation(class, @selector(fullDescription)), method_getTypeEncoding(fullDescription));
	debugDescription = class_getInstanceMethod(class, @selector(debugDescription));
	fullDescription = class_getInstanceMethod(class, @selector(fullDescription));
	method_exchangeImplementations(debugDescription, fullDescription);
}

// Used by fullDescription.gdbinit
void SwizzleFullDescription(void)
{
	const char *classNames[] = {"NSObject", "NSString", "NSArray", "NSPointerArray", "NSDictionary", "NSSet"};
	for (unsigned int i = 0; i < sizeof(classNames) / sizeof(classNames[0]); i++)
		swizzleDescription(classNames[i]);
}

__attribute__((constructor)) void initialize(void)
{
	CFPropertyListRef indentWidthPref = CFPreferencesCopyAppValue(CFSTR("DVTTextIndentWidth"), CFSTR("com.apple.dt.Xcode"));
	if (!indentWidthPref)
		indentWidthPref = CFPreferencesCopyAppValue(CFSTR("IndentWidth"), CFSTR("com.apple.Xcode"));

	if (indentWidthPref)
	{
		gIndentWidth = [(__bridge id)indentWidthPref intValue];
		CFRelease(indentWidthPref);
	}

	for (uint32_t i = 0; i < _dyld_image_count(); i++)
	{
		if (strstr(_dyld_get_image_name(i), "DevToolsBundleInjection"))
		{
			gColorize = NO;
			break;
		}
	}

	gObjects = [[NSMutableSet alloc] initWithCapacity:256];
}

static void indent(NSMutableString *string, NSUInteger indentLevel)
{
	for (NSUInteger i = 0; i < indentLevel * gIndentWidth; i++)
	{
		[string appendString:@" "];
	}
}

enum {
	black = 30,
	red,
	green,
	yellow,
	blue,
	magenta,
	cyan,
	white
};

#define pathColor blue
#define referenceColor green
#define emptyColor magenta
#define keyColor cyan
#define nilColor red

static NSString* color(NSString *string, int color)
{
	if (gColorize)
		return [NSString stringWithFormat:@"\033[%dm%@\033[0m", color, string];
	else
		return string;
}

static NSString *debugDescription(id self)
{
	if (self)
	{
		[gObjects addObject:self];
	}
	Class class = [self class];
	NSMutableString *desc = [NSMutableString stringWithFormat:@"[%p: %@]", self, class];
	unsigned int ivarCount;
	Ivar *ivars = class_copyIvarList(class, &ivarCount); // instance variables declared by superclasses are not included

	[desc appendString:(ivarCount <= 1) ? @" " : @"\n"];

	for(int i = 0; i < ivarCount; i++)
	{
		Ivar ivar = ivars[i];
		NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
		id obj;
		const char *typeEncoding = ivar_getTypeEncoding(ivar);

		if (ivarCount > 1)
			indent(desc, gIndentLevel);

		switch (typeEncoding[0]) 
		{
			case '@':
				obj = [self valueForKey:ivarName];
				if (![gObjects containsObject:obj] || [obj isKindOfClass:[NSString class]])
				{
					[desc appendFormat:@"%@: %@", ivarName, obj ? [obj debugDescription] : color(@"nil", nilColor)];
				}
				else
				{
					[desc appendFormat:@"%@: => ", ivarName];
					[desc appendString:color([NSString stringWithFormat:@"%p", obj], referenceColor)];
					[desc appendString:@""];
				}
				break;
			default:
				[desc appendFormat:@"%@: %p", ivarName, object_getIvar(self, ivar)];
				break;
		}
		if (i < ivarCount-1)
		{
			[desc appendString:@"\n"];
		}
	}
	free(ivars);
	return [NSString stringWithString:desc];
}

static NSString *collectionDescription(id collection)
{
	BOOL isArray = NO, isDictionary = NO, isSet = NO;
	NSString *markerStart = @"[?", *markerEnd = @"?]";
	if ([collection isKindOfClass:[NSArray class]] || [collection isKindOfClass:[NSPointerArray class]])
	{
		if ([collection isKindOfClass:[NSPointerArray class]])
		{
			markerStart = @"<(";
			markerEnd   = @")>";
			collection = [collection allObjects];
		}
		else
		{
			markerStart = @"(";
			markerEnd   = @")";
		}
		isArray = YES;
	}
	else if ([collection isKindOfClass:[NSDictionary class]])
	{
		markerStart = @"{";
		markerEnd   = @"}";
		isDictionary = YES;
	}
	else if ([collection isKindOfClass:[NSSet class]])
	{
		markerStart = @"{(";
		markerEnd   = @")}";
		isSet = YES;
	}

	if ( [collection respondsToSelector:@selector(count)] ){
			if ([[collection valueForKey:@"count"]integerValue] == 0){

			return [NSString stringWithFormat:@"%p:%@ %@ %@", collection, markerStart, color(@"empty", emptyColor), markerEnd];
			}
			else if ([[collection valueForKey:@"count"]integerValue] == 1)
			{
			NSString *debugDescription = nil;
			if (isArray)
			{
				debugDescription = [[collection lastObject] debugDescription];
			}
			else if (isDictionary)
			{
				NSString *key = [[collection allKeys] lastObject];
				debugDescription = [NSString stringWithFormat:@"%@: %@", color(key, keyColor), [collection[key] debugDescription]];
			}
			else if (isSet)
			{
				debugDescription = debugDescription = [[collection anyObject] debugDescription];
			}
			return [NSString stringWithFormat:@"%p:%@ %@ %@", collection, markerStart, debugDescription, markerEnd];
		}
	}
	else
	{
		NSMutableString *desc = [NSMutableString stringWithFormat:@"%p:%@\n", collection, markerStart];
		NSUInteger i = 0;

		for(id object in (isDictionary ? [collection allKeys] : collection))
		{
			indent(desc, gIndentLevel + 1);
			if (isArray)
			{
//				[desc appendFormat:$(@"%%%dd) ", [[NSString stringWithFormat:@"%ld", [collection count]] length]), i++];
			}
			else if (isDictionary)
			{
				[desc appendString:color(object, keyColor)];
				[desc appendString:@": "];
			}
			gIndentLevel++;
			[desc appendString:[(isDictionary ? collection[object] : object) debugDescription]];
			gIndentLevel--;
			[desc appendString:@"\n"];
		}

		indent(desc, gIndentLevel);
		[desc appendFormat:@"%@", markerEnd];
		return [NSString stringWithString:desc];
	}
}

@implementation NSObject (fullDescription)

- (NSString *) fullDescription
{
	NSString *desc;
	gIndentLevel++;
	desc = debugDescription(self);
	gIndentLevel--;
	if (gIndentLevel == 0)
	{
		[gObjects removeAllObjects];
	}
	return desc;
}

@end

@implementation NSString (fullDescription)

- (NSString *) fullDescription
{
	BOOL isPath = [self isKindOfClass:NSClassFromString(@"NSPathStore2")];
	return color([self description], isPath ? pathColor : black);
}

@end

@implementation NSArray (fullDescription)

- (NSString *) fullDescription
{
	return collectionDescription(self);
}

@end

@implementation NSPointerArray (fullDescription)

- (NSString *) fullDescription
{
	return collectionDescription(self);
}

@end

@implementation NSDictionary (fullDescription)

- (NSString *) fullDescription
{
	return collectionDescription(self);
}

@end

@implementation NSSet (fullDescription)

- (NSString *) fullDescription
{
	return collectionDescription(self);
}

@end