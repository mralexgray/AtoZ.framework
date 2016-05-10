

#import <AtoZ/AtoZ.h>


@interface AZFile : BaseModel //<AtoZNodeProtocol> // Base abstract class that wraps a file system URL

@property (NA)   NSS * path,
									    	* itemKind;
@property (NA)   NSC * color,
									 	    * customColor;
@property (NA)   NSA * colors;
@property (NA)  NSS * name,
								 		    * calulatedBundleID;
_RO  NSC * labelColor;
@property (NA) NSIMG * image;
@property (NA)   AZA   position;
_RO NSUI  	labelNumber;
_RO  CGF   hue;
_RO BOOL   hasLabel;

+ (INST)         forAppNamed:(NSS*)appName;
+ (INST)    instanceWithPath:(NSS*)path;
//+ (INST)   instanceWithImage:(NSIMG*)image;
+ (INST)   instanceWithColor:(NSC*)color;
- (void) setActualLabelColor:(NSC*)aColor;

@end

// Concrete subclass of ATDesktopEntity that loads children from a folder


@interface AZFolder : AZFile// <AtoZNodeProtocol> //AZFile
//_RONSUI count;
//	@property(NA, readonly) NSMutableArray *children;
//	_RONSUI capacity;
- (id) initWithArray:(NSArray*)array;
+ appFolder;
+ samplerWithCount:(NSUInteger)items;
// + samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items;
+ instanceWithFiles:(NSA*)files;
+ instanceWithPaths:(NSA*)strings;

//- (NSA*)filesMatchingFilter: (NSString *)filte
//- (NSA*)filesWithCategory: (AppCat)cat;
@end
@interface AZDockApp : BaseModel

+ (instancetype)instanceWithPath:(NSString *)path;

@property (NA, assign) 	CGPoint		dockPoint;
@property (NA, assign) 	CGPoint		dockPointNew;
@property (NA, assign) 	NSUInteger	spot;
@property (NA, assign) 	NSUInteger 	spotNew;
_RO			BOOL		isRunning;
@end

@interface AZDock : BaseModel
_RO NSA *dock;
_RO NSA *dockSorted;
@property (NA) AZDockSort sortOrder;
@end


//@interface AZImage : NSObject
//
//@property (weak,nonatomic)	id objectRep;
//
//@property (retain) NSColor *fillColor;
//@property (copy) NSString *fillColorName;
//
//@property (STR, readwrite) NSString *title;
//
//// Access to the image. This property can be observed to find out when it changes and is fully loaded.
//@property (STR) NSImage *image;
//@property (readonly, retain) NSImage *thumbnailImage;
//
//	// Asynchronously loads the image (if not already loaded). A KVO notification is sent out when the image is loaded.
//- (void) oadImage;
//
//	// A nil image isn't loaded (or couldn't be loaded). An image that is in the process of loading has imageLoading set to YES
//_ROBOOL imageLoading;
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
	//_ROBOOL imageLoading;
	//
	//@end
	// Declared constants to avoid typos in KVO. Common prefixes are used for easy code completion.
extern NSString *const ATEntityPropertyNamedFillColor;
extern NSString *const ATEntityPropertyNamedFillColorName;
extern NSString *const ATEntityPropertyNamedImage;
extern NSString *const ATEntityPropertyNamedThumbnailImage;

	//	@property (weak)	id itunesDescription;
	//	@property (weak)	id itunesResults;
	//	@property (NA, STR)	AJSiTunesResult *itunesInfo;
	//	@property (NA, STR)  	NSImage	 * 	icon;

