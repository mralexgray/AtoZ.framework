

#import "AtoZ.h"
#import "AtoZUmbrella.h"

extern NSUInteger gcd(NSI m, NSUI n);

@interface AZSizer : BaseModel 

+ (AZSizer*)  forQuantity:(NSUI)q			ofSize:(NSSZ)s  withColumns:(NSUI)c;
+ (AZSizer*)   forObjects: (NSA*)objects  withFrame:(NSR)aFrame arranged:(AZOrient)arr;
+ (AZSizer*)  forQuantity: (NSUI)aNumber aroundRect:(NSR)aFrame;
+ (AZSizer*)  forQuantity: (NSUI)aNumber	 inRect:(NSR)aFrame;
+ (NSR) structForQuantity: (NSUI)aNumber	 inRect:(NSR)aFrame;
+ (NSR)   rectForQuantity: (NSUI)q 			 ofSize:(NSSize)s  	withColumns:(NSUI)c;
- (NSR)	  rectForPoint: (NSP)point;

@property (NATOM, ASS)   AZOrient		orient;
@property (NATOM, ASS)   NSR		outerFrame;

@property (RONLY) 		 NSUI	rows, 		columns,		capacity;
@property (RONLY) 		 NSI	remainder;
@property (RONLY) 		 CGF 	width, 		height;
@property (NATOM, RONLY) NSSZ	size;
@property (RONLY) 		 NSA 	*paths, 	*boxes;
@property (RONLY) 		 NSS	*aspectRatio;

@property (weak) 		NSA		*objects;
@property (NATOM, ASS) 	NSUI 	quantity;
@property (NATOM, CP) 	NSA 	*rects;
@property (NATOM, CP) 	NSMA 	*positions;


@end

