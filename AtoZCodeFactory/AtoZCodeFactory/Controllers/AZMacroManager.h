
#import <Foundation/Foundation.h>
#import "AZMacro.h"

@interface AZMacroManager : NSTreeController <NSFilePresenter>

//@property (nonatomic,strong)      NSMutableArray * allReplacements,	* allKeywords,	* allCats;

//@property (nonatomic,strong) NSString					*plistPath;
//@property (nonatomic,strong) NSString					*generatedHeaderStr;
//@property (readonly)							NSMutableDictionary 	*plistData;
//@property (nonatomic,strong) NSDate 					*savedDate;
//@property (readonly) BOOL   			 					fileExists,
//												 					outdated;

@property (nonatomic,strong) 	NSTreeNode 				*shortcuts;

+ (instancetype) instanceWithPlist:(NSURL*)url;

- (AZMacro*)createShortcut;
- (BOOL)deleteShortcut:(AZMacro*)shortcut;

///////////

//@property (readonly) NSData 	*data;		// For archiving.
//@property (readonly) NSDictionary 		*fileInfo;	// Convenience.
//
//+ (instancetype) fileWithPath:(NSString*)p;
//+ (instancetype) fileWithData:  (NSData*)d;


//- (BOOL) saveGeneratedHeader;
//- (void) saveKeyPairsWithSeperator:(NSString*)sep toFile:(NSString*)path;

@end
