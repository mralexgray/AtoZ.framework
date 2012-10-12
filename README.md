[<kbd>A</kbd>to<kbd>Z</kbd>.framework](https://github.com/mralexgray/AtoZ.framework)
-------------------------------------------------------------------------------------
###The *all-inclusive cruise* of Umbrella frameworks.

STARS:

AZPermineterWithRoundRadius([self frame],self.radius);

-(void) setWithDictionary:(NSD*)dic;
{
	[[dic allKeys] each:^(id obj) {
		NSString *j = $(@"set%@", [obj capitalizedString]);
		SEL setter = @selector(j);
		[self performSelectorWithoutWarnings:setter withObject:dic[obj]];
	}];

}



# ConciseKit

A set of Objective-C additions and macros that lets you to write code more quickly.

## Pull requests are welcome!

## USAGE

Use [CocoaPods](https://github.com/CocoaPods/CocoaPods)

```ruby
dependency 'ConciseKit', '~> 0.1.2'
```

or

1. Copy files under `src/` to your project.

```objective-c
#import "ConciseKit.h"
```

## $ class

### Method Swizzling

        [$ swizzleMethod:@selector(foo) with:@selector(bar) in:[Foo class]]
        [$ swizzleMethod:@selector(foo) in:[Foo class] with:@selector(bar) in:[Bar class]]

        [$ swizzleClassMethod:@selector(foo) with:@selector(bar) in:[Foo class]]
        [$ swizzleClassMethod:@selector(foo) in:[Foo class] with:@selector(bar) in:[Bar class]]

### Path

        [$ homePath]     => path to user's home directory
        [$ desktopPath]  => path to user's desktop directory
        [$ documentPath] => path to user's document directory
        [$ appPath]      => path to app directory
        [$ resourcePath] => path to app's resources directory

### waitUntil

Useful when writing tests for asynchronous tasks. Default timeout is 10 seconds, checking is done every 0.1 seconds.

        [$ waitUntil:^{ return (BOOL)(someConditionIsMet == YES) }]
        [$ waitUntil:^{ return (BOOL)(someConditionIsMet == YES) } timeOut:10.0]
        [$ waitUntil:^{ return (BOOL)(someConditionIsMet == YES) } timeOut:10.0 interval:0.1]

## Singleton

### Creating Singletons

        @interface Foo
        - (id)initSingleton; // <= add these to the interface
        + (Foo *)sharedFoo;  // <= where Foo is the class name
        @end

        @implementation Foo
        $singleton(Foo);     // => makes Foo a singleton class

        - (id)initSingleton {
          foo = 1;           // do initialization in -initSingleton method
          bar = 2;
          return self;
        }
        @end

### Using Singletons

        $shared(Foo)         // => returns the shared instance
        /* or */
        [Foo sharedFoo]

## Macros

### General shorthands

        $new(Foo)       => [[[Foo alloc] init] autorelease]
        $eql(foo, bar)  => [foo isEqual:bar]
        $safe(obj)      => (obj == [NSNull null] ? nil : obj)

### NSArray shorthands

        $arr(foo, bar)          =>  [NSArray arrayWithObjects:foo, bar, nil]
        $marr(foo, bar)         =>  [NSMutableArray ...]
        $marrnew or $marr(nil)  =>  [NSMutableArray array]

### NSSet shorthands

        $set(foo, bar)          =>  [NSSet setWithObjects:foo, bar, nil]
        $mset(foo, bar)         =>  [NSMutableSet ...]
        $msetnew or $mset(nil)  =>  [NSMutableSet set]

### NSDictionary shorthands

        $dict(v1, k1, v2, k2)     =>  [NSDictionary dictionaryWithObjectsAndKeys:v1, k1, v2, k2, nil]
        $mdict(v1, k1, v2, k2)    =>  [NSMutableDictionary ...]
        $mdictnew or $mdict(nil)  =>  [NSMutableDictionary dictionary]

### NSString shorthands

        $str(@"foo: %@", bar)   => [NSString stringWithFormat:@"foo: %@", bar]
        $mstr(@"foo: %@", bar)  => [NSMutableString ...]
        $mstrnew or $mstr(nil)  => [NSMutableString string]

### NSNumber shorthands

        $bool(YES)    => [NSNumber numberWithBool:YES]
        $int(123)     => [NSNumber numberWithInt:123]
        $float(123.4) => [NSNumber numberWithFloat:123.4]

        $char(), $double(), $integer(), $long(), $longlong(), $short(),
        $uchar(), $uint(), $uinteger(), $ulong(), $ulonglong(), $ushort()

### NSValue shorthands
        $nonretained(), $pointer(), $point(), $range(), $rect(), $size()

## Additions

### NSArray

        [array $first] => [array objectAtIndex:0]
        [array $last]  => [array lastObject]
        [array $at:1]  => [array objectAtIndex:1]

        [array $each:^(id obj) {
          NSLog(@"%@", obj);
        }]

        [array $eachWithIndex:^(id obj, NSUInteger i) {
          NSLog(@"%d %@", i, obj);
        }]

        [array $eachWithStop:^(id obj, BOOL *stop) {
          NSLog(@"%@", obj);
          if($eql(obj, @"foo")) {
            *stop = YES;
          }
        }]

        [array $eachWithIndexAndStop:^(id obj, NSUInteger i, BOOL *stop) {
          NSLog(@"%d %@", i, obj);
          if(i == 1) {
            *stop = YES;
          }
        }]

        [array $map:^(id obj) {
          return $integer([obj integerValue] * 2);
        }]

        [array $mapWithIndex:^(id obj, NSUInteger i) {
          return $integer([obj integerValue] * 2 + i);
        }]

        [array $reduce:^(id obj) {
          return $integer([obj integerValue] * 2);
        }]

        [array $reduce:^(NSNumber *memo, NSNumber *obj) {
          return $integer([memo integerValue] + [obj integerValue]);
        }]

        [array $reduceStartingAt:$integer(1) with:^(NSNumber *memo, NSNumber *obj) {
          return $integer([memo integerValue] * [obj integerValue]);
        }]

        [array $select:^BOOL(NSNumber *obj) {
          return ([obj integerValue] % 2) == 0;
        }]

        [array $detect:^BOOL(NSNumber *obj) {
          return ([obj integerValue] % 2) == 1;
        }]

        [array $join]      => [self componentsJoinedByString:@""]
        [array $join:@","] => [self componentsJoinedByString:@","]

### NSMutableArray

        [array $push:foo]    => [array addObject:foo]              (+ returns self)
        [array $pop]         => [array removeLastObject]           (+ returns lastObject)
        [array $unshift:foo] => [array insertObject:foo atIndex:0] (+ returns self)
        [array $shift]       => [array removeObjectAtIndex:0]      (+ returns first object)

### NSDictionary

        [dict $for:@"foo"] => [dict objectForKey:@"foo"]
        [dict $keys]       => [dict allKeys]
        [dict $values]     => [dict allValues]

        [dict $each:^(id key, id value) {
            NSLog(@"%@ => %@", key, value);
        }

        [dict $eachWithStop:^(id key, id value, BOOL *stop) {
            NSLog(@"%@ => %@", key, value);
            if($eql(key, @"foo")) {
                *stop = YES;
            }
        }]

        [dict $eachKey:^(id key) {
            NSLog(@"%@", key);
        }]

        [dict $eachValue:^(id value) {
            NSLog(@"%@", value);
        }]

### NSMutableDictionary

        [dict $obj:@"bar" for:@"foo"] => [dict setObject:@"bar" forKey:@"foo"] (+ returns self)

### NSString

        [string $append:@"foo"]  => [string stringByAppendString:@"foo"]
        [string $prepend:@"foo"] => [NSString stringWithFormat:@"%@%@", @"foo", string]
        [string $split:@","]     => [string componentsSeparatedByString:@","]
        [string $split]          => [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

### NSMutableString

        [string $append_:@"foo"]     => [string appendString:@"foo"]           (+ returns self)
        [string $prepend_:@"foo"]    => [string insertString:@"foo" atIndex:0] (+ returns self)
        [string $insert:@"foo" at:1] => [string insertString:@"foo" atIndex:1] (+ returns self)
        [string $set:@"foo"]         => [string setString:@"foo"]              (+ returns self)

## Contributors

* [nolanw](http://github.com/nolanw)
* [listrophy](https://github.com/listrophy)
* [gerry3](https://github.com/gerry3) @ [Inigral](https://github.com/inigral)

## License

Copyright (c) 2010-2012 Peter Jihoon Kim and contributors. This code is licensed under the [MIT License](http://github.com/petejkim/ConciseKit/raw/master/LICENSE).

/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#pragma mark Named Structures

<CODE>

struct AZTri {
    struct CGPoint a;
    struct CGPoint b;
    struct CGPoint c;
};

struct AZTriPair {
    struct AZTri uno;
    struct AZTri duo;
};

struct CATransform3D {
    double _field1;
    double _field2;
    double _field3;
    double _field4;
    double _field5;
    double _field6;
    double _field7;
    double _field8;
    double _field9;
    double _field10;
    double _field11;
    double _field12;
    double _field13;
    double _field14;
    double _field15;
    double _field16;
};

struct CGAffineTransform {
    double _field1;
    double _field2;
    double _field3;
    double _field4;
    double _field5;
    double _field6;
};

struct CGPoint {
    double x;
    double y;
};

struct CGRect {
    struct CGPoint origin;
    struct CGSize size;
};

struct CGSize {
    double width;
    double height;
};

struct NSView {
    Class _field1;
    id _field2;
    struct CGRect _field3;
    struct CGRect _field4;
    id _field5;
    id _field6;
    id _field7;
    id _field8;
    id _field9;
    id _field10;
    id _field11;
    id _field12;
    struct __VFlags {
        unsigned int :1;
        unsigned int :1;
        unsigned int :6;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :6;
        unsigned int :1;
        unsigned int :1;
    } _field13;
    struct __VFlags2 {
        unsigned int :14;
        unsigned int :14;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
        unsigned int :1;
    } _field14;
};

struct _CTGradientElement {
    float _field1;
    float _field2;
    float _field3;
    float _field4;
    float _field5;
    struct _CTGradientElement *_field6;
};

struct _NSRange {
    unsigned long long _field1;
    unsigned long long _field2;
};

struct __va_list_tag {
    unsigned int _field1;
    unsigned int _field2;
    void *_field3;
    void *_field4;
};

#pragma mark Typedef'd Structures

typedef struct {
    unsigned long long _field1;
    id *_field2;
    unsigned long long *_field3;
    unsigned long long _field4[5];
} CDStruct_70511ce9;

typedef struct {
    double _field1;
    double _field2;
    double _field3;
    double _field4;
    double _field5;
    double _field6;
    double _field7;
    double _field8;
} CDStruct_7660b417;

typedef struct {
    long long _field1;
    long long _field2;
} CDStruct_912cb5d2;

#pragma mark -

/*
 * File: /Users/localadmin/Library/Developer/Xcode/DerivedData/AtoZ-hfqteqfcvjfinlajqwkydsqyzpiz/Build/Products/Debug/AtoZ.framework/Versions/A/AtoZ
 * UUID: EBEFA121-CAB3-3817-BD2E-CB2FAF8B07BA
 * Arch: Intel x86-64 (x86_64)
 *       Current version: 1.0.0, Compatibility version: 1.0.0
 *       Minimum Mac OS X version: 10.6.0
 *
 *       Objective-C Garbage Collection: Unsupported
 *       Run path: @loader_path/Frameworks
 *               = /Users/localadmin/Library/Developer/Xcode/DerivedData/AtoZ-hfqteqfcvjfinlajqwkydsqyzpiz/Build/Products/Debug/AtoZ.framework/Versions/A/Frameworks
 *       Run path: @loader_path/../Frameworks
 *               = /Users/localadmin/Library/Developer/Xcode/DerivedData/AtoZ-hfqteqfcvjfinlajqwkydsqyzpiz/Build/Products/Debug/AtoZ.framework/Versions/Frameworks
 */

@protocol AZScrollerContent
- (void)scrollToPosition:(double)arg1;
- (void)moveScrollView:(double)arg1;
- (double)stepSize;
- (double)visibleWidth;
- (double)contentWidth;
@end

@protocol AZScrollerContentController
- (void)scrollContentResized;
- (void)scrollPositionChanged:(double)arg1;
- (BOOL)isRepositioning;
@end

@protocol AZSourceListDataSource <NSObject>
- (BOOL)sourceList:(id)arg1 isItemExpandable:(id)arg2;
- (id)sourceList:(id)arg1 objectValueForItem:(id)arg2;
- (id)sourceList:(id)arg1 child:(unsigned long long)arg2 ofItem:(id)arg3;
- (unsigned long long)sourceList:(id)arg1 numberOfChildrenOfItem:(id)arg2;

@optional
- (id)sourceList:(id)arg1 namesOfPromisedFilesDroppedAtDestination:(id)arg2 forDraggedItems:(id)arg3;
- (BOOL)sourceList:(id)arg1 acceptDrop:(id)arg2 item:(id)arg3 childIndex:(long long)arg4;
- (unsigned long long)sourceList:(id)arg1 validateDrop:(id)arg2 proposedItem:(id)arg3 proposedChildIndex:(long long)arg4;
- (BOOL)sourceList:(id)arg1 writeItems:(id)arg2 toPasteboard:(id)arg3;
- (id)sourceList:(id)arg1 persistentObjectForItem:(id)arg2;
- (id)sourceList:(id)arg1 itemForPersistentObject:(id)arg2;
- (id)sourceList:(id)arg1 iconForItem:(id)arg2;
- (BOOL)sourceList:(id)arg1 itemHasIcon:(id)arg2;
- (id)sourceList:(id)arg1 badgeBackgroundColorForItem:(id)arg2;
- (id)sourceList:(id)arg1 badgeTextColorForItem:(id)arg2;
- (long long)sourceList:(id)arg1 badgeValueForItem:(id)arg2;
- (BOOL)sourceList:(id)arg1 itemHasBadge:(id)arg2;
- (void)sourceList:(id)arg1 setObjectValue:(id)arg2 forItem:(id)arg3;
@end

@protocol BaseModel <NSObject, NSFastEnumeration>

@optional
- (void)encodeWithCoder:(id)arg1;
- (void)setWithCoder:(id)arg1;
- (void)setWithData:(id)arg1;
- (void)setWithNumber:(id)arg1;
- (void)setWithString:(id)arg1;
- (void)setWithArray:(id)arg1;
- (void)setWithDictionary:(id)arg1;
- (void)setUp;
@end

@protocol NSApplicationDelegate <NSObject>

@optional
- (void)applicationDidChangeScreenParameters:(id)arg1;
- (void)applicationWillTerminate:(id)arg1;
- (void)applicationDidUpdate:(id)arg1;
- (void)applicationWillUpdate:(id)arg1;
- (void)applicationDidResignActive:(id)arg1;
- (void)applicationWillResignActive:(id)arg1;
- (void)applicationDidBecomeActive:(id)arg1;
- (void)applicationWillBecomeActive:(id)arg1;
- (void)applicationDidUnhide:(id)arg1;
- (void)applicationWillUnhide:(id)arg1;
- (void)applicationDidHide:(id)arg1;
- (void)applicationWillHide:(id)arg1;
- (void)applicationDidFinishLaunching:(id)arg1;
- (void)applicationWillFinishLaunching:(id)arg1;
- (void)application:(id)arg1 didDecodeRestorableState:(id)arg2;
- (void)application:(id)arg1 willEncodeRestorableState:(id)arg2;
- (void)application:(id)arg1 didReceiveRemoteNotification:(id)arg2;
- (void)application:(id)arg1 didFailToRegisterForRemoteNotificationsWithError:(id)arg2;
- (void)application:(id)arg1 didRegisterForRemoteNotificationsWithDeviceToken:(id)arg2;
- (id)application:(id)arg1 willPresentError:(id)arg2;
- (id)applicationDockMenu:(id)arg1;
- (BOOL)applicationShouldHandleReopen:(id)arg1 hasVisibleWindows:(BOOL)arg2;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(id)arg1;
- (unsigned long long)application:(id)arg1 printFiles:(id)arg2 withSettings:(id)arg3 showPrintPanels:(BOOL)arg4;
- (BOOL)application:(id)arg1 printFile:(id)arg2;
- (BOOL)application:(id)arg1 openFileWithoutUI:(id)arg2;
- (BOOL)applicationOpenUntitledFile:(id)arg1;
- (BOOL)applicationShouldOpenUntitledFile:(id)arg1;
- (BOOL)application:(id)arg1 openTempFile:(id)arg2;
- (void)application:(id)arg1 openFiles:(id)arg2;
- (BOOL)application:(id)arg1 openFile:(id)arg2;
- (unsigned long long)applicationShouldTerminate:(id)arg1;
@end

@protocol NSCoding
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
@end

@protocol NSControlTextEditingDelegate <NSObject>

@optional
- (id)control:(id)arg1 textView:(id)arg2 completions:(id)arg3 forPartialWordRange:(struct _NSRange)arg4 indexOfSelectedItem:(long long *)arg5;
- (BOOL)control:(id)arg1 textView:(id)arg2 doCommandBySelector:(SEL)arg3;
- (BOOL)control:(id)arg1 isValidObject:(id)arg2;
- (void)control:(id)arg1 didFailToValidatePartialString:(id)arg2 errorDescription:(id)arg3;
- (BOOL)control:(id)arg1 didFailToFormatString:(id)arg2 errorDescription:(id)arg3;
- (BOOL)control:(id)arg1 textShouldEndEditing:(id)arg2;
- (BOOL)control:(id)arg1 textShouldBeginEditing:(id)arg2;
@end

@protocol NSCopying
- (id)copyWithZone:(struct _NSZone *)arg1;
@end

@protocol NSDraggingDestination <NSObject>

@optional
- (void)updateDraggingItemsForDrag:(id)arg1;
- (BOOL)wantsPeriodicDraggingUpdates;
- (void)draggingEnded:(id)arg1;
- (void)concludeDragOperation:(id)arg1;
- (BOOL)performDragOperation:(id)arg1;
- (BOOL)prepareForDragOperation:(id)arg1;
- (void)draggingExited:(id)arg1;
- (unsigned long long)draggingUpdated:(id)arg1;
- (unsigned long long)draggingEntered:(id)arg1;
@end

@protocol NSFastEnumeration
- (unsigned long long)countByEnumeratingWithState:(CDStruct_70511ce9 *)arg1 objects:(id *)arg2 count:(unsigned long long)arg3;
@end

@protocol NSMutableCopying
- (id)mutableCopyWithZone:(struct _NSZone *)arg1;
@end

@protocol NSObject
- (id)description;
- (unsigned long long)retainCount;
- (id)autorelease;
- (oneway void)release;
- (id)retain;
- (BOOL)respondsToSelector:(SEL)arg1;
- (BOOL)conformsToProtocol:(id)arg1;
- (BOOL)isMemberOfClass:(Class)arg1;
- (BOOL)isKindOfClass:(Class)arg1;
- (BOOL)isProxy;
- (id)performSelector:(SEL)arg1 withObject:(id)arg2 withObject:(id)arg3;
- (id)performSelector:(SEL)arg1 withObject:(id)arg2;
- (id)performSelector:(SEL)arg1;
- (struct _NSZone *)zone;
- (id)self;
- (Class)class;
- (Class)superclass;
- (unsigned long long)hash;
- (BOOL)isEqual:(id)arg1;

@optional
- (id)debugDescription;
@end

@protocol NSOutlineViewDataSource <NSObject>

@optional
- (id)outlineView:(id)arg1 namesOfPromisedFilesDroppedAtDestination:(id)arg2 forDraggedItems:(id)arg3;
- (BOOL)outlineView:(id)arg1 acceptDrop:(id)arg2 item:(id)arg3 childIndex:(long long)arg4;
- (unsigned long long)outlineView:(id)arg1 validateDrop:(id)arg2 proposedItem:(id)arg3 proposedChildIndex:(long long)arg4;
- (void)outlineView:(id)arg1 updateDraggingItemsForDrag:(id)arg2;
- (BOOL)outlineView:(id)arg1 writeItems:(id)arg2 toPasteboard:(id)arg3;
- (void)outlineView:(id)arg1 draggingSession:(id)arg2 endedAtPoint:(struct CGPoint)arg3 operation:(unsigned long long)arg4;
- (void)outlineView:(id)arg1 draggingSession:(id)arg2 willBeginAtPoint:(struct CGPoint)arg3 forItems:(id)arg4;
- (id)outlineView:(id)arg1 pasteboardWriterForItem:(id)arg2;
- (void)outlineView:(id)arg1 sortDescriptorsDidChange:(id)arg2;
- (id)outlineView:(id)arg1 persistentObjectForItem:(id)arg2;
- (id)outlineView:(id)arg1 itemForPersistentObject:(id)arg2;
- (void)outlineView:(id)arg1 setObjectValue:(id)arg2 forTableColumn:(id)arg3 byItem:(id)arg4;
- (id)outlineView:(id)arg1 objectValueForTableColumn:(id)arg2 byItem:(id)arg3;
- (BOOL)outlineView:(id)arg1 isItemExpandable:(id)arg2;
- (id)outlineView:(id)arg1 child:(long long)arg2 ofItem:(id)arg3;
- (long long)outlineView:(id)arg1 numberOfChildrenOfItem:(id)arg2;
@end

@protocol NSOutlineViewDelegate <NSControlTextEditingDelegate>

@optional
- (void)outlineViewItemDidCollapse:(id)arg1;
- (void)outlineViewItemWillCollapse:(id)arg1;
- (void)outlineViewItemDidExpand:(id)arg1;
- (void)outlineViewItemWillExpand:(id)arg1;
- (void)outlineViewSelectionIsChanging:(id)arg1;
- (void)outlineViewColumnDidResize:(id)arg1;
- (void)outlineViewColumnDidMove:(id)arg1;
- (void)outlineViewSelectionDidChange:(id)arg1;
- (BOOL)outlineView:(id)arg1 shouldShowOutlineCellForItem:(id)arg2;
- (BOOL)outlineView:(id)arg1 shouldReorderColumn:(long long)arg2 toColumn:(long long)arg3;
- (double)outlineView:(id)arg1 sizeToFitWidthOfColumn:(long long)arg2;
- (void)outlineView:(id)arg1 willDisplayOutlineCell:(id)arg2 forTableColumn:(id)arg3 item:(id)arg4;
- (BOOL)outlineView:(id)arg1 shouldCollapseItem:(id)arg2;
- (BOOL)outlineView:(id)arg1 shouldExpandItem:(id)arg2;
- (BOOL)outlineView:(id)arg1 isGroupItem:(id)arg2;
- (id)outlineView:(id)arg1 dataCellForTableColumn:(id)arg2 item:(id)arg3;
- (BOOL)outlineView:(id)arg1 shouldTrackCell:(id)arg2 forTableColumn:(id)arg3 item:(id)arg4;
- (BOOL)outlineView:(id)arg1 shouldShowCellExpansionForTableColumn:(id)arg2 item:(id)arg3;
- (BOOL)outlineView:(id)arg1 shouldTypeSelectForEvent:(id)arg2 withCurrentSearchString:(id)arg3;
- (id)outlineView:(id)arg1 nextTypeSelectMatchFromItem:(id)arg2 toItem:(id)arg3 forString:(id)arg4;
- (id)outlineView:(id)arg1 typeSelectStringForTableColumn:(id)arg2 item:(id)arg3;
- (double)outlineView:(id)arg1 heightOfRowByItem:(id)arg2;
- (id)outlineView:(id)arg1 toolTipForCell:(id)arg2 rect:(struct CGRect *)arg3 tableColumn:(id)arg4 item:(id)arg5 mouseLocation:(struct CGPoint)arg6;
- (void)outlineView:(id)arg1 didDragTableColumn:(id)arg2;
- (void)outlineView:(id)arg1 didClickTableColumn:(id)arg2;
- (void)outlineView:(id)arg1 mouseDownInHeaderOfTableColumn:(id)arg2;
- (BOOL)outlineView:(id)arg1 shouldSelectTableColumn:(id)arg2;
- (id)outlineView:(id)arg1 selectionIndexesForProposedSelection:(id)arg2;
- (BOOL)outlineView:(id)arg1 shouldSelectItem:(id)arg2;
- (BOOL)selectionShouldChangeInOutlineView:(id)arg1;
- (BOOL)outlineView:(id)arg1 shouldEditTableColumn:(id)arg2 item:(id)arg3;
- (void)outlineView:(id)arg1 willDisplayCell:(id)arg2 forTableColumn:(id)arg3 item:(id)arg4;
- (void)outlineView:(id)arg1 didRemoveRowView:(id)arg2 forRow:(long long)arg3;
- (void)outlineView:(id)arg1 didAddRowView:(id)arg2 forRow:(long long)arg3;
- (id)outlineView:(id)arg1 rowViewForItem:(id)arg2;
- (id)outlineView:(id)arg1 viewForTableColumn:(id)arg2 item:(id)arg3;
@end

@protocol NSSpeechSynthesizerDelegate <NSObject>

@optional
- (void)speechSynthesizer:(id)arg1 didEncounterSyncMessage:(id)arg2;
- (void)speechSynthesizer:(id)arg1 didEncounterErrorAtIndex:(unsigned long long)arg2 ofString:(id)arg3 message:(id)arg4;
- (void)speechSynthesizer:(id)arg1 willSpeakPhoneme:(short)arg2;
- (void)speechSynthesizer:(id)arg1 willSpeakWord:(struct _NSRange)arg2 ofString:(id)arg3;
- (void)speechSynthesizer:(id)arg1 didFinishSpeaking:(BOOL)arg2;
@end

@protocol NSSplitViewDelegate <NSObject>

@optional
- (void)splitViewDidResizeSubviews:(id)arg1;
- (void)splitViewWillResizeSubviews:(id)arg1;
- (struct CGRect)splitView:(id)arg1 additionalEffectiveRectOfDividerAtIndex:(long long)arg2;
- (struct CGRect)splitView:(id)arg1 effectiveRect:(struct CGRect)arg2 forDrawnRect:(struct CGRect)arg3 ofDividerAtIndex:(long long)arg4;
- (BOOL)splitView:(id)arg1 shouldHideDividerAtIndex:(long long)arg2;
- (BOOL)splitView:(id)arg1 shouldAdjustSizeOfSubview:(id)arg2;
- (void)splitView:(id)arg1 resizeSubviewsWithOldSize:(struct CGSize)arg2;
- (double)splitView:(id)arg1 constrainSplitPosition:(double)arg2 ofSubviewAt:(long long)arg3;
- (double)splitView:(id)arg1 constrainMaxCoordinate:(double)arg2 ofSubviewAt:(long long)arg3;
- (double)splitView:(id)arg1 constrainMinCoordinate:(double)arg2 ofSubviewAt:(long long)arg3;
- (BOOL)splitView:(id)arg1 shouldCollapseSubview:(id)arg2 forDoubleClickOnDividerAtIndex:(long long)arg3;
- (BOOL)splitView:(id)arg1 canCollapseSubview:(id)arg2;
@end

@protocol NSWindowDelegate <NSObject>

@optional
- (void)windowDidExitVersionBrowser:(id)arg1;
- (void)windowWillExitVersionBrowser:(id)arg1;
- (void)windowDidEnterVersionBrowser:(id)arg1;
- (void)windowWillEnterVersionBrowser:(id)arg1;
- (void)windowDidExitFullScreen:(id)arg1;
- (void)windowWillExitFullScreen:(id)arg1;
- (void)windowDidEnterFullScreen:(id)arg1;
- (void)windowWillEnterFullScreen:(id)arg1;
- (void)windowDidEndLiveResize:(id)arg1;
- (void)windowWillStartLiveResize:(id)arg1;
- (void)windowDidEndSheet:(id)arg1;
- (void)windowWillBeginSheet:(id)arg1;
- (void)windowDidChangeBackingProperties:(id)arg1;
- (void)windowDidChangeScreenProfile:(id)arg1;
- (void)windowDidChangeScreen:(id)arg1;
- (void)windowDidUpdate:(id)arg1;
- (void)windowDidDeminiaturize:(id)arg1;
- (void)windowDidMiniaturize:(id)arg1;
- (void)windowWillMiniaturize:(id)arg1;
- (void)windowWillClose:(id)arg1;
- (void)windowDidResignMain:(id)arg1;
- (void)windowDidBecomeMain:(id)arg1;
- (void)windowDidResignKey:(id)arg1;
- (void)windowDidBecomeKey:(id)arg1;
- (void)windowDidMove:(id)arg1;
- (void)windowWillMove:(id)arg1;
- (void)windowDidExpose:(id)arg1;
- (void)windowDidResize:(id)arg1;
- (void)window:(id)arg1 didDecodeRestorableState:(id)arg2;
- (void)window:(id)arg1 willEncodeRestorableState:(id)arg2;
- (struct CGSize)window:(id)arg1 willResizeForVersionBrowserWithMaxPreferredSize:(struct CGSize)arg2 maxAllowedSize:(struct CGSize)arg3;
- (void)windowDidFailToExitFullScreen:(id)arg1;
- (void)window:(id)arg1 startCustomAnimationToExitFullScreenWithDuration:(double)arg2;
- (id)customWindowsToExitFullScreenForWindow:(id)arg1;
- (void)windowDidFailToEnterFullScreen:(id)arg1;
- (void)window:(id)arg1 startCustomAnimationToEnterFullScreenWithDuration:(double)arg2;
- (id)customWindowsToEnterFullScreenForWindow:(id)arg1;
- (unsigned long long)window:(id)arg1 willUseFullScreenPresentationOptions:(unsigned long long)arg2;
- (struct CGSize)window:(id)arg1 willUseFullScreenContentSize:(struct CGSize)arg2;
- (BOOL)window:(id)arg1 shouldDragDocumentWithEvent:(id)arg2 from:(struct CGPoint)arg3 withPasteboard:(id)arg4;
- (BOOL)window:(id)arg1 shouldPopUpDocumentPathMenu:(id)arg2;
- (struct CGRect)window:(id)arg1 willPositionSheet:(id)arg2 usingRect:(struct CGRect)arg3;
- (id)windowWillReturnUndoManager:(id)arg1;
- (BOOL)windowShouldZoom:(id)arg1 toFrame:(struct CGRect)arg2;
- (struct CGRect)windowWillUseStandardFrame:(id)arg1 defaultFrame:(struct CGRect)arg2;
- (struct CGSize)windowWillResize:(id)arg1 toSize:(struct CGSize)arg2;
- (id)windowWillReturnFieldEditor:(id)arg1 toObject:(id)arg2;
- (BOOL)windowShouldClose:(id)arg1;
@end

@protocol __ARCLiteIndexedSubscripting__
- (void)setObject:(id)arg1 atIndexedSubscript:(unsigned long long)arg2;
- (id)objectAtIndexedSubscript:(unsigned long long)arg1;
@end

@protocol __ARCLiteKeyedSubscripting__
- (void)setObject:(id)arg1 forKeyedSubscript:(id)arg2;
- (id)objectForKeyedSubscript:(id)arg1;
@end

@interface AZQueue : NSObject
{
    NSMutableArray *array;
}

- (void).cxx_destruct;
- (void)clear;
- (BOOL)isEmpty;
- (long long)size;
- (id)peek;
- (void)enqueueElementsFromQueue:(id)arg1;
- (void)enqueueElementsFromArray:(id)arg1;
- (void)enqueue:(id)arg1;
- (id)dequeue;
- (id)init;

@end

@interface AZSize : NSObject
{
    double width;
    double height;
}

+ (BOOL)maybeSize:(id)arg1;
+ (id)sizeWithWidth:(double)arg1 height:(double)arg2;
+ (id)sizeWithSize:(struct CGSize)arg1;
+ (id)sizeOf:(id)arg1;
+ (id)size;
@property double height; // @synthesize height;
@property double width; // @synthesize width;
- (id)description;
- (id)invert;
- (id)negate;
- (id)swap;
- (id)divideBySize:(struct CGSize)arg1;
- (id)divideByPoint:(struct CGPoint)arg1;
- (id)divideByWidth:(double)arg1 height:(double)arg2;
- (id)divideBy:(id)arg1;
- (id)multipyBySize:(struct CGSize)arg1;
- (id)multipyByPoint:(struct CGPoint)arg1;
- (id)multipyByWidth:(double)arg1 height:(double)arg2;
- (id)multipyBy:(id)arg1;
- (id)growByWidth:(double)arg1 height:(double)arg2;
- (id)growBy:(id)arg1;
@property struct CGSize size;
@property(readonly) double wthRatio;
@property(readonly) double max;
@property(readonly) double min;
- (id)initWithSize:(struct CGSize)arg1;
- (id)initWithWidth:(double)arg1 height:(double)arg2;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)copy;

@end

@interface FliprAnimation : NSAnimation
{
}

- (void)setCurrentProgress:(float)arg1;
- (void)startAtProgress:(float)arg1 withDuration:(double)arg2;
- (id)initWithAnimationCurve:(unsigned long long)arg1;

@end

@interface FliprView : NSView
{
    struct CGRect originalRect;
    NSWindow *initialWindow;
    NSWindow *finalWindow;
    CIImage *finalImage;
    CIFilter *transitionFilter;
    NSShadow *shadow;
    FliprAnimation *animation;
    float direction;
    float frameTime;
}

- (void)drawRect:(struct CGRect)arg1;
- (void)animationDidEnd:(id)arg1;
- (void)setInitialWindow:(id)arg1 andFinalWindow:(id)arg2 forward:(BOOL)arg3;
- (BOOL)isOpaque;
- (void)dealloc;
- (id)initWithFrame:(struct CGRect)arg1 andOriginalRect:(struct CGRect)arg2;

@end

@interface AZBoxMagic : NSView
{
    struct CGSize cellSize;
    unsigned long long rows;
    unsigned long long columns;
    NSMutableArray *filingCabinet;
    id <AZBoxMagicDataSource> dataSource;
}

@property(retain, nonatomic) id <AZBoxMagicDataSource> dataSource; // @synthesize dataSource;
@property(retain) NSMutableArray *filingCabinet; // @synthesize filingCabinet;
@property unsigned long long columns; // @synthesize columns;
@property unsigned long long rows; // @synthesize rows;
@property struct CGSize cellSize; // @synthesize cellSize;
- (void).cxx_destruct;
- (void)reload;
- (void)drawRect:(struct CGRect)arg1;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface AZIndeterminateIndicator : NSCell
{
    float redComponent;
    float greenComponent;
    float blueComponent;
    NSTimer *theTimer;
    NSControl *parentControl;
    BOOL spinning;
    double doubleValue;
    double animationDelay;
    BOOL displayedWhenStopped;
    NSColor *color;
}

@property(retain, nonatomic) NSColor *color; // @synthesize color;
@property(retain, nonatomic) NSControl *parentControl; // @synthesize parentControl;
- (void).cxx_destruct;
- (void)setObjectValue:(id)arg1;
- (void)drawInteriorWithFrame:(struct CGRect)arg1 inView:(id)arg2;
- (void)drawWithFrame:(struct CGRect)arg1 inView:(id)arg2;
- (void)animate:(id)arg1;
@property(getter=isSpinning) BOOL spinning; // @synthesize spinning;
@property(getter=isDisplayedWhenStopped) BOOL displayedWhenStopped; // @synthesize displayedWhenStopped;
@property double animationDelay; // @synthesize animationDelay;
@property double doubleValue; // @synthesize doubleValue;
- (id)init;

@end

@interface AZDummy : NSObject
{
}

@end

@interface AtoZ : BaseModel
{
    BOOL fontsRegistered;
    NSBundle *_bundle;
}

+ (id)runningAppsAsStrings;
+ (id)runningApps;
+ (id)defs;
+ (id)jsonReuest:(id)arg1;
+ (id)fontWithSize:(double)arg1;
+ (void)trackIt;
+ (id)version;
+ (id)appCategories;
+ (id)stringForType:(id)arg1;
+ (id)resources;
+ (id)stringForPosition:(int)arg1;
+ (void)printTransform:(struct CGAffineTransform)arg1;
+ (void)printPoint:(struct CGPoint)arg1;
+ (void)printCGPoint:(struct CGPoint)arg1;
+ (void)printRect:(struct CGRect)arg1;
+ (void)printCGRect:(struct CGRect)arg1;
+ (struct CGRect)rectFromPointA:(struct CGPoint)arg1 andPointB:(struct CGPoint)arg2;
+ (id)cropImage:(id)arg1 withRect:(struct CGRect)arg2;
+ (struct CGPoint)centerOfRect:(struct CGRect)arg1;
+ (struct CGRect)centerSize:(struct CGSize)arg1 inRect:(struct CGRect)arg2;
+ (double)scaleForSize:(struct CGSize)arg1 inRect:(struct CGRect)arg2;
+ (double)clamp:(double)arg1 from:(double)arg2 to:(double)arg3;
@property(retain, nonatomic) NSBundle *bundle; // @synthesize bundle=_bundle;
- (void).cxx_destruct;
- (void)badgeApplicationIcon:(id)arg1;
- (void)playNotificationSound:(id)arg1;
- (void)handleMouseEvent:(unsigned long long)arg1 inView:(id)arg2 withBlock:(id)arg3;
- (void)moveMouseToScreenPoint:(struct CGPoint)arg1;
- (struct CGPoint)convertToScreenFromLocalPoint:(struct CGPoint)arg1 relativeToView:(id)arg2;
- (id)jsonReuest:(id)arg1;
- (void)mouseSelector;
- (id)registerFonts:(double)arg1;
- (void)setUp;
- (int)imageTypeStringToEnum:(id)arg1;

@end

@interface Box : NSView
{
    NSColor *color;
    NSColor *save;
    BOOL selected;
    CAShapeLayer *shapeLayer;
}

@property(copy) CAShapeLayer *shapeLayer; // @synthesize shapeLayer;
@property BOOL selected; // @synthesize selected;
@property(copy) NSColor *save; // @synthesize save;
@property(copy) NSColor *color; // @synthesize color;
- (void).cxx_destruct;
- (void)flash:(id)arg1;
- (void)mouseUp:(id)arg1;
- (void)drawRect:(struct CGRect)arg1;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface NSViewFlipperController : NSObject
{
    NSView *hostView;
    NSView *frontView;
    NSView *backView;
    NSView *topView;
    NSView *bottomView;
    CALayer *topLayer;
    CALayer *bottomLayer;
    BOOL isFlipped;
    double duration;
}

@property double duration; // @synthesize duration;
@property(readonly) BOOL isFlipped; // @synthesize isFlipped;
- (void).cxx_destruct;
@property(readonly) NSView *visibleView;
- (void)animationDidStop:(id)arg1 finished:(BOOL)arg2;
- (void)flip;
- (id)initWithHostView:(id)arg1 frontView:(id)arg2 backView:(id)arg3;

@end

@interface BaseModel : NSObject <BaseModel, NSCoding, NSCopying, NSFastEnumeration>
{
    NSString *_uniqueID;
    NSMutableArray *_backingstore;
    BOOL _usesBackingStore;
}

+ (BOOL)deleteEverything;
+ (BOOL)delete:(id)arg1;
+ (BOOL)persist:(id)arg1 key:(id)arg2;
+ (id)retrieve:(id)arg1;
+ (id)newUniqueIdentifier;
+ (id)instanceWithContentsOfFile:(id)arg1;
+ (id)instanceWithCoder:(id)arg1;
+ (id)instancesWithArray:(id)arg1;
+ (id)instanceWithObject:(id)arg1;
+ (id)instance;
+ (id)saveFile;
+ (id)resourceFile;
+ (void)reloadSharedInstance;
+ (id)sharedInstance;
+ (BOOL)hasSharedInstance;
+ (void)setSharedInstance:(id)arg1;
+ (id)saveFilePath;
+ (id)saveFilePath:(id)arg1;
+ (id)resourceFilePath;
+ (id)resourceFilePath:(id)arg1;
+ (id)instanceWithID:(id)arg1;
@property(nonatomic) BOOL usesBackingStore; // @synthesize usesBackingStore=_usesBackingStore;
@property(retain, nonatomic) NSMutableArray *backingstore; // @synthesize backingstore=_backingstore;
@property(retain, nonatomic) NSString *uniqueID; // @synthesize uniqueID=_uniqueID;
- (void).cxx_destruct;
- (id)description;
- (void)writeToDescription:(id)arg1 withIndent:(unsigned long long)arg2;
- (void)writeLineBreakToString:(id)arg1 withTabs:(unsigned long long)arg2;
- (unsigned long long)hash;
- (BOOL)isEqual:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (void)encodeWithCoder:(id)arg1;
- (void)enumerateIvarsUsingBlock:(id)arg1;
- (void)dealloc;
- (void)writeToFile:(id)arg1 atomically:(BOOL)arg2;
- (id)initWithContentsOfFile:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)initWithObject:(id)arg1;
- (id)setterNameForClass:(Class)arg1;
- (id)init;
- (id)objectAtIndex:(unsigned long long)arg1;
- (unsigned long long)count;
- (unsigned long long)countByEnumeratingWithState:(CDStruct_70511ce9 *)arg1 objects:(id *)arg2 count:(unsigned long long)arg3;
- (void)setUp;
- (id)filter:(id)arg1;
- (id)map:(id)arg1;
- (void)eachWithIndex:(id)arg1;
- (id)nmap:(id)arg1;
- (void)save;
- (BOOL)useHRCoderIfAvailable;
- (id)saveInstanceInAppSupp;
- (void)setObject:(id)arg1 forKeyedSubscript:(id)arg2;
- (id)objectForKeyedSubscript:(id)arg1;
- (id)normal:(long long)arg1;
- (id)objectAtNormalizedIndex:(long long)arg1;
- (id)randomSubarrayWithSize:(unsigned long long)arg1;
- (id)shuffeled;
- (id)randomElement;
- (void)setObject:(id)arg1 atIndexedSubscript:(long long)arg2;
- (id)objectAtIndexedSubscript:(long long)arg1;

@end

@interface AZGrid : NSObject
{
    NSMutableArray *array;
    unsigned long long parallels;
    unsigned long long style;
    unsigned long long order;
    BOOL rowMajorOrder;
}

- (void).cxx_destruct;
- (id)description;
- (id)objectAtPoint:(struct CGPoint)arg1;
- (id)indexAtPoint:(struct CGPoint)arg1;
- (id)pointAtIndex:(unsigned long long)arg1;
@property(readonly) double max;
@property(readonly) double min;
@property(readonly) double height;
@property(readonly) double width;
@property(readonly) AZSize *size;
- (id)objectAtIndex:(unsigned long long)arg1;
- (void)removeObjectAtIndex:(unsigned long long)arg1;
- (void)removeAllObjects;
- (void)insertObject:(id)arg1 atIndex:(unsigned long long)arg2;
- (void)addObject:(id)arg1;
- (id)elements;
@property(readonly) unsigned long long count;
@property unsigned long long order;
@property unsigned long long style;
@property unsigned long long parallels;
- (id)initWithCapacity:(unsigned long long)arg1;
- (id)init;
- (void)_init;

@end

@interface AZMatrix : NSObject
{
    unsigned long long width;
    unsigned long long height;
    NSMutableArray *data;
}

@property(nonatomic) unsigned long long height; // @synthesize height;
@property(nonatomic) unsigned long long width; // @synthesize width;
- (void).cxx_destruct;
- (id)objectAtX:(unsigned long long)arg1 y:(unsigned long long)arg2;
- (id)init;

@end

@interface AZPoint : NSObject
{
    double x;
    double y;
}

+ (BOOL)maybePoint:(id)arg1;
+ (id)halfPoint;
+ (id)pointWithPoint:(struct CGPoint)arg1;
+ (id)pointWithX:(double)arg1 y:(double)arg2;
+ (id)pointOf:(id)arg1;
+ (id)point;
@property double y; // @synthesize y;
@property double x; // @synthesize x;
- (id)description;
- (BOOL)isWithin:(id)arg1;
- (BOOL)equalsPoint:(struct CGPoint)arg1;
- (BOOL)equals:(id)arg1;
- (id)divideBy:(id)arg1;
- (id)multiplyBy:(id)arg1;
- (id)moveByX:(double)arg1 andY:(double)arg2;
- (id)moveByPoint:(struct CGPoint)arg1;
- (id)moveByNegative:(id)arg1;
- (id)moveBy:(id)arg1;
- (id)moveTowardsPoint:(struct CGPoint)arg1 withDistance:(double)arg2;
- (id)moveTowards:(id)arg1 withDistance:(double)arg2;
- (id)moveTo:(id)arg1;
- (id)ratio;
- (id)root;
- (id)square;
- (id)ceil;
- (id)round;
- (id)floor;
- (id)invert;
- (id)negate;
- (id)swap;
@property(readonly) double max;
@property(readonly) double min;
@property(readonly) struct CGPoint cgpoint;
@property struct CGPoint point;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)copy;
- (id)initWithPoint:(struct CGPoint)arg1;
- (id)initWithX:(double)arg1 y:(double)arg2;
- (id)init;

@end

@interface AZRect : AZPoint
{
    double width;
    double height;
}

+ (BOOL)maybeRect:(id)arg1;
+ (id)rectWithX:(double)arg1 andY:(double)arg2 width:(double)arg3 height:(double)arg4;
+ (id)rectWithOrigin:(struct CGPoint)arg1 andSize:(struct CGSize)arg2;
+ (id)rectWithRect:(struct CGRect)arg1;
+ (id)rectOf:(id)arg1;
+ (id)rect;
@property double height; // @synthesize height;
@property double width; // @synthesize width;
- (id)sizeTo:(id)arg1 ofRect:(id)arg2;
- (id)moveTo:(id)arg1 ofRect:(id)arg2;
- (id)centerOn:(id)arg1;
- (void)fill;
- (void)drawFrame;
- (BOOL)containsRect:(struct CGRect)arg1;
- (BOOL)containsPoint:(struct CGPoint)arg1;
- (BOOL)contains:(id)arg1;
- (BOOL)equals:(id)arg1;
- (id)growBySizePadding:(struct CGSize)arg1;
- (id)growByPadding:(long long)arg1;
- (id)growBy:(id)arg1;
- (id)shrinkBySizePadding:(struct CGSize)arg1;
- (id)shrinkByPadding:(long long)arg1;
- (id)shrinkBy:(id)arg1;
- (id)insetRectWithPadding:(long long)arg1;
@property struct CGRect rect;
@property struct CGPoint center;
@property struct CGSize size;
@property(readonly) double area;
@property struct CGPoint origin;
- (id)description;
- (id)copy;
- (id)initFromPoint:(struct CGPoint)arg1 toPoint:(struct CGPoint)arg2;
- (id)initWithSize:(struct CGSize)arg1;
- (id)initWithRect:(struct CGRect)arg1;
- (id)init;
- (id)segmentedRectWithWidth:(unsigned long long)arg1 height:(unsigned long long)arg2;
- (id)segmentedRectWithCubicSize:(unsigned long long)arg1;
- (id)segmentedRect;

@end

@interface AZTalker : NSObject <NSSpeechSynthesizerDelegate>
{
    NSSpeechSynthesizer *_talker;
}

+ (void)say:(id)arg1;
@property(retain, nonatomic) NSSpeechSynthesizer *talker; // @synthesize talker=_talker;
- (void).cxx_destruct;
- (void)say:(id)arg1;
- (id)init;

@end

@interface Candidate : BaseModel
{
    float _height;
    float _width;
    struct CGRect _screen;
    float _aspectRatio;
    int _rows;
    int _columns;
    int _remainder;
}

+ (id)withRows:(unsigned long long)arg1 columns:(unsigned long long)arg2 remainder:(long long)arg3 forRect:(struct CGRect)arg4;
@property int remainder; // @synthesize remainder=_remainder;
@property int columns; // @synthesize columns=_columns;
@property int rows; // @synthesize rows=_rows;
@property float aspectRatio; // @synthesize aspectRatio=_aspectRatio;
@property struct CGRect screen; // @synthesize screen=_screen;
@property float width; // @synthesize width=_width;
@property float height; // @synthesize height=_height;
- (id)initWithDictionary:(id)arg1;

@end

@interface AZSizer : BaseModel
{
    int _orient;
    double _height;
    NSArray *_paths;
    NSArray *_boxes;
    double _width;
    NSMutableArray *_positions;
    NSMutableArray *_candidates;
    NSArray *_rects;
    struct CGRect _outerFrame;
    unsigned long long _rows;
    unsigned long long _columns;
    unsigned long long _quantity;
    struct CGSize _size;
}

+ (id)forQuantity:(unsigned long long)arg1 aroundRect:(struct CGRect)arg2;
+ (id)rectsForQuantity:(unsigned long long)arg1 inRect:(struct CGRect)arg2;
+ (id)forQuantity:(unsigned long long)arg1 inRect:(struct CGRect)arg2;
+ (struct CGRect)structForQuantity:(unsigned long long)arg1 inRect:(struct CGRect)arg2;
@property(nonatomic) struct CGSize size; // @synthesize size=_size;
@property(nonatomic) unsigned long long quantity; // @synthesize quantity=_quantity;
@property(nonatomic) unsigned long long columns; // @synthesize columns=_columns;
@property(nonatomic) unsigned long long rows; // @synthesize rows=_rows;
@property(nonatomic) struct CGRect outerFrame; // @synthesize outerFrame=_outerFrame;
@property(copy, nonatomic) NSArray *rects; // @synthesize rects=_rects;
@property(retain, nonatomic) NSMutableArray *candidates; // @synthesize candidates=_candidates;
@property(copy, nonatomic) NSMutableArray *positions; // @synthesize positions=_positions;
@property(nonatomic) double width; // @synthesize width=_width;
@property(readonly) NSArray *boxes; // @synthesize boxes=_boxes;
@property(readonly) NSArray *paths; // @synthesize paths=_paths;
@property(nonatomic) double height; // @synthesize height=_height;
@property(nonatomic) int orient; // @synthesize orient=_orient;
- (void).cxx_destruct;
@property(readonly) long long remainder;
@property(readonly) unsigned long long capacity;
@property(readonly) NSString *aspectRatio;
- (id)initWithQuantity:(unsigned long long)arg1 inRect:(struct CGRect)arg2;

@end

@interface InfiniteDocumentView : NSView
{
}

@end

@interface InfiniteImageView : NSImageView
{
}

- (BOOL)isFlipped;

@end

@interface AtoZInfinity : NSScrollView
{
    NSImage *bar;
    NSImage *snap;
    BOOL visible;
    BOOL hovered;
    float offset;
    BOOL scrollUp;
    NSIndexSet *screenSet;
    InfiniteImageView *_imageViewBar;
    struct CGRect _barUnit;
    NSArray *_infiniteObjects;
    struct CGSize _totalBar;
    InfiniteDocumentView *_docV;
    int _scale;
    struct CGRect _unit;
    struct CGRect _totalBarFrame;
    NSTrackingArea *_trackingArea;
    int _orientation;
}

@property(nonatomic) int orientation; // @synthesize orientation=_orientation;
@property(nonatomic) NSTrackingArea *trackingArea; // @synthesize trackingArea=_trackingArea;
@property(nonatomic) struct CGRect totalBarFrame; // @synthesize totalBarFrame=_totalBarFrame;
@property(nonatomic) struct CGRect unit; // @synthesize unit=_unit;
@property(nonatomic) int scale; // @synthesize scale=_scale;
@property(retain, nonatomic) InfiniteDocumentView *docV; // @synthesize docV=_docV;
@property(nonatomic) struct CGSize totalBar; // @synthesize totalBar=_totalBar;
@property(retain, nonatomic) NSArray *infiniteObjects; // @synthesize infiniteObjects=_infiniteObjects;
@property(nonatomic) struct CGRect barUnit; // @synthesize barUnit=_barUnit;
@property(retain, nonatomic) InfiniteImageView *imageViewBar; // @synthesize imageViewBar=_imageViewBar;
- (void).cxx_destruct;
- (BOOL)isOpaque;
- (void)evalMouse:(struct CGPoint)arg1;
- (void)boundsDidChangeNotification:(id)arg1;
- (void)mouseMoved:(id)arg1;
- (void)setupInfiniBar;
- (void)viewDidEndLiveResize;
- (void)awakeFromNib;

@end

@interface AZBlockView : NSView
{
    id drawBlock;
    BOOL opaque;
}

+ (id)viewWithFrame:(struct CGRect)arg1 opaque:(BOOL)arg2 drawnUsingBlock:(id)arg3;
@property(nonatomic) BOOL opaque; // @synthesize opaque;
@property(copy, nonatomic) id drawBlock; // @synthesize drawBlock;
- (void).cxx_destruct;
- (BOOL)isOpaque;
- (void)drawRect:(struct CGRect)arg1;

@end

@interface AZAXAuthorization : NSObject
{
}

- (void)Restart:(id)arg1;
- (BOOL)RunCommand:(id)arg1;
- (id)BundleName;

@end

@interface AZPopupWindow : NSWindow
{
    struct CGRect _originalWidowFrame;
    struct CGRect _originalLayerFrame;
    NSView *_oldContentView;
    NSResponder *_oldFirstResponder;
    NSView *_animationView;
    CALayer *_animationLayer;
    BOOL _growing;
    BOOL _shrinking;
    BOOL _pretendKeyForDrawing;
}

- (void).cxx_destruct;
- (void)popup;
- (BOOL)isKeyWindow;
- (BOOL)canBecomeKeyWindow;
- (void)animationDidStop:(id)arg1 finished:(BOOL)arg2;
- (void)_addAnimationToScale:(double)arg1 duration:(double)arg2;
- (struct CATransform3D)_transformForScale:(double)arg1;
- (void)_cleanupAndRestoreViews;

@end

@interface AZAttachedWindow : NSWindow
{
    NSColor *_AZBackgroundColor;
    NSView *_view;
    NSWindow *_window;
    struct CGPoint _point;
    int _side;
    float _distance;
    struct CGRect _viewFrame;
    BOOL _resizing;
    struct CGPoint initialLocation;
    float _viewMargin;
    int _pos;
    float _borderWidth;
    NSColor *_borderColor;
    float _arrowBaseWidth;
    float _arrowHeight;
    BOOL _hasArrow;
    float _cornerRadius;
    BOOL _drawsRoundCornerBesideArrow;
}

@property(nonatomic) BOOL drawsRoundCornerBesideArrow; // @synthesize drawsRoundCornerBesideArrow=_drawsRoundCornerBesideArrow;
@property(nonatomic) float cornerRadius; // @synthesize cornerRadius=_cornerRadius;
@property(nonatomic) BOOL hasArrow; // @synthesize hasArrow=_hasArrow;
@property(nonatomic) float arrowHeight; // @synthesize arrowHeight=_arrowHeight;
@property(nonatomic) float arrowBaseWidth; // @synthesize arrowBaseWidth=_arrowBaseWidth;
@property(retain, nonatomic) NSColor *borderColor; // @synthesize borderColor=_borderColor;
@property(nonatomic) float borderWidth; // @synthesize borderWidth=_borderWidth;
@property(nonatomic) int pos; // @synthesize pos=_pos;
@property(nonatomic) float viewMargin; // @synthesize viewMargin=_viewMargin;
@property(retain, nonatomic) NSView *view; // @synthesize view=_view;
- (void).cxx_destruct;
- (void)mouseDown:(id)arg1;
- (void)mouseDragged:(id)arg1;
- (void)setBackgroundImage:(id)arg1;
- (void)setBackgroundColor:(id)arg1;
- (id)windowBackgroundColor;
- (void)windowDidResize:(id)arg1;
- (void)performClose:(id)arg1;
- (BOOL)validateMenuItem:(id)arg1;
- (BOOL)isExcludedFromWindowsMenu;
- (BOOL)canBecomeKeyWindow;
- (BOOL)canBecomeMainWindow;
- (void)_redisplay;
- (void)_appendArrowToPath:(id)arg1;
- (id)_backgroundPath;
- (id)_backgroundColorPatternImage;
- (void)_updateBackground;
- (float)_arrowInset;
- (int)_bestSideForAutomaticPosition;
- (void)_updateGeometry;
- (void)dealloc;
- (id)initWithView:(id)arg1 attachedToPoint:(struct CGPoint)arg2;
- (id)initWithView:(id)arg1 attachedToPoint:(struct CGPoint)arg2 onSide:(int)arg3;
- (id)initWithView:(id)arg1 attachedToPoint:(struct CGPoint)arg2 inWindow:(id)arg3;
- (id)initWithView:(id)arg1 attachedToPoint:(struct CGPoint)arg2 atDistance:(float)arg3;
- (id)initWithView:(id)arg1 attachedToPoint:(struct CGPoint)arg2 onSide:(int)arg3 atDistance:(float)arg4;
- (id)initWithView:(id)arg1 attachedToPoint:(struct CGPoint)arg2 inWindow:(id)arg3 atDistance:(float)arg4;
- (id)initWithView:(id)arg1 attachedToPoint:(struct CGPoint)arg2 inWindow:(id)arg3 onSide:(int)arg4 atDistance:(float)arg5;

@end

@interface DummyListClass : NSObject
{
}

@end

@interface HRCoderAliasPlaceholder : NSObject
{
}

+ (id)placeholder;
- (id)description;

@end

@interface HRCoder : NSCoder
{
    NSMutableArray *stack;
    NSMutableDictionary *knownObjects;
    NSMutableDictionary *unresolvedAliases;
    NSString *keyPath;
}

+ (BOOL)archiveRootObject:(id)arg1 toFile:(id)arg2;
+ (id)archivedPlistWithRootObject:(id)arg1;
+ (id)unarchiveObjectWithFile:(id)arg1;
+ (id)unarchiveObjectWithPlist:(id)arg1;
+ (id)classNameKey;
@property(retain, nonatomic) NSString *keyPath; // @synthesize keyPath;
@property(retain, nonatomic) NSMutableDictionary *unresolvedAliases; // @synthesize unresolvedAliases;
@property(retain, nonatomic) NSMutableDictionary *knownObjects; // @synthesize knownObjects;
@property(retain, nonatomic) NSMutableArray *stack; // @synthesize stack;
- (void).cxx_destruct;
- (const char *)decodeBytesForKey:(id)arg1 returnedLength:(unsigned long long *)arg2;
- (double)decodeDoubleForKey:(id)arg1;
- (float)decodeFloatForKey:(id)arg1;
- (long long)decodeInt64ForKey:(id)arg1;
- (int)decodeInt32ForKey:(id)arg1;
- (int)decodeIntForKey:(id)arg1;
- (BOOL)decodeBoolForKey:(id)arg1;
- (id)decodeObjectForKey:(id)arg1;
- (id)decodeObject:(id)arg1 forKey:(id)arg2;
- (void)encodeBytes:(const char *)arg1 length:(unsigned long long)arg2 forKey:(id)arg3;
- (void)encodeDouble:(double)arg1 forKey:(id)arg2;
- (void)encodeFloat:(float)arg1 forKey:(id)arg2;
- (void)encodeInt64:(long long)arg1 forKey:(id)arg2;
- (void)encodeInt32:(int)arg1 forKey:(id)arg2;
- (void)encodeInt:(int)arg1 forKey:(id)arg2;
- (void)encodeBool:(BOOL)arg1 forKey:(id)arg2;
- (void)encodeConditionalObject:(id)arg1 forKey:(id)arg2;
- (void)encodeObject:(id)arg1 forKey:(id)arg2;
- (id)encodedObject:(id)arg1 forKey:(id)arg2;
- (BOOL)containsValueForKey:(id)arg1;
- (BOOL)allowsKeyedCoding;
- (void)dealloc;
- (BOOL)archiveRootObject:(id)arg1 toFile:(id)arg2;
- (id)archivedPlistWithRootObject:(id)arg1;
- (id)unarchiveObjectWithFile:(id)arg1;
- (id)unarchiveObjectWithPlist:(id)arg1;
- (id)init;

@end

@interface AZProgressIndicator : NSView
{
    NSThread *_animationThread;
    int position;
    struct CGRect indeterminateRect;
    int _step;
    NSTimer *_timer;
    NSImage *_indeterminateImage;
    NSImage *_indeterminateImage2;
    BOOL _animationStarted;
    BOOL _animationStartedThreaded;
    float _gradientWidth;
    double doubleValue;
    double maxValue;
    double cornerRadius;
    BOOL isIndeterminate;
    BOOL usesThreadedAnimation;
    float shadowBlur;
    NSColor *shadowColor;
    NSString *progressText;
    float fontSize;
    NSColor *progressHolderColor;
    NSColor *progressColor;
    NSColor *backgroundTextColor;
    NSColor *frontTextColor;
}

@property(retain, nonatomic) NSColor *frontTextColor; // @synthesize frontTextColor;
@property(retain, nonatomic) NSColor *backgroundTextColor; // @synthesize backgroundTextColor;
@property(retain, nonatomic) NSColor *progressColor; // @synthesize progressColor;
@property(retain, nonatomic) NSColor *progressHolderColor; // @synthesize progressHolderColor;
@property(nonatomic) float fontSize; // @synthesize fontSize;
@property(retain, nonatomic) NSString *progressText; // @synthesize progressText;
@property(retain, nonatomic) NSColor *shadowColor; // @synthesize shadowColor;
@property(nonatomic) float shadowBlur; // @synthesize shadowBlur;
@property(nonatomic) BOOL usesThreadedAnimation; // @synthesize usesThreadedAnimation;
@property(nonatomic) double cornerRadius; // @synthesize cornerRadius;
@property(nonatomic) double maxValue; // @synthesize maxValue;
@property(nonatomic) double doubleValue; // @synthesize doubleValue;
- (void).cxx_destruct;
- (void)setFrame:(struct CGRect)arg1;
- (void)animateInBackgroundThread;
@property(nonatomic, setter=setIsIndeterminate:) BOOL isIndeterminate; // @synthesize isIndeterminate;
- (void)stopAnimation:(id)arg1;
- (void)startAnimation:(id)arg1;
- (int)progressTextAlignt;
- (void)setProgressTextAlign:(int)arg1;
- (float)alignTextOnProgress:(struct CGRect)arg1 fontSize:(struct CGSize)arg2;
- (void)drawIndeterminate:(id)arg1;
- (void)makeIndeterminatePole;
- (void)drawRect:(struct CGRect)arg1;
- (void)cycle;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface AZBox : NSView
{
    NSTrackingArea *tArea;
    NSBezierPath *standard;
    float mPhase;
    float all;
    NSTextView *tv;
    NSTimer *timer;
    NSButton *close;
    NSImage *image;
    NSColor *color;
    NSString *cellIdentifier;
    float dynamicStroke;
    long long index;
    float inset_;
    float radius_;
    BOOL hovered_;
    BOOL selected_;
    id representedObject_;
}

@property(retain, nonatomic) id representedObject; // @synthesize representedObject=representedObject_;
@property(nonatomic) BOOL selected; // @synthesize selected=selected_;
@property(nonatomic) BOOL hovered; // @synthesize hovered=hovered_;
@property(nonatomic) float radius; // @synthesize radius=radius_;
@property(nonatomic) float inset; // @synthesize inset=inset_;
@property(nonatomic) long long index; // @synthesize index;
@property(readonly, nonatomic) NSString *cellIdentifier; // @synthesize cellIdentifier;
- (void).cxx_destruct;
- (void)prepareForReuse;
- (void)mouseDown:(id)arg1;
- (void)mouseEntered:(id)arg1;
- (void)drawRect:(struct CGRect)arg1;
- (id)tv;
- (id)pathWithInset:(float)arg1;
- (float)halfwayWithInset;
- (void)updateTrackingAreas;
- (unsigned long long)trackoptions;
- (id)initWithFrame:(struct CGRect)arg1;
@property(readonly) float dynamicStroke; // @synthesize dynamicStroke;
- (void)handleAntAnimationTimer:(id)arg1;
- (id)initWithReuseIdentifier:(id)arg1;
- (void)dynamicStuff;
- (void)defaults;
- (id)initWithFrame:(struct CGRect)arg1 representing:(id)arg2 atIndex:(unsigned long long)arg3;

@end

@interface AZStopwatch : NSObject
{
    NSMutableDictionary *items;
}

+ (id)alloc;
+ (id)sharedInstance;
+ (void)print:(id)arg1;
+ (void)stop:(id)arg1;
+ (void)start:(id)arg1;
+ (void)stopwatch:(id)arg1 timing:(id)arg2;
+ (void)named:(id)arg1 block:(id)arg2;
- (void).cxx_destruct;
- (id)init;
- (void)add:(id)arg1;
- (void)remove:(id)arg1;
- (id)get:(id)arg1;

@end

@interface AZStopwatchItem : NSObject
{
    NSString *name;
    NSDate *started;
    NSDate *stopped;
}

+ (id)itemWithName:(id)arg1;
@property(retain, nonatomic) NSDate *stopped; // @synthesize stopped;
@property(retain, nonatomic) NSDate *started; // @synthesize started;
@property(retain, nonatomic) NSString *name; // @synthesize name;
- (void).cxx_destruct;
- (id)runtimePretty;
- (double)runtime;
- (double)runtimeMills;
- (id)description;
- (void)stop;

@end

@interface AZBoxGrid : NSView
{
    BOOL allowsSelection;
    BOOL allowsMultipleSelection;
    id <AZBoxGridDataSource> dataSource;
    id <AZBoxGridDelegate> delegate;
    unsigned long long numberOfColumns;
    unsigned long long numberOfRows;
    unsigned long long numberOfCells;
    unsigned long long lastHoverCellIndex;
    NSMutableDictionary *reusableCellQueues;
    NSMutableDictionary *visibleCells;
    NSMutableIndexSet *selection;
    double lastSelection;
    double lastDoubleClick;
    BOOL unselectOnMouseUp;
    BOOL updatingData;
    BOOL calledReloadData;
    struct CGSize cellSize;
    unsigned long long desiredNumberOfColumns;
    unsigned long long desiredNumberOfRows;
    BOOL magicSizing;
    float boxRadius_;
    float boxInset_;
    float scalar_;
}

@property(nonatomic) unsigned long long numberOfColumns; // @synthesize numberOfColumns;
@property(nonatomic) unsigned long long numberOfRows; // @synthesize numberOfRows;
@property(nonatomic) float scalar; // @synthesize scalar=scalar_;
@property(nonatomic) BOOL allowsMultipleSelection; // @synthesize allowsMultipleSelection;
@property(nonatomic) BOOL allowsSelection; // @synthesize allowsSelection;
@property(nonatomic) BOOL unselectOnMouseUp; // @synthesize unselectOnMouseUp;
@property(nonatomic) BOOL magicSizing; // @synthesize magicSizing;
@property(nonatomic) id <AZBoxGridDelegate> delegate; // @synthesize delegate;
@property(nonatomic) id <AZBoxGridDataSource> dataSource; // @synthesize dataSource;
@property(nonatomic) unsigned long long desiredNumberOfRows; // @synthesize desiredNumberOfRows;
@property(nonatomic) unsigned long long desiredNumberOfColumns; // @synthesize desiredNumberOfColumns;
@property(nonatomic) struct CGSize cellSize; // @synthesize cellSize;
- (void).cxx_destruct;
- (void)keyDown:(id)arg1;
- (void)mouseUp:(id)arg1;
- (void)mouseExited:(id)arg1;
- (void)mouseMoved:(id)arg1;
- (void)mouseDragged:(id)arg1;
- (void)mouseDown:(id)arg1;
- (void)dealloc;
- (id)initWithCoder:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1;
- (BOOL)isFlipped;
- (void)setupCollectionView;
- (void)commitChanges;
- (void)beginChanges;
- (void)setFrame:(struct CGRect)arg1;
- (void)updateLayout;
- (struct _NSRange)visibleRange;
- (void)scrollViewDidScroll:(id)arg1;
- (void)reloadData;
- (void)addMissingCells;
- (void)removeInvisibleCells;
- (void)reorderCellsAnimated:(BOOL)arg1;
- (void)queueCell:(id)arg1;
- (id)cellAtIndex:(unsigned long long)arg1;
- (id)dequeueReusableCellWithIdentifier:(id)arg1;
- (id)indexesOfCellsInRect:(struct CGRect)arg1;
- (struct CGRect)rectForCellAtIndex:(long long)arg1;
- (struct CGPoint)positionOfCellAtIndex:(unsigned long long)arg1;
- (unsigned long long)indexOfCellAtPosition:(struct CGPoint)arg1;
- (unsigned long long)indexOfCellAtPoint:(struct CGPoint)arg1;
- (void)hoverOutOfLastCell;
- (void)hoverOutOfCellAtIndex:(unsigned long long)arg1;
- (void)hoverOverCellAtIndex:(unsigned long long)arg1;
- (void)deselectAllCells;
- (void)deselectCellsAtIndexes:(id)arg1;
- (void)deselectCellAtIndex:(unsigned long long)arg1;
- (void)selectCellsAtIndexes:(id)arg1;
- (void)selectCellAtIndex:(unsigned long long)arg1;
@property(nonatomic) float boxInset; // @synthesize boxInset=boxInset_;
@property(nonatomic) float boxRadius; // @synthesize boxRadius=boxRadius_;
@property(readonly, nonatomic) NSIndexSet *selection;

@end

@interface AZHoverButton : NSButton
{
    NSTrackingArea *trackingArea;
}

- (void).cxx_destruct;
- (void)mouseExited:(id)arg1;
- (void)mouseEntered:(id)arg1;
- (void)updateTrackingAreas;

@end

@interface AZButtonCell : NSButtonCell
{
    NSBezierPath *__bezelPath;
    unsigned long long __buttonType;
    NSColor *color;
    BOOL isTopTab;
}

@property BOOL isTopTab; // @synthesize isTopTab;
@property(retain, nonatomic) NSColor *color; // @synthesize color;
- (void).cxx_destruct;
- (BOOL)az_shouldDrawBlueButton;
- (struct CGRect)az_drawCheckboxTitle:(id)arg1 withFrame:(struct CGRect)arg2 inView:(id)arg3;
- (struct CGRect)az_drawButtonTitle:(id)arg1 withFrame:(struct CGRect)arg2 inView:(id)arg3;
- (id)az_checkmarkPathForRect:(struct CGRect)arg1 mixed:(BOOL)arg2;
- (void)az_drawCheckboxBezelWithFrame:(struct CGRect)arg1 inView:(id)arg2;
- (void)az_drawButtonBezelWithFrame:(struct CGRect)arg1 inView:(id)arg2;
- (void)drawImage:(id)arg1 withFrame:(struct CGRect)arg2 inView:(id)arg3;
- (struct CGRect)drawTitle:(id)arg1 withFrame:(struct CGRect)arg2 inView:(id)arg3;
- (void)drawBezelWithFrame:(struct CGRect)arg1 inView:(id)arg2;
- (void)drawWithFrame:(struct CGRect)arg1 inView:(id)arg2;
- (void)setButtonType:(unsigned long long)arg1;
- (id)initWithCoder:(id)arg1;

@end

@interface AZButton : NSButton
{
}

+ (Class)cellClass;
- (id)initWithCoder:(id)arg1;

@end

@interface AZSourceList : NSOutlineView <NSOutlineViewDelegate, NSOutlineViewDataSource>
{
    id <AZSourceListDelegate> _secondaryDelegate;
    id <AZSourceListDataSource> _secondaryDataSource;
    struct CGSize _iconSize;
}

@property(nonatomic) struct CGSize iconSize; // @synthesize iconSize=_iconSize;
- (void).cxx_destruct;
- (void)registerDelegateToReceiveNotification:(id)arg1 withSelector:(SEL)arg2;
- (void)outlineViewItemDidCollapse:(id)arg1;
- (void)outlineViewItemWillCollapse:(id)arg1;
- (void)outlineViewItemDidExpand:(id)arg1;
- (void)outlineViewItemWillExpand:(id)arg1;
- (void)outlineViewSelectionDidChange:(id)arg1;
- (void)outlineViewSelectionIsChanging:(id)arg1;
- (BOOL)outlineView:(id)arg1 isGroupItem:(id)arg2;
- (double)outlineView:(id)arg1 heightOfRowByItem:(id)arg2;
- (BOOL)outlineView:(id)arg1 shouldTrackCell:(id)arg2 forTableColumn:(id)arg3 item:(id)arg4;
- (BOOL)outlineView:(id)arg1 shouldEditTableColumn:(id)arg2 item:(id)arg3;
- (id)outlineView:(id)arg1 selectionIndexesForProposedSelection:(id)arg2;
- (BOOL)outlineView:(id)arg1 shouldSelectItem:(id)arg2;
- (void)outlineView:(id)arg1 willDisplayCell:(id)arg2 forTableColumn:(id)arg3 item:(id)arg4;
- (id)outlineView:(id)arg1 dataCellForTableColumn:(id)arg2 item:(id)arg3;
- (BOOL)outlineView:(id)arg1 shouldCollapseItem:(id)arg2;
- (BOOL)outlineView:(id)arg1 shouldExpandItem:(id)arg2;
- (id)outlineView:(id)arg1 namesOfPromisedFilesDroppedAtDestination:(id)arg2 forDraggedItems:(id)arg3;
- (BOOL)outlineView:(id)arg1 acceptDrop:(id)arg2 item:(id)arg3 childIndex:(long long)arg4;
- (unsigned long long)outlineView:(id)arg1 validateDrop:(id)arg2 proposedItem:(id)arg3 proposedChildIndex:(long long)arg4;
- (BOOL)outlineView:(id)arg1 writeItems:(id)arg2 toPasteboard:(id)arg3;
- (id)outlineView:(id)arg1 persistentObjectForItem:(id)arg2;
- (id)outlineView:(id)arg1 itemForPersistentObject:(id)arg2;
- (void)outlineView:(id)arg1 setObjectValue:(id)arg2 forTableColumn:(id)arg3 byItem:(id)arg4;
- (id)outlineView:(id)arg1 objectValueForTableColumn:(id)arg2 byItem:(id)arg3;
- (BOOL)outlineView:(id)arg1 isItemExpandable:(id)arg2;
- (id)outlineView:(id)arg1 child:(long long)arg2 ofItem:(id)arg3;
- (long long)outlineView:(id)arg1 numberOfChildrenOfItem:(id)arg2;
- (id)menuForEvent:(id)arg1;
- (void)keyDown:(id)arg1;
- (void)drawBadgeForRow:(long long)arg1 inRect:(struct CGRect)arg2;
- (void)drawRow:(long long)arg1 clipRect:(struct CGRect)arg2;
- (void)drawGridInClipRect:(struct CGRect)arg1;
- (void)viewDidMoveToSuperview;
- (struct CGSize)sizeOfBadgeAtRow:(long long)arg1;
- (struct CGRect)frameOfCellAtColumn:(long long)arg1 row:(long long)arg2;
- (struct CGRect)frameOfOutlineCellAtRow:(long long)arg1;
- (void)selectRowIndexes:(id)arg1 byExtendingSelection:(BOOL)arg2;
- (long long)badgeValueForItem:(id)arg1;
- (BOOL)itemHasBadge:(id)arg1;
- (BOOL)isGroupAlwaysExpanded:(id)arg1;
- (BOOL)isGroupItem:(id)arg1;
- (unsigned long long)numberOfGroups;
- (void)reloadData;
@property id <AZSourceListDataSource> dataSource; // @dynamic dataSource;
@property id <AZSourceListDelegate> delegate; // @dynamic delegate;
- (void)dealloc;
- (void)AZSL_setup;
- (id)initWithFrame:(struct CGRect)arg1;
- (id)initWithCoder:(id)arg1;
- (void)drawBackgroundInClipRect:(struct CGRect)arg1;

@end

@interface SourceListItem : NSObject
{
    NSString *title;
    NSString *identifier;
    NSImage *icon;
    long long badgeValue;
    NSArray *children;
    NSColor *_color;
    id _objectRep;
}

+ (id)itemWithTitle:(id)arg1 identifier:(id)arg2 icon:(id)arg3;
+ (id)itemWithTitle:(id)arg1 identifier:(id)arg2;
@property(retain, nonatomic) id objectRep; // @synthesize objectRep=_objectRep;
@property(retain, nonatomic) NSColor *color; // @synthesize color=_color;
@property(copy, nonatomic) NSArray *children; // @synthesize children;
@property(nonatomic) long long badgeValue; // @synthesize badgeValue;
@property(retain, nonatomic) NSImage *icon; // @synthesize icon;
@property(copy, nonatomic) NSString *identifier; // @synthesize identifier;
@property(copy, nonatomic) NSString *title; // @synthesize title;
- (void).cxx_destruct;
- (id)description;
- (BOOL)hasIcon;
- (BOOL)hasChildren;
- (BOOL)hasBadge;
- (id)init;

@end

@interface DummyClass : NSObject
{
}

@end

@interface AZLayerManager : NSObject
{
}

@end

@interface Grid : CALayer
{
    unsigned int _nRows;
    unsigned int _nColumns;
    struct CGSize _spacing;
    struct CGColor *_lineColor;
    struct CGColor *_highlightColor;
    struct CGColor *_animateColor;
    struct CGPoint _cellOffset;
    NSMutableArray *_cells;
}

@property(readonly) struct CGSize spacing; // @synthesize spacing=_spacing;
@property(readonly) unsigned int columns; // @synthesize columns=_nColumns;
@property(readonly) unsigned int rows; // @synthesize rows=_nRows;
- (void).cxx_destruct;
- (void)drawInContext:(struct CGContext *)arg1;
- (void)drawCellsInContext:(struct CGContext *)arg1;
- (void)removeCellAtRow:(unsigned int)arg1 column:(unsigned int)arg2;
- (void)removeAllCells;
- (void)addAllCells;
- (id)addCellAtRow:(unsigned int)arg1 column:(unsigned int)arg2;
- (id)cellAtRow:(unsigned int)arg1 column:(unsigned int)arg2;
@property struct CGColor *animateColor;
@property struct CGColor *highlightColor;
@property struct CGColor *lineColor;
- (void)_setColor:(struct CGColor **)arg1 withNewColor:(struct CGColor *)arg2;
- (void)dealloc;
- (id)initWithRows:(unsigned int)arg1 columns:(unsigned int)arg2 spacing:(struct CGSize)arg3 position:(struct CGPoint)arg4 cellOffset:(struct CGPoint)arg5 backgroundColor:(struct CGColor *)arg6;

@end

@interface GridCell : CALayer
{
    BOOL _highlighted;
    BOOL _animated;
    Grid *_grid;
    unsigned int _row;
    unsigned int _column;
    BOOL dotted;
    BOOL cross;
}

@property(nonatomic) BOOL cross; // @synthesize cross;
@property(nonatomic) BOOL dotted; // @synthesize dotted;
@property(nonatomic) unsigned int column; // @synthesize column=_column;
@property(nonatomic) unsigned int row; // @synthesize row=_row;
@property(nonatomic, setter=setAnimated:) BOOL animated; // @synthesize animated=_animated;
@property(nonatomic, setter=setHighlighted:) BOOL highlighted; // @synthesize highlighted=_highlighted;
- (void).cxx_destruct;
@property(readonly) GridCell *w;
@property(readonly) GridCell *sw;
@property(readonly) GridCell *s;
@property(readonly) GridCell *se;
@property(readonly) GridCell *e;
@property(readonly) GridCell *ne;
@property(readonly) GridCell *n;
@property(readonly) GridCell *nw;
- (struct CGPoint)getMidInLayer:(id)arg1;
- (void)drawInContext:(struct CGContext *)arg1;
- (void)drawInParentContext:(struct CGContext *)arg1;
- (id)description;
- (void)dealloc;
- (id)initWithGrid:(id)arg1 row:(unsigned int)arg2 column:(unsigned int)arg3 frame:(struct CGRect)arg4;

@end

@interface AZApplePrivate : BaseModel
{
}

+ (id)registeredApps;
+ (id)sharedInstance;

@end

@interface AZBoxLayer : CALayer
{
    NSString *title;
    CALayer *closeLayer;
    CATextLayer *text;
    CALayer *imageLayer;
    NSImage *image;
}

@property(retain) NSString *title; // @synthesize title;
@property(retain) NSImage *image; // @synthesize image;
- (void).cxx_destruct;
- (void)drawLayer:(id)arg1 inContext:(struct CGContext *)arg2;
- (id)closeBoxLayer;
- (id)shakeAnimation;
- (void)stopShake;
- (void)startShake;
- (BOOL)isRunning;
- (void)toggleShake;
- (id)initWithImage:(id)arg1 title:(id)arg2;

@end

@interface AZOverlayView : IKImageView
{
    id __AZ_overlayDelegate;
    id __AZ_overlayDataSource;
    unsigned long long __AZ_state;
    CALayer *__AZ_topLayer;
    struct CGColor *__AZ_overlayFillColor;
    struct CGColor *__AZ_overlayBorderColor;
    struct CGColor *__AZ_overlaySelectionFillColor;
    struct CGColor *__AZ_overlaySelectionBorderColor;
    double __AZ_overlayBorderWidth;
    id __AZ_target;
    SEL __AZ_action;
    SEL __AZ_doubleAction;
    SEL __AZ_rightAction;
    BOOL __AZ_allowsCreatingOverlays;
    BOOL __AZ_allowsModifyingOverlays;
    BOOL __AZ_allowsDeletingOverlays;
    BOOL __AZ_allowsOverlappingOverlays;
    BOOL __AZ_allowsOverlaySelection;
    BOOL __AZ_allowsEmptyOverlaySelection;
    BOOL __AZ_allowsMultipleOverlaySelection;
    double __AZ_handleWidth;
    double __AZ_handleOffset;
    NSCursor *__AZ_northWestSouthEastResizeCursor;
    NSCursor *__AZ_northEastSouthWestResizeCursor;
    struct CGPoint __AZ_mouseDownPoint;
    CAShapeLayer *__AZ_activeLayer;
    unsigned long long __AZ_activeCorner;
    struct CGPoint __AZ_activeOrigin;
    struct CGSize __AZ_activeSize;
    double __AZ_xOffset;
    double __AZ_yOffset;
    NSInvocation *__AZ_singleClickInvocation;
    id __AZ_overlayCache;
    NSMutableArray *__AZ_selectedOverlays;
    long long __AZ_clickedOverlay;
}

@property(retain) id contents; // @synthesize contents=__AZ_overlayCache;
@property(readonly) long long clickedOverlay; // @synthesize clickedOverlay=__AZ_clickedOverlay;
@property SEL rightAction; // @synthesize rightAction=__AZ_rightAction;
@property SEL doubleAction; // @synthesize doubleAction=__AZ_doubleAction;
@property SEL action; // @synthesize action=__AZ_action;
@property __weak id target; // @synthesize target=__AZ_target;
@property BOOL allowsMultipleOverlaySelection; // @synthesize allowsMultipleOverlaySelection=__AZ_allowsMultipleOverlaySelection;
@property BOOL allowsEmptyOverlaySelection; // @synthesize allowsEmptyOverlaySelection=__AZ_allowsEmptyOverlaySelection;
@property BOOL allowsOverlaySelection; // @synthesize allowsOverlaySelection=__AZ_allowsOverlaySelection;
@property BOOL allowsOverlappingOverlays; // @synthesize allowsOverlappingOverlays=__AZ_allowsOverlappingOverlays;
@property BOOL allowsDeletingOverlays; // @synthesize allowsDeletingOverlays=__AZ_allowsDeletingOverlays;
@property BOOL allowsModifyingOverlays; // @synthesize allowsModifyingOverlays=__AZ_allowsModifyingOverlays;
@property BOOL allowsCreatingOverlays; // @synthesize allowsCreatingOverlays=__AZ_allowsCreatingOverlays;
@property double overlayBorderWidth; // @synthesize overlayBorderWidth=__AZ_overlayBorderWidth;
- (void).cxx_destruct;
@property struct CGColor *overlaySelectionBorderColor;
@property struct CGColor *overlaySelectionFillColor;
@property struct CGColor *overlayBorderColor;
@property struct CGColor *overlayFillColor;
@property __weak id overlayDelegate;
@property __weak id overlayDataSource;
- (void)draggedFrom:(struct CGPoint)arg1 to:(struct CGPoint)arg2 done:(BOOL)arg3;
- (BOOL)rect:(struct CGRect)arg1 isValidForLayer:(id)arg2;
- (unsigned long long)cornerOfLayer:(id)arg1 atPoint:(struct CGPoint)arg2;
- (id)layerAtPoint:(struct CGPoint)arg1;
- (id)layerWithRect:(struct CGRect)arg1 handles:(BOOL)arg2 selected:(BOOL)arg3;
- (struct CGPath *)newRectPathWithSize:(struct CGSize)arg1 handles:(BOOL)arg2;
- (struct CGPoint)convertWindowPointToImagePoint:(struct CGPoint)arg1;
- (void)setMouseForPoint:(struct CGPoint)arg1;
- (id)northEastSouthWestResizeCursor;
- (id)northWestSouthEastResizeCursor;
- (void)selectAll:(id)arg1;
- (void)keyUp:(id)arg1;
- (void)keyDown:(id)arg1;
- (BOOL)acceptsFirstResponder;
- (void)mouseExited:(id)arg1;
- (void)mouseMoved:(id)arg1;
- (void)cursorUpdate:(id)arg1;
- (void)rightMouseUp:(id)arg1;
- (void)mouseUp:(id)arg1;
- (void)mouseDragged:(id)arg1;
- (void)mouseDown:(id)arg1;
- (void)deselectAllOverlays:(id)arg1;
- (void)selectAllOverlays:(id)arg1;
- (BOOL)isOverlaySelected:(long long)arg1;
- (long long)numberOfSelectedOverlays;
- (void)deselectOverlay:(long long)arg1;
- (id)selectedOverlays;
- (id)selectedOverlayIndexes;
- (long long)selectedOverlayIndex;
- (void)selectOverlayIndexes:(id)arg1 byExtendingSelection:(BOOL)arg2;
- (BOOL)enterState:(unsigned long long)arg1;
- (void)dealloc;
- (void)drawOverlays;
- (void)reloadData;
- (void)initialSetup;
- (void)awakeFromNib;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface CAAnimationDelegate : NSObject
{
    id _completion;
    id _start;
}

@property(copy, nonatomic) id start; // @synthesize start=_start;
@property(copy, nonatomic) id completion; // @synthesize completion=_completion;
- (void).cxx_destruct;
- (void)animationDidStop:(id)arg1 finished:(BOOL)arg2;
- (void)animationDidStart:(id)arg1;
- (void)dealloc;
- (id)init;

@end

@interface RoundedView : NSView
{
}

- (void)drawRect:(struct CGRect)arg1;

@end

@interface TransparentWindow : NSWindow
{
    struct CGPoint initialLocation;
    BOOL flipRight;
    double duration;
    NSWindow *mAnimationWindow;
    NSWindow *mTargetWindow;
    BOOL _draggable;
    struct CGRect _downFrame;
    struct CGRect _upFrame;
}

@property struct CGRect upFrame; // @synthesize upFrame=_upFrame;
@property struct CGRect downFrame; // @synthesize downFrame=_downFrame;
@property BOOL draggable; // @synthesize draggable=_draggable;
@property double duration; // @synthesize duration;
@property BOOL flipRight; // @synthesize flipRight;
- (void).cxx_destruct;
- (void)flip:(id)arg1 to:(id)arg2;
- (void)animationDidStop:(id)arg1 finished:(BOOL)arg2;
- (id)animationWithDuration:(double)arg1 flip:(BOOL)arg2 right:(BOOL)arg3;
- (id)layerFromView:(id)arg1;
- (id)windowForAnimation:(struct CGRect)arg1;
- (BOOL)canBecomeKeyWindow;
- (id)initWithContentRect:(struct CGRect)arg1 styleMask:(unsigned long long)arg2 backing:(unsigned long long)arg3 defer:(BOOL)arg4;

@end

@interface AZFoamView : NSView
{
}

- (void)drawRect:(struct CGRect)arg1;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface AZInfiniteCell : NSView
{
    NSTrackingArea *tArea;
    NSBezierPath *standard;
    float mPhase;
    float all;
    NSTextView *tv;
    NSTimer *timer;
    NSButton *close;
    NSImage *image;
    NSColor *color;
    NSColor *backgroundColor;
    BOOL selected;
    NSString *uniqueID;
    BOOL hovered;
    AZFile *file;
    NSString *cellIdentifier;
    float dynamicStroke;
    float inset;
    float radius;
    id representedObject;
    BOOL _hasText;
}

@property BOOL hasText; // @synthesize hasText=_hasText;
@property(retain, nonatomic) id representedObject; // @synthesize representedObject;
@property(nonatomic) float radius; // @synthesize radius;
@property(nonatomic) float inset; // @synthesize inset;
@property(readonly) float dynamicStroke; // @synthesize dynamicStroke;
@property(readonly, nonatomic) NSString *cellIdentifier; // @synthesize cellIdentifier;
@property(retain, nonatomic) AZFile *file; // @synthesize file;
@property BOOL hovered; // @synthesize hovered;
@property(retain, nonatomic) NSString *uniqueID; // @synthesize uniqueID;
@property BOOL selected; // @synthesize selected;
@property(retain, nonatomic) NSColor *backgroundColor; // @synthesize backgroundColor;
- (void).cxx_destruct;
- (void)encodeWithCoder:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)initWithCoder:(id)arg1;
- (void)updateTrackingAreas;
- (id)initWithFrame:(struct CGRect)arg1;
- (void)mouseDown:(id)arg1;
- (void):(id)arg1;
- (void)mouseEntered:(id)arg1;
- (void)drawRect:(struct CGRect)arg1;
- (id)tv;
- (id)pathWithInset:(float)arg1;
- (float)halfwayWithInset;
- (void)handleAntAnimationTimer:(id)arg1;

@end

@interface AZSimpleView : NSView
{
    BOOL glossy;
    NSColor *backgroundColor;
    BOOL checkerboard;
    BOOL gradient;
    BOOL _clear;
}

@property BOOL clear; // @synthesize clear=_clear;
@property BOOL gradient; // @synthesize gradient;
@property BOOL checkerboard; // @synthesize checkerboard;
@property(retain, nonatomic) NSColor *backgroundColor; // @synthesize backgroundColor;
@property BOOL glossy; // @synthesize glossy;
- (void).cxx_destruct;
- (void)drawRect:(struct CGRect)arg1;
- (void)setFrameSizePinnedToTopLeft:(struct CGSize)arg1;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface AZSimpleGridView : NSView
{
    unsigned long long rows;
    unsigned long long columns;
    CALayer *grid;
    struct CGSize _dimensions;
}

@property(nonatomic) struct CGSize dimensions; // @synthesize dimensions=_dimensions;
@property(retain, nonatomic) CALayer *grid; // @synthesize grid;
@property(nonatomic) unsigned long long columns; // @synthesize columns;
@property(nonatomic) unsigned long long rows; // @synthesize rows;
- (void).cxx_destruct;
- (void)awakeFromNib;

@end

@interface RuntimeReporter : NSObject
{
}

+ (id)protocolNamesForClass:(Class)arg1;
+ (id)protocolNamesForClassNamed:(id)arg1;
+ (id)propertyNamesForClass:(Class)arg1;
+ (id)propertyNamesForClassNamed:(id)arg1;
+ (id)iVarNamesForClass:(Class)arg1;
+ (id)iVarNamesForClassNamed:(id)arg1;
+ (id)methodNamesForClass:(Class)arg1;
+ (id)methodNamesForClassNamed:(id)arg1;
+ (int)numberOfClasses;
+ (int)numberOfSubclassesOfClass:(Class)arg1;
+ (BOOL)classHasSubclasses:(Class)arg1;
+ (id)subclassNamesForClass:(Class)arg1;
+ (id)rootClasses;
+ (id)subclassNamesForClassNamed:(id)arg1;
+ (id)inheritanceForClass:(Class)arg1;
+ (id)inheritanceForClassNamed:(id)arg1;
+ (id)superclassNameForClass:(Class)arg1;
+ (id)superclassNameForClassNamed:(id)arg1;
+ (id)rawClassPointers;
+ (id)cache;
+ (void)recache:(id)arg1;
+ (void)initialize;

@end

@interface NotificationCenterSpy : NSObject
{
    BOOL spying;
}

+ (void)toggleSpyingAllNotifications;
+ (id)sharedNotificationCenterSpy;
@property(nonatomic, getter=isSpying) BOOL spying; // @synthesize spying;
- (void)receivedNotification:(id)arg1;
- (void)toggleSpyingAllNotifications;

@end

@interface AZMouser : BaseModel
{
    BOOL _debug;
    struct CGSize _screenSize;
    NSUserDefaults *_defaults;
    int _orientation;
}

@property(nonatomic) int orientation; // @synthesize orientation=_orientation;
@property(retain) NSUserDefaults *defaults; // @synthesize defaults=_defaults;
@property(nonatomic) struct CGSize screenSize; // @synthesize screenSize=_screenSize;
@property(nonatomic) BOOL debug; // @synthesize debug=_debug;
- (void).cxx_destruct;
- (id)arcPointsBetween:(struct CGPoint)arg1 and:(struct CGPoint)arg2;
- (id)coaxPointsForPoints:(struct CGPoint)arg1 to:(struct CGPoint)arg2;
- (void)dragFrom:(struct CGPoint)arg1 to:(struct CGPoint)arg2;
- (void)moveTo:(struct CGPoint)arg1;
- (struct CGPoint)mouseLocation;
- (float)largeValue;
- (void)listenForCancel;
- (void)setUp;

@end

@interface AZDockQuery : BaseModel
{
    NSArray *_dock;
    NSArray *_dockSorted;
}

@property(retain, nonatomic) NSArray *dock; // @synthesize dock=_dock;
- (id)subelementsFromElement:(struct __AXUIElement *)arg1 forAttribute:(id)arg2;
- (struct CGPoint)locationNowForAppWithPath:(id)arg1;
- (void)dock:(id)arg1;

@end

@interface AZNamedColors : NSColorList
{
}

+ (id)nameOfColor:(id)arg1 savingDistance:(id *)arg2;
+ (id)nameOfColor:(id)arg1;
+ (id)namedColors;
+ (void)initialize;
- (id)init;
- (void)_initColors;

@end

@interface NSLogConsole : AZSingleton
{
    NSString *windowTitle;
    BOOL autoOpens;
    NSMutableArray *messageQueue;
    id _window;
    int _original_stderr;
    unsigned long long _fileOffset;
    NSFileHandle *_fileHandle;
    NSLogConsoleView *_webView;
    id _searchField;
    id _po;
    NSString *_logPath;
}

+ (id)sharedConsole;
@property(retain, nonatomic) NSString *logPath; // @synthesize logPath=_logPath;
@property __weak id po; // @synthesize po=_po;
@property __weak id searchField; // @synthesize searchField=_searchField;
@property __weak NSLogConsoleView *webView; // @synthesize webView=_webView;
@property(retain, nonatomic) NSFileHandle *fileHandle; // @synthesize fileHandle=_fileHandle;
@property unsigned long long fileOffset; // @synthesize fileOffset=_fileOffset;
@property int original_stderr; // @synthesize original_stderr=_original_stderr;
@property id window; // @synthesize window=_window;
@property(retain, nonatomic) NSMutableArray *messageQueue; // @synthesize messageQueue;
@property(copy) NSString *windowTitle; // @synthesize windowTitle;
@property BOOL autoOpens; // @synthesize autoOpens;
- (void).cxx_destruct;
- (void)logData:(id)arg1 file:(char *)arg2 lineNumber:(int)arg3;
- (void)updateLogWithFile:(char *)arg1 lineNumber:(int)arg2;
- (void)poChanged:(id)arg1;
- (void)searchChanged:(id)arg1;
- (void)clear:(id)arg1;
- (BOOL)isOpen;
- (void)close;
- (void)open;
- (void)dataAvailable:(id)arg1;
- (id)init;

@end

@interface NSLogConsoleView : WebView
{
    BOOL webViewLoaded;
    id _messageQueue;
}

@property(retain, nonatomic) id messageQueue; // @synthesize messageQueue=_messageQueue;
- (void).cxx_destruct;
- (void)search:(id)arg1;
- (void)clear;
- (void)webView:(id)arg1 decidePolicyForNavigationAction:(id)arg2 request:(id)arg3 frame:(id)arg4 decisionListener:(id)arg5;
- (void)logString:(id)arg1 file:(char *)arg2 lineNumber:(int)arg3;
- (void)webView:(id)arg1 didFinishLoadForFrame:(id)arg2;
- (void)webView:(id)arg1 windowScriptObjectAvailable:(id)arg2;
- (void)awakeFromNib;
- (BOOL)drawsBackground;

@end

@interface AZWindowExtendController : NSObject
{
    AZWindowExtend *_window;
}

@property __weak AZWindowExtend *window; // @synthesize window=_window;
- (void).cxx_destruct;
- (void)awakeFromNib;

@end

@interface AZWindowExtend : NSWindow
{
    NSTextField *_coordinates;
    struct CGPoint _point;
}

@property(nonatomic) struct CGPoint point; // @synthesize point=_point;
@property __weak NSTextField *coordinates; // @synthesize coordinates=_coordinates;
- (void).cxx_destruct;
- (void)setAcceptsMouseMovedEvents:(BOOL)arg1 screen:(BOOL)arg2;
- (void)dealloc;
- (void)mouseMoved:(id)arg1;
- (void)awakeFromNib;

@end

@interface _AZNotificationHelper : NSObject
{
    SEL _selector;
    NSString *_keyPath;
    id _userInfo;
    id _target;
    id _observer;
}

@property(retain) id observer; // @synthesize observer=_observer;
@property(retain) id target; // @synthesize target=_target;
@property(retain) id userInfo; // @synthesize userInfo=_userInfo;
@property(retain) NSString *keyPath; // @synthesize keyPath=_keyPath;
@property SEL selector; // @synthesize selector=_selector;
- (void).cxx_destruct;
- (void)deregister;
- (void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void *)arg4;
- (id)initWithObserver:(id)arg1 object:(id)arg2 keyPath:(id)arg3 selector:(SEL)arg4 userInfo:(id)arg5 options:(unsigned long long)arg6;

@end

@interface AZNotificationCenter : AZSingleton
{
    NSMutableDictionary *_observerHelpers;
}

+ (id)defaultCenter;
- (void).cxx_destruct;
- (void)removeObserver:(id)arg1 object:(id)arg2 keyPath:(id)arg3 selector:(SEL)arg4;
- (void)addObserver:(id)arg1 object:(id)arg2 keyPath:(id)arg3 selector:(SEL)arg4 userInfo:(id)arg5 options:(unsigned long long)arg6;
- (id)_dictionaryKeyForObserver:(id)arg1 object:(id)arg2 keyPath:(id)arg3 selector:(SEL)arg4;
- (id)init;

@end

@interface AZSingleton : NSObject
{
}

+ (id)mutableCopyWithZone:(struct _NSZone *)arg1;
+ (id)copyWithZone:(struct _NSZone *)arg1;
+ (id)new;
+ (id)singleton;
+ (id)sharedInstance;
+ (id)instance;
+ (id)alloc;
+ (void)initialize;
- (id)init;

@end

@interface AZCSSColors : NSColorList
{
}

+ (id)nameOfColor:(id)arg1 savingDistance:(id *)arg2;
+ (id)nameOfColor:(id)arg1;
+ (id)webNamedColors;
+ (void)initialize;
- (id)init;
- (void)_initColors;

@end

@interface AZObject : NSObject <NSCoding, NSCopying, NSFastEnumeration>
{
    NSString *_uniqueID;
    AZObject *_sharedInstance;
    AZObject *_lastModifiedInstance;
    NSString *_lastModifiedKey;
}

+ (id)newUniqueIdentifier;
+ (void)initialize;
+ (id)lastModifiedKey;
+ (id)lastModifiedInstance;
+ (void)setLastModifiedKey:(id)arg1 forInstance:(id)arg2;
+ (id)saveFile;
+ (id)resourceFile;
+ (void)reloadSharedInstance;
+ (id)sharedInstance;
+ (BOOL)hasSharedInstance;
+ (void)setSharedInstance:(id)arg1;
+ (id)instanceWithCoder:(id)arg1;
+ (id)instancesWithArray:(id)arg1;
+ (id)instanceWithObject:(id)arg1;
+ (id)instance;
@property(retain, nonatomic) NSString *lastModifiedKey; // @synthesize lastModifiedKey=_lastModifiedKey;
@property(retain, nonatomic) AZObject *lastModifiedInstance; // @synthesize lastModifiedInstance=_lastModifiedInstance;
@property(retain, nonatomic) AZObject *sharedInstance; // @synthesize sharedInstance=_sharedInstance;
@property(retain, nonatomic) NSString *uniqueID; // @synthesize uniqueID=_uniqueID;
- (void).cxx_destruct;
- (id)description;
- (void)writeToDescription:(id)arg1 withIndent:(unsigned long long)arg2;
- (void)writeLineBreakToString:(id)arg1 withTabs:(unsigned long long)arg2;
- (unsigned long long)hash;
- (BOOL)isEqual:(id)arg1;
- (unsigned long long)countByEnumeratingWithState:(CDStruct_70511ce9 *)arg1 objects:(id *)arg2 count:(unsigned long long)arg3;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (void)dealloc;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)nillableKeys;
- (id)allKeys;
- (void)setKeyChanged:(id)arg1;
- (id)keyChanged;
- (void)setValue:(id)arg1 forKey:(id)arg2;
- (void)setObject:(id)arg1 forKeyedSubscript:(id)arg2;
- (id)objectForKeyedSubscript:(id)arg1;
- (id)initWithObject:(id)arg1;
- (id)setterNameForClass:(Class)arg1;

@end

@interface AZLassoView : NSView
{
    NSTrackingArea *trackingArea;
    float mPhase;
    float all;
    NSTimer *timer;
    float dynamicStroke;
    float _inset;
    float _radius;
    BOOL _hovered;
    BOOL _selected;
    BOOL _nooseMode;
    id _representedObject;
    NSString *uniqueID;
}

@property(retain, nonatomic) NSString *uniqueID; // @synthesize uniqueID;
@property(retain, nonatomic) id representedObject; // @synthesize representedObject=_representedObject;
@property(nonatomic) BOOL nooseMode; // @synthesize nooseMode=_nooseMode;
@property(nonatomic) BOOL selected; // @synthesize selected=_selected;
@property(nonatomic) BOOL hovered; // @synthesize hovered=_hovered;
@property(nonatomic) float radius; // @synthesize radius=_radius;
@property(nonatomic) float inset; // @synthesize inset=_inset;
- (void).cxx_destruct;
- (float)halfwayWithInset;
- (void)drawRect:(struct CGRect)arg1;
@property(readonly) float dynamicStroke; // @synthesize dynamicStroke;
- (void)handleAntAnimationTimer:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface AZBackground : NSView
{
}

- (void)drawRect:(struct CGRect)arg1;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface AZDarkButtonCell : NSButtonCell
{
}

- (void)drawBezelWithFrame:(struct CGRect)arg1 inView:(id)arg2;
- (void)drawImage:(id)arg1 withFrame:(struct CGRect)arg2 inView:(id)arg3;

@end

@interface AZToggleArrayView : NSView
{
    id <AZToggleArrayViewDelegate> _delegate;
    CALayer *_rootLayer;
    CALayer *_containerLayer;
    NSArray *_questions;
}

@property(retain, nonatomic) NSArray *questions; // @synthesize questions=_questions;
@property(nonatomic) id <AZToggleArrayViewDelegate> delegate; // @synthesize delegate=_delegate;
- (void).cxx_destruct;
- (struct CGPoint)layerLocationForEvent:(id)arg1;
- (id)toggleLayerForEvent:(id)arg1;
@property(readonly) CALayer *rootLayer; // @synthesize rootLayer=_rootLayer;
@property(readonly) CALayer *containerLayer; // @synthesize containerLayer=_containerLayer;
- (id)itemLayerWithName:(id)arg1 relativeTo:(id)arg2 onText:(id)arg3 offText:(id)arg4 state:(BOOL)arg5 index:(unsigned long long)arg6;
- (id)itemLayerWithName:(id)arg1 relativeTo:(id)arg2 onText:(id)arg3 offText:(id)arg4 state:(BOOL)arg5 index:(unsigned long long)arg6 labelPositioned:(int)arg7;
- (id)itemLayerWithName:(id)arg1 relativeTo:(id)arg2 index:(unsigned long long)arg3;
- (id)itemTextLayerWithName:(id)arg1;
- (id)toggleLayerWithOnText:(id)arg1 offText:(id)arg2 initialState:(BOOL)arg3 title:(id)arg4 index:(unsigned long long)arg5;
- (void)mouseDown:(id)arg1;
- (void)setFrame:(struct CGRect)arg1;
- (void)awakeFromNib;

@end

@interface AZToggleControlLayer : CALayer
{
    CALayer *thumbLayer;
    CALayer *onBackLayer;
    CALayer *offBackLayer;
    CATextLayer *onTextLayer;
    CATextLayer *offTextLayer;
    NSGradient *onBackGradient;
    NSGradient *offBackGradient;
    BOOL toggleState;
}

- (void).cxx_destruct;
- (void)drawLayer:(id)arg1 inContext:(struct CGContext *)arg2;
- (void)layoutSublayersOfLayer:(id)arg1;
@property(copy) NSString *offStateText;
@property(copy) NSString *onStateText;
@property BOOL toggleState;
- (void)reverseToggleState;
- (void)dealloc;
- (id)init;
@property(readonly) NSGradient *offBackGradient;
@property(readonly) NSGradient *onBackGradient;
@property(readonly) double contentsHeight;
@property(readonly) CATextLayer *offTextLayer;
@property(readonly) CATextLayer *onTextLayer;
@property(readonly) CALayer *offBackLayer;
@property(readonly) CALayer *onBackLayer;
@property(readonly) CALayer *thumbLayer;

@end

@interface iCarousel : NSView
{
    NSTrackingArea *trackingArea;
    id <iCarouselDataSource> _dataSource;
    id <iCarouselDelegate> _delegate;
    int _type;
    double _perspective;
    long long _numberOfItems;
    long long _numberOfPlaceholders;
    long long _numberOfPlaceholdersToShow;
    long long _numberOfVisibleItems;
    NSView *_contentView;
    NSMutableDictionary *_itemViews;
    NSMutableSet *_itemViewPool;
    NSMutableSet *_placeholderViewPool;
    long long _previousItemIndex;
    double _itemWidth;
    double _scrollOffset;
    double _offsetMultiplier;
    double _startVelocity;
    NSTimer *_timer;
    BOOL _decelerating;
    BOOL _scrollEnabled;
    double _decelerationRate;
    double _bounceDistance;
    BOOL _bounces;
    struct CGSize _contentOffset;
    struct CGSize _viewpointOffset;
    double _startOffset;
    double _endOffset;
    double _scrollDuration;
    double _startTime;
    BOOL _scrolling;
    double _previousTranslation;
    BOOL _wrapEnabled;
    BOOL _vertical;
    BOOL _dragging;
    BOOL _didDrag;
    double _scrollSpeed;
    double _toggleTime;
    double _toggle;
    BOOL _stopAtItemBoundary;
    BOOL _scrollToItemBoundary;
    BOOL _ignorePerpendicularSwipes;
    long long _animationDisableCount;
    BOOL _centerItemWhenSelected;
    long long _currentItemIndex;
    NSView *_currentItemView;
    int _option;
}

@property(nonatomic) int option; // @synthesize option=_option;
@property(retain, nonatomic) NSView *currentItemView; // @synthesize currentItemView=_currentItemView;
@property(nonatomic) long long currentItemIndex; // @synthesize currentItemIndex=_currentItemIndex;
@property(nonatomic) BOOL centerItemWhenSelected; // @synthesize centerItemWhenSelected=_centerItemWhenSelected;
@property(nonatomic) long long animationDisableCount; // @synthesize animationDisableCount=_animationDisableCount;
@property(nonatomic) BOOL ignorePerpendicularSwipes; // @synthesize ignorePerpendicularSwipes=_ignorePerpendicularSwipes;
@property(nonatomic) BOOL scrollToItemBoundary; // @synthesize scrollToItemBoundary=_scrollToItemBoundary;
@property(nonatomic) BOOL stopAtItemBoundary; // @synthesize stopAtItemBoundary=_stopAtItemBoundary;
@property(nonatomic) double toggle; // @synthesize toggle=_toggle;
@property(nonatomic) double toggleTime; // @synthesize toggleTime=_toggleTime;
@property(nonatomic) double scrollSpeed; // @synthesize scrollSpeed=_scrollSpeed;
@property(nonatomic) BOOL didDrag; // @synthesize didDrag=_didDrag;
@property(nonatomic, getter=isDragging) BOOL dragging; // @synthesize dragging=_dragging;
@property(nonatomic, getter=isVertical) BOOL vertical; // @synthesize vertical=_vertical;
@property(nonatomic, getter=isWrapEnabled) BOOL wrapEnabled; // @synthesize wrapEnabled=_wrapEnabled;
@property(nonatomic) double previousTranslation; // @synthesize previousTranslation=_previousTranslation;
@property(nonatomic, getter=isScrolling) BOOL scrolling; // @synthesize scrolling=_scrolling;
@property(nonatomic) double startTime; // @synthesize startTime=_startTime;
@property(nonatomic) double scrollDuration; // @synthesize scrollDuration=_scrollDuration;
@property(nonatomic) double endOffset; // @synthesize endOffset=_endOffset;
@property(nonatomic) double startOffset; // @synthesize startOffset=_startOffset;
@property(nonatomic) struct CGSize viewpointOffset; // @synthesize viewpointOffset=_viewpointOffset;
@property(nonatomic) struct CGSize contentOffset; // @synthesize contentOffset=_contentOffset;
@property(nonatomic) BOOL bounces; // @synthesize bounces=_bounces;
@property(nonatomic) double bounceDistance; // @synthesize bounceDistance=_bounceDistance;
@property(nonatomic) double decelerationRate; // @synthesize decelerationRate=_decelerationRate;
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled; // @synthesize scrollEnabled=_scrollEnabled;
@property(nonatomic, getter=isDecelerating) BOOL decelerating; // @synthesize decelerating=_decelerating;
@property(nonatomic) NSTimer *timer; // @synthesize timer=_timer;
@property(nonatomic) double startVelocity; // @synthesize startVelocity=_startVelocity;
@property(nonatomic) double offsetMultiplier; // @synthesize offsetMultiplier=_offsetMultiplier;
@property(nonatomic) double scrollOffset; // @synthesize scrollOffset=_scrollOffset;
@property(nonatomic) double itemWidth; // @synthesize itemWidth=_itemWidth;
@property(nonatomic) long long previousItemIndex; // @synthesize previousItemIndex=_previousItemIndex;
@property(retain, nonatomic) NSMutableSet *placeholderViewPool; // @synthesize placeholderViewPool=_placeholderViewPool;
@property(retain, nonatomic) NSMutableSet *itemViewPool; // @synthesize itemViewPool=_itemViewPool;
@property(retain, nonatomic) NSMutableDictionary *itemViews; // @synthesize itemViews=_itemViews;
@property(retain, nonatomic) NSView *contentView; // @synthesize contentView=_contentView;
@property(nonatomic) long long numberOfVisibleItems; // @synthesize numberOfVisibleItems=_numberOfVisibleItems;
@property(nonatomic) long long numberOfPlaceholdersToShow; // @synthesize numberOfPlaceholdersToShow=_numberOfPlaceholdersToShow;
@property(readonly, nonatomic) long long numberOfPlaceholders; // @synthesize numberOfPlaceholders=_numberOfPlaceholders;
@property(readonly, nonatomic) long long numberOfItems; // @synthesize numberOfItems=_numberOfItems;
@property(nonatomic) double perspective; // @synthesize perspective=_perspective;
@property(nonatomic) int type; // @synthesize type=_type;
@property(nonatomic) id <iCarouselDelegate> delegate; // @synthesize delegate=_delegate;
@property(nonatomic) id <iCarouselDataSource> dataSource; // @synthesize dataSource=_dataSource;
- (void).cxx_destruct;
- (void)keyDown:(id)arg1;
- (BOOL)acceptsFirstResponder;
- (void)mouseUp:(id)arg1;
- (void)mouseMoved:(id)arg1;
- (void)mouseDragged:(id)arg1;
- (void)mouseDown:(id)arg1;
- (void)viewDidMoveToSuperview;
- (void)didMoveToSuperview;
- (void)step;
- (double)easeInOut:(double)arg1;
- (void)startDecelerating;
- (BOOL)shouldScroll;
- (BOOL)shouldDecelerate;
- (double)decelerationDistance;
- (void)stopAnimation;
- (void)startAnimation;
- (void)reloadItemAtIndex:(long long)arg1 animated:(BOOL)arg2;
- (void)insertItemAtIndex:(long long)arg1 animated:(BOOL)arg2;
- (void)fadeInItemView:(struct NSView *)arg1;
- (void)removeItemAtIndex:(long long)arg1 animated:(BOOL)arg2;
- (void)scrollToItemAtIndex:(long long)arg1 animated:(BOOL)arg2;
- (void)scrollToItemAtIndex:(long long)arg1 duration:(double)arg2;
- (void)scrollByNumberOfItems:(long long)arg1 duration:(double)arg2;
- (void)scrollToOffset:(double)arg1 duration:(double)arg2;
- (void)scrollByOffset:(double)arg1 duration:(double)arg2;
- (double)minScrollDistanceFromOffset:(double)arg1 toOffset:(double)arg2;
- (long long)minScrollDistanceFromIndex:(long long)arg1 toIndex:(long long)arg2;
- (void)reloadData;
- (void)loadUnloadViews;
- (struct NSView *)loadViewAtIndex:(long long)arg1;
- (struct NSView *)loadViewAtIndex:(long long)arg1 withContainerView:(struct NSView *)arg2;
- (struct NSView *)dequeuePlaceholderView;
- (struct NSView *)dequeueItemView;
- (void)queuePlaceholderView:(struct NSView *)arg1;
- (void)queueItemView:(struct NSView *)arg1;
- (void)layOutItemViews;
- (long long)circularCarouselItemCount;
- (void)updateNumberOfVisibleItems;
- (void)updateItemWidth;
- (void)transformItemViews;
- (void)resizeSubviewsWithOldSize:(struct CGSize)arg1;
- (void)layoutSubviews;
- (void)transformItemView:(struct NSView *)arg1 atIndex:(long long)arg2;
- (struct NSView *)containView:(struct NSView *)arg1;
- (void)depthSortViews;
- (void)setNeedsLayout;
- (struct CATransform3D)transformForItemView:(struct NSView *)arg1 withOffset:(double)arg2;
- (double)valueForOption:(int)arg1 withDefault:(double)arg2;
- (double)alphaForItemWithOffset:(double)arg1;
- (void)insertView:(struct NSView *)arg1 atIndex:(long long)arg2;
- (void)removeViewAtIndex:(long long)arg1;
- (void)setItemView:(struct NSView *)arg1 forIndex:(long long)arg2;
- (long long)indexOfItemViewOrSubview:(struct NSView *)arg1;
- (long long)indexOfItemView:(struct NSView *)arg1;
- (struct NSView *)itemViewAtIndex:(long long)arg1;
@property(readonly, nonatomic) NSArray *visibleItemViews;
@property(readonly, nonatomic) NSArray *indexesForVisibleItems;
- (void)disableAnimation;
- (void)enableAnimation;
- (void)dealloc;
- (id)initWithFrame:(struct CGRect)arg1;
- (id)initWithCoder:(id)arg1;
- (void)setUp;
- (double)clampedOffset:(double)arg1;
- (long long)clampedIndex:(long long)arg1;
- (double)offsetForItemAtIndex:(long long)arg1;
- (void)didScroll;
- (void)scrollWheel:(id)arg1;
- (void)additionalSetUp;
- (id)hostWindow;
- (double)clampedOffset:(double)arg1;
- (long long)clampedIndex:(long long)arg1;
- (double)offsetForItemAtIndex:(long long)arg1;
- (void)didScroll;
- (void)scrollWheel:(id)arg1;
- (void)additionalSetUp;
- (id)hostWindow;

@end

@interface AZLaunchServicesListItem : NSObject
{
    NSURL *_url;
    NSImage *_icon;
    NSString *_name;
}

@property(retain, nonatomic) NSString *name; // @synthesize name=_name;
@property(retain, nonatomic) NSImage *icon; // @synthesize icon=_icon;
@property(retain, nonatomic) NSURL *url; // @synthesize url=_url;
- (id)init;

@end

@interface AZLaunchServices : NSObject
{
}

+ (id)mappingArray:(id)arg1 usingBlock:(id)arg2;
+ (long long)indexOfItemWithURL:(id)arg1 inList:(struct __CFString *)arg2;
+ (id)prepareArray:(id)arg1 withFormat:(int)arg2;
+ (id)allAvailableFileExtensionsForFileExtension:(id)arg1;
+ (id)allAvailableFileExtensionsForPboardType:(id)arg1;
+ (id)allAvailableFileExtensionsForMIMEType:(id)arg1;
+ (id)preferredFileExtensionForMIMEType:(id)arg1;
+ (id)allAvailableFileExtensionsForUTI:(id)arg1;
+ (id)mimeTypeForFile:(id)arg1;
+ (id)humanReadableTypeForFile:(id)arg1;
+ (id)allAvailableFileExtensionsForApplication:(id)arg1;
+ (id)allAvailableMIMETypesForApplication:(id)arg1;
+ (id)allAvailableFileTypesForApplication:(id)arg1;
+ (id)allApplicationsAbleToOpenFileExtension:(id)arg1 responseFormat:(int)arg2;
+ (id)allApplicationsFormattedAs:(int)arg1;
+ (BOOL)clearList:(struct __CFString *)arg1;
+ (BOOL)removeItemWithURL:(id)arg1 fromList:(struct __CFString *)arg2;
+ (BOOL)removeItemWithIndex:(long long)arg1 fromList:(struct __CFString *)arg2;
+ (BOOL)addItemWithURL:(id)arg1 toList:(struct __CFString *)arg2;
+ (id)allItemsFromList:(struct __CFString *)arg1;

@end

@interface AZSplitView : NSSplitView
{
    NSColor *_dividerColor;
}

@property(retain, nonatomic) NSColor *dividerColor; // @synthesize dividerColor=_dividerColor;
- (void).cxx_destruct;
- (void)drawDividerInRect:(struct CGRect)arg1;
- (double)dividerThickness;

@end

@interface AZVeil : NSObject <NSWindowDelegate, NSApplicationDelegate, NSSplitViewDelegate>
{
    NSTimer *refreshWhileActiveTimer;
    NSTrackingArea *closeTracker;
    NSTrackingArea *windowTracker;
    BOOL mouseHoveringOverBox;
    BOOL mouseHoveringOverButton;
    BOOL shouldShowCloseButton;
    NSTrackingArea *boxTrackingArea;
    NSTrackingArea *buttonTrackingArea;
    NSWindow *_leveler;
    int _shroudState;
    id _subBar;
    AZSplitView *_horizonSplit;
    double _defaultSize;
    TransparentWindow *_shroud;
    TransparentWindow *_window;
    id _quad1;
    id _closeButton;
    id _quad4;
    NSImageView *_view;
    id _quad3;
    struct CGRect _barFrame;
    struct CGRect _barFrameUp;
    id _quad2;
}

+ (id)screenCacheImageForView:(id)arg1;
@property __weak id quad2; // @synthesize quad2=_quad2;
@property(nonatomic) struct CGRect barFrameUp; // @synthesize barFrameUp=_barFrameUp;
@property(nonatomic) struct CGRect barFrame; // @synthesize barFrame=_barFrame;
@property __weak id quad3; // @synthesize quad3=_quad3;
@property __weak NSImageView *view; // @synthesize view=_view;
@property __weak id quad4; // @synthesize quad4=_quad4;
@property __weak id closeButton; // @synthesize closeButton=_closeButton;
@property __weak id quad1; // @synthesize quad1=_quad1;
@property __weak TransparentWindow *window; // @synthesize window=_window;
@property __weak TransparentWindow *shroud; // @synthesize shroud=_shroud;
@property(nonatomic) double defaultSize; // @synthesize defaultSize=_defaultSize;
@property __weak AZSplitView *horizonSplit; // @synthesize horizonSplit=_horizonSplit;
@property __weak id subBar; // @synthesize subBar=_subBar;
@property(nonatomic) int shroudState; // @synthesize shroudState=_shroudState;
@property __weak NSWindow *leveler; // @synthesize leveler=_leveler;
- (void).cxx_destruct;
- (void)appWillActivate;
- (void)appWillResign;
- (void)capture;
- (void)shroudOut;
- (void)mouseExited:(id)arg1;
- (void)mouseEntered:(id)arg1;
- (void)futureCancelSetHoveringOverNote:(BOOL)arg1;
- (void)futureSetHoveringOverNote:(BOOL)arg1;
- (void)setHoveringOverNote:(id)arg1;
- (void)conditionallyShowCloseButton;
- (void)awakeFromNib;
- (void)toggleLeftView:(id)arg1;
- (double)splitView:(id)arg1 constrainSplitPosition:(double)arg2 ofSubviewAt:(long long)arg3;
- (BOOL)splitView:(id)arg1 shouldCollapseSubview:(id)arg2 forDoubleClickOnDividerAtIndex:(long long)arg3;
- (BOOL)splitView:(id)arg1 canCollapseSubview:(id)arg2;
- (double)splitView:(id)arg1 constrainMaxCoordinate:(double)arg2 ofSubviewAt:(long long)arg3;
- (double)splitView:(id)arg1 constrainMinCoordinate:(double)arg2 ofSubviewAt:(long long)arg3;
- (struct CGRect)splitView:(id)arg1 additionalEffectiveRectOfDividerAtIndex:(long long)arg2;
- (BOOL)splitView:(id)arg1 shouldHideDividerAtIndex:(long long)arg2;

@end

@interface AZTrackingWindow : NSWindow
{
    struct CGRect _workingFrame;
    BOOL _showsHandle;
    struct CGRect _visibleFrame;
    double _intrusion;
    struct CGRect _triggerFrame;
    NSImageView *_handle;
    int _slideState;
    double _triggerWidth;
    AZSimpleView *_view;
    int _position;
}

+ (id)oriented:(int)arg1 intruding:(double)arg2 withDelegate:(id)arg3;
+ (id)oriented:(int)arg1 intruding:(double)arg2;
+ (id)oriented:(int)arg1 intruding:(double)arg2 inRect:(struct CGRect)arg3;
+ (id)oriented:(int)arg1 intruding:(double)arg2 inRect:(struct CGRect)arg3 withDelegate:(id)arg4;
+ (id)standardInit;
@property(nonatomic) int position; // @synthesize position=_position;
@property(retain, nonatomic) AZSimpleView *view; // @synthesize view=_view;
@property(nonatomic) double triggerWidth; // @synthesize triggerWidth=_triggerWidth;
@property(nonatomic) int slideState; // @synthesize slideState=_slideState;
@property(retain, nonatomic) NSImageView *handle; // @synthesize handle=_handle;
@property(nonatomic) struct CGRect triggerFrame; // @synthesize triggerFrame=_triggerFrame;
@property(nonatomic) double intrusion; // @synthesize intrusion=_intrusion;
@property(nonatomic) struct CGRect visibleFrame; // @synthesize visibleFrame=_visibleFrame;
@property(nonatomic) BOOL showsHandle; // @synthesize showsHandle=_showsHandle;
@property(nonatomic) struct CGRect workingFrame; // @synthesize workingFrame=_workingFrame;
- (void).cxx_destruct;
- (void)mouseHandler:(id)arg1;
- (BOOL)acceptsFirstResponder;
- (void)slideOut;
- (void)slideIn;
- (void)awakeFromNib;
@property(readonly) unsigned long long capacity;
@property(readonly) int orientation;
@property(readonly) struct CGRect outFrame;

@end

@interface CornerClipView : NSView
{
    struct AZTriPair _t;
    AZTrackingWindow *_windy;
}

+ (id)initInWindow:(id)arg1;
@property __weak AZTrackingWindow *windy; // @synthesize windy=_windy;
@property(nonatomic, getter=getPair) struct AZTriPair t; // @synthesize t=_t;
- (void).cxx_destruct;
- (void)drawRect:(struct CGRect)arg1;
- (void)viewWillDraw;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface GridLayoutManager : CALayer
{
}

- (void)drawLayer:(id)arg1 inContext:(struct CGContext *)arg2;

@end

@interface AZFileGridView : NSView
{
    GridLayoutManager *_gridManager;
    CALayer *_root;
    CALayer *_veil;
    CALayer *_gridLayer;
    NSArray *_content;
    CALayer *_contentLayer;
    NSMutableArray *_layers;
    AZSizer *_sizer;
}

@property(retain, nonatomic) AZSizer *sizer; // @synthesize sizer=_sizer;
@property(retain, nonatomic) NSMutableArray *layers; // @synthesize layers=_layers;
@property(retain, nonatomic) CALayer *contentLayer; // @synthesize contentLayer=_contentLayer;
@property(retain, nonatomic) NSArray *content; // @synthesize content=_content;
@property(retain, nonatomic) CALayer *gridLayer; // @synthesize gridLayer=_gridLayer;
@property(retain, nonatomic) CALayer *veil; // @synthesize veil=_veil;
@property(retain, nonatomic) CALayer *root; // @synthesize root=_root;
@property(retain, nonatomic) GridLayoutManager *gridManager; // @synthesize gridManager=_gridManager;
- (void).cxx_destruct;
- (void)mouseDown:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1 andFiles:(id)arg2;
- (void)viewDidEndLiveResize;
- (void)viewWillStartLiveResize;

@end

@interface GridLayer : CAConstraintLayoutManager
{
    AZSizer *_sizer;
}

@property(retain, nonatomic) AZSizer *sizer; // @synthesize sizer=_sizer;
- (void).cxx_destruct;
- (void)layoutSublayersOfLayer:(id)arg1;

@end

@interface AZSpinnerLayer : CALayer
{
    BOOL _isRunning;
    NSTimer *_animationTimer;
    unsigned long long _position;
    struct CGColor *_foreColor;
    double _fadeDownOpacity;
    unsigned long long _numFins;
    NSMutableArray *_finLayers;
}

@property(readonly) BOOL isRunning; // @synthesize isRunning=_isRunning;
- (void).cxx_destruct;
- (struct CGPoint)finAnchorPointForCurrentBounds;
- (struct CGRect)finBoundsForCurrentBounds;
- (void)removeFinLayers;
- (void)createFinLayers;
- (void)toggleProgressAnimation;
@property(copy) NSColor *color;
- (void)stopProgressAnimation;
- (void)startProgressAnimation;
- (void)disposeAnimTimer;
- (void)setupAnimTimer;
- (void)advancePosition;
- (void)setBounds:(struct CGRect)arg1;
- (void)dealloc;
- (id)init;

@end

@interface AZBackgroundProgressBar : NSView
{
    BOOL shouldStop;
    double phase;
    double lastUpdate;
}

- (void)stopAnimation:(id)arg1;
- (void)startAnimation:(id)arg1;
- (void)doAnimation;
- (void)drawRect:(struct CGRect)arg1;
- (BOOL)isFlipped;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface AZSegmentedRect : AZRect
{
    struct CGPoint segments;
    BOOL emptyBorder;
    struct CGSize minimumSegmentSize;
    struct CGSize maximumSegmentSize;
    int *_orientation;
}

+ (id)rectWithRect:(struct CGRect)arg1 width:(unsigned long long)arg2 height:(unsigned long long)arg3;
+ (id)rectWithRect:(struct CGRect)arg1 cubicSize:(unsigned long long)arg2;
+ (id)rectWithRect:(struct CGRect)arg1;
@property(nonatomic) int *orientation; // @synthesize orientation=_orientation;
@property(nonatomic) struct CGSize maximumSegmentSize; // @synthesize maximumSegmentSize;
@property(nonatomic) struct CGSize minimumSegmentSize; // @synthesize minimumSegmentSize;
@property(nonatomic) BOOL emptyBorder; // @synthesize emptyBorder;
- (struct CGPoint)pointWithString:(id)arg1;
- (id)segmentAtX:(unsigned long long)arg1 y:(unsigned long long)arg2;
- (id)segmentAtIndex:(unsigned long long)arg1;
- (id)rectForPerimeterIndex:(unsigned long long)arg1;
- (struct CGRect)rectOfSegmentAtX:(unsigned long long)arg1 y:(unsigned long long)arg2;
- (struct CGRect)rectOfSegmentAtIndex:(unsigned long long)arg1;
- (struct CGPoint)pointOfSegmentAtX:(unsigned long long)arg1 y:(unsigned long long)arg2;
- (struct CGPoint)pointOfSegmentAtIndex:(unsigned long long)arg1;
- (unsigned long long)indexAtPoint:(struct CGPoint)arg1;
- (struct CGPoint)indicesOfSegmentAtIndex:(unsigned long long)arg1;
@property(readonly) struct CGSize segmentSize;
@property(readonly) unsigned long long segmentCount;
- (id)setDimensionWidth:(unsigned long long)arg1 height:(unsigned long long)arg2;
- (id)setCubicSize:(unsigned long long)arg1;
@property(nonatomic) unsigned long long verticalSegments;
@property(nonatomic) unsigned long long horizontalSegments;
- (id)init;

@end

@interface F : NSObject
{
}

+ (id)mapRangeFrom:(long long)arg1 To:(long long)arg2 withBlock:(id)arg3;
+ (void)onUIThread:(id)arg1;
+ (void)asynchronously:(id)arg1;
+ (void)times:(id)arg1 RunBlock:(id)arg2;
+ (id)dropFromArray:(id)arg1 whileBlock:(id)arg2;
+ (id)groupArray:(id)arg1 withBlock:(id)arg2;
+ (id)minDict:(id)arg1 withBlock:(id)arg2;
+ (id)minArray:(id)arg1 withBlock:(id)arg2;
+ (id)maxDict:(id)arg1 withBlock:(id)arg2;
+ (id)maxArray:(id)arg1 withBlock:(id)arg2;
+ (id)countInDictionary:(id)arg1 withBlock:(id)arg2;
+ (id)countInArray:(id)arg1 withBlock:(id)arg2;
+ (BOOL)anyInDictionary:(id)arg1 withBlock:(id)arg2;
+ (BOOL)anyInArray:(id)arg1 withBlock:(id)arg2;
+ (BOOL)allInDictionary:(id)arg1 withBlock:(id)arg2;
+ (BOOL)allInArray:(id)arg1 withBlock:(id)arg2;
+ (id)rejectDictionary:(id)arg1 withBlock:(id)arg2;
+ (id)rejectArray:(id)arg1 withBlock:(id)arg2;
+ (id)filterDictionary:(id)arg1 withBlock:(id)arg2;
+ (id)filterArray:(id)arg1 withBlock:(id)arg2;
+ (id)reduceDictionary:(id)arg1 withBlock:(id)arg2 andInitialMemo:(void)arg3;
+ (id)reduceArray:(id)arg1 withBlock:(id)arg2 andInitialMemo:(void)arg3;
+ (id)mapDict:(id)arg1 withBlock:(id)arg2;
+ (id)mapArray:(id)arg1 withBlock:(id)arg2;
+ (void)eachInDict:(id)arg1 withBlock:(id)arg2;
+ (void)eachInArrayWithIndex:(id)arg1 withBlock:(id)arg2;
+ (void)eachInArray:(id)arg1 withBlock:(id)arg2;
+ (void)concurrently:(id)arg1 withQueue:(void)arg2;
+ (void)concurrently:(id)arg1;
+ (void)useQueue:(struct dispatch_queue_s *)arg1;
+ (void)dontUseConcurrency;
+ (void)useConcurrency;

@end

@interface AGProcess : NSObject
{
    int process;
    unsigned int task;
    NSString *command;
    NSString *annotation;
    NSArray *arguments;
    NSDictionary *environment;
}

+ (id)processForCommand:(id)arg1;
+ (id)processesForCommand:(id)arg1;
+ (id)processesForRealUser:(int)arg1;
+ (id)processesForUser:(int)arg1;
+ (id)processesForTerminal:(int)arg1;
+ (id)processesForProcessGroup:(int)arg1;
+ (id)processForProcessIdentifier:(int)arg1;
+ (id)userProcesses;
+ (id)allProcesses;
+ (id)currentProcess;
+ (void)initialize;
+ (id)processesForThirdLevelName:(int)arg1 value:(int)arg2;
- (void)dealloc;
- (id)description;
- (BOOL)isEqual:(id)arg1;
- (unsigned int)hash;
- (int)threadCount;
- (int)basePriority;
- (int)priority;
- (int)state;
- (unsigned int)residentMemorySize;
- (unsigned int)virtualMemorySize;
- (double)percentMemoryUsage;
- (double)systemCPUTime;
- (double)userCPUTime;
- (double)totalCPUTime;
- (double)percentCPUUsage;
- (id)siblings;
- (id)children;
- (id)parent;
- (id)environment;
- (id)arguments;
- (id)annotatedCommand;
- (id)annotation;
- (id)command;
- (int)realUserIdentifier;
- (int)userIdentifier;
- (int)terminalProcessGroup;
- (int)terminal;
- (int)processGroup;
- (int)parentProcessIdentifier;
- (int)processIdentifier;
- (id)initWithProcessIdentifier:(int)arg1;
- (void)doProcargs;
- (BOOL)kill:(int)arg1;
- (BOOL)terminate;
- (BOOL)interrupt;
- (BOOL)resume;
- (BOOL)suspend;
- (int)contextSwitches;
- (int)unixSystemCalls;
- (int)machSystemCalls;
- (int)messagesReceived;
- (int)messagesSent;
- (int)copyOnWriteFaults;
- (int)pageins;
- (int)faults;

@end

@interface XLDragDropView : NSView <NSDraggingDestination>
{
    NSString *_normalBackgroundImageName;
    NSString *_highlightedBackgroundImageName;
    NSString *_acceptedBackgroundImageName;
    NSImage *_normalBackgroundImage;
    NSImage *_highlightedBackgroundImage;
    NSImage *_acceptedBackgroundImage;
    NSImage *_currentBackgroundImage;
    NSString *_filePath;
    NSArray *_desiredSuffixes;
    BOOL _isFileReady;
    id <DragDropViewDelegate> _delegate;
}

@property(readonly, nonatomic) BOOL isFileReady; // @synthesize isFileReady=_isFileReady;
@property(retain, nonatomic) NSArray *desiredSuffixes; // @synthesize desiredSuffixes=_desiredSuffixes;
@property(readonly, nonatomic) NSString *filePath; // @synthesize filePath=_filePath;
@property(retain, nonatomic) NSString *acceptedBackgroundImageName; // @synthesize acceptedBackgroundImageName=_acceptedBackgroundImageName;
@property(retain, nonatomic) NSString *highlightedBackgroundImageName; // @synthesize highlightedBackgroundImageName=_highlightedBackgroundImageName;
@property(retain, nonatomic) NSString *normalBackgroundImageName; // @synthesize normalBackgroundImageName=_normalBackgroundImageName;
@property(nonatomic) id <DragDropViewDelegate> delegate; // @synthesize delegate=_delegate;
- (void).cxx_destruct;
- (void)draggingExited:(id)arg1;
- (BOOL)performDragOperation:(id)arg1;
- (BOOL)prepareForDragOperation:(id)arg1;
- (void)draggingEnded:(id)arg1;
- (unsigned long long)draggingUpdated:(id)arg1;
- (unsigned long long)draggingEntered:(id)arg1;
- (void)drawRect:(struct CGRect)arg1;
- (BOOL)resignFirstResponder;
- (BOOL)becomeFirstResponder;
- (BOOL)acceptsFirstResponder;
- (void)viewWillDraw;
- (void)setCurrentBackgroundImage:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1 normalBackgroundImageName:(id)arg2;
- (id)initWithFrame:(struct CGRect)arg1;
- (void)load;

@end

@interface AZCSSColorExtraction : NSObject
{
}

- (id)colorsInStyleSheet:(id)arg1;
- (id)init;

@end

@interface AZMedallionView : NSView
{
    NSColor *backgroundColor;
    struct CGSize _shadowOffset;
    struct CGGradient *_alphaGradient;
    NSImage *_image;
    double _shadowBlur;
    NSColor *_borderColor;
    double _borderWidth;
    NSColor *_shadowColor;
}

@property(retain, nonatomic) NSColor *shadowColor; // @synthesize shadowColor=_shadowColor;
@property(nonatomic) double borderWidth; // @synthesize borderWidth=_borderWidth;
@property(retain, nonatomic) NSColor *borderColor; // @synthesize borderColor=_borderColor;
@property(nonatomic) double shadowBlur; // @synthesize shadowBlur=_shadowBlur;
@property(retain, nonatomic) NSImage *image; // @synthesize image=_image;
@property(nonatomic) struct CGGradient *alphaGradient; // @synthesize alphaGradient=_alphaGradient;
@property(nonatomic) struct CGSize shadowOffset; // @synthesize shadowOffset=_shadowOffset;
- (void).cxx_destruct;
- (void)drawRect:(struct CGRect)arg1;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface CALayerNoHit : CALayer
{
}

- (BOOL)containsPoint:(struct CGPoint)arg1;

@end

@interface CAShapeLayerNoHit : CAShapeLayer
{
}

- (BOOL)containsPoint:(struct CGPoint)arg1;

@end

@interface CATextLayerNoHit : CATextLayer
{
}

- (BOOL)containsPoint:(struct CGPoint)arg1;

@end

@interface NSBag : NSObject
{
    NSMutableDictionary *dict;
}

+ (id)bagWithObjects:(id)arg1;
+ (id)bag;
- (void).cxx_destruct;
- (id)description;
- (id)objects;
- (long long)occurrencesOf:(id)arg1;
- (void)remove:(id)arg1;
- (void)addObjects:(id)arg1;
- (void)add:(id)arg1;
- (id)init;

@end

@interface AZFolder : BaseModel <BaseModel, NSCopying, NSMutableCopying, NSFastEnumeration>
{
    NSMutableArray *_paths;
    NSArray *_categories;
    NSArray *_folders;
}

+ (id)appFolder;
+ (id)instanceWithPaths:(id)arg1;
+ (id)instanceWithFiles:(id)arg1;
+ (id)instanceWithItems:(id)arg1;
+ (id)samplerWithBetween:(unsigned long long)arg1 andMax:(unsigned long long)arg2;
@property(readonly) NSArray *folders; // @synthesize folders=_folders;
@property(readonly) NSArray *categories; // @synthesize categories=_categories;
@property(retain, nonatomic) NSMutableArray *paths; // @synthesize paths=_paths;
- (void).cxx_destruct;
@property(readonly) NSArray *appFolder;
@property(readonly) NSArray *files;
@property(readonly) unsigned long long count;

// Remaining properties
@property(retain, nonatomic) NSMutableArray *backingstore;

@end

@interface AZDock : BaseModel
{
    NSArray *_dockSorted;
    NSArray *_dock;
    int _sortOrder;
}

@property(nonatomic) int sortOrder; // @synthesize sortOrder=_sortOrder;
@property(readonly) NSArray *dock; // @synthesize dock=_dock;
@property(readonly) NSArray *dockSorted; // @synthesize dockSorted=_dockSorted;
- (void).cxx_destruct;
- (void)setUp;

@end

@interface AZColor : BaseModel
{
    double brightness;
    double saturation;
    double hue;
    double percent;
    unsigned long long count;
    NSString *name;
    NSColor *color;
    double hueComponent;
}

+ (id)instanceWithObject:(id)arg1;
+ (id)instanceWithColor:(id)arg1;
@property(readonly, nonatomic) double hueComponent; // @synthesize hueComponent;
@property(retain, nonatomic) NSColor *color; // @synthesize color;
@property(retain, nonatomic) NSString *name; // @synthesize name;
@property(nonatomic) unsigned long long count; // @synthesize count;
@property(nonatomic) double percent; // @synthesize percent;
@property(readonly, nonatomic) double hue; // @synthesize hue;
@property(readonly, nonatomic) double saturation; // @synthesize saturation;
@property(readonly, nonatomic) double brightness; // @synthesize brightness;
- (void).cxx_destruct;
- (id)colorsForImage:(id)arg1;

@end

@interface LoremIpsum : NSObject
{
    NSArray *_words;
}

- (id)sentences:(unsigned long long)arg1;
- (id)words:(unsigned long long)arg1;
- (id)randomWord;
- (void)dealloc;
- (id)init;

@end

@interface AZTextViewResponder : NSTextView
{
}

- (void)mouseDown:(id)arg1;

@end

@interface AZCoreScrollView : NSView
{
    CALayer *_mainLayer;
    AZScrollerLayer *_scrollerLayer;
    int _currentMouseEventType;
    AZScrollPaneLayer *_bodyLayer;
    NSGradient *_bgGradient;
}

@property(retain, nonatomic) NSGradient *bgGradient; // @synthesize bgGradient=_bgGradient;
@property(retain, nonatomic) AZScrollPaneLayer *bodyLayer; // @synthesize bodyLayer=_bodyLayer;
@property(nonatomic) int currentMouseEventType; // @synthesize currentMouseEventType=_currentMouseEventType;
@property(retain, nonatomic) AZScrollerLayer *scrollerLayer; // @synthesize scrollerLayer=_scrollerLayer;
@property(retain, nonatomic) CALayer *mainLayer; // @synthesize mainLayer=_mainLayer;
- (void).cxx_destruct;
- (void)debugLayers:(id)arg1;
- (void)moveSelection:(long long)arg1;
- (void)appBecameActive:(id)arg1;
- (void)appNoLongerActive:(id)arg1;
- (void)scrollWheel:(id)arg1;
- (void)mouseUp:(id)arg1;
- (void)mouseDragged:(id)arg1;
- (void)mouseDown:(id)arg1;
- (void)keyDown:(id)arg1;
- (BOOL)acceptsFirstResponder;
- (void)drawRect:(struct CGRect)arg1;
- (void)setupListeners;
- (void)setupLayers;
- (void)awakeFromNib;

@end

@interface AZScrollerLayer : CALayer <AZScrollerContentController>
{
    CALayer *leftArrow;
    CALayer *leftArrowHighlight;
    CALayer *rightArrow;
    CALayer *rightArrowHighlight;
    CALayer *tray;
    CALayer *slider;
    id <AZScrollerContent> _scrollerContent;
    int _inputMode;
    struct CGPoint _mouseDownPointForCurrentEvent;
    BOOL _mouseOverSelectedInput;
    NSTimer *mouseDownTimer;
}

@property id <AZScrollerContent> scrollerContent; // @synthesize scrollerContent=_scrollerContent;
- (void).cxx_destruct;
- (void)scrollContentResized;
- (void)scrollPositionChanged:(double)arg1;
- (BOOL)isRepositioning;
- (void)mouseUp:(struct CGPoint)arg1;
- (void)mouseDragged:(struct CGPoint)arg1;
- (BOOL)mouseDownAtPointInSuperlayer:(struct CGPoint)arg1;
- (void)periodicMouseDownEvent:(id)arg1;
- (void)startMouseDownTimer;
- (void)addContents:(id)arg1 toLayer:(id)arg2;
- (void)addMask:(id)arg1 toLayer:(id)arg2;
- (id)createGlassImageForSize:(struct CGSize)arg1;
- (id)createArrowMaskImageForPt:(struct CGPoint)arg1 pt2:(struct CGPoint)arg2 pt3:(struct CGPoint)arg3 pt4:(struct CGPoint)arg4 pt5:(struct CGPoint)arg5;
- (id)createArrowTriangleWithPt:(struct CGPoint)arg1 pt2:(struct CGPoint)arg2 pt3:(struct CGPoint)arg3;
- (id)createArrowBorderPathWithPt:(struct CGPoint)arg1 pt2:(struct CGPoint)arg2 pt3:(struct CGPoint)arg3;
- (void)setContentForArrowLayer:(id)arg1 withArrow:(id)arg2 andBorder:(id)arg3;
- (void)createRightArrow;
- (void)createLeftArrow;
- (void)setSliderSideLayer:(id)arg1 contents:(id)arg2 andPts:(struct CGPoint)arg3 pt2:(struct CGPoint)arg4 pt3:(struct CGPoint)arg5;
- (void)createSlider;
- (void)createScrollTray;
- (void)moveSlider:(double)arg1;
- (void)setSliderPosition:(double)arg1;
- (void)setSliderWidth:(double)arg1;
- (void)layoutSublayers;
- (id)init;

@end

@interface AZScrollPaneLayer : CAScrollLayer <AZScrollerContent>
{
    BOOL selectionAnim;
    id <AZScrollerContentController> _contentController;
    double contentWidth;
    double visibleWidth;
    double stepSize;
}

@property id <AZScrollerContentController> contentController; // @synthesize contentController=_contentController;
- (void)stopWiggling:(id)arg1;
- (void)startWiggling:(id)arg1;
- (double)stepSize;
- (void)moveScrollView:(double)arg1;
- (void)scrollToPosition:(double)arg1;
- (double)visibleWidth;
- (double)contentWidth;
- (void)scrollToPoint:(struct CGPoint)arg1;
- (long long)selectedIndex;
- (void)scrollToSelected;
- (void)moveSelection:(long long)arg1;
- (void)zoomAnimation:(id)arg1;
- (void)selectSnapShot:(long long)arg1;
- (void)mouseDownAtPointInSuperlayer:(struct CGPoint)arg1;
- (void)layoutSublayers;

@end

@interface AZSnapShotLayer : CALayer
{
    struct CGGradient *backgroundGradient;
    CALayer *_contentLayer;
    CALayer *_gradLayer;
    id _objectRep;
    CATransformLayer *_trannyLayer;
    CAConstraintLayoutManager *_constrainLayer;
    BOOL _selected;
    CALayer *_imageLayer;
    CATextLayer *_labelLayer;
    int _mode;
}

+ (id)rootSnapshot;
+ (id)rootSnapWithFile:(id)arg1 andDisplayMode:(int)arg2;
@property(nonatomic) int mode; // @synthesize mode=_mode;
@property(retain, nonatomic) CATextLayer *labelLayer; // @synthesize labelLayer=_labelLayer;
@property(retain, nonatomic) CALayer *imageLayer; // @synthesize imageLayer=_imageLayer;
@property(nonatomic) BOOL selected; // @synthesize selected=_selected;
@property(retain, nonatomic) CAConstraintLayoutManager *constrainLayer; // @synthesize constrainLayer=_constrainLayer;
@property(retain, nonatomic) CATransformLayer *trannyLayer; // @synthesize trannyLayer=_trannyLayer;
@property(retain, nonatomic) id objectRep; // @synthesize objectRep=_objectRep;
@property(retain, nonatomic) CALayer *gradLayer; // @synthesize gradLayer=_gradLayer;
@property(retain, nonatomic) CALayer *contentLayer; // @synthesize contentLayer=_contentLayer;
- (void).cxx_destruct;
- (void)didChangeValueForKey:(id)arg1;

@end

@interface AZTimeLineLayout : NSObject
{
}

+ (id)layoutManager;
- (void)layoutSublayersOfLayer:(id)arg1;
- (struct CGSize)preferredSizeOfLayer:(id)arg1;
- (struct CGPoint)scrollPointForSelected:(id)arg1;

@end

@interface AZCalculatorController : NSWindowController
{
    NSWindow *window;
    NSString *labelValue;
    CalcModel *_calc;
    NSTextField *_label;
}

+ (id)nibName;
+ (id)sharedCalc;
@property NSTextField *label; // @synthesize label=_label;
@property(retain, nonatomic) CalcModel *calc; // @synthesize calc=_calc;
@property(retain, nonatomic) NSString *labelValue; // @synthesize labelValue;
@property NSWindow *window; // @synthesize window;
- (void).cxx_destruct;
- (void)setLabel;
- (void)getValue:(id)arg1;
- (void)add:(id)arg1;
- (void)dealloc;
- (id)init;

@end

@interface CalcModel : NSObject
{
    long long accumulatorValue;
    long long transientValue;
    BOOL restartText;
    int currentOperation;
}

@property(nonatomic) int currentOperation; // @synthesize currentOperation;
@property(nonatomic) BOOL restartText; // @synthesize restartText;
@property(nonatomic) long long transientValue; // @synthesize transientValue;
@property(nonatomic) long long accumulatorValue; // @synthesize accumulatorValue;
- (void)operatorAction:(int)arg1;
- (void)doArithmetic;
- (void)numberInput:(id)arg1;
- (id)init;

@end

@interface AZLassoLayer : CALayer
{
    double _dynamicStroke;
    NSBezierPath *_bPath;
    CAShapeLayer *_lasso;
    CAShapeLayer *_lassoBorder;
}

+ (id)lasso:(id)arg1;
@property(retain, nonatomic) CAShapeLayer *lassoBorder; // @synthesize lassoBorder=_lassoBorder;
@property(retain, nonatomic) CAShapeLayer *lasso; // @synthesize lasso=_lasso;
@property(retain, nonatomic) NSBezierPath *bPath; // @synthesize bPath=_bPath;
@property(nonatomic) double dynamicStroke; // @synthesize dynamicStroke=_dynamicStroke;
- (void).cxx_destruct;
- (void)layoutSublayersOfLayer:(id)arg1;
- (id)init;

@end

@interface CTGradient : NSObject <NSCopying, NSCoding>
{
    struct _CTGradientElement *elementList;
    int blendingMode;
    struct CGFunction *gradientFunction;
}

+ (id)hydrogenSpectrumGradient;
+ (id)rainbowGradient;
+ (id)sourceListUnselectedGradient;
+ (id)sourceListSelectedGradient;
+ (id)unifiedDarkGradient;
+ (id)unifiedPressedGradient;
+ (id)unifiedNormalGradient;
+ (id)unifiedSelectedGradient;
+ (id)aquaPressedGradient;
+ (id)aquaNormalGradient;
+ (id)aquaSelectedGradient;
+ (id)gradientWithBeginningColor:(id)arg1 endingColor:(id)arg2;
- (struct _CTGradientElement *)elementAtIndex:(unsigned int)arg1;
- (struct _CTGradientElement)removeElementAtPosition:(float)arg1;
- (struct _CTGradientElement)removeElementAtIndex:(unsigned int)arg1;
- (void)addElement:(struct _CTGradientElement *)arg1;
- (void)setBlendingMode:(int)arg1;
- (void)radialFillRect:(struct CGRect)arg1;
- (void)fillRect:(struct CGRect)arg1 angle:(float)arg2;
- (void)drawSwatchInRect:(struct CGRect)arg1;
- (id)colorAtPosition:(float)arg1;
- (id)colorStopAtIndex:(unsigned int)arg1;
- (int)blendingMode;
- (id)removeColorStopAtIndex:(unsigned int)arg1;
- (id)removeColorStopAtPosition:(float)arg1;
- (id)addColorStop:(id)arg1 atPosition:(float)arg2;
- (id)gradientWithBlendingMode:(int)arg1;
- (id)gradientWithAlphaComponent:(float)arg1;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (void)dealloc;
- (void)_commonInit;
- (id)init;

@end

@interface Transition : NSObject
{
    id delegate;
    CIImage *initialImage;
    CIImage *inputShadingImage;
    NSAnimation *animation;
    CIImage *finalImage;
    double transitionDuration;
    CIFilter *transitionFilter;
    CIFilter *transitionFilter2;
    BOOL _chaining;
    double _direction;
    int _style;
    unsigned long long _frames;
}

+ (void)updatePerspectiveFilter:(id)arg1 px1:(float)arg2 pz1:(float)arg3 px2:(float)arg4 pz2:(float)arg5 dist:(float)arg6 width:(float)arg7 height:(float)arg8;
@property(nonatomic) unsigned long long frames; // @synthesize frames=_frames;
@property(nonatomic) int style; // @synthesize style=_style;
@property(nonatomic) double direction; // @synthesize direction=_direction;
@property(nonatomic) BOOL chaining; // @synthesize chaining=_chaining;
@property(retain, nonatomic) CIFilter *transitionFilter2; // @synthesize transitionFilter2;
@property(retain, nonatomic) CIFilter *transitionFilter; // @synthesize transitionFilter;
@property(retain, nonatomic) CIImage *finalImage; // @synthesize finalImage;
@property(retain, nonatomic) NSAnimation *animation; // @synthesize animation;
@property(retain, nonatomic) CIImage *inputShadingImage; // @synthesize inputShadingImage;
@property(retain, nonatomic) CIImage *initialImage; // @synthesize initialImage;
@property id delegate; // @synthesize delegate;
- (void).cxx_destruct;
- (void)draw:(struct CGRect)arg1;
- (void)start;
- (BOOL)isAnimating;
- (void)setFinalView:(id)arg1;
- (void)setInitialView:(id)arg1;
- (id)createCoreImage:(id)arg1;
@property(nonatomic) double transitionDuration; // @synthesize transitionDuration;
- (void)setStyle:(int)arg1 direction:(float)arg2;
- (void)dealloc;
- (void)reset;
- (id)initWithDelegate:(id)arg1 shadingImage:(id)arg2;

@end

@interface TransitionAnimation : NSAnimation
{
}

- (void)setCurrentProgress:(float)arg1;

@end

@interface CTBadge : NSObject
{
    NSColor *badgeColor;
    NSColor *labelColor;
}

+ (id)badgeWithColor:(id)arg1 labelColor:(id)arg2;
+ (id)systemBadge;
- (void).cxx_destruct;
- (id)badgeMaskOfSize:(float)arg1 length:(unsigned int)arg2;
- (id)stringForValue:(unsigned int)arg1;
- (id)labelForString:(id)arg1 size:(unsigned int)arg2;
- (id)badgeGradient;
- (void)badgeApplicationDockIconWithValue:(unsigned int)arg1 insetX:(float)arg2 y:(float)arg3;
- (id)badgeOverlayImageForValue:(unsigned int)arg1 insetX:(float)arg2 y:(float)arg3;
- (void)badgeApplicationDockIconWithString:(id)arg1 insetX:(float)arg2 y:(float)arg3;
- (id)badgeOverlayImageForString:(id)arg1 insetX:(float)arg2 y:(float)arg3;
- (id)badgeOfSize:(float)arg1 forString:(id)arg2;
- (id)badgeOfSize:(float)arg1 forValue:(unsigned int)arg2;
- (id)largeBadgeForString:(id)arg1;
- (id)largeBadgeForValue:(unsigned int)arg1;
- (id)smallBadgeForString:(id)arg1;
- (id)smallBadgeForValue:(unsigned int)arg1;
- (id)labelColor;
- (id)badgeColor;
- (void)setLabelColor:(id)arg1;
- (void)setBadgeColor:(id)arg1;
- (id)init;

@end

@interface AZHostView : NSView
{
    CALayer *_host;
}

@property(retain, nonatomic) CALayer *host; // @synthesize host=_host;
- (void).cxx_destruct;
- (void)awakeFromNib;

@end

@interface AZFile : BaseModel
{
    NSColor *_color;
    NSArray *_colors;
    NSImage *_image;
    NSColor *_labelColor;
    NSString *_calulatedBundleID;
    NSColor *_customColor;
    BOOL _hasLabel;
    NSString *_name;
    NSNumber *_labelNumber;
    NSString *_path;
    int _position;
    double _hue;
}

+ (id)instanceWithPath:(id)arg1;
+ (id)instanceWithImage:(id)arg1;
+ (id)instanceWithColor:(id)arg1;
+ (id)dummy;
+ (id)forAppNamed:(id)arg1;
@property(nonatomic) double hue; // @synthesize hue=_hue;
@property(nonatomic) int position; // @synthesize position=_position;
@property(retain, nonatomic) NSString *path; // @synthesize path=_path;
@property(nonatomic) NSNumber *labelNumber; // @synthesize labelNumber=_labelNumber;
@property(retain, nonatomic) NSString *name; // @synthesize name=_name;
@property(readonly, nonatomic) BOOL hasLabel; // @synthesize hasLabel=_hasLabel;
@property(retain, nonatomic) NSColor *customColor; // @synthesize customColor=_customColor;
@property(retain, nonatomic) NSString *calulatedBundleID; // @synthesize calulatedBundleID=_calulatedBundleID;
@property(retain, nonatomic) NSColor *labelColor; // @synthesize labelColor=_labelColor;
@property(retain, nonatomic) NSImage *image; // @synthesize image=_image;
@property(retain, nonatomic) NSArray *colors; // @synthesize colors=_colors;
@property(retain, nonatomic) NSColor *color; // @synthesize color=_color;
- (void).cxx_destruct;
- (void)setActualLabelNumber:(id)arg1;
- (void)setActualLabelColor:(id)arg1;
- (BOOL)isRunning;
- (void)setWithString:(id)arg1;
- (void)setUp;

@end

@interface AZDockItem
{
}

+ (id)instanceWithPath:(id)arg1;

@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSApplication (AtoZ)
+ (id)infoValueForKey:(id)arg1;
- (void)setShowsDockIcon:(BOOL)arg1;
- (BOOL)showsDockIcon;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSWindow (NSWindow_Flipr)
+ (void)releaseFlippingWindow;
+ (id)flippingWindow;
- (void)flipToShowWindow:(id)arg1 forward:(BOOL)arg2;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSObject (debugandreturn)
- (id)debugReturn:(id)arg1;
@end

@interface CAAnimation (NSViewFlipper)
+ (id)flipAnimationWithDuration:(double)arg1 forLayerBeginningOnTop:(BOOL)arg2 scaleFactor:(double)arg3;
@end

@interface NSView (AGAdditions)
- (id)layerFromContents;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSClipView (InfinityAdditions)
- (BOOL)isFlipped;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSArray (EnumExtensions)
- (unsigned long long)enumFromString:(id)arg1;
- (unsigned long long)enumFromString:(id)arg1 default:(unsigned long long)arg2;
- (id)stringWithEnum:(unsigned long long)arg1;
@end

@interface NSArray (NSTableDataSource)
- (int)numberOfRowsInTableView:(id)arg1;
- (id)tableView:(id)arg1 objectValueForTableColumn:(id)arg2 row:(int)arg3;
@end

@interface NSArray (AtoZ)
+ (id)arrayWithDoubles:(double)arg1;
+ (id)arrayWithInts:(long long)arg1;
+ (id)mutableArrayWithArrays:(id)arg1;
+ (id)arrayWithArrays:(id)arg1;
+ (id)arrayFromPlist:(id)arg1;
- (id)mapArray:(id)arg1;
- (id)findAllIntoWeakRefsWithBlock:(id)arg1;
- (id)findAllWithBlock:(id)arg1;
- (BOOL)isObjectInArrayWithBlock:(id)arg1;
- (id)findWithBlock:(id)arg1;
- (void)az_eachConcurrentlyWithBlock:(id)arg1;
- (void)az_each:(id)arg1;
- (id)firstObject;
- (id)uniqueObjectsSortedUsingSelector:(SEL)arg1;
- (id)uniqueObjects;
- (id)filteredArrayUsingBlock:(id)arg1;
- (id)firstObjectWithFormat:(id)arg1;
- (id)objectsWithFormat:(id)arg1;
- (void)setAndExecuteEnumeratorBlock:(id)arg1;
- (id)andExecuteEnumeratorBlock;
- (BOOL)doesNotContainObject:(id)arg1;
- (BOOL)doesNotContainObjects:(id)arg1;
- (BOOL)containsAll:(id)arg1;
- (BOOL)containsAny:(id)arg1;
- (double)sumFloatWithKey:(id)arg1;
- (long long)sumIntWithKey:(id)arg1;
- (id)normal:(long long)arg1;
- (id)objectAtNormalizedIndex:(long long)arg1;
- (id)randomSubarrayWithSize:(unsigned long long)arg1;
@property(readonly) NSArray *shuffeled;
@property(readonly) id randomElement;
- (id)subarrayFromIndex:(long long)arg1 toIndex:(long long)arg2;
- (id)subarrayToIndex:(long long)arg1;
- (id)subarrayFromIndex:(long long)arg1;
@property(readonly) id sixth;
@property(readonly) id fifth;
@property(readonly) id fourth;
@property(readonly) id thrid;
@property(readonly) id second;
@property(readonly) id first;
- (id)objectOrNilAtIndex:(unsigned long long)arg1;
- (id)objectAtIndex:(unsigned long long)arg1 fallback:(id)arg2;
@property(readonly) NSArray *strings;
@property(readonly) NSArray *numbers;
- (id)elementsOfClass:(Class)arg1;
- (BOOL)allKindOfClass:(Class)arg1;
- (id)filterOne:(id)arg1;
- (id)filter:(id)arg1;
- (id)arrayWithoutSet:(id)arg1;
- (id)arrayWithoutArray:(id)arg1;
- (id)arrayWithoutObjects:(id)arg1;
- (id)arrayWithoutObject:(id)arg1;
- (id)reduce:(id)arg1;
- (id)nmap:(id)arg1;
- (id)map:(id)arg1;
- (id)arrayUsingBlock:(id)arg1;
- (id)arrayWithKey:(id)arg1;
@property(readonly) NSArray *reversed;
@property(readonly) NSArray *popped;
@property(readonly) NSArray *shifted;
@property(readonly) NSSet *set;
- (id)sortedWithKey:(id)arg1 ascending:(BOOL)arg2;
- (id)arrayUsingIndexedBlock:(id)arg1;
@property(readonly) NSArray *colorValues;
- (unsigned long long)enumFromString:(id)arg1;
- (unsigned long long)enumFromString:(id)arg1 default:(unsigned long long)arg2;
- (id)stringWithEnum:(unsigned long long)arg1;
- (id)arrayWithEach;
- (void)saveToPlistAtPath:(id)arg1;

// Remaining properties
@property(readonly) NSArray *trimmedStrings; // @dynamic trimmedStrings;
@end

@interface NSArray (ListComprehensions)
+ (id)arrayWithBlock:(id)arg1 range:(void)arg2 if:(struct _NSRange)arg3;
+ (id)arrayWithBlock:(id)arg1 range:(void)arg2;
@end

@interface NSMutableArray (AG)
- (void)moveObjectAtIndex:(unsigned long long)arg1 toIndex:(unsigned long long)arg2 withBlock:(id)arg3;
- (void)moveObjectAtIndex:(unsigned long long)arg1 toIndex:(unsigned long long)arg2;
- (id)shuffle;
- (id)az_reverse;
- (id)sort;
- (void)push:(id)arg1;
- (id)pop;
- (id)shift;
- (void)removeFirstObject;
@property(retain) id first;
- (void)lastToFirst;
- (void)firstToLast;
@property(retain) id last;
- (void)addRect:(struct CGRect)arg1;
- (void)addPoint:(struct CGPoint)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSString (AtoZ)
+ (id)stringWithCGFloat:(double)arg1 maxDigits:(unsigned long long)arg2;
+ (id)stringWithData:(id)arg1 encoding:(unsigned long long)arg2;
+ (id)colorFromData:(id)arg1;
+ (id)randomSentences:(long long)arg1;
+ (id)randomWords:(long long)arg1;
+ (id)randomAppPath;
+ (id)newUniqueIdentifier;
+ (double)pointSizeForFrame:(struct CGRect)arg1 withFont:(id)arg2 forString:(id)arg3;
- (id)truncatedForRect:(struct CGRect)arg1 withFont:(id)arg2;
- (double)widthWithFont:(id)arg1;
- (id)attributedParagraphWithSpacing:(float)arg1;
- (id)attributedWithSize:(unsigned long long)arg1 andColor:(id)arg2;
@property(readonly) NSString *lcfirst;
@property(readonly) NSString *ucfirst;
@property(readonly) NSURL *fileURL;
@property(readonly) NSURL *url;
@property(readonly) unsigned long long secondsValue;
@property(readonly) unsigned long long minutesValue;
@property(readonly) struct CGPoint pointValue;
@property(readonly) NSArray *decapitate;
- (BOOL)splitAt:(id)arg1 head:(id *)arg2 tail:(id *)arg3;
- (id)splitAt:(id)arg1;
- (id)substringAfter:(id)arg1;
- (id)substringBefore:(id)arg1;
@property(readonly) NSArray *splitByComma;
@property(readonly) NSArray *decolonize;
- (id)trimmedComponentsSeparatedByString:(id)arg1;
@property(readonly) NSSet *wordSet;
@property(readonly) NSArray *words;
@property(readonly) NSArray *lines;
- (struct _NSRange)rangeOfAny:(id)arg1;
- (long long)lastIndexOf:(id)arg1;
- (long long)indexOf:(id)arg1 afterIndex:(long long)arg2;
- (long long)indexOf:(id)arg1;
- (id)substringBetweenPrefix:(id)arg1 andSuffix:(id)arg2;
- (BOOL)hasPrefix:(id)arg1 andSuffix:(id)arg2;
- (BOOL)endsWith:(id)arg1;
- (BOOL)startsWith:(id)arg1;
- (BOOL)containsAllOf:(id)arg1;
- (BOOL)containsAnyOf:(id)arg1;
- (BOOL)contains:(id)arg1;
@property(readonly) unsigned long long indentationLevel;
- (unsigned long long)count:(id)arg1;
- (unsigned long long)count:(id)arg1 options:(unsigned long long)arg2;
@property(readonly) NSString *reversed;
@property(readonly) BOOL isEmpty;
@property(readonly) NSString *underscored;
@property(readonly) NSString *hyphonized;
@property(readonly) NSString *camelized;
@property(readonly) NSString *chopped;
@property(readonly) NSString *popped;
@property(readonly) NSString *shifted;
@property(readonly) NSString *trim;
- (void)drawInRect:(struct CGRect)arg1 withFont:(id)arg2 andColor:(id)arg3;
- (void)drawCenteredInFrame:(struct CGRect)arg1 withFont:(id)arg2;
- (void)drawCenteredInRect:(struct CGRect)arg1 withFont:(id)arg2;
- (id)colorData;
- (id)firstLetter;
- (id)urlDecoded;
- (id)urlEncoded;
- (id)stringByReplacingAllOccurancesOfString:(id)arg1 withString:(id)arg2;
- (double)pointSizeForFrame:(struct CGRect)arg1 withFont:(id)arg2;
- (void)copyFileAtPathTo:(id)arg1;
@end

@interface NSMutableString (AtoZ)
- (id)replaceAll:(id)arg1 withString:(id)arg2;
- (id)constantize;
- (id)underscorize;
- (id)hyphonize;
- (id)camelize;
- (BOOL)removePrefix:(id)arg1 andSuffix:(id)arg2;
- (BOOL)removeSuffix:(id)arg1;
- (BOOL)removePrefix:(id)arg1;
- (id)pop;
- (id)shift;
@end

@interface NSString (RuntimeReporting)
- (void)setValue:(id)arg1 forUndefinedKey:(id)arg2;
- (id)valueForUndefinedKey:(id)arg1;
- (void)setSubclassNames:(id)arg1;
- (id)protocolNames;
- (id)propertyNames;
- (id)ivarNames;
- (id)methodNames;
- (id)subclassNames;
- (int)numberOfSubclasses;
- (BOOL)hasSubclasses;
- (BOOL)hasNoSubclasses;
@end

@interface NSAttributedString (Geometrics)
- (float)widthForHeight:(float)arg1;
- (float)heightForWidth:(float)arg1;
- (struct CGSize)sizeForWidth:(float)arg1 height:(float)arg2;
@end

@interface NSString (Geometrics)
- (float)widthForHeight:(float)arg1 font:(id)arg2;
- (float)heightForWidth:(float)arg1 font:(id)arg2;
- (struct CGSize)sizeForWidth:(float)arg1 height:(float)arg2 font:(id)arg3;
- (float)widthForHeight:(float)arg1 attributes:(id)arg2;
- (float)heightForWidth:(float)arg1 attributes:(id)arg2;
- (struct CGSize)sizeForWidth:(float)arg1 height:(float)arg2 attributes:(id)arg3;
- (struct CGSize)sizeInSize:(struct CGSize)arg1 font:(id)arg2;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSColor (AtoZ)
+ (id)colorFromHexString:(id)arg1;
+ (id)colorFromString:(id)arg1;
+ (id)colorWithName:(id)arg1;
+ (id)crayonColorNamed:(id)arg1;
+ (id)randomPalette;
+ (id)systemColors;
+ (id)allSystemColors;
+ (id)allColors;
+ (id)systemColorNames;
+ (id)allSystemColorNames;
+ (id)fengshui;
+ (id)colorsInFrameworkListNamed:(id)arg1;
+ (id)colorListsInFramework;
+ (id)colorLists;
+ (id)colorWithHex:(id)arg1;
+ (id)colorWithRGB:(unsigned long long)arg1;
+ (id)colorWithCalibratedRGB:(unsigned long long)arg1;
+ (id)colorWithDeviceRGB:(unsigned long long)arg1;
+ (id)colorFromHexRGB:(id)arg1;
+ (id)randomColor;
+ (id)randomOpaqueColor;
+ (id)MAUVE;
+ (id)boringColors;
+ (id)colorNamed:(id)arg1;
+ (id)colorNames;
+ (id)checkerboardWithFirstColor:(id)arg1 secondColor:(id)arg2 squareWidth:(double)arg3;
+ (id)linenTintedWithColor:(id)arg1;
+ (id)linen;
@property(readonly) BOOL isYellowish;
@property(readonly) BOOL isGreenish;
@property(readonly) BOOL isRedish;
@property(readonly) BOOL isBlueish;
@property(readonly) double hsbWeight;
@property(readonly) double rgbWeight;
- (id)hsbDistanceToColor:(id)arg1;
- (id)rgbDistanceToColor:(id)arg1;
@property(readonly) NSColor *watermark;
@property(readonly) NSColor *translucent;
@property(readonly) NSColor *moreOpaque;
@property(readonly) NSColor *lessOpaque;
@property(readonly) NSColor *opaque;
@property(readonly) NSColor *rgbComplement;
@property(readonly) NSColor *complement;
@property(readonly) NSColor *contrastingForegroundColor;
@property(readonly) NSColor *blackened;
@property(readonly) NSColor *whitened;
- (id)blend:(id)arg1;
@property(readonly) NSColor *blueshift;
@property(readonly) NSColor *redshift;
@property(readonly) NSColor *dark;
@property(readonly) BOOL isDark;
@property(readonly) NSColor *muchDarker;
@property(readonly) NSColor *darker;
@property(readonly) NSColor *brighter;
@property(readonly) NSColor *bright;
@property(readonly) BOOL isBright;
@property(readonly) double relativeBrightness;
@property(readonly) double luminance;
- (id)nameOfColor;
- (id)closestNamedColor;
- (id)toHex;
@property(readonly) NSColor *calibratedRGBColor;
@property(readonly) NSColor *deviceRGBColor;
- (id)closestWebColor;
- (id)closestColorListColor;
- (id)pantoneName;
- (id)crayonName;
- (struct CGColor *)cgColor;
- (BOOL)isExciting;
- (BOOL)isBoring;
- (id)inverted;
@end

@interface NSCoder (AGCoder)
+ (void)encodeColor:(struct CGColor *)arg1 withCoder:(id)arg2 withKey:(id)arg3;
@end

@interface NSColor (AIColorAdditions_Comparison)
- (BOOL)equalToRGBColor:(id)arg1;
@end

@interface NSColor (AIColorAdditions_DarknessAndContrast)
- (id)contrastingColor;
- (id)colorWithInvertedLuminance;
- (id)darkenAndAdjustSaturationBy:(double)arg1;
- (id)darkenBy:(double)arg1;
- (BOOL)colorIsMedium;
- (BOOL)colorIsDark;
@end

@interface NSColor (AIColorAdditions_HLS)
- (id)adjustHue:(double)arg1 saturation:(double)arg2 brightness:(double)arg3;
@end

@interface NSColor (AIColorAdditions_RepresentingColors)
- (id)stringRepresentation;
- (id)hexString;
@end

@interface NSString (AIColorAdditions_RepresentingColors)
- (id)representedColorWithAlpha:(double)arg1;
- (id)representedColor;
@end

@interface NSColor (AIColorAdditions_RandomColor)
+ (id)randomColorWithAlpha;
+ (id)randomColor;
@end

@interface NSColor (AIColorAdditions_ObjectColor)
+ (id)representedColorForObject:(id)arg1 withValidColors:(id)arg2;
@end

@interface NSColor (NSColor_ColorspaceEquality)
- (BOOL)isEqualToColor:(id)arg1 colorSpace:(id)arg2;
@end

@interface NSColor (NSColor_CSSRGB)
+ (id)colorWithCSSRGB:(id)arg1;
@end

@interface NSColor (Utilities)
+ (float *)xyzToLab:(float *)arg1;
+ (float *)rgbToXYZ:(float *)arg1;
+ (float *)rgbToLab:(float *)arg1;
+ (id)calveticaPalette;
- (float *)colorToLab;
- (id)closestColorInPalette:(id)arg1;
- (id)closestColorInCalveticaPalette;
@end

@interface NSColorList (AtoZ)
+ (id)colorListInFrameworkWithFileName:(id)arg1;
+ (id)colorListWithFileName:(id)arg1 inBundleForClass:(Class)arg2;
+ (id)colorListWithFileName:(id)arg1 inBundle:(id)arg2;
- (id)randomColor;
@end

@interface NSString (THColorConversion)
+ (id)colorFromData:(id)arg1;
- (id)colorData;
- (id)colorValue;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSView (ObjectRep)
- (id)viewWithObjectRep:(id)arg1;
- (id)captureFrame;
@property(retain, nonatomic) id objectRep; // @dynamic objectRep;
@end

@interface NSView (AtoZ)
+ (void)runEndBlock:(id)arg1;
+ (void)animateWithDuration:(double)arg1 animation:(id)arg2 completion:(void)arg3;
+ (void)animateWithDuration:(double)arg1 animation:(id)arg2;
+ (void)setDefaultAnimationCurve:(unsigned long long)arg1;
+ (void)setDefaultBlockingMode:(unsigned long long)arg1;
+ (void)setDefaultDuration:(double)arg1;
- (void)handleMouseEvent:(unsigned long long)arg1 withBlock:(id)arg2;
- (struct CGPoint)localPoint;
- (id)snapshotFromRect:(struct CGRect)arg1;
- (id)snapshot;
- (void)fadeToFrame:(struct CGRect)arg1;
- (void)animateToFrame:(struct CGRect)arg1;
- (void)fadeIn;
- (void)fadeOut;
- (void)fadeWithEffect:(id)arg1;
- (void)playAnimationWithParameters:(id)arg1;
- (id)animationArrayForParameters:(id)arg1;
- (void)resizeFrameBy:(int)arg1;
- (void)stopAnimating;
- (void)animate:(int)arg1;
- (BOOL)requestFocus;
- (id)trackAreaWithRect:(struct CGRect)arg1 userInfo:(id)arg2;
- (id)trackAreaWithRect:(struct CGRect)arg1;
- (id)trackFullView;
- (void)removeAllSubviews;
- (void)setLastSubview:(id)arg1;
- (id)lastSubview;
- (id)firstSubview;
- (id)setupHostView;
- (struct CGPoint)center;
- (id)animationIdentifer;
- (void)setAnimationIdentifer:(id)arg1;
- (id)allSubviews;
- (void)slideUp;
- (void)slideDown;
- (void)centerOriginInRect:(struct CGRect)arg1;
- (void)centerOriginInFrame;
- (void)centerOriginInBounds;
- (struct CGRect)centerRect:(struct CGRect)arg1 onPoint:(struct CGPoint)arg2;
@end

@interface NSView (Layout)
- (void)sizeHeightToFit;
- (long long)compareLeftEdges:(id)arg1;
- (void)sizeHeightToFitAllowShrinking:(BOOL)arg1;
- (void)deltaH:(float)arg1;
- (void)deltaW:(float)arg1;
- (void)deltaY:(float)arg1;
- (void)deltaX:(float)arg1;
- (void)deltaY:(float)arg1 deltaH:(float)arg2;
- (void)deltaX:(float)arg1 deltaW:(float)arg2;
- (void)setSize:(struct CGSize)arg1;
@property(nonatomic) float height;
@property(nonatomic) float width;
@property(nonatomic) float centerY;
@property(nonatomic) float top;
@property(nonatomic) float bottom;
@property(nonatomic) float centerX;
@property(nonatomic) float rightEdge;
@property(nonatomic) float leftEdge;
@end

@interface NSView (findSubview)
- (id)firstSubviewOfKind:(Class)arg1;
- (id)firstSubviewOfKind:(Class)arg1 withTag:(long long)arg2;
- (id)subviewsOfKind:(Class)arg1;
- (id)subviewsOfKind:(Class)arg1 withTag:(long long)arg2;
- (id)findSubviewsOfKind:(Class)arg1 withTag:(long long)arg2 inView:(id)arg3;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSObject (AutoCoding) <NSCoding>
+ (id)objectWithContentsOfFile:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (void)setWithCoder:(id)arg1;
- (void)setNilValueForKey:(id)arg1;
- (id)uncodableKeys;
- (id)codableKeys;
- (void)writeToFile:(id)arg1 atomically:(BOOL)arg2;
@end

@interface NSObject (HRCoding)
- (id)archivedObjectWithHRCoder:(id)arg1;
- (id)unarchiveObjectWithHRCoder:(id)arg1;
@end

@interface NSDictionary (HRCoding)
- (id)archivedObjectWithHRCoder:(id)arg1;
- (id)unarchiveObjectWithHRCoder:(id)arg1;
@end

@interface NSArray (HRCoding)
- (id)archivedObjectWithHRCoder:(id)arg1;
- (id)unarchiveObjectWithHRCoder:(id)arg1;
@end

@interface NSString (HRCoding)
- (id)archivedObjectWithHRCoder:(id)arg1;
@end

@interface NSData (HRCoding)
- (id)archivedObjectWithHRCoder:(id)arg1;
@end

@interface NSNumber (HRCoding)
- (id)archivedObjectWithHRCoder:(id)arg1;
@end

@interface NSDate (HRCoding)
- (id)archivedObjectWithHRCoder:(id)arg1;
@end

@interface NSObject (AtoZ)
- (id)autoDescribe;
- (id)autoDescribeWithClassType:(Class)arg1;
- (int)windowPosition;
- (void)setWindowPosition:(int)arg1;
- (id)getDictionary;
@end

@interface NSObject (SubclassEnumeration)
+ (id)subclasses;
@end

@interface NSObject (AG)
+ (id)customClassWithProperties:(id)arg1;
+ (id)classMethods;
+ (id)classPropsFor:(Class)arg1;
- (id)initWithProperties:(id)arg1;
- (void)setClass:(Class)arg1;
- (id)allKeys;
- (id)dictionaryWithValuesForKeys;
- (void)didChangeValueForKeys:(id)arg1;
- (void)willChangeValueForKeys:(id)arg1;
- (void)removeObserver:(id)arg1 forKeyPaths:(id)arg2;
- (void)addObserver:(id)arg1 forKeyPaths:(id)arg2;
- (void)addObserver:(id)arg1 forKeyPath:(id)arg2;
- (void)performSelector:(SEL)arg1 afterDelay:(double)arg2;
- (void)performSelectorWithoutWarnings:(SEL)arg1 withObject:(id)arg2;
- (void)stopObserving:(id)arg1 forName:(id)arg2;
- (void)observeName:(id)arg1 calling:(SEL)arg2;
- (void)observeObject:(id)arg1 forName:(id)arg2 calling:(SEL)arg3;
- (id)observeName:(id)arg1 usingBlock:(id)arg2;
- (void)fire:(id)arg1 userInfo:(id)arg2;
- (void)fire:(id)arg1;
- (BOOL)isEqualToAnyOf:(id)arg1;
- (void)setFloatValue:(double)arg1 forKeyPath:(id)arg2;
- (void)setFloatValue:(double)arg1 forKey:(id)arg2;
- (void)setIntValue:(long long)arg1 forKeyPath:(id)arg2;
- (void)setIntValue:(long long)arg1 forKey:(id)arg2;
- (id)stringFromClass;
- (id)propertiesPlease;
- (id)propertiesSans:(id)arg1;
- (void)performActionFromSegment:(id)arg1;
- (void)showMethodsInFrameWork:(id)arg1;
@end

@interface NSObject (PrimitiveEvocation)
- (void *)performSelector:(SEL)arg1 withValue:(void *)arg2;
@end

@interface NSDictionary (PropertyMap)
- (void)mapPropertiesToObject:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSAffineTransform (UKShearing)
- (void)shearXBy:(double)arg1 yBy:(double)arg2;
@end

@interface NSBezierPath (AtoZ)
+ (id)bezierPathWithCappedBoxInRect:(struct CGRect)arg1;
+ (id)bezierPathWithCGPath:(struct CGPath *)arg1;
+ (id)bezierPathWithRoundedRect:(struct CGRect)arg1 cornerRadius:(double)arg2;
+ (id)bezierPathWithRoundedRect:(struct CGRect)arg1 cornerRadius:(double)arg2 inCorners:(int)arg3;
+ (id)bezierPathWithRightRoundedRect:(struct CGRect)arg1 radius:(double)arg2;
+ (id)bezierPathWithLeftRoundedRect:(struct CGRect)arg1 radius:(double)arg2;
+ (id)bezierPathWithTriangleInRect:(struct CGRect)arg1 orientation:(int)arg2;
+ (id)bezierPathWithPlateInRect:(struct CGRect)arg1;
- (void)strokeInsideWithinRect:(struct CGRect)arg1;
- (void)strokeInside;
- (void)drawBlurWithColor:(id)arg1 radius:(double)arg2;
- (void)fillWithInnerShadow:(id)arg1;
- (id)pathWithStrokeWidth:(double)arg1;
- (struct CGPath *)cgPath;
- (struct CGPath *)quartzPath;
- (struct CGRect)nonEmptyBounds;
- (struct CGPoint)associatedPointForElementAtIndex:(unsigned long long)arg1;
- (void)setDashPattern:(id)arg1;
- (id)dashPattern;
- (void)fillGradientFrom:(id)arg1 to:(id)arg2 angle:(float)arg3;
- (void)appendBezierPathWithTriangleInRect:(struct CGRect)arg1 orientation:(int)arg2;
- (void)appendBezierPathWithRoundedRect:(struct CGRect)arg1 cornerRadius:(float)arg2;
- (void)appendBezierPathWithPlateInRect:(struct CGRect)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSWindow (NoodleEffects)
- (void)zoomOffToRect:(struct CGRect)arg1;
- (void)zoomOnFromRect:(struct CGRect)arg1;
- (id)_createZoomWindowWithRect:(struct CGRect)arg1;
- (void)animateToFrame:(struct CGRect)arg1 duration:(double)arg2;
@end

@interface NSWindow (AtoZ)
+ (id)borderlessWindowWithContentRect:(struct CGRect)arg1;
+ (id)allWindows;
@property(readonly, nonatomic) double toolbarHeight;
- (void)betterCenter;
- (void)setContentSize:(struct CGSize)arg1 display:(BOOL)arg2 animate:(BOOL)arg3;
- (double)heightOfTitleBar;
- (void)addViewToTitleBar:(id)arg1 atXPosition:(double)arg2;
- (void)setMidpoint:(struct CGPoint)arg1;
- (struct CGPoint)midpoint;
- (void)veil:(id)arg1;
- (id)veilLayerForView:(id)arg1;
- (id)veilLayer;
@end

@interface NSWindow (Utilities)
+ (BOOL)windowRectIsOnScreen:(struct CGRect)arg1;
+ (id)miniaturizedWindows;
+ (id)visibleWindows:(BOOL)arg1 delegateClass:(Class)arg2;
+ (id)visibleWindows:(BOOL)arg1;
+ (BOOL)isAnyWindowVisible;
+ (BOOL)isAnyWindowVisibleWithDelegateClass:(Class)arg1;
+ (void)cascadeWindow:(id)arg1;
- (void)extendVerticallyBy:(int)arg1;
- (void)animationDidEnd:(id)arg1;
- (void)slideUp;
- (void)slideDown;
- (void)slideTo:(id)arg1;
- (void)fadeOut;
- (void)fadeIn;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (struct CGRect)resizeWindowToContentSize:(struct CGSize)arg1 display:(BOOL)arg2;
- (struct CGRect)windowFrameForContentSize:(struct CGSize)arg1;
- (struct CGRect)setContentViewAndResizeWindow:(id)arg1 display:(BOOL)arg2;
- (void)flushActiveTextFields;
- (BOOL)keyWindowIsMenu;
- (BOOL)dimControlsKey;
- (BOOL)dimControls;
- (void)setDefaultFirstResponder;
- (id)parentWindowIfDrawerWindow;
- (BOOL)isBorderless;
- (BOOL)isMetallic;
- (BOOL)isFloating;
- (void)setFloating:(BOOL)arg1;
- (id)topWindowWithDelegateClass:(Class)arg1;
@end

@interface NSWindow (UKFade)
- (void)fadeToLevel:(int)arg1 withDuration:(double)arg2;
- (void)fadeOutOneStep:(id)arg1;
- (void)fadeOutWithDuration:(double)arg1;
- (void)fadeInOneStep:(id)arg1;
- (void)fadeInWithDuration:(double)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSShadow (AtoZ)
+ (void)clearShadow;
+ (void)setShadowWithOffset:(struct CGSize)arg1 blurRadius:(double)arg2 color:(id)arg3;
- (id)initWithColor:(id)arg1 offset:(struct CGSize)arg2 blurRadius:(double)arg3;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSNumber (AtoZ)
+ (id)two;
+ (id)one;
+ (id)zero;
- (id)to:(id)arg1 by:(id)arg2;
- (id)to:(id)arg1;
- (id)times:(id)arg1;
- (id)increment;
- (id)transpose;
- (id)negate;
- (id)abs;
- (id)prettyBytes;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface CIFilter (Subscript)
- (void)setObject:(id)arg1 forKeyedSubscript:(id)arg2;
- (id)objectForKeyedSubscript:(id)arg1;
@end

@interface CIFilter (WithDefaults)
+ (id)filterWithDefaultsNamed:(id)arg1;
@end

@interface NSImage (AtoZ)
+ (id)resizedImage:(id)arg1 newSize:(struct CGSize)arg2 lockAspectRatio:(BOOL)arg3 lockAspectRatioByWidth:(BOOL)arg4;
+ (id)imageWithPreviewOfFileAtPath:(id)arg1 ofSize:(struct CGSize)arg2 asIcon:(BOOL)arg3;
+ (id)imageFromCGImageRef:(struct CGImage *)arg1;
+ (id)systemImages;
+ (id)prettyGradientImage;
+ (id)swatchWithGradientColor:(id)arg1 size:(struct CGSize)arg2;
+ (id)swatchWithColor:(id)arg1 size:(struct CGSize)arg2;
+ (id)az_imageNamed:(id)arg1;
+ (id)az_imageNamed:(id)arg1;
+ (id)imageWithFileName:(id)arg1 inBundleForClass:(Class)arg2;
+ (id)imageWithFileName:(id)arg1 inBundle:(id)arg2;
+ (id)createImageFromSubView:(id)arg1 rect:(struct CGRect)arg2;
+ (id)createImageFromView:(id)arg1;
+ (id)reflectedImage:(id)arg1 amountReflected:(float)arg2;
+ (void)drawInQuadrants:(id)arg1 inRect:(struct CGRect)arg2;
+ (id)randomImages:(unsigned long long)arg1;
- (id)scaleToFillSize:(struct CGSize)arg1;
- (BOOL)saveAs:(id)arg1;
- (BOOL)saveImage:(id)arg1 fileName:(id)arg2 fileType:(unsigned long long)arg3;
- (id)croppedImage:(struct CGRect)arg1;
- (struct CGImage *)cgImageRef;
- (id)maskedWithColor:(id)arg1;
- (void)drawEtchedInRect:(struct CGRect)arg1;
- (id)addReflection:(double)arg1;
- (id)imageByRemovingTransparentAreasWithFinalRect:(struct CGRect *)arg1;
- (id)toCIImage;
- (struct CGRect)proportionalRectForTargetRect:(struct CGRect)arg1;
- (id)rotated:(int)arg1;
- (struct CGSize)sizeLargestRepresentation;
- (id)largestRepresentation;
- (struct CGSize)sizeSmallestRepresentation;
- (id)smallestRepresentation;
- (id)imageScaledToFitSize:(struct CGSize)arg1;
- (id)scaledToMax:(double)arg1;
- (id)imageCroppedToFitSize:(struct CGSize)arg1;
- (id)imageToFitSize:(struct CGSize)arg1 method:(int)arg2;
- (void)drawInRect:(struct CGRect)arg1 operation:(unsigned long long)arg2 fraction:(float)arg3 method:(int)arg4;
- (id)imageByScalingProportionallyToSize:(struct CGSize)arg1 background:(id)arg2;
- (id)imageRotatedByDegrees:(double)arg1;
- (struct CGImage *)cgImage;
- (id)bitmap;
- (id)filteredMonochromeEdge;
- (id)tintedWithColor:(id)arg1;
- (id)tintedImage;
- (void)drawCenteredinRect:(struct CGRect)arg1 operation:(unsigned long long)arg2 fraction:(float)arg3;
- (void)drawFloatingRightInFrame:(struct CGRect)arg1;
- (id)quantize;
- (id)resizeWhenScaledImage;
- (id)coloredWithColor:(id)arg1 composite:(unsigned long long)arg2;
- (id)coloredWithColor:(id)arg1;
- (id)scaleImageToFillSize:(struct CGSize)arg1;
- (id)maskWithColor:(id)arg1;
- (id)imageByConvertingToBlackAndWhite;
- (id)imageByFillingVisibleAlphaWithColor:(id)arg1;
- (id)imageByScalingProportionallyToSize:(struct CGSize)arg1 flipped:(BOOL)arg2 addFrame:(BOOL)arg3 addShadow:(BOOL)arg4 addSheen:(BOOL)arg5;
- (id)imageByScalingProportionallyToSize:(struct CGSize)arg1 flipped:(BOOL)arg2 addFrame:(BOOL)arg3 addShadow:(BOOL)arg4;
- (id)imageByScalingProportionallyToSize:(struct CGSize)arg1 flipped:(BOOL)arg2;
- (id)imageByScalingProportionallyToSize:(struct CGSize)arg1;
- (struct CGSize)proportionalSizeForTargetSize:(struct CGSize)arg1;
@end

@interface CIImage (ToNSImage)
- (id)rotateDegrees:(float)arg1;
- (id)toNSImage;
- (id)toNSImageFromRect:(struct CGRect)arg1;
@end

@interface NSImage (CGImageConversion)
- (struct CGImage *)cgImage;
- (id)bitmap;
@end

@interface NSImage (AtoZScaling)
- (BOOL)shrinkToSize:(struct CGSize)arg1;
- (id)duplicateOfSize:(struct CGSize)arg1;
- (void)removeRepresentationsLargerThanSize:(struct CGSize)arg1;
- (BOOL)createRepresentationOfSize:(struct CGSize)arg1;
- (BOOL)createIconRepresentations;
- (id)representationOfSize:(struct CGSize)arg1;
- (id)bestRepresentationForSize:(struct CGSize)arg1;
- (struct CGSize)adjustSizeToDrawAtSize:(struct CGSize)arg1;
- (id)imageByAdjustingHue:(float)arg1 saturation:(float)arg2;
- (id)imageByAdjustingHue:(float)arg1;
@end

@interface NSImage (AtoZTrim)
- (id)scaleImageToSize:(struct CGSize)arg1 trim:(BOOL)arg2 expand:(BOOL)arg3 scaleUp:(BOOL)arg4;
- (struct CGRect)usedRect;
@end

@interface NSImage (AtoZAverage)
+ (id)maskImage:(id)arg1 withMask:(id)arg2;
- (id)averageColor;
@end

@interface NSImage (Icons)
+ (id)picolStrings;
+ (id)icons;
+ (id)iconsColoredWithColor:(id)arg1;
+ (id)randomIcon;
+ (id)systemIcons;
+ (id)frameworkImages;
+ (id)screeShot;
@end

@interface NSImage (GrabWindow)
+ (id)imageBelowWindow:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface CATransaction (AtoZ)
+ (void)az_performWithDisabledActions:(id)arg1;
@end

@interface CAAnimation (AtoZ)
+ (id)dockBounceAnimationWithIconHeight:(double)arg1;
+ (id)jumpAnimation;
+ (id)shakeAnimation:(struct CGRect)arg1;
+ (id)flipDown:(double)arg1 scaleFactor:(double)arg2;
+ (id)flipAnimationWithDuration:(double)arg1 forLayerBeginningOnTop:(BOOL)arg2 scaleFactor:(double)arg3;
+ (id)popInAnimation;
+ (id)rotateAnimationForLayer:(id)arg1 start:(double)arg2 end:(double)arg3;
+ (id)colorAnimationForLayer:(id)arg1 withStartingColor:(id)arg2 endColor:(id)arg3;
+ (id)shakeAnimation;
+ (id)animationForRotation;
+ (id)animateionForScale;
+ (id)animationForOpacity;
+ (id)animationOnPath:(struct CGPath *)arg1 duration:(double)arg2 timeOffset:(double)arg3;
+ (id)shrinkAnimationAtPoint:(struct CGPoint)arg1;
+ (id)blowupAnimationAtPoint:(struct CGPoint)arg1;
+ (id)rotateAnimation;
- (void)shakeBabyShake:(id)arg1;
- (id)negativeShake:(struct CGRect)arg1;
- (void)animationDidStop:(id)arg1 finished:(BOOL)arg2;
@property(copy, nonatomic) id az_completionBlock;
@end

@interface NSView (CAAnimationEGOHelper)
- (void)popInAnimated;
@end

@interface CALayer (CAAnimationEGOHelper)
- (void)popInAnimated;
@end

@interface CAAnimation (BlocksAddition)
- (id)start;
- (void)setStart:(id)arg1;
- (id)completion;
- (void)setCompletion:(id)arg1;
- (BOOL)delegateCheck;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface CALayer (AtoZ)
+ (id)greyGradient;
+ (id)closeBoxLayerForLayer:(id)arg1;
+ (id)closeBoxLayer;
+ (id)veilForView:(id)arg1;
+ (id)withName:(id)arg1 inFrame:(struct CGRect)arg2 colored:(id)arg3 withBorder:(double)arg4 colored:(id)arg5;
- (void)addSublayers:(id)arg1;
- (id)debugLayerTree;
- (void)debugAppendToLayerTree:(id)arg1 indention:(id)arg2;
- (id)debugDescription;
- (id)_flipAnimationWithDuration:(double)arg1 isFront:(BOOL)arg2;
- (void)flipLayer:(id)arg1 withLayer:(id)arg2;
- (void)addConstraints:(id)arg1;
- (void)addConstraintsSuperSize;
- (void)_ensureSuperHasLayoutManager;
- (void)addConstraintsSuperSizeScaled:(double)arg1;
- (struct CATransform3D)rectToQuad:(struct CGRect)arg1 quadTLX:(double)arg2 quadTLY:(double)arg3 quadTRX:(double)arg4 quadTRY:(double)arg5 quadBLX:(double)arg6 quadBLY:(double)arg7 quadBRX:(double)arg8 quadBRY:(double)arg9;
- (id)magnifier:(id)arg1;
- (id)setLabelString:(id)arg1;
- (id)sublayerWithName:(id)arg1;
- (id)labelLayer;
- (BOOL)containsOpaquePoint:(struct CGPoint)arg1;
- (struct CATransform3D)makeTransformForAngle:(double)arg1 from:(struct CATransform3D)arg2;
- (struct CATransform3D)makeTransformForAngleX:(double)arg1;
- (void)fadeOut;
- (void)fadeIn;
- (void)addAnimations:(id)arg1 forKeys:(id)arg2;
- (void)pulse;
- (void)setScale:(double)arg1;
- (void)flipForward:(BOOL)arg1 atPosition:(int)arg2;
- (struct CATransform3D)flipAnimationPositioned:(int)arg1;
- (void)flipBack;
- (void)flipOver;
- (void)flipDown;
- (void)toggleFlip;
- (void)flipForwardAtEdge:(int)arg1;
- (void)flipBackAtEdge:(int)arg1;
- (void)setAnchorPoint:(struct CGPoint)arg1 inRect:(struct CGRect)arg2;
- (void)setAnchorPointRelative:(struct CGPoint)arg1;
- (void)setAnchorPoint:(struct CGPoint)arg1 inView:(id)arg2;
- (void)orientWithX:(double)arg1 andY:(double)arg2;
- (void)orientWithPoint:(struct CGPoint)arg1;
- (void)rotateBy90;
- (void)rotateBy45;
- (void)animateCameraToPosition:(struct CGPoint)arg1;
- (void)setHostingLayerAnchorPoint:(struct CGPoint)arg1;
- (void)rotateAroundYAxis:(double)arg1;
- (void)setObject:(id)arg1 forKeyedSubscript:(id)arg2;
- (id)objectForKeyedSubscript:(id)arg1;
- (id)hitTest:(struct CGPoint)arg1 inView:(id)arg2 forClass:(Class)arg3;
- (struct CATransform3D)makeTransformForAngle:(double)arg1;
- (id)lassoLayerForLayer:(id)arg1;
- (id)selectionLayerForLayer:(id)arg1;
- (void)addPerspectiveForVerticalOffset:(double)arg1;
- (id)hitTestEvent:(id)arg1 inView:(id)arg2;
@end

@interface CATextLayer (AtoZ)
- (void)setupAttributedTextLayerWithFont:(struct __CTFont *)arg1;
- (struct CGSize)suggestSizeAndFitRange:(CDStruct_912cb5d2 *)arg1 forAttributedString:(id)arg2 usingSize:(struct CGSize)arg3;
- (struct __CTFont *)newCustomFontWithName:(id)arg1 ofType:(id)arg2 attributes:(id)arg3;
- (struct __CTFont *)newFontWithAttributes:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSNotificationCenter (MainThread)
- (void)postNotificationOnMainThreadName:(id)arg1 object:(id)arg2 userInfo:(id)arg3;
- (void)postNotificationOnMainThreadName:(id)arg1 object:(id)arg2;
- (void)postNotificationOnMainThread:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSThread (BlocksAdditions)
+ (void)runBlock:(id)arg1;
+ (void)performBlockInBackground:(id)arg1;
- (void)performBlock:(id)arg1 afterDelay:(void)arg2;
- (void)performBlock:(id)arg1 waitUntilDone:(void)arg2;
- (void)performBlock:(id)arg1;
- (void)performBlockOnMainThread:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSObject (fullDescription)
- (id)fullDescription;
@end

@interface NSString (fullDescription)
- (id)fullDescription;
@end

@interface NSArray (fullDescription)
- (id)fullDescription;
@end

@interface NSPointerArray (fullDescription)
- (id)fullDescription;
@end

@interface NSDictionary (fullDescription)
- (id)fullDescription;
@end

@interface NSSet (fullDescription)
- (id)fullDescription;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSScreen (PointConversion)
+ (struct CGPoint)convertAndFlipEventPoint:(id)arg1 relativeToView:(id)arg2;
+ (struct CGPoint)convertAndFlipMousePointInView:(id)arg1;
+ (id)currentScreenForMouseLocation;
- (void)moveMouseToScreenPoint:(struct CGPoint)arg1;
- (struct CGPoint)convertToScreenFromLocalPoint:(struct CGPoint)arg1 relativeToView:(id)arg2;
- (struct CGPoint)flipPoint:(struct CGPoint)arg1;
- (struct CGPoint)convertPointToScreenCoordinates:(struct CGPoint)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSURL (AtoZ)
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSColor (AZNamedColors)
@property(readonly) NSString *webName;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSObject (MAKVONotification)
- (void)removeObserver:(id)arg1 keyPath:(id)arg2 selector:(SEL)arg3;
- (void)addObserver:(id)arg1 forKeyPath:(id)arg2 selector:(SEL)arg3 userInfo:(id)arg4 options:(unsigned long long)arg5;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSColor (AZCSSColors)
@property(readonly) NSString *webName;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSWindow (Animations)
+ (void)flipDown:(id)arg1;
- (void)shake;
- (void)anmateOnPath:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSObject (BlocksAdditions)
- (void)my_callBlockWithObject:(id)arg1;
- (void)my_callBlock;
@end

@interface NSLock (BlocksAdditions)
- (void)whileLocked:(id)arg1;
@end

@interface NSNotificationCenter (BlocksAdditions)
- (void)addObserverForName:(id)arg1 object:(id)arg2 block:(id)arg3;
@end

@interface NSURLConnection (BlocksAdditions)
+ (void)sendAsynchronousRequest:(id)arg1 completionBlock:(id)arg2;
@end

@interface NSArray (CollectionsAdditions)
- (id)map:(id)arg1;
- (id)select:(id)arg1;
- (void)do:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSBundle (AtoZ)
+ (id)calulatedBundleIDForPath:(id)arg1;
+ (id)applicationSupportFolder;
+ (id)appSuppFolder;
+ (id)appSuppDir;
+ (id)appSuppSubPathNamed:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSFileManager (AtoZ)
+ (id)pathsForBundleDocumentsMatchingExtension:(id)arg1;
+ (id)pathsForDocumentsMatchingExtension:(id)arg1;
+ (id)pathsForItemsMatchingExtension:(id)arg1 inFolder:(id)arg2;
+ (id)filesInFolder:(id)arg1;
+ (id)pathForBundleDocumentNamed:(id)arg1;
+ (id)pathForDocumentNamed:(id)arg1;
+ (id)pathForItemNamed:(id)arg1 inFolder:(id)arg2;
- (id)arrayWithFilesMatchingPattern:(id)arg1 inDirectory:(id)arg2;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSBezierPath (AZSegmentedRect)
- (id)traverseSegments:(id)arg1 inRect:(id)arg2;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSArray (F)
+ (id)arrayFrom:(long long)arg1 To:(long long)arg2;
+ (id)from:(long long)arg1 to:(long long)arg2;
- (id)arrayFromIndexOn:(long long)arg1;
- (id)arrayUntilIndex:(long long)arg1;
- (id)reverse;
- (id)first;
- (id)group:(id)arg1;
- (id)sort:(id)arg1;
- (id)dropWhile:(id)arg1;
- (id)min:(id)arg1;
- (id)max:(id)arg1;
- (id)countValidEntries:(id)arg1;
- (BOOL)isValidForAny:(id)arg1;
- (BOOL)isValidForAll:(id)arg1;
- (id)reject:(id)arg1;
- (id)filter:(id)arg1;
- (id)reduce:(id)arg1 withInitialMemo:(void)arg2;
- (id)map:(id)arg1;
- (void)eachWithIndex:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSDictionary (F)
- (id)min:(id)arg1;
- (id)max:(id)arg1;
- (id)countValidEntries:(id)arg1;
- (BOOL)isValidForAny:(id)arg1;
- (BOOL)isValidForAll:(id)arg1;
- (id)reject:(id)arg1;
- (id)filter:(id)arg1;
- (id)reduce:(id)arg1 withInitialMemo:(void)arg2;
- (id)map:(id)arg1;
- (void)each:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSNumber (F)
- (void)times:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSValue (AZWindowPosition)
+ (id)valueWithPosition:(int)arg1;
- (int)positionValue;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSTextView (AtoZ)
+ (id)textViewForFrame:(struct CGRect)arg1 withString:(id)arg2;
- (void)incrementFontSize:(id)arg1;
- (void)decrementFontSize:(id)arg1;
- (void)changeFontSize:(double)arg1;
- (void)increaseFontSize:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSMutableDictionary (AtoZ)
- (id)colorForKey:(id)arg1;
- (void)setColor:(id)arg1 forKey:(id)arg2;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSEvent (AtoZ)
+ (void)shiftClick:(id)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSUserDefaults (Subscript)
+ (id)defaults;
- (void)setObject:(id)arg1 forKeyedSubscription:(id)arg2;
- (id)objectForKeyedSubscript:(id)arg1;
@end

@interface NSUserDefaults (Convenience_Private)
+ (BOOL)isiCloudEnabled;
+ (id)randomKey;
@end

@interface NSUserDefaults (Convenience) <NSFastEnumeration>
- (void)stopSyncingWithiCloud;
- (void)startSyncingWithiCloud;
- (id)storeBool:(BOOL)arg1;
- (id)storeFloat:(double)arg1;
- (id)storeInteger:(long long)arg1;
- (id)storeObject:(id)arg1;
- (void)resetValuesForKeys:(id)arg1;
- (void)resetAllValues;
- (void)removeValuesForKeys:(id)arg1;
- (void)removeAllValues;
- (void)saveBool:(BOOL)arg1 forKey:(id)arg2;
- (void)saveFloat:(double)arg1 forKey:(id)arg2;
- (void)saveInteger:(long long)arg1 forKey:(id)arg2;
- (void)saveObject:(id)arg1 forKey:(id)arg2;
- (BOOL)hasValueForKey:(id)arg1;
- (BOOL)boolForKey:(id)arg1 or:(BOOL)arg2;
- (double)floatForKey:(id)arg1 or:(double)arg2;
- (long long)integerForKey:(id)arg1 or:(long long)arg2;
- (id)dataForKey:(id)arg1 or:(id)arg2;
- (id)dictionaryForKey:(id)arg1 or:(id)arg2;
- (id)arrayForKey:(id)arg1 or:(id)arg2;
- (id)stringForKey:(id)arg1 or:(id)arg2;
- (id)objectForKey:(id)arg1 or:(id)arg2;
- (unsigned long long)countByEnumeratingWithState:(CDStruct_70511ce9 *)arg1 objects:(id *)arg2 count:(unsigned long long)arg3;
@end

@interface NSImage (Matrix)
- (id)addPerspectiveMatrix:(CDStruct_7660b417)arg1;
@end

@interface NSObject (Utilities)
+ (id)instanceOfClassNamed:(id)arg1;
+ (BOOL)classExists:(id)arg1;
+ (id)getProtocolListForClass;
+ (id)getIvarListForClass;
+ (id)getPropertyListForClass;
+ (id)getSelectorListForClass;
- (id)tryPerformSelector:(SEL)arg1;
- (id)tryPerformSelector:(SEL)arg1 withObject:(id)arg2;
- (id)tryPerformSelector:(SEL)arg1 withObject:(id)arg2 withObject:(id)arg3;
- (SEL)chooseSelector:(SEL)arg1;
- (const char *)returnTypeForSelector:(SEL)arg1;
- (BOOL)hasIvar:(id)arg1;
- (BOOL)hasProperty:(id)arg1;
@property(readonly) NSDictionary *protocols;
@property(readonly) NSDictionary *ivars;
@property(readonly) NSDictionary *properties;
@property(readonly) NSDictionary *selectors;
- (id)valueByPerformingSelector:(SEL)arg1;
- (id)valueByPerformingSelector:(SEL)arg1 withObject:(id)arg2;
- (id)valueByPerformingSelector:(SEL)arg1 withObject:(id)arg2 withObject:(id)arg3;
- (void)performSelector:(SEL)arg1 withDelayAndArguments:(double)arg2;
- (void)getReturnValue:(void *)arg1;
- (void)performSelector:(SEL)arg1 afterDelay:(double)arg2;
- (void)performSelector:(SEL)arg1 withFloat:(float)arg2 afterDelay:(double)arg3;
- (void)performSelector:(SEL)arg1 withInt:(int)arg2 afterDelay:(double)arg3;
- (void)performSelector:(SEL)arg1 withBool:(BOOL)arg2 afterDelay:(double)arg3;
- (void)performSelector:(SEL)arg1 withCPointer:(void *)arg2 afterDelay:(double)arg3;
- (id)objectByPerformingSelector:(SEL)arg1;
- (id)objectByPerformingSelector:(SEL)arg1 withObject:(id)arg2;
- (id)objectByPerformingSelector:(SEL)arg1 withObject:(id)arg2 withObject:(id)arg3;
- (id)objectByPerformingSelectorWithArguments:(SEL)arg1;
- (BOOL)performSelector:(SEL)arg1 withReturnValueAndArguments:(void *)arg2;
- (BOOL)performSelector:(SEL)arg1 withReturnValue:(void *)arg2 andArguments:(struct __va_list_tag [1])arg3;
- (id)invocationWithSelectorAndArguments:(SEL)arg1;
- (id)invocationWithSelector:(SEL)arg1 andArguments:(struct __va_list_tag [1])arg2;
- (id)superclasses;
@end

@interface NSObject (NSCoding)
- (void)autoDecode:(id)arg1;
- (void)autoEncodeWithCoder:(id)arg1;
- (id)properties;
- (id)propertiesForClass:(Class)arg1;
@end



```CompileC /Users/localadmin/Library/Developer/Xcode/DerivedData/build/Intermediates/AtoZ.build/Debug/AtoZ.build/Objects-normal/x86_64/azCarousel.o Views/azCarousel.m normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.compiler```
    ```cd /Volumes/2T/ServiceData/AtoZ.framework/AtoZ```
    ```setenv LANG en_US.US-ASCII```
    ```/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c```
    ```-arch x86_64 -fmessage-length=0 -std=c99 -fobjc-arc```
    ```-Wno-trigraphs -fpascal-strings -Os -Wno-missing-field-initializers```
    ```-Wno-missing-prototypes -Wno-return-type -Wno-implicit-atomic-properties```
    ```-Wno-receiver-is-weak -Wformat -Wno-missing-braces -Wparentheses```
    ```-Wswitch -Wno-unused-function -Wno-unused-label -Wno-unused-parameter```
    ```-Wno-unused-variable -Wunused-value -Wno-empty-body -Wno-uninitialized```
    ```-Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion```
    ```-Wno-shorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector```
    ```-Wno-strict-selector-match -Wno-undeclared-selector -Wno-deprecated-implementations```
    ```-DDEBUGTALKER=1 -isysroot /Applications/Xcode.app/.../MacOSX10.8.sdk```
    ```-fasm-blocks -Wprotocol -Wdeprecated-declarations -mmacosx-version-min=10.6```
    ```-g -Wno-sign-conversion "-DIBOutlet=__attribute__((iboutlet))" "-DIBOutletCollection(ClassName)=__attribute__((iboutletcollection(ClassName)))" "-DIBAction=void)__attribute__((ibaction)" -I/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Intermediates/AtoZ.build/Debug/AtoZ.build/AtoZ.hmap -I/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Intermediates/AtoZ.build/Debug/AtoZ.build/DerivedSources/x86_64 -I/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Intermediates/AtoZ.build/Debug/AtoZ.build/DerivedSources -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCoding.app -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCodingTests-NO_THROW.octest -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCodingTests.octest -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/OAuthConsumer.framework.dSYM "-F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/Transformed Image.app" -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/TwitterPlane.app -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCoding.app/Contents -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCodingTests-NO_THROW.octest/Contents -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCodingTests.octest/Contents -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/OAuthConsumer.framework.dSYM/Contents "-F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/Transformed Image.app/Contents" -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/TwitterPlane.app/Contents -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCoding.app/Contents/MacOS -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCoding.app/Contents/Resources -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCodingTests-NO_THROW.octest/Contents/MacOS -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCodingTests-NO_THROW.octest/Contents/Resources -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCodingTests.octest/Contents/MacOS -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/AutomagicCodingTests.octest/Contents/Resources -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/OAuthConsumer.framework.dSYM/Contents/Resources "-F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/Transformed Image.app/Contents/MacOS" "-F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/Transformed Image.app/Contents/Resources" -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/TwitterPlane.app/Contents/Frameworks -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/TwitterPlane.app/Contents/MacOS -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/TwitterPlane.app/Contents/Resources -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug/OAuthConsumer.framework.dSYM/Contents/Resources/DWARF -F/Users/localadmin/Library/Developer/Xcode/DerivedData/build/Products/Debug -Xclang -fobjc-runtime-has-weak -lobjc -sub_library libobjc -include /Users/localadmin/Library/Developer/Xcode/DerivedData/build/Intermediates/PrecompiledHeaders/AtoZ-Prefix-azyuvasafkyfgnfurbesiaqyitzf/AtoZ-Prefix.pch -MMD -MT dependencies -MF /Users/localadmin/Library/Developer/Xcode/DerivedData/build/Intermediates/AtoZ.build/Debug/AtoZ.build/Objects-normal/x86_64/azCarousel.d --serialize-diagnostics /Users/localadmin/Library/Developer/Xcode/DerivedData/build/Intermediates/AtoZ.build/Debug/AtoZ.build/Objects-normal/x86_64/azCarousel.dia -c /Volumes/2T/ServiceData/AtoZ.framework/AtoZ/Views/azCarousel.m -o /Users/localadmin/Library/Developer/Xcode/DerivedData/build/Intermediates/AtoZ.build/Debug/AtoZ.build/Objects-normal/x86_64/azCarousel.o
```
clang: warning: -lobjc: 'linker' input unused when '-c' is present
clang: warning: argument unused during compilation: '-sub_library libobjc'
fatal error: file '/Volumes/2T/ServiceData/AtoZ.framework/AtoZ/AtoZ-Prefix.pch' has been modified since the precompiled header was built
1 error generated.
```

* SHA: be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
* User@SHA ref: mojombo@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
* User/Project@SHA: mojombo/god@be6a8cc1c1ecfe9489fb51e4869af15a13fc2cd2
* \#Num: #1
* User/#Num: mojombo#1
* User/Project#Num: mojombo/god#1

These are dangerous goodies though, and we need to make sure email addresses don't get mangled:

My email addy is tom@github.com.

Math is hard, let's go shopping
-------------------------------

In first grade I learned that 5 > 3 and 2 < 7. Maybe some arrows. 1 -> 2 -> 3. 9 <- 8 <- 7.

Triangles man! a^2 + b^2 = c^2

We all like making lists
------------------------

The above header should be an H2 tag. Now, for a list of fruits:

* Red Apples
* Purple Grapes
* Green Kiwifruits

Let's get crazy:

1.  This is a list item with two paragraphs. Lorem ipsum dolor
    sit amet, consectetuer adipiscing elit. Aliquam hendrerit
    mi posuere lectus.

    Vestibulum enim wisi, viverra nec, fringilla in, laoreet
    vitae, risus. Donec sit amet nisl. Aliquam semper ipsum
    sit amet velit.

2.  Suspendisse id sem consectetuer libero luctus adipiscing.

What about some code **in** a list? That's insane, right?

1. In Ruby you can map like this:

        ['a', 'b'].map { |x| x.uppercase }

2. In Rails, you can do a shortcut:

        ['a', 'b'].map(&:uppercase)

Some people seem to like definition lists

<dl>
  <dt>Lower cost</dt>
  <dd>The new version of this product costs significantly less than the previous one!</dd>
  <dt>Easier to use</dt>
  <dd>We've changed the product so that it's much easier to use!</dd>
</dl>

I am a robot
------------

Maybe you want to print `robot` to the console 1000 times. Why not?

    def robot_invasion
      puts("robot " * 1000)
    end

You see, that was formatted as code because it's been indented by four spaces.

How about we throw some angle braces and ampersands in there?

    <div class="footer">
        &copy; 2004 Foo Corporation
    </div>

Set in stone
------------

Preformatted blocks are useful for ASCII art:

<pre>
             ,-. 
    ,     ,-.   ,-. 
   / \   (   )-(   ) 
   \ |  ,.>-(   )-< 
    \|,' (   )-(   ) 
     Y ___`-'   `-' 
     |/__/   `-' 
     | 
     | 
     |    -hrr- 
  ___|_____________ 
</pre>

Playing the blame game
----------------------

If you need to blame someone, the best way to do so is by quoting them:

> I, at any rate, am convinced that He does not throw dice.

Or perhaps someone a little less eloquent:

> I wish you'd have given me this written question ahead of time so I
> could plan for it... I'm sure something will pop into my head here in
> the midst of this press conference, with all the pressure of trying to
> come up with answer, but it hadn't yet...
>
> I don't want to sound like
> I have made no mistakes. I'm confident I have. I just haven't - you
> just put me under the spot here, and maybe I'm not as quick on my feet
> as I should be in coming up with one.

Table for two
-------------

<table>
  <tr>
    <th>ID</th><th>Name</th><th>Rank</th>
  </tr>
  <tr>
    <td>1</td><td>Tom Preston-Werner</td><td>Awesome</td>
  </tr>
  <tr>
    <td>2</td><td>Albert Einstein</td><td>Nearly as awesome</td>
  </tr>
</table>

Crazy linking action
--------------------

I get 10 times more traffic from [Google] [1] than from
[Yahoo] [2] or [MSN] [3].

  [1]: http://google.com/        "Google"
  [2]: http://search.yahoo.com/  "Yahoo Search"
  [3]: http://search.msn.com/    "MSN Search"
  
# Points about Tweedledee and Tweedledum
 
Much has been made of the curious features of 
Tweedledee and Tweedledum.  We propose here to
set some of the controversy to rest and to uproot
all of the more outlandish claims.

    .      Tweedledee       Tweedledum
--------   --------------   ----------------
Age        14               14
Height     3'2"             3'2"
Politics   Conservative     Conservative
Religion   "New Age"        Syrian Orthodox
---------  --------------   ----------------

Table: T.-T. Data


# Mussolini's role in my downfall

--------------------------------------------------------------------
             *Drugs*         *Alcohol*           *Tobacco*
----------   -------------   -----------------   --------------------
    Monday     3 Xanax        2 pints             3 cigars,  
                                                  1 hr at hookah bar

   Tuesday    14 Adderall     1 Boone's Farm,     1 packet Drum
                              2 Thunderbird

 Wednesday    2 aspirin       Tall glass water    (can't remember)
---------------------------------------------------------------------

Table:  *Tableau des vices*, deluxe edition


# Points about the facts

In recent years, more and more attention has been 
paid to opinion, less and less to what were formerly 
called the cold, hard facts.  In a spirit of traditionalism, 
we propose to reverse the trend. Here are some of our results.

-------     ------ ----------   -------
     12     12        12             12
    123     123       123           123
      1     1          1              1
---------------------------------------

Table:  Crucial Statistics


# Recent innovations (1): False presentation

Some, moved by opinion and an irrational lust for novelty, 
would introduce a non-factual element into the data, 
perhaps moving all the facts to the left:

-------     ------ ----------   -------
12          12     12           12
123         123    123          123
1           1      1            1
---------------------------------------

Table: Crucial "Statistics"

# Recent innovations (2): Illegitimate decoration

Others, preferring their facts to be *varnished*, 
as we might say, will tend to 'label' the columns

Variable    Before During       After
---------   ------ ----------   -------
12          12     12           12
123         123    123          123
1000        1000   1000         1000
----------------------------------------

# Recent innovations (3): "Moderate" decoration

Or, maybe, to accompany this 'spin' with a centered or centrist representation: 

 Variable    Before  During       After
----------  ------- ----------   -------
 12          12      12           12
 123         123     123          123
 1           1       1            1
-----------------------------------------


# The real enemy

Some even accompany these representations with a bit of leftwing 
clap-trap, suggesting the facts have drifted right:


------------------------------------------------------
  Variable       Before            During       After
----------  -----------        ----------     -------
 12                  12                12          12
              -- Due to
                baleful 
              bourgeois
              influence

  123               123               123          123
              -- Thanks
              to the 
              renegade 
               Kautsky

  1                   1                 1            1
              -- All a 
              matter of
            sound Party
             discipline
-------------------------------------------------------

Table: *"The conditions are not ripe, comrades; they are **overripe**!"*

# The Truth

If comment be needed, let it be thus:  the facts have drifted left.


------------------------------------------------------------------------
 Variable   Before             During            After
----------  -------------      ----------        ----------------------
 12         12                 12                12
            (here's            (due to           (something to do
            where the rot      lapse of          with Clinton and
            set in )           traditional       maybe the '60's)
                               values)

 123        123                123               123
            (too much          (A=440?)
            strong drink)

 1          1                  1                 1
                                                 (Trilateral Commission?)
--------------------------------------------------------------------------

Table: *The Decline of Western Civilization*



Useful git commands for dealing with the nested submodules..

```git submodule foreach 'echo `git commit -am "sync"`'```

###[BlocksKit](http://zwaldowski.github.com/BlocksKit)
===================================================
###[Functional.m](https://github.com/leuchtetgruen/Functional.m)
=============================================================
###[PLWeakCompatibility](https://github.com/mralexgray/PLWeakCompatibility)

[NSUserDefaults+Subscript](https://github.com/asmallteapot/NSUserDefaults-Subscript)
 provides access to preferences using Objective-C’s subscript syntax.]
# FunSize: Cocoa, but smaller.

FunSize is an Objective-C framework comprised entirely of categories and intended to make Cocoa code shorter, while maintaining expressiveness. Here are a few approaches taken:

* Use blocks, a lot. They're pretty cool.
* Make `NSNumber` and `NSValue` as invisible as possible. They are ugly and
  provide no additional information. Instead, provide messages for low-level
  data types (`int`, `NSRect`, `CATransform3D`, etc).
* Replace absurdly long messages. `CAMediaTimingFunction`'s
  `+functionWithName:` takes one of five constants, each of which is prefixed
  with `kCAMediaTimingFunction`. `[CAMediaTimingFunction easeOut]` is much more
  succinct.
* Use reasonable defaults. Why is there no simple `-CGImage` or `-drawInRect:`
  for `NSImage`? There is now. Additionally, 99% of `NSNotificationCenter`
  usage is on the `-defaultCenter`. So, FunSize has class-level versions of all
  `NSNotificationCenter` (and `NSUserDefaults`) instance messages.

## Current Status

FunSize was written while writing a Mac OS X application. Most of it presumably works on iOS, but some `#ifdef`s are probably needed for classes that don't exist (`NSView`). I used garbage collection in that application, and while I attempted to insert `retain`, `release`, and `autorelease` where applicable,
I haven't tested it extensively without GC (for this reason, I will not be using GC in my next application).

**New Note**: It *seems* to work fine with reference counting now, as I've been running Leaks on my current project, which uses manual reference counting and makes extensive use of FunSize. If there are any remaining leaks, they would show up pretty clearly in Leaks anyways (which I assume everyone runs...right?)

## Usage

The Xcode project target is a framework. Honestly, I haven't really used it, I simply added the source files to my project. Either way should work, however. I don't think Apple will be shipping FunSize any time soon, so you'll have to distribute it with each application anyways.

`FunSize.h` imports all of the other headers. Personally, I added it to my prefix header so that FunSize feels like part of Cocoa. Actually, while I was writing this, I was surprised to learn that `-[NSImage CGImage]` *isn't* part of Cocoa.

## Style

If you would like to contribute to FunSize, please follow this style.

### What FunSize does and does not do

* FunSize adds category methods.
* FunSize does not do anything else.

Note that this rule only applies to "public" things. "Helper" classes are
perfectly acceptable (see `NSTimer+FunSize.m`), but they cannot be included in
any header files that are included with a compiled copy of FunSize. The same
applies to structs, typedefs, and anything else that isn't a category method.

### Documentation

Everything should be documented in
[appledoc](http://www.gentlebytes.com/home/appledocapp/) style. There's no need
to go overkill documenting parameters or returns that are really obvious to
anyone smart enough to be the type of software developer that seeks out
Objective-C category frameworks. But at least say something, since the appledoc
pages look really ugly otherwise. Also, although appledoc warns about it, the
classes that categories are being added to don't need to be documented.

Separate sections in header files like this:

    #pragma mark -
    #pragma mark Recursive Subview Operations
    /** @name Recursive Subview Operations */
    
The final line is for appledoc, and should be left off in the implementation
file.

Reasonably current documentation is available
[here](http://funsize.natestedman.com/documentation).

### Naming Things

Boring and easy things first: filenames are `Class+FunSize.h` and
`Class+FunSize.m`. Category declarations are `Class (FunSize)`.

For naming actual messages, try to stay within Apple style (within reason). An
example is the usage of `CATransform3D`. `CA*` classes refer to it as a
"transform", so I added `-setFromTransform` to `CABasicAnimation`. `NSValue`,
however, has `-CATransform3DValue`. Therefore, when I added key/value messages
to `NSObject` to support `CATransform3D`, I used the style
`-CATransform3DForKey:`.

### Braces and Spaces

In general, just look at the current style and copy it. But basically, use
four spaces for indentation, since Xcode is bad at handling tabs. Use Allman
style for everything except blocks, which use K&R (why? I think it's most
readable like that).Declare pointers like this: `NSImage*`. Put spaces in math
(`2 + 2`, not `2+2`), because it's good if math is actually readable.



Blocks in C and Objective-C are downright magical.  They make coding easier and potentially quicker, not to mention faster on the front end with multithreading and Grand Central Dispatch.  BlocksKit hopes to facilitate this kind of programming by removing some of the annoying - and, in some cases, impeding - limits on coding with blocks.

BlocksKit is a framework and static library for iOS 4.0+ and Mac OS X 10.6+.

Installation
============

BlocksKit can be added to a project using [CocoaPods](https://github.com/alloy/cocoapods).

### Framework

* Download a release of BlocksKit.
* Move BlocksKit.framework to your project's folder.  Drag it from there into your project.
* Add BlocksKit.framework to "Link Binary With Libraries" in your app's target. Make sure your app is linked with CoreGraphics, Foundation, MessageUI, and UIKit.
* In the build settings of your target or project, change "Other Linker Flags" (`OTHER_LDFLAGS`) to `-ObjC -all_load`.
* Insert `#import <BlocksKit/BlocksKit.h>` in your project's prefix header.
* Make amazing software.

### Library

* Download a release of BlocksKit.
* Move libBlocksKit.a and Headers to your project's folder, preferably a subfolder like "Vendor".
* In "Build Phases", Drag libBlocksKit.a into your target's "Link Binary With Libraries" build phase. 
* In the build settings of your target or project, change "Other Linker Flags" to `-ObjC -all_load`. Make sure your app is linked with CoreGraphics, Foundation, MessageUI, and UIKit.
* Change (or add) to "Header Search Paths" the relative path to BlocksKit's headers, like `$(SRCROOT)/Vendor/Headers`.
* Insert `#import <BlocksKit/BlocksKit.h>`` in your project's prefix header.

Documentation
=============

An Xcode 4 compatible documentation set is available [using this Atom link](http://zwaldowski.github.com/BlocksKit/com.dizzytechnology.BlocksKit.atom). You may also view the documentation [online](http://zwaldowski.github.com/BlocksKit/Documentation).

#Functional.m

Functional.m is an extension for objective-c, that can be used to do functional programming.

Here's the documentation for the individual functions:

The numberArray NSArray contains a collection of NSNumbers, The dict NSDictionary contains the same collection - the keys are the names of the numbers

```objc
    NSArray *numberArray = [NSArray arrayFrom:1 To:5];
    NSArray *numberNamesArray = [NSArray arrayWithObjects:@"one", @"two", @"three", @"four", @"five", nil];
    NSDictionary *numberDict = [NSDictionary dictionaryWithObjects:numberArray forKeys:numberNamesArray];
```

##each

The given iterator runs for each object in the collection.

- `- (void) each:(VoidIteratorArrayBlock) block;`
- `- (void) each:(VoidIteratorDictBlock) block;`

Example:

```objc
    [numberArray each:^(id obj) {
        NSLog(@"Current Object : %@", obj);
    }];
    
    [numberDict each:^(id key, id value) {
        NSLog(@"%@ => %@", key, value);
    }];
```

##map

Each object in the collection can be transformed in the iterator.

- `- (NSArray *) map:(MapArrayBlock) block;`
- `- (NSDictionary *) map:(MapDictBlock) block;`

Example:

```objc
    NSArray *doubleArray = [numberArray map:^NSNumber*(NSNumber *obj) {
        return [NSNumber numberWithInt:([obj intValue]*2)];
    }];
    NSDictionary *doubleDict = [numberDict map:^NSNumber*(id key, NSNumber *obj) {
        return [NSNumber numberWithInt:([obj intValue]*2)];
    }];
    
    NSLog(@"Double : Array %@ - Dict %@", doubleArray, doubleDict);
```

##reduce

Reduces all objects in the collection to a single value (something like computing the average etc.)

- `- (id) reduce:(ReduceArrayBlock) block withInitialMemo:(id) memo;`
- `- (id) reduce:(ReduceDictBlock) block withInitialMemo:(id) memo;`

Example - adds all NSNumbers in the array or dictionary.

```objc 
    NSNumber *memo = [NSNumber numberWithInt:0];
    
    NSNumber *sumArray = [numberArray reduce:^NSNumber*(NSNumber *memo, NSNumber *cur) {
        return [NSNumber numberWithInt:([memo intValue] + [cur intValue])];
    } withInitialMemo:memo];
    
    NSNumber *sumDict = [numberDict reduce:^NSNumber*(NSNumber *memo, id key, NSNumber *cur) {
        return [NSNumber numberWithInt:([memo intValue] + [cur intValue])];
    } withInitialMemo:memo];
    
    NSLog(@"Sum : Array %@ - Dict %@", sumArray, sumDict);
```

##filter and reject

`Filter` gives you only those objects, for that the iterator returns true. `Reject` removes all objects for that the iterator returns true.

- `- (NSArray *) filter:(BoolArrayBlock) block;`
- `- (NSArray *) reject:(BoolArrayBlock) block;`

- `- (NSDictionary*) filter:(BoolDictionaryBlock) block;`
- `- (NSDictionary*) reject:(BoolDictionaryBlock) block;`

This example gives you all even (filter) or odd (reject) numbers in the array / dict:

```objc
        BoolArrayBlock isEvenArrayBlock = ^BOOL(NSNumber *obj) {
            return (([obj intValue] % 2) == 0);
        };
        BoolDictionaryBlock isEvenDictBlock = ^BOOL(id key, NSNumber *obj) {
            return (([obj intValue] % 2) == 0);
        };
    
        NSArray *evenArr    = [numberArray filter:isEvenArrayBlock];
        NSDictionary *evenDict   = [numberDict filter:isEvenDictBlock];
        NSLog(@"The following elements are even : Array %@ - Dict %@", evenArr, evenDict);
    
    #pragma mark - reject
        NSArray *oddArr = [numberArray reject:isEvenArrayBlock];
        NSDictionary *oddDict = [numberDict reject:isEvenDictBlock];
        NSLog(@"The following elements are odd : Array %@ - Dict %@", oddArr, oddDict);   
```

##isValidForAll and isValidForAny

`isValidForAll` returns YES if the iterator returns YES for all elements in the collection. `isValidForAny` returns YES if the iterator returns YES for at least one object in the collection.

- `- (BOOL) isValidForAll:(BoolArrayBlock) block;`
- `- (BOOL) isValidForAny:(BoolArrayBlock) block;`

- `- (BOOL) isValidForAll:(BoolDictionaryBlock) block;`
- `- (BOOL) isValidForAny:(BoolDictionaryBlock) block;`

This example checks if all or any elements in the collection are even numbers

```objc
    BoolArrayBlock isEvenArrayBlock = ^BOOL(NSNumber *obj) {
        return (([obj intValue] % 2) == 0);
    };
    BoolDictionaryBlock isEvenDictBlock = ^BOOL(id key, NSNumber *obj) {
        return (([obj intValue] % 2) == 0);
    };

    NSLog(@"Only even numbers : Array %d - Dict %d", [numberArray isValidForAll:isEvenArrayBlock], [numberDict isValidForAll:isEvenDictBlock]);
    # pragma mark - isValidForAny
    NSLog(@"Any even numbers : Array %d - Dict %d", [numberArray isValidForAny:isEvenArrayBlock], [numberDict isValidForAny:isEvenDictBlock]);
```

##countValidEntries

Counts the number of entries in a set, for which the given block returns true:

- `- (NSNumber *) countValidEntries:(BoolArrayBlock) block;`
- `- (NSNumber *) countValidEntries:(BoolDictionaryBlock) block;`

```objc
    BoolArrayBlock isEvenArrayBlock = ^BOOL(NSNumber *obj) {
        return (([obj intValue] % 2) == 0);
    };
    BoolDictionaryBlock isEvenDictBlock = ^BOOL(id key, NSNumber *obj) {
        return (([obj intValue] % 2) == 0);
    };

    NSNumber *ctEvenArr     = [numberArray countValidEntries:isEvenArrayBlock];
    NSNumber *ctEvenDict    = [numberDict countValidEntries:isEvenDictBlock];
    NSLog(@"The number of even elements are : Array %@ - Dict %@", ctEvenArr, ctEvenDict);
```

##dropWhile

Drops every entry before the first item the block returns true for.

- `- (NSArray *) dropWhile:(BoolArrayBlock) block;`

```objc
	NSArray *droppedUntilThree = [numberArray dropWhile:^BOOL(NSNumber *nr) {
	    return ([nr integerValue] < 3);
	}];
	NSLog(@"Array from 3 : %@", droppedUntilThree);
```

##max and min

Return the maximum and the minimum values in a collection. You will have to write a comperator, which compares two elements.

- `- (id) max:(CompareArrayBlock) block;`
- `- (id) min:(CompareArrayBlock) block;`

- `- (id) max:(CompareDictBlock) block;`
- `- (id) min:(CompareDictBlock) block;`

Here's an example that gets the minimum and the maximum value from the array and dict described above:

```objc
        CompareArrayBlock compareArrBlock = ^NSComparisonResult(NSNumber *a, NSNumber *b) {
            return [a compare:b];
        };
    
        CompareDictBlock compareDictBlock = ^NSComparisonResult(id k1, NSNumber *v1, id k2, NSNumber *v2) {
            return [v1 compare:v2];
        };
    
        NSNumber *maxArr    = [numberArray max:compareArrBlock];
        NSNumber *maxDict   = [numberDict max:compareDictBlock];
        NSLog(@"Max : Array %@ - Dict %@", maxArr, maxDict);
    
    #pragma mark - min
        NSNumber *minArr    = [numberArray min:compareArrBlock];
        NSNumber *minDict   = [numberDict min:compareDictBlock];
        NSLog(@"Min : Array %@ - Dict %@", minArr, minDict);
```

##sort

Sort is actually just an alias for `[self sortedArrayUsingComparator:block];`

- `- (NSArray *) sort:(NSComparator) block;`

See [NSArray sortedArrayUsingComperator:](http://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Reference/Foundation/Classes/NSArray_Class/NSArray.html#//apple_ref/occ/instm/NSArray/sortedArrayUsingComparator:) for reference.

Here's an example:

```objc
    NSComperator compareArrBlock = ^NSComparisonResult(NSNumber *a, NSNumber *b) {
        return [a compare:b];
    };

    NSArray *nrReversed = [numberArray reverse];
    NSArray *sorted     = [nrReversed sort:compareArrBlock];
    NSLog(@"%@ becomes %@ when sorted", nrReversed, sorted);
```

##group

Groups an array by the values returned by the iterator.

- `- (NSDictionary *) group:(MapArrayBlock) block;`

Here's an example that groups an array into an odd numbers section and an even numbers section:

```objc
	NSDictionary *oddEvenArray = [numberArray group:^NSString *(NSNumber *obj) {
        if (([obj intValue] % 2) == 0) return @"even";
        else return @"odd";
    }];
	NSLog(@"Grouped array %@", oddEvenArray);
```

##times

Call times on an `NSNumber` (n) to iterate n times over the given block.

- `- (void) times:(VoidBlock) block;`

Here's a simple example - it prints 'have i told you' once:

```objc
    NSNumber *howMany   = [numberArray first];
    [howMany times:^{
        NSLog(@"have i told you?");
    }];
```

##NSArray additions

###arrayFrom:To:

Creates an array, that contains the range as individual NSNumbers

- `+ (NSArray *) arrayFrom:(NSInteger) from To:(NSInteger) to;`

Example:

```objc
	NSArray *rArr = [NSArray arrayFrom:0 To:3];
    NSLog(@"Array from 0 to 3 %@", rArr);
```

###first

- `- (id) first;`

Just a shortcut for `[array objectAtIndex:0]`;

###reverse

- `- (NSArray *) reverse;`

Returns the reversed array

###arrayUntilIndex and arrayFromIndexOn

These are helper functions. They return the elements of the array they are called on until (excluding) the given index or from the given index on (including).

- `- (NSArray *) arrayUntilIndex:(NSInteger) idx;`
- `- (NSArray *) arrayFromIndexOn:(NSInteger) idx;`

```objc
	NSArray *untilTwo = [numberArray arrayUntilIndex:2];
	NSArray *afterTwo = [numberArray arrayFromIndexOn:2];
	NSLog(@"The array until idx 2 : %@ and thereafter : %@", untilTwo, afterTwo); // 1,2 and 3,4,5
```


PLWeakCompatibility
===================

Do you like ARC but need to support older OSes? Do you contemplate dropping support for Mac OS X 10.6 or iOS 4 just so you can use `__weak`? Good news! Now you can use `__weak` on those older OSes by just dropping a file into your project and adding a couple of compiler flags.

`PLWeakCompatibility` is a set of stubs that implement the Objective-C runtime functions the compiler uses to make `__weak` work. It automatically calls through to the real runtime functions if they're present (i.e. your app is running on iOS5+ or Mac OS X 10.7+) and uses its own implementation if they're not.

To use `PLWeakCompatibility`:

1. Drop `PLWeakCompatibilityStubs.m` into your project.
2. Add these flags to your Other C Flags in your Xcode target settings: `-Xclang -fobjc-runtime-has-weak`.
3. There is no step 3!

Note that, by default, `PLWeakCompatibility` uses `MAZeroingWeakRef` to handle `__weak` *if* `MAZeroingWeakRef` is present. If not, it uses its own, less sophisticated, internal implementation. If you are already using `MAZeroingWeakRef`, then `PLWeakCompatibility` will take advantage of it. If you're not, you don't need it. There is nothing you need to do to enable the use of `MAZeroingWeakRef`, it will simply be used if it's in your project.


Implementation Notes
--------------------

The built-in weak reference implementation is basic but serviceable. It works by swizzling out `-release` and `-dealloc` on target classes directly. This means that every instance of any weakly referenced class takes a performance hit for those operations, even for instances which are not themselves weakly referenced.

This swizzling *should* be benign, but as with all things runtime manipulation, problems may occur. In particular, I do not anticipate weak references to bridged CoreFoundation objects working at all, and there may be conflicts with Key-Value Observing. The good news is that, since the `PLWeakCompatibility` implementation is only active on older OSes, you have stable targets to test against, and can know that future updates won't affect compatibility.


Compatibility Notes
-------------------

`PLWeakCompatibility` *should* be fully compatible with any OS/architecture/compiler combination which supports ARC. Since the calls are generated at compile time, and the stubs simply call through to Apple's implementations when available, it's extremely unlikely that a future OS update will break an app that uses `PLWeakCompatibility`. All of the tricky business happens on OSes which will not receive further updates.

It is possible that a future version of Xcode will include a compiler which does not get along with these stubs. We consider this possibility to be unlikely, but it's possible in theory. If it does happen, you may continue to build using an old compiler for as long as you support iOS 4 or Mac OS 10.6, and we also hope to be able to fix up any incompatibilities in the unlikely event that this occurs.


## Licensing

Please Refer to submodule individual licensing, where applicable, but here is a summary.

=======

FunSize is licensed under the ISC license.
Copyright (c) 2011, Nate Stedman <natesm@gmail.com>

=======

BlocksKit is created and maintained by [Zachary Waldowski](https://github.com/zwaldowski) under the MIT license.  **The project itself is free for use in any and all projects.**  You can use BlocksKit in any project, public or private, with or without attribution.

Unsure about your rights?  [Read more.](http://zwaldowski.github.com/BlocksKit/index.html#license)

All of the included code is licensed either under BSD, MIT, or is in the public domain. A full list of contributors exists on the [project page](http://zwaldowski.github.com/BlocksKit/index.html#contributors). Individual credits exist in the header files and documentation. We thank them for their contributions to the open source community.

▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

<pre>
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
</pre>
