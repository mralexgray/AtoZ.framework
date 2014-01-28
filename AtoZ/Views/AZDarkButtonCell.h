
//  AZDarkButtonCell.h
//  AtoZ

//  Created by Alex Gray on 8/17/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#define AZRANGEMAX(r) (r.location + r.length)

@interface AZDarkButtonCell : NSButtonCell <NSCopying>

@end

// in awake from nib...

// ((NSTableColumn*)_table.tableColumns[[_table columnWithIdentifier:   @"Status"]]).dataCell = TodoColorCell.new;
// ((NSTableColumn*)_table.tableColumns[[_table columnWithIdentifier: @"Priority"]]).dataCell = TodoPriorityClickCell.new;

@interface AZColorCell : NSActionCell <NSCopying, NSCoding>
@property (CP) NSC*(^colorForObjectValue)(id);
@end


@interface AZPriorityClickCell : NSActionCell <NSCopying, NSCoding>
@property NSRange range;
@property (CP) NSControlActionBlock block;
@end


