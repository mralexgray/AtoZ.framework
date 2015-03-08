
#import <AtoZUniversal/AtoZUniversal.h>
#include <libkern/OSAtomic.h>

NSCharacterSet * _GetCachedCharacterSet(CharacterSet set) {
  static NSCharacterSet *cache[kNumCharacterSets] = { 0 };

  if (cache[set] == nil) {
  #if !TARGET_OS_IPHONE
    OSSpinLockLock(&_staticSpinLock);
  #endif
    if (cache[set] == nil) {
      switch (set) {
        case kCharacterSet_Newline:
          cache[set] = NSCharacterSet.newlineCharacterSet;
          break;
        case kCharacterSet_WhitespaceAndNewline:
          cache[set] = NSCharacterSet.whitespaceAndNewlineCharacterSet;
          break;
        case kCharacterSet_WhitespaceAndNewline_Inverted:
          cache[set] = [NSCharacterSet.whitespaceAndNewlineCharacterSet invertedSet];
          break;
        case kCharacterSet_UppercaseLetters:
          cache[set] = NSCharacterSet.uppercaseLetterCharacterSet;
          break;
        case kCharacterSet_DecimalDigits_Inverted:
          cache[set] = [NSCharacterSet.decimalDigitCharacterSet invertedSet];
          break;
        case kCharacterSet_WordBoundaries:
          cache[set] = NSMutableCharacterSet.new;
          [(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
          [(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet punctuationCharacterSet]];
          [(NSMutableCharacterSet *)cache[set] removeCharactersInString : @"-"];
          break;
        case kCharacterSet_SentenceBoundaries:
          cache[set] = NSMutableCharacterSet.new;
          [(NSMutableCharacterSet *)cache[set] addCharactersInString : @".?!"];
          break;
        case kCharacterSet_SentenceBoundariesAndNewlineCharacter:
          cache[set] = NSMutableCharacterSet.new;
          [(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet newlineCharacterSet]];
          [(NSMutableCharacterSet *)cache[set] addCharactersInString : @".?!"];
          break;
        case kNumCharacterSets:
          break;
      }
    }
#if !TARGET_OS_IPHONE
    OSSpinLockUnlock(&_staticSpinLock);
#endif
  }
  return cache[set];
}

BOOL SameChar		(const char *a, const char *b) {
  return [$(@"%s", a) isEqualToString:$(@"%s", b)];
}
BOOL SameString	(id a, id b) {
  return [$(@"%@", a) isEqualToString:$(@"%@", b)];
}
BOOL 	SameStringI		(          NSS* a,          NSS* b ){
  return [[$(@"%@", a)lowercaseString] isEqualToString:[$(@"%@", b) lowercaseString]];
}
BOOL SameClass	(id a, id b) {
  return SameString(NSStringFromClass([a class]), NSStringFromClass([b class]));
}

BOOL Same(id a, id b) {
  return a == b
  ? : [a ISKINDA:[NSS class]] && [b ISKINDA:[NSS class]] && [a isEqualToString:b]
  //		?: [thing respondsToString:@"length"] && ![(NSData*)thing length]
  //		?: [thing respondsToString:@"count" ] && ![(NSA*)thing	 count]
  ? : NO;
}

BOOL IsEven(NSI n) { return !(n % 2);   }
BOOL  IsOdd(NSI n) { return !IsEven(n); }

BOOL IsEmpty(id obj) {
  return obj == nil
  ||	  (NSNull *)obj == [NSNull null]
  ||	  ([obj respondsToSelector:@selector(length)] && [obj length] == 0)
  ||	  ([obj respondsToSelector:@selector(count)]	  && [obj count]  == 0);
}

//// Check if the "thing" pass'd is empty
//BOOL IsEmpty(id thing) {
//  return thing == nil
//  ? : [thing ISKINDA:[NSNull class]]
//  ? : [thing respondsToString:@"length"] && ![(NSData *)thing length]
//  ? : [thing respondsToString:@"count" ] && ![(NSA*) thing count]
//  ? : NO;
//}
