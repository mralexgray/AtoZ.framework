
@interface AZMacro : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *contents;
@property (nonatomic, strong) NSString *shortcut;
@property (nonatomic, strong) NSArray *scopes;

- (id)initWithPlistURL:(NSURL *) plistURL;
- (void)updatePropertiesFromDictionary:(NSDictionary *)plist;
- (NSDictionary *)propertyList;
- (BOOL)persistChanges;
- (BOOL)validate;

//
//@property (nonatomic) 	NSURL *fileURL;
//@property 	NSUUID *uuid;
//@property 	NSString *platform,*language, *summary, *contents, *shortcut, *title;
//@property 	NSArray *scopes;
//
//@property NSMutableDictionary *propertyList;
//
//+ (instancetype) macroWithPlistURL:(NSURL*)plistURL;
//
//- (instancetype) initWithPlistURL:(NSURL*)plistURL;
//
//
//- (BOOL)persistChanges;
//- (BOOL)validate;

@end
