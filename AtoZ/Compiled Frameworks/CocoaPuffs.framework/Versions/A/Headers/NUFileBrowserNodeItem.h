
#import <AppKit/AppKit.h>

@interface NUFileBrowserNodeItem : NSTreeNode<NSPasteboardWriting,NSPasteboardReading>

@property (readonly) NSImage  *image;
@property (readonly) NSString *label;
@property (readonly) NSString *type;
@property (readonly) NSString *typeDescription;
@property (readonly) NSDate   *creationDate;
@property (readonly) NSDate   *lastAccessDate;
@property (readonly) NSDate   *lastModificationDate;
@property (readonly) BOOL      isReadable;
@property (readonly) BOOL      isDirectory;
@property (readonly) BOOL      isLeaf;
@property (assign)   BOOL      enabled;

@property (readonly) NSUInteger fileSize;
@property (readonly) double     fileSizeKB;
@property (readonly) double     fileSizeMB;

// This determines the initial enabled state of the node.
// This value is not KVC compliant.
@property (retain) NSArray *supportedTypes;

// Designated initializer
- (id) initWithRepresentedObject:(NSURL*)aURL andSupportedTypes:(NSArray*)types;
+ (id) treeNodeWithRepresentedObject:(NSURL*)aURL andSupportedTypes:(NSArray*)types;

+ (NSMutableArray*) nodesForURL:(NSURL*)URL andSupportedTypes:(NSArray*)types;

@end
