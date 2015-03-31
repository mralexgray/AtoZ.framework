
#import <AtoZUniversal/AtoZUniversal.h>
#include <libkern/OSAtomic.h>


JREnumDefine(azkColor);
JREnumDefine(AZEvent);
JREnumDefine(AZParity);
JREnumDefine(AZQuad);
JREnumDefine(AZConstraintMask);
JREnumDefine(AZAlign);
JREnumDefine(AZOrient);
JREnumDefine(AZCompass);
JREnumDefine(AZState);
JREnumDefine(AZSectionState);
JREnumDefine(AZSelectState);
JREnumDefine(AZOutlineCellStyle);


NSCharacterSet * _GetCachedCharacterSet(CharacterSet set) {
  static NSCharacterSet *cache[kNumCharacterSets] = { 0 };

//  if (cache[set] == nil) {
  #if !TARGET_OS_IPHONE
//    OSSpinLockLock(&_staticSpinLock);
  #endif
    cache[set] = cache[set] ?:
      set == kCharacterSet_Newline ? NSCharacterSet.newlineCharacterSet :
      set == kCharacterSet_WhitespaceAndNewline ? NSCharacterSet.whitespaceAndNewlineCharacterSet :
      set == kCharacterSet_WhitespaceAndNewline_Inverted ? [NSCharacterSet.whitespaceAndNewlineCharacterSet invertedSet] :
      set == kCharacterSet_UppercaseLetters ? NSCharacterSet.uppercaseLetterCharacterSet :
      set == kCharacterSet_DecimalDigits_Inverted ? [NSCharacterSet.decimalDigitCharacterSet invertedSet] :
      set == kCharacterSet_WordBoundaries ? ({
          cache[set] = NSMutableCharacterSet.new;
          [(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
          [(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet punctuationCharacterSet]];
          [(NSMutableCharacterSet *)cache[set] removeCharactersInString : @"-"];
          cache[set]; }) :
      set == kCharacterSet_SentenceBoundaries ? ({
          cache[set] = NSMutableCharacterSet.new;
          [(NSMutableCharacterSet *)cache[set] addCharactersInString : @".?!"];
          cache[set];
    }) :
      set == kCharacterSet_SentenceBoundariesAndNewlineCharacter ? ({
          cache[set] = NSMutableCharacterSet.new;
          [(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet newlineCharacterSet]];
          [(NSMutableCharacterSet *)cache[set] addCharactersInString : @".?!"];
        cache[set];

      }) : cache[set];
//        case kNumCharacterSets:
//          break;
//      }
//    }
#if !TARGET_OS_IPHONE
//    OSSpinLockUnlock(&_staticSpinLock);
#endif
//  }
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




NSS * AZToStringFromTypeAndValue(const char *typeCode, void *val) {
  //  Compare
  return  SameChar(typeCode, @encode(  NSP)) ? AZStringFromPoint(*(NSP*)   val)
  : SameChar(typeCode, @encode(NSRNG)) ? NSStringFromRange(*(NSRNG*) val)
  // 		    : SameChar(typeCode, @encode(  RNG)) ?   AZRangeToString(*(RNG*)   val)
  : SameChar(typeCode, @encode( NSSZ)) ?  AZStringFromSize(*(NSSZ*)  val)
  : SameChar(typeCode, @encode(  NSR)) ?  AZStringFromRect(*(NSR*)   val)
  : SameChar(typeCode, @encode( BOOL)) ?    $B(*(BOOL*)  val)
  : SameChar(typeCode, @encode(  CGF)) ? $(@"%2.f",        *((CGF*)  val))
  : SameChar(typeCode, @encode( NSUI)) ? $(@"%lu",         *((NSUI*) val))
  : SameChar(typeCode, @encode(  int)) ? $(@"%d",          *((int*)  val))
  : SameChar(typeCode, @encode(  NSI)) ? $(@"%ld",         *((NSI*)  val))
  : SameChar(typeCode, @encode(   id)) ? $(@"%@", (__bridge NSO*)val)
//  : SameChar(typeCode, @encode( CGCR)) ? $(@"cg%@", [NSC colorWithCGColor:*((CGCR*)val)].name) // FIX!
  : nil;
}

_Text AZStringForTypeOfValue(_ObjC *obj) {
  return AZToStringFromTypeAndValue((const char *)@encode(__typeof__(obj)), (void*)obj);
}

_Text AZStringFromPoint(_Cord p) { return $(@"[x.%0.f y.%0.f]", p.x, p.y); }
_Text  AZStringFromSize(_Size s) { return $(@"[w.%1.f h.%1.f]", s.width, s.height); }
_Text  AZStringFromRect(_Rect r) { return $($(@"{{%%%@ld x %%%@ld},{%%%@ld x %%%@ld}}", r.origin.x > 100 ? @"3" : @"2",
                                           r.origin.y   > 100 ? @"3" : @"2",
                                           r.size.width > 100 ? @"3" : @"2",
                                           r.size.width > 100 ? @"-3" : @"-2"),
                                         (NSI)r.origin.x,(NSI)r.origin.y, (NSI)r.size.width, (NSI)r.size.height); }



id _AZEncodeToObject /*_box */			( const char *encoding, const void *value)	{

	char e = encoding[0]=='r' ? encoding[1] : encoding[0]; // ignore 'const' modifier 	// file:///Developer/Documentation/DocSets/com.apple.ADC_Reference_Library.DeveloperTools.docset/Contents/Resources/Documents/documentation/DeveloperTools/gcc-4.0.1/gcc/Type-encoding.html
	switch( e ) {
		case 'c':   return @(*(char*)					value);
		case 'C':   return [NSNumber numberWithUnsignedChar: *(char*)value];
		case 's':   return @(*(short*)					value);
		case 'S':   return @(*(unsigned short*)		value);
		case 'i':   return @(*(int*)					value);
		case 'I':   return @(*(unsigned int*)		value);
		case 'l':   return @(*(long*)					value);
		case 'L':   return @(*(unsigned long*)		value);
		case 'q':   return @(*(long long*)			value);
		case 'Q':   return @(*(unsigned long long*)value);
		case 'f':   return @(*(float*)					value);
		case 'd':   return @(*(double*)				value);
		case '*':   return @(*(char**)					value);
		case '@':   return (__bridge id)				value;
		default:    return [NSValue value: value withObjCType: encoding];
	}
}

//  id       (const char * typeCode, void * value)  { return _box(typeCode, value); }

BOOL            AZIsEqualToObject (const char * typeCode, void * value, id obj) { id x = _AZEncodeToObject(typeCode, value);

    return ((!obj && x) || (!x && obj))   ? NO :  // one or the other is nil, but not both.
           [obj class] != [x class]       ? NO : // differen=t classes.
           [obj class] == NSNumber.class  ? [obj isEqualToNumber:x] :
           [obj class] == NSValue.class   ? [obj isEqualToValue:x]  : [obj isEqual:x];
}

#if MAC_ONLY
NSString* NSStringFromCGRect(CGRect rect) {
	return NSStringFromRect(NSRectFromCGRect(rect));
}

NSString* NSStringFromCGPoint(CGPoint p) {
	return NSStringFromPoint(NSPointFromCGPoint(p));
}
#endif