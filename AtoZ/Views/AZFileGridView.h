//
//  AZFileGridView.h
//  AtoZ
//
//  Created by Alex Gray on 8/26/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@interface AZFileGridView : NSView

- (id)initWithFrame:(NSRect)frame andFiles:(NSArray*)files;



@property (nonatomic, retain) AZSizer *sizer;
@property (nonatomic, retain) NSMutableArray *layers;
@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, retain) CALayer *root;
@property (nonatomic, retain) CALayer *contentLayer;

@end
