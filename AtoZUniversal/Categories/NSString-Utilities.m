#import "NSString-Utilities.h"

@implementation NSString(Utilities)

typedef NSString*(* string_IMP)(id,SEL,...);

+ (NSString*)stringWithFileSystemRepresentation:(const char*)path
{
	if (path)
		return [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];
	
	return nil;
}

//+ stringWithMacOSRomanString:(const char *)nullTerminatedCString;
//{
//	return [[[NSString alloc] initWithBytes:nullTerminatedCString length:strlen(nullTerminatedCString) encoding:NSMacOSRomanStringEncoding] autorelease];
//}
//
//+ (NSString*)stringWithPString:(Str255)pString;
//{
//	NSString* result = [[NSString alloc] initWithBytes:(const char *)pString+1 length:pString[0] encoding:NSMacOSRomanStringEncoding];
//
//    return [result autorelease];
//}
//
//- (void)getPString:(Str255)outString
//{
//	int len = MIN((unsigned)255, strlen([self UTF8String]));
//
//	memcpy(outString+1, [self UTF8String], len);
//    outString[0] = len;
//}

- (void)getUTF8String:(char*)outString maxLength:(int)maxLength;
{
	NSInteger len = MIN((unsigned)maxLength, strlen([self UTF8String]));
	
	memcpy(outString, [self UTF8String], len);
    outString[len] = 0;
}

- (NSString*)slashToColon;
{
	return [self stringByReplacing:@"/" with:@":"];
}

- (NSString*)colonToSlash;
{
	return [self stringByReplacing:@":" with:@"/"];
}

//+ (NSString*)stringWithHFSUniStr255:(const HFSUniStr255*)hfsString;
//{
//	CFStringRef stringRef = FSCreateStringFromHFSUniStr(nil, hfsString);
//    
//	NSString* result = [[(NSString*)stringRef retain] autorelease];
//	
//	CFRelease(stringRef);
//	
//    return result;
//}
//
//+ (NSString*)fileNameWithHFSUniStr255:(const HFSUniStr255*)hfsString;
//{
//	CFStringRef stringRef = FSCreateStringFromHFSUniStr(nil, hfsString);
//    
//	// this name contains "/" characters, must convert to ":"
//	NSString* result = [(NSString*)stringRef slashToColon];
//	
//	CFRelease(stringRef);
//	
//    return result;
//}
//
//- (void)HFSUniStr255:(HFSUniStr255*)hfsString
//{
//	FSGetHFSUniStrFromString((CFStringRef)self, hfsString);
//}

- (NSString*)stringByReplacing:(NSString *)value with:(NSString *)newValue;
{
    NSMutableString *newString = [NSMutableString stringWithString:self];

    [newString replaceOccurrencesOfString:value withString:newValue options:NSLiteralSearch range:NSMakeRange(0, [newString length])];

    return newString;
}

- (NSString*)stringByReplacingValuesInArray:(NSArray *)values withValuesInArray:(NSArray *)newValues;
{
    NSUInteger i, cnt = [values count];
    NSString *tempString=self;

    for (i=0; i < cnt; i++)
    {
        NSString *newValue;

        newValue=[tempString stringByReplacing:[values objectAtIndex:i] with:[newValues objectAtIndex:i]];
        tempString=newValue;
    }
    return tempString;
}

+ stringWithBytes:(const void *)bytes length:(unsigned)len encoding:(NSStringEncoding)encoding;
{
	return [Text.alloc initWithBytes:bytes length:len encoding:encoding];
}

+ stringWithUTF8String:(const void *)bytes length:(unsigned)length;
{
  return [[NSString alloc] initWithBytes:bytes length:length encoding:NSUTF8StringEncoding];

}

- (BOOL)stringContainsValueFromArray:(NSArray *)theValues
{
    id eachItem;

    for (eachItem in theValues)
    {
        NSRange foundSourceRange;

        foundSourceRange=[self rangeOfString:eachItem options:NSLiteralSearch];
        if (foundSourceRange.length!=0)
            return YES;
    }

    return NO;
}

- (BOOL)isEqualToString:(NSString *)str caseSensitive:(BOOL)caseSensitive;
{
	if (caseSensitive)
		return [self isEqualToString:str];
	
	return [self isEqualToStringCaseInsensitive:str];
}

- (BOOL)hasPrefix:(NSString *)prefix caseSensitive:(BOOL)caseSensitive;
{
	if (caseSensitive)
		return [self hasPrefix:prefix];

	return [[self lowercaseString] hasPrefix:[prefix lowercaseString]];
}

- (BOOL)hasSuffix:(NSString *)suffix caseSensitive:(BOOL)caseSensitive;
{
	if (caseSensitive)
		return [self hasSuffix:suffix];

	return [[self lowercaseString] hasSuffix:[suffix lowercaseString]];
}

- (NSString*)stringByDeletingSuffix:(NSString *)suffix caseSensitive:(BOOL)caseSensitive;
{
	if ([self hasSuffix:suffix caseSensitive:caseSensitive])
        return [self substringToIndex:([self length]-[suffix length])];
	
    return self;	
}

- (NSString*)stringByDeletingPrefix:(NSString *)prefix caseSensitive:(BOOL)caseSensitive;
{
	if ([self hasPrefix:prefix caseSensitive:caseSensitive])
        return [self substringFromIndex:[prefix length]];
	
    return self;	
}

- (NSString*)stringByDeletingSuffix:(NSString *)suffix;
{
	return [self stringByDeletingSuffix:suffix caseSensitive:YES];
}

- (NSString*)stringByDeletingPrefix:(NSString *)prefix;
{
	return [self stringByDeletingPrefix:prefix caseSensitive:YES];
}

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)str
{
    // returns - NSOrderedAscending, NSOrderedSame, NSOrderedDescending
    return ([self caseInsensitiveCompare:str] == NSOrderedSame);
}

- (NSArray*)linesFromString:(NSString**)outRemainder;
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:20];
    NSUI length = [self length];
    NSString *line;
    NSRange range = NSMakeRange(0, 1);
    NSUInteger start, end, contentsEnd;

    // getLineStart can throw exceptions
    NS_DURING

        // must parse out the lines, more than one line will be returned
        while (NSMaxRange(range) <= length)
        {
            [self getLineStart:&start end:&end contentsEnd:&contentsEnd forRange:range];

            if ((start >= range.location) && (start != end) && (end != contentsEnd))
            {
                line = [self substringWithRange:NSMakeRange(start, contentsEnd-start)];
                [result addObject:line];

                range = NSMakeRange(end, 1);
            }
            else
            {
                if (outRemainder)
                {
                    if (end == contentsEnd)
                        *outRemainder = [self substringWithRange:NSMakeRange(start, contentsEnd-start)];
                    else
                        *outRemainder = nil;
                }

                break;
            }
        }

        NS_HANDLER
            ;
        NS_ENDHANDLER

        return result;
}

- (NSString*)getFirstLine;
{
    NSString *line=self;
    NSRange range = NSMakeRange(0, 1);
    NSUInteger start, end, contentsEnd;

    if (NSMaxRange(range) <= [self length])
    {
        [self getLineStart:&start end:&end contentsEnd:&contentsEnd forRange:range];

        if ((start >= range.location) && (start != end) && (end != contentsEnd))
            line = [self substringWithRange:NSMakeRange(start, contentsEnd-start)];
    }

    return line;
}


// includeSpace NO if your putting the string in quotes for the terminal
- (NSString*)stringWithShellCharactersEscaped:(BOOL)notInQuotes;
{
    NSString *result;
	result=[self stringByReplacing:@"\\" with:@"\\\\"]; // must go first
    result=[result stringByReplacing:@"\"" with:@"\\\""];
	result=[result stringByReplacing:@"$" with:@"\\$"];
	result=[result stringByReplacing:@"!" with:@"\\!"];
	
	if (notInQuotes)
	{
		result=[result stringByReplacing:@"'" with:@"\\'"];
		result=[result stringByReplacing:@":" with:@"\\:"];
		result=[result stringByReplacing:@"?" with:@"\\?"];
		result=[result stringByReplacing:@"*" with:@"\\*"];
		result=[result stringByReplacing:@"&" with:@"\\&"];
		result=[result stringByReplacing:@";" with:@"\\;"];
		result=[result stringByReplacing:@"|" with:@"\\|"];
		
		result=[result stringByReplacing:@" " with:@"\\ "];
		result=[result stringByReplacing:@"(" with:@"\\("];
		result=[result stringByReplacing:@")" with:@"\\)"];
		result=[result stringByReplacing:@"[" with:@"\\["];
		result=[result stringByReplacing:@"]" with:@"\\]"];
	}
	
    return result;
}

- (NSString*)stringWithRegularExpressionCharactersQuoted;
{
	NSString *result;
	result = [self stringWithShellCharactersEscaped:YES];
	
	// add the +
	result=[result stringByReplacing:@"+" with:@"\\+"];
	
	return result;
}

- (NSString*)URLEncodedString;
{
    CFStringRef (stringRef) = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) self, NULL, NULL, kCFStringEncodingUTF8);

    NSString *result = [NSString stringWithString:(__bridge NSString*)stringRef];
    CFRelease(stringRef);
    
    return result;
}


// converts a POSIX path to an HFS path
- (NSString*)HFSPath;
{
    CFURLRef fileURL;
    NSString* hfsPath=nil;

    fileURL = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)self, kCFURLPOSIXPathStyle, NO);

    if (fileURL)
    {
        CFStringRef hfsRef = CFURLCopyFileSystemPath(fileURL, kCFURLHFSPathStyle);
        if (hfsRef)
        {
            // copy into an autoreleased NSString
            hfsPath = [NSString stringWithString:(__bridge NSString*)hfsRef];

            CFRelease(hfsRef);
        }

        CFRelease(fileURL);
    }

    return hfsPath;
}

// converts a POSIX path to a Windows path
- (NSString*)windowsPath;
{
	CFURLRef fileURL;
	NSString* hfsPath=nil;
	
	fileURL = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)self, kCFURLPOSIXPathStyle, NO);
	
	if (fileURL)
	{
		CFStringRef hfsRef = CFURLCopyFileSystemPath(fileURL, kCFURLWindowsPathStyle);
		if (hfsRef)
		{
			// copy into an autoreleased NSString
			hfsPath = [NSString stringWithString:(__bridge NSString*)hfsRef];
			
			CFRelease(hfsRef);
		}
		
		CFRelease(fileURL);
	}
	
	return hfsPath;
}

// converts a HFS path to a POSIX path
- (NSString*)POSIXPath;
{
    CFURLRef fileURL;
    NSString* posixPath=nil;

    fileURL = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)self, kCFURLHFSPathStyle, NO);

    if (fileURL)
    {
        CFStringRef posixRef = CFURLCopyFileSystemPath(fileURL, kCFURLPOSIXPathStyle);

        if (posixRef)
        {
            // copy into an autoreleased NSString
            posixPath = [NSString stringWithString:(__bridge NSString*)posixRef];

            CFRelease(posixRef);
        }

        CFRelease(fileURL);
    }

    return posixPath;
}

- (NSString *)stringByRemovingCharactersInCharacterSet:(NSCharacterSet *)removeSet;
{
	NSRange r = [self rangeOfCharacterFromSet:removeSet];
	
	if (r.location == NSNotFound) 
		return self;
	
	NSMutableString *result = self.mC;
	do
	{
		[result replaceCharactersInRange:r withString:@""];
		r = [result rangeOfCharacterFromSet:removeSet];
	}
	while (r.location != NSNotFound);
	
	return result;
}

- (NSString *)stringByRemovingReturns;
{
    static NSCharacterSet *newlineCharacterSet = nil;
    
    if (newlineCharacterSet == nil)
        newlineCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
    
    return [self stringByRemovingCharactersInCharacterSet:newlineCharacterSet];
}

+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;
{
    return [self.alloc initWithData:data encoding:encoding];
}

- (NSString*)stringByTrimmingWhiteSpace;
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByRemovingPrefix:(NSString *)prefix;
{
    NSRange aRange;
	
    aRange = [self rangeOfString:prefix options:NSAnchoredSearch];
    if ((aRange.length == 0) || (aRange.location != 0))
        return self;
    return [self substringFromIndex:aRange.location + aRange.length];
}

- (NSString *)stringByRemovingSuffix:(NSString *)suffix;
{
    if (![self hasSuffix:suffix])
        return self;
    return [self substringToIndex:[self length] - [suffix length]];
}

- (BOOL)isEndOfWordAtIndex:(unsigned)index;
{
    if (index == [self length])
        return YES;
    else if (index >0 && index < [self length])
    {
        NSCharacterSet *wordSep;
        unichar ch;

        ch = [self characterAtIndex:index];

        wordSep = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if ([wordSep characterIsMember:ch])
            return YES;

        wordSep = [NSCharacterSet punctuationCharacterSet];
        if ([wordSep characterIsMember:ch])
            return YES;
    }

    return NO;
}

- (BOOL)isStartOfWordAtIndex:(unsigned)index;
{
    if (index == 0)
        return YES;
    else
    {
        index -= 1;  // get the character before this index
        if (index >0 && index < [self length])
        {
            NSCharacterSet *wordSep;
            unichar ch;

            ch = [self characterAtIndex:index];

            wordSep = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            if ([wordSep characterIsMember:ch])
                return YES;

            wordSep = [NSCharacterSet punctuationCharacterSet];
            if ([wordSep characterIsMember:ch])
                return YES;
        }
    }

    return NO;
}

- (NSString*)stringByTruncatingToLength:(unsigned)length;
{
    NSString* result = self;

    if ([self length] > length)
    {
        int segmentLen = (length/2) - 2;

        result = [self substringToIndex:segmentLen];
        result = [result stringByAppendingString:@"..."];
        result = [result stringByAppendingString:[self substringFromIndex:([self length] - segmentLen)]];
    }

    return result;
}

#define kEncryptionKey 1

- (NSString*)stringByEncryptingString;
{
    NSUI i, cnt=[self length];
    NSMutableString *result = [NSMutableString string];

    for (i=0;i<cnt;i++)
    {
        unichar aChar = [self characterAtIndex:i];

        [result appendChar:aChar + kEncryptionKey];
    }

    return result;
}

- (NSString*)stringByDecryptingString;
{
    int i, cnt=[self length];
    NSMutableString *result = [NSMutableString string];

    for (i=0;i<cnt;i++)
    {
        unichar aChar = [self characterAtIndex:i];

        [result appendChar:aChar - kEncryptionKey];
    }

    return result;
}

//- (BOOL)FSRef:(FSRef*)fsRef createFileIfNecessary:(BOOL)createFile;
//{
//    NSFileManager* fileManager = [NSFileManager defaultManager];
//    CFURLRef urlRef;
//    Boolean gotFSRef;
//
//    // Check whether the file exists already.  If not, create an empty file if requested.
//    if (![fileManager fileExistsAtPath:self])
//    {
//        if (createFile)
//        {
//            if (![@"" writeToFile:self atomically:YES encoding:NSUTF8StringEncoding error:nil])
//                return NO;
//        }
//        else
//            return NO;
//    }
//
//    // Create a CFURL with the specified POSIX path.
//    urlRef = CFURLCreateWithFileSystemPath( kCFAllocatorDefault,
//                                            (CFStringRef) self,
//                                            kCFURLPOSIXPathStyle,
//                                            FALSE /* isDirectory */ );
//    if (urlRef == NULL)
//        return NO;
//
//    gotFSRef = CFURLGetFSRef(urlRef, fsRef);
//    CFRelease(urlRef);
//
//    if (!gotFSRef)
//        return NO;
//
//    return YES;
//}

//- (BOOL)FSSpec:(FSSpec*)fsSpec createFileIfNecessary:(BOOL)createFile;
//{
//    FSRef fsRef;
//
//    if (![self FSRef:&fsRef createFileIfNecessary:createFile])
//        return NO;
//
//    if (FSGetCatalogInfo( &fsRef,
//                          kFSCatInfoNone,
//                          NULL,
//                          NULL,
//                          fsSpec,
//                          NULL ) != noErr)
//    {
//        return NO;
//    }
//
//    return YES;
//}

// doesn't allow extensions with spaces
- (NSString*)strictPathExtension;
{
    NSString* ext = [self pathExtension];
    NSRange spaceRange;
    
    if ([ext length])
    {
        // search for a space
        spaceRange=[ext rangeOfString:@" " options:NSLiteralSearch];
        if (spaceRange.location != NSNotFound)
            return @"";
    }
    
    return ext;    
}

- (NSString*)strictStringByDeletingPathExtension;
{
    NSString* ext = [self strictPathExtension];
    
    // if we don't find an extension, don't call stringByDeletingPathExtension
    if (![ext length])
        return self;
    
	/*
	 (gdb) po name
	 http-//www.nytimes.com/2005/11/27/business/yourmoney/27hedge.html?th&emc=th.webloc
	 (gdb) po [name stringByDeletingPathExtension]
	 http-/www.nytimes.com/2005/11/27/business/yourmoney/27hedge.html?th&emc=th
	 */	 
    // return [self stringByDeletingPathExtension];
	
	return [self substringWithRange:NSMakeRange(0, [self length] - ([ext length]+1))];  // +1 for the .
}

- (NSString*)stringByDeletingPercentEscapes;
{
    // returns nil if fails, we don't want this behavior
    NSString* result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (result)
        return result;
    
    return self;
}

- (NSComparisonResult)filenameCompareWithString:(NSString *)rightString;
{
#if SNOWLEOPARD
	return [self localizedStandardCompare:rightString];
#endif
	return [self compare:rightString
				 options:NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch
				   range:NSMakeRange(0, [self length])
				  locale:[NSLocale currentLocale]];
}

- (NSString*)stringInStringsFileFormat;
{
	NSString *result = self;
	
	result = [result stringByReplacing:@"\r" with:@"\\n"];
	result = [result stringByReplacing:@"\n" with:@"\\n"];
	result = [result stringByReplacing:@"\t" with:@"\\t"];
	result = [result stringByReplacing:@"\"" with:@"\\\""];

	return result;
}

- (NSString*)stringFromStringsFileFormat;
{
	NSString *result = self;
	
	result = [result stringByReplacing:@"\\n"  with:@"\n"];
	result = [result stringByReplacing:@"\\r"  with:@"\n"];
	result = [result stringByReplacing:@"\\t"  with:@"\t"];
	result = [result stringByReplacing:@"\\\""  with:@"\""];

	return result;
}

- (NSString*)stringPairInStringsFileFormat:(NSString*)right addNewLine:(BOOL)addNewLine;
{
	NSString *selfie = [self stringInStringsFileFormat];
	right = [right stringInStringsFileFormat];
	
	return [NSString stringWithFormat:@"\"%@\" = \"%@\";%@", selfie, right, (addNewLine) ? @"\n": @""];
}

// a unique string
+ (NSString*)unique;
{	
	static unsigned counter=0;  // protected for thread safety
	unsigned intValue;
	
	@synchronized(self) {
		intValue = counter++;
	}
	
	return [NSString stringWithFormat:@"u:%u", intValue];
}

// Split on slashes and chop out '.' and '..' correctly.
- (NSString *)normalizedPath;
{
	char resolved[PATH_MAX];
	char* result = realpath([self fileSystemRepresentation], resolved);
	
	if (!result)
		return [NSString stringWithFileSystemRepresentation:result];
	
	return self;	
}

@end

// ================================================================================================

@implementation NSMutableString(Utilities)

- (void)replace:(NSString *)value with:(NSString *)newValue;
{    
    [self replaceOccurrencesOfString:value withString:newValue options:NSLiteralSearch range:NSMakeRange(0, [self length])];
}

- (void)appendChar:(unichar)aCharacter;
{
	CFStringAppendCharacters((CFMutableStringRef)self, &aCharacter, 1);
}

@end

