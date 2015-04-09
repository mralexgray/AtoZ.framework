

#import <AtoZUniversal/AtoZUniversal.h>

#if MAC_ONLY


@interface AZTalker ()
AZPROP(NSSpeechSynthesizer,talker);
@end

@implementation AZTalker static NSMutableArray* queue = nil; static BOOL finished = NO;

- _Void_ setUp { _talker = NSSpeechSynthesizer.new; _talker.delegate = self; queue = NSMA.new; }

- _Void_ say:(NSString *)x {

	NSSpeechSynthesizer.isAnyApplicationSpeaking

  ? [self performSelector:@selector(say:) withObject:x afterDelay:.4]
//  ? [NSThread.mainThread performBlock:^{	[self say:x]; } waitUntilDone:YES]
  : [_talker startSpeakingString:x];

                                                 // performSelector:@selector(say:) withObject:x afterDelay:1];
}

+ (NSSpeechSynthesizer*) talker { return [self.sharedInstance talker]; }

//+ (void) randomDicksonism { SAY(NSString.dicksonisms.randomElement); }


+ (void) sayUntilFinished:(NSString*)x { finished = NO; [self say:x then:^{ finished = YES; }];

  while(!finished) [AZRUNLOOP runMode:NSDefaultRunLoopMode beforeDate:NSDate.date];
}
+ (void) say:(NSString*)x                      { [self.sharedInstance say:x]; }// startSpeakingString:x]; }
+ (void) say:(NSString*)x then:(VBlk)then {

  [self.sharedInstance setDoneTalking:[then copy]];
  [self.sharedInstance say:x]; }

//+ (void) sayFormat:(NSString*)fmt,... {
//
//  va_list argList; va_start(argList, fmt); [self say:[NSString stringWithFormat:fmt arguments:argList]]; va_end(argList);
//}



+ (void) say:(NSString*)x withVolume:(CGF)vol {

  [self.talker setVolume:vol];
  [self.talker startSpeakingString:x];
}

+ (NSU*) tempURL { 	return [NSURL.alloc initFileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:NSUUID.UUID.UUIDString]];
}

+ (void) say:(NSString*)x toData:(void(^)(NSData*d))data {

	NSURL *aURL = [self tempURL];
	[queue addObject:@{@"URL":aURL, @"block":data}];
	[[self.sharedInstance talker] startSpeakingString:x toURL:aURL];
}

+ (void) say:(NSString*)x toURL:(void(^)(NSURL*u))url {

	NSURL *aURL = [self tempURL];
	[queue addObject:@{@"URL":aURL, @"uBlock":url}];
	[[self.sharedInstance talker] startSpeakingString:x toURL:aURL];
}

- _Void_ speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {

	if (!queue.count) { !_doneTalking ?: _doneTalking(); return; }  	NSD *d = queue[0];   NSURL*url = d[@"URL"];

 	if ([d objectForKey:@"uBlock"]) {

    if(d[@"uBlock"]) ((void(^)(NSURL*))d[@"uBlock"])(url);
  }
	else {
		NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingFromURL:d[@"URL"] error:nil];
		NSData* fileContents = nil;

		if (aHandle && (fileContents = aHandle.readDataToEndOfFile) && d[@"block"])   //	NSLog(@"reading:%@ data:%@",d[@"URL"], fileContents);
        ((void(^)(NSData*))d[@"block"])(fileContents);

	}
	[queue removeObjectAtIndex:0];
}

@end


//NSSpeechSynthesizer *talker;
//-- init
//{
//	self = [super init];
//	if (self) {
//
//	}
//	return self;
//}
//	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/say" arguments:@[x]];

#else


#import <AVFoundation/AVFoundation.h>

@interface VSSpeechSynthesizer : NSObject
@property(assign) id delegate;
@property(assign) float rate,volume;
-startSpeakingString _ _Text_ s ___
-startSpeakingString _ _Text_ s toURL:(CFURLRef)URL;
-startSpeakingString _ _Text_ s toURL:(CFURLRef)URL error:(NSError*)e;
-startSpeakingString _ _Text_ s                     error:(NSError*)e;
@end

@interface SpeechSynthesizerDelegate : NSObject @end @implementation SpeechSynthesizerDelegate

+ (void) speechSynthesizer:(VSSpeechSynthesizer*)synth didFinishSpeaking:(BOOL)finished withError:(NSError*)e{

  if(!finished){fprintf(stderr,"E: %s\n",e.localizedDescription.UTF8String);} CFRunLoopStop(CFRunLoopGetMain());
}
@end


#define OPT_RATE 1
#define OPT_VOLUME 2


@implementation AZiTalker

/*
int main(int argc,char** argv) {
  char options=0;
  char* outfn=NULL;
  float s_volume,s_rate;
  int opt;
  while((opt=getopt(argc,argv,"o:r:V:"))!=-1){
    if(!optarg){return 1;}
    if(opt=='o'){outfn=optarg;continue;}
    char ierr=(opt=='r' && (options|=OPT_RATE))?(sscanf(optarg,"%f",&s_rate)!=1):
     (opt=='V' && (options|=OPT_VOLUME))?(sscanf(optarg,"%f",&s_volume)!=1):2;
    if(ierr==2){fprintf(stderr,"Warning: Ignoring option -%c\n",opt);}
    else if(ierr){
      fprintf(stderr,"-%c: Invalid argument\n",opt);
      return 1;
    }
  }
  if(optind>=argc && isatty(fileno(stdin))){
    fprintf(stderr,"Usage: %s [-o output.caf] [-r rate] [-V volume] [string] < [file]\n",argv[0]);
    return 1;
  }
  @autoreleasepool {


    AVAudioSession* session=[AVAudioSession sharedInstance];
    NSError* error;
    if(![session setCategory:AVAudioSessionCategoryPlayback error:&error]){
      fprintf(stderr,"E[AVAudioSession]: %s\n",error.localizedDescription.UTF8String);
    }
    if(![session setActive:YES error:&error]){
      fprintf(stderr,"E[AVAudioSession]: %s\n",error.localizedDescription.UTF8String);
    }
    NSString* string=nil;
    if(optind!=argc-1 || strcmp(argv[optind],"-")!=0){
      NSMutableString* buffer=[NSMutableString string];
      for (opt=optind;opt<argc;opt++){[buffer appendFormat:@"%s ",argv[opt]];}
      if(buffer.length){string=buffer;}
    }
    if(!string){
      string=[NSString.alloc initWithData:[[NSFileHandle
       fileHandleWithStandardInput] readDataToEndOfFile]
       encoding:NSUTF8StringEncoding];
    }
    VSSpeechSynthesizer* synth=[[VSSpeechSynthesizer alloc] init];
    synth.delegate=[SpeechSynthesizerDelegate class];
    if(options&OPT_RATE){synth.rate=s_rate;}
    if(options&OPT_VOLUME){synth.volume=s_volume;}
    if(outfn){
      CFURLRef URL=CFURLCreateFromFileSystemRepresentation(NULL,
       (const UInt8*)outfn,strlen(outfn),false);
      if([synth respondsToSelector:@selector(startSpeakingString:toURL:error:)]){
        [synth startSpeakingString:string toURL:URL error:NULL];
      }
      else {[synth startSpeakingString:string toURL:URL];}
      CFRelease(URL);
    }
    else if([synth respondsToSelector:@selector(startSpeakingString:error:)]){
      [synth startSpeakingString:string error:NULL];
    }
    else {[synth startSpeakingString:string];}
    CFRunLoopRun();
  }
}
*/

@end
#endif