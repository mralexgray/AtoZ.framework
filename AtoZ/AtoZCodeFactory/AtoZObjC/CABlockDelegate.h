
/*  CABlockDelegate.h	*//***  AtoZCodeFactory *//*  Created by Alex Gray on 6/1/13. */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef 			 void (^ layoutBlock 	  ) ( CALayer*               );
typedef id<CAAction> (^ layerActionBlock ) ( CALayer*,    NSString* );
typedef 			 void (^ drawBlock 		  ) ( CALayer*, CGContextRef );
typedef         void (^ aniComplete 	  ) ( BOOL,     CAAnimation* );

typedef NS_ENUM ( NSUInteger, CABlockType ){ 	CABlockTypeDrawBlock,		CABlockTypeLayoutBlock, 
																CABlockTypeAniComplete, 	CABlockTypeLayerAction	};
@interface CABlockDelegate : NSObject
// Determines the delegate type, generates an instance, saves itself as property on layer, declares itself as layers delegate, or layoutmanager, etc.  calls setneeds.... blah blah.  returns itself, but chances are you wont evem need to reference it again.
+ (instancetype) delegateFor:(CALayer*)layer ofType:(CABlockType)type withBlock:(id)block;

@property (strong, nonatomic) layoutBlock layoutBlock;// 		  void (^ layoutBlock 	  ) ( CALayer*               );
@property (strong, nonatomic) layerActionBlock layerActionBlock;// id<CAAction> (^ layerActionBlock ) ( CALayer*,   NSString*  );
@property (strong, nonatomic) drawBlock drawBlock;			// void (^ drawBlock 		  ) ( CALayer*, CGContextRef );
@property (strong, nonatomic) aniComplete aniComplete;//			 void (^ aniComplete 	  ) (     BOOL, CAAnimation* );
@end

typedef id (^ transformBlock ) ( id value );
@interface NSObject (AZBlockFactory)
@property (readonly) NSString* properties;
- (void)  bind:(NSString*)b toObject:(id)o withKeyPath:(NSString*)kp transform:(id(^)(id))transformBlock;
- (BOOL)  overrideSelector:  			 (SEL)selector 						withBlock:    (void*)block;
- (void*) superForSelector:		 	 (SEL)selector;
@end

@interface CATransaction (AZBlockFactory)
+ (void) transactionWithLength: (NSTimeInterval)dur actions:(void(^)()) block;
+ (void) transactionWithLength: (NSTimeInterval)dur easing:(id)ease actions:(void(^)()) block;
+ (void) immediately:(void (^)())block;
@end

@interface NSGraphicsContext (AZBlockFactory)
+(void)drawInContext:(CGContextRef)ctx flipped:(BOOL)flipped actions:(void(^)())actions;
-(void)state:(void(^)())actions;
+(void)state:(void(^)())actions;
@end




@interface CALayer (CAScrollLayer_Extensions)
-   (id) scanSubsForClass:		(Class)c;
- (void) scrollBy:				(CGPoint)inDelta;
- (void) scrollCenterToPoint:	(CGPoint)inPoint;
@end




