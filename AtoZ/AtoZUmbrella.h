
#ifndef AtoZ_Umbrella
#define AtoZ_Umbrella

@import ObjectiveC;
@import QuartzCore;
@import AppKit;
@import Dispatch;
@import SystemConfiguration;
#import <ExtObjC/ExtObjC.h>
#import <Zangetsu/Zangetsu.h>
#import "KVOMap/KVOMap.h"
#import "AtoZAutoBox/AtoZAutoBox.h"

//#import <RoutingHTTPServer/RoutingHTTPServer.h>
//#import <CocoaHTTPServer/CocoaHTTPServer.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

static const int ddLogLevel = LOG_LEVEL_VERBOSE; // Log level for robbie (debug)

#pragma mark - ACTIVE NSLOG

#define NSLog(fmt...)  ((void)printf("%s %s\n",__PRETTY_FUNCTION__,[[NSString.alloc initWithFormat:fmt]UTF8String]))
#define NSLogC(fmt...)  ((void)printf("%s %s\n",__PRETTY_FUNCTION__,[[NSString.alloc initWithFormat:fmt]UTF8String]))

//(((void)DDLogInfo(__VA_ARGS__)))
//#define NSLogC(...) (((void)DDLogCInfo(__VA_ARGS__)))


#pragma mark - ATOZFRAMEWORK

#import "JREnum.h"
#import "objswitch.h"
#import "BaseModel.h"
#import "AutoCoding.h"
#import "HRCoder.h"
#import "F.h"

#import "AtoZMacroDefines.h"
#import "AtoZTypes.h"
#import "BoundingObject.h"
#import "MutableGeometry.h"

/*! id x = CAL.new; [x setGeos:@"bounds", @"x",@100, @"width", @5000, nil];   NEAT! */
#import "AtoZGeometry.h"

//#import <Zangetsu/Zangetsu.h>
//#import <RoutingHTTPServer/RoutingHTTPServer.h>
//#import "BaseModel.h"
//#import "AtoZCategories.h"


#define CGRect NSRect 
#define CGPoint NSPoint 
#define CGSize NSSize

#define DEFAULTINIT(methodName) \
- (id) init                       { return self = super.init ? [self methodName], self : nil; }\
- (id) initWithFrame:(NSR)f       { return self = [super initWithFrame:f] ? [self methodName], self : nil; }\
- (id) initWithCoder:(NSCoder*)d  { return self = [super initWithCoder:d] ? [self methodName], self : nil; }

#pragma mark - General Functions

//#define NSDICT (...) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
//#define NSARRAY(...) [NSArray arrayWithObjects: __VA_ARGS__, nil]
#define NSBOOL(X) [NSNumber numberWithBool:X]
//#define NSSET  (...) [NSSet setWithObjects: __VA_ARGS__, nil]

#define NSCRGBA(red,green,blue,alpha) [NSC r:red g:green b:blue a:alpha]
#define NSDEVICECOLOR(r,g,b,a) [NSColor colorWithDeviceRed:r green:g blue:b alpha:a]
#define NSCOLORHSB(h,s,b,a) [NSColor colorWithDeviceHue:h saturation:s brightness:b alpha:a]
#define NSCW(_grey_,_alpha_)  [NSColor colorWithCalibratedWhite:_grey_ alpha:_alpha_]

//^NSC*(grey,alpa){ return (NSC*)[NSColor colorWithCalibratedWhite:grey alpha:alpha]; }

#pragma mark - FUNCTION defines

//		\
//	BOOL YESORNO = strcmp(getenv(XCODE_COLORS), "YES") == 0;					\
//	va_list vl;																				\
//	va_start(vl, fmt);																	\
//	NSS* str = [NSString.alloc initWithFormat:(NSS*)fmt arguments:vl];	\
//	va_end(vl);																				\
//	YESORNO 	? 	NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" @"%@" XCODE_COLORS_RESET, __PRETTY_FUNCTION__, __LINE__, str) \
//				: 	NSLog(@"%@",str); \
//}()

//strcmp(getenv(XCODE_COLORS), "YES") == 0 \
//		? NSLog(	(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" fmt XCODE_COLORS_RESET)\
//		, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) \
//			: NSLog(fmt,__VA_ARGS__)

//_AZColorLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);


/**	const

 extern NSString * const MyConstant;

 You'll see this in header files. It tells the compiler that the variable MyConstant exists and can be used in your implementation files.	More likely than not, the variable is set something like:

 NSString * const MyConstant = @"foo";
 The value can't be changed. If you want a global that can be changed, then drop the const from the declaration.
 The position of the const keyword relative to the type identifier doesn't matter
 const NSString *MyConstant = @"foo";  ===  NSString const *MyConstant = @"foo";
 You can also legally declare both the pointer and the referenced value const, for maximum constness:
 const NSString * const MyConstant = @"foo";
 extern

 Allows you to declare a variable in one compilation unit, and let the compiler know that you've defined that variable in a separate compilation unit. You would generally use this only for global values and constants.

 A compilation unit is a single .m file, as well as all the .h files it includes. At build time the compiler compiles each .m file into a separate .o file, and then the linker hooks them all together into a single binary. Usually the way one compilation unit knows about identifiers (such as a class name) declared in another compilation unit is by importing a header file. But, in the case of globals, they are often not part of a class's public interface, so they're frequently declared and defined in a .m file.

 If compilation unit A declares a global in a .m file:

 #import "A.h"
 NSString *someGlobalValue;

 and compilation unit B wants to use that global:

 #import "B.h"
 extern NSString *someGlobalValue;

 @implementation B
 - (void)someFunc {
 NSString *localValue = [self getSomeValue];
 [localValue isEqualToString:someGlobalValue] ? ^{ ... }() : ^{ ... }();
 }

 unit B has to somehow tell the compiler to use the variable declared by unit A. It can't import the .m file where the declaration occurs, so it uses extern to tell the compiler that the variable exists elsewhere.
 Note that if unit A and unit B both have this line at the top level of the file:

 NSString *someGlobalValue;

 then you have two compilation units declaring the same global variable, and the linker will fail with a duplicate symbol error. If you want to have a variable like this that exists only inside a compilation unit, and is invisible to any other compilation units (even if they use extern), you can use the static keyword:

 static NSString * const someFileLevelConstant = @"wibble";

 This can be useful for constants that you want to use within a single implementation file, but won't need elsewhere
 **/

#define nAZColorWellChanged @"AtoZColorWellChangedColors"

#define AZBONK @throw [NSException exceptionWithName:@"WriteThisMethod" reason:@"You did not write this method, yet!" userInfo:nil]

#define GENERATE_SINGLETON(SC) static SC * SC##_sharedInstance = nil;\
+(SC *)sharedInstance { if (! SC##_sharedInstance) { SC##_sharedInstance = SC.new; } \
return SC##_sharedInstance; }


//#define foreach(B,A) A.andExecuteEnumeratorBlock = \
//^(B, NSUInteger A##Index, BOOL *A##StopBlock)

//#define foreach(A,B,C) \
//A.andExecuteEnumeratorBlock =  ^(B, NSUInteger C, BOOL *A##StopBlock)


/* 	KSVarArgs is a set of macros designed to make dealing with variable arguments	easier in Objective-C. All macros assume that the varargs list contains only objective-c objects or object-like structures (assignable to type id). The base macro ksva_iterate_list() iterates over the variable arguments, invoking a block for each argument, until it encounters a terminating nil. The other macros are for convenience when converting to common collections.
*/
/** 	Block type used by ksva_iterate_list.
 @param entry The current argument in the vararg list.	*/

typedef void (^AZVA_Block)(id entry);
typedef void (^AZVA_ArrayBlock)(NSArray* values);

#define AZVA_ARRAYB void (^)(NSArray* values)
#define AZVA_IDB void (^AZVA_Block)(id entry)

/**	Iterate over a va_list, executing the specified code block for each entry.
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param BLOCK A code block of type KSVA_Block.	 */
#define azva_iterate_list(FIRST_ARG_NAME, BLOCK) { \
	AZVA_Block azva_block = BLOCK;	va_list azva_args	;	va_start(azva_args,FIRST_ARG_NAME );							 \
	for( id azva_arg = FIRST_ARG_NAME;	azva_arg != nil;  azva_arg = va_arg(azva_args, id ) )	azva_block(azva_arg); \
	va_end(azva_args); }

#define AZVA_ARRAY(FIRST_ARG_NAME,ARRAY_NAME) azva_list_to_nsarray(FIRST_ARG_NAME,ARRAY_NAME)

/***	Convert a variable argument list into array. An autorel. NSMA will be created in current scope w/ the specified name.
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param ARRAY_NAME The name of the array to create in the current scope.	 */
#define azva_list_to_nsarray(FIRST_ARG_NAME, ARRAY_NAME) \
	NSMA* ARRAY_NAME = NSMA.new;  azva_iterate_list(FIRST_ARG_NAME, ^(id entry) { [ARRAY_NAME addObject:entry]; })

#define azva_list_to_nsarrayBLOCKSAFE(FIRST_ARG_NAME, ARRAY_NAME) \
	NSMA* ARRAY_NAME = NSMA.new;  azva_iterate_list(FIRST_ARG_NAME, ^(id entry) { __block __typeof__(entry) _x_ = entry; [ARRAY_NAME addObject:_x_]; })


/*** 	Convert a variable argument list into a dictionary, interpreting the vararg list as object, key, object, key, ...
 An autoreleased NSMutableDictionary will be created in the current scope with the specified name.
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param DICT_NAME The name of the dictionary to create in the current scope.		*/
#define azva_list_to_nsdictionary(FIRST_ARG_NAME, DICT_NAME) \
	NSMD* DICT_NAME = NSMD.new; 	{						 														\
		__block id azva_object = nil; 					 														\
		azva_iterate_list(FIRST_ARG_NAME, ^(id entry) { 													\
			if(azva_object == nil)  azva_object = entry; 													\
			else {	[DICT_NAME setObject:azva_object forKey:entry]; azva_object = nil;  } 	}); }


/*** 	Same as above... but KEY is first!
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param DICT_NAME The name of the dictionary to create in the current scope.		*/
#define azva_list_to_nsdictionaryKeyFirst(FIRST_KEY, DICT_NAME) \
	NSMD* DICT_NAME = NSMD.new; 	{						 														\
		__block id azva_object = nil; 					 														\
		azva_iterate_list(FIRST_KEY, ^(id entry) { 															\
			if(azva_object == nil)  azva_object = entry; 													\
			else {	[DICT_NAME setObject:entry forKey:azva_object]; azva_object = nil;  } 	}); }


static inline void _AZUnimplementedMethod(SEL selector,id object,const char *file,int line) {
   NSLogC(@"-[%@ %s] unimplemented in %s at %d",[object class],sel_getName(selector),file,line);
}

static inline void _AZUnimplementedFunction(const char *function,const char *file,int line) {
   NSLogC(@"%s() unimplemented in %s at %d",function,file,line);
}

#define AZUnimplementedMethod() \
_AZUnimplementedMethod(_cmd,self,__FILE__,__LINE__)

#define AZUnimplementedFunction() \
_AZUnimplementedFunction(__PRETTY_FUNCTION__,__FILE__,__LINE__)


/* instance variable    NSMutableArray *thingies;  in @implementation  ARRAY_ACCESSORS(thingies,Thingies) */

#define ARRAY_ACCESSORS(lowername, capsname) \
	- (NSUInteger)countOf ## capsname { return [lowername count]; } \
	- (id)objectIn ## capsname ## AtIndex: (NSUInteger)index { return [lowername objectAtIndex: index]; } \
	- (void)insertObject: (id)obj in ## capsname ## AtIndex: (NSUInteger)index { [lowername insertObject: obj atIndex: index]; } \
	- (void)removeObjectFrom ## capsname ## AtIndex: (NSUInteger)index { [lowername removeObjectAtIndex: index]; }


#ifdef XCODECODEFORPASTING

- (NSUInteger) countOf<#Collection#> { return [<#collectuion#> count]; }
- objectIn<#Collection#>AtIndex:(NSUInteger)idx { return [<#collectuion#> objectAtIndex:idx]; }
- (void) insertObject:(id)o in<#Collection#>AtIndex:(NSUInteger)idx { [<#collectuion#> insertObject:o atIndex:idx]; }
- (void) removeObjectFrom<#Collection#>AtIndex:(NSUInteger)idx { [<#collectuion#> removeObjectAtIndex:idx]; }

#endif

//#define objc_dynamic_cast(obj,cls) \
//    ([obj isKindOfClass:(Class)objc_getClass(#cls)] ? (cls *)obj : NULL)

#define NEW(A,B) A *B = A.new

//#define NEWVALUE(_NAME_,_VAL_) \
//	objc_getClass([_VAL_ class])
//	whatever *s = @"aa;";
//	NSLog(@"%@", s.class);
//}
//NS_INLINE void AZNewItems (Class aClass,...) {		objc_getClass}

#define NEWS(A,...) AZNewItems(A,...)


//#import "AtoZGeometry.h"
//#import "BoundingObject.h"

#endif /* END #ifndef AtoZ_Umbrella */