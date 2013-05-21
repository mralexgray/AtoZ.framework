/*
Suppose you want to observe your app's template folder, and you already have a function that returns it:

NSURL * MyTemplateFolderURL() {
    return [MyApplicationSupportDirectoryURL() URLByAppendingPathComponent:@"Templates" isDirectory:YES];
}
To begin observing, add one of your objects as an observer of the directory:

NSURL * templatesURL = MyTemplateFolderURL();
[templatesURL addDirectoryObserver:self options:0 resumeToken:nil];
Then implement three methods:

- (void)observedDirectory:(NSURL*)observedURL childrenAtURLDidChange:(NSURL*)changedURL historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken {
    NSLog(@"Files in %@ have changed!", changedURL.path);
}

- (void)observedDirectory:(NSURL*)observedURL descendantsAtURLDidChange:(NSURL*)changedURL reason:(ArchDirectoryObserverDescendantReason)reason historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken {
    NSLog(@"Descendents below %@ have changed!", changedURL.path);
}

- (void)observedDirectory:(NSURL*)observedURL ancestorAtURLDidChange:(NSURL*)changedURL historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken {
    NSLog(@"%@, ancestor of your directory, has changed!", changedURL.path);
}
When you're done observing, make sure you remove the observer:

NSURL * templatesURL = MyTemplateFolderURL();
[templatesURL removeDirectoryObserver:self];
Resume Tokens

ArchDirectoryObserver exposes the powerful FSEvents capability to observe changes that occurred in the past, when the app was not running.

This ability is used through the resumeToken: parameters to various methods. Each observation is associated with a resume token; if you later register an observer with that resume token, observation will resume from the moment after that change. That means you can save your last resume token to disk before quitting and then add the observer again with that resume token the next time you need it. In so doing, you can learn about changes that happend when your app wasn't running.

Resume tokens can be written to a property list or an NSCoder archive, so they're easy to save.

Options

You can tweak the way ArchDirectoryObserver observes your directory with two options:

ArchDirectoryObserverObservesSelf: By default, you won't observe changes made by your own process. Pass this parameter if you really do want to see them.

ArchDirectoryObserverResponsive: The default behavior does not notify you immediately of changes; it waits a few seconds and coalesces similar changes to avoid overwhelming your app with observations. This kind of lag isn't very good where the user can see it, though. This flag changes the coalescing algorithm to one that immediately notifies you of the first change and only coalesces subsequent changes.


*/
#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

// This opaque token is used to resume observation at a given point in time.  Each ArchDirectoryObserver callback passes you one; if you save it (in a plist or NSCoder archive) and pass it back in when registering the observer, observation will pick up where it left off, even if the process has quit since then.
typedef id <NSCopying, NSCoding> ArchDirectoryObservationResumeToken;


// These constants indicate the reason that the observation center believes a descendant scan is needed.
typedef enum {
    // You added an observer with a nil resume token, so the directory's history is unknown.
    ArchDirectoryObserverNoHistoryReason = 0,
    // The observation center coalesced events that occurred only a couple seconds apart.
    ArchDirectoryObserverCoalescedReason,
    // Events came too fast and some were dropped.
    ArchDirectoryObserverEventDroppedReason,
    // Event ID numbers have wrapped and so the history is not reliable.
    ArchDirectoryObserverEventIDsWrappedReason,
    // A volume was mounted in a subdirectory.
    ArchDirectoryObserverVolumeMountedReason,
    // A volume was unmounted in a subdirectory.
    ArchDirectoryObserverVolumeUnmountedReason
} ArchDirectoryObserverDescendantReason;

@protocol ArchDirectoryObserver <NSObject>

// At least one file in the directory indicated by changedURL has changed.  You should examine the directory at changedURL to see which files changed.
// observedURL: the URL of the dorectory you're observing.
// changedURL: the URL of the actual directory that changed. This could be a subdirectory.
// historical: if YES, the event occured sometime before the observer was added.  If NO, it occurred just now.
// resumeToken: the resume token to save if you want to pick back up from this event.
- (void)observedDirectory:(NSURL*)observedURL childrenAtURLDidChange:(NSURL*)changedURL historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken;

// At least one file somewhere inside--but not necessarily directly descended from--changedURL has changed.  You should examine the directory at changedURL and all subdirectories to see which files changed.
// observedURL: the URL of the dorectory you're observing.
// changedURL: the URL of the actual directory that changed. This could be a subdirectory.
// reason: the reason the observation center can't pinpoint the changed directory.  You may want to ignore some reasons--for example, "ArchDirectoryObserverNoHistoryReason" simply means that you didn't pass a resume token when adding the observer, and so you should do an initial scan of the directory.
// historical: if YES, the event occured sometime before the observer was added.  If NO, it occurred just now.
// resumeToken: the resume token to save if you want to pick back up from this event.
- (void)observedDirectory:(NSURL*)observedURL descendantsAtURLDidChange:(NSURL*)changedURL reason:(ArchDirectoryObserverDescendantReason)reason historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken;

// An ancestor of the observedURL has changed, so the entire directory tree you're observing may have vanished. You should ensure it still exists.
// observedURL: the URL of the dorectory you're observing.
// changedURL: the URL of the actual directory that changed. For this call, it will presumably be an ancestor directory.
// historical: if YES, the event occured sometime before the observer was added.  If NO, it occurred just now.
// resumeToken: the resume token to save if you want to pick back up from this event.
- (void)observedDirectory:(NSURL*)observedURL ancestorAtURLDidChange:(NSURL*)changedURL historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken;

@end


typedef enum {
    // Receive events for this process's actions.  If absent, file system changes initiated by the current process will not cause the directory observer to be notified.
    ArchDirectoryObserverObservesSelf = 1,
    // Favor quicker notifications over reduced number of notifications.
    // If this flag is ABSENT, a timer is started upon the first change, and after five seconds, an observation for all changes during that period is delivered.
    // If this flag is PRESENT, an observation is sent immediately upon the first change; then a 1 second timer is started, and a second observation is delivered for all changes during that period.
    // Use this flag if you're going to refresh an on-screen list or otherwise show the user that things have changed.
    ArchDirectoryObserverResponsive = 2
} ArchDirectoryObserverOptions;

@interface NSURL (DirectoryObserver)

// Start observing this URL.
// observer: the object to send observation messages to.
// options: modifies the observation's characteristics.  See ArchDirectoryObserverOptions above for more details.
// resumeToken: if you're interested in what has happened to this folder since your app last stopped observing it, pass in the last resume token your directory observer received.  If you don't, pass nil (and ignore the callback with a NoHistory reason).
// NOTE: Observation is currently only done on the main thread (and particularly, the main run loop).  To use other run loops, you'll need to create your own ArchDirectoryObservationCenter and go from there.
- (void)addDirectoryObserver:(id <ArchDirectoryObserver>)observer options:(ArchDirectoryObserverOptions)options resumeToken:(ArchDirectoryObservationResumeToken)resumeToken;

// Remove the observer.  You should do this in dealloc—ArchDirectoryObserver does not use weak pointers.
- (void)removeDirectoryObserver:(id <ArchDirectoryObserver>)observer;

// Class method to remove all observations using a given observer.
+ (void)removeObserverForAllDirectories:(id <ArchDirectoryObserver>)observer;

// Utility method; given two resume tokens, returns the one that represents a later point in time.  You may find this useful when saving resume tokens.
+ (ArchDirectoryObservationResumeToken)laterOfDirectoryObservationResumeToken:(ArchDirectoryObservationResumeToken)token1 andResumeToken:(ArchDirectoryObservationResumeToken)token2;

@end


// The observation center is where all the action happens.  You usually only need to work with it if you want to observe on a background thread.  The interface is not terribly different from the NSURL (DirectoryObserver) category.

@interface ArchDirectoryObservationCenter : NSObject {
@private
    NSMutableArray * eventStreams;
    NSRunLoop * runLoop;
}

+ (ArchDirectoryObservationCenter*)mainObservationCenter;

- (id)initWithRunLoop:(NSRunLoop*)runLoop;

@property (readonly) NSRunLoop * runLoop;

// We will retain the url, but you have to retain the observer.
- (void)addObserver:(id <ArchDirectoryObserver>)observer forDirectoryAtURL:(NSURL*)url ignoresSelf:(BOOL)ignoresSelf responsive:(BOOL)responsive resumeToken:(id)resumeToken;
- (void)removeObserver:(id <ArchDirectoryObserver>)observer forDirectoryAtURL:(NSURL*)url;
- (void)removeObserverForAllDirectories:(id <ArchDirectoryObserver>)observer;

- (ArchDirectoryObservationResumeToken)laterOfResumeToken:(ArchDirectoryObservationResumeToken)token1 andResumeToken:(ArchDirectoryObservationResumeToken)token2;

@end

