//
//  BGHUDTokenAttachmentCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/11/08.
//


#import "BGHUDTokenAttachmentCell.h"


@implementation BGHUDTokenAttachmentCell

@synthesize tokenFillNormal, tokenFillHighlight, tokenBorder;

- (id)tokenForegroundColor {

	if(![self isHighlighted]) {
		
		return [self tokenFillHighlight];
	} else {
		
		return [self tokenFillNormal];
	}
}

- (id)tokenBackgroundColor {
	
	return [self tokenBorder];
}

- (void)drawWithFrame:(NSRect)fp8 inView:(id)fp24 {
	
	NSMutableAttributedString *newTitle = [[NSMutableAttributedString alloc] initWithAttributedString: [self attributedStringValue]];
	NSRect textRect = fp8;
	
	if(![self isHighlighted]) {
		
		[newTitle beginEditing];
		[newTitle addAttribute: NSForegroundColorAttributeName
						 value: [self textColor]
						 range: NSMakeRange(0, [newTitle length])];
		[newTitle endEditing];
		
		[self setAttributedStringValue: newTitle];
	}
	
	switch ([self controlSize]) {
		
		case NSSmallControlSize:
			
			fp8.size.height = 14;
			
			[newTitle beginEditing];
			[newTitle addAttribute: NSFontAttributeName
							 value: [NSFont controlContentFontOfSize: 10.0f]
							 range: NSMakeRange(0, [newTitle length])];
			[newTitle endEditing];
			
			textRect.origin.y -= 2;
			
			break;
			
		case NSMiniControlSize:

			fp8.size.height = 12;
			
			[newTitle beginEditing];
			[newTitle addAttribute: NSFontAttributeName
							 value: [NSFont controlContentFontOfSize: 8.0f]
							 range: NSMakeRange(0, [newTitle length])];
			[newTitle endEditing];
			
			textRect.origin.y -= 3;
			
			break;
	}
	
	[super drawTokenWithFrame: fp8 inView: fp24];
	
	if([self controlSize] == NSRegularControlSize) {
		
		[super drawInteriorWithFrame: fp8 inView: fp24];
	} else {
		
		[newTitle drawInRect: textRect];
	}
	
}

@end
