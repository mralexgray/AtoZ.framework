/**
 
 \category  CATextLayer(AttributedString)
 
 \brief     Automates combining other layer attributes into an attributed string.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */


#import <QuartzCore/QuartzCore.h>

@interface CATextLayer (AttributedString)

/**
 
 fontAttributes
 
 \brief   combines the font and fontSize into a NSDictionary appropriate
          for creating attributed strings.
 
 \details Regarding the font property, both CGFontRef and NSFont are supported.
          If necessary, CGFontRefs are converted to NSFont.
 
 */
@property (readonly) NSDictionary *fontAttributes;


/**
 
 attributedString
 
 \brief   combines the string with fontAttributes to form an attributed string.
 
 \details If the string property is already an attributedString then
          its value is simply returned. Otherwise, an attributed string
          is built using the string as the text and the dictionary from the
          fontAttributes property.

 */
@property (readonly) NSAttributedString *attributedString;

@end
