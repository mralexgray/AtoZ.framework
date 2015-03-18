



#import <AtoZUniversal/AtoZTypes.h>

NSCharacterSet* _GetCachedCharacterSet(CharacterSet set);



BOOL SameChar     (const char*,const char*);
BOOL SameStringI  (NSS*,NSS*);
BOOL SameString   (id,id);
BOOL SameClass    (id,id);
BOOL Same         (id,id);

BOOL IsEmpty      (id);
BOOL IsEven       (NSI);
BOOL IsOdd        (NSI);


// typedef BOOL(*BoolIdId)(id,id);


NSS * AZStringForTypeOfValue      (_ObjC *obj); 				 //(NSString* (^)(void))blk;
NSS * AZToStringFromTypeAndValue	(const char *typeCode, void *val);
NSS * AZStringFromRect						(_Rect rect);
NSS * AZStringFromPoint				    (_Cord p);
NSS * AZStringFromSize            (_Size sz);


_IsIt AZIsEqualToObject (const char * typCd, void * val, id x);
//_ObjC  AZEncodeToObject (const char * typCd, void * val);
