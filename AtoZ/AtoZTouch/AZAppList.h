
@import AtoZUniversal;

_Type NS_ENUM(_UInt,AZAppIconSize){  AZAppIconSizeSmall = 29,
                                     AZAppIconSizeLarge = 59  };

@KIND(AZAppList) + _Kind_ list; _RO _Dict apps; _RO _UInt appCount;

_LT appsFilteredUsingPredicate:(NSPredicate*)predicate;

- valueForKeyPath __Text_ kp forDisplayIdentifier __Text_ dispID;
-     valueForKey __Text_ kp forDisplayIdentifier __Text_ dispID;

- _Pict_           iconOfSize:(AZAppIconSize)z forDisplayIdentifier __Text_ dispID;
- _IsIt_  hasCachedIconOfSize:(AZAppIconSize)z forDisplayIdentifier __Text_ dispID;
- (CGImageRef) copyIconOfSize:(AZAppIconSize)z forDisplayIdentifier __Text_ dispID CF_RETURNS_RETAINED;

@Stop

extern Text *const ALIconLoadedNotification,
            *const ALDisplayIdentifierKey,
            *const ALIconSizeKey;
