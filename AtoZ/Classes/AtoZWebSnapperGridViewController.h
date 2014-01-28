//
//  AtoZWebSnapperGridViewController.h
//  Paparazzi!
//
//  Created by Alex Gray on 11/30/12.
//
//

#import <Cocoa/Cocoa.h>
#import "AtoZWebSnapper.h"

@interface AtoZWebSnapperGridViewController : NSViewController

@property (nonatomic, retain) AtoZGridViewAuto *grid;
@property (nonatomic, retain) NSMA *images;
@property (assign) IBOutlet AtoZWebSnapper *snapper;

@end
