
//  MondoSwitchButtonCALayer.h
//  CocoaMondoKit

//  Created by Matthieu Cormier on 12/8/09.
//  Copyright 2009 Preen and Prune Software and Design. All rights reserved.
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


typedef enum {
	PPNoEvent = (1 << 1),
  PPstandardMouseDown = (1 << 2),
  PPcanDragSwitch = (1 << 3),
  PPdragOccurred = (1 << 4)
} MondoSwitchEventType;

@interface MondoSwitchButtonCALayer : CALayer {

  @private
    CALayer* theSwitch;  
    MondoSwitchEventType _currentEventState;  
    CGImageRef notClickedImgRef, clickedImgRef;  
    CGPoint _mouseDownPointForCurrentEvent;
  
    BOOL _on;
}

@property(nonatomic, getter=isOn) BOOL on;

-(void)mouseDown:(CGPoint)point;
-(void)mouseUp:(CGPoint)point;
-(void)mouseDragged:(CGPoint)point;

-(void)setOn:(BOOL)on animated:(BOOL)animated;

@end
@interface MondoSwitchButtonCALayer (PrivateMethods)
- (void)createtheSwitch;
- (void)switchSide;
- (void)moveSwitch:(CGPoint)point;
- (BOOL)shouldDrag:(CGFloat)dx;
- (CGImageRef)switchImageForPath:(NSBezierPath*)path topColor:(CGFloat)topColor  bottomColor:(CGFloat)bottomColor;
@end

