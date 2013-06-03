//
//  BGHUDScrollView.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/31/08.
//


#import "BGHUDScrollView.h"


@implementation BGHUDScrollView

@synthesize themeKey;

-(id)init {
	
	self = [super init];
	
	if(self) {
		
		[self setThemeKey: @"gradientTheme"];
		
		[super setVerticalScroller: [[BGHUDScroller alloc] init]];
		[super setHorizontalScroller: [[BGHUDScroller alloc] init]];
	}
	
	return self;
}

-(id)initWithFrame:(NSRect)frame {
	
	self = [super initWithFrame: frame];
	
	if(self) {
		
		[self setThemeKey: @"gradientTheme"];
		
		[super setVerticalScroller: [[BGHUDScroller alloc] init]];
		[super setHorizontalScroller: [[BGHUDScroller alloc] init]];
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			[self setThemeKey: [aDecoder decodeObjectForKey: @"themeKey"]];
		} else {
			[self setThemeKey: @"gradientTheme"];
		}
		
		if(![[super verticalScroller] isKindOfClass: [BGHUDScroller class]]) {
			
			[super setVerticalScroller: [[BGHUDScroller alloc] init]];
		}
		
		if(![[super horizontalScroller] isKindOfClass: [BGHUDScroller class]]) {
			
			[super setHorizontalScroller: [[BGHUDScroller alloc] init]];
		}
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}


@end
