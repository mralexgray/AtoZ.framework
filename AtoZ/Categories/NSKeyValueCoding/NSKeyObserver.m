#import "NSKeyObserver.h"
#import <Foundation/NSString.h>

@implementation NSKeyObserver

-initWithObject:object key:(NSS*)key keyPathObserver:(NSKeyPathObserver *)keyPathObserver restOfPath:(NSS*)restOfPath {
   _object=object;
   _key=[key copy];
	_keyPathObserver=keyPathObserver;// retain];
   _branchPath=[restOfPath copy];
   _isValid=YES;
   return self;
}

-(void)dealloc {
   [_key release];
//   [_keyPathObserver release];
   [_branchPath release];
   [_branchObserver release];
   [_dependantKeyObservers release];
//   [super dealloc];
}

-(BOOL)isValid {
   return _isValid;
}

-(void)invalidate {
   _isValid=NO;
}

-object {
   return _object;
}

-(NSS*)key {
   return _key;
}

-(NSKeyPathObserver *)keyPathObserver {
   return _keyPathObserver;
}

-(NSS*)restOfPath {
   return _branchPath;
}

-(NSKeyObserver *)restOfPathObserver {
   return _branchObserver;
}

-(void)setRestOfPathObserver:(NSKeyObserver *)keyObserver {
	keyObserver=keyObserver;// retain];
   [_branchObserver release];
   _branchObserver=keyObserver;
}

-(NSA*)dependantKeyObservers {
   return _dependantKeyObservers;
}

-(void)setDependantKeyObservers:(NSA*)keyObservers {
	keyObservers=keyObservers;// retain];
   
   [_dependantKeyObservers release];
   _dependantKeyObservers=keyObservers;
}

-(NSS*)description {
   return [NSString stringWithFormat:@"<%@ %@ _object: %@ _key: %@ _branchPath: %@>",isa,self,_object,_key,_branchPath];
}

@end
