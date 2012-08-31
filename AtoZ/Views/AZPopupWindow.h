
//  AZPopupWindow.h
//  AtoZ

//  Created by Alex Gray on 6/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface AZPopupWindow : NSWindow
{
@private
    NSRect _originalWidowFrame;
    NSRect _originalLayerFrame;
    
    NSView *_oldContentView;
    NSResponder *_oldFirstResponder;
    NSView *_animationView;
    CALayer *_animationLayer;
    
    BOOL _growing;
    BOOL _shrinking;
    BOOL _pretendKeyForDrawing;
}

- (void)popup;

@end