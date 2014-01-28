#import "AtoZ.h"
#import "AZGit.h"
#import "NSObject+StrictProtocols.h"


//	NSLog(@"AZGists init:%@. Impolements IBProto:%@",	self,	StringFromBOOL([self implementsProtocol:@protocol(IBSingleton)]) );
//- (id) content { 	return self->_content = _content ?: ; }
//- (void) setUp {  AZLOGCMD; _content = @[[NSTN treeNodeWithRepresentedObject:@"GISTS"]].mutableCopy; }
//		[unoGisto.properties[@"AZGist"] each:^(id sender) {	NSLog(@"%@...%@",sender,[unoGisto vFK:sender]);	}];
//		JATLog(@"obj.desc:{0} gisto.desc:{1}", obj[@"description"],unoGisto.description);
//		NSTreeNode *gistNodes;
//		_tc.content = @[gistNodes = [NSTreeNode treeNodeWithRepresentedObject:@"GISTS"]].mutableCopy;
//		[gists each:^(NSD*gist){ XX(gist);
//			[gistNodes.mutableChildNodes addObject:[NSTreeNode treeNodeWithRepresentedObject:[AZGist instanceWithDictionary:gist]]];
//		}];
//- (NSArray*) childNodes {
//	return [self.properties[@"AZGist"] cw_mapArray:^id(id object) {
//		id myVal = [self vFK:object];
//		return myVal ? [NSTN treeNodeWithRepresentedObject:@{object:myVal}] : nil;
//	}];
//}

@implementation AZGist
- (BOOL) isLeaf { return _files.count == 1 || !_files.count; } //  > 1; XX(leafy); return leafy; }
+ (instancetype)instanceWithDictionary:(NSD*)dict {
	AZGist *g = self.new;
	[g setWithDictionary:dict];
	return g;
}

- (void) setWithDictionary:(NSDictionary *)dict {

  NSDateFormatter *dateFormat = NSDateFormatter.new;	//	WithDateFormat:@"yyyy/MM/dd hh:mm:ss" //allowNaturalLanguage:NO];
	dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
// "created_at" : "2011-12-04T13:52:43Z",
//    NSLog(@"%@", [aDictionary objectForKey:@"created_at"]);
//	NSObject+setValuesForKeysWithJSONDictionary
	self.created			= [dateFormat dateFromString:dict[@"created_at"]]; //	NSLog(@"formatted... %@", self.created);//
	self.description  = [dict objectForKey:@"description"];
	self.owner				=	[dict objectForKey:@"owner"];
	self.files 	 	 		= //NSMA.new;

	[((NSD*)dict[@"files"]).allKeys map:^id(id file) {

		AZGistFile *f =  AZGistFile.instance;
		id x = dict[@"files"][file];
		if (x) {
			[x  enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				if (obj && [f canSetValueForKey:key]) [f sV:obj fK:key];
			}];
		}
		return f;
	}].mutableCopy;
//	if (_files) [_files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		id xx = [obj vFK:@"language"];
//		if (xx && [xx ISKINDA:NSS.class]) self.language = [AZGistLanguage languageNamed:xx];
//		*stop = _language != nil;
//	}];
//*/
//	self.language = [AZGistLanguage languageNamed:@"shell"];
	self.isPublic			= [dict boolForKey:@"public"];
	self.repository		= [dict objectForKey:@"repo"];

}

@end

@implementation AZGists
//- (id)initWithCoder:(NSCoder*)aDec{ self = [super initWithCoder:aDec]; 	AZLOGCMD;
//	self.content = @[[NSTN treeNodeWithRepresentedObject:@"GISTS"]].mutableCopy;	return self;
//}
- (void) addGists:(id)content {

//NSA *rawGists; AZLOGCMD; NSAssert([rawGists = content ISKINDA:NSA.class], @"content needs to be a raw array");

	[content enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		AZGist *unoGisto = [AZGist instanceWithDictionary:obj];
		if (!unoGisto) return;
//		NSLog(@"uoGistso language:%@", unoGisto);
		[self addObject:unoGisto];
//		if (unoGisto && self.content && [self.content count]) [[self.content[0] mutableChildNodes] addObject:unoGisto];
//		JATLog(@"self.content:{0}  ct:{1}", self.content, [self.content count]);
	}];
}
@end

NSString *taskWithPathAndArgs(NSString*path,NSArray *args){

    NSTask *task								= NSTask.new;
    task.currentDirectoryPath		= @"/tmp";
    task.environment						= NSProcessInfo.processInfo.environment;
    task.launchPath							= path;
    if (args) task.arguments		= args;
    NSPipe *filePipe						= NSPipe.pipe;
    task.standardOutput					= filePipe;
    task.standardError					= filePipe;
    NSFileHandle *file					= filePipe.fileHandleForReading;  task.launch;				 task.waitUntilExit;
    NSData *data								= file.readDataToEndOfFile;				task.waitUntilExit;  file.closeFile;
    return [[NSString stringWithData:data encoding:NSUTF8StringEncoding] stringByDeletingSuffix:@"\n"];
}

@implementation AZGit

+ (NSString*) lookupUsername {  //try to get the github username

		NSString *gitname = taskWithPathAndArgs(self.gitPath,@[@"config", @"--global", @"github.user"]);
    if(gitname && gitname.length) return gitname;
    //try to get the git username
    NSString *username = taskWithPathAndArgs(self.gitPath,@[@"config", @"--global", @"user.name"]);
    return username && username.length ? username : nil;
}

+ (NSArray *)searchLocations{
	return @[@"/opt/local/bin/git", @"/usr/bin/git", @"/sw/bin/git", @"/opt/git/bin/git", @"/usr/local/bin/git", @"/usr/local/git/bin/git", @"~/bin/git".stringByExpandingTildeInPath];
}

+ (NSString*) gitPath{    //try the enviorment variable
    char *path = getenv("GIT_PATH");  if(path) return [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
    for(NSString *location in self.searchLocations) if([AZFILEMANAGER fileExistsAtPath:location]) return location;
    return nil;
}
@end

		//try which
    //NSString *whichPath = [Git commandLineCallWithPath:@"/usr/bin/which" andArgs:[NSArray arrayWithObjects:@"git",nil]];
    //if(whichPath && ![whichPath isEqualToString:@""]){ return whichPath; }
    //try seach location;


//@implementation AZGistLanguagesController
//
//- (void) setUp {
//
//	NSD* d = [NSD dictionaryWithContentsOfFile:[AZFWORKBUNDLE pathForResource:@"GithubLanguages" ofType:@"plist"]];
//	self.content = NSMA.new;
//	[d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//		AZGistLanguage *l = AZGistLanguage.instance;
//		[l setValuesForKeysWithDictionary:obj];
//		if (l) [self.content addObject:l];
//	}];
//}
//
//@end

@implementation AZGistFile

- (BOOL) isLeaf { return YES; }
@end
@implementation AZGistLanguage
static NSD* d = nil;
+ (instancetype) languageNamed:(NSS*)s {

static NSA* langs = nil;
	d = d ?: [NSD dictionaryWithContentsOfFile:[AZFWORKBUNDLE pathForResource:@"GithubLanguages" ofType:@"plist"]];
	AZGistLanguage *l = AZGistLanguage.new;
	[d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if ([key caseInsensitiveCompare:s]) {
			[l setValuesForKeysWithDictionary:obj];
			*stop = YES;
		}
	}];
	return l;
}
//@property NSS * extension, *type, *name;
//@property NSA * aliases, *extensions;




@end