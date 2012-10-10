/**
 
 \class     NUSimpleGradient
 
 \brief     Simple gradient provides a bindings compatible way to create a
            two color gradient.
  
 \author    Eric Methot
 \date      2012-04-13
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <Foundation/Foundation.h>

@interface NUSimpleGradient : NSObject

@property (retain) NSColor *startingColor;
@property (retain) NSColor *endingColor;

@property (readonly,retain) NSGradient *gradient;

+ (id) simpleGradient;

@end
