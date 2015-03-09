
#ifndef AtoZ_AtoZUniversal_h
#define AtoZ_AtoZUniversal_h

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;
#endif

@import ObjectiveC;
@import WebKit;

@import AtoZAutoBox.OrderedDictionary; // Eliminate


#import <AtoZUniversal/AtoZMacroDefines.h>
#import <AtoZUniversal/metamacros.h>
#import <AtoZUniversal/JREnum.h>
#import <AtoZUniversal/AtoZTypes.h>
#import <AtoZUniversal/BaseModel.h>
#import <AtoZUniversal/F.h>                       // in PCH ^

#import <AtoZUniversal/NSBag.h>
#import <AtoZUniversal/AZRange.h>

#import <AtoZUniversal/EXTSynthesize.h>
#import <AtoZUniversal/EXTConcreteProtocol.h>
#import <AtoZUniversal/NSMethodSignature+EXT.h>
#import <AtoZUniversal/SubscriptProtocols.h>

#import <AtoZUniversal/Protocols.h>
#import <AtoZUniversal/Functions.h>

#import <AtoZUniversal/NSString+AtoZ.h>
#import <AtoZUniversal/NSNumber+AtoZ.h>
#import <AtoZUniversal/NSData+AtoZ.h>
#import <AtoZUniversal/NSArray+AtoZ.h>
#import <AtoZUniversal/NSDictionary+AtoZ.h>
#import <AtoZUniversal/NSObject+AtoZ.h>
#import <AtoZUniversal/NSObject+Properties.h>
#import <AtoZUniversal/NSBundle+AtoZ.h>

#if TARGET_OS_IPHONE

#else

#import <AtoZUniversal/AZTalker.h>

#endif // TARGET_OS_IPHONE

FOUNDATION_EXPORT              double AtoZUniversalVersionNumber;   //! Project version number
FOUNDATION_EXPORT const unsigned char AtoZUniversalVersionString[]; //! Project version string

#endif /// AtoZ_AtoZUniversal_h
