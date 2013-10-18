
#import "AZMacroManager.h"


static NSString *SNIPPET_RELATIVE_DIRECTORY = @"Library/Developer/Xcode/UserData/CodeSnippets";
static NSString *SNIPPET_EXTENSION = @"codesnippet";

@implementation AZMacroManager

- (id)init { if (self != [super init]) return nil;
    if (self) {
//        [self loadSnippets];
        [NSFileCoordinator addFilePresenter:self];
    }
    return self;
}

- (NSURL *)snippetDirectory {
    return [NSURL fileURLWithPathComponents:@[NSHomeDirectory(), SNIPPET_RELATIVE_DIRECTORY]];
}

- (AZMacro*)createSnippet {
    AZMacro *snippet = AZMacro.new;
    snippet.uuid     = [NSUUID UUID];
    snippet.title    = @"Untitled snippet";
    snippet.fileURL  = [NSURL fileURLWithPathComponents:@[[self snippetDirectory].path, [NSString stringWithFormat:@"%@.codesnippet", [snippet.uuid UUIDString]]]];
    return snippet;
}

- (BOOL)deleteSnippet:(AZMacro*)snippet {
    NSError *error = nil;

    [[NSFileManager defaultManager] removeItemAtPath:snippet.fileURL.path error:&error];

    if (!error) return YES;
    
    NSLog(@"Error deleting snippet: %@, %@", error, [error userInfo]);
    return NO;
}

#pragma mark - NSFilePresenter methods

- (NSURL *)presentedItemURL {
    return [self snippetDirectory];
}

- (NSOperationQueue *)presentedItemOperationQueue {
    return [NSOperationQueue mainQueue];
}

- (void)accommodatePresentedSubitemDeletionAtURL:(NSURL *)url completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"Deleting snippet at %@", url.path);
    if (![self isSnippetURL:url]) return;

    AZMacro *snippet = [self.class instanceWithPlist:url];
    [NSNotificationCenter.defaultCenter postNotificationName:@"me.delisa.Attica.snippet-deletion" object:snippet];
    [self.shortcuts.mutableChildNodes removeObject:snippet];
    completionHandler(nil);
}

- (void)presentedSubitemDidAppearAtURL:(NSURL *)url {
    if (![self isSnippetURL:url]) return;

    NSLog(@"Adding snippet at %@", url.path);
    AZMacro *snippet = [AZMacro.alloc initWithPlistURL:url];
    [self.shortcuts.mutableChildNodes addObject:snippet];
}

- (void)presentedSubitemDidChangeAtURL:(NSURL *)url {
    if (![self isSnippetURL:url]) return;

    NSLog(@"Updating snippet at %@", url.path);
    AZMacro *snippet = [self.class instanceWithPlist:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:url.path];
        if (snippet) {
//            [snippet updatePropertiesFromDictionary:plist];
        } else {
            snippet = [[AZMacro alloc] initWithPlistURL:url];
            [self.shortcuts.mutableChildNodes addObject:snippet];
        }
    } else {
        [self.shortcuts.mutableChildNodes removeObject:snippet];
    }
}

- (void)presentedSubitemAtURL:(NSURL *)oldURL didMoveToURL:(NSURL *)newURL {
    if (![self isSnippetURL:oldURL]) return;

    AZMacro *snippet = [self.class instanceWithPlist:oldURL];
    snippet.fileURL = newURL;
}

#pragma mark - Private

- (BOOL)isSnippetURL:(NSURL *)url {
    return [[url.path pathExtension] isEqualToString:SNIPPET_EXTENSION];
}
/**
- (void)loadSnippets {

//    self.shortcuts = self.conten
    @try {
//        NSString *path = [self snippetDirectory].path;
		for (NSString *directoryEntry in  [[NSFileManager defaultManager]contentsOfDirectoryAtPath:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>


        while (directoryEntry = [enumerator nextObject]) {
            if ([directoryEntry hasSuffix:SNIPPET_EXTENSION]) {
                [self.snippets addObject:[[AZMacro alloc] initWithPlistURL:[NSURL fileURLWithPathComponents:@[path, directoryEntry]]]];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception occurred while loading snippets: %@", exception);
    }
    NSLog(@"%ld Snippets Loaded.", (unsigned long)self.shortcuts.childNodes.count);
}

//- (AZMacro *)snippetByURL:(NSURL *)snippetURL {
//
//    NSIndexSet *indices = [self.snippets indexesOfObjectsPassingTest:^BOOL(AZMacro *snippet, NSUInteger idx, BOOL *stop) {
//        return  [snippet.fileURL isEqual:snippetURL];
//    }];
//
//    if (indices.count > 0) {
//        return self.snippets[[indices firstIndex]];
//    }
//    return nil;
//}

@implementation AZMacroManager

- (instancetype) init {
	return self = super.init ? _plistPath = @"/Volumes/2T/ServiceData/AtoZ.framework/AtoZMacroDefines.plist", self : nil;
}

+ (instancetype) instanceWithPlist:(NSString*)path {

	AZMacroManager *man; return man = AZMacroManager.new ? man.plistPath = path.copy, man : nil;
}

-   (NSMutableDictionary*) plistData				{

//	return _plistData = _plistData ?:  ^(NSMutableDictionary*){  / * parse the plist * /

		NSError 	*e 	= nil;		NSData 	*data	= nil; NSPropertyListFormat fmt;

		if (![NSFileManager.defaultManager fileExistsAtPath:self.plistPath])
			return NSLog(@"Plist URL is wrong! (%@)",self.plistPath ),(id)nil;

		NSString* s = [NSString stringWithContentsOfFile:_plistPath encoding:NSUTF8StringEncoding error:&e];
		data = [s dataUsingEncoding:NSUTF8StringEncoding];

		NSString *errorDesc = nil;

		return [(NSDictionary*)[NSPropertyListSerialization
                                      propertyListFromData:data
                                      mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                      format:&fmt
                                      errorDescription:&errorDesc]mutableCopy];
//						return _plistData;
//	}();


//		return _plistData = [ proper
//		dataUsingEncoding:NSUTF8StringEncoding];


//		_plistData = [NSPropertyListSerialization dataWithPropertyList: format:NSPropertyListImmutable options:<#(NSPropertyListWriteOptions)#> error:<#(out NSError *__autoreleasing *)#> mutabilityOption:NSPropertyListImmutable format:&fmt errorDescription:&error];


//		if (data != [NSData :self.plistPath])
//			return NSLog(@"could not make data from plist:Path:%@", _plistPath), (id)nil;

//		return [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&fmt error:&e];
}

-   (NSTreeNode*) shortcuts  	{ return _shortcuts = _shortcuts ?: ^{	 _shortcuts = NSTreeNode.new;

		[self.plistData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			__block NSTreeNode *catNode = [NSTreeNode treeNodeWithRepresentedObject:key];
			[obj enumerateKeysAndObjectsUsingBlock: ^(NSString *macro,NSString *expansion, BOOL*s){
				//		NSLog(@"Added category:%@ class:%@", cat.key = key, NSStringFromClass([key class]));
				AZMacro *sc = AZMacro.new;
				sc.macro = macro;
				sc.expansion = expansion;
				NSTreeNode *defNode = [NSTreeNode treeNodeWithRepresentedObject:sc];
				[catNode.mutableChildNodes addObject:sc];

			}];
			[_shortcuts.mutableChildNodes	addObject:catNode];
		}];
		return _shortcuts;
	}();
}

-   (NSString*) generatedHeaderStr	{  // this "MAKES" the header

	__block NSString *define, *definition; __block NSUInteger pad, longest; __block NSMutableArray *keys;
	__block NSMutableString *definer = @"#import <QuartzCore/QuartzCore.h>\n".mutableCopy;  // put some other crap here ??
	[self.children enumerateObjectsUsingBlock:^(AZNode* category,NSUInteger idx,BOOL *stop) {
		[definer appendFormat:@"\n#pragma mark - %@\n\n", category.key];   // pragma section per "category"
		// figure out the longest member for pretty psacing.
		[keys = [[category.children valueForKeyPath:@"key"]mutableCopy] sortUsingComparator:^NSComparisonResult(NSString *s1, NSString *s2) {
			return 	s1.length < s2.length ? (NSComparisonResult) NSOrderedDescending :
						s1.length > s2.length ? (NSComparisonResult) NSOrderedAscending  : (NSComparisonResult)NSOrderedSame;
		}];
		longest = [keys[0] length];
		[category.children enumerateObjectsUsingBlock:^(AZNode *defineNode, NSUInteger idx, BOOL *stop) {
			if (!defineNode.key || [defineNode.key isEqualToString:@"Inactive"]) return; else definition = defineNode.key;
			pad 		= MAX(8, (NSInteger)(longest - definition.length + 8));
//			NSLog(@"def: %@  pad: %lu",definition, pad);  //  log ALL entries?
			define	= [@"#define" stringByPaddingToLength:pad withString:@" " startingAtIndex:0];
			[definer appendString:[define stringByAppendingFormat:@"%@ %@\n", definition, defineNode.value ?: @""]];
		}];
	}];		
	return definer;
}

- (NSOperationQueue*)presentedItemOperationQueue { return NSOperationQueue.mainQueue; }

- (NSURL*)shortcutDirectory {
    return [NSURL fileURLWithPathComponents:@[NSHomeDirectory(), SNIPPET_RELATIVE_DIRECTORY]];
}

- (AZShortcut *)createShortcut {
    AZShortcut *shortcut = AZShortcut.new;
    shortcut.uuid     = [NSUUID UUID];
    shortcut.title    = @"Untitled shortcut";
    shortcut.fileURL  = [NSURL fileURLWithPathComponents:@[self.shortcutDirectory.path, [NSString stringWithFormat:@"%@.codeshortcut", shortcut.uuid.UUIDString]]];
    return shortcut;
}

- (BOOL)deleteShortcut:(AZShortcut *)shortcut {
    NSError *error = nil;
    [NSFileManager.defaultManager removeItemAtPath:shortcut.fileURL.path error:&error];
    if (!error) return YES;
    NSLog(@"Error deleting shortcut: %@, %@", error, [error userInfo]);
    return NO;
}

#pragma mark - NSFilePresenter methods

- (NSURL *)presentedItemURL {    return [self shortcutDirectory];	}

- (void)accommodatePresentedSubitemDeletionAtURL:(NSURL *)url completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"Deleting shortcut at %@", url.path);
    if (![self isShortcutURL:url]) return;

    AZShortcut *shortcut = [self shortcutByURL:url];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"me.delisa.Attica.shortcut-deletion" object:shortcut];
    [self.shortcuts removeObject:shortcut];
    completionHandler(nil);
}

- (void)presentedSubitemDidAppearAtURL:(NSURL *)url {
    if (![self isShortcutURL:url]) return;

    NSLog(@"Adding shortcut at %@", url.path);
    AZShortcut *shortcut = [[AZShortcut alloc] initWithPlistURL:url];
    [self.shortcuts addObject:shortcut];
}

- (void)presentedSubitemDidChangeAtURL:(NSURL *)url {
    if (![self isShortcutURL:url]) return;

    NSLog(@"Updating shortcut at %@", url.path);
    AZShortcut *shortcut = [self shortcutByURL:url];
    if ([NSFileManager.defaultManager fileExistsAtPath:url.path]) {
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:url.path];
        if (shortcut)
            [shortcut updatePropertiesFromDictionary:plist];
        else {
            shortcut = [AZShortcut.alloc initWithPlistURL:url];
            [self.shortcuts addObject:shortcut];
        }
    } else
        [self.shortcuts removeObject:shortcut];
}

- (void)presentedSubitemAtURL:(NSURL *)oldURL didMoveToURL:(NSURL *)newURL {
    if (![self isShortcutURL:oldURL]) return;
    AZShortcut *shortcut = [self shortcutByURL:oldURL];
    shortcut.fileURL = newURL;
}

#pragma mark - Private

- (BOOL)isShortcutURL:(NSURL *)url {
    return [[url.path pathExtension] isEqualToString:SNIPPET_EXTENSION];
}

- (void)loadShortcuts {
    self.shortcuts = [NSMutableArray new];
    @try {
        NSDirectoryEnumerator *enumerator = [NSFileManager.defaultManager enumeratorAtPath:self.shortcutDirectory.path];
        NSString *directoryEntry;
        while (directoryEntry = [enumerator nextObject]) {
            if ([directoryEntry hasSuffix:SNIPPET_EXTENSION])
                [self.shortcuts addObject:[[AZShortcut alloc] initWithPlistURL:[NSURL fileURLWithPathComponents:@[self.shortcutDirectory.path, directoryEntry]]]];

        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception occurred while loading shortcuts: %@", exception);
    }
    NSLog(@"%ld Shortcuts Loaded.", (unsigned long)self.shortcuts.count);
}

- (AZShortcut *)shortcutByURL:(NSURL *)shortcutURL {
    NSIndexSet *indices = [self.shortcuts indexesOfObjectsPassingTest:^BOOL(AZShortcut *shortcut, NSUInteger idx, BOOL *stop) {
        return  [shortcut.fileURL isEqual:shortcutURL];
    }];

    if (indices.count > 0) {
        return self.shortcuts[[indices firstIndex]];
    }
    return nil;
}
*/

@end
