//
//  NSCell+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 11/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

@import AtoZUniversal;

@interface NSButton (SNRAdditions)
@property (nonatomic, retain) NSColor *textColor;
@property (nonatomic, retain) NSColor *alternateTextColor;
@end


@interface NSCell (AtoZ)

@end
@interface NSCell (TrackingAreaExtensions)
- (void) addTrackingAreasForView:(NSView *)view inRect:(NSRect)cellFrame withUserInfo:(NSD*)userInfo mouseLocation:(NSPoint)currentPoint;
- (void) mouseEntered:(NSEvent *)event;
- (void) mouseExited:(NSEvent *)event;
@end


@interface NSValueTransformer (SRAdditions)
-(void)registerTransformerWithClassName;
@end
@interface RNAddListItemCell : NSTextFieldCell

@property (nonatomic, retain) NSNumber *favorite;
//@property (nonatomic, retain) RNCategory *category;
@property (nonatomic, retain) NSDictionary *titleAttributes;
@property (nonatomic, retain) NSDictionary *selectedTitleAttributes;
@property (nonatomic, retain) NSDictionary *categoryAttributes;
@property (nonatomic, retain) NSDictionary *selectedCategoryAttributes;

//-(NSRect)favoriteRectForBounds:(NSRect)cellFrame;
-(NSRect)categoryRectForBounds:(NSRect)cellFrame;

@end
