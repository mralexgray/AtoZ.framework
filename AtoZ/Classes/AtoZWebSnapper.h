//
//  AtoZWebSnapper.h
//  AtoZWebSnapper
//
//  Created by Alex Gray on 9/14/12.
//
//

#import <Foundation/Foundation.h>
//#import "GetURLCommand.h"
//#import "NSStringAdditions.h"
#import "MetalUI.h"
#import "PreferencesController.h"
//#import "md5.h"
#import "AtoZWebSnapperWindowController.h"


@interface GetURLCommand : NSScriptCommand
@end

extern NSString * const kAZWebSnapperUserAgent;
extern NSString * const kAZWebSnapperWebMinWidthKey;
extern NSString * const kAZWebSnapperWebMinHeightKey;
extern NSString * const kAZWebSnapperWebMaxWidthKey;
extern NSString * const kAZWebSnapperWebMaxHeightKey;
extern NSString * const kAZWebSnapperSaveFormatKey;
extern NSString * const kAZWebSnapperJPEGQualityKey;
extern NSString * const kAZWebSnapperURLHistoryKey;

extern NSString * const kAZWebSnapperThumbnailScaleKey;
extern NSString * const kAZWebSnapperSaveImageKey;
extern NSString * const kAZWebSnapperSaveThumbnailKey;
extern NSString * const kAZWebSnapperDelayKey;
extern NSString * const kAZWebSnapperThumbnailFormatKey;

// Initialized in PaparazziController.h
extern NSString * const kAZWebSnapperFilenameFormatKey;
extern NSString * const kAZWebSnapperThumbnailSuffixKey;
extern NSString * const kAZWebSnapperMaxHistoryKey;
extern NSString * const kAZWebSnapperUseGMTKey;


@interface AtoZWebSnapper : NSObject

@property (STRNG, NATOM) NSURL				*currentURL;
@property (STRNG, NATOM) NSString			*currentTitle;

@property (ASS, NATOM)	NSSize				currentMax; // currentSize isn't needed because the size is set when the load starts
@property (ASS, NATOM)	float				currentDelay;

@property (STRNG, NATOM) WebView		*webView;
@property (STRNG, NATOM) NSWindow		*webWindow;
@property (ASS,   NATOM)	BOOL				isLoading;

@property (STRNG, NATOM) NSBitmapImageRep	*bitmap;
@property (STRNG, NATOM) NSData				*pdfData;
@property (STRNG, NATOM) NSIMG				*snap;
@property (STRNG, NATOM) NSMA				*webHistory;


- (void)takeURLFromBrowser: (NSS*) name;
- (void)takeScreenshot;

- (void)fetchUsingString: (NSS*) string minSize:(NSSize)minSize cropSize:(NSSize)cropSize;

- (NSString *)filenameWithFormat: (NSS*) format;
- (void)saveAsPNG: (NSS*)filename fullSize:(BOOL)saveFullSize thumbnailScale:(float)thumbnailScale thumbnailSuffix: (NSS*) thumbnailSuffix;
- (void)saveAsTIFF: (NSS*) filename fullSize:(BOOL)saveFullSize thumbnailScale:(float)thumbnailScale thumbnailSuffix: (NSS*) thumbnailSuffix;
- (void)saveAsJPEG: (NSS*) filename usingCompressionFactor:(float)factor fullSize:(BOOL)saveFullSize thumbnailScale:(float)thumbnailScale thumbnailSuffix: (NSS*) thumbnailSuffix;
- (void)saveAsPDF: (NSS*) filename;
- (NSBitmapImageRep *)bitmapThumbnailWithScale:(float)scale;

- (void)validateInputSchemeForControl:(NSControl *)control;

- (void)warnOfMalformedPaparazziURL:(NSURL *)url;

- (void)addURLToHistory:(NSURL *)url;



@end
