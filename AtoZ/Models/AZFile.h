

#import "AtoZ.h"
#import "AtoZUmbrella.h"


@interface AZFile : BaseModel <AtoZNodeProtocol> // Base abstract class that wraps a file system URL


@property (NATOM, STRNG) 		NSS * path,
											 * itemKind;
@property (NATOM, STRNG) 		NSC * color,
										 	 * customColor;
@property (NATOM, RONLY) 		NSA * colors;
@property (NATOM, ASS  ) 	 AZPOS   position;

@property (RONLY) 				NSS * name,
											 * calulatedBundleID;
@property (RONLY) 				NSC * labelColor;
@property (RONLY)           NSIMG * image;
@property (RONLY)            NSUI	labelNumber;
@property (RONLY) 				CGF   hue;
@property (RONLY)            BOOL   hasLabel;

+   (id) forAppNamed: 		   (NSS*) appName;
+   (id) instanceWithPath:	   (NSS*) path;
+   (id) instanceWithImage: (NSIMG*) image;
+   (id) instanceWithColor:   (NSC*) color;
- (void) setActualLabelColor: (NSC*) aColor;

@end

// Concrete subclass of ATDesktopEntity that loads children from a folder


@interface AZFolder : AZFile <AtoZNodeProtocol> //AZFile
//@property (RONLY) NSUI count;
//	@property(NATOM, readonly) NSMutableArray *children;
//	@property (RONLY) NSUI capacity;
- (id) initWithArray:(NSArray*)array;
+ (id) appFolder;
+ (id) samplerWithCount:(NSUInteger)items;
// + (id) samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items;
+ (id) instanceWithFiles:(NSA*)files;
+ (id) instanceWithPaths:(NSA*)strings;

//- (NSA*)filesMatchingFilter: (NSString *)filte
//- (NSA*)filesWithCategory: (AppCat)cat;
@end
@interface AZDockApp : BaseModel

+ (instancetype)instanceWithPath:(NSString *)path;

@property (NATOM, assign) 	CGPoint		dockPoint;
@property (NATOM, assign) 	CGPoint		dockPointNew;
@property (NATOM, assign) 	NSUInteger	spot;
@property (NATOM, assign) 	NSUInteger 	spotNew;
@property (RONLY)			BOOL		isRunning;
@end

@interface AZDock : BaseModel
@property (RONLY) NSArray *dock;
@property (RONLY) NSArray *dockSorted;
@property (NATOM, assign) AZDockSort sortOrder;
@end


//@interface AZImage : NSObject
//
//@property (weak,nonatomic)	id objectRep;
//
//@property (retain) NSColor *fillColor;
//@property (copy) NSString *fillColorName;
//
//@property (STRNG, readwrite) NSString *title;
//
//// Access to the image. This property can be observed to find out when it changes and is fully loaded.
//@property (STRNG) NSImage *image;
//@property (readonly, retain) NSImage *thumbnailImage;
//
//	// Asynchronously loads the image (if not already loaded). A KVO notification is sent out when the image is loaded.
//- (void)loadImage;
//
//	// A nil image isn't loaded (or couldn't be loaded). An image that is in the process of loading has imageLoading set to YES
//@property (RONLY) BOOL imageLoading;
//
//@end
	//extern NSString *const AtoZFileUpdated;
	//@class AJSiTunesResult;

	//
	//	// Concrete subclass of ATDesktopEntity that adds support for loading an image at the given URL and stores a fillColor property
	//@interface ATDesktopImageEntity : ATDesktopEntity {
	//@private
	//	BOOL _imageLoading;
	//	NSString *_title;
	//	NSImage *_image;
	//	NSImage *_thumbnailImage;
	//	NSColor *_fillColor;
	//	NSString *_fillColorName;
	//}
	//
	//@property (retain) NSColor *fillColor;
	//@property (copy) NSString *fillColorName;
	//
	//@property (retain, readwrite) NSString *title;
	//
	//	// Access to the image. This property can be observed to find out when it changes and is fully loaded.
	//@property (retain) NSImage *image;
	//@property (readonly, retain) NSImage *thumbnailImage;
	//
	//	// Asynchronously loads the image (if not already loaded). A KVO notification is sent out when the image is loaded.
	//- (void)loadImage;
	//
	//	// A nil image isn't loaded (or couldn't be loaded). An image that is in the process of loading has imageLoading set to YES
	//@property (RONLY) BOOL imageLoading;
	//
	//@end
	// Declared constants to avoid typos in KVO. Common prefixes are used for easy code completion.
extern NSString *const ATEntityPropertyNamedFillColor;
extern NSString *const ATEntityPropertyNamedFillColorName;
extern NSString *const ATEntityPropertyNamedImage;
extern NSString *const ATEntityPropertyNamedThumbnailImage;

	//	@property (weak)	id itunesDescription;
	//	@property (weak)	id itunesResults;
	//	@property (NATOM, STRNG)	AJSiTunesResult *itunesInfo;
	//	@property (NATOM, STRNG)  	NSImage	 * 	icon;

