

@interface NSString (AssetType)
- (NSS*) wrapInHTML;
- (AssetType)assetFromString;
@end
#define AssetDataType @"AssetDataTypeFprTableViewDrag"


@interface Asset : BaseModel

@property (RONLY)			NSN			*priority;
@property (NATOM, STRNG)	NSS 		*path,
										*contents;
@property (NATOM, ASS) 		BOOL 		isInline,
									 	isActive;
@property (NATOM, ASS) 		AssetType 	assetType;
@property (NATOM, STRNG)	NSS 		*markup;


+ (instancetype) instanceOfType:(AssetType)type withPath:(NSS*)path orContents:(NSS*)contents isInline:(BOOL)isit;
@end

@interface AssetCollection : BaseModel
@property (NATOM, STRNG) NSMutableArray *folders, *assets;

// Subclass specific KVO Compliant "items" accessors to trigger NSArrayController updates on inserts / removals.
- (id)	 objectInAssetsAtIndex:		   			 (NSUI)idx;
- (void) removeObjectFromAssetsAtIndex:			 (NSUI)idx;
- (void) insertObject: (Asset*)a inAssetsAtIndex:(NSUI)idx;
- (NSUI) countOfAssets;

- (void) addFolder: (NSS*)path matchingType:(AssetType)fileType;
@end

@interface AssetTypeTransformer: NSValueTransformer
@end
