
#import "Nodelike+AtoZ.h"
@import WebKit;


@implementation WebView (CSS)
- (void) injectCSS:(NSString*)css {

  DOMDocument  * domD = self.mainFrameDocument;
  DOMElement * styleE = [domD createElement:@"style"];

  [styleE setAttribute:@"type" value:@"text/css"];
  [styleE appendChild:[domD createTextNode:css]];
  [[[domD getElementsByTagName:@"head"] item:0] appendChild:styleE]; // head
}
@end

@implementation NSString (InRange)
- (BOOL) containsSet:(NSCharacterSet*)set inRange:(NSRange)r {

  return [[self substringWithRange:r] rangeOfCharacterFromSet:set].location != NSNotFound;

}
- (BOOL) isOnlyWhitespace {
  return ![self stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet].length;
}
@end
