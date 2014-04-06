/*
 * StickyNoteView.h
 * 
 * Created by Jim McGowan on 04/10/2007.
 * Updated 05/09/2012 for Reference Tracker 2
 *
 * This code uses ARC
 *
 * Copyright (c) Jim McGowan
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * The name Jim McGowan may not be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY JIM MCGOWAN ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL JIM MCGOWAN BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@class StickyNoteView;

@protocol StickyNoteViewDelegate <NSObject>
- (void)stickyNoteViewShouldBeDismissed:(StickyNoteView *)stickyNoteView;
@end

@interface StickyNoteView : NSControl 

@property (weak) id <StickyNoteViewDelegate> delegate;
@property NSSize minSize;
@property NSSize maxSize;
@property NSPoint flippedTopLeftPoint; // bindable
@property (copy) NSColor *noteColor;
@property (copy) NSColor *textColor;

@end



