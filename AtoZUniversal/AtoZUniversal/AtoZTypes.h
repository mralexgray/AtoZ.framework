
#ifndef AtoZ_Types_h
#define AtoZ_Types_h

#ifndef AtoZ_MacroDefines_h
#import <AtoZUniversal/AtoZMacroDefines.h>
#endif

typedef void (^Blk)         (         );
typedef void (^VBlk)        ( void    );
typedef void (^ObjBlk)      (   id   x);
typedef void (^DTABlk)      (  DTA * d);
typedef void (^URLBlk)      (NSURL * u);
typedef void (^NumBlk)      (  NSN * n);
typedef void (^DBlk)        (  NSD * d);

typedef void (^ObjObjBlk)   (id x1, id x2);
typedef void (^ObjIntBlk)   (id x, NSI i);

typedef id (^Obj_Blk)       (            );
typedef id (^Obj_VBlk)      (void        );
typedef id (^Obj_ObjBlk)    (id x        );
typedef id (^Obj_ObjObjBlk) (id x1, id x2);
typedef id (^Obj_IntBlk)    (NSI i       );

typedef id (^ReduceArrayBlock)(id memo, id obj);
typedef id (^ReduceDictBlock)(id memo, id key, id value);

typedef BOOL (^Bool_ObjBlk)(id x);
typedef BOOL (^Bool_ObjObjBlk)(id x1, id x2);

typedef NSComparisonResult (^CompareArrayBlock) (id a, id b);
typedef NSComparisonResult (^CompareDictBlock) (id k1, id v1 , id k2, id v2);


/*! The Bitwise operators supported by Objective-C language are listed in the following table.
@code
             unsigned int a = 60 == 0011 1100
                          b = 13 == 0000 1101
Op  Binary             
==  ======
&   AND             a & b ->  12 == 0000 1100  Copies a bit to the result if it exists in both operands.	 
|   OR              a | b ->  61 == 0011 1101  Copies a bit if it exists in either operand.	 
^   XOR             a ^ b ->  49 == 0011 0001  Copies the bit if it is set in one operand but not both.	
~   1's Complement    ~ a -> -61 == 1100 0011  Operator is unary and has the effect of 'flipping' bits.	  in 2's complement form due to a signed binary number.
>>	R Shift        a >> 2 ->  15 == 0000 1111  Left operand's value is moved right by the number of bits specified by the right operand.	 
<<	L Shift        a << 2 -> 240 == 1111 0000  Left operand's value is moved left by the number of bits specified by the right operand.	 

*/

#if !TARGET_OS_IPHONE

NS_INLINE NSString* AZEnumToBinary(int num) {  char str[9] = {0};

  return [NSString stringWithFormat:@"%s", ({ int i; for(i=7;i>=0;i--){ str[i] = (num&1)?'1':'0'; num >>= 1; } str; })];
}
#endif

#define AZ01 AZParity  // Even or Odd?
#define QUAD AZQuad    // Describe The 4 quadrants of a rect.
#define AZA   AZAlign  // Multifaceted enumerator of edges, etc.
#define AZPOS AZA      // Alias, that sounds better gramatically, sometimes, for AZAlign.

#define AZAlignLeft         AZLft
#define AZAlignRight        AZRgt		
#define AZAlignTop          AZTop		
#define AZAlignBottom       AZBtm		
#define AZAlignTopLeft      AZTopLft	
#define AZAlignBottomLeft   AZBtmLft	
#define AZAlignTopRight     AZTopRgt	
#define AZAlignBottomRight  AZBtmRgt	
#define AZAlignCenter       AZCntr	
#define AZAlignOutside      AZOtsd	
#define AZAlignAutomatic    AZAuto	
#define AZAlignUnset        AZUnset	

#define VRT AZOrientVertical
#define HRZ AZOrientHorizontal

#define AZTW AZTrackingWindow
#define iC iCarousel

#define AZPositionToString AZAlignToString
#define AZPosition AZAlign
#define AZWindowPosition AZPosition

//#define   AZLft          AZAlignLeft
//#define   AZRgt         AZAlignRight		//			= 2, //NSMaxXEdge, // 2  preferredEdge
//#define 	AZTop           AZAlignTop		   //	= 3, //NSMaxYEdge, // 3  compatibility
//#define 	AZBtm        AZAlignBottom//			= 1,  //NSMinYEdge, // 1  numbering!
#define 	AZPositionTopLeft       AZAlignTopLeft//	   	= 4,
#define 	AZPositionBottomLeft		AZAlignBottomLeft//		= 5,
#define 	AZPositionTopRight      AZAlignTopRight//	 	= 6,
#define 	AZPositionBottomRight		AZAlignBottomRight//   = 7,
#define 	AZPositionAutomatic     AZAlignAutomatic   //	 	= 8 );// AZWindowPosition;
#define 	AZPositionCenter        AZAlignCenter
#define 	AZPositionOutside       AZAlignOutside


#if !TARGET_OS_IPHONE

@class BLKVIEW;
typedef void(^ViewBlock)(NSView *v);
typedef void(^BlkViewRectBlock) (BLKVIEW *v, NSRect r);
typedef void(^BlkViewLayerBlock) (BLKVIEW *v, CALayer *l);

typedef void(^RectBlock) (NSR rect);
typedef void(^ObjRectBlock) (id _self, NSR rect);

#endif

//#define BLKVIEWRBLK BlkViewRectBlock

JREnumDeclare( AZAlign,        AZUnset = 0x00000000,

                                 AZTop = 0x00000001,   ///         1
                                 AZBtm = 0x00000010,   ///        1
                                 AZLft = 0x00000100,   ///       1
                                 AZRgt = 0x00001000,   ///      1

                              AZTopLft = 0x00000101,   ///       1 1
                              AZTopRgt = 0x00001001,   ///      1  1
                              AZBtmLft = 0x00000110,   ///       11
                              AZBtmRgt = 0x00001010,   ///      1 1
                                AZCntr = 0x00001111,

                                AZOtsd = 0x00010000,   ///     1
                                AZAuto = 0x01000000,   ///   1
                           AZAmbiguous = 0x10000000,   /// 1
                         AZAIsVertical = 0x00000011,   ///        11
                       AZAIsHorizontal = 0x00001100,   ///      11

                            AZNotFound = NSNotFound );  //0x11111111,);
#if !TARGET_OS_IPHONE

NS_INLINE NSUI AZAlignToNormalBitmask(AZA a){ return a == AZLft ? 2U : a == AZRgt ? 3U : a == AZTop ? 0U : a == AZBtm ? 1U : NSNotFound; }

#endif

typedef NS_ENUM(NSUI, OSCornerType)         { OSTopLeftCorner = 1,
                                              OSBottomLeftCorner,
                                              OSTopRightCorner = 4,
                                              OSBottomRightCorner = 8 };

NS_INLINE OSCornerType AZAlignToCorner(AZA a) {  return a == AZTopLft ? 1 : a == AZBtmLft ? 2 : AZTopRgt ? 4 :  8; }


JREnumDeclare( AZOrient,  AZOrientVertical, AZOrientHorizontal,  
                          AZOrientTop, AZOrientLeft, AZOrientBottom, AZOrientRight,
                          AZOrientGrid, AZOrientPerimeter, AZOrientFiesta );

#define AZO AZOrient

NS_INLINE AZOrient AZOrientOpposite(AZOrient o) { return o == AZOrientHorizontal ? AZOrientVertical : AZOrientHorizontal; }
NS_INLINE     BOOL isVertical(AZOrient o) { return o == AZOrientVertical; }


typedef NS_ENUM(unsigned short, AZArrow){ AZArrowLeft = 123, AZArrowRight = 124, AZArrowDown =  125, AZArrowUp = 126 };
typedef NS_ENUM(NSUI,    AZOrder){ AZAscending, AZDescending, AZAlphabetically };

JREnumDeclare(azkColor, azkColorNone, azkColorRed, azkColorOrange, azkColorYellow, azkColorGreen, azkColorBlue, azkColorPurple, azkColorGray);

/*** AtoZ Block Types */

typedef void (^AZObjIdxStopBlock)         (id obj, NSUI idx, BOOL *stop);
typedef   id (^AZIndexedAccumulationBlock)(id sum,   id obj, NSUI   idx);

/*! 
@param NSControlActionBlock 
@code
  @property (UNSF) IBOutlet NSButton 	*someButton;
  [_someButton setActionBlock:(NSControlActionBlock) ^(id inSender) { AZLOG(@"xlisidud"); [self doSomeBullshit:nil];	}];
  
*/

typedef void(^SenderEvent)               (id sender, NSEvent* e);

typedef void(^EventBlock)               (NSEvent* e);
typedef void(^NSControlActionBlock)     (id sender);

JREnumDeclare(AZEvent,  AZEventLeftMouseDown = 1, AZEventLeftMouseUp, AZEventRightMouseDown, AZEventRightMouseUp,
                        AZEventMouseMoved, AZEventLeftMouseDragged, AZEventRightMouseDragged, AZEventMouseEntered, AZEventMouseExited,
                        AZEventKeyDown, AZEventKeyUp, AZEventFlagsChanged, 
                        AZEventAppKitDefined, AZEventSystemDefined, AZEventApplicationDefined, AZEventPeriodic, AZEventCursorUpdate,
                        AZEventScrollWheel, AZEventTabletPoint, AZEventTabletProximity,
                        AZEventOtherMouseDown, AZEventOtherMouseUp, AZEventOtherMouseDragged,
                        AZEventEventTypeGesture, AZEventEventTypeMagnify, AZEventEventTypeSwipe, AZEventEventTypeRotate, 
                        AZEventEventTypeBeginGesture, AZEventTypeEndGesture);


typedef void(^NSControlEventActionBlock)(AZEvent e,id sender);
typedef void(^NSControlVoidActionBlock) (void);
typedef void(^ReverseAnimationBlock)    (void);
typedef void(^LayerBlock)               (CALayer *l);



typedef NS_ENUM(NSUI, AMTriangleOrientation){ AMTriangleUp,   AMTriangleDown,
                                              AMTriangleLeft, AMTriangleRight };

JREnumDeclare(AZParity, AZEven, AZOdd, AZUndefined);

JREnumDeclare(AZQuad, AZQuadTopLeft, AZQuadTopRight, AZQuadBotRight, AZQuadBotLeft);

JREnumDeclare( AZConstraintMask,  AZConstraintMaskMinX    = 1 << 0,
                                  AZConstraintMaskMidX    = 1 << 1,
                                  AZConstraintMaskMaxX    = 1 << 2,
                                  AZConstraintMaskWidth   = 1 << 3,
                                  AZConstraintMaskMinY    = 1 << 4,
                                  AZConstraintMaskMidY    = 1 << 5,
                                  AZConstraintMaskMaxY    = 1 << 6,
                                  AZConstraintMaskHeight  = 1 << 7);


//#define AZLft   AZAlignLeft
//#define AZRgt		AZAlignRight
//#define AZTop		AZAlignTop
//#define AZBtm		AZAlignBottom
//#define AZTopLft	AZAlignTopLeft
//#define AZBtmLft	AZAlignBottomLeft
//#define AZTopRgt	AZAlignTopRight
//#define AZBtmRgt	AZAlignBottomRight
//#define AZCntr	AZAlignCenter
//#define AZOutside	AZAlignOutside
//#define AZAAuto	AZAlignAutomatic
//#define AZAUnset	AZAlignUnset



JREnumDeclare(AZCompass,
  AZCompassW          = 0x00000001,
  AZCompassE          = 0x00000010,
  AZCompassN	        = 0x00000100,
  AZCompassS          = 0x00001000,
  AZCompassNW         = 0x00000101,
  AZCompassSW         = 0x00001001,
  AZCompassNE         = 0x00000110,
  AZCompassSE         = 0x00001010,
);

typedef NS_ENUM(int, CharacterSet) {
	kCharacterSet_Newline, kCharacterSet_WhitespaceAndNewline, kCharacterSet_WhitespaceAndNewline_Inverted,
	kCharacterSet_UppercaseLetters, kCharacterSet_DecimalDigits_Inverted, kCharacterSet_WordBoundaries,
	kCharacterSet_SentenceBoundaries, kCharacterSet_SentenceBoundariesAndNewlineCharacter,kNumCharacterSets
};

typedef NS_ENUM (int, AGImageResizingMethod) {	AGImageResizeCrop,AGImageResizeCropStart,	AGImageResizeCropEnd, AGImageResizeScale };



typedef NS_ENUM(int, PXListViewDropHighlight) { PXListViewDropNowhere, PXListViewDropOn,	PXListViewDropAbove, PXListViewDropBelow };



//AZAlignCenter    		= 0x00001111,
//AZAlignOutside  		= 0x00000000,
//AZAlignAutomatic		= 0x11111111





//JREnumDeclare(AZAlign,AZAlignLeft,// = 0x00000001),

/*  expanded....

 typedef enum AZAlign : NSUInteger AZAlign;
 enum AZAlign : NSUInteger { AZAlignLeft 			= 0x00000001,
 AZAlignRight 			= 0x00000010,
 AZAlignTop 				= 0x00000100,
 AZAlignBottom 			= 0x00001000,
 AZAlignTopLeft 		= 0x00000101,
 AZAlignBottomLeft 	= 0x00001001,
 AZAlignTopRight 		= 0x00000110,
 AZAlignBottomRight 	= 0x00001010 };
 extern NSDictionary* AZAlignByValue();
 extern NSDictionary* AZAlignByLabel();
 extern NSString* AZAlignToString(int enumValue);
 extern BOOL AZAlignFromString(NSString *enumLabel, AZAlign *enumValue);
 static NSString *_AZAlign_constants_string = @"" "AZAlignLeft = 0x00000001, AZAlignRight = 0x00000010, AZAlignTop = 0x00000100, AZAlignBottom = 0x00001000, AZAlignTopLeft = 0x00000101, AZAlignBottomLeft = 0x00001001, AZAlignTopRight = 0x00000110, AZAlignBottomRight = 0x00001010";;


				AZAlignNone	= 0, // 0
		AZAlignBottomLeft = 0x10000001, // 2 << 0  (0x1 << 1), // => 0x00000010
			 AZAlignBottom	= 0x00000010,
	  AZAlignBottomRight	= 0x00000110,
	     	  AZAlignRight = 0x00001000,
  	     AZAlignTopRight = 0x00001100,
	          AZAlignTop = 0x00000000,
			AZAlignTopLeft = 0x00000101,
				AZAlignLeft = 0x00011100 // 1 << 0   aka (0x1 << 0), // => 0x00000001
//	       = 0x00001000,
	   = 0x00001001,
	  = 0x00001010
*/




//	AZAlignTopLeft 	   = 0x00000101,
//	AZAlignBottomLeft		= 0x00001001,
//	AZAlignTopRight   	= 0x00000110,
//	AZAlignBottomRight  	= 0x00001010

//CASCROLLVIEW
//minimizing = 0x01, // 00000001
//maximizing = 0x02, // 00000010
//minimized  = 0x04, // 00000100
//maximized  = 0x08  // 00001000

#if !TARGET_OS_IPHONE
//NSDATE NSSTRING ETC
__unused static OSSpinLock _calendarSpinLock = 0;
__unused static OSSpinLock _formattersSpinLock = 0;
__unused static OSSpinLock _staticSpinLock = 0;
#endif

typedef NS_ENUM(NSUInteger, BindType) {BindTypeIfNil, BindTypeTransform, BindTypeSelector, BindTypeNotFound = NSNotFound };


typedef NS_ENUM(NSUInteger, AppCat) {
	Games, Education, Entertainment,
	Books, Lifestyle, Utilities, Business,
	Travel, Music, Reference, Sports,
	Productivity, News, HealthcareFitness,
	Photography, Finance, Medical, SocialNetworking,
	Navigation, Weather, Catalogs, FoodDrink, Newsstand
};

#define AppCatTypeArray @"Games", @"Education", @"Entertainment", @"Books", @"Lifestyle", @"Utilities", @"Business", @"Travel", @"Music", @"Reference", @"Sports", @"Productivity", @"News", @"Healthcare & Fitness", @"Photography", @"Finance", @"Medical", @"Social Networking", @"Navigation", @"Weather", @"Catalogs", @"Food & Drink", @"Newsstand", nil

#if !TARGET_OS_IPHONE

typedef NS_ENUM(NSInteger,  AZStatus) { AZMIXED = NSMixedState, AZOFF =  NSOffState, AZON = NSOnState };
#endif

JREnumDeclare(AZState, AZOff, AZOn, AZModifyingState, AZIdleState, AZCreatingState, AZDeletingState);

JREnumDeclare(AZSectionState, AZCollapsed, AZExpanded);
JREnumDeclare(AZSelectState, AZDeselected, AZSelected);


//typedef NSInteger NSCellStateValue;

typedef NS_ENUM(NSUInteger,    AZSlideState ) { AZIn, AZOut, AZToggle																						};

typedef NS_ENUM(NSUInteger,    AZTrackState ) { LeftOn, LeftOff, TopOn, TopOff, RightOn, RightOff, BottomOn, BottomOff						};
typedef NS_ENUM(NSUInteger,      AZDockSort ) { AZDockSortNatural, AZDockSortColor, AZDockSortPoint, AZDockSortPointNew						};
typedef NS_ENUM(NSUInteger,      AZSearchBy ) { AZSearchByCategory, AZSearchByColor, AZSearchByName, AZSearchByRecent						};
typedef NS_ENUM(NSUInteger,  AZMenuPosition ) { AZMenuN, AZMenuS, AZMenuE, AZMenuW, AZMenuPositionCount											};
typedef NS_ENUM(NSUInteger, AZTrackPosition ) { AZTrackN, AZTrackS, AZTrackE, AZTrackW, AZTrackPositionCount									};
typedef NS_ENUM(NSUInteger,  	AZInfiteScale ) { AZInfiteScale0X, AZInfiteScale1X, AZInfiteScale2X, AZInfiteScale3X, AZInfiteScale10X	};


typedef struct AZWhatever {
	NSUInteger position;
	char *aString;
	int  anInt;
} AZWhatever;

typedef struct {	CGFloat tlX; CGFloat tlY;
	CGFloat trX; CGFloat trY;
	CGFloat blX; CGFloat blY;
	CGFloat brX; CGFloat brY;
} CIPerspectiveMatrix;

//extern NSString *const AZOrientName[AZOrientCount];
//extern NSString *const AZMenuPositionName[AZMenuPositionCount];
// NSLog(@"%@", FormatTypeName[XML]);
//NSString *const FormatTypeName[FormatTypeCount] = { [JSON]=@"JSON", [XML]=@"XML", [Atom] = @"Atom", [RSS] = @"RSS", };

typedef NS_ENUM(NSUInteger, SandBox) {	ReadAccess = R_OK,	WriteAccess = W_OK,	ExecuteAccess = X_OK,	PathExists = F_OK };


NS_INLINE void AZPrintEncodingTypes(){
	NSLog(@"%15s: %s","AZPOS", @encode( AZPOS ));
	NSLog(@"%15s: %s",  "NSP", @encode(   NSPoint ));
	NSLog(@"%15s: %s","NSRGG", @encode( NSRange ));
	NSLog(@"%15s: %s", "NSSZ", @encode(  NSSize ));
	NSLog(@"%15s: %s",  "NSR", @encode(   NSRect ));
	NSLog(@"%15s: %s", "BOOL", @encode(  BOOL ));
	NSLog(@"%15s: %s","AZPOS", @encode( AZPOS ));
	NSLog(@"%15s: %s",  "CGF", @encode(   CGFloat ));
	NSLog(@"%15s: %s", "NSUI", @encode(  NSUInteger));
	NSLog(@"%15s: %s",  "int", @encode(   int ));
	NSLog(@"%15s: %s",  "NSI", @encode(   NSInteger ));
	NSLog(@"%15s: %s", "CGCR", @encode(  CGColorRef ));
	NSLog(@"%15s: %s",   "id", @encode(    id ));
	NSLog(@"%15s: %s",  "NSA", @encode(   NSArray ));
}

JREnumDeclare( AZOutlineCellStyle, 	AZOutlineCellStyleToggleHeader,
												AZOutlineCellStyleScrollList,
												AZOutlineCellStyleScrollListItem );

//NS_INLINE NSA* CAConstraintAttributesForMask(AZConstraintMask mask) {
//
//  return [AZConstraintMaskByValue().allValues reduce:@[] usingBlock:^id(id sum, NSN * bit){
//    return mask & bit.uIV ? [sum arrayByAddingObject:
////  }
//
//}



/*! When defining a new class use the GENERICSABLE macro.
	@code

	  GENERICSABLE(MyClass)
	  @interface MyClass : NSObject<MyClass>
	  @property (nonatomic, strong) NSString* name;
    @end
	
  Now you can use generics with arrays and sets just as you normally do in Java, C#, etc.

  @code
    NSArray<Class>* classArray = @[];
    NSStrtng* meaberName = classArray.lastObJect.name; //No castLng needed :)
*/

#if NS_BLOCKS_AVAILABLE
#define GENERICSABLE(__className) GENERICSABLEWITHOUTBLOCKS(__className) GENERICSABLEWITHBLOCKS(__className)
#else
#define GENERICSABLE(__className) GENERICSABLEWITHOUTBLOCKS(__className)
#endif

#define GENERICSABLEWITHOUTBLOCKS(__className)    \
\
@protocol __className <NSObject> @end             \
@class    __className;                            \
typedef NSComparisonResult(^__className##Comparator)(__className* obj1, __className* obj2); \
\
@interface NSEnumerator (__className##_NSEnumerator_Generics) <__className>                 \
- (__className*) nextObject;  - (NSArray<__className>*)allObjects;  @end                    \
\
@interface NSArray (__className##_NSArray_Generics) <__className> \
\
- (__className*)objectAtIndex:(NSUInteger)index; \
- (NSArray<__className>*)arrayByAddingObject:(__className*)anObject; \
- (NSArray*)arrayByAddingObjectsFromArray:(NSArray<__className>*)otherArray; \
- (BOOL)containsObject:(__className*)anObject; \
- (__className*)firstObjectCommonWithArray:(NSArray<__className>*)otherArray; \
- (NSUInteger)indexOfObject:(__className*)anObject; \
- (NSUInteger)indexOfObject:(__className*)anObject inRange:(NSRange)range; \
- (NSUInteger)indexOfObjectIdenticalTo:(__className*)anObject; \
- (NSUInteger)indexOfObjectIdenticalTo:(__className*)anObject inRange:(NSRange)range; \
- (BOOL)isEqualToArray:(NSArray<__className>*)otherArray; \
- (__className*)lastObject; \
- (NSEnumerator<__className>*)objectEnumerator; \
- (NSEnumerator<__className>*)reverseObjectEnumerator; \
- (NSArray<__className>*)sortedArrayUsingFunction:(NSInteger (*)(__className*, __className*, void *))comparator context:(void *)context; \
- (NSArray<__className>*)sortedArrayUsingFunction:(NSInteger (*)(__className*, __className*, void *))comparator context:(void *)context hint:(NSData *)hint; \
- (NSArray<__className>*)sortedArrayUsingSelector:(SEL)comparator; \
- (NSArray<__className>*)subarrayWithRange:(NSRange)range; \
- (NSArray<__className>*)objectsAtIndexes:(NSIndexSet *)indexes; \
- (__className*)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0); \
\
+ (NSArray<__className>*)array; \
+ (NSArray<__className>*)arrayWithObject:(__className*)anObject; \
+ (NSArray<__className>*)arrayWithObjects:(const id [])objects count:(NSUInteger)cnt; \
+ (NSArray<__className>*)arrayWithObjects:(__className*)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
+ (NSArray<__className>*)arrayWithArray:(NSArray<__className>*)array; \
\
- (NSArray<__className>*)initWithObjects:(const id [])objects count:(NSUInteger)cnt; \
- (NSArray<__className>*)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
- (NSArray<__className>*)initWithArray:(NSArray *)array; \
- (NSArray<__className>*)initWithArray:(NSArray *)array copyItems:(BOOL)flag; \
\
+ (NSArray<__className>*)arrayWithContentsOfFile:(NSString *)path; \
+ (NSArray<__className>*)arrayWithContentsOfURL:(NSURL *)url; \
- (NSArray<__className>*)initWithContentsOfFile:(NSString *)path; \
- (NSArray<__className>*)initWithContentsOfURL:(NSURL *)url; \
\
@end \
\
@interface NSMutableArray (__className##_NSMutableArray_Generics) <__className> \
\
- _Void_ addObjectsFromArray:(NSArray<__className>*)otherArray; \
- _Void_ removeObject:(__className*)anObject inRange:(NSRange)range; \
- _Void_ removeObject:(__className*)anObject; \
- _Void_ removeObjectIdenticalTo:(__className*)anObject inRange:(NSRange)range; \
- _Void_ removeObjectIdenticalTo:(__className*)anObject; \
- _Void_ removeObjectsInArray:(NSArray<__className>*)otherArray; \
\
- _Void_ replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<__className>*)otherArray range:(NSRange)otherRange; \
- _Void_ replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<__className>*)otherArray; \
- _Void_ etArray:(NSArray<__className>*)otherArray; \
- _Void_ sortUsingFunction:(NSInteger (*)(__className*, __className*, void *))compare context:(void *)context; \
\
- _Void_ nsertObjects:(NSArray<__className>*)objects atIndexes:(NSIndexSet *)indexes; \
- _Void_ removeObjectsAtIndexes:(NSIndexSet *)indexes; \
- _Void_ replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<__className>*)objects; \
\
- _Void_ etObject:(__className*)obj atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0); \
\
+ (NSMutableArray<__className>*)array; \
+ (NSMutableArray<__className>*)arrayWithObject:(__className*)anObject; \
+ (NSMutableArray<__className>*)arrayWithObjects:(const id [])objects count:(NSUInteger)cnt; \
+ (NSMutableArray<__className>*)arrayWithObjects:(__className*)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
+ (NSMutableArray<__className>*)arrayWithArray:(NSArray<__className>*)array; \
\
- (NSMutableArray<__className>*)initWithObjects:(const id [])objects count:(NSUInteger)cnt; \
- (NSMutableArray<__className>*)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
- (NSMutableArray<__className>*)initWithArray:(NSArray *)array; \
- (NSMutableArray<__className>*)initWithArray:(NSArray *)array copyItems:(BOOL)flag; \
\
+ (NSMutableArray<__className>*)arrayWithContentsOfFile:(NSString *)path; \
+ (NSMutableArray<__className>*)arrayWithContentsOfURL:(NSURL *)url; \
- (NSMutableArray<__className>*)initWithContentsOfFile:(NSString *)path; \
- (NSMutableArray<__className>*)initWithContentsOfURL:(NSURL *)url; \
\
@end \
\
@interface NSSet (__className##_NSSet_Generics) <__className> \
\
- (__className*)member:(__className*)object; \
- (NSEnumerator<__className>*)objectEnumerator; \
\
- (NSArray<__className>*)allObjects; \
- (__className*)anyObject; \
- (BOOL)containsObject:(__className*)anObject; \
- (BOOL)intersectsSet:(NSSet<__className>*)otherSet; \
- (BOOL)isEqualToSet:(NSSet<__className>*)otherSet; \
- (BOOL)isSubsetOfSet:(NSSet<__className>*)otherSet; \
\
- (NSSet<__className>*)setByAddingObject:(__className*)anObject NS_AVAILABLE(10_5, 2_0); \
- (NSSet<__className>*)setByAddingObjectsFromSet:(NSSet<__className>*)other NS_AVAILABLE(10_5, 2_0); \
- (NSSet<__className>*)setByAddingObjectsFromArray:(NSArray *)other NS_AVAILABLE(10_5, 2_0); \
\
+ (NSSet<__className>*)set; \
+ (NSSet<__className>*)setWithObject:(__className*)object; \
+ (NSSet<__className>*)setWithObjects:(const id [])objects count:(NSUInteger)cnt; \
+ (NSSet<__className>*)setWithObjects:(__className*)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
+ (NSSet<__className>*)setWithSet:(NSSet<__className>*)set; \
+ (NSSet<__className>*)setWithArray:(NSArray<__className>*)array; \
\
- (NSSet<__className>*)initWithObjects:(const id [])objects count:(NSUInteger)cnt; \
- (NSSet<__className>*)initWithObjects:(__className*)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
- (NSSet<__className>*)initWithSet:(NSSet<__className>*)set; \
- (NSSet<__className>*)initWithSet:(NSSet<__className>*)set copyItems:(BOOL)flag; \
- (NSSet<__className>*)initWithArray:(NSArray<__className>*)array; \
\
@end \
\
@interface NSMutableSet (__className##_NSMutableSet_Generics) <__className> \
\
- _Void_ addObject:(__className*)object; \
- _Void_ removeObject:(__className*)object; \
- _Void_ addObjectsFromArray:(NSArray<__className>*)array; \
- _Void_ ntersectSet:(NSSet<__className>*)otherSet; \
- _Void_ inusSet:(NSSet<__className>*)otherSet; \
- _Void_ nionSet:(NSSet<__className>*)otherSet; \
\
- _Void_ etSet:(NSSet<__className>*)otherSet; \
+ (NSSet<__className>*)setWithCapacity:(NSUInteger)numItems; \
- (NSSet<__className>*)initWithCapacity:(NSUInteger)numItems; \
\
@end \
\
@interface NSCountedSet (__className##_NSCountedSet_Generics) <__className> \
\
- (NSSet<__className>*)initWithCapacity:(NSUInteger)numItems;  \
- (NSSet<__className>*)initWithArray:(NSArray<__className>*)array; \
- (NSSet<__className>*)initWithSet:(NSSet<__className>*)set; \
- (NSUInteger)countForObject:(__className*)object; \
- (NSEnumerator<__className>*)objectEnumerator; \
- _Void_ addObject:(__className*)object; \
- _Void_ removeObject:(__className*)object; \
\
@end \

#if NS_BLOCKS_AVAILABLE

#define GENERICSABLEWITHBLOCKS(__className) \
\
@interface NSMutableArray (__className##_NSMutableArray_BLOCKS_Generics) <__className> \
- _Void_ sortUsingComparator:(__className##Comparator)cmptr NS_AVAILABLE(10_6, 4_0); \
- _Void_ sortWithOptions:(NSSortOptions)opts usingComparator:(__className##Comparator)cmptr NS_AVAILABLE(10_6, 4_0); \
@end \
@interface NSSet (__className##_NSSet_BLOCKS_Generics) <__className> \
- _Void_ numerateObjectsUsingBlock:(void (^)(__className* obj, BOOL *stop))block NS_AVAILABLE(10_6, 4_0); \
- _Void_ numerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(__className* obj, BOOL *stop))block NS_AVAILABLE(10_6, 4_0); \
- (NSSet<__className>*)objectsPassingTest:(BOOL (^)(__className* obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0); \
- (NSSet<__className>*)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(__className* obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0); \
@end \

#endif



//GENERICSABLE(NSArray) @interface NSArray (Generics) <NSArray> @end


/*  Created by Benedict Cohen on 10/01/2012.

 A Record is a Block (a.k.a. closure) that returns a struct. Unlike struct, Records handle memory management of their fields.
 The fields can be Objective-C objects or basic C types. Because Records are Blocks they can be treated like objects.

 To declare a Record you must define its fields and implement a function for creating an instance of the record. 2 types are
 available once a record has been declare:
 - A struct that contains the defined fields
 - A block that takes zero arguments and returns a struct

 Declaration example
 ===================
 //Person Record declaration
 RECORD(Person,	RECORD_FIELD_OBJ	(NSString *name)
						RECORD_FIELD_PRM	(float 		age)
 );

 ++++ ---->
 typedef struct Person_ {
 	__unsafe_unretained NSString *name;
	 float age;
 } Person;

 typedef Person(^PersonRecord)(void);
________.

 The creation function must return a Record. All object fields must be captured inside the returned block.

 Creation function example
 =========================
 static PersonRecord createPersonRecord(NSString *name, float age)
 {
 PersonRecord spartacus = ^(void) {
	 	Person p;
		p.name 	= name;
		p.age 	= age;
 return p;
 };
 return spartacus;     //for ARC code

 //for non-ARC code	return (PersonRecord)[[spartacus copy] autorelease];
 }

 Useage example
 ==============
 PersonRecord bill    = createPersonRecord(@"Bill Wyman",     75);
 PersonRecord charlie = createPersonRecord(@"Charlie Wattts", 70);
 PersonRecord keith   = createPersonRecord(@"Keith Richards", 68);
 PersonRecord mick    = createPersonRecord(@"Mick Jagger",    68);
 PersonRecord ronnie  = createPersonRecord(@"Ronnie Wood",    64);

 NSArray *stones = [NSArray arrayWithObjects: bill, charlie, keith, mick, ronnie, nil];

 for (PersonRecord stone in stones)
 {
	 Person p = stone();
	 NSLog(@"%@  %f", p.name, p.age);
 }

 It's worth noting that the creation function has the potentinal to do interesting things.
 */

#define RECORD_FIELD_OBJ(FIELD_TYPE_AND_NAME...) __unsafe_unretained FIELD_TYPE_AND_NAME;
#define RECORD_FIELD_PRM(FIELD_TYPE_AND_NAME...) FIELD_TYPE_AND_NAME;

#define RECORD(RECORD_NAME, FIELDS...) \/*Typedef for struct returned by Record */ \
typedef struct RECORD_NAME ## _ {	FIELDS	} RECORD_NAME; \
typedef RECORD_NAME(^RECORD_NAME ## Record)(void);	/*typedef of Rec. that returns struct*/


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

/*
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

*/
#endif /*END AtoZ_Types_h */