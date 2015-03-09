
//#import "M13OrderedDictionary.h"


@interface AZDict : NSMutableDictionary

- _Void_ setObject: anObject forKey: aKey;

@prop_NA BOOL sortByValues;
@prop_RO NSUInteger count;
@prop_RO NSEnumerator* reverseKeyEnumerator, *keyEnumerator;

//+ (instancetype) dictWithSortedDict:(NSD*)dict byValues:(BOOL)byV;

//- (id)objectForKey: aKey;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- _Void_ setObject: obj atIndexedSubscript:(NSUInteger)idx;
- _Void_ setObject: obj forKeyedSubscript:(id <NSCopying>)key;
- (id)objectForKeyedSubscript: key;

- _Void_ insertObject: anObject forKey: aKey atIndex:(NSUInteger)anIndex;
- (id)keyAtIndex:(NSUInteger)anIndex;

@end


@class NSBag;
//@interface NSOrderedDictionary (AtoZ)
//- _Void_ forwardInvocation:(NSINV*)invocation;
//- (SIG*) methodSignatureForSelector:(SEL)sel;
//- (BOOL) respondsToSelector:(SEL)selector;
//@end

// Catchall, adds "accessor" methods to doctionaries!
@interface NSDictionary (DynamicAccessors)
+ (BOOL) resolveInstanceMethod:(SEL)sel;
@end

@interface NSMutableDictionary (AtoZ)
  #if !TARGET_OS_IPHONE
- _Void_ setColor:(NSColor *)aColor forKey:(NSS*)aKey;
- (NSColor *)colorForKey:(NSS*)aKey;
#endif
- (BOOL)setObjectOrNull: anObject forKey: aKey;
@end

/** http://appventure.me/2011/12/fast-nsdictionary-traversal-in-objective-c.html
	supports retrieving individual NSArray entities during traversal.
	I.e.: ‘data.friends.data.0.name’ to access the first friends name

{
    "data": [{
        "location": {
            "id": "833",
            "latitude": 37.77956816727314,
            "longitude": -122.41387367248539,
            "name": "Civic Center BART"
        },
        "comments": {
            "count": 16,
            "data": [ ... ]
        },
        "caption": null,
        "link": "http://instagr.am/p/BXsFz/",
        "likes": {
            "count": 190,
            "data": [{
                "username": "shayne",
                "full_name": "Shayne Sweeney",
                "id": "20",
                "profile_picture": "..."
            }, {...subset of likers...}]
        }}]
} */

@interface NSDictionary (objectForKeyList)
- (id)objectForKeyList: key, ...;

- (id)objectMatching: match forKeyorKeyPath: kp;
@end
//	syntax of path similar to Java: record.array[N].item
//	items are separated by . and array indices in []
//	example: a.b[N][M].c.d
@interface  NSMutableDictionary (GetObjectForKeyPath)
- (id)objectForKeyPath:(NSS*)inKeyPath;
-(void)setObject: inValue forKeyPath:(NSS*)inKeyPath;
@end

@interface  NSObject  (BagofKeysValue)
- (NSBag*) bagWithValuesForKey:(NSS*)key;
@end

@interface NSDictionary (Types)

- (NSS*)stringForKey: key;
- (NSS*)stringForKey: key default:(NSS*)defaultValue;

- (NSN*)numberForKey: key default:(NSN*)defaultValue;
- (NSN*)numberForKey: key;

- (NSA*)arrayForKey: key default:(NSA*)defaultValue;
- (NSA*)arrayForKey: key;

@end 

/**  FIERCE

	NSD* whatever = @{@"colors" : NSC.colorLists};
		 colors =     {
        BlueSkyTulips = "NSColorList 0x7ff8f330e510 name:BlueSkyTulips device:(null) file:/Volumes/2T/ServiceData/Developer/Xcode/DerivedData/AtoZ-hfqteqfcvjfinlajqwkydsqyzpiz/Build/Products/Release/AtoZ.framework/Resources/BlueSkyTulips.clr loaded:1"; .........

	[whatever valueForKeyPath:@"@allKeys.colors"]	( OliveSunset,		    Bujumbura,		    "Classic Crayons",		    GrayScale,		    Monaco,		    Rainbow, ....		)
	[whatever valueForKeyPath:@"@allValues.colors"]
		{
		    "NSColorList 0x7f83435244c0 name:MossAndLichen device:(null) file:/Volumes/2T/ServiceData/Developer/Xcode/DerivedData/AtoZ-hfqteqfcvjfinlajqwkydsqyzpiz/Build/Products/Release/AtoZ.framework/Resources/MossAndLichen.clr loaded:1"
		etc...
		}
*/
//http://funwithobjc.tumblr.com/post/1527111790/defining-custom-key-path-operators
@interface NSDictionary (CustomKVCOperator)
- (id) _allValuesForKeyPath:(NSS*)keyPath;
- (id) _allKeysForKeyPath:(NSS*)keyPath;
@end


typedef void(^KeyValueIndexBlock)(id key, id obj, NSUI idx);
typedef void(^KeyValueIndexAbortBlock)(id key, id value, NSUI idx, BOOL *stop);

typedef id(^KeyValueToObjectBlock)(id k, id v);
typedef void(^KeyValueIteratorBlock)(id key, id obj);


@interface NSDictionary (AtoZ)


@prop_RO id randomValue, randomKey;

+ (NSD*) withFile:(NSS*)p;
@prop_RO VAL* oldVal, *newVal;
@prop_RO NSN* oldNum, *newNum;

@prop_RO NSS* flattenedString;

- (NSA*) mapToArray:(KeyValueToObjectBlock)block;

- (NSS*) keyForValueOfClass:(Class)klass;

- _Void_ eachWithIndex:(KeyValueIndexAbortBlock)block;

-  (id) recursiveObjectForKey:(NSS*)k; /* fierce */  //- (NSA*) recursiveObjectsForKey:(NSS*)key;

- (NSD*) findDictionaryWithValue: value;
+ (NSD*) dictionaryWithValue: value forKeys:(NSA*)keys;
- (NSD*) dictionaryWithValue: value forKeys:(NSA*)keys;
- (NSD*) dictionaryWithValue: value forKey: key;
- (NSD*) dictionaryWithoutKey: key;
- (NSD*) dictionaryWithKey: newKey replacingKey: oldKey;

- _Void_ enumerateEachKeyAndObjectUsingBlock:(KeyValueIteratorBlock)block;

- _Void_ enumerateEachSortedKeyAndObjectUsingBlock:(KeyValueIndexBlock)block;
@end

@interface  NSArray (FindDictionary)
- (id)findDictionaryWithValue: value;
@end


@interface NSDictionary (OFExtensions)
/// Enumerate each key and object in the dictioanry.

- (NSD*)dictionaryWithObject: anObj forKey:(NSS*)key;
//- (NSD*)dictionaryByAddingObjectsFromDictionary:(NSD*)otherDictionary;

- (id)anyObject;
- (NSS*)keyForObjectEqualTo: anObj;

- (NSS*)stringForKey:(NSS*)key defaultValue:(NSS*)defaultValue;
//- (NSS*)stringForKey:(NSS*)key;

- (NSA*)stringArrayForKey:(NSS*)key defaultValue:(NSA*)defaultValue;
//- (NSA*)stringArrayForKey:(NSS*)key;

	// ObjC methods to nil have undefined results for non-id values (though ints happen to currently work)
- (float)floatForKey:(NSS*)key defaultValue:(float)defaultValue;
//- (float)floatForKey:(NSS*)key;
- (double)doubleForKey:(NSS*)key defaultValue:(double)defaultValue;
- (double)doubleForKey:(NSS*)key;

- (CGPoint)pointForKey:(NSS*)key defaultValue:(CGPoint)defaultValue;
//- (CGPoint)pointForKey:(NSS*)key;
- (CGSize)sizeForKey:(NSS*)key defaultValue:(CGSize)defaultValue;
- (CGSize)sizeForKey:(NSS*)key;
- (CGRect)rectForKey:(NSS*)key defaultValue:(CGRect)defaultValue;
- (CGRect)rectForKey:(NSS*)key;

	// Returns YES iff the value is YES, Y, yes, y, or 1.
//- (BOOL)boolForKey:(NSS*)key defaultValue:(BOOL)defaultValue;
//- (BOOL)boolForKey:(NSS*)key;

	// Just to make life easier
//- (int)intForKey:(NSS*)key defaultValue:(int)defaultValue;
//- (int)intForKey:(NSS*)key;
- (unsigned int)unsignedIntForKey:(NSS*)key defaultValue:(unsigned int)defaultValue;
- (unsigned int)unsignedIntForKey:(NSS*)key;

- (NSInteger)integerForKey:(NSS*)key defaultValue:(NSInteger)defaultValue;
- (NSInteger)integerForKey:(NSS*)key;

- (unsigned long long int)unsignedLongLongForKey:(NSS*)key defaultValue:(unsigned long long int)defaultValue;
- (unsigned long long int)unsignedLongLongForKey:(NSS*)key;
	// This seems more convenient than having to write your own if statement a zillion times
//- (id)objectForKey:(NSS*)key defaultObject: defaultObject;

//- (NSMutableDictionary *)deepMutableCopy;// NS_RETURNS_RETAINED;

//- (NSA*)copyKeys;
//- (NSMutableArray *)mutableCopyKeys;
//
//- (NSSet *)copyKeySet;
//- (NSMutableSet *)mutableCopyKeySet;

@end

@interface NSCountedSet (Votes)
/*!
 @brief	Returns the member of the receiver which has the
 highest count
 @details  Returns nil if there is more than one member with
 the highest count (a "tie").&nbsp;  Also returns nil if
 the receiver is empty.	*/
- (id)winner  ;
@end

//@interface NSArray (Subdictionaries)
//- (NSBag*) objectsInSubdictionariesForKey:(NSS*)key;
//@end

@interface NSDictionary (Subdictionaries)
/*!
 @brief	Assuming that the receiver's objects are also
 dictionaries (subdictionaries), returns a counted set of all
 the different values for a given key in all the subdictionaries.
 @details  The count of each item in the returned set is equal
 to the number of subdictionaries which had an equal item as
 the object for the given key.&nbsp; If none of the
 subdictionaries have an object for the given key and no
 defaultObject is given, returns an empty set.
 @param	defaultObject  An object which will be added to the
 result, one for each subdictionary in the receiver which has
 no object for the given key, or nil if you do not want any object
 added for missing objects.	*/

- (NSCountedSet*)objectsInSubdictionariesForKey: key
								  defaultObject: defaultObject;
@end
@interface NSDictionary (SimpleMutations)
/*!
 @brief	Returns a new dictionary, equal to the receiver
 except with a single key/value pair updated or removed.

 @details  Convenience method for mutating a single key/value
 pair in a dictionary without having to make a mutable copy,
 blah, blah...  Of course, if you have many mutations to make
 it would be more efficient to make a mutable copy and then do
 all your mutations at once in the normal way.
 @param	object  The new value for the key.  May be nil.
 If it is nil, the key is removed from the receiver if it exists.
 If it is non-nil and the key already exists, the existing
 value is overwritten with the new value
 @param	key  The key to be mutated.  May be nil; this method
 simply returns a copy of the receiver.
 @result   The new dictionary	*/
- (NSDictionary*)dictionaryBySettingValue: value
								   forKey: key ;

/*!
 @brief	Returns a new dictionary, equal to the receiver
 except with additional entries from another dictionary.

 @details  Convenience method combining two dictionaries.
 If an entry in otherDic already exists in the receiver,
 the existing value is overwritten with the value from
 otherDic
 @param	otherDic  The other dictionary from which entries
 will be copied.  May be nil or empty; in these cases the
 result is simply a copy of the receiver.
 @result   The new dictionary	*/
- (NSDictionary*)dictionaryByAddingEntriesFromDictionary:(NSDictionary*)otherDic ;

/*!
 @brief	Same as dictionaryByAddingEntriesFromDictionary:
 except that no existing entries in the receiver are overwritten.

 @details  If otherDic contains an entry whose key already exists
 in the receiver, that entry is ignored.
 @param	otherDic  The other dictionary from which entries
 will be copied.  May be nil or empty; in these cases the
 result is simply a copy of the receiver.
 @result   The new dictionary	*/
- (NSDictionary*)dictionaryByAppendingEntriesFromDictionary:(NSDictionary*)otherDic ;

/*!
 @brief	Given a dictionary of existing additional entries, a set of existing
 keys to be deleted, a dictionary new additional entries, and a set of
 new keys to be deleted, mutates the existing dictionary and set to reflect the
 new additions and deletions.

 @details  First, checks newAdditions and newDeletions for common
 members which cancel each other out, and if any such are found, removes
 them from both collections.  Then, for each remaining new addition, if
 a deletion of the same key exists, removes it ("cancels it out"),
 and if not, adds the entry to the existing additions.  Finally, for each
 remaining new deletion, if a addition of the same object exists,
 removes it ("cancels it out"), and if not, adds it to the existing
 deletions. */
+ (void)mutateAdditions:(NSMutableDictionary*)additions
			  deletions:(NSMutableSet*)deletions
		   newAdditions:(NSMutableDictionary*)newAdditions
		   newDeletions:(NSMutableSet*)newDeletions ;

@end

@interface NSDictionary (subdictionaryWithKeys)
- (NSDictionary*)subdictionaryWithKeys:(NSArray*)keys ;
@end

//@interface OrderedDictionary : NSMutableDictionary
//- _Void_ insertObject: anObject forKey: aKey atIndex:(NSUInteger)anIndex;
//- (id)keyAtIndex:(NSUInteger)anIndex;
//- (NSEnumerator *)reverseKeyEnumerator;
//@end


extern NSString *jsonIndentString;
extern const int jsonDoNotIndent;

@interface NSDictionary (BSJSONAdditions)

+ (NSD*)dictionaryWithJSONString:(NSS*)jsonString;
- (NSS*)jsonStringValue;

@end


@interface NSDictionary (PrivateBSJSONAdditions)

- (NSS*)jsonStringValueWithIndentLevel:(int)level;
- (NSS*)jsonStringForValue: value withIndentLevel:(int)level;
- (NSS*)jsonStringForArray:(NSA*)array withIndentLevel:(int)level;
- (NSS*)jsonStringForString:(NSS*)string;
- (NSS*)jsonIndentStringForLevel:(int)level;

@end

extern NSString *jsonObjectStartString,*jsonObjectEndString,*jsonArrayStartString,*jsonArrayEndString;
extern NSString *jsonKeyValueSeparatorString, *jsonValueSeparatorString, *jsonStringDelimiterString;
extern NSString *jsonStringEscapedDoubleQuoteString, *jsonStringEscapedSlashString;
extern NSString *jsonTrueString, *jsonFalseString, *jsonNullString;


@interface NSScanner (PrivateBSJSONAdditions)

- (BOOL)scanJSONObject:(NSDictionary **)dictionary;
- (BOOL)scanJSONArray:(NSArray **)array;
- (BOOL)scanJSONString:(NSString **)string;
- (BOOL)scanJSONValue:(id *)value;
- (BOOL)scanJSONNumber:(NSNumber **)number;

- (BOOL)scanJSONWhiteSpace;
- (BOOL)scanJSONKeyValueSeparator;
- (BOOL)scanJSONValueSeparator;
- (BOOL)scanJSONObjectStartString;
- (BOOL)scanJSONObjectEndString;
- (BOOL)scanJSONArrayStartString;
- (BOOL)scanJSONArrayEndString;
- (BOOL)scanJSONStringDelimiterString;

@end
