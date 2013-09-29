//
//  DSSyntaxCollection.h
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 01/10/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSyntaxDefinition.h"

@interface DSSyntaxCollection : NSObject

@property (nonatomic, retain) NSArray *availableSyntaxNames;

- (DSSyntaxDefinition*)syntaxForName:(NSString*)name;

//- (NSString*)syntaxForExtension:(NSString*)rb;

@end
