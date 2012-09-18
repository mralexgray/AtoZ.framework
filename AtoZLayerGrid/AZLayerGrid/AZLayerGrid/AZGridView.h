//
//  AZGridView.h
//  AZLayerGrid
//
//  Created by Alex Gray on 7/20/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AZSizer;
@interface AZGridView : NSView
@property (nonatomic, strong) NSArray *content;
@property (strong, nonatomic) CALayer *root;
@property (strong, nonatomic) CALayer *contentLayer;

@property (nonatomic, strong) AZSizer *ss;
@end
