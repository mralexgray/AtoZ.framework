

#define AssetDataType @"AssetDataTypeForTableViewDrag"

_EnumKind(AssetType, 	AssetTypeJS, 	AssetTypeCSS,  AssetTypeHTML5,
                          AssetTypePHP, AssetTypeBASH, AssetTypeObjC, AssetTypeTXT,
                          AssetTypeUNKNOWN = 99,
                          AssetTypeNotFound = NSNotFound );

//static NSArray* extensionsForAssetType(AssetType type);

@interface AssetController : NSTreeController


@end

@interface AssetCollection : NSMA

- (void) addFolder: (NSS*)path matchingType:(AssetType)fileType	printInline:(BOOL)printI;
_RO AssetType assetType;
+ (instancetype) instanceWithFolder:(NSS*)path matchingType:(AssetType)fileType printInline:(BOOL)isit;
@end

@interface Asset : BaseModel
@property (WK)	AssetController * controller;
@property               NSN * priority;
@property (CP)					NSS * path,
                            * contents;
@property				       BOOL  	printInline,
									 		        active;
@property (STR)				  NSB * bundle;
@property				  AssetType 	assetType;
@prop_RO				NSS * markup;
+ (instancetype) test;
+ (instancetype) instanceOfType:(AssetType)type withPath:(NSS*)path orContents:(NSS*)contents printInline:(BOOL)isit;
@end

@interface AssetTypeTransformer: NSValueTransformer	@end

@interface NSString (AssetType)
_RO NSS * wrapInHTML;
@end


// Subclass specific KVO Compliant "items" accessors to trigger NSArrayController updates on inserts / removals.
//-   (id)	objectInAssetsAtIndex:		   			 (NSUI)idx;
//- (void) removeObjectFromAssetsAtIndex:			 (NSUI)idx;
//- (void) insertObject: (Asset*)a inAssetsAtIndex:(NSUI)idx;
//- (NSUI) countOfAssets;
//extern NSString * const assetStringValue[],
//					 * const assetTagName[];
