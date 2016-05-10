//#import AtoZAutoBox
//- (void) openCardAtIndex:(NSUI)@index;
//+ (instancetype) instanceWithImage:(NSIMG*)img imageID:(NSS*)imgID andImageSubTitle:(NSS*) subT andPersonUID:(NSS*)pUID;


@protocol    AZDataSource <NSTableViewDataSource>
- (id)     contactAtIndex:(NSUI)i;
- (NSA*)	contactsInRange:(NSRange)r;
- (NSUI) numberOfContacts;
@end

@interface AtoZContact : BaseModel

_RO	 BOOL   hasImage;
@property  BOOL   cached;
_NC 	NSIMG * image;
_RO 	  NSS * fullName;
_NC 	  NSS * firstName,
                * lastName,
                * company,
                * tel;
@end

@import AtoZUniversal;

@interface AtoZContacts : AtoZSingleton <AZDataSource> - (id) find: x ___
                              @end

@interface   AtoZContacts (Proxied)
+ (NSA*)	contactsInRange:(NSRange)r;
+ (NSA*)    contactImages;
+ (NSA*)         contacts;
@end

