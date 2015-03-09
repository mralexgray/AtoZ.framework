

#if !TARGET_OS_IPHONE


#define BRENDA    [AZTalker randomDicksonism]
#define   SAY(X) ({ [AZTalker sayUntilFinished:ISA(X,NSString) ? X : [X description]]; })
#define AZSAY(X) SAY(X)

@interface AZTalker : BaseModel <NSSpeechSynthesizerDelegate>

+ (void) sayUntilFinished:(NSString*)x;
//+ (void)        sayFormat:(NSString*)fmt,...; // FIX

+ (void) say:(NSString*)x       then:(VBlk)blk;
+ (void) say:(NSString*)x      toURL:(URLBlk)u;
+ (void) say:(NSString*)x     toData:(DTABlk)d;
+ (void) say:(NSString*)x withVolume:(CGF)volm;
+ (void) say:(NSString*)x;


@prop_CP VBlk doneTalking;

@end

//+ (void) randomDicksonism;

//+(NSData*) sayToData:(NSStringtring*)thing;
//- _Void_ say:(NSStringtring*)thing;
#endif