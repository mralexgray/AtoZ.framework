
#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NUExtensions)

/**
 
 objectForKey:computeIfNil:
 
 \brief Gives the opportunity for the caller to specify how to compute the
        value of a missing dictionary key. Results of the computation are
        cached in the dictionary.
 
 \param in key     Key to lookup in the dictionary.
 
 \param in block   Block get called if the dictionary does not have `key`.
                   The result of the block gets cached in the dictionary
                   under `key`. If `block` is nil then the semantics are
                   the same as objectForKey:.
 
 */
- (id) objectForKey:(NSString*)key computeIfNil:(id(^)(void))block;

@end
