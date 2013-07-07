
@interface ObjCFile : NSObject <NSCoding, NSCopying>


@property (readonly) NSData *data;	// For archiving.
@property (readonly) NSD *fileInfo;	// Convenience.
@property (readonly) NSN *fileModified;
@property (readonly) BOOL   fileExists,
									outdated;
@property (nonatomic, strong) NSN *savedDate;
@property (nonatomic, strong) NSURL * URL;

+ (instancetype) fileWithPath:(NSString*)p;
+ (instancetype) fileWithData:  (NSData*)d;
@end

@class AZFactoryView;
@interface		  DefinitionController : NSObject 
<
	NSApplicationDelegate, 
	NSTextFieldDelegate, 
	NSTextViewDelegate, 
	AtoZNodeProtocol,
	NSPathControlDelegate
>

//@property AtoZObjC *atozobjc;

@property (readonly)  	   NSS * generatedHeaderStr;
@property (nonatomic, strong) NSD 	*plistData; 
@property (nonatomic, strong) NSW 	*window;
@property (nonatomic, strong) AZNode * root;
@property (nonatomic, strong) ObjCFile * generatedHeader,	* pList, 		* thisTool;
//@property (nonatomic,strong)      NSMA * allReplacements,	* allKeywords,	* allCats;	
@property(strong)      NSNumber * matched;	
@property(strong) IBOutlet AZFactoryView * view;

- (BOOL) saveGeneratedHeader;
- (void) saveKeyPairsWithSeperator:(NSS*)sep toFile:(NSS*)path;

@end
