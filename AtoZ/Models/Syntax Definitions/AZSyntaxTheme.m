//
//  DSSyntaxTheme.m
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 26/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//
#import <AtoZ/AtoZ.h>
#import "AZSyntaxTheme.h"

//#if TARGET_OS_IPHONE
//#define RGB(r, g, b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
//#else
//	#ifndef RGB(r, g, b)
//  		#define RGB(r, g, b) [NSColor colorWithCalibratedRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
//	#endif
//#endif

@interface NSString (DSSyntaxTheme)
- (UINSColor*)xcodeColor;
@end

@implementation AZSyntaxThemes

-(void) awakeFromNib {

	[self setContent:NSMA.new];
	NSA*themes = [AZFILEMANAGER contentsOfDirectoryAtPath:[@"~/Library/Developer/Xcode/UserData/FontAndColorThemes/" stringByExpandingTildeInPath] error:nil];
	for (NSString*name in [themes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.dvtcolortheme'"]])
		[self addObject:[AZSyntaxTheme themeWithXcodeTheme:name]];
	XX(self.arrangedObjects);
}

@end

//PROXY_DEFINE_BLOCK(AZSyntaxThemes,NSMA,^(NSMA*setBacking){ 
//	
//	NSA*themes = [AZFILEMANAGER contentsOfDirectoryAtPath:[@"~/Library/Developer/Xcode/UserData/FontAndColorThemes/" stringByExpandingTildeInPath] error:nil];
//	setBacking = [[themes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.dvtcolortheme'"]] map:^id(NSString*name){
//		return [AZSyntaxTheme themeWithXcodeTheme:name];
//  	}].mutableCopy;
//	return setBacking;
//})


//SYNTHESIZE_SINGLETON_FOR_CLASS(AZSyntaxThemes, 


/** Populates the themes using those available to Xcode. */
//- (void) opulateThemes {
//  NSFileManager *fm = [NSFileManager defaultManager];
//  NSString *themesPath = [kXcodeThemesFolder stringByExpandingTildeInPath];
//  NSArray *dirContents = [fm contentsOfDirectoryAtPath:themesPath error:nil];
//  NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.dvtcolortheme'"];
//  NSArray *themes = [dirContents filteredArrayUsingPredicate:fltr];
//  NSMutableArray *themeNames = [NSMutableArray array];
//  [themes enumerateObjectsUsingBlock:^(NSString* name, NSUInteger idx, BOOL *stop) {
//    [themeNames addObject:[name stringByDeletingPathExtension]];
//  }];
//  self.themeNames = themeNames;
//}
//
//- (NSString*)pathForThemeNamed:(NSString*)name {
//  NSString *path = [kXcodeThemesFolder stringByExpandingTildeInPath];
//  path = [path stringByAppendingPathComponent:name];
//  path = [path stringByAppendingPathExtension:@"dvtcolortheme"];
//  return path;
//}
//
//- (NSString*)sampleForSyntaxNamed:(NSString*)name {
//  NSString *path = [[NSBundle mainBundle] pathForResource:[self syntaxes][name]
//                                                   ofType:nil];
//  NSString *sample = [NSString stringWithContentsOfFile:path
//                                               encoding:NSUTF8StringEncoding
//                                                  error:nil];
//  return sample;
//}

@implementation AZSyntaxTheme 


- (UINSColor*)colorForType:(NSString*)type { UINSColor* c = !type ? _plainTextColor : [self vFK:[type withString:@"Color"]];
	
	if (c) return c;
	NSLog(@"NOVALFOR:%@", [type withString:@"Color"]);
	return RANDOMCOLOR;
}

- (id)init {
	if (!(self = super.init)) return nil;
	_name = @"Default";
	_plainTextColor  = RGB(255.f, 255.f, 255.f);
	_backgroundColor = RGB(0.f, 0.f, 0.f);
	_selectionColor  = RGB(166.f, 201.f, 255.f);
	return self;
}

+ defaultTheme {
	AZSyntaxTheme *result = self.new;
	
	result.plainTextColor  = [UINSColor blackColor];
	result.backgroundColor = [UINSColor whiteColor];
	result.cursorColor     = [UINSColor blackColor];
	result.commentColor    = RGB(128.f, 128.f, 128.f);
	result.stringColor     = RGB(211.f, 045.f, 038.f);
	result.keywordColor    = RGB(188.f, 049.f, 156.f);
	result.variableColor   = RGB(63, 110, 116);
	result.constantColor   = result.variableColor;
	
//	result.documentationCommentColor   =  RGB(000.f, 131.f, 039.f);
  result.characterColor              =  RGB(040.f, 052.f, 206.f);
  result.numberColor                 =  RGB(040.f, 052.f, 206.f);
//  result.preprocessorColor           =  RGB(120.f, 072.f, 048.f);
  result.attributeColor              =  RGB(150.f, 125.f, 065.f);
//  result.projectColor                =  RGB(077.f, 129.f, 134.f);
	
	return result;
}
//- (id) valueForKey:(NSString *)key { return [self vFK:key] ?: [self respondsToSelector:NSSelectorFromString(key)] ? RANDOMCOLOR : [super vFK:key]; }

+ themeWithXcodeTheme:(NSString*)path {
	AZSyntaxTheme *result = self.class.new;
	
	NSDictionary* root     = [NSDictionary dictionaryWithContentsOfFile:path];
	result.backgroundColor = [root[@"DVTSourceTextBackground"] xcodeColor];
	result.cursorColor     = [root[@"DVTSourceTextInsertionPointColor"] xcodeColor];
	result.selectionColor  = [root[@"DVTSourceTextSelectionColor"] xcodeColor];
	
	NSDictionary* syntax   = root[@"DVTSourceTextSyntaxColors"];
	result.plainTextColor  = [syntax[@"xcode.syntax.plain"] xcodeColor];
	result.commentColor    = [syntax[@"xcode.syntax.comment"] xcodeColor];
	result.stringColor     = [syntax[@"xcode.syntax.string"] xcodeColor];
	result.keywordColor    = [syntax[@"xcode.syntax.keyword"] xcodeColor];
	result.attributeColor  = [syntax[@"xcode.syntax.attribute"] xcodeColor];
	result.characterColor  = [syntax[@"xcode.syntax.character"] xcodeColor];
	result.numberColor     = [syntax[@"xcode.syntax.number"] xcodeColor];
	
	result.constantColor   = [syntax[@"xcode.syntax.identifier.constant"] xcodeColor];
	result.variableColor   = [syntax[@"xcode.syntax.identifier.variable"] xcodeColor];
	result.functionColor   = [syntax[@"xcode.syntax.identifier.function"] xcodeColor];
	result.macroColor      = [syntax[@"xcode.syntax.identifier.macro"] xcodeColor];
	result.typeColor       = [syntax[@"xcode.syntax.identifier.type"] xcodeColor];
	result.classColor      = [syntax[@"xcode.syntax.identifier.class"] xcodeColor];
	
	result.DSLKeywordColor = result.keywordColor;
	
	result.name = [path.lastPathComponent stringByDeletingPathExtension];
	
	// Automatically adjust the color of the cursor to the background
	// TODO: move to TextView?
#if !TARGET_OS_IPHONE
	if (!result.cursorColor || [result.cursorColor isEqualTo:RGB(0.f, 0.f, 0.f)]) {
		CGFloat r, b, g;
		[result.backgroundColor getRed:&r green:&g blue:&b alpha:NULL];
		CGFloat average = (r + b + g) /3.f;
		if (average > 0.5) {
			result.cursorColor = [NSColor blackColor];
		} else {
			result.cursorColor = [NSColor whiteColor];
		}
	}
#endif
	[root writeToFile:@"/Users/localadmin/Desktop/themdump.plist" atomically:YES];
	return result;
}

@end

@implementation NSString (DSSyntaxTheme)
- (UINSColor*)xcodeColor {
	
	NSScanner *scanner = [NSScanner scannerWithString:self];
	float r, b, g, a;
	[scanner scanFloat:&r];
	[scanner scanFloat:&g];
	[scanner scanFloat:&b];
	[scanner scanFloat:&a];
	
#if TARGET_OS_IPHONE
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
#else
	return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a] ?: RANDOMCOLOR;
#endif
}

@end

