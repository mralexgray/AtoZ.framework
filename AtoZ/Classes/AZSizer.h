

#import "AtoZUmbrella.h"


/* Standard C Function: Greatest Common Divisor */
NS_INLINE NSI gcd ( NSI a, NSI b ){ NSI c; while ( a != 0 ) { c = a; a = b%a;  b = c; } return b; }
/* Recursive Standard C Function: Greatest Common Divisor */
NS_INLINE NSI gcdr ( NSI a, NSI b ){ if ( a==0 ) return b; return gcdr ( b%a, a ); }

//NS_INLINE NSUI gcd(NSI m,NSUI n) { NSI t,r; if(m<n){t=m; m=n; n=t; } r=m%n; return r==0?n:gcd(n,r); // MSLog(@"remainder for %i is %i", n, r);}
@interface AZSizer : BaseModel 

+ (AZSizer*)  forQuantity: (NSUI)q			   ofSize:(NSSZ)s  withColumns:(NSUI)c;
+ (AZSizer*)   forObjects: (NSA*)objects  withFrame:(NSR)aFrame arranged:(AZOrient)arr;
+ (AZSizer*)  forQuantity: (NSUI)aNumber aroundRect:(NSR)aFrame;
+ (AZSizer*)  forQuantity: (NSUI)aNumber	   inRect:(NSR)aFrame;
+ (NSR) structForQuantity: (NSUI)aNumber	   inRect:(NSR)aFrame;
+ (NSR)   rectForQuantity: (NSUI)q 			   ofSize:(NSSize)s withColumns:(NSUI)c;
+ (NSA*)  rectsForColumns: (NSUI)ct 			inRect:(NSR)frame;
- (NSR)	 	 rectForPoint: (NSP)point;


@prop_RO NSUI	rows, columns, capacity;
@prop_RO NSI	remainder;
@prop_RO CGF 	width, height;
@prop_RO NSSZ	size;
@prop_RO NSS	*aspectRatio;

@property (NATOM) AZOrient		orient;
@property (NATOM) NSR		  outerFrame;
@property (WK) 		NSA	*objects;
@property (NATOM) 	NSUI 	quantity;
AZPROP (NSA, rects);
@property (NATOM,CP) NSMA 	*positions;

@end

//@prop_RO 	NSA 	*paths, 	*boxes;


NSR 						AZRectForItemsWithColumns	( NSA    *items, NSUI cols );

@interface NSImage (Merge)
/*!	@brief	Returns an image constructed by tiling a given array of images side-by-side or top-to-bottom.
 		@param	spacingX  Spacing which will be applied horizontally between images, and at the left and right borders.
 		@param	spacingY  Spacing which will be applied vertitally between images, and at the bottom and top borders.
 		@param	vertically  YES to tile the given images from top to bottom, starting with the first image in the array at the top. NO to tile the given images from left to right, starting with the first image in the array at the left.	*/

+ (NSIMG*) contactSheetWith:(NSA*)imgs   columns:(NSUI)cols;                      // I guess this is natiral size?
+ (NSIMG*) contactSheetWith:(NSA*)imgs withSizer:(AZSizer*)s withName:(BOOL)name; // sortaconvenient..
+ (NSIMG*) contactSheetWith:(NSA*)imgs   inFrame:(NSR)rect;//  columns:(NSUI)cols;
+ (NSIMG*) contactSheetWith:(NSA*)imgs   inFrameWithNames:(NSR)rect;

+ (NSIMG*) contactSheetWith:(NSA*)imgs sized:  (NSSZ)size spaced:(NSSZ)spacing columns:(NSUI)cols;
+ (NSIMG*) contactSheetWith:(NSA*)imgs sized:  (NSSZ)size spaced:(NSSZ)spacing columns:(NSUI)cols withName:(BOOL)name;
+ (NSIMG*) imageByTilingImages:(NSA*)imgs spacingX:(CGF)x spacingY:(CGF)y vertically:(BOOL)vertically;
- (NSIMG*) imageBorderedWithInset: (CGF)inset;
- (NSIMG*) imageBorderedWithOutset:(CGF)outset;			@end  // (MERGE)
