

#import "AZObject.h"


NSString *taskWithPathAndArgs(NSString*path,NSArray *args);

@interface AZGit : NSObject

+ (NSString*) lookupUsername;
+ (NSString*) gitPath;
@end

@interface AZGists : NSTreeController // <IBSingleton>
- (void) addGists:(id)content;
@end

@interface AZGistLanguage : NSTreeNode
+ (instancetype) languageNamed:(NSS*)s;
@property NSS * extension, *type, *name;
@property NSA * aliases, *extensions;
@end

@interface AZGist : NSO

@property (nonatomic) NSDate *created;
@property (nonatomic,copy) NSString *description, *owner, *repository;
@property (nonatomic) NSArray *files;
@property BOOL isPublic;
@property (readonly) BOOL isLeaf;
@property NSArray*fullURLs;
@property AZGistLanguage *language;
//- (NSString *)textForURL:(NSURL *)url;
//- (NSString *)cachedTextForFile:(NSString *)file;
//- (NSURL*)repositoryURL;
//- (void) penRepositoryURL;

@end
//@interface AZGistLanguagesController : NSArrayController <IBSingleton>
//@end

@interface AZGistFile : BaseModel
@property (nonatomic) AZGistLanguage *language;
@property (nonatomic) NSS* text;
@end


