
#import "AZShortcutManager.h"

static NSString *SNIPPET_RELATIVE_DIRECTORY = @"Library/Developer/Xcode/UserData/CodeShortcuts";
static NSString *SNIPPET_EXTENSION = @"codeshortcut";

@implementation AZShortcutManager

- (id)init {    return self = super.init ?
        [self loadShortcuts],
        [NSFileCoordinator addFilePresenter:self], self : nil;
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

@end
