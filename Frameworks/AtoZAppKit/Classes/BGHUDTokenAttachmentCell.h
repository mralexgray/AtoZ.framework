//
//  BGHUDTokenAttachmentCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/11/08.
//


#import <Cocoa/Cocoa.h>
#import "NSTokenAttachmentCell.h"

@interface BGHUDTokenAttachmentCell : NSTokenAttachmentCell {

	NSColor *tokenFillNormal;
	NSColor *tokenFillHighlight;
	NSColor *tokenBorder;
}

@property (copy) NSColor *tokenFillNormal;
@property (copy) NSColor *tokenFillHighlight;
@property (copy) NSColor *tokenBorder;

@end
