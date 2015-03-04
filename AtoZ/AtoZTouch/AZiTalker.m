//
//  AZiTalker.m
//  AtoZ
//
//  Created by Alex Gray on 2/13/15.
//  Copyright (c) 2015 mrgray.com, inc. All rights reserved.
//

#import "AZiTalker.h"
#import <AVFoundation/AVFoundation.h>

void AtoZTouchWelcome() {

  system("play /System/Library/CoreServices/AssistiveTouch.app/Drill.aiff");
   NSLog(@"I'm here baby, get used to it");
}


@interface VSSpeechSynthesizer : NSObject
@property(assign) id delegate;
@property(assign) float rate,volume;
-startSpeakingString:(NSString*)_;
-startSpeakingString:(NSString*)_ toURL:(CFURLRef)URL;
-startSpeakingString:(NSString*)_ toURL:(CFURLRef)URL error:(NSError*)e;
-startSpeakingString:(NSString*)_                     error:(NSError*)e;
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
