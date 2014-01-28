//
//  BGHUDOutlineView.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/20/08.
//


#import "BGHUDOutlineView.h"

@interface NSOutlineView (private)
- (void)_sendDelegateWillDisplayCell:(id)cell forColumn:(id)column row:(NSInteger)row;
@end

@implementation BGHUDOutlineView

#pragma mark Drawing Functions

@synthesize themeKey;

-(id)init {
	
	self = [super init];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
	}
	
	[self setBackgroundColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableBackgroundColor]];
	[self setFocusRingType: NSFocusRingTypeNone];
	
	//Setup Header Cells
	for (NSTableColumn* aColumn in [self tableColumns]) {
		
		//Create new cell and set it's props to that of old cell
		BGHUDTableViewHeaderCell *newHeader = [[BGHUDTableViewHeaderCell alloc] init];
		[newHeader setStringValue: [[aColumn headerCell] stringValue]];
		[newHeader setThemeKey: self.themeKey];
		[newHeader setFont: [[aColumn headerCell] font]];
		
		[aColumn setHeaderCell: newHeader];
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
			
			//Create new cell and set it's props to that of old cell
			BGHUDTableViewHeaderCell *newHeader = [[BGHUDTableViewHeaderCell alloc] init];
			[newHeader setStringValue: [[aColumn headerCell] stringValue]];
			[newHeader setThemeKey: self.themeKey];
			[newHeader setFont: [[aColumn headerCell] font]];
			
			[aColumn setHeaderCell: newHeader];
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
	
	return [[[BGThemeManager keyedManager] themeForKey: self.themeKey] cellHighlightColor];
}

- (void)_sendDelegateWillDisplayCell:(id)cell forColumn:(id)column row:(NSInteger)row {
	
    [super _sendDelegateWillDisplayCell:cell forColumn:column row:row];
	
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

#pragma mark Helper Methods


-(void)awakeFromNib {

	[self setCornerView: [[BGHUDTableCornerView alloc] initWithThemeKey: self.themeKey]];
}


@end
