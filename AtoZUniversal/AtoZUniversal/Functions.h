



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