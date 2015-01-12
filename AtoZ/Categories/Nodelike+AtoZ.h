


@import WebKit.WebView;

@interface WebView (CSS)
- (void) injectCSS:(NSString*)css;
@end

@interface NSString (InRange)
- (BOOL) containsSet:(NSCharacterSet*)set inRange:(NSRange)r;
@property (readonly) BOOL isOnlyWhitespace;
@end

NS_INLINE NSCharacterSet * JSSENTINEL() { static NSCharacterSet * set;

  return set = set ?: ({

    NSMutableCharacterSet *mset = ((NSCharacterSet*)NSCharacterSet.newlineCharacterSet).mutableCopy;
    [mset formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
    mset.copy;
  });
}

