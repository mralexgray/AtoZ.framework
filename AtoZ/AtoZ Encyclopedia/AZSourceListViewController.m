//
//  AZSourceListViewController.m
//  AtoZ
//
//  Created by Alex Gray on 8/20/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZSourceListViewController.h"

@interface AZSourceListViewController ()
{
	NSMutableArray *sourceListItems;

//	__unsafe_unretained AZToggleArrayView *_tv;
//	__unsafe_unretained AZSourceList *_sourceList;
}
@end

@implementation AZSourceListViewController
//@synthesize tv = _tv, sourceList= _sourceList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self makeBadges];
    }
    
    return self;
}




- (NSArray*)questionsForToggleView:(AZToggleArrayView *) view{
	return 	@[@"Sort Alphabetically?", @"Sort By Color?" , @"Sort like Dock", @"Sort by \"Category\"?", @"Show extra app info?" ];

}
- (void)toggleStateDidChangeTo:(BOOL)state InToggleViewArray:(AZToggleArrayView *) view WithName:(NSString *)name{

	NSLog(@"Toggle notifies delegtae:  %@, %@", name, (state ? @"YES"  :@"NO"));
//	NSArray *choices = @[@"Sort Alphabetically?", @"Sort By Color?" , @"Sort like Dock", @"Sort by \"Category\"?", @"Show extra app info?" ];
	_carrie.iconStyle = RAND_INT_VAL(1, 3);
	[_carrie.carousel reloadData];
}


#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(AZSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	SourceListItem *i = item;

	NSLog(@"Object:%@", i.objectRep);// [item propertiesPlease]);
									 //Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {


		return [[item children] count];
	}
}

	//- (BOOL)sourceList:(AZSourceList*)aSourceList isItemExpandable:(id)item {
	//


- (id)sourceList:(AZSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
		//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return sourceListItems[index];
	}
	else {
		return [item children][index];
	}
}


- (id)sourceList:(AZSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];

		//	return [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
		//		return ( [object.uniqueID isEqualTo:[item identifier]] ? YES : NO);
		//	}];


}


- (void)sourceList:(AZSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{

	[item setObjectValue:[[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
		return ([object.uniqueID isEqualToString:[item identifier]] ? YES : NO);
	}]];

	[item setTitle:[[item object]valueForKey:@"name"]];
}



- (BOOL)sourceList:(AZSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(AZSourceList*)aSourceList itemHasBadge:(id)item
{
	if ([[item valueForKey:@"objectRep"] isKindOfClass:[AZFile class]])
		return YES;
	else return NO;   // [item hasBadge];
}

- (NSColor*)sourceList:(AZSourceList*)aSourceList badgeBackgroundColorForItem:(id)item {

	AZFile *first = [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
		return ( [object.uniqueID isEqualTo:[item identifier]] ? YES : NO);
	}];
	return first.color;

}


- (NSInteger)sourceList:(AZSourceList*)aSourceList badgeValueForItem:(id)item
{
	AZFile *first  = aSourceList.objectRep;
	return first.spotNew;
		//	AZFile *first = [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
		//		return ( [object.uniqueID isEqualTo:[item identifier]] ? YES : NO);
		//	}];

		//	return first.spotNew;
		//	return [item badgeValue];
}


- (BOOL)sourceList:(AZSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}


- (NSImage*)sourceList:(AZSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(AZSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}

#pragma mark -
#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(AZSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"apps"])
		return YES;

	return NO;
}


- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [_sourceList selectedRowIndexes];

	if([selectedIndexes count]==1)
	{
		NSString *identifier = [[_sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		AZFile *first = [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
			return ( [object.uniqueID isEqualTo:identifier] ? YES : NO);
		}];
		CGPoint now = [[AZDockQuery instance]locationNowForAppWithPath:first.path];
		self.point1x = $(@"%f",now.x);// setStringValue:$(@"%f",now.x)];
		self.point1y = $(@"%f",now.y); //setStringValue:$(@"%f",now.y)];
		self.point2x = $(@"%f",first.dockPointNew.x);//setStringValue:$(@"%f",first.dockPointNew.x)];
		self.point2y = $(@"%f",first.dockPointNew.y);

	}
	if([selectedIndexes count]==2)
	{
		NSString *identifier = [[_sourceList itemAtRow:[selectedIndexes lastIndex]] identifier];
		AZFile *first = [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
			return ( [object.uniqueID isEqualTo:identifier] ? YES : NO);
		}];
		self.point2x = $(@"%f",first.dockPoint.x);
		self.point2y = $(@"%f",first.dockPoint.y);
	}

		//Set the label text to represent the new selection
		//	if([selectedIndexes count]>1)
		//		[selectedItemLabel setStringValue:@"(multiple)"];
		//
		//	else if([selectedIndexes count]==1) {
		//		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		//
		//		[selectedItemLabel setStringValue:identifier];
		//	}
		//	else {
		//		[selectedItemLabel setStringValue:@"(none)"];
		//	}
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [notification userInfo][@"rows"];

	NSLog(@"Delete key pressed on rows %@", rows);

		//Do something here
}



-(void) makeBadges {
	[AZStopwatch start:@"makingbadges"];
		//	[NSThread performBlockInBackground:^{

	SourceListItem *appsListItem = [SourceListItem itemWithTitle:@"APPS" identifier:@"apps"];
		//		[appsListItem setBadgeValue:[[AtoZ dock]count]];
	[appsListItem setIcon:[NSImage imageNamed:NSImageNameAddTemplate]];
	[appsListItem setChildren:[[AtoZ sharedInstance].dockSorted arrayUsingBlock:^id(AZFile* obj) {
		SourceListItem *app = [SourceListItem itemWithTitle:obj.name identifier:obj.uniqueID icon:obj.image];
			//			AZFile* sorted =[[AtoZ dockSorted] filterOne:^BOOL(AZFile* sortObj) {
			//				return ([sortObj.uniqueID isEqualToString:obj.uniqueID] ? YES : NO);
			//			}];
		NSLog(@"%@, spot: %ld, match ", obj.name, obj.spot);//, oc.name, sorted.spotNew);
															//			app.badgeValue = sorted.spotNew;


		app.color = obj.color;
		app.objectRep = obj;
		[app setChildren:[[[obj propertiesPlease] allKeys] arrayUsingBlock:^id(NSString* key) {
			if ( [key isEqualToAnyOf:@[@"name",@"image", @"color", @"colors"]]) return  nil;
			else return [SourceListItem itemWithTitle:$(@"%@: %@",key,[obj valueForKey:key]) identifier:nil];
		}]];
			//
		return app;
	}]];
		//		[[NSThread mainThread] performBlock:^{
	sourceListItems = @[appsListItem];
	[AZStopwatch stop:@"makingbadges"];
	[_sourceList reloadData];
}



@end
