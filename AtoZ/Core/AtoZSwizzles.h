

#define AZSWIZ printf("[SWIZ|%s]",NSStringFromSelector(_cmd).UTF8String);
#define $$$$ self
#define AZLogDictsASXML 0

@Kind(AZBlockSwizzle) // was MBBlockSwizzle

typedef void(^AZSwizzleWithOrig)(IMP orig);

///*! @abstract A block type definition for blocks that contain logic to revert a swizzled method's implementation to it's original implementation.
// */ typedef void(^AZSwizzleRevertBlock)();

/*! @abstract A function to swizzle a method of a class or instance with given implementation block.
 @note Due to an observation, this function uses the classes name, to pick up the current class in the runtime via NSClassFromString. Otherwise, another class reference would be used, which leads to unpredictable behavior.
 @param className     Name of the class of the method to be swizzled.
 @param selector      Method selector definition to identify method on the class definitions.
 @param isClassMethod Boolean flag to indicate the method is a class or instance method.
 @param block         Block to contain the implementation to be executed by the method.
 @return TMMethodSwizzleRevertBlock Block to contain logic to revert the swizzle.
 */
Blk AZSwizzleWithBlock(NSS *className, SEL selector, BOOL isClassMethod, id block );
/*! A function to swizzle a method of a class or instance with given implementation block and run a given block. After the block execution the swizzle is reverted.
  @note Due to an observation, this function uses the classes name, to pick up the current class in the runtime via NSClassFromString. Otherwise, another class reference would be used, which leads to unpredictable behavior.
  @param className      Name of the class of the method to be swizzled.
  @param selector       Method selector definition to identify method on the class definitions.
  @param isClassMethod  Boolean flag to indicate the method is a class or instance method.
  @param imp            Block to contain the implementation to be executed by the method.
  @param run            Block to contain logic to be executed when the swizzle was executed.
 */
void AZSwizzleWithBlockAndRun   (NSS *className, SEL selector, BOOL isClassMethod, id imp, VBlk run);
void AZSwizzleWithBlockFallback (NSS *className, SEL selector, BOOL isClassMethod, id imp);

@end

@interface NSO (ConciseKitSwizzle)

+ _IsIt_      swizzleMethod __Meth_ sel1 with __Meth_ sel2;

+ _IsIt_      swizzleMethod __Meth_ sel1 with __Meth_ sel2
                                        in __Meta_ k1;

+ _IsIt_      swizzleMethod __Meth_ sel1   in __Meta_ k1
                       with __Meth_ sel2   in __Meta_ k2;

+ _IsIt_ swizzleClassMethod __Meth_ sel1 with __Meth_ sel2
                                        in __Meta_ k1;

+ _IsIt_ swizzleClassMethod __Meth_ sel1   in __Meta_ k1
                       with __Meth_ sel2   in __Meta_ k2;

+ (void) waitUntil:(BOOL(^)(void))cond;
+ (void) waitUntil:(BOOL(^)(void))cond timeOut:(NSTimeInterval)to;
+ (void) waitUntil:(BOOL(^)(void))cond timeOut:(NSTimeInterval)to interval:(NSTimeInterval)interval;

- (NSS*)swizzleNSValueDescription;

// TEMPORARY SWIZ
+ (void)swizzle __Meth_ oMeth toMethod __Meth_ newMeth forBlock:(Blk)swizzledBlock;

/*!  AG says: This compensates for NSObject's inability to set a selector for a key...
    Implementations of shadyValueForKey: and shadySetValue:forKey: Adapted from Mike Ash's "Let's Build KVC" article
    http://www.mikeash.com/pyblog/friday-qa-2013-02-08-lets-build-key-value-coding.html
    Original MAObject implementation on github at https://github.com/mikeash/MAObject 
    @see selectorForKey:
*/

￭

@interface View (AtoZSwizzles) _NA _Colr backgroundColor ___ ￭
