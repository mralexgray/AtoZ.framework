//
//  XLDragDropView.m
//  XLDragDrop
//
//  Created by Richard Wei on 11-11-21.
//  Copyright (c) 2011 Xinranmsn Labs. All rights reserved.
//

#import "XLDragDropView.h"

@implementation XLDragDropView

@synthesize delegate = _delegate;
@synthesize normalBackgroundImageName = _normalBackgroundImageName, highlightedBackgroundImageName = _highlightedBackgroundImageName, acceptedBackgroundImageName = _acceptedBackgroundImageName;
@synthesize filePath = _filePath;
@synthesize desiredSuffixes = _desiredSuffixes;
@synthesize isFileReady = _isFileReady;

- (void)load {
    _isFileReady = NO;
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self load];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect normalBackgroundImageName:(NSString *)imageName {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self load];
        _normalBackgroundImageName = imageName;
        _currentBackgroundImage = _normalBackgroundImage = [NSImage imageNamed:_normalBackgroundImageName];
    }
    return self;
}

- (void)setCurrentBackgroundImage:(NSImage *)image {
    _currentBackgroundImage = image;
    [self setNeedsDisplay:YES];
}

- (void)setNormalBackgroundImageName:(NSString *)normalBackgroundImageName {
    _normalBackgroundImageName = normalBackgroundImageName;
    _normalBackgroundImage = [NSImage imageNamed:normalBackgroundImageName];
    if (!_isFileReady) [self setCurrentBackgroundImage:_normalBackgroundImage];
}

- (void)setHighlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName {
    _highlightedBackgroundImageName = highlightedBackgroundImageName;
    _highlightedBackgroundImage = [NSImage imageNamed:highlightedBackgroundImageName];
}

- (void)setAcceptedBackgroundImageName:(NSString *)acceptedBackgroundImageName {
    _acceptedBackgroundImageName = acceptedBackgroundImageName;
    _acceptedBackgroundImage = [NSImage imageNamed:acceptedBackgroundImageName];
    if (_isFileReady) [self setCurrentBackgroundImage:_acceptedBackgroundImage];
}

- (void)viewWillDraw {
    if ([(NSObject *)self.delegate respondsToSelector:@selector(dragDropViewWillDraw:)])
        [self.delegate dragDropViewWillDraw:self];
    [super viewWillDraw];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    [self setNeedsDisplay:YES];
    return YES;
}
- (BOOL)resignFirstResponder {
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [_currentBackgroundImage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    [super drawRect:dirtyRect];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
        == NSDragOperationGeneric) {
        NSPasteboard *paste = [sender draggingPasteboard];
        NSArray *types = [NSArray arrayWithObjects:NSFilenamesPboardType, nil];
        NSString *desiredType = [paste availableTypeFromArray:types];
        if ([desiredType isEqualToString:NSFilenamesPboardType]) {
            NSArray *fileArray = [paste propertyListForType:@"NSFilenamesPboardType"];
            NSString *path = [fileArray objectAtIndex:0];
            BOOL hasDesiredSuffix = NO;
            hasDesiredSuffix = [_desiredSuffixes containsObject:path.pathExtension];
            if (hasDesiredSuffix) [self setCurrentBackgroundImage:_highlightedBackgroundImage];
            else return NSDragOperationNone;
        }
        return NSDragOperationGeneric;
    }
    else return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
        == NSDragOperationGeneric) {
        return NSDragOperationGeneric;
    } else {
        return NSDragOperationNone;
    }
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender {
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *paste = [sender draggingPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSFilenamesPboardType, nil];
    NSString *desiredType = [paste availableTypeFromArray:types];
    NSData *carriedData = [paste dataForType:desiredType];
    if (!carriedData) {
        NSRunAlertPanel(@"Paste Error", @"Sorry, but the past operation failed", nil, nil, nil);
        return NO;
    }
    else {
        if ([desiredType isEqualToString:NSFilenamesPboardType]) {
            NSArray *fileArray = [paste propertyListForType:@"NSFilenamesPboardType"];
            NSString *path = [fileArray objectAtIndex:0];
            BOOL hasDesiredSuffix = NO;
            hasDesiredSuffix = [_desiredSuffixes containsObject:path.pathExtension];
            if (!hasDesiredSuffix) {
                [self setCurrentBackgroundImage:_normalBackgroundImage];
                NSLog(@"Not the type we want.");
                if ([(NSObject *)self.delegate respondsToSelector:@selector(dragDropView:didRefuseDroppedFile:)])
                    [self.delegate dragDropView:self didRefuseDroppedFile:path];
                _filePath = @"";
                _isFileReady = NO;
                return NO;
            }
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (!data) {
                if ([(NSObject *)self.delegate respondsToSelector:@selector(dragDropView:didRefuseDroppedFile:)])
                    [self.delegate dragDropView:self didRefuseDroppedFile:path];
                NSRunAlertPanel(@"File Reading Error", [NSString stringWithFormat:@"Failed to open the file at \"%@\"", path], nil, nil, nil);
                _filePath = @"";
                _isFileReady = NO;
                return NO;
            }
            else {
                _filePath = path;
                _isFileReady = YES;
                [self setCurrentBackgroundImage:_acceptedBackgroundImage];
                NSLog(@"Dropped File Path: %@", _filePath);
                if ([(NSObject *)self.delegate respondsToSelector:@selector(dragDropView:didAcceptDroppedFile:)])
                    [self.delegate dragDropView:self didAcceptDroppedFile:_filePath];
            }
        }
        else {
            NSAssert(NO, @"This can't happen");
            return NO;
        }
    }
    return YES;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
    [self setCurrentBackgroundImage:_isFileReady ? _acceptedBackgroundImage : _normalBackgroundImage];
}

@end
