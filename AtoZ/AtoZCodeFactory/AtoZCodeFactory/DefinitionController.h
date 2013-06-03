
@interface AZFile : NSObject <NSCoding, NSCopying>
@property (readonly) NSData 	*data;   		// For archiving.
@property (readonly) NSD 		*fileInfo;		// Convenience.
@property (readonly) NSN 		*fileModified;
@property (readonly) BOOL 		fileExists, 
										outdated;
@property (nonatomic) NSN 		*savedDate;
@property (nonatomic) NSURL 	*URL;

+ (instancetype) fileWithPath:(NSString*)p;
+ (instancetype) fileWithData:  (NSData*)d;
@end

@class AZFactoryView;
@interface		  DefinitionController : NSObject <NSApplicationDelegate,NSTextFieldDelegate,NSTextViewDelegate,AtoZNodeProtocol,NSPathControlDelegate>

@property (readonly)  	   NSS * generatedHeaderStr;
@property (nonatomic) 	   NSD * plistData; 
@property (nonatomic)      NSW * window;
@property (nonatomic)   AZNode * root;
@property (nonatomic)   AZFile * generatedHeader,	* pList, 		* thisTool;
@property 			        NSMA * allReplacements,	* allKeywords,	* allCats;	
@property 			    NSNumber * matched;									
@property 		  AZFactoryView * view;

- (BOOL) saveGeneratedHeader;

@end
