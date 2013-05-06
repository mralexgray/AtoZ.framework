//
//  AZLog.m
//  AtoZ
//
//  Created by Alex Gray on 5/2/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZLog.h"


static NSA *gPal = nil;
JREnum ( LogEnv, LogEnvXcodeColor, LogEnvXcodeNOColor, LogEnvTTY );

@implementation AZLog

- (void) setUp {	![self.class hasSharedInstance] ? ^{

	[[self class] setSharedInstance:self];
	if (!gPal) gPal = NSC.randomPalette;
	
	}(): nil;
}
- (BOOL) inTTY 			{   return [@(isatty(STDERR_FILENO))boolValue]; }
- (LogEnv) logEnv 		{

	if (self.inTTY) return LogEnvTTY;
	char *XcodeSaysColor	= getenv("XCODE_COLORS");
	return XcodeSaysColor != NULL && SameChar(XcodeSaysColor,"YES") ? LogEnvXcodeColor :  LogEnvXcodeNOColor;
}

#define LOG_CALLER_VERBOSE NO		// Rediculous logging of calling method
#define LOG_CALLER_INFO	YES		// Slighlty less annoying logging of calling method

- (NSA*) rgbColorValues:(id)color 				{
	__block float r, g, b;  __block NSC *x;									   //  printf("%s", $(@"%@",[color class]).UTF8String);

	if ([color ISKINDA:NSS.class]) x = [NSC colorWithName:color] ? : [NSC colorWithCSSRGB:color] ? : RED;

	ISA(color, NSC) ? ^{	 x = color;  x = x.isDark ? [x colorWithBrightnessOffset:2] : x;
		x = [x colorUsingColorSpace:NSColorSpace.genericRGBColorSpace];
		r = (x.redComponent * 255); g = (x.greenComponent * 255); b = (x.blueComponent * 255);					} ()

	: ISA(color, NSA) && [color count] == 3 ? ^{
		r = [color[0] integerValue]; g = [color[1] integerValue]; b = [color[2] integerValue];
	} () : nil;  return @[@(r), @(g), @(b)];
}
- (NSS*) colorizeString:(NSS*)string front:(id)front back:(id)back  {				//NSA *rgbs;
	if (front) [string setLogForeground:front];
	if (back)  [string  setLogBackground:back];
	return string;
}
- (NSS*) colorizeString:(NSS*)string withColor:(id)color 				{
	return [self colorizeString:string front:color back:nil];
}
/* Pass a variadic list of Colors, and Ovjects, in any order, TRMINATED BY NIL, abd it wiull use those colors to log those objects! */
//- (NSA*) COLORIZE:(id) colorsAndThings, ...  {
- (NSA*) colorizeAndReturn:(id) colorsAndThings, ... {
	__block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;

	AZVA_Block sort   = ^(id thing) { [thing ISKINDA:NSC.class] ? [colors addObject:thing] : [words addObject:thing]; };
	AZVA_Block theBlk = ^(id thing) { if ([thing ISKINDA:NSA.class])  [(NSA*)thing each:^(id obj) {   sort(thing);		}];
	else sort (thing);
	};

	azva_iterate_list(colorsAndThings, theBlk);   
	return [words nmap:^id (id o, NSUI i) { 
		NSS *n = $(@"%@", o); NSC *c  = [colors normal:i];  
		n.logForeground = c.isDark ? c.invertedColor : c;  return n; 
	}];
}
/*NSA * COLORIZE		  ( id colorsAndThings, ... )*/							


-(void) logNilTerminatedListOfColorsAndStrings:(const char*)pretty things:(id) colorsAndThings,... 	{

	__block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;
	AZVA_Block theBlk = ^(id it) {								//			AZVA_Block sort   = ^(id it) {
		[it ISKINDA:NSC.class] ? [colors addObject:[it copy]] :
		[it ISKINDA:NSS.class] ? [words  addObject:[it copy ]] :
		[it ISKINDA:NSA.class] ? [(NSA*)it each:^(id obj) {
		   [obj ISKINDA:NSC.class] ? [colors addObject:[obj copy]] :
		   [obj ISKINDA:NSS.class] ? [words  addObject:[obj copy]] :
		   [obj respondsToString:@"stringValue"] ? [words addObject:[[obj stringValue]copy]] : nil;
		}]:[ it respondsToString:@"stringValue"] ? [words addObject:[[ it stringValue]copy]] : nil;
	};
	azva_iterate_list(colorsAndThings, theBlk);
	//	NSLog(@"colors:%ld:%@ words:%ld:%@", colors.count, colors, words.count, words);
	//	NSA *colors, *words, *colorStringArray;  colorStringArray = colors1strings2(colorsAndThings); colors = colorStringArray[0]; words = colorStringArray[1];
	LogEnv e =  self.logEnv ; __block NSUI ctr = 0;
	if (!colors.count) colors = @[WHITE].mutableCopy;
	if (!words.count) {  printf( "WARNING, NO WORDS TO PRINT: %s", pretty); return; }
	fprintf(stderr, "%s", //e != LogEnvXcodeColor ? [words componentsJoinedByString:@" "].UTF8String :

	 [[words reduce:LOG_CALLER_VERBOSE ? @"LOGCOLORS: ":@"" withBlock:^NSS*(NSS *sum,NSS *o) {
															NSC  *c 				= [colors normal:ctr];	ctr++;
															o.logForeground 	= c.isDark ? [c colorWithBrightnessMultiplier:2]: c;
															return [sum withString:o.colorLogString];
														}]UTF8String]);
}

void WEBLOG (id format, ...) {

	NSLogConsoleView* e = (NSLogConsoleView*)[NSLogConsole.sharedConsole webView];
//	[e logString: file:(char*)filename lineNumber:(int)lineNum];
	
}


-(void) logInColor:(id)color file:(const char *)filename line:(int)line func:( const char *)funcName format:(id) format, ...	{

   va_list argList;  va_start(argList,format);	__block NSS *lineNum,*path,*mess,*func,*output; __block NSUI numberofspaces;

	path	= $(@"[%@]", $UTF8(filename).lastPathComponent);
	mess 	= [NSS stringWithFormat:format arguments:argList];

		//:fl lineNumber:ln];setFakeStdin:$(@"%@%i%s%@",path, line, funcName, mess)];
	self.logEnv == LogEnvXcodeColor ? ^{

		path.logForeground 		= gPal [0];
		lineNum						= $( @":%i ", line );
		lineNum.logForeground 	= gPal [1];
		numberofspaces		 		=      10;	//MIN(MAX((paddedString.length - concat.length), 2), 20);
		func  						= [$UTF8(funcName) truncateInMiddleToCharacters:30];
		func.logForeground 		= [gPal[2] darker];
		//	output = $(@"%@%@", path.colorLogString, lineNum.colorLogString);   //, [NSS spaces:numberofspaces]);
		NSC* messColor				= color 	? : gPal [4];
		mess.logForeground      = messColor;
		mess 							= mess.colorLogString ?: mess;  //  actual log message

		output 						= [mess paddedTo:120];//withString:output];
		output 						= [output withString:func.colorLogString];
		//	[func containsAnyOf:@[@"///Color"]] ? @"" : func.colorLogString];	//	fflush(stdout);
		[NSTerminal printString:output];
///		fprintf(stderr, "%s\n", output.UTF8String);

	}() : [NSTerminal printString:mess]; 
	
//		[%@]:%i @"%s*/ @"%@\n",/* path, line, funcName,*/ 
//										XCODE_COLORS_ESCAPE @"fg140,140,140;"   @":%i"  XCODE_COLORS_RESET
//										XCODE_COLORS_ESCAPE @"fg109,0,40;"  @" %s "		 XCODE_COLORS_RESET
//										XCODE_COLORS_ESCAPE @"%@" "%@"XCODE_COLORS_RESET @"\n",
//										path,
//										line, funcName,
//										colorString,
//										mess)
//	 toLog.UTF8String);//
	va_end(argList);
} // ACTIVE NSLOG


////void _AZColorLog		( id color, const char *filename, int line, const char *funcName, id format, ...) {
//
//	if (!gPal) gPal = NSC.randomPalette;
//   va_list argList;  va_start(argList,format);	__block NSS *lineNum,*path,*mess,*func,*output; __block NSUI numberofspaces;
//
//	path	= $(@"[%@]", $UTF8(filename).lastPathComponent);
//	mess 	= [NSS stringWithFormat:format arguments:argList];
//
//		//:fl lineNumber:ln];setFakeStdin:$(@"%@%i%s%@",path, line, funcName, mess)];
//	AZLogEnv() == LogEnvXcodeColor ? ^{
//
//		path.logForeground 		= gPal [0];
//		lineNum						= $( @":%i ", line );
//		lineNum.logForeground 	= gPal [1];
//		numberofspaces		 		=      10;	//MIN(MAX((paddedString.length - concat.length), 2), 20);
//		func  						= [$UTF8(funcName) truncateInMiddleToCharacters:30];
//		func.logForeground 		= [gPal[2] darker];
//		//	output = $(@"%@%@", path.colorLogString, lineNum.colorLogString);   //, [NSS spaces:numberofspaces]);
//		NSC* messColor				= color 	? : gPal [4];
//		mess.logForeground      = messColor;
//		mess 							= mess.colorLogString ?: mess;  //  actual log message
//
//		output 						= [mess paddedTo:120];//withString:output];
//		output 						= [output withString:func.colorLogString];
//		//	[func containsAnyOf:@[@"///Color"]] ? @"" : func.colorLogString];	//	fflush(stdout);
//		fprintf(stderr, "%s\n", output.UTF8String);
//
//	}() : ^{ fprintf(stderr, "%s", $(/*@"[%@]:%i @"%s*/ @"%@\n",/* path, line, funcName,*/ mess).UTF8String); return; }();
////										XCODE_COLORS_ESCAPE @"fg140,140,140;"   @":%i"  XCODE_COLORS_RESET
////										XCODE_COLORS_ESCAPE @"fg109,0,40;"  @" %s "		 XCODE_COLORS_RESET
////										XCODE_COLORS_ESCAPE @"%@" "%@"XCODE_COLORS_RESET @"\n",
////										path,
////										line, funcName,
////										colorString,
////										mess)
////	 toLog.UTF8String);//
//	va_end(argList);
//} // ACTIVE NSLOG
//

//typedef NSA*(^SeperateColorsThenStrings)(id colorsAndThings);
//AZVA_Block theBlk = ^(id thing) { [thing ISKINDA:NSC.class] ? [colors addObject:thing] : [words addObject:thing]; };
//
//SeperateColorsThenStrings colors1strings2 = ^(id colorsAndThings){
//
// __block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;
//	azva_iterate_list(colorsAndThings, theBlk);
//	return @[Block_copy(colors), Block_copy(words)];
//};



//+(BOOL) inTTY 					{   return [@(isatty(STDERR_FILENO))boolValue]; }
//LogEnv AZLogEnv(void) 		{
//
//	if (inTTY()) return LogEnvTTY;
//	char *XcodeSaysColor	= getenv("XCODE_COLORS");
//	return XcodeSaysColor != NULL && SameChar(XcodeSaysColor,"YES") ? LogEnvXcodeColor :  LogEnvXcodeNOColor;
//}
//
//#define LOG_CALLER_VERBOSE NO		// Rediculous logging of calling method
//#define LOG_CALLER_INFO	YES		// Slighlty less annoying logging of calling method
//
//NSA * rgbColorValues			 	             (id color) 				{
//	__block float r, g, b;  __block NSC *x;									   //  printf("%s", $(@"%@",[color class]).UTF8String);
//
//	if ([color ISKINDA:NSS.class]) x = [NSC colorWithName:color] ? : [NSC colorWithCSSRGB:color] ? : RED;
//
//	ISA(color, NSC) ? ^{	 x = color;  x = x.isDark ? [x colorWithBrightnessOffset:2] : x;
//		x = [x colorUsingColorSpace:NSColorSpace.genericRGBColorSpace];
//		r = (x.redComponent * 255); g = (x.greenComponent * 255); b = (x.blueComponent * 255);					} ()
//
//	: ISA(color, NSA) && [color count] == 3 ? ^{
//		r = [color[0] integerValue]; g = [color[1] integerValue]; b = [color[2] integerValue];
//	} () : nil;  return @[@(r), @(g), @(b)];
//}
//NSS * colorizeStringWithColors (NSS *string, id front, id back)	{				//NSA *rgbs;
//	if (front) [string setLogForeground:front];
//	if (back)  [string  setLogBackground:back];
//	return string;
//}
//NSS * colorizeStringWithColor	 (NSS *string, id color) 				{
//	return colorizeStringWithColors(string, color, nil);
//}
//
///* Pass a variadic list of Colors, and Ovjects, in any order, TRMINATED BY NIL, abd it wiull use those colors to log those objects! */
//NSA * COLORIZE		  ( id colorsAndThings, ... )							{
//	__block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;
//
//	AZVA_Block sort   = ^(id thing) { [thing ISKINDA:NSC.class] ? [colors addObject:thing] : [words addObject:thing]; };
//	AZVA_Block theBlk = ^(id thing) { if ([thing ISKINDA:NSA.class])  [(NSA*)thing each:^(id obj) {   sort(thing);		}];
//	else sort (thing);
//	};
//
//	azva_iterate_list(colorsAndThings, theBlk);   return [words nmap:^id (id o, NSUI i) { NSS *n = $(@"%@", o); NSC *c  = [colors normal:i];  n.logForeground = c.isDark ? c.invertedColor : c;  return n; }];
//}
//void logNilTerminatedListOfColorsAndStrings ( const char*pretty, id colorsAndThings,...) 	{
//
//	__block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;
//	AZVA_Block theBlk = ^(id it) {								//			AZVA_Block sort   = ^(id it) {
//		[it ISKINDA:NSC.class] ? [colors addObject:[it copy]] :
//		[it ISKINDA:NSS.class] ? [words  addObject:[it copy ]] :
//		[it ISKINDA:NSA.class] ? [(NSA*)it each:^(id obj) {
//		   [obj ISKINDA:NSC.class] ? [colors addObject:[obj copy]] :
//		   [obj ISKINDA:NSS.class] ? [words  addObject:[obj copy]] :
//		   [obj respondsToString:@"stringValue"] ? [words addObject:[[obj stringValue]copy]] : nil;
//		}]:[ it respondsToString:@"stringValue"] ? [words addObject:[[ it stringValue]copy]] : nil;
//	};
//	azva_iterate_list(colorsAndThings, theBlk);
//	//	NSLog(@"colors:%ld:%@ words:%ld:%@", colors.count, colors, words.count, words);
//	//	NSA *colors, *words, *colorStringArray;  colorStringArray = colors1strings2(colorsAndThings); colors = colorStringArray[0]; words = colorStringArray[1];
//	LogEnv e =  AZLogEnv(); __block NSUI ctr = 0;
//	if (!colors.count) colors = @[WHITE].mutableCopy;
//	if (!words.count) {  printf( "WARNING, NO WORDS TO PRINT: %s", pretty); return; }
//	fprintf(stderr, "%s", //e != LogEnvXcodeColor ? [words componentsJoinedByString:@" "].UTF8String :
//
//	 [[words reduce:LOG_CALLER_VERBOSE ? @"LOGCOLORS: ":@"" withBlock:^NSS*(NSS *sum,NSS *o) {
//															NSC  *c 				= [colors normal:ctr];	ctr++;
//															o.logForeground 	= c.isDark ? [c colorWithBrightnessMultiplier:2]: c;
//															return [sum withString:o.colorLogString];
//														}]UTF8String]);
//}
//void WEBLOG (id format, ...) {
//
//	NSLogConsoleView* e = (NSLogConsoleView*)[NSLogConsole.sharedConsole webView];
//	[e logString: file:(char*)filename lineNumber:(int)lineNum];
//	
//}
//void _AZColorLog		( id color, const char *filename, int line, const char *funcName, id format, ...) {
//
//	if (!gPal) gPal = NSC.randomPalette;
//   va_list argList;  va_start(argList,format);	__block NSS *lineNum,*path,*mess,*func,*output; __block NSUI numberofspaces;
//
//	path	= $(@"[%@]", $UTF8(filename).lastPathComponent);
//	mess 	= [NSS stringWithFormat:format arguments:argList];
//
//		//:fl lineNumber:ln];setFakeStdin:$(@"%@%i%s%@",path, line, funcName, mess)];
//	AZLogEnv() == LogEnvXcodeColor ? ^{
//
//		path.logForeground 		= gPal [0];
//		lineNum						= $( @":%i ", line );
//		lineNum.logForeground 	= gPal [1];
//		numberofspaces		 		=      10;	//MIN(MAX((paddedString.length - concat.length), 2), 20);
//		func  						= [$UTF8(funcName) truncateInMiddleToCharacters:30];
//		func.logForeground 		= [gPal[2] darker];
//		//	output = $(@"%@%@", path.colorLogString, lineNum.colorLogString);   //, [NSS spaces:numberofspaces]);
//		NSC* messColor				= color 	? : gPal [4];
//		mess.logForeground      = messColor;
//		mess 							= mess.colorLogString ?: mess;  //  actual log message
//
//		output 						= [mess paddedTo:120];//withString:output];
//		output 						= [output withString:func.colorLogString];
//		//	[func containsAnyOf:@[@"///Color"]] ? @"" : func.colorLogString];	//	fflush(stdout);
//		fprintf(stderr, "%s\n", output.UTF8String);
//
//	}() : ^{ fprintf(stderr, "%s", $(/*@"[%@]:%i @"%s*/ @"%@\n",/* path, line, funcName,*/ mess).UTF8String); return; }();
////										XCODE_COLORS_ESCAPE @"fg140,140,140;"   @":%i"  XCODE_COLORS_RESET
////										XCODE_COLORS_ESCAPE @"fg109,0,40;"  @" %s "		 XCODE_COLORS_RESET
////										XCODE_COLORS_ESCAPE @"%@" "%@"XCODE_COLORS_RESET @"\n",
////										path,
////										line, funcName,
////										colorString,
////										mess)
////	 toLog.UTF8String);//
//	va_end(argList);
//} // ACTIVE NSLOG

/*
void _AZSimpleLog( const char *file, int lineNumber, const char *funcName, NSString *format, ... ) {
void LOGWARN(NSString *format,...) {
	va_list argList; va_start (argList, format);
	NSS* full = [NSS.alloc initWithFormat:format arguments:argList];
	NSLog(XCODE_COLORS_ESCAPE @"fg218,147,0;" "%@" XCODE_COLORS_RESET, full);
}
NSColor description
   void _AZSimpleLog( const char *file, int lineNumber, const char *funcName, NSString *format, ... ) {
		static NSA* colors;  colors = colors ?: NSC.randomPalette;
		static NSUI idx = 0;
		va_list   argList;
		va_start (argList, format);
		NSS *path   = [$UTF8(file) lastPathComponent];
		NSS *mess   = [NSString.alloc initWithFormat:format arguments:argList];
		NSS *toLog;
		char *xcode_colors = getenv(XCODE_COLORS);
		if (getenv(XCODE_COLORS) && (strcmp(xcode_colors, "YES") == 0))
		{
				//	NSS *justinfo = $(@"[%s]:%i",path.UTF8String, lineNumber);
				//	NSS *info   = [NSString stringWithFormat:@"word:%-11s rank:%u", [word UTF8String], rank];
				NSS *info   = $( XCODE_COLORS_ESCAPE @"fg82,82,82;" @" [%s]" XCODE_COLORS_RESET
														 XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i" XCODE_COLORS_RESET	, path.UTF8String, lineNumber);
				int max			 = 120;
				int cutTo			= 22;
				BOOL longer	 = mess.length > max;
				NSC *c = [colors normal:idx];
						c = c.isDark ? [c colorWithBrightnessMultiplier:1.5] : [c colorWithBrightnessMultiplier:.7];
				NSS *cs = $(@"%i,%i,%i",(int)(c.redComponent *255), (int)(c.greenComponent *255), (int)(c.blueComponent *255)); idx++;
				NSS* nextLine   = longer ? $(XCODE_COLORS_ESCAPE @"fg%@;" XCODE_COLORS_RESET @"\n\t%@\n", cs, [mess substringFromIndex:max - cutTo]) : @"\n";
				mess				= longer ? [mess substringToIndex:max - cutTo] : mess;
				int add = max - mess.length - cutTo;
				if (add > 0) {
						NSS *pad = [NSS.string stringByPaddingToLength:add withString:@" " startingAtIndex:0];
						info = [pad stringByAppendingString:info];
				}
				toLog   = $(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET @"%@%@", cs, mess, info, nextLine);
						// XcodeColors is installed and enabled!
				}
				else {
						NSS *info = $( XCODE_COLORS_ESCAPE @"fg82,82,82;" @"  [%s]" XCODE_COLORS_RESET
														  XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i" XCODE_COLORS_RESET	, path.UTF8String, lineNumber);
						toLog = $(@"%@ %s \n", info, mess.UTF8String);
		}

		fprintf ( stderr, "%s", toLog.UTF8String);//
		va_end  (argList);

		//	NSS *toLog  = $( XCODE_COLORS_RESET	@"%s" XCODE_COLORS_ESCAPE @"fg82,82,82;" @"%-70s[%s]" XCODE_COLORS_RESET
		//									XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i\n" XCODE_COLORS_RESET	,
		//									mess.UTF8String, "", path.UTF8String, lineNumber);

		//	NSLog(XCODE_COLORS_ESCAPE @"bg89,96,105;" @"Grey background" XCODE_COLORS_RESET);
		//	NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;"
		//			XCODE_COLORS_ESCAPE @"bg220,0,0;"
		//			@"Blue text on red background"
		//			XCODE_COLORS_RESET);

 */

@end
