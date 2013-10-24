

#import "BaseModel.h"

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


@property (RONLY) NSUI	rows, columns, capacity;
@property (RONLY) NSI	remainder;
@property (RONLY) CGF 	width, height;
@property (RONLY) NSSZ	size;
@property (RONLY) NSS	*aspectRatio;

@property (NATOM) AZOrient		orient;
@property (NATOM) NSR		  outerFrame;
@property (WK) 		NSA	*objects;
@property (NATOM) 	NSUI 	quantity;
AZPROP (NSA, rects);
@property (NATOM,CP) NSMA 	*positions;

@end

//@property (RONLY) 	NSA 	*paths, 	*boxes;
