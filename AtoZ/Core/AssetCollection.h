
#define AssetDataType @"AssetDataTypeForTableViewDrag"

extern NSString * const assetStringValue[];
extern NSString * const assetTagName[];

typedef NS_ENUM(NSUI,AssetType){ JS, CSS, HTML5, PHP, BASH,	ObjC, TXT, UNKNOWN = 99 };

@class AssetCollection;
@interface Asset : BaseModel

@property (WK)									AssetCollection *collection;
@property (NATOM, STRNG)	NSN			*priority;
@property (NATOM, STRNG)	NSS 			*path,
													*contents;
@property (NATOM, ASS) 		BOOL 			printInline,
									 				active;
@property (NATOM, ASS) 		AssetType 	assetType;
@property (RONLY)				NSS 			*markup;

+ (instancetype) instanceOfType:(AssetType)type withPath:(NSS*)path orContents:(NSS*)contents printInline:(BOOL)isit;
@end

@interface AssetCollection : BaseModel

@property (NATOM, STRNG) NSMutableArray *folders, *assets;

+ (instancetype) instanceWithFolder:(NSS*)path matchingType:(AssetType)fileType printInline:(BOOL)isit;
- (void) addFolder: (NSS*)path matchingType:(AssetType)fileType;

// Subclass specific KVO Compliant "items" accessors to trigger NSArrayController updates on inserts / removals.
-   (id)	objectInAssetsAtIndex:		   			 (NSUI)idx;
- (void) removeObjectFromAssetsAtIndex:			 (NSUI)idx;
- (void) insertObject: (Asset*)a inAssetsAtIndex:(NSUI)idx;
- (NSUI) countOfAssets;

@end

@interface AssetTypeTransformer: NSValueTransformer
@end
