#import <Foundation/NSObject.h>

@class NSKeyPathObserver,NSArray;

@interface NSKeyObserver : NSObject {
   id				 _object;
   NSString		  *_key;
   NSKeyPathObserver *_keyPathObserver;
   NSString		  *_branchPath;
   NSKeyObserver	 *_branchObserver;
   NSArray		   *_dependantKeyObservers;
   BOOL			   _isValid;
}

-initWithObject:object key:(NSS*)key keyPathObserver:(NSKeyPathObserver *)keyPathObserver restOfPath:(NSS*)restOfPath;

-(BOOL)isValid;
-(void)invalidate;

-object;
-(NSS*)key;
-(NSKeyPathObserver *)keyPathObserver;

-(NSS*)restOfPath;

-(NSKeyObserver *)restOfPathObserver;
-(void)setRestOfPathObserver:(NSKeyObserver *)keyObserver;

-(NSA*)dependantKeyObservers;
-(void)setDependantKeyObservers:(NSA*)keyObservers;

@end
