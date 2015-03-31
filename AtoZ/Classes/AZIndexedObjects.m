

#import <AtoZ/AtoZ.h>
#import "AZIndexedObjects.h"


@interface AZIndexedObjects ()
@property NSMD*map;
@end
#define IDX(_x_) @(_x_).stringValue

@implementation AZIndexedObjects

-   (id) init {  return self = super.init ? _map = NSMD.new, self : nil; }
-   (id) objectAtIndex:	(NSUI)idx {

  if ([_map.allKeys containsObject:IDX(idx)])
    return ((NUWeakReference*)_map[IDX(idx)]).ref;
  else return nil;
}

-  (NSI) indexOfObject:	(id)x {

	return (![_map.allValues containsObject:x]) ? NSNotFound : 
          [[_map keyForObjectEqualTo:x] iV];
}
- (void) addObject:x                              {	_map[[_map.allKeys maxNumberInArray].stringValue] = x;	}
- (void) addObject:x atIndex:_SInt_ i             { _map[IDX(i)] = x; 				}
- (void) setObject:x atIndexedSubscript:_SInt_ i  { _map[IDX(i)] = x; 				}
-   (id) objectAtIndexedSubscript:_SInt_ i        { return _map[IDX(i)];			}


@end
