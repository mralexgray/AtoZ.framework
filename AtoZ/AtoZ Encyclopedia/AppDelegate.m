//
//  AppDelegate.m
//  AtoZ Encyclopedia
//
//  Created by Alex Gray on 8/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
	//@synthesize pIndi;
	//@synthesize orientButton;
	//@synthesize scaleSlider;

@synthesize window = _window, root, demos, contentLayer;

+ (void) initialize {

//	AZTalker *welcome = [AZTalker new];
//	[welcome say:@"welcome"];

}

-(void) dunno {

//	NSUInteger index = [(NSPopUpButton *)sender selectedTag];
	NSLog(@"Selecting stylesheet %ld",index);

	if (index > 1 ) {
		[[_window contentView] performSelectorOnMainThread:@selector(fadeOut) withObject:nil waitUntilDone:YES];
//		[self selectStyleSheetAtIndex:index];
//		[ibackgroundView fadeIn];
	} else {
//		[ibackgroundView performSelectorOnMainThread:@selector(fadeOut) withObject:nil waitUntilDone:YES];
//		[self selectStyleSheetAtIndex:index];
//		[backgroundView fadeIn];
	}
}

-(void) quadImage {

//	NSString* path = [NSString stringWithFormat:@"%@/Frameworks/AtoZ.framework/Resources/1.pdf", [[NSBundle mainBundle] bundlePath]];
//	[image saveAs:@"/Users/localadmin/Desktop/mystery.png"];

//	CALayer *layer = [CALayer layer];
//	[root setLayer:myLayer];
//	[view setFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
//	root.transform = [contentLayer rectToQuad:[contentLayer bounds] quadTLX:0 quadTLY:0 quadTRX:image.size.width quadTRY:20 quadBLX:0 quadBLY:image.size.height quadBRX:image.size.width quadBRY:image.size.height + 90];
	//
	//[1]: http://codingincircles.com/2010/07/major-misunderstanding/
}


-(void)awakeFromNib{
	
//	NSRect erect = NSInsetRect([[_window contentView] bounds],25,25);
//	ibackgroundView.frame = erect;
//	[ibackgroundView setHidden:YES];
//	[container addSubview:ibackgroundView];
	[_window setDelegate:self];

		//LAYER
	self.root = [CALayer layer];
	root.name = @"root";
	root.backgroundColor = cgORANGE;
	root.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	NSImage *image = [NSImage imageWithFileName:@"1.pdf" inBundleForClass:[AtoZ class]];
	NSLog(@"image:%@", image);
	[image setSize:[_window.contentView bounds].size];
	[root setContents:image];
	[[_window contentView] setLayer:root];
	[[_window contentView] setWantsLayer:YES];
	self.contentLayer = [CALayer layer];
	[root addSublayer:contentLayer];
//	NSRect r =  [AZSizer structForQuantity:[[AtoZ dockSorted]count] inRect:tiny];
	AZSizer *cc = [AZSizer forQuantity:[AtoZ dockSorted].count inRect:[_window frame]];
	[cc.rects eachConcurrentlyWithBlock:^(NSInteger index, id obj, BOOL *stop) {
		CALayer *rrr = [CALayer layer];
		rrr.frame = [obj rectValue];
		rrr.backgroundColor = [[[NSColor yellowColor]colorWithAlphaComponent:RAND_FLOAT_VAL(0,1)] CGColor];
		[contentLayer addSublayer:rrr];
	}];
	[_window.contentView setPostsBoundsChangedNotifications:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:NSViewBoundsDidChangeNotification];
}

-(void) didChangeValueForKey:(NSString *)key {

//	if ( key == NSViewBoundsDidChangeNotification)
//		[self rezhuzh];
//
//}
//
//-(void) rezhuzh {
	NSLog(@"rezhzuhing");
//	[[[AZSizer forQuantity:[AtoZ dockSorted].count inRect:[_window frame]]rects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		[(CALayer*)[contentLayer.sublayers objectAtIndex:idx] setFrame:[obj rectValue]];

//	}];

}


-(IBAction)toggleShake:(id)sender {

	[root flipOver];


}
//	self.contentLayer = [CALayer layer];

//	self.contentLayer.position =  AZCenterOfRect([[_window contentView]frame]);

//	[self quadImage];
//	NSRect r =


/*
	AZSizer *cc = [AZSizer forQuantity:[AtoZ dockSorted].count inRect:[[_window contentView] frame]];
	NSLog(@"rects: %@", cc.rects);

	[[AtoZ dockSorted] each:^(AZFile *file, NSUInteger index, BOOL *stop) {

//		NSRect f = AZMakeRect(
//					randomPointInRect([[_window contentView]bounds]),
//					NSMakeSize(60,50)  );
		AZBlockView *i = [AZBlockView viewWithFrame:[cc.rects[index]rectValue] opaque:YES drawnUsingBlock:^(NSView *view, NSRect dirtyRect) {
			NSColor*d = [view valueForKeyPath:@"dictionary.file.color"];
			[d set];
			NSRectFill(view.bounds);
		}];
		[i setValue:file forKeyPath:@"dictionary.file"];
			//		[[AtoZ sharedInstance] handleMouseEvent:NSMouseEntered inView:i withBlock:^{

		 [i handleMouseEvent:NSMouseExitedMask | NSMouseEnteredMask withBlock:^{
			AZTalker *n = [AZTalker new];
			[n say:[[i valueForKeyPath:@"dictionary.file"]valueForKey:@"name"]];
			[i setNeedsDisplay:YES];
//			[i fadeOut];
		}];
		[i setNeedsDisplay:NO];
		[[_window contentView]addSubview:i];
		NSLog(@"madea v: %@", i.propertiesPlease);
	}];

		//		fileLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
//		fileLayer.backgroundColor = [file.color CGColor];
//		fileLayer.contents = file.image;
//		fileLayer.frame = AZMakeRect(NSMakePoint(
//												 s.width * columnindex,
//												 root.frame.size.height - ((rowindex + 1) * s.height)), s);
//		[root addSublayer:fileLayer];
//
//
//	[self doLayout];
*/

//	[self cells];


-(void) cells {

//    NSRect f = _window.contentView.frame;
//	AZSizer *sizer = [AZSizer forQuantity:[AtoZ dockSorted] inRect:f];

	NSRect tiny = NSInsetRect(_window.frame,200, 199);
	NSRect r =  [AZSizer structForQuantity:[[AtoZ dockSorted]count] inRect:tiny];

    matrix = [[NSMatrix alloc] initWithFrame:tiny mode:NSTrackModeMatrix cellClass:[NSImageCell class] numberOfRows:r.origin.x numberOfColumns:r.origin.y];
	[matrix setCellSize:r.size];//NSMakeSize(100, 100)];
    [matrix sizeToCells];
//	[matrix setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];
	[matrix setBackgroundColor:RANDOMCOLOR];
	[matrix setDrawsBackground:YES];

	[[AtoZ dockSorted] eachConcurrentlyWithBlock:^(NSInteger index, id obj, BOOL *stop) {
		NSImageCell *cell = [[NSImageCell alloc]init];
		cell.tag = index;
//		[matrix setCe]
//		[matrix cellWithTag:index];

											//cellAtRow:0 column:0];

//		[cell setValue:obj forKeyPath:@"dictionary.file"];
//		[cell setImage:[NSImage systemImages].randomElement];//[cell valueForKeyPath:@"dictionary.file.image"]];
		NSLog(@"making cell: %@", cell.description);
		[matrix setCellBackgroundColor:RANDOMCOLOR];
		[matrix setCell:cell];
//		return cell;
	}];
    [[_window contentView] addSubview:matrix];
	NSLog(@"matrix:%@", matrix);
	[matrix setNeedsDisplay:YES];
	[matrix fadeIn];
	AZSimpleView *kk = [AZSimpleView new];
	kk.backgroundColor = RANDOMCOLOR;
	kk.frame = AZLowerEdge(_window.frame, 200);
	[_window.contentView addSubview:(NSView *)kk];
//	Since the NSMatrix is a container for NSCell you need to fill them with something. In the example you posted you can do this by fetching the cell corresponding to your only row and column and setting the image.

}

-(void) applicationDidFinishLaunching:(NSNotification *)notification
{
//	[[[_window contentView] subviews] each:^(id obj, NSUInteger index, BOOL *stop) {
//		[obj setNeedsDisplay:YES];
//	}];
}

- (void) doLayout {

	NSRect r 	= [AZSizer structForQuantity:[AtoZ dockSorted		].count inRect:[[_window contentView] frame]];
		//				   contentLayer.sublayers.count inRect:[[_window contentView] frame]];
	NSLog(@"Sizer rect: %@", NSStringFromRect(r));
	int columns = r.origin.y;
	int rows 	= r.origin.x;
	NSSize s 	= NSMakeSize(r.size.width, r.size.height);
	NSUInteger rowindex,  columnindex;
	rowindex = columnindex = 0;
	for (AZFile *file in [AtoZ dock]) {

		CALayer *fileLayer = [CALayer layer];
		fileLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		fileLayer.backgroundColor = [file.color CGColor];
		fileLayer.contents = file.image;
		fileLayer.frame = AZMakeRect(NSMakePoint(
												 s.width * columnindex,
												 root.frame.size.height - ((rowindex + 1) * s.height)), s);
		[root addSublayer:fileLayer];
		columnindex++;
		if ( ! ((columnindex + 1) <= columns) ) { columnindex = 0; rowindex++; }

			//		CATransform3D rot = [[_window contentView] makeTransformForAngle:270];
			//      imageLayer.transform = rot;
			//		box.identifier = $(@"%ldx%ld", rowindex, columnindex);
	}


}


@end
/*
    [[_window contentView] setWantsLayer:YES];
	root = [CALayer layer];
	[[[_window contentView] layer] addSublayer: root ];
    [root setBackgroundColor:cgRANDOMCOLOR];
	//	root.layoutManager =
	int i = 4;
	while (i != 0) {
		AZBoxLayer *layer = [[AZBoxLayer alloc] initWithImage:[[NSImage systemImages]randomElement] title:$(@"vageen.%i",i)];
		[layer setFrame:CGRectMake(kMargin, 0.0, kIconWidth, kCompositeIconHeight)];
	    [root insertSublayer:layer atIndex:i];
		i--;
	}
		//		:iconPath1 title:@"Desktop"] retain];
		//		[layer1 setFrame:CGRectMake(kMargin, 0.0, kIconWidth, kCompositeIconHeight)];
		//	}	
		//    
		//    layer1 = [[[IconLayer alloc] initWithImagePath:iconPath1 title:@"Desktop"] retain];
		//    [layer1 setFrame:CGRectMake(kMargin, 0.0, kIconWidth, kCompositeIconHeight)];
		//    
		//    layer2 = [[[IconLayer alloc] initWithImagePath:iconPath2 title:@"Firewire Drive"] retain];
		//    [layer2 setFrame:CGRectMake(kMargin, kIconWidth + kMargin, kIconWidth, kCompositeIconHeight)];
		//    
		//    layer3 = [[[IconLayer alloc] initWithImagePath:iconPath3 title:@"Pictures"] retain];
		//    [layer3 setFrame:CGRectMake(kCompositeIconHeight + kMargin, 0.0, 128, kCompositeIconHeight)];
		//    
		//    layer4 = [[[IconLayer alloc] initWithImagePath:iconPath4 title:@"Computer"] retain];
		//    [layer4 setFrame:CGRectMake(kCompositeIconHeight + kMargin, kIconWidth + kMargin, kIconWidth, kCompositeIconHeight)];
		//	
		//    [root insertSublayer:layer1 atIndex:0];
		//    [root insertSublayer:layer2 atIndex:0];
		//    [root insertSublayer:layer3 atIndex:0];
		//    [root insertSublayer:layer4 atIndex:0];
    
}

-(IBAction)toggleShake:(id)sender;
{
	for (AZBoxLayer *obj in [root sublayers] )
		[obj toggleShake];
	
		//    [layer1 toggleShake];
		//    [layer2 toggleShake];
		//    [layer3 toggleShake];
		//    [layer4 toggleShake];
}


@end


*/




@implementation MineField

@synthesize numMines;
@synthesize numExposedCells;
@synthesize kablooey;

-(id)initWithWidth:(int)w Height:(int)h Mines:(int)m {
    self = [super init];
    if (self != nil) {
        int r, c;
        cells = [[NSMutableArray alloc] initWithCapacity: h];
        for (r = 0; r < h; r++) {
            NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity: w];
            [cells addObject: row];
            for (c = 0; c < w; c++) {
                [row addObject: [[Cell alloc] init]];
            }
        }
        numMines = m;
        [self reset]; // place random mines and unexpose all cells
    }
    return self;
}

-(int)width {
    return [[cells objectAtIndex: 0] count];
}

-(int)height {
    return [cells count];
}

-(Cell*)cellAtRow:(int)r Col:(int)c {
    return [[cells objectAtIndex: r] objectAtIndex: c];
}

-(void)reset {
    int w = [self width], h = [self height];
    int n = w*h;  // total cells left
    int m = numMines; // total mines left to place
    int r,c;

    numExposedCells = 0;
    kablooey = NO;

    for (r = 0; r < h; r++) { // reset all cells
        for (c = 0; c < w; c++) {
            Cell *cell = [self cellAtRow: r Col: c];
            cell.exposed = cell.marked = cell.hasMine = NO;
            double p = (double) m / (double) n; // probability of placing mine here
            double g = drand48();  // generate random number 0 <= g < 1
            if (g < p) {
                cell.hasMine = YES;
                m--;
            }
            n--;
        }
    }
    numMines -= m;  // just to be anal, m should be zero at this point

    for (r = 0; r < h; r++) { // compute surrounding mine counts
        for (c = 0; c < w; c++) {
            int i,j, count = 0;
            Cell *cell = [self cellAtRow: r Col: c];
            for (j = -1; j <= +1; j++) {
                for (i = -1; i <= +1; i++) {
                    if (i == 0 && j == 0) continue;
                    int rr = r+j, cc = c+i;
                    if (rr < 0 || rr >= h || cc < 0 || cc >= w) continue;
                    Cell *neighbor = [self cellAtRow: rr Col: cc];
                    if (neighbor.hasMine)
                        count++;
                }
            }
            cell.numSurroundingMines = count;
        }
    }
}

-(int)unexposedCells {
    int w = [self width], h = [self height];
    return w*h - numMines - numExposedCells;
}

	//
	// return value
	//  -2 => no change (cell already exposed, controller shouldn't allow this)
	//  -1 => "BOOM" (new exposed cell contained mine).
	//  0 to 8 => cell safely exposed, number of neighboring mines returned
	//  When 0 returned, its neighbors are (recursively) exposed
	//        controller should rescan grid for exposed cells
	//
-(int)exposeCellAtRow:(int)r Col:(int)c {
    if (kablooey) return -2;
    Cell *cell = [self cellAtRow: r Col: c];
    if (cell.exposed) return -2;
    cell.exposed = YES;
    numExposedCells++;
    if (cell.hasMine) {  // BOOM!
        kablooey = YES;
        return -1;
    }
    int n = cell.numSurroundingMines;
    if (n == 0) {
        int w = [self width], h = [self height];
        BOOL changed;
        do {
            int rr, cc;
            changed = NO;
            for (rr = 0; rr < h; rr++)
                for (cc = 0; cc < w; cc++)
					if ([self autoExposeCellAtRow:rr Col:cc])
                        changed = YES;
        } while (changed);
    }
    return n;
}

-(BOOL)autoExposeCellAtRow:(int)r Col:(int)c {
    Cell *cell = [self cellAtRow: r Col: c];
    if (!cell.exposed && !cell.hasMine) {
        int w = [self width], h = [self height];
        int i,j;
        for (j = -1; j <= +1; j++) {
            for (i = -1; i <= +1; i++) {
                if (i == 0 && j == 0) continue;
                int rr = r+j, cc = c+i;
                if (rr < 0 || rr >= h || cc < 0 || cc >= w) continue;
                Cell *neighbor = [self cellAtRow:rr Col:cc];
                if (neighbor.exposed && neighbor.numSurroundingMines == 0) {
                    cell.exposed = YES;
                    numExposedCells++;
                    return YES;
                }
            }
        }
    }
    return NO;
}

@end



@implementation Cell

@synthesize hasMine;
@synthesize exposed;
@synthesize marked;
@synthesize numSurroundingMines;

-(id)init {
    self = [super init];
    if (self != nil) {
        hasMine = exposed = NO;
        marked = numSurroundingMines = 0;
    }
    return self;
}

@end