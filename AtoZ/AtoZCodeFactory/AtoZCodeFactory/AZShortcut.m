
#import "AZShortcut.h"

@implementation AZShortcut

- (id)initWithPlistURL:(NSURL *)plistURL {
	return self = [super init] ?
	_fileURL = plistURL,
	[self updatePropertiesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistURL.path]], self : nil;
}

- (void)updatePropertiesFromDictionary:(NSDictionary*)plist {
	self.title    = plist[@"IDECodeShortcutTitle"];
	self.uuid     = plist[@"IDECodeShortcutIdentifier"];
	self.platform = plist[@"IDECodeShortcutPlatform"] ?: @"All";
	self.language = [plist[@"IDECodeShortcutLanguage"]
							stringByReplacingOccurrencesOfString:@"Xcode.SourceCodeLanguage."
							withString:@""];
	self.summary  = plist[@"IDECodeShortcutSummary"];
	self.contents = plist[@"IDECodeShortcutContents"];
	self.shortcut = plist[@"IDECodeShortcutCompletionPrefix"];
	self.scopes   = plist[@"IDECodeShortcutCompletionScopes"];
}

- (BOOL)persistChanges {
	if (![self validate]) return  NO;
	if (![NSFileManager.defaultManager fileExistsAtPath:_fileURL.path])
		[NSFileManager.defaultManager createFileAtPath:_fileURL.path contents:nil attributes:nil];
	return [self.propertyList writeToFile:_fileURL.path atomically:YES];
}

- (BOOL)validate {	return _uuid && _shortcut && _contents;	}

- (NSDictionary *)propertyList {
	NSMutableDictionary *properties = @{
													@"IDECodeShortcutTitle": self.title?:@"",
													@"IDECodeShortcutIdentifier": self.uuid?:@"",
													@"IDECodeShortcutPlatform": self.platform?:@"",
													@"IDECodeShortcutLanguage": [NSString stringWithFormat:@"Xcode.SourceCodeLanguage.%@", _language],
													@"IDECodeShortcutSummary": self.summary?:@"",
													@"IDECodeShortcutContents": self.contents?:@"",
													@"IDECodeShortcutCompletionPrefix": self.shortcut?:@"",
													@"IDECodeShortcutCompletionScopes": self.scopes?:@[],
													@"IDECodeShortcutUserShortcut": @YES,
													@"IDECodeShortcutVersion": @2
													}.mutableCopy;
	properties[@"IDECodeShortcutPlatform"] = _platform && ![_platform isEqual:@"All"] ?
	self.platform : properties[@"IDECodeShortcutPlatform"];
	return properties;
}

+ (NSSet *)keyPathsForValuesAffectingUuid {
	return [NSSet setWithObjects:@"title",@"platform",@"language",@"summary",@"contents",@"shortcut", nil];
}

@end
