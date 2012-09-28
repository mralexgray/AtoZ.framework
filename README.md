#[AtoZ.framework](https://github.com/mralexgray/AtoZ.framework) 
##The *all-inclusive cruise* of Umbrella frameworks.


###[BlocksKit](http://zwaldowski.github.com/BlocksKit)
===================================================
###[Functional.m](https://github.com/leuchtetgruen/Functional.m)
=============================================================

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

FunSize was written while writing a Mac OS X application. Most of it presumably
works on iOS, but some `#ifdef`s are probably needed for classes that don't
exist (`NSView`). I used garbage collection in that application, and while
I attempted to insert `retain`, `release`, and `autorelease` where applicable,
I haven't tested it extensively without GC (for this reason, I will not be
using GC in my next application).

**New Note**: It *seems* to work fine with reference counting now, as I've been
running Leaks on my current project, which uses manual reference counting and
makes extensive use of FunSize. If there are any remaining leaks, they would
show up pretty clearly in Leaks anyways (which I assume everyone runs...right?)

## Usage

The Xcode project target is a framework. Honestly, I haven't really used it, I
simply added the source files to my project. Either way should work, however. I
don't think Apple will be shipping FunSize any time soon, so you'll have to
distribute it with each application anyways.

`FunSize.h` imports all of the other headers. Personally, I added it to my
prefix header so that FunSize feels like part of Cocoa. Actually, while I was 
writing this, I was surprised to learn that `-[NSImage CGImage]` *isn't* part
of Cocoa.

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



## Licensing

Please Refer to submodule individual licensing, where applicable, but here is a summary.

=======

FunSize is licensed under the ISC license.
Copyright (c) 2011, Nate Stedman <natesm@gmail.com>

=======

BlocksKit is created and maintained by [Zachary Waldowski](https://github.com/zwaldowski) under the MIT license.  **The project itself is free for use in any and all projects.**  You can use BlocksKit in any project, public or private, with or without attribution.

Unsure about your rights?  [Read more.](http://zwaldowski.github.com/BlocksKit/index.html#license)

All of the included code is licensed either under BSD, MIT, or is in the public domain. A full list of contributors exists on the [project page](http://zwaldowski.github.com/BlocksKit/index.html#contributors). Individual credits exist in the header files and documentation. We thank them for their contributions to the open source community.

