//
//  AZBoxMagic.m
//  AtoZ
//
//  Created by Alex Gray on 7/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZBoxMagic.h"
#import "AtoZ.h"
@interface AZBoxMagic ()
@property NSSize cellSize;
@property NSUInteger rows;
@property NSUInteger columns;
@property NSMutableArray *filingCabinet;
@end

@implementation AZBoxMagic
@synthesize cellSize, rows, columns, filingCabinet;
@synthesize dataSource;

- (id)initWithFrame:(NSRect)frame {
	if ((  self = [super initWithFrame:frame] )) {
	
			filingCabinet = [NSMutableArray array];		
	}
	return self;
}

- (void) drawRect:(NSRect)dirtyRect
{
}

- (void) reload {
	NSLog(@"reload called.  datasource is %@", self.dataSource);
	NSUInteger totes =  [dataSource totalFilesToBeBoxedIn:self];
	self.rows = ceil(sqrt(totes));
	self.columns = ceil(totes/ceil(sqrt(totes)));
	//	//		float sizer =  ();// self.desiredNumberOfRows);
	NSSize s = NSMakeSize([self frame].size.width/self.columns, [self frame].size.height/self.rows );
	self.cellSize =  s;
	NSLog(@"computed rows: %ld, cols:%ld. cellsize: %@", rows, columns, NSStringFromSize(cellSize));
	NSUInteger rowindex; NSUInteger columnindex;
	rowindex = columnindex = 1;
	[AZStopwatch start:@"boxFactory"];
	for (int i=0; i < totes; i++) {
		if (columnindex < columns) columnindex++; else { columnindex = 1; rowindex++; }
		AZFile * file = [dataSource magicView:self fileForIndex:i];
		NSRect fileframe = NSMakeRect( 	cellSize.width * (columnindex - 1), 
										self.frame.size.height - (rowindex * cellSize.height),
										self.cellSize.width, self.cellSize.height);
		AZBox *box = [[AZBox alloc]initWithFrame:fileframe representing:file atIndex:i];
		box.identifier = $(@"%ldx%ld", rowindex, columnindex);
		[self addSubview:box];
		NSLog(@"filing a box @ %ldx%ld frame:%@", rowindex, columnindex, NSStringFromRect(fileframe));
		[self.filingCabinet insertObject:box atIndex:i];
	}	
	[AZStopwatch stop:@"boxFactory"];
}
	
//	[missingIndicies enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop){
//		AZBox *cell = [[self dataSource] collectionView:self cellForIndex:index];
//		if(!cell)
//			return;
//		if([selection containsIndex:index])
//			[cell setSelected:YES];
//		[cell setIndex:index];
//		[cell setFrame:[self rectForCellAtIndex:index]];
//		//		[cell setHidden:YES];
//		[self addSubview:cell];
//		//		[cell fadeIn];
//		//		[self per performSelector:@selector(fadeIn) afterDelay:index*.01];
//		[visibleCells setObject:cell forKey:[NSNumber numberWithUnsignedInteger:index]];
//	}];
//}

	

@end
