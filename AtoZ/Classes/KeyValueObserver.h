

//@interface NSO (KVOSpy)

//- (void) observe:(id)o key:(NSS*)k task:

#import <Foundation/Foundation.h>

@interface KeyValueObserver : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

/*! Create a Key-Value Observing helper object.
  @discussion As long as the returned token object is retained, the KVO notifications of the @c object
  and @c keyPath will cause the given @c selector to be called on @c target.
  @a object and @a target are weak references.
  Once the token object gets dealloc'ed, the observer gets removed.
  The @c selector should conform to
  
  @code  - (void)nameDidChange:(NSDictionary *)change; @endcode
  
  The passed in dictionary is the KVO change dictionary (c.f. @c NSKeyValueChangeKindKey, @c NSKeyValueChangeNewKey etc.)
  @returns the opaque token object to be stored in a property

  @code   self.nameObserveToken = [KeyValueObserver observeObject:user
                                                          keyPath:@"name"
                                                           target:self
                                                          elector:@selector(nameDidChange:)];
  @endcode  */
  
+ (NSObject*) observeObject:(id)o  keyPath:(NSString*)kp 
                     target:(id)t selector:(SEL)sel      __attribute__((warn_unused_result));

/// Create a key-value-observer with the given KVO options
+ (NSObject*) observeObject:(id)o  keyPath:(NSString*)kp 
                     target:(id)t selector:(SEL)sel 
                    options:(NSKeyValueObservingOptions)x __attribute__((warn_unused_result));

@end
