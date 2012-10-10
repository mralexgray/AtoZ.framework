/**
 
 \category  NSObject(NUExtensions)
 
 \brief     Adds a number of facilities to NSObject that are useful in a 
            general sense.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <Foundation/Foundation.h>

@interface NSObject (NUExtensions)

/**
 
 \brief     Returns the root model object and associated key path for a 
 potentially bound object key path pair.
 
 \details   The binding chain is followed until we find an object and
 a keyPath that are not bound. They are returned in `rootObject`
 and `rootKeyPath`.
 
 */
- (void) getRootModelObject:(id*)rootObject 
                 andKeyPath:(NSString**)rootKeyPath
                  forObject:(id)object
                 andKeyPath:(NSString*)keyPath
;


/**
 
 setValue:forPotentiallyBoundKeyPath:
 
 \brief   Semantics are the same as setValue:forKey.
 
 \details If `keyPath` is unbound then this is exactly the same as calling
          setValue:forKeyPath:. In the case where `keyPath` is bound 
          setValue:forPotentiallyBoundKeyPath: is called on the
          bound-to object and bound-to key-path.
 */
- (void) setValue:(id)value forPotentiallyBoundKeyPath:(NSString*)keyPath;


/**
 
 bind:toArray:atIndex:withKeyPath:options:
 
 \brief   Allow the caller to bind into an indexed collection.
 
 \details The key path should lead to an indexed collection that is KVC compliant.
          An exception is raised if `index` is out of range.
 
 */
- (void) bind:(NSString *)binding toArray:(NSArray*)array atIndex:(NSUInteger)index withKeyPath:(NSString*)keyPath options:(NSDictionary *)options;


/**
 
 \brief     Similar to setValue:forKeyPath:withUndoManager:andActionName:disableAnimations:.
 
 \details   In this case we can toggle between two user specified values.
 
 */
- (void) setUndoValue:(id)undoValue
            redoValue:(id)redoValue
           forKeyPath:(NSString *)keyPath
      withUndoManager:(NSUndoManager*)undoManager
        andActionName:(NSString*)actionName
    disableAnimations:(BOOL)shouldDisableAnimations
       skipAssignment:(BOOL)shouldSkipAssign
;


/**
 
 \brief     Calls willChangeValueForKey for each key.

 \details   List must be nil terminated.
 
 */
- (void) willChangeValueForKeys:(NSString*)key,...;


/**
 
 \brief     Calls willChangeValueForKey for each key in reverse order.
 
 \details   List must be nil terminated.
 
 */
- (void) didChangeValueForKeys:(NSString*)key,...;


/**
 
 \brief     If NSCoding is implemented then deep-copy of the object.
            Otherwise it returns a simple copy.
 
 */
- (id) deepCopyIfPossible;


/// Returns a formatted string containg all of the methods for the object.
/// The methods of NSObject are not included in the result.
@property (readonly) NSString *methodListDescrption;

@end
