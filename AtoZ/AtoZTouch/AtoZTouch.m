
#import <AtoZTouch/AtoZTouch.h>


void AtoZTouchWelcome() {

  id sPath = [[NSBundle bundleWithIdentifier:@"com.mrgray.AtoZUniversal"]
                             pathForResource:@"black.people.sweat" ofType:@"aif"];
  [IO justPlay:sPath];
//  [[IO playerForAudio:sPath] play];

//#if TARGET_IPHONE_SIMULATOR
//  @"/System/Library/Sounds/black.people.sweat.aif"
//#else
//  @"/System/Library/CoreServices/AssistiveTouch.app/Drill.aiff"
//#endif
//  ] play];

//  system("play /System/Library/CoreServices/AssistiveTouch.app/Drill.aiff");
   NSLog(@"I'm here (in the %@) baby, get used to it", sPath);
}

_IMPL AtoZTouch


_FINI

