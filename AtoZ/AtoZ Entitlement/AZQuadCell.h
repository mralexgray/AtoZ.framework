
//  AZQuadCell.h
//  AtoZ

//  Created by Alex Gray on 8/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.

typedef NS_ENUM(NSUI, AZQuadCellModel) {
								AZQuadCellSingleLetter 	= 0x01, // 00000001
								AZQuadCellIconOnly 		= 0x02, // 00000010
								AZQuadCellIndex  		= 0x04, // 00000100
								AZQuadCellName  		= 0x08, // 00001000

								AZQuadCellRenderAll		= 0x80 /* this hex number = binary 10000000 */
};

@interface AZQuadCell : NSView

- (id)initInWindow:(AZTrackingWindow*)window withObject:(id)thing atIndex:(NSUInteger)index;

@property (weak) AZTrackingWindow* superWindow;
@property (nonatomic, assign) AZWindowPosition position;
@property (weak) 					id objectRep;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSColor *color;
@property (nonatomic, assign) NSFont *font;
@property (nonatomic, assign) CGFloat dynamicStroke;
@end
