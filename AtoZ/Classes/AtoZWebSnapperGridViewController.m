//
//  AtoZWebSnapperGridViewController.m
//  Paparazzi!
//
//  Created by Alex Gray on 11/30/12.
//
//

#import "AtoZWebSnapperGridViewController.h"

@interface AtoZWebSnapperGridViewController ()

@end

@implementation AtoZWebSnapperGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self != [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) return nil;
	[self awakeFromNib];
	return self;
}
- (void) awakeFromNib {

	self.images = NSMA.new;
	self.grid = [AtoZGridViewAuto.alloc initWithFrame:self.view.bounds];

	_grid.grid.itemSize = AZSizeFromDimension(300);
	[self.view addSubview:_grid];// ? _grid : self.view;
	[_grid fadeIn];
	[self.snapper addObserver:self keyPath:@"snap" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
		NSLog(@"snap snap snap **** %@", self.snapper.snap );
		[_grid insertObject:self.snapper.snap inItemsAtIndex:0];
//		[self insertObject:self.snapper.snap inImagesAtIndex:0];
	}];

}
- (NSUInteger)countOfImages {	return self.images.count;	}

- (id)objectInImagesAtIndex:(NSUI)index	{	return self.images[index];	}

- (void)insertObject:(id)obj inImagesAtIndex:(NSUI)index {	self.images[index] = obj; [self regrid]; }

- (void)removeObjectFromImagesAtIndex:(NSUI)index {	[self.images removeObjectAtIndex:index]; }

- (void)replaceObjectInImagesAtIndex:(NSUI)index withObject:(id)obj {	[self.images replaceObjectAtIndex:index withObject:obj];	}

- (void) regrid {
	NSLog(@"setting grid with: %@", self.images);

	_grid.frame = self.view.bounds;
}

@end
