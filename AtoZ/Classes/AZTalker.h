

#import "AtoZUmbrella.h"

#define BRENDA    [AZTalker randomDicksonism]
#define   SAY(X) ({ [AZTalker sayUntilFinished:ISA(X,NSS) ? X : [X description]]; })
#define AZSAY(X) SAY(X)

@interface AZTalker : BaseModel <NSSpeechSynthesizerDelegate>

+ (void) sayUntilFinished:(NSS*)x;
+ (void)        sayFormat:(NSS*)fmt,...;

+ (void) say:(NSS*)x       then:(VBlk)blk;
+ (void) say:(NSS*)x      toURL:(URLBlk)u;
+ (void) say:(NSS*)x     toData:(DTABlk)d;
+ (void) say:(NSS*)x withVolume:(CGF)volm;
+ (void) say:(NSS*)x;

+ (void) randomDicksonism;

@prop_CP VBlk doneTalking;

@end


//+(NSData*) sayToData:(NSString*)thing;
//- (void) say:(NSString*)thing;
