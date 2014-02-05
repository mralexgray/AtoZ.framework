//
//  DSSyntaxCollection.m
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 01/10/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//
#import "AtoZ.h"
#import "DSSyntaxCollection.h"
#import "DSRubySyntaxDefinition.h"
#import "DSObjectiveCSyntaxDefinition.h"
#import "DSPodfileSyntaxDefinition.h"
#import "DSPodspecSyntaxDefinition.h"

@implementation DSSyntaxCollection {
  NSArray *_availableSyntaxes;
  NSDictionary *_namesMappings;
}

- (id)init {
  self = [super init];
  if (self) {
    _availableSyntaxes = @[
    [DSRubySyntaxDefinition class],
    [DSObjectiveCSyntaxDefinition class],
    [DSPodfileSyntaxDefinition class],
    [DSPodspecSyntaxDefinition class],
    ];

    NSMutableDictionary *namesMappings = [NSMutableDictionary new];
    [_availableSyntaxes each:^(Class class) {
      namesMappings[[class name]] = class;
    }];
    _availableSyntaxNames = [namesMappings allKeys];
    _namesMappings = namesMappings;
  }
  return self;
}

- (DSSyntaxDefinition*)syntaxForName:(NSString*)name {
  Class class = _namesMappings[name];
  return class.new;
}

@end
