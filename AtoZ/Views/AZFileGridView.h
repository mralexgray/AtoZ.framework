
//  AZFileGridView.h
//  AtoZ

//  Created by Alex Gray on 8/26/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@class AZSizer;
@interface GridLayer : CAConstraintLayoutManager
@property (nonatomic, retain) AZSizer *sizer;
@end

@class AZSizer, GridLayoutManager;
@interface AZFileGridView : NSView

- (id)initWithFrame:(NSRect)frame andFiles:(NSArray*)files;

@property (nonatomic, retain) AZSizer *sizer;
@property (nonatomic, retain) NSMutableArray *layers;
@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) CALayer *root;
@property (nonatomic, retain) GridLayoutManager *gridManager;
@property (nonatomic, retain) CALayer *contentLayer;
@property (nonatomic, retain) CALayer *gridLayer;
@property (nonatomic, retain) CALayer *veil;
- (CALayer*)layerAt:(NSUInteger)idx;

@end
