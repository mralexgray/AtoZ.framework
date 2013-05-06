//
//  AtoZContacts.h
//  AtoZ
//
//  Created by Alex Gray on 5/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZUmbrella.h"


@interface AtoZContact : BaseModel

//+ (instancetype) instanceWithImage:(NSIMG*)img imageID:(NSS*)imgID andImageSubTitle:(NSS*) subT andPersonUID:(NSS*)pUID;

@property (CP,NATOM) 	NSIMG *image;
@property (CP,NATOM) 	NSS 	*firstName, *lastName, *company;
@property (RONLY) 		NSS 	*fullName;
@property (RONLY) 		BOOL	 hasImage;
@property (ASS) 			BOOL 		cached;

@end

@protocol AZDataSource <NSTableViewDataSource>

-   (id)	contactAtIndex:(NSUI)i;
- (NSUI) numberOfContacts;
- (NSA*)	contactsInRange:(NSRange)r;

@end
@interface AtoZContacts : AZSingleton <AZDataSource>

//- (void) openCardAtIndex:(NSUI)index;
-   (id) find:				   (id)sender;
@end

