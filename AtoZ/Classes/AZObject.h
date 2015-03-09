

#import <objc/runtime.h>
//#import <Zangetsu/Zangetsu.h>
//#import "extobjc_OSX/extobjc.h"
//#import "AtoZCategories.h"


@protocol IBSingleton <NSObject> @optional - (void) setUp;
@concrete
+ allocWithZone:(NSZone*)z;
+ (instancetype) sharedInstance;
+ alloc; + _alloc;
- (id) init;	- (id) _init;
@end


@protocol AZPlistRepresentation <NSObject>
@concrete
@property (readonly) NSD* plistRepresentation;
@end

@interface AZArray : NSObject

+ (AZArray*)sharedArray;

- (void) addObject:(id)o;
- (NSUI) countOfObjects;
-   (id) objectInObjectsAtIndex:(NSUInteger)index;
@end


//@interface AZObject : NSObject <NSCoding, NSCopying, NSMutableCopying, AZPlistRepresentation>
//@end


@interface AZObject : NSObject <NSCoding, NSCopying> //,NSFastEnumeration>
+ (INST) instanceWithKeysAndObjects:(NSS*)key1,...;
@property id representedObject;
@prop_RO NSA *keys;
@end

// Shared instance is the object modified after each key change
//+ (AZObject*)sharedInstance;

//	After being notified of change to the shared instance,
//	call this to get last modified key of last modified instance
//+ (AZObject*)lastModifiedInstance;
//+ (NSString*)lastModifiedKey;
//@property (nonatomic, retain) NSString *lastModifiedKey;
//@property (nonatomic, retain) AZObject *lastModifiedInstance;
//@property (nonatomic, retain) AZObject *sharedInstance;
//@property (nonatomic, retain) NSString *uniqueID;

/*
@interface NSObject (NSCoding)

- (void) autoEncodeWithCoder: (NSCoder*)coder;
- (void) autoDecode:				(NSCoder*)coder;
//- (NSD*) properties;
- (NSD*) autoEncodedProperties;
@end
*/

