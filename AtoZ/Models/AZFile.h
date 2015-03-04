

#import <AtoZ/AtoZ.h>
#import "AtoZUmbrella.h"


@interface AZFile : BaseModel //<AtoZNodeProtocol> // Base abstract class that wraps a file system URL

@property (NATOM)   NSS * path,
									    	* itemKind;
@property (NATOM)   NSC * color,
									 	    * customColor;
@property (NATOM)   NSA * colors;
@property (NATOM)  NSS * name,
								 		    * calulatedBundleID;
@prop_RO   NSC * labelColor;
@property (NATOM) NSIMG * image;
@property (NATOM)   AZA   position;
@prop_RO  NSUI  	labelNumber;
@prop_RO   CGF   hue;
@prop_RO  BOOL   hasLabel;

+ (INST)         forAppNamed:(NSS*)appName;
+ (INST)    instanceWithPath:(NSS*)path;
//+ (INST)   instanceWithImage:(NSIMG*)image;
+ (INST)   instanceWithColor:(NSC*)color;
- (void) setActualLabelColor:(NSC*)aColor;

@end

// Concrete subclass of ATDesktopEntity that loads children from a folder


@interface AZFolder : AZFile// <AtoZNodeProtocol> //AZFile
//@prop_RO NSUI count;
//	@property(NATOM, readonly) NSMutableArray *children;
//	@prop_RO NSUI capacity;
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
@prop_RO			BOOL		isRunning;
@end

@interface AZDock : BaseModel
@prop_RO NSA *dock;
@prop_RO NSA *dockSorted;
@property (NATOM) AZDockSort sortOrder;
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
//- (void) oadImage;
//
//	// A nil image isn't loaded (or couldn't be loaded). An image that is in the process of loading has imageLoading set to YES
//@prop_RO BOOL imageLoading;
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
	//- (void) oadImage;
	//
	//	// A nil image isn't loaded (or couldn't be loaded). An image that is in the process of loading has imageLoading set to YES
	//@prop_RO BOOL imageLoading;
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

