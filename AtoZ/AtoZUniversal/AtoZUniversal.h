
#ifndef AtoZ_AtoZUniversal_h
#define AtoZ_AtoZUniversal_h

#define TARGET_IPHONE (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)

@import Foundation;

#import <AtoZUniversal/AtoZMacroDefines.h>

#define APPLE_MAIN int main(int argc, char **argv, char **envp, char **apple)
#define APPLEMAIN(...) APPLE_MAIN { ({ __VA_ARGS__; }); }

// In this header, you should import all the public headers of your framework using statements like

#if TARGET_IPHONE
  #import <UIKit/UIKit.h>
  #import <AtoZTouch/AtoZiMacroDefines.h>
#else
  #import <AppKit/AppKit.h>
  #import <AtoZUniversal/AZTalker.h>
#endif

#import <AtoZUniversal/SubscriptProtocols.h>
#import <AtoZUniversal/BaseModel.h>
#import <AtoZUniversal/F.h>


FOUNDATION_EXPORT              double AtoZUniversalVersionNumber;   //! Project version number
FOUNDATION_EXPORT const unsigned char AtoZUniversalVersionString[]; //! Project version string

#endif /// AtoZ_AtoZUniversal_h

//#import "JREnum.h"
