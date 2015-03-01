


#import <AtoZUniversal/AtoZMacroDefines.h>
#import <AtoZUniversal/F.h>


#define BRENDA    [AZTalker randomDicksonism]
#define   SAY(X) ({ [AZTalker sayUntilFinished:ISA(X,NSString) ? X : [X description]]; })
#define AZSAY(X) SAY(X)

@interface AZTalker : BaseModel <NSSpeechSynthesizerDelegate>

+ (void) sayUntilFinished:(NSString*)x;
+ (void)        sayFormat:(NSString*)fmt,...;

+ (void) say:(NSString*)x       then:(void(^)())blk;
+ (void) say:(NSString*)x      toURL:(URLBlk)u;
+ (void) say:(NSString*)x     toData:(DTABlk)d;
+ (void) say:(NSString*)x withVolume:(CGF)volm;
+ (void) say:(NSString*)x;

+ (void) randomDicksonism;

@prop_CP VBlk doneTalking;

@end


//+(NSData*) sayToData:(NSStringtring*)thing;
//- (void) say:(NSStringtring*)thing;
