


// Sweetness vs. longwindedness


#define $(...)        ((NSString *)[NSString stringWithFormat:__VA_ARGS__,nil])
#define $array(...)   ((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])
#define $set(...)     ((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])
#define $map(...)     ((NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil])
#define $int(A)       [NSNumber numberWithInt:(A)]
#define $ints(...)    [NSArray arrayWithInts:__VA_ARGS__,NSNotFound]
#define $float(A)     [NSNumber numberWithFloat:(A)]
#define $doubles(...) [NSArray arrayWithDoubles:__VA_ARGS__,MAXFLOAT]
#define $words(...)   [[@#__VA_ARGS__ splitByComma] trimmedStrings]
#define $concat(A,...) { A = [A arrayByAddingObjectsFromArray:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])]; }

#define nilease(A) [A release]; A = nil

#define $affectors(A,...) \
+(NSSet *)keyPathsForValuesAffecting##A { \
  static NSSet *re = nil; \
  if (!re) { \
    re = [[[@#__VA_ARGS__ splitByComma] trimmedStrings] set]; \
  } \
  return re;\
}

#define foreach(B,A) A.andExecuteEnumeratorBlock = \
  ^(B, NSUInteger A##Index, BOOL *A##StopBlock) 

//#define foreach(A,B,C) \
//A.andExecuteEnumeratorBlock = \
//  ^(B, NSUInteger C, BOOL *A##StopBlock)

#define SELFBONK @throw \
  [NSException \
  exceptionWithName:@"WriteThisMethod" \
  reason:@"You did not write this method, yet!" \
  userInfo:nil]

#define GENERATE_SINGLETON(SC) \
static SC * SC##_sharedInstance = nil; \
+(SC *)sharedInstance { \
  if (! SC##_sharedInstance) { \
    SC##_sharedInstance = [[SC alloc] init]; \
  } \
  return SC##_sharedInstance; \
}



#define rand() (arc4random() % ((unsigned)RAND_MAX + 1)) 


#define RED				[NSColor colorWithCalibratedRed:0.797 green:0.000 blue:0.043 alpha:1.000]
#define ORANGE			[NSColor colorWithCalibratedRed:0.888 green:0.492 blue:0.000 alpha:1.000]
#define YELLOw			[NSColor colorWithCalibratedRed:0.830 green:0.801 blue:0.277 alpha:1.000]
#define GREEN			[NSColor colorWithCalibratedRed:0.367 green:0.583 blue:0.179 alpha:1.000]
#define BLUE			[NSColor blueColor]
#define BLACK			[NSColor blackColor]
#define GREY			[NSColor grayColor]
#define WHITE			[NSColor whiteColor]
#define RANDOMCOLOR		[NSColor randomColor]
#define CLEAR			[NSColor clearColor]
#define PURPLE 			[NSColor colorWithCalibratedRed:0.317 green:0.125 blue:0.328 alpha:1.000];
#define LGRAY			[NSColor colorWithCalibratedWhite:.33 alpha:1];

#define cgRED			[RED 		CGColor]
#define cgORANGE		[ORANGE 	CGColor]
#define cgYELLOW		[YELLOW		CGColor]
#define cgGREEN			[GREEN		CGColor]
#define cgPURPLE		[PURPLE		CGColor]

#define cgBLUE			[[NSColor blueColor]	CGColor]
#define cgBLACK			[[NSColor blackColor]	CGColor]
#define cgGREY			[[NSColor grayColor]	CGColor]
#define cgWHITE			[[NSColor whiteColor]	CGColor]
#define cgRANDOMCOLOR	[RANDOMCOLOR	CGColor]
#define cgCLEARCOLOR	[[NSColor clearColor]	CGColor]


// random macros utilizing arc4random()

#define RAND_UINT_MAX		0xFFFFFFFF
#define RAND_INT_MAX		0x7FFFFFFF

// RAND_UINT() positive unsigned integer from 0 to RAND_UINT_MAX
// RAND_INT() positive integer from 0 to RAND_INT_MAX
// RAND_INT_VAL(a,b) integer on the interval [a,b] (includes a and b)
#define RAND_UINT()				arc4random()
#define RAND_INT()				((int)(arc4random() & 0x7FFFFFFF))
#define RAND_INT_VAL(a,b)		((arc4random() % ((b)-(a)+1)) + (a))

// RAND_FLOAT() float between 0 and 1 (including 0 and 1)
// RAND_FLOAT_VAL(a,b) float between a and b (including a and b)
#define RAND_FLOAT()			(((float)arc4random()) / RAND_UINT_MAX)
#define RAND_FLOAT_VAL(a,b)		(((((float)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))

// note: Random doubles will contain more precision than floats, but will NOT utilize the
//        full precision of the double. They are still limited to the 32-bit precision of arc4random
// RAND_DOUBLE() double between 0 and 1 (including 0 and 1)
// RAND_DOUBLE_VAL(a,b) double between a and b (including a and b)
#define RAND_DOUBLE()			(((double)arc4random()) / RAND_UINT_MAX)
#define RAND_DOUBLE_VAL(a,b)	(((((double)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))

// RAND_BOOL() a random boolean (0 or 1)
// RAND_DIRECTION() -1 or +1 (usage: int steps = 10*RAND_DIRECTION();  will get you -10 or 10)
#define RAND_BOOL()				(arc4random() & 1)
#define RAND_DIRECTION()		(RAND_BOOL() ? 1 : -1)


//CGFloat DEGREEtoRADIAN(CGFloat degrees) {return degrees * M_PI / 180;};
//CGFloat RADIANtoDEGREEES(CGFloat radians) {return radians * 180 / M_PI;};

CGImageRef ApplyQuartzComposition(const char* compositionName, const CGImageRef srcImage);
static inline float RandomComponent() {  return (float)random() / (float)LONG_MAX; }

#define rand() (arc4random() % ((unsigned)RAND_MAX + 1)) 


//BOOL flag = YES;
//NSLog(flag ? @"Yes" : @"No");
//?: is the ternary conditional operator of the form:
//condition ? result_if_true : result_if_false
#define StringFromBOOL(b) ((b) ? @"YES" : @"NO")

#define LogProps(a) NSLog(@"%@", a.propertiesPlease)


// degree to radians
#define ARAD	 0.017453f
#define DEG2RAD(x) ((x) * ARAD)

//returns float in range 0 - 1.0f
//usage RAND01()*3, or (int)RAND01()*3 , so there is no risk of dividing by zero
#define RAND01() ((random() / (float)0x7fffffff ))


extern const NSPoint mousePoint;
