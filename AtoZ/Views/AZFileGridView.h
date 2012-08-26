//
//  AZFileGridView.h
//  AtoZ
//
//  Created by Alex Gray on 8/26/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZFileGridView : NSView

- (id)initWithFrame:(NSRect)frame andFiles:(NSArray*)files;

@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) CALayer *root;
@property (nonatomic, retain) CALayer *contentLayer;

@end
