

#import "TargetConditionals.h"


#ifndef AtoZ_AtoZUniversal_h
#define AtoZ_AtoZUniversal_h

  #define TARGET_IPHONE (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)

  #import "JREnum.h"

  #define APPLE_MAIN int main(int argc, char **argv, char **envp, char **apple)
  #define APPLEMAIN(...) APPLE_MAIN { ({ __VA_ARGS__; }); }


#endif

#if TARGET_IPHONE
  #import <UIKit/UIKit.h>
  #import <AtoZTouch/AtoZiMacroDefines.h>
#else
  #import <AppKit/AppKit.h>
  @import AtoZUniversal;
#endif
