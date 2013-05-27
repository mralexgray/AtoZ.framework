

#import "AtoZUmbrella.h"


//static NSA *_pos = nil;
//#define AZWindowPositionTypeArray @"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic", nil

/*
Binary Math
0 + 0 = 0
0 + 1 = 1
1 + 1 = 10

Binary to Decimal Conversion
00010011 = 0*2**7 + 0*2**6 + 0*2**5 + 1*2**4 + 0*2**3 + 0*2**2 + 1*2**1 + 1*2**0
         = 		 0 + 		 0 + 		 0 + 		16 + 		 0 + 		 0 + 		 2 + 		 1
         = 																							19
*/


// Constants to hold bit masks for desired flags
static int flagAllOff 	=   0;	//         000...00000000 (empty mask)
static int flagbit1 		=   1;   // 2^^0    000...00000001
static int flagbit2 		=   2;   // 2^^1    000...00000010
static int flagbit3 		=   4;   // 2^^2    000...00000100
static int flagbit4 		=   8;   // 2^^3    000...00001000
static int flagbit5 		=  16;   // 2^^4    000...00010000
static int flagbit6 		=  32;   // 2^^5    000...00100000
static int flagbit7 		=  64;   // 2^^6    000...01000000
static int flagbit8 		= 128;  	// 2^^7    000...10000000

#define AZA AZAlign
#define AZPOS AZA
//JREnumDeclare (AZAlign,
JROptionsDeclare(AZAlign, 	AZAlignLeft       = 0x00000001, 
									AZAlignRight      = 0x00000010,
									AZAlignTop        = 0x00000100,
									AZAlignBottom     = 0x00001000,
									AZAlignTopLeft    = 0x00000101,
									AZAlignBottomLeft = 0x00001001,		
									AZAlignTopRight   = 0x00000110,
									AZAlignBottomRight  = 0x00001010

//				AZAlignNone	= 0, // 0
//		AZAlignBottomLeft = 0x10000001, // 2 << 0  (0x1 << 1), // => 0x00000010
//			 AZAlignBottom	= 0x00000010,
//	  AZAlignBottomRight	= 0x00000110,
//	     	  AZAlignRight = 0x00001000,
//  	     AZAlignTopRight = 0x00001100,
//	          AZAlignTop = 0x00000000,
//			AZAlignTopLeft = 0x00000101,
//				AZAlignLeft = 0x00011100 // 1 << 0   aka (0x1 << 0), // => 0x00000001
////	       = 0x00001000,
//	   = 0x00001001,
//	  = 0x00001010
);


typedef NS_ENUM(NSUI, AssetType){ JS, CSS, HTML, PHP, BASH,	ObjC, TXT,	UNKNOWN = 99 };
extern NSString * const assetStringValue[];
extern NSString * const assetTagName[];



typedef NS_ENUM(NSUI, CharacterSet) {
	kCharacterSet_Newline = 0,
	kCharacterSet_WhitespaceAndNewline,
	kCharacterSet_WhitespaceAndNewline_Inverted,
	kCharacterSet_UppercaseLetters,
	kCharacterSet_DecimalDigits_Inverted,
	kCharacterSet_WordBoundaries,
	kCharacterSet_SentenceBoundaries,
	kCharacterSet_SentenceBoundariesAndNewlineCharacter,
	kNumCharacterSets
};


typedef NS_OPTIONS(NSUInteger, AZInstallationStatus) {
	AZNotInstalled			= 0,
	AZInstalled				= 1 << 0,
	AZNeedsUpdate			= 1 << 1,
	//	UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
	//	UIViewAutoresizingFlexibleTopMargin	= 1 << 3,
	//	UIViewAutoresizingFlexibleHeight	   = 1 << 4,
	//	UIViewAutoresizingFlexibleBottomMargin = 1 << 5,
	AZInstalledNeedsUpdate 	= AZInstalled|AZNeedsUpdate
};


typedef NS_ENUM(NSUInteger, PXListViewDropHighlight) {
	PXListViewDropNowhere,
	PXListViewDropOn,
	PXListViewDropAbove,
	PXListViewDropBelow
};


typedef NS_ENUM(NSUI,  	OSCornerType) {
	//typedef NS_NSENUM( OSCornerTypes {
	OSTopLeftCorner = 1,
	OSBottomLeftCorner = 2,
	OSTopRightCorner = 4,
	OSBottomRightCorner = 8
};// OSCornerType;

typedef enum {
	AMTriangleUp = 0,
	AMTriangleDown,
	AMTriangleLeft,
	AMTriangleRight
} AMTriangleOrientation;



//CASCROLLVIEW
//minimizing = 0x01, // 00000001
//maximizing = 0x02, // 00000010
//minimized  = 0x04, // 00000100
//maximized  = 0x08  // 00001000

typedef NS_OPTIONS(NSUI, ScrollFix)	{	LayerInsertFront, 		//= 0x01, // 00000001
	LayerInsertEnd,
	LayerRemoveFront,
	LayerRemoveEnd,
	LayerStateOK,// 			= 0x04, // 00000100
	LayerStateUnresolved,// = 0x08,  // 00001000
	LayerStateUnset
};

typedef NS_ENUM (NSUI, StateStyle)	{	Lasso,			InnerShadow,
	DarkenOthers,	None				};

#define VRT AZOrientVertical
#define HRZ AZOrientHorizontal
#define ScrollFixTypeArray @"LayerInsertFront",	@"LayerInsertEnd",				 @"LayerRemoveFront",	@"LayerRemoveEnd", \
@"LayerStateOK",		@"LayerStateUnresolved",  @"LayerStateUnset",  	nil

//@"LayerCopyInsertFront",@"LayerCopyInsertEnd"
NS_INLINE NSS* stringForScrollFix(ScrollFix val) { return [NSArray.alloc initWithObjects:ScrollFixTypeArray][val]; }






//NSDATE NSSTRING ETC
__unused static OSSpinLock _calendarSpinLock = 0;
__unused static OSSpinLock _formattersSpinLock = 0;
__unused static OSSpinLock _staticSpinLock = 0;





typedef NS_ENUM(NSUI, AppCat) {
	Games, Education, Entertainment,
	Books, Lifestyle, Utilities, Business,
	Travel, Music, Reference, Sports,
	Productivity, News, HealthcareFitness,
	Photography, Finance, Medical, SocialNetworking,
	Navigation, Weather, Catalogs, FoodDrink, Newsstand
};

#define AppCatTypeArray @"Games", @"Education", @"Entertainment", @"Books", @"Lifestyle", @"Utilities", @"Business", @"Travel", @"Music", @"Reference", @"Sports", @"Productivity", @"News", @"Healthcare & Fitness", @"Photography", @"Finance", @"Medical", @"Social Networking", @"Navigation", @"Weather", @"Catalogs", @"Food & Drink", @"Newsstand", nil


typedef NS_ENUM(NSUI,    AZSlideState ) { AZIn, AZOut, AZToggle																						};
typedef NS_ENUM(NSUI, 		 	AZState ) {	AZIdleState, AZCreatingState, AZModifyingState, AZDeletingState, AZOn, AZOff				};
typedef NS_ENUM(NSUI,    AZTrackState ) { LeftOn, LeftOff, TopOn, TopOff, RightOn, RightOff, BottomOn, BottomOff						};
typedef NS_ENUM(NSUI,      AZDockSort ) { AZDockSortNatural, AZDockSortColor, AZDockSortPoint, AZDockSortPointNew						};
typedef NS_ENUM(NSUI,      AZSearchBy ) { AZSearchByCategory, AZSearchByColor, AZSearchByName, AZSearchByRecent						};
typedef NS_ENUM(NSUI,  AZMenuPosition ) { AZMenuN, AZMenuS, AZMenuE, AZMenuW, AZMenuPositionCount											};
typedef NS_ENUM(NSUI, AZTrackPosition ) { AZTrackN, AZTrackS, AZTrackE, AZTrackW, AZTrackPositionCount									};
typedef NS_ENUM(NSUI,  	AZInfiteScale ) { AZInfiteScale0X, AZInfiteScale1X, AZInfiteScale2X, AZInfiteScale3X, AZInfiteScale10X	};

typedef NS_OPTIONS(NSUI,     AZOrient ) {	AZOrientTop, AZOrientLeft, AZOrientBottom, AZOrientRight,
														AZOrientGrid, AZOrientPerimeter, AZOrientFiesta,
														AZOrientVertical, AZOrientHorizontal																	};

#define AZTW AZTrackingWindow
#define iC iCarousel
/*
//#ifndef ATOZTOUCH
typedef NS_OPTIONS(NSUI, AZWindowPosition) {
	AZPositionLeft 			= NSMinXEdge, // 0  NSDrawer
	AZPositionRight			= NSMaxXEdge, // 2  preferredEdge
	AZPositionTop		   	= NSMaxYEdge, // 3  compatibility
	AZPositionBottom			= NSMinYEdge, // 1  numbering!
	AZPositionTopLeft	   	= 4,
	AZPositionBottomLeft		= 5,
	AZPositionTopRight	 	= 6,
	AZPositionBottomRight   = 7,
	AZPositionAutomatic	 	= 8
};// AZWindowPosition;
*/
#define  AZPositionToString AZWindowPositionToString
#define AZPosition AZAlign
#define AZWindowPosition AZPosition
//JREnumDeclare(AZPosition,
//	AZPositionLeft 			= 0,// NSMinXEdge, // 0  NSDrawer
//	AZPositionRight			= 2, //NSMaxXEdge, // 2  preferredEdge
//	AZPositionTop		   	= 3, //NSMaxYEdge, // 3  compatibility
//	AZPositionBottom			= 1,  //NSMinYEdge, // 1  numbering!
//	AZPositionTopLeft	   	= 4,
//	AZPositionBottomLeft		= 5,
//	AZPositionTopRight	 	= 6,
//	AZPositionBottomRight   = 7,
//	AZPositionAutomatic	 	= 8 );// AZWindowPosition;



#define AZPositionLeft 		AZAlignLeft
#define AZPositionRight		AZAlignRight		//			= 2, //NSMaxXEdge, // 2  preferredEdge
#define 	AZPositionTop		AZAlignTop		   //	= 3, //NSMaxYEdge, // 3  compatibility
#define 	AZPositionBottom		AZAlignBottom//			= 1,  //NSMinYEdge, // 1  numbering!
#define 	AZPositionTopLeft 		AZAlignTopLeft//	   	= 4,
#define 	AZPositionBottomLeft		AZAlignBottomLeft//		= 5,
#define 	AZPositionTopRight		AZAlignTopRight//	 	= 6,
#define 	AZPositionBottomRight		AZAlignBottomRight//   = 7,
#define 	AZPositionAutomatic		NSNotFound//	 	= 8 );// AZWindowPosition;

#define AZLft 		AZPositionLeft
#define AZRgt		AZPositionRight
#define AZTop		AZPositionTop
#define AZBot		AZPositionBottom
#define AZTpLft	AZPositionTopLeft
#define AZBtLft	AZPositionBottomLeft
#define AZTpRgt	AZPositionTopRight
#define AZBtRgt	AZPositionBottomRight



//NSS* stringForPosition(AZWindowPosition enumVal);

//NS_INLINE NSS* stringForPosition(AZPOS e) {	_pos = _pos ?: [NSA arrayWithObjects:AZWindowPositionTypeArray];
//	return _pos.count >= e ? _pos[e] : @"outside of range for Positions";
//}
//NS_INLINE AZPOS positionForString(NSS* s)	{	_pos = _pos ?: [NSA arrayWithObjects:AZWindowPositionTypeArray];
//															return (AZPOS) [_pos indexOfObject:s];
//}


typedef struct AZWhatever {
	NSUI position;
	char *aString;
	int  anInt;
} AZWhatever;

// NSVALUE defined, see NSValue+AtoZ.h
//#define AZWindowPositionTypeArray @[@"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic"]
//#endif

#define QUAD AZQuad


//JREnum() is fine for when you have an enum that lives solely in an .m file. But if you're exposing an enum in a header file, you'll have to use the alternate macros. In your .h, use JREnumDeclare():
//	JREnumDeclare(StreamState,	   Stream_Disconnected,   	Stream_Connecting,                                                    										Stream_Connected, 		Stream_Disconnecting);
//And then use JREnumDefine() in your .m:
//	JREnumDefine(StreamState); for Free!!
// NSString* AZQuadrantToString(int value);

//JREnumDeclare( AZQuadrant, AZTopLeftQuad = 0, AZTopRightQuad, AZBotRightQuad, AZBotLeftQuad);
JREnumDeclare( AZQuad, AZQuadTopLeft = 0, AZQuadTopRight, AZQuadBotRight, AZQuadBotLeft);

//typedef NS_ENUM(NSUI, AZQuadrant){
//	AZTopLeftQuad = 0,
//	AZTopRightQuad,
//	AZBotRightQuad,
//	AZBotLeftQuad
//};


typedef struct {	CGFloat tlX; CGFloat tlY;
	CGFloat trX; CGFloat trY;
	CGFloat blX; CGFloat blY;
	CGFloat brX; CGFloat brY;
} CIPerspectiveMatrix;

//extern NSString *const AZOrientName[AZOrientCount];
extern NSString *const AZMenuPositionName[AZMenuPositionCount];
// NSLog(@"%@", FormatTypeName[XML]);
//NSString *const FormatTypeName[FormatTypeCount] = { [JSON]=@"JSON", [XML]=@"XML", [Atom] = @"Atom", [RSS] = @"RSS", };

typedef NS_ENUM( NSUI, AZItemsViewFormat ){	AZItemsAsBundleIDs,	AZItemsAsPaths,	AZItemsAsNames	};

typedef NS_ENUM(NSUI, SandBox) {	ReadAccess = R_OK,	WriteAccess = W_OK,	ExecuteAccess = X_OK,	PathExists = F_OK };


NS_INLINE void AZPrintEncodingTypes(){
	NSLog(@"%15s: %s","AZPOS", @encode( AZPOS ));
	NSLog(@"%15s: %s",  "NSP", @encode(   NSP ));
	NSLog(@"%15s: %s","NSRGG", @encode( NSRNG ));
	NSLog(@"%15s: %s", "NSSZ", @encode(  NSSZ ));
	NSLog(@"%15s: %s",  "NSR", @encode(   NSR ));
	NSLog(@"%15s: %s", "BOOL", @encode(  BOOL ));
	NSLog(@"%15s: %s","AZPOS", @encode( AZPOS ));
	NSLog(@"%15s: %s",  "CGF", @encode(   CGF ));
	NSLog(@"%15s: %s", "NSUI", @encode(  NSUI ));
	NSLog(@"%15s: %s",  "int", @encode(   int ));
	NSLog(@"%15s: %s",  "NSI", @encode(   NSI ));
	NSLog(@"%15s: %s", "CGCR", @encode(  CGCR ));
	NSLog(@"%15s: %s",   "id", @encode(    id ));
	NSLog(@"%15s: %s",  "NSA", @encode(   NSA ));
}

//typedef enum {
//	JSON = 0,		 // explicitly indicate starting index
//	XML,
//	Atom,
//	RSS,
//
//	FormatTypeCount,  // keep track of the enum size automatically
//} FormatType;
//extern NSString *const FormatTypeName[FormatTypeCount];
//NSLog(@"%@", FormatTypeName[XML]);
//	// In a source file
//NSString *const FormatTypeName[FormatTypeCount] = {
//	[JSON] = @"JSON",
//	[XML] = @"XML",
//	[Atom] = @"Atom",
//	[RSS] = @"RSS",
//};
//typedef enum {
//	IngredientType_text  = 0,
//	IngredientType_audio = 1,
//	IngredientType_video = 2,
//	IngredientType_image = 3
//} IngredientType;
//write a method like this in class:
//+ (NSString*)typeStringForType:(IngredientType)_type {
//	NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type];
//	return NSLocalizedString(key, nil);
//}
//have the strings inside Localizable.strings file:
///* IngredientType_text */
//"IngredientType_0" = "Text";
///* IngredientType_audio */
//"IngredientType_1" = "Audio";
///* IngredientType_video */
//"IngredientType_2" = "Video";
///* IngredientType_image */
//"IngredientType_3" = "Image";
//

//typedef struct _GlossParameters{
//	CGFloat color[4];
//	CGFloat caustic[4];
//	CGFloat expCoefficient;
//	CGFloat expScale;
//	CGFloat expOffset;
//	CGFloat initialWhite;
//	CGFloat finalWhite;
//} GlossParameters;
