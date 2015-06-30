//
//  THWebNamedColors.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 28.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//


@interface  NSColorList (Dictionary) _RO NSD *dictionary;  @end

@interface AZNamedColors : NSColorList

+ (AZNamedColors *)namedColors;

+ (NSS*) nameOfColor:(NSC*)color;
+ (NSS*) nameOfColor:(NSC*)color savingDistance:(NSC**)distance;
+ (NSC*) normal:(NSUI)idx;

_RO NSA* colors;

@end

