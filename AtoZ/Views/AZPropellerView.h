//
//  PCProgressCirlceView.h
//  ProgressBar
//
//  Created by Patrick Chamelo on 8/26/12.
//  Copyright (c) 2012 Patrick Chamelo. All rights reserved.
//


@interface AZPropellerView : NSView

@property (nonatomic, strong) NSColor 	  *color;
@property (nonatomic, strong) NSImageView *progressImage;
@property (nonatomic, strong) NSImageView *badgeView;

- (void) toggle;
- (void) spin;
- (void) stop;

@end
