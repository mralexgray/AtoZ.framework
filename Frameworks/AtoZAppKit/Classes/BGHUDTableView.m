//
//  BGHUDTableView.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/17/08.
//


#import "BGHUDTableView.h"

@interface NSTableView (private)
- (void)_sendDelegateWillDisplayCell:(id)cell forColumn:(id)column row:(NSInteger)row;
@end

@implementation BGHUDTableView

#pragma mark Drawing Functions

@synthesize themeKey;

-(id)init {
	NSLog(@"Init");
	self = [super init];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		
		[self setBackgroundColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableBackgroundColor]];
		[self setFocusRingType: NSFocusRingTypeNone];
		
		//Setup Header Cells		
		for (NSTableColumn* aColumn in [self tableColumns]) {
			
			if([[aColumn headerCell] class] == [NSTableHeaderCell class]) {
				
				BGHUDTableViewHeaderCell *newHeader = [[BGHUDTableViewHeaderCell alloc] initTextCell: @""];
				[newHeader setThemeKey: [self themeKey]];
				[newHeader setFont: [[aColumn headerCell] font]];
				[aColumn setHeaderCell: newHeader];
			} else {
				
				[[aColumn headerCell] setThemeKey: [self themeKey]];
			}
		}
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
		
	self = [super initWithCoder: aDecoder]; 
	
	if(self) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
		} else {
			self.themeKey = @"gradientTheme";
		}
		
		[self setBackgroundColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableBackgroundColor]];
		[self setFocusRingType: NSFocusRingTypeNone];
		
		//Setup Header Cells
		for (NSTableColumn* aColumn in [self tableColumns]) {
			
			if([[aColumn headerCell] class] == [NSTableHeaderCell class]) {
				
				BGHUDTableViewHeaderCell *newHeader = [[BGHUDTableViewHeaderCell alloc] initTextCell: @""];
				[newHeader setThemeKey: [self themeKey]];
				[newHeader setFont: [[aColumn headerCell] font]];
				[aColumn setHeaderCell: newHeader];
			} else {
				
				[[aColumn headerCell] setThemeKey: [self themeKey]];
			}
		}
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

- (id)_alternatingRowBackgroundColors {
	
	return [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellAlternatingRowColors];
}

- (id)_highlightColorForCell:(id)cell {

	if([self selectionHighlightStyle] == 1) {
		
		return nil;
	} else {
		
		return [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellHighlightColor];
	}
}

- (void)_sendDelegateWillDisplayCell:(id)cell forColumn:(id)column row:(NSInteger)row {
	
    [super _sendDelegateWillDisplayCell: cell forColumn: column row: row];
	
	[[self currentEditor] setBackgroundColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellEditingFillColor]];
	[[self currentEditor] setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
	
	if([[self selectedRowIndexes] containsIndex: row]) {
		
		if([cell respondsToSelector: @selector(setTextColor:)]) {
			[cell setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellSelectedTextColor]];
		}
	} else {
		
		if ([cell respondsToSelector:@selector(setTextColor:)]) {
			[cell setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
		}
	}
}

- (void)_manuallyDrawSourceListHighlightInRect:(NSRect)rect isButtedUpRow:(BOOL)flag {

	if ([NSApp isActive]) {

		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInRect: rect angle: 90];
    } else {

		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInRect: rect angle: 90];
    }
	
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	
	rect = NSInsetRect(rect, 0.5f, 0.5f);
	[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(rect), NSMaxY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
}

- (BOOL)_manuallyDrawSourceListHighlight {
	
	return YES;
}

-(void)awakeFromNib {
	
	[self setCornerView: [[BGHUDTableCornerView alloc] initWithThemeKey: self.themeKey]];
}

#pragma mark Helper Methods



@end
