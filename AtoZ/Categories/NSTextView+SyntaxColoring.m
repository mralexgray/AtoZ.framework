
#import "AtoZ.h"
#import "NSTextView+SyntaxColoring.h"

#define isAZaz_(c) ( (c >= 'A' && c <= 'z') || c == '_' )

//char ** nsarraytochar ( NSA* array ){
//   int i, count = array.count;
//   char **cargs = (char**) malloc(sizeof(char*) * (count + 1));
//   for(i = 0; i < count; i++) {        //cargs is a pointer to 4 pointers to char
//      NSString *s      = array[i];     //get a NSString
//      const char *cstr = s.UTF8String; //get cstring
//      int          len = strlen(cstr); //get its length
//      char  *cstr_copy = (char*) malloc(sizeof(char) * (len + 1));//allocate memory, + 1 for ending '\0'
//      strcpy(cstr_copy, cstr);         //make a copy
//      cargs[i] = cstr_copy;            //put the point in cargs
//  }
//  cargs[i] = NULL;
//  return cargs;
//}

@implementation NSTextView (SyntaxColoring)

//char **stringArrayFromNSArray(NSArray *a) { if (!a.count) return NULL;
//
//	NSUI count = [a count], maxLength = [a[0] length]; // because a is supposed to be sorted by length, order desc
//
//	__block char **sa = malloc(count*maxLength*sizeof(unichar));
//
//  [a eachWithIndex:^(id obj, NSI idx) { sa[idx] = (char*)[obj UTF8String]; }]; return sa;
//}

char **stringArrayFromNSArray(NSArray *a) {
	NSUInteger count = [a count];
	NSUInteger maxLength = [[a objectAtIndex:0] length]; // because a is supposed to be sorted by length, order desc

	
	char **sa = malloc(count*maxLength*sizeof(unichar));
	for(NSUI i = 0; i < count; i++) sa[i] = (char *)[[a objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
	return sa;
}

- (void)tryToColorizeWithTokens:(char**)tokens    nbTokens:(NSUInteger)nbTokens
                            ptr:(char *)ptr           text:(const char*)txt
                   firstCharSet:(NSCSET*)cs1 secondCharSet:(NSCSET*)cs2
								                                     color:(NSC*)color {

  if( ![cs1 characterIsMember:*ptr] || ![cs2 characterIsMember:*(ptr+1)]) return;
  for(NSUI i = 0; i < nbTokens; i++) {
    NSUI tokenLength = strlen(tokens[i]); // TODO: optimize here: strlen is called 378185 times for NSObject...
    if(!isAZaz_(*(ptr+tokenLength)) && !strncmp(tokens[i], ptr, tokenLength)) {
      [self setTextColor:color range:NSMakeRange(ptr-txt, tokenLength)];
      ptr += tokenLength;
      break;
    }
  }
}

- (void) colorizeWithKeywords:(NSA*)keywords classes:(NSA*)classes {

#ifdef DEBUG
  AZSTOPWATCH(
//	double start = [NSDate.date timeIntervalSince1970];
#endif
	const char* text = self.string.UTF8String;
	char *tmp = (char *)text;

  self.backgroundColor = GRAY1;
	NSC *commentsColor = GRAY8, *keywordsColor = RANDOMCOLOR, *classesColor = RANDOMCOLOR;

  AZNewVal(kwCS1,NSMutableCharacterSet.new); AZNewVal(kwCS2,NSMutableCharacterSet.new);
  AZNewVal(clCS1,NSMutableCharacterSet.new); AZNewVal(clCS2,NSMutableCharacterSet.new);

	for(NSS *k in keywords) {
		[kwCS1 addCharactersInString:[k substringWithRange:NSMakeRange(0, 1)]];
		[kwCS2 addCharactersInString:[k substringWithRange:NSMakeRange(1, 1)]];
	}

	for(NSS *c in classes) {
		[clCS1 addCharactersInString:[c substringWithRange:NSMakeRange(0, 1)]];
		[clCS2 addCharactersInString:[c substringWithRange:NSMakeRange(1, 1)]];
	}
	// we use char** to avoid numerous -cString calls on the same NSStrings	

	NSUI kwCount = keywords.count, clCount = classes.count, colorStart, colorStop;

	char **kw = stringArrayFromNSArray(keywords);
	char **cl = stringArrayFromNSArray(classes);
	
	while(*tmp != '\0') {	// color comments
		if(*tmp == '/' && *(tmp+1) == '*') {	colorStart = tmp-text;	do {	tmp++; } while(*tmp != '\0' && *(tmp+1) != '\0' && !(*tmp == '*' && *(tmp+1) == '/'));
			colorStop = tmp-text+2;
			[self setTextColor:commentsColor range:(NSRNG){colorStart, colorStop-colorStart}];
		}
		// color directives
		if(*tmp == '@') {

      colorStart = tmp-text;
      do tmp++;
      while(*tmp != '\0' && *tmp != ' ' && *tmp != '(' && *tmp != '\n');
      colorStop = tmp-text;
			[self setTextColor:keywordsColor range:(NSRNG){colorStart, colorStop-colorStart}]; // we use kwColor also for directives
		}
		// color keywords
		if( !isAZaz_(*tmp) ) {	tmp++;	if(*tmp == '\0') {	free(kw); free(cl);	
#ifdef DEBUGZ
				NSLog(@"-- colored in %f seconds", [NSDate.date timeIntervalSince1970] - start);
#endif
				return;
			}
			[self tryToColorizeWithTokens:kw         nbTokens:kwCount ptr:tmp text:text
                       firstCharSet:kwCS1 secondCharSet:kwCS2 color:keywordsColor];
			[self tryToColorizeWithTokens:cl         nbTokens:clCount ptr:tmp text:text
                       firstCharSet:clCS1 secondCharSet:clCS2 color:classesColor];
		} else tmp++;
	}
	free(kw); free(cl);
#ifdef DEBUG
  );
//	NSLog(@"-- colored in %f seconds", [NSDate.date timeIntervalSince1970] - start);
#endif
}

@end

@implementation NSMutableAttributedString (RTB)

- (void)setTextColor:(NSColor*)color font:(NSFont*)font range:(NSRNG)range {
    NSDictionary *d = @{ NSForegroundColorAttributeName : color, NSFontAttributeName : font };
    [self setAttributes:d range:range];
}

@end

@implementation NSString (SyntaxColoring)

- (void)tryToColorizeWithTokens:(char**)tokens nbTokens:(NSUI)nbTokens
                            ptr:(char*)ptr			   text:(const char*)text
                   firstCharSet:(NSCSET*)c1 secondCharSet:(NSCSET*)cs2
//#if TARGET_OS_IPHONE
//						  color:(UIColor *)color  font:(UIFont *)font
//#else
						  color:(NSColor *)color font:(NSFont *)font
//#endif
               attributedString:(NSMAS*)mas {

	NSUI tokenLength;
	NSUI i;
	if([c1 characterIsMember:*ptr] && [cs2 characterIsMember:*(ptr+1)]) {
		for(i = 0; i < nbTokens; i++) {
			tokenLength = strlen(tokens[i]); // TODO: optimize here: strlen is called 378185 times for NSObject...
			if(!isAZaz_(*(ptr+tokenLength)) && !strncmp(tokens[i], ptr, tokenLength)) {
				[mas setTextColor:color font:font range:NSMakeRange(ptr-text, tokenLength)];
				ptr += tokenLength;
				break;
			}
		}
	}
}

- (NSAttributedString *)colorizeWithKeywords:(NSA*)keywords classes:(NSA*)classes {

//#if TARGET_OS_IPHONE
//    NSFont *font = [UIFont fontWithName:@"Courier" size:12.0];
//#else
    NSFont *font = [NSFont fontWithName:@"Courier" size:12.0];
//#endif    
    NSMAS *attributedString = [self attributedWith:@{NSFontAttributeName:font}].mC;

#ifdef DEBUG
	double start = [[NSDate date] timeIntervalSince1970];
#endif
	
	const char* text = [self UTF8String];// cStringUsingEncoding:NSUTF8StringEncoding];
	char *tmp = (char *)text;

//#if TARGET_OS_IPHONE
//	UIColor *commentsColor = [UIColor colorWithRed:0.0 green:119.0/255 blue:0.0 alpha:1.0];
//	UIColor *keywordsColor = [UIColor colorWithRed:193.0/255 green:0.0 blue:145./255 alpha:1.0];
//	UIColor *classesColor = [UIColor colorWithRed:103.0/255 green:31.0/255 blue:155./255 alpha:1.0];
//#else
    NSColor *commentsColor = [NSColor colorWithCalibratedRed:0.0 green:119.0/255 blue:0.0 alpha:1.0];
	NSColor *keywordsColor = [NSColor colorWithCalibratedRed:193.0/255 green:0.0 blue:145./255 alpha:1.0];
	NSColor *classesColor = [NSColor colorWithCalibratedRed:103.0/255 green:31.0/255 blue:155./255 alpha:1.0];
//#endif
    //NSColor *typesColor = [NSColor colorWithCalibratedRed:53.0/255 green:0.0/255 blue:111./255 alpha:1.0];
	
  AZNewVal(kwCS1,NSMutableCharacterSet.new);
  AZNewVal(kwCS2,NSMutableCharacterSet.new);
  AZNewVal(clCS1,NSMutableCharacterSet.new);
  AZNewVal(clCS2,NSMutableCharacterSet.new);

	if (keywords.count)
    for(NSString *k in keywords) {
      [kwCS1 addCharactersInString:[k substringWithRange:NSMakeRange(0, 1)]];
      [kwCS2 addCharactersInString:[k substringWithRange:NSMakeRange(1, 1)]];
    }

	for(NSString *c in classes) {
		[clCS1 addCharactersInString:[c substringWithRange:NSMakeRange(0, 1)]];
		[clCS2 addCharactersInString:[c substringWithRange:NSMakeRange(1, 1)]];
	}
	
	// we use char** to avoid numerous -cString calls on the same NSStrings	
	NSUInteger kwCount = [keywords count];
	NSUInteger clCount = [classes count];

	NSUInteger colorStart;
	NSUInteger colorStop;

	char **kw = stringArrayFromNSArray(keywords);
	char **cl = stringArrayFromNSArray(classes);
	
	while(*tmp != '\0') {
		
		// color comments
		if(*tmp == '/' && *(tmp+1) == '*') {
			colorStart = tmp-text;
			do {
				tmp++; 
			} while(*tmp != '\0' && *(tmp+1) != '\0' && !(*tmp == '*' && *(tmp+1) == '/'));
			colorStop = tmp-text+2;
			[attributedString setTextColor:commentsColor font:font range:NSMakeRange(colorStart, colorStop-colorStart)];
		}
		
		// color directives
		if(*tmp == '@') {
			colorStart = tmp-text;
			do {
				tmp++;
			} while(*tmp != '\0' && *tmp != ' ' && *tmp != '(' && *tmp != '\n');
			colorStop = tmp-text;
			[attributedString setTextColor:keywordsColor font:font range:NSMakeRange(colorStart, colorStop-colorStart)]; // we use kwColor also for directives
		}
		
		// color keywords
		if( !isAZaz_(*tmp) ) {
			tmp++;
			if(*tmp == '\0') {
				free(kw); free(cl);
#ifdef DEBUG
				NSLog(@"-- colored in %f seconds", [[NSDate date] timeIntervalSince1970] - start);
#endif
                
				return attributedString;
			}

			[self tryToColorizeWithTokens:kw nbTokens:kwCount ptr:tmp text:text firstCharSet:kwCS1 secondCharSet:kwCS2 color:keywordsColor font:font attributedString:attributedString];
			[self tryToColorizeWithTokens:cl nbTokens:clCount ptr:tmp text:text firstCharSet:clCS1 secondCharSet:clCS2 color:classesColor font:font attributedString:attributedString];
			
		} else {
			tmp++;
		}
		
	}

	free(kw); free(cl);

#ifdef DEBUG
	NSLog(@"-- colored in %f seconds", [[NSDate date] timeIntervalSince1970] - start);
#endif
    
    return attributedString;
}
@end

/*
char **stringArrayFromNSArray(NSArray *a) {
	NSUInteger count = [a count];
	NSUInteger maxLength = [[a objectAtIndex:0] length]; // because a is supposed to be sorted by length, order desc
	NSUInteger i;
	
	char **sa = malloc(count*maxLength*sizeof(unichar));
	for(i = 0; i < count; i++) {
		sa[i] = (char *)[[a objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
	}
	return sa;
}

  NSTextView+SyntaxColoring.m
  RuntimeBrowser
  Created by Nicolas Seriot on 04.08.08.
  Copyright 2008 seriot.ch. All rights reserved.
 written and optimized for runtime browser
	
	NSUI count 		= a.count;
	NSUI maxLength = [a[0] length]; // because a is supposed to be sorted by length, order desc
	NSUI i;
	char **sa = malloc(count*maxLength*sizeof(char**));			//unichar));
	for(i = 0; i < count; i++) {
		sa[i] = (char*)[a[i]UTF8String];														// (char*)[(NSString*)a[i] UTF8String ]; //
		
	}
	return sa;


RANDOMGRAY;//RED;// [NSColor colorWithCalibratedRed:0.0 green:119.0/255 blue:0.0 alpha:1.0];
GREEN;
ORANGE;//[NSColor colorWithCalibratedRed:193.0/255 green:0.0 blue:145./255 alpha:1.0];//[NSColor colorWithCalibratedRed:103.0/255 green:31.0/255 blue:155./255 alpha:1.0];
	NSColor *typesColor = BLUE;//[NSColor colorWithCalibratedRed:53.0/255 green:0.0/255 blue:111./255 alpha:1.0];
	[@[kwCS1, kwCS2, clCS1, clCS2] makeObjectsPerformSelector:@selector(new)];
	kwCS1 = NSMutableCharacterSet.new;//.autorelease;//[[NSMutableCharacterSet.alloc init] autorelease];
	kwCS2 = NSMutableCharacterSet.new;//NSMutableCharacterSet.new.autorelease; //alloc] init] autorelease];
	clCS1 = NSMutableCharacterSet.new;//NSMutableCharacterSet.new.autorelease;
	clCS2 = NSMutableCharacterSet.new;//NSMutableCharacterSet.new.autorelease;
*/
