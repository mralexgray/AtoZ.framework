//
//  NSString+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSString+AtoZ.h"
#import "NSColor+AtoZ.h"
#import "NSArray+AtoZ.h"
#import "AtoZ.h"

@implementation NSString (AtoZ)



+ (NSString *)newUniqueIdentifier
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return AZ_RETAIN(CFBridgingRelease(identifier));
}


/**
 Returns the support folder for the application, used to store the Core Data
 store file.  This code uses a folder named "ArtGallery" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */

+ (NSString*) applicationSupportFolder {

	NSString *app = [[NSBundle mainBundle]bundleIdentifier];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0 ? [paths objectAtIndex:0] : NSTemporaryDirectory() );
    return [basePath stringByAppendingPathComponent:app];
}


+ (NSString *)randomAppPath {

	return [[[[NSWorkspace sharedWorkspace] launchedApplications] valueForKeyPath:@"NSApplicationPath"]randomElement];
}
//- (NSColor *)colorValue {
//	return [NSColor colorFromString:self];
//}

-(NSData *) colorData {
	NSData *theData=[NSArchiver archivedDataWithRootObject:self];
	return theData;
}

+ (NSColor * )colorFromData:(NSData*)theData {
	NSColor * color =  [NSUnarchiver unarchiveObjectWithData:theData];
	return  color;
}



- (void)drawCenteredInRect:(CGRect)rect withFont:(NSFont *)font {
    CGSize size = CGSizeMake(20.0f, 400.0f); // [self sizeWithAttributes: //sizeWithFont:font];
    CGRect textBounds = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
                                   rect.origin.y + (rect.size.height - size.height) / 2,
                                   size.width, size.height);
    [self drawCenteredInRect:textBounds withFont:font];    
}

//- (void)drawCenteredInFrame:(id)frame withFont:(NSFont *)font {
//	NSView *view = frame;
//    NSSize size = view.frame.size;// WithFont:font;
//    NSAttributedString *string = [NSAttributedString alloc] initWithString:self attributes:<#(NSDictionary *)#>
//    CGRect textBounds = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
//                                   rect.origin.y + (rect.size.height - size.height) / 2,
//                                   size.width, size.height);
//    [self drawInRect:textBounds withFont:font];    
//}

- (NSString *)trim {
NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
return [self stringByTrimmingCharactersInSet:cs];
}

- (NSString *)shifted {
	return [self substringFromIndex:1];
}

- (NSString *)popped {
	return [self substringWithRange:NSMakeRange(0, self.length - 1)];
}

- (NSString *)chopped {
	return [self substringWithRange:NSMakeRange(1, self.length - 2)];
}

- (NSString *)camelized {
	return [[self mutableCopy] camelize];
}

- (NSString *)hyphonized {
	return [[self mutableCopy] hyphonize];
}

- (NSString *)underscored {
	return [[self mutableCopy] underscorize];
}

- (BOOL)isEmpty {
	return (self == nil) || [self.trim isEqualToString:@""];
}

/**
 * Actually this should be called stringByReversingThisString,
 * but that appeared to be too much sugar-free
 *
 * reverse ist non-destructive
 */
- (NSString *)reversed
{
	NSMutableString *re = NSMutableString.string;
	
	for (int i = self.length - 1; i >= 0; i--) {
		[re appendString:[self substringWithRange:NSMakeRange(i, 1)]];
	}
	
	return re;
}

- (NSUInteger)count:(NSString *)s options:(NSStringCompareOptions)mask {
	NSUInteger re = 0;
	NSRange r = NSMakeRange(0, self.length);
	
	NSRange rr;
	
	while ((rr = [self rangeOfString:s options:mask range:r]).location != NSNotFound) {
		re++;
		r.location = rr.location + 1;
		r.length = self.length - r.location;
	}
	
	return re;
}

- (NSUInteger)count:(NSString *)aString {
	return [self count:aString options:0];
}

- (NSUInteger)indentationLevel {
	NSUInteger re = 0;
	
	while (re < self.length 
		   && [[self substringWithRange:NSMakeRange(re, 1)] isEqualToString:@" "]) 
	{
		re++;
	}
	
	return re;
}

- (BOOL)contains:(NSString *)aString {
	return [self rangeOfString:aString].location != NSNotFound;
}

- (BOOL)containsAnyOf:(NSArray *)array {
	for (id v in array) {
		NSString *s = [v description];
		
		if ([v isKindOfClass:[NSString class]]) {
			s = (NSString *)v;
		}
		
		if ([self contains:s]) {
			return YES;
		}
	}
	
	return NO;         
}

- (BOOL)containsAllOf:(NSArray *)array {
	for (id v in array) {
		NSString *s = [v description];
		
		if ([v isKindOfClass:[NSString class]]) {
			s = (NSString *)v;
		}
		
		if (![self contains:s]) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)startsWith:(NSString *)aString {
	return [self hasPrefix:aString];
}

- (BOOL)endsWith:(NSString *)aString {
	return [self hasSuffix:aString];
}

- (BOOL)hasPrefix:(NSString *)prefix andSuffix:(NSString *)suffix {
	return [self hasPrefix:prefix] && [self hasSuffix:suffix];
}

- (NSString *)substringBetweenPrefix:(NSString *)prefix
                           andSuffix:(NSString *)suffix
{
	NSRange pre = [self rangeOfString:prefix];
	NSRange suf = [self rangeOfString:suffix];
	
	if (pre.location == NSNotFound || suf.location == NSNotFound) {
		return nil;
	}
	
	NSUInteger loc = pre.location  + pre.length;
	NSUInteger len = self.length - loc - (self.length - suf.location);
	NSRange r = NSMakeRange(loc, len);
	
	//NSLog(@"Substring with range %i, %i, %@", loc, len, NSStringFromRange(r));
	
	return [self substringWithRange:r];
}

/**
 * Unlike the Object-C default rangeOfString
 * this method will return -1 if the String could not be found, not NSNotFound
 */
- (NSInteger)indexOf:(NSString *)aString
{
	return [self indexOf:aString afterIndex:0];
}

- (NSInteger)indexOf:(NSString *)aString afterIndex:(NSInteger)index
{
	NSRange lookupRange = NSMakeRange(0, self.length);
	
	if (index < 0 && -index < self.length) {
		lookupRange.location = self.length + index;
	} else {
		if (index > self.length) {
			NSString *reason = [NSString stringWithFormat:
								@"LookupIndex %i is not within range: Expected 0-%i", 
								index, 
								self.length];
			@throw [NSException exceptionWithName:@"ArrayIndexOutOfBoundsExceptions" 
										   reason:reason
										 userInfo:nil];
		}
		lookupRange.location = index;
	}
	
	NSRange range = [self rangeOfString:aString	options:0 range:lookupRange];
	return (range.location == NSNotFound ? -1 : range.location);
}

- (NSInteger)lastIndexOf:(NSString *)aString
{
	NSString *reversed = self.reversed;
	NSInteger pos = [reversed indexOf:aString];
	
	return pos == -1 ? -1 : self.length - pos;
}

- (NSRange)rangeOfAny:(NSSet *)strings {
	NSRange re = NSMakeRange(NSNotFound, 0);
	
	for (NSString *s in strings) {
		NSRange r = [self rangeOfString:s];
		if (r.location < re.location) {
			re = r;
		}
	}
	
	return re;
}

- (NSArray *)lines
{
	return [self componentsSeparatedByString:@"\n"];
}

- (NSArray *)words
{
	NSMutableArray *re = NSMutableArray.array;
	for (NSString *s in [self componentsSeparatedByString:@" "]) {
		if (!s.isEmpty) {
			[re addObject:s];
		}
	}
	return re;
}

- (NSSet *)wordSet {
	return [NSMutableSet setWithArray:self.words];
}

- (NSArray *)trimmedComponentsSeparatedByString:(NSString *)separator {
	NSMutableArray *re = NSMutableArray.array;
	
	for (__strong NSString *s in [self componentsSeparatedByString:separator]) {
		s = s.trim;
		if (!s.isEmpty) {
			[re addObject:s];
		}
	}
	
	return re;
}

- (NSArray *)decolonize {
	return [self componentsSeparatedByString:@":"];
}

- (NSArray *)splitByComma {
	return [self componentsSeparatedByString:@","];
}

- (NSString *)substringBefore:(NSString *)delimiter {
	NSInteger index = [self indexOf:delimiter];
	if (index == -1) {
		return self;
	}
	return [self substringToIndex:index];
}

- (NSString *)substringAfter:(NSString *)delimiter {
	NSInteger index = [self indexOf:delimiter];
	if (index == -1) {
		return self;
	}
	return [self substringFromIndex:index + delimiter.length];
}

- (NSArray *)splitAt:(NSString *)delimiter {
	NSRange index = [self rangeOfString:delimiter];
	if (index.location == NSNotFound) {
		return [NSArray arrayWithObjects:self, nil];
	}
	return [NSArray arrayWithObjects:
			[self substringToIndex:index.location],
			[self substringFromIndex:index.location + index.length],
			nil
			];
}

- (BOOL)splitAt:(NSString *)delimiter 
           head:(NSString **)head 
           tail:(NSString **)tail
{
	NSRange index = [self rangeOfString:delimiter];
	if (index.location == NSNotFound) {
		return NO;
	}
	
	NSString *copy = self.copy;
	
	*head = [copy substringToIndex:index.location];
	*tail = [copy substringFromIndex:index.location + index.length];
	
	
	return YES;
}

- (NSArray *)decapitate {
	NSRange index = [self rangeOfString:@" "];
	if (index.location == NSNotFound) {
		return [NSArray arrayWithObjects:[self trim], nil];
	}
	return [NSArray arrayWithObjects:
			[[self substringToIndex:index.location] trim],
			[[self substringFromIndex:index.location + index.length] trim],
			nil
			];
}

- (NSPoint)pointValue {
	NSPoint re = NSMakePoint(0.0, 0.0);
	
	NSArray *values = self.splitByComma;
	if (values.count == 0) {
		return re;
	}
	re.x = [[values objectAtIndex:0] floatValue];
	if (values.count < 2) {
		re.y = re.x;
	} else {
		re.y = [[values objectAtIndex:1] floatValue];
	}
	
	return re;
}

- (NSUInteger)minutesValue {
	NSArray *split = [self componentsSeparatedByString:@":"];
	
	if (split.count > 1) {
		return [[split objectAtIndex:0] intValue] * 60 
		+ [[split objectAtIndex:1] intValue];
	}
	
	return [self intValue];
}

- (NSUInteger)secondsValue {
	NSArray *split = [self componentsSeparatedByString:@":"];
	
	if (split.count > 2) {
		return [[split objectAtIndex:0] intValue] * 3600 
		+ [[split objectAtIndex:1] intValue] * 60
		+ [[split objectAtIndex:2] intValue];
	} else if (split.count == 2) {
		return [[split objectAtIndex:0] intValue] * 3600 
		+ [[split objectAtIndex:1] intValue] * 60;
	}
	
	return [self intValue];
}

-(NSURL *)url {
	return [NSURL URLWithString:self];
}

-(NSURL *)fileURL {
	return [NSURL fileURLWithPath:self];
}

- (NSString *)ucfirst {
	NSString *head = [[self substringToIndex:1] uppercaseString];
	NSString *tail = [self substringFromIndex:1];
	return [NSString stringWithFormat:@"%@%@", head, tail];
}

- (NSString *)lcfirst {
	NSString *head = [[self substringToIndex:1] lowercaseString];
	NSString *tail = [self substringFromIndex:1];
	return [NSString stringWithFormat:@"%@%@", head, tail];
}

+ (id)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
	return [[self alloc] initWithData:data encoding:encoding];
}

+ (NSString *)stringWithCGFloat:(CGFloat)f maxDigits:(NSUInteger)numDigits
{
	//012345678 <-Indices.
	//42.123400 <-Assuming numDigits = 6.
	//^-----^   <-Returns this substring. (Trailing zeroes are deleted.)
	//42.000000
	//^^        <-Returns this substring (everything before the decimal point) for a whole number.
	NSString *format = numDigits ? [NSString stringWithFormat:@"%%.%uf", numDigits] : @"%f";
	NSString *str = [NSString stringWithFormat:format, (double)f];
	NSUInteger i = [str length];
	while (i-- > 0) {
		if ([str characterAtIndex:i] != '0') {
			//If we have run out of zeroes, this is a whole number. Leave off the decimal point.
			//Not incrementing i means that the decimal point will be dropped.
			if ([str characterAtIndex:i] != '.') ++i;
			break;
		}
	}
	return [str substringToIndex:i];
}

//This method creates an NSMutableAttributedString, using an NSString and an NSMutableParagraphStyle.

-(NSMutableAttributedString *) attributedParagraphWithSpacing:(float)spacing
{
	NSMutableParagraphStyle *aMutableParagraphStyle;
	NSMutableAttributedString   *attString;
	/*
	 The only way to instantiate an NSMutableParagraphStyle is to mutably copy an
	 NSParagraphStyle. And since we don't have an existing NSParagraphStyle available
	 to copy, we use the default one.
	 
	 The default values supplied by the default NSParagraphStyle are:
	 Alignment   NSNaturalTextAlignment
	 Tab stops   12 left-aligned tabs, spaced by 28.0 points
	 Line break mode   NSLineBreakByWordWrapping
	 All others   0.0
	 */
	aMutableParagraphStyle = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
	
	// Now adjust our NSMutableParagraphStyle formatting to be whatever we want.
	// The numeric values below are in points (72 points per inch)
	[aMutableParagraphStyle	setAlignment:NSLeftTextAlignment];
	[aMutableParagraphStyle setLineSpacing:spacing];
//	[aMutableParagraphStyle setParagraphSpacing:25.5];
//	[aMutableParagraphStyle setHeadIndent:25.0];
//	[aMutableParagraphStyle setTailIndent:-45.0];
	// setTailIndent: if negative, offset from right margin (right margin mark does
	//      NOT appear); if positive, offset from left margin (margin mark DOES appear)
//	[aMutableParagraphStyle setFirstLineHeadIndent:65.0];
	[aMutableParagraphStyle	setLineBreakMode:NSLineBreakByWordWrapping];
	/*
	 possible allignments
	 NSLeftTextAlignment
	 NSRightTextAlignment
	 NSCenterTextAlignment
	 NSJustifiedTextAlignment
	 NSNaturalTextAlignment
	 possible line wraps
	 NSLineBreakByWordWrapping
	 NSLineBreakByCharWrapping
	 NSLineBreakByClipping
	 */
	
	// Instantiate the NSMutableAttributedString with the argument string
	attString = [[NSMutableAttributedString alloc]
				 initWithString:self];
	// Apply your paragraph style attribute over the entire string
	[attString addAttribute:NSParagraphStyleAttributeName
					  value:aMutableParagraphStyle
					  range:NSMakeRange(0,[self length])];
//	[aMutableParagraphStyle release]; // since it was copy'd
//	[attString autorelease]; // since it was alloc'd
	return attString;
}
//If your NSTextView already has attributed strings in its textStorage, you can get the NSParagraphStyle by:

//aMutableParagraphStyle = [[myTextView typingAttributes]
//						  objectForKey:@"NSParagraphStyle"];


@end

//	[NSGraphicsContext saveGraphicsState];
//	[NSBezierPath clipRect: box];   // Make sure we don't draw outside our cell.
//	NSDictionary *attrs = $map(
//		[NSFont systemFontOfSize: 18, NSFontAttributeName,
//		[[NSColor alternateSelectedControlTextColor] colorWithAlphaComponent: 1], NSForegroundColorAttributeName)
//	NSLineBreakMode truncateMode = NSLineBreakByTruncatingMiddle;
//	[displayTitle drawInRect: textBox withAttributes: attrs];
//	[NSGraphicsContext restoreGraphicsState];

NSString*   StringByTruncatingStringWithAttributesForWidth( NSString* s, NSDictionary* attrs,
                                                                float wid, NSLineBreakMode truncateMode )
{
	NSSize				txSize = [s sizeWithAttributes: attrs];
    if( txSize.width <= wid )   // Don't do anything if it fits.
        return s;
	NSMutableString*	currString = [NSMutableString string];
	NSRange             rangeToCut = { 0, 0 };
    if( truncateMode == NSLineBreakByTruncatingTail )    {
        rangeToCut.location = [s length] -1;
        rangeToCut.length = 1;
    }
    else if( truncateMode == NSLineBreakByTruncatingHead )    {
        rangeToCut.location = 0;
        rangeToCut.length = 1;
    }
    else {    // NSLineBreakByTruncatingMiddle
        rangeToCut.location = [s length] / 2;
        rangeToCut.length = 1;
    }
    
	while( txSize.width > wid )	{
		if( truncateMode != NSLineBreakByTruncatingHead && rangeToCut.location <= 1 )
			return @"...";
        [currString setString: s];
        [currString replaceCharactersInRange: rangeToCut withString: @"..."];
		txSize = [currString sizeWithAttributes: attrs];
        rangeToCut.length++;
        if( truncateMode == NSLineBreakByTruncatingHead )
            ;   // No need to fix location, stays at start.
        else if( truncateMode == NSLineBreakByTruncatingTail )
            rangeToCut.location--;  // Fix location so range that's one longer still lies inside our string at end.
        else if( (rangeToCut.length & 1) != 1 )     // even? NSLineBreakByTruncatingMiddle
            rangeToCut.location--;  // Move location left every other time, so it grows to right and left and stays centered.
        if( rangeToCut.location <= 0 || (rangeToCut.location +rangeToCut.length) > [s length] )
            return @"...";
	}
	return currString;
}



@implementation NSMutableString (AtoZ)

- (NSString *)shift {
NSString *re = [self substringToIndex:1];
[self setString:[self substringFromIndex:1]];
return re;
}

- (NSString *)pop {
	NSUInteger index = self.length - 1;
	NSString *re = [self substringFromIndex:index];
	[self setString:[self substringToIndex:index]];
	return re;
}

- (BOOL)removePrefix:(NSString *)prefix {
	if (![self hasPrefix:prefix]) {
		return NO;
	}
	
	NSRange range = NSMakeRange(0, prefix.length);
	[self replaceCharactersInRange:range withString:@""];
	
	return YES;
}

- (BOOL)removeSuffix:(NSString *)suffix {
	if (![self hasSuffix:suffix]) {
		return NO;
	}
	
	NSRange range = NSMakeRange(self.length - suffix.length, suffix.length);
	[self replaceCharactersInRange:range withString:@""];
	
	return YES;
}

- (BOOL)removePrefix:(NSString *)prefix andSuffix:(NSString *)suffix {
	if (![self hasPrefix:prefix andSuffix:suffix]) {
		return NO;
	}
	
	NSRange range = NSMakeRange(0, prefix.length);
	[self replaceCharactersInRange:range withString:@""];
	
	range = NSMakeRange(self.length - suffix.length, suffix.length);
	[self replaceCharactersInRange:range withString:@""];
	
	return YES;
}

- (NSMutableString *)camelize {
	unichar c;
	unichar us = [@"_" characterAtIndex:0];
	unichar hy = [@"-" characterAtIndex:0];
	NSMutableString *r = [NSMutableString string];
	
	for (NSUInteger i = 0; i < self.length; i++) {
		c = [self characterAtIndex:i];
		if (c == us || c == hy) {
			[r setString:[self substringWithRange:NSMakeRange(i, 1)]];
			
			[self replaceCharactersInRange:NSMakeRange(i, 2) 
								withString:[r uppercaseString]];
			i++;
		}
	}
	
	return self;
}

- (NSMutableString *)hyphonize {
	return [self replaceAll:@"_" withString:@"-"];
}

- (NSMutableString *)underscorize {
	return [self replaceAll:@"-" withString:@"_"];
}

- (NSMutableString *)constantize {
	[self setString:[[self underscorize] uppercaseString]];
	return self;
}

- (NSMutableString *)replaceAll:(NSString *)needle 
                     withString:(NSString *)replacement 
{
	[self replaceOccurrencesOfString:needle
						  withString:replacement
							 options:0
							   range:NSMakeRange(0, self.length)
	 ];
	return self;
}



@end