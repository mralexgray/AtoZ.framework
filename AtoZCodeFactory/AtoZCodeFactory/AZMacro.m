
//- (NSMD*) propertyList { return _propertyList = _propertyList ?: _fileURL ? [NSMD dictionaryWithContentsOfURL:_fileURL] : nil; }

#import "AZMacro.h"
#import <AtoZ/AtoZ.h>

@implementation AZMacro

- (id)initWithPlistURL:(NSURL *)plistURL {
    self = [super init];
    if (self) {
        self.fileURL = plistURL;
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:plistURL.path];
        [self updatePropertiesFromDictionary:plist];
    }
    return self;
}

- (void)updatePropertiesFromDictionary:(NSDictionary *)plist {
    self.title    = plist[@"IDECodeSnippetTitle"];
    self.uuid     = plist[@"IDECodeSnippetIdentifier"];
    self.platform = plist[@"IDECodeSnippetPlatform"];
    if (!self.platform) self.platform = @"All";
    self.language = [((NSString *)plist[@"IDECodeSnippetLanguage"]) stringByReplacingOccurrencesOfString:@"Xcode.SourceCodeLanguage." withString:@""];
    self.summary  = plist[@"IDECodeSnippetSummary"];
    self.contents = plist[@"IDECodeSnippetContents"];
    self.shortcut = plist[@"IDECodeSnippetCompletionPrefix"];
    self.scopes   = plist[@"IDECodeSnippetCompletionScopes"];
}

- (BOOL)persistChanges {
    if ([self validate]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:self.fileURL.path])
            [fm createFileAtPath:self.fileURL.path contents:nil attributes:nil];
        return [[self propertyList] writeToFile:self.fileURL.path atomically:YES];
    }
    return NO;
}

- (BOOL)validate {
    return self.uuid && self.shortcut && self.contents;
}

- (NSDictionary *)propertyList {
    NSMutableDictionary *properties = @{
        @"IDECodeSnippetTitle": self.title?:@"",
        @"IDECodeSnippetIdentifier": self.uuid?:@"",
        @"IDECodeSnippetPlatform": self.platform?:@"",
        @"IDECodeSnippetLanguage": [NSString stringWithFormat:@"Xcode.SourceCodeLanguage.%@", self.language],
        @"IDECodeSnippetSummary": self.summary?:@"",
        @"IDECodeSnippetContents": self.contents?:@"",
        @"IDECodeSnippetCompletionPrefix": self.shortcut?:@"",
        @"IDECodeSnippetCompletionScopes": self.scopes?:@[],
        @"IDECodeSnippetUserSnippet": @YES,
        @"IDECodeSnippetVersion": @2
    }.mutableCopy;

    if (self.platform && ![self.platform isEqual:@"All"]) {
        properties[@"IDECodeSnippetPlatform"] = self.platform;
    }

    return properties;
}

+ (NSSet *)keyPathsForValuesAffectingUuid {
    return [NSSet setWithObjects:@"title",@"platform",@"language",@"summary",@"contents",@"shortcut", nil];
}

@end


/*
@synthesize title,uuid,platform,summary, language, contents, shortcut, scopes, fileURL = _fileURL, propertyList = _propertyList;

+ (instancetype) macroWithPlistURL:(NSURL*)plistURL 	{ return [self.alloc initWithPlistURL:plistURL]; }

- (instancetype) initWithPlistURL:(NSURL*)plistURL 	{ if (self != super.init) return self;

	_fileURL = plistURL.copy;
	NSString *s = _fileURL.path;
	NSLog(@"file:@ ,., %@", [AZFILEMANAGER fileExistsAtPath:s] ? @"exists!" :@"doesnt exist!");
//	NSDictionary *plist =
	_propertyList =  [[NSDictionary dictionaryWithContentsOfFile:s]mutableCopy];
//	__block DCParserConfiguration *config = [DCParserConfiguration configuration];
//	NSLog(@"plist:%@",plist);
	NSDictionary *map =
	@{ 	@"title" 	: @"IDECodeSnippetTitle",
			@"uuid"		: @"IDECodeSnippetIdentifier",
 	   	@"platform"	: @"IDECodeSnippetPlatform",
    		@"summary"	: @"IDECodeSnippetSummary",
//			@"language"	: [(NSString*)plist[@"IDECodeSnippetLanguage"]
//								stringByReplacing:@"Xcode.SourceCodeLanguage." with:@""] ?: @"N/A",
    		@"contents"	: @"IDECodeSnippetContents",
    		@"shortcut"	: @"IDECodeSnippetCompletionPrefix"
//   	 	@"scopes"	:	@"IDECodeSnippetCompletionScopes"
	};
	[map enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		id x = [_propertyList vFK:obj];
		NSLog(@"valueforkey:%@  obj:%@  %@",key, obj,x);
		if (x)
		[self bind:key toObject:_propertyList withKeyPath:obj nilValue:@""];//obj$(@"propertyList.%@",obj) nilValue:@""];
		// transform:
	}];
//	[map enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//
//		id x = plist[obj];
//		if (x)
////		NSLog(@"mapping: ")
//			[config addObjectMapping:[DCObjectMapping mapKeyPath:key toAttribute:obj onClass:self.class]];
//	}];
//	DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:self.class  andConfiguration:config];
	return self;// = [parser parseDictionary:plist] ? self : nil;
}

//- (id) valueForKey:(NSString*)key { if (!_propertyList) return nil;

//- (void) setFileURL:(NSURL *)fileURL {


//_objcase(key)
//
//	@{ @"title":@"IDECodeSnippetTitle",
//    self.uuid     = plist[@"IDECodeSnippetIdentifier"];
//    self.platform = plist[@"IDECodeSnippetPlatform"];
//    if (!self.platform) self.platform = @"All";
//    self.language = [((NSString *)plist[@"IDECodeSnippetLanguage"]) stringByReplacingOccurrencesOfString:@"Xcode.SourceCodeLanguage." withString:@""];
//    self.summary  = plist[@"IDECodeSnippetSummary"];
//    self.contents = plist[@"IDECodeSnippetContents"];
//    self.shortcut = plist[@"IDECodeSnippetCompletionPrefix"];
//    self.scopes   = plist[@"IDECodeSnippetCompletionScopes"];
//}

- (BOOL)persistChanges {
    if ([self validate]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:self.fileURL.path])
            [fm createFileAtPath:self.fileURL.path contents:nil attributes:nil];
        return [[self propertyList] writeToFile:self.fileURL.path atomically:YES];
    }
    return NO;
}

- (BOOL)validate {
    return self.uuid && self.shortcut && self.contents;
}

//- (NSDictionary *)propertyList {
//    NSMutableDictionary *properties = @{
//        @"IDECodeSnippetTitle": self.title?:@"",
//        @"IDECodeSnippetIdentifier": self.uuid?:@"",
//        @"IDECodeSnippetPlatform": self.platform?:@"",
//        @"IDECodeSnippetLanguage": [NSString stringWithFormat:@"Xcode.SourceCodeLanguage.%@", self.language],
//        @"IDECodeSnippetSummary": self.summary?:@"",
//        @"IDECodeSnippetContents": self.contents?:@"",
//        @"IDECodeSnippetCompletionPrefix": self.shortcut?:@"",
//        @"IDECodeSnippetCompletionScopes": self.scopes?:@[],
//        @"IDECodeSnippetUserSnippet": @YES,
//        @"IDECodeSnippetVersion": @2
//    }.mutableCopy;
//
//    if (self.platform && ![self.platform isEqual:@"All"]) {
//        properties[@"IDECodeSnippetPlatform"] = self.platform;
//    }
//
//    return properties;
//}

+ (NSSet *)keyPathsForValuesAffectingUuid {
    return [NSSet setWithObjects:@"title",@"platform",@"language",@"summary",@"contents",@"shortcut", nil];
}


//- (id)initWithPlistURL:(NSURL *)plistURL {
//	return self = [super init] ?
//	_fileURL = plistURL,
//	[self updatePropertiesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistURL.path]], self : nil;
//}

//- (void)updatePropertiesFromDictionary:(NSDictionary*)plist {
//	self.title    = plist[@"IDECodeShortcutTitle"];
//	self.uuid     = plist[@"IDECodeShortcutIdentifier"];
//	self.platform = plist[@"IDECodeShortcutPlatform"] ?: @"All";
//	self.language = [plist[@"IDECodeShortcutLanguage"]
//							stringByReplacingOccurrencesOfString:@"Xcode.SourceCodeLanguage."
//							withString:@""];
//	self.summary  = plist[@"IDECodeShortcutSummary"];
//	self.contents = plist[@"IDECodeShortcutContents"];
//	self.shortcut = plist[@"IDECodeShortcutCompletionPrefix"];
//	self.scopes   = plist[@"IDECodeShortcutCompletionScopes"];
//}

//- (BOOL)persistChanges {
//	if (![self validate]) return  NO;
//	if (![NSFileManager.defaultManager fileExistsAtPath:_fileURL.path])
//		[NSFileManager.defaultManager createFileAtPath:_fileURL.path contents:nil attributes:nil];
//	return [self.propertyList writeToFile:_fileURL.path atomically:YES];
//}

//- (BOOL)validate {	return _uuid && _shortcut && _contents;	}

//- (NSDictionary *)propertyList {
//	NSMutableDictionary *properties = @{
//													@"IDECodeShortcutTitle": self.title?:@"",
//													@"IDECodeShortcutIdentifier": self.uuid?:@"",
//													@"IDECodeShortcutPlatform": self.platform?:@"",
//													@"IDECodeShortcutLanguage": [NSString stringWithFormat:@"Xcode.SourceCodeLanguage.%@", _language],
//													@"IDECodeShortcutSummary": self.summary?:@"",
//													@"IDECodeShortcutContents": self.contents?:@"",
//													@"IDECodeShortcutCompletionPrefix": self.shortcut?:@"",
//													@"IDECodeShortcutCompletionScopes": self.scopes?:@[],
//													@"IDECodeShortcutUserShortcut": @YES,
//													@"IDECodeShortcutVersion": @2
//													}.mutableCopy;
//	properties[@"IDECodeShortcutPlatform"] = _platform && ![_platform isEqual:@"All"] ?
//	self.platform : properties[@"IDECodeShortcutPlatform"];
//	return properties;
//}

//+ (NSSet *)keyPathsForValuesAffectingUuid {
//	return [NSSet setWithObjects:@"title",@"platform",@"language",@"summary",@"contents",@"shortcut", nil];
//}

@end
*/

