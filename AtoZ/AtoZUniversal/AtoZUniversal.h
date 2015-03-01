
#ifndef AtoZ_AtoZUniversal_h
#define AtoZ_AtoZUniversal_h

#import <AtoZUniversal/AtoZMacroDefines.h>


#define TARGET_IPHONE (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)

//#import "JREnum.h"

#define APPLE_MAIN int main(int argc, char **argv, char **envp, char **apple)
#define APPLEMAIN(...) APPLE_MAIN { ({ __VA_ARGS__; }); }




// In this header, you should import all the public headers of your framework using statements like


#if TARGET_IPHONE
  #import <UIKit/UIKit.h>
  #import <AtoZTouch/AtoZiMacroDefines.h>
#else
  #import <AppKit/AppKit.h>
#import <AtoZUniversal/AZTalker.h>
//  @import AtoZUniversal;
#endif

#import <AtoZUniversal/SubscriptProtocols.h>
#import <AtoZUniversal/BaseModel.h>
#import <AtoZUniversal/F.h>
#import <AtoZUniversal/NSNumber+F.h>
#import <AtoZUniversal/NSDictionary+F.h>
#import <AtoZUniversal/NSArray+F.h>
#import <AtoZUniversal/SubscriptProtocols.h>



FOUNDATION_EXPORT              double AtoZUniversalVersionNumber;   //! Project version number
FOUNDATION_EXPORT const unsigned char AtoZUniversalVersionString[]; //! Project version string

#endif
