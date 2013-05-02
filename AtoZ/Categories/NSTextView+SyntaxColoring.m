//
//  NSTextView+SyntaxColoring.m
//  RuntimeBrowser
//  Created by Nicolas Seriot on 04.08.08.
//  Copyright 2008 seriot.ch. All rights reserved.
// written and optimized for runtime browser

#import "NSTextView+SyntaxColoring.h"
#import <AtoZ/AtoZ.h>
#define isAZaz_(c) ( (c >= 'A' && c <= 'z') || c == '_' )

char ** nsarraytochar ( NSArray* array ){
   int i, count = array.count;
   char **cargs = (char**) malloc(sizeof(char*) * (count + 1));
   for(i = 0; i < count; i++) {        //cargs is a pointer to 4 pointers to char
      NSString *s      = array[i];     //get a NSString
      const char *cstr = s.UTF8String; //get cstring
      int          len = strlen(cstr); //get its length
      char  *cstr_copy = (char*) malloc(sizeof(char) * (len + 1));//allocate memory, + 1 for ending '\0'
      strcpy(cstr_copy, cstr);         //make a copy
      cargs[i] = cstr_copy;            //put the point in cargs
  }
  cargs[i] = NULL;
  return cargs;
}

@implementation NSTextView (SyntaxColoring)

char ** stringArrayFromNSArray( NSArray *a ) {
	return  nsarraytochar(a);
//	
//	NSUI count 		= a.count;
//	NSUI maxLength = [a[0] length]; // because a is supposed to be sorted by length, order desc
//	NSUI i;
//	char **sa = malloc(count*maxLength*sizeof(char**));			//unichar));
//	for(i = 0; i < count; i++) {
//		sa[i] = (char*)[a[i]UTF8String];														// (char*)[(NSString*)a[i] UTF8String ]; //
//		
//	}
//	return sa;
}

- (void)tryToColorizeWithTokens:(char **)tokens  				nbTokens:(NSUInteger)nbTokens
									 ptr:(char *)ptr         				 text:(const char*)text
				   	 firstCharSet:(NSCharacterSet *)cs1  secondCharSet:(NSCharacterSet *)cs2 
								  color:(NSColor *)color 																	{
								  
	NSUInteger tokenLength;
	NSUInteger i;
	if( [cs1 characterIsMember:*ptr] && [cs2 characterIsMember:*(ptr+1)] ) {
		for(i = 0; i < nbTokens; i++) {
			tokenLength = strlen(tokens[i]); // TODO: optimize here: strlen is called 378185 times for NSObject...
			if(!isAZaz_(*(ptr+tokenLength)) && !strncmp(tokens[i], ptr, tokenLength)) {
				[self setTextColor:color range:NSMakeRange(ptr-text, tokenLength)];
				ptr += tokenLength;
				break;
			}
		}
	}
}

- (void)colorizeWithKeywords:(NSArray *)keywords classes:(NSArray *)classes {
#ifdef DEBUG
	double start = [NSDate.date timeIntervalSince1970];
#endif
	const char* text = self.string.UTF8String;
	char *tmp = (char *)text;

	NSColor *commentsColor = RANDOMGRAY;//RED;// [NSColor colorWithCalibratedRed:0.0 green:119.0/255 blue:0.0 alpha:1.0];
	NSColor *keywordsColor = RANDOMCOLOR;//ORANGE;//[NSColor colorWithCalibratedRed:193.0/255 green:0.0 blue:145./255 alpha:1.0];
	NSColor *classesColor = RANDOMCOLOR;//GREEN;
	//[NSColor colorWithCalibratedRed:103.0/255 green:31.0/255 blue:155./255 alpha:1.0];
//	NSColor *typesColor = BLUE;//[NSColor colorWithCalibratedRed:53.0/255 green:0.0/255 blue:111./255 alpha:1.0];

	NSMutableCharacterSet *kwCS1, *kwCS2, *clCS1, *clCS2;
//	[@[kwCS1, kwCS2, clCS1, clCS2] makeObjectsPerformSelector:@selector(new)];
	kwCS1 = NSMutableCharacterSet.new;//.autorelease;//[[[NSMutableCharacterSet alloc] init] autorelease];
	kwCS2 = NSMutableCharacterSet.new;//NSMutableCharacterSet.new.autorelease; //alloc] init] autorelease];
	clCS1 = NSMutableCharacterSet.new;//NSMutableCharacterSet.new.autorelease;
	clCS2 = NSMutableCharacterSet.new;//NSMutableCharacterSet.new.autorelease;

	for(NSS *k in keywords) {
		[kwCS1 addCharactersInString:[k substringWithRange:NSMakeRange(0, 1)]];
		[kwCS2 addCharactersInString:[k substringWithRange:NSMakeRange(1, 1)]];
	}

	for(NSS *c in classes) {
		[clCS1 addCharactersInString:[c substringWithRange:NSMakeRange(0, 1)]];
		[clCS2 addCharactersInString:[c substringWithRange:NSMakeRange(1, 1)]];
	}
	// we use char** to avoid numerous -cString calls on the same NSStrings	
	NSUInteger kwCount = [keywords   count];
	NSUInteger clCount = [classes 	count];
	NSUInteger colorStart;
	NSUInteger colorStop;

	char **kw = stringArrayFromNSArray(keywords);
	char **cl = stringArrayFromNSArray(classes);
	
	while(*tmp != '\0') {	// color comments
		if(*tmp == '/' && *(tmp+1) == '*') {	colorStart = tmp-text;	do {	tmp++; } while(*tmp != '\0' && *(tmp+1) != '\0' && !(*tmp == '*' && *(tmp+1) == '/'));
			colorStop = tmp-text+2;
			[self setTextColor:commentsColor range:NSMakeRange(colorStart, colorStop-colorStart)];
		}
		// color directives
		if(*tmp == '@') {
			colorStart = tmp-text; do tmp++; while(*tmp != '\0' && *tmp != ' ' && *tmp != '(' && *tmp != '\n'); colorStop = tmp-text;
			[self setTextColor:keywordsColor range:NSMakeRange(colorStart, colorStop-colorStart)]; // we use kwColor also for directives
			
		}
		// color keywords
		if( !isAZaz_(*tmp) ) {	tmp++;	if(*tmp == '\0') {	free(kw); free(cl);	
#ifdef DEBUG
				NSLog(@"-- colored in %f seconds", [NSDate.date timeIntervalSince1970] - start);
#endif
				return;
			}
			[self tryToColorizeWithTokens:kw nbTokens:kwCount ptr:tmp text:text firstCharSet:kwCS1 secondCharSet:kwCS2 color:keywordsColor];
			[self tryToColorizeWithTokens:cl nbTokens:clCount ptr:tmp text:text firstCharSet:clCS1 secondCharSet:clCS2 color:classesColor];
		} else tmp++;
	}
	free(kw); free(cl);
#ifdef DEBUG
	NSLog(@"-- colored in %f seconds", [NSDate.date timeIntervalSince1970] - start);
#endif
}

@end
