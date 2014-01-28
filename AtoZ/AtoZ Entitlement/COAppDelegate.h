//
//  COAppDelegate.h
//  CoreTable
//
//  Created by StuFF mc on 5/29/12.
//  Copyright (c) 2012 StuFF mc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface COAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
