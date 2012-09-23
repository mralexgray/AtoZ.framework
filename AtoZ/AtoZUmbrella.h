
typedef enum {
	AZMenuN,
	AZMenuS,
	AZMenuE,
	AZMenuW,
	AZMenuPositionCount
}	AZMenuPosition;

extern NSString *const AZMenuPositionName[AZMenuPositionCount];
	// NSLog(@"%@", FormatTypeName[XML]);


typedef enum  {
    AZItemsAsBundleIDs,
    AZItemsAsPaths,
    AZItemsAsNames
}AZItemsViewFormat;


typedef enum
{
	ReadAccess = R_OK,
	WriteAccess = W_OK,
	ExecuteAccess = X_OK,
	PathExists = F_OK
} SandBox;
BOOL isPathAccessible(NSString *path, SandBox mode);

void trackMouse();
	// In a header file
//typedef enum {
//	JSON = 0,         // explicitly indicate starting index
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


typedef enum {
    IngredientType_text  = 0,
    IngredientType_audio = 1,
    IngredientType_video = 2,
    IngredientType_image = 3
} IngredientType;
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

typedef enum {
	AZOrientTop,  //explicit
	AZOrientLeft,
	AZOrientBottom,
	AZOrientRight,
	AZOrientGrid,
	AZOrientPerimeter,
	AZOrientFiesta,
	AZOrientVertical,
	AZOrientHorizontal

} AZOrient;
	//extern NSString *const AZOrientName[AZOrientCount];


typedef enum  {
	AZInfiteScale0X,
	AZInfiteScale1X,
	AZInfiteScale2X,
	AZInfiteScale3X,
	AZInfiteScale10X
} AZInfiteScale;


typedef enum  {
    LeftOn,
    LeftOff,
    TopOn,
    TopOff,
	RightOn,
	RightOff,
	BottomOn,
	BottomOff
} AZTrackState;


typedef enum  {
	AZDockSortNatural,
	AZDockSortColor,
	AZDockSortPoint,
	AZDockSortPointNew,
}	AZDockSort;

typedef enum  {
	AZSearchByCategory,
	AZSearchByColor,
	AZSearchByName,
	AZSearchByRecent
} AZSearchBy;


typedef enum {
	AZIn,
	AZOut
} AZSlideState;


#ifndef ATOZTOUCH
typedef enum _AZWindowPosition {
		// The four primary sides are compatible with the preferredEdge of NSDrawer.
    AZPositionLeft          = NSMinXEdge, // 0
    AZPositionRight         = NSMaxXEdge, // 2
    AZPositionTop           = NSMaxYEdge, // 3
    AZPositionBottom        = NSMinYEdge, // 1
    AZPositionLeftTop       = 4,
    AZPositionLeftBottom    = 5,
    AZPositionRightTop      = 6,
    AZPositionRightBottom   = 7,
    AZPositionTopLeft       = 8,
    AZPositionTopRight      = 9,
    AZPositionBottomLeft    = 10,
    AZPositionBottomRight   = 11,
    AZPositionAutomatic     = 12
} AZWindowPosition;

#endif
// Place this in your .h file, outside the @interface block
//#define  AZWindowPositionTypeArray [NSArray arrayWithObjects: NSVposi(AZPositionLeft), NSVposi(AZPositionRight), NSVposi(AZPositionTop), NSVposi(AZPositionBottom), NSVposi(AZPositionLeftTop), NSVposi(AZPositionLeftBottom), NSVposi(AZPositionRightTop), NSVposi(AZPositionRightBottom), NSVposi(AZPositionTopLeft), NSVposi(AZPositionTopRight), NSVposi(AZPositionBottomLeft), NSVposi(AZPositionBottomRight), NSVposi(AZPositionAutomatic), nil]

#define  AZWindowPositionTypeArray @"Left", @"Bottom", @"Right", @"Top",  @"ZPositionLeftTop",@"ZPositionLeftBottom", @"ZPositionRightTop", @"ZPositionRightBottom", @"ZPositionTopLeft", @"ZPositionTopRight", @"ZPositionBottomLeft", @"ZPositionBottomRight", @"ZPositionAutomatic", nil

@interface NSValue (AZWindowPosition)
+ (id)valueWithPosition:(AZWindowPosition)pos;
- (AZWindowPosition)positionValue;
@end

//NSString *const FormatTypeName[FormatTypeCount] = {
//	[JSON] = @"JSON",
//	[XML] = @"XML",
//	[Atom] = @"Atom",
//	[RSS] = @"RSS",
//};


typedef struct {
    CGFloat color[4];
	CGFloat caustic[4];
	CGFloat expCoefficient;
	CGFloat expScale;
	CGFloat expOffset;
	CGFloat initialWhite;
	CGFloat finalWhite;
} GlossParameters;


