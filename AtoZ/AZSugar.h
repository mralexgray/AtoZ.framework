


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
