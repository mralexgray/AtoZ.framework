
//  ButtonController.h
//  AtoZ

//  Created by Alex Gray on 8/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Foundation/Foundation.h>
#import "AZQuadObject.h"


@interface ButtonController : NSObject
@property (weak) IBOutlet AZQuadCarousel *quads;
- (IBAction)more:(id)sender;
- (IBAction)less:(id)sender;

@end
