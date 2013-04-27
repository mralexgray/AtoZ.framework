#import "AtoZFunctions.h"
#import "NSString+AtoZ.h"
#import "AtoZ.h"

JREnumDefine(AZQuadrant);
JREnumDefine(Color);
JROptionsDefine(AZAlign);

NSC* Clr(Color c) {
	return 	c == ColorNone 	? nil 		 :	c == ColorRed 	? RED		 	:	c == ColorOrange 	? ORANGE		 	:
				c == ColorYellow 	? YELLOW		 :	c == ColorGreen? GREEN		:	c == ColorBlue 	? BLUE			: nil;
}

NSG* GradForClr(Color c) {

		return 	c == ColorNone 	? nil 		 :	c == ColorRed 	? REDGRAD 	:	c == ColorOrange 	? ORANGEGRAD 	:
					c == ColorYellow 	? YELLOWGRAD :	c == ColorGreen ? GREENGRAD :	c == ColorBlue 	? BLUEGRAD 	:
					c == ColorPurple 	? PURPLEGRAD :	c == ColorGray ? GRAYGRAD 	:	nil;
}

CACONST * AZConst								 (CACONSTATTR attrb, NSS *rel) 														{
	return [CACONST constraintWithAttribute:attrb relativeTo:rel
								  attribute:attrb];
}
CACONST * AZConstraint						 (CACONSTATTR attrb, NSS *rel) 														{
	return AZConst(attrb, rel);
}
CACONST * AZConstScaleOff					 (CACONSTATTR attrb, NSS *rel, CGF scl, CGF off) 								{
	return [CACONST constraintWithAttribute:attrb relativeTo:rel attribute:attrb scale:scl offset:off];
}
CACONST * AZConstRelSuper					 (CACONSTATTR att) 																		{
	return [CACONST constraintWithAttribute:att relativeTo:@"superlayer" attribute:att];
}
CACONST * AZConstRelSuperScaleOff		 (CACONSTATTR attrb, CGF scl, CGF off) 											{
	return [CACONST constraintWithAttribute:attrb relativeTo:@"superlayer" attribute:attrb scale:scl offset:off];
}
CACONST * AZConstAttrRelNameAttrScaleOff(CACONSTATTR aOne, NSS *relName, CACONSTATTR aTwo, CGF scl, CGF off) 	{
	return [CAConstraint constraintWithAttribute:aOne relativeTo:relName attribute:aTwo scale:scl offset:off];
}

//typedef NSA*(^SeperateColorsThenStrings)(id colorsAndThings);
//AZVA_Block theBlk = ^(id thing) { [thing ISKINDA:NSC.class] ? [colors addObject:thing] : [words addObject:thing]; };
//
//SeperateColorsThenStrings colors1strings2 = ^(id colorsAndThings){
//
// __block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;
//	azva_iterate_list(colorsAndThings, theBlk);
//	return @[Block_copy(colors), Block_copy(words)];
//};
static NSA *gPal = nil;
#define LOG_CALLER_VERBOSE NO				   // Rediculous logging of calling method
#define LOG_CALLER_INFO	YES				  // Slighlty less annoying logging of calling method

NSA * rgbColorValues			 	 					(id color)	 							{
	__block float r, g, b;  __block NSC *x;									   //  printf("%s", $(@"%@",[color class]).UTF8String);

	if ([color ISKINDA:NSS.class]) x = [NSC colorWithName:color] ? : [NSC colorWithCSSRGB:color] ? : RED;

	ISA(color, NSC) ? ^{	 x = color;  x = x.isDark ? [x colorWithBrightnessOffset:2] : x;
		x = [x colorUsingColorSpace:NSColorSpace.genericRGBColorSpace];
		r = (x.redComponent * 255); g = (x.greenComponent * 255); b = (x.blueComponent * 255);					} ()

	: ISA(color, NSA) && [color count] == 3 ? ^{
		r = [color[0] integerValue]; g = [color[1] integerValue]; b = [color[2] integerValue];
	} () : nil;  return @[@(r), @(g), @(b)];
}
NSS * colorizeStringWithColors 					(NSS *string, id front, id back) {				//NSA *rgbs;
	if (front) [string setLogForeground:front];
	if (back)  [string  setLogBackground:back];
	return string;
}
NSS * colorizeStringWithColor	 					(NSS *string, id color) 			{
	return colorizeStringWithColors(string, color, nil);
}

/* Pass a variadic list of Colors, and Ovjects, in any order, TRMINATED BY NIL, abd it wiull use those colors to log those objects! */
NSA * COLORIZE(id colorsAndThings, ...) {
	__block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;

	AZVA_Block sort   = ^(id thing) { [thing ISKINDA:NSC.class] ? [colors addObject:thing] : [words addObject:thing]; };
	AZVA_Block theBlk = ^(id thing) { if ([thing ISKINDA:NSA.class])  [(NSA*)thing each:^(id obj) {   sort(thing);		}];
	else sort (thing);
	};

	azva_iterate_list(colorsAndThings, theBlk);   return [words nmap:^id (id o, NSUI i) { NSS *n = $(@"%@", o); NSC *c  = [colors normal:i];  n.logForeground = c.isDark ? c.invertedColor : c;  return n; }];
}
JREnum(LogEnv, LogEnvXcodeColor, LogEnvXcodeNOColor, LogEnvTTY);
BOOL inTTY() {   return [@(isatty(STDERR_FILENO))boolValue]; }

LogEnv AZLogEnv(void) {

	if (inTTY()) return LogEnvTTY;
	char *XcodeSaysColor	= getenv("XCODE_COLORS");
	return XcodeSaysColor != NULL && SameChar(XcodeSaysColor,"YES") ? LogEnvXcodeColor :  LogEnvXcodeNOColor;
}
void logNilTerminatedListOfColorsAndStrings ( const char*pretty, id colorsAndThings,...) {

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
	LogEnv e =  AZLogEnv(); __block NSUI ctr = 0;
	if (!colors.count) colors = @[WHITE].mutableCopy;
	if (!words.count) {  printf( "WARNING, NO WORDS TO PRINT: %s", pretty); return; }
	printf("%s", e != LogEnvXcodeColor ? [words componentsJoinedByString:@" "].UTF8String :

	 [[words reduce:LOG_CALLER_VERBOSE ? @"LOGCOLORS: ":@"" withBlock:^NSS*(NSS *sum,NSS *o) {
															NSC  *c 				= [colors normal:ctr];	ctr++;
															o.logForeground 	= c.isDark ? [c colorWithBrightnessMultiplier:2]: c;
															return [sum withString:o.colorLogString];
														}]UTF8String]);
}

// ACTIVE NSLOG
void _AZColorLog					 (id color, const char *filename, int line, const char *funcName, id format, ...) {

//	if (!gPal) gPal = [AZP instanceWithColorList:[NSC randomList]];//NSC.randomPalette.shuffeled
	if (!gPal) gPal = NSC.randomPalette;// [[ cw_mapArray:^id(NSC*o){ return o ;}] withMin:5 max:10];
	// .isBoring ? nil : o.darker

   va_list argList;  va_start(argList,format);	__block NSS *lineNum,*path,*mess,*func,*output; __block NSUI numberofspaces;

	path	= $(@"[%@]", $UTF8(filename).lastPathComponent);
	mess 	= [NSS stringWithFormat:format arguments:argList];
	NSLogConsoleView* e = (NSLogConsoleView*)[NSLogConsole.sharedConsole webView];
	[e logString:mess file:(char*)filename lineNumber:(int)lineNum];
		//:fl lineNumber:ln];setFakeStdin:$(@"%@%i%s%@",path, line, funcName, mess)];
	AZLogEnv() == LogEnvXcodeColor ? ^{

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
		fprintf(stdout, "%s\n", output.UTF8String);

	}() : ^{ printf("%s",$(@"[%@]:%i %s %@\n", path, line, funcName, mess).UTF8String); return; }();
//										XCODE_COLORS_ESCAPE @"fg140,140,140;"   @":%i"  XCODE_COLORS_RESET
//										XCODE_COLORS_ESCAPE @"fg109,0,40;"  @" %s "		 XCODE_COLORS_RESET
//										XCODE_COLORS_ESCAPE @"%@" "%@"XCODE_COLORS_RESET @"\n",
//										path,
//										line, funcName,
//										colorString,
//										mess)
//	 toLog.UTF8String);//
	va_end(argList);
}
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
/**	   if ( [AZSHAREDAPP delegate] ) {   id appD = [AZSHAREDAPP delegate];
				fprintf ( stderr, "%s", appD description.UTF8String );
				if ( [(NSObject*)appD respondsToString:@"stdOutView"]) {   NSTextView *tv = ((NSTextView*)[appD valueForKey:@"stdOutView"]);
				if (tv) [tv autoScrollText:toLog];   }   }

				$(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: args])	]
				const char *threadName = [[[NSThread currentThread] name] UTF8String];
 */
void pyRunWithArgsInDir				(NSS *script, 	NSA *args, NSS *working) 						{
	pyRunWithArgsInDirPythonPath(script, args, working, nil);
}
void runPythonAtPathWithArgs		(NSS *path, 	NSA *array) 										{
	pyRunWithArgs(path, array);
}
void pyRunWithArgs					(NSS *script, 	NSA *args) 											{
	pyRunWithArgsInDirPythonPath(script, args, nil, nil);
}
void pyRunWithArgsInDirPythonPath(NSS *_spriptP,NSA *_optArgs, NSS *working, NSS *pyPATH) {
	if (!Py_IsInitialized()) {
		NSLog(@"initializing Python"); Py_Initialize();
	}

	NSLog(@"args:  %@,  script:  %@", _optArgs, _spriptP);
//		static dispatch_once_t opoo;
//		dispatch_once(&opoo, ^{
//		Py_Initialize();

//		[[NSThread mainThread]performBlock:^{
	setenv("PYTHONPATH", [@"$PYTHONPATH:/mg/siprtmp/p2p-sip/src/app:/mg/siprtmp/p2p-sip/external:/mg/siprtmp/p2p-sip/src:/mg/siprtmp:." UTF8String], 1);
	NSLog(@"PYTHONPATH: %@", [NSS stringWithCString:getenv("PYTHONPATH") encoding:NSUTF8StringEncoding]);
	NSArray *args = _optArgs ? [@[_spriptP] arrayByAddingObjectsFromArray : _optArgs] : @[_spriptP];
	char **cargs;
	int x = [args createArgv:&cargs];																		  //cArrayFromNSArray(array);	////{ "weather.py", "10011" };
	PySys_SetArgv(args.count, cargs);																		  //argc, (char **)argv);

//			PyObject* PyFileObject = PyFile_FromString((char*)_spriptP.UTF8String, "r");
	PyRun_SimpleFile(PyFile_AsFile(PyFile_FromString((char *)_spriptP.UTF8String, "r")), _spriptP.UTF8String); //lastPathComponent.UTF8String);
//		}waitUntilDone:NO];
//	});
//	}

//	[AZSOQ addOperation:[PYO inDir:working withPath:script pythonPATH:pyPATH optArgs:argA]];
}

char** cArrayFromNSArray ( NSArray* array ){
   int i;
   int count = array.count + 1;
   char *cargs = (char*) malloc( count * sizeof(char*));
//   char *cargs = (char*) malloc(sizeof(char*) * (count + 1));
   for(i = 0; i < count - 1; i++) {		//cargs is a pointer to 4 pointers to char
	  NSString *s	  = array[i];	 //get a NSString
	  const char *cstr = [s UTF8String];// UTF8String; //get cstring
//	  int		  len = strlen(cstr); //get its length
//	  char  *cstr_copy = (char*) malloc(sizeof(char) * (len + 1));//allocate memory, + 1 for ending '\0'
//	  strcpy(cstr_copy, cstr);		 //make a copy
	  cargs[i] = &cstr; //cstr_copy;			//put the point in cargs
  }
  cargs[count] = NULL;
  return (char **)cargs;
}
/*
char** cArrayFromNSArray ( NSArray* array ){
   int i, count = array.count;
   char *cargs = (char*) malloc(sizeof(char*) * (count + 1));
   for(i = 0; i < count; i++) {		//cargs is a pointer to 4 pointers to char
	  NSString *s	  = array[i];	 //get a NSString
	  const char *cstr = s.UTF8String; //get cstring
	  int		  len = strlen(cstr); //get its length
	  char  *cstr_copy = (char*) malloc(sizeof(char) * (len + 1));//allocate memory, + 1 for ending '\0'
	  strcpy(cstr_copy, cstr);		 //make a copy
	  cargs[i] = cstr_copy;			//put the point in cargs
  }
  cargs[i] = NULL;
  return cargs;
}
/*
	NSString *path= @"/Volumes/2T/ServiceData/git/VideoIO/VideoIO/weather.py";
	NSString *path= @"/cgi/hostname.py";
	NSString *path= @"/cgi/repeater.py";
";
   NSString *py = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	NSLog(@"content: %@", py);
	PyRun_SimpleString([py UTF8String]);

		const char** args[array.count] =
		size_t t;
		strnlen(t,&cargs);
		cargs[array.count +1] = NULL;
	int argc;		char * argv[3];
	argv[0] = (char*)path.lastPathComponent.UTF8String;
	argv[1] = "10011";//"-m";
	argv[2] = "/tmp/targets.list";
	Py_SetProgramName(argv[0]);
//	Py_Initialize();
	PySys_SetArgv(argc, argv);
	[NSThread.mainThread performBlock:^{
		NSLog(@"Hello");
	} waitUntilDone:YES];
	} afterDelay:]
	const char *mainFilePathPtr = [path UTF8String];
	FILE *mainFile = fopen(mainFilePathPtr, "r");
	NSLog(@"running simple file... %s", mainFilePathPtr);
	int result = PyRun_SimpleFile(mainFile, (char *)[[path lastPathComponent] UTF8String]);
	Py_Finalize();

//		[NSException raise: NSInternalInconsistencyException format:

*/
@implementation CALayerNoHit
- (BOOL)containsPoint:(CGP)p  		{
	return FALSE;
}
@end
@implementation CAShapeLayerNoHit
- (BOOL)containsPoint:(CGP)p			{
	return FALSE;
}
@end
@implementation CATextLayerNoHit
- (BOOL)containsPoint:(CGP)p			{
	return FALSE;
}
@end
//  OR
@implementation CALayer (NoHit)
- (void)setNoHit:(BOOL)noHit 			{
	if (noHit) [self setAssociatedValue:@(YES) forKey:@"noHit" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}
- (BOOL)noHit 								{
	NSN * nohit = [self associatedValueForKey:@"noHit"];
	return nohit != nil && nohit.boolValue == YES ? YES : NO;
}
+ (void)load 								{
	[$ swizzleMethod:@selector(containsPoint:) with:@selector(swizzleContainsPoint:) in:self.class];
}
- (BOOL)swizzleContainsPoint:(CGP)p {
	BOOL fakedout =  [self noHit];
	BOOL forReals = [self swizzleContainsPoint:p];

	return fakedout == YES ? NO : [self swizzleContainsPoint:p];// NO ? NO : forReals;
}
@end


@implementation NSObject (AZLayerDelegate)
- (BOOL)boolForKey: (NSS*)key defaultValue:(BOOL)defaultValue 	{

	id val;
	if ([self hasPropertyForKVCKey:key]) {

		val = [self valueForKey:key];
		return  [val ISKINDA:NSSCLASS] || [val ISKINDA:NSN.class] ? [val boolValue] : defaultValue;
	}
	else return defaultValue;

}
- (BOOL)boolForKey: (NSS*)key											  	{
	return [self boolForKey:key defaultValue:YES];
}
- (void)toggleBoolForKey:(NSS *)key										{
	[self setBool:![self boolForKey:key defaultValue:NO] forKey:key];
	//[NSN numberWithBool:![self boolForKey:key defaultValue:YES]]
}
- (void)layerWasClicked:(CAL *)layer								   {
	[layer toggleBoolForKey:@"clicked"]; [layer setNeedsDisplay];
}
@end
@implementation CALayer (WasClicked)
- (void)wasClicked														 	{
	[self toggleBoolForKey:@"clicked"];  [self setNeedsDisplay];
}

@end

@implementation AZToggleClickTableCell
-   (id) target												{
	return self;
}
-  (SEL) action												{
	return @selector(tickPriority);
}
- (void) tickPriority										{
	NSUInteger val = [[self objectValue]unsignedIntegerValue];
//	((TodoItem*)[TodoList sharedInstance].items[[(NSTableView*)[self controlView]selectedRow]]).priority = @( val < 8 ? val + 1 : 0 );
}
- (void) drawWithFrame:(NSR)cF inView:(NSV *)cV  	{
	NSRectFillWithColor(cF, GRAY3); NSS *string = ((NSNumber *)self.objectValue).stringValue;
	NSD *attrs					  = @{ NSFontAttributeName: [NSF fontWithName:@"Lucida Grande Bold" size:cF.size.height - 10], NSForegroundColorAttributeName: WHITE };
	NSSZ stringSize = [string sizeWithAttributes:attrs];
	[string drawInRect:(NSRect) {NSMidX(cF) - stringSize.width / 2, cF.origin.y + 3, stringSize.width, stringSize.height }withAttributes:attrs];
}
@end
@implementation AZInstallStatusCell
- (void)drawWithFrame:(NSR)cF inView:(NSV *)cV  	{
	NSRectFillWithColor(cF, GREEN);
//	return st ==  (AZNeedsUpdate | AZInstalledNeedsUpdate)  ? [NSIMG systemIconNamed:@"Sync"] :
//	st ==   AZNotInstalled						  ? [NSIMG systemIconNamed:@"unsupported"] :
//	st ==   AZInstalled								 ? [NSIMG systemIconNamed:@"toolbardown"] :
//	[NSIMG systemIconNamed:@"userunknown"] ;
}
@end
@implementation AZColorTableCell
- (void)drawWithFrame:(NSRect)cF inView:(NSV *)cV 	{
	NSRectFillWithColor(cF, (NSC *)self.objectValue);
	if (self.isHighlighted) [[NSBP bezierPathWithRect:cF] strokeWithColor:RED andWidth:5 inside:cF];
}
@end
@implementation NSTableView (CustomDataCell)
- (void)setColumnWithIdentifier:(NSS *)identifier toClass:(Class)actionCellClass	{
	((NSTableColumn *)self.tableColumns[[self columnWithIdentifier:identifier]]).dataCell = actionCellClass.new;
}
@end
@implementation NSObject (KVONotifyBlock)
- (void)setValueForKey:(NSString *)key andNotifyInBlock:(updateKVCKeyBlock)block	{
	[self willChangeValueForKey:key];
	block();
	[self didChangeValueForKey:key];
}
@end
@implementation BoolToImageTransformer
+ (Class)transformedValueClass		  		{
	return [NSImage class];
}
+ (BOOL)allowsReverseTransformation 		{
	return YES;
}
- (id)transformedValue:(id)value	   		{
	return [value boolValue] ? [NSImage imageNamed:NSImageNameStatusAvailable] : ![value boolValue] ? [NSImage imageNamed:NSImageNameStatusUnavailable] : nil;
}
@end
@implementation AZInstallationStatusToImageTransformer
static NSIMG *installed, *notInstalled, *needsUpdate, *installedNeedsUpdate;
+ (void)initialize								{
	needsUpdate					 = [NSIMG systemIconNamed:@"Sync"];
	notInstalled					= [NSIMG systemIconNamed:@"unsupported"];
	installed							   = [NSIMG systemIconNamed:@"toolbardown"];
	installedNeedsUpdate	= [NSIMG systemIconNamed:@"userunknown"];
}
+ (Class)transformedValueClass				{
	return NSImage.class;
}
+ (BOOL)allowsReverseTransformation		   {
	return YES;
}
- (id)transformedValue:(id)value				{
	AZInstallationStatus st = [value unsignedIntegerValue];
	return st ==  AZNeedsUpdate ? needsUpdate :
		   st ==  AZNotInstalled ? notInstalled :
		   st ==  AZInstalled ? installed :
		   installedNeedsUpdate;
}
- (id)reverseTransformedValue:(id)v		 	{
	return [v isEqualTo:needsUpdate] ? @(AZNeedsUpdate) : [v isEqualTo:notInstalled] ? @(AZNotInstalled) :
		   [v isEqualTo:installed] ? @(AZInstalled) : @(AZInstalledNeedsUpdate);
}
@end
@implementation  NSColor (compare)
- (NSComparisonResult)compare:(NSC *)otherColor {
	// comparing the same type of animal, so sort by name
	//	if ([self kindOfAnimal] == [otherAnimal kindOfAnimal]) return [[self name] caseInsensitiveCompare:[otherAnimal name]];
	// we're comparing by kind of animal now. they will be sorted by the order in which you declared the types in your enum // (Dogs first, then Cats, Birds, Fish, etc)
	//	return [[NSNumber numberWithInt:[self kindOfAnimal]] compare:[[[NSNumber]] numberWithInt:[otherAnimal kindOfAnimal]]]; }
	return [@(self.hueComponent)compare : @(otherColor.hueComponent)];
}
@end

void			monitorTask(NSTask *task) {
	NSData *epipe = [[task.standardError fileHandleForReading] readDataToEndOfFile];
	char *buffer;
	if ([epipe length] > 0) {
		buffer = calloc([epipe length] + 1, sizeof(char));
		[epipe getBytes:buffer length:[epipe length]];
		LogAndReturn(@(buffer));
	}
	NSData *spipe   = [[task.standardOutput fileHandleForReading] readDataToEndOfFile];
	buffer = calloc([spipe length] + 1, sizeof(char));
	[spipe getBytes:buffer length:[spipe length]];
	NSLog(@"%@", @(buffer));
}

NSTSK *  launchMonitorAndReturnTask(NSTSK *t) {
	[t launch]; monitorTask(t);  return t;
}

//static inline BOOL isEmpty(id thing);	return	thing == nil || ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0)	|| ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0)	|| NO;	}

AZRange 	AZMakeRange			(NSI min,  NSI max) 		{
	return (AZRange) {min, max };
}
NSUI		AZIndexInRange		(NSI fake, AZRange rng) {
	return fake - rng.min;
}
NSI	 	AZNextSpotInRange	(NSI spot, AZRange rng) {
	return spot + 1 > rng.max ? rng.min : spot + 1;
}
NSI	 	AZPrevSpotInRange	(NSI spot, AZRange rng) {
	return spot - 1 < rng.min ? rng.max : spot - 1;
}
NSUI		AZSizeOfRange					 (AZRange rng) {
	return rng.max - rng.min;
}

//// SANDBOX
NSS * realHomeDirectory() {
	const char *home = getpwuid(getuid())->pw_dir;
	NSString *path = [[NSFileManager defaultManager]
					  stringWithFileSystemRepresentation:home
												  length:strlen(home)];
	static NSString *realHomeDirectory = nil;
	return realHomeDirectory = [[NSURL fileURLWithPath:path isDirectory:YES] path];
}
BOOL powerBox() {
	NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanCreateDirectories:YES];

	[openPanel beginWithCompletionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton) {
			for (NSURL * fileURL in [openPanel URLs]) {
				NSString *filename = [fileURL path];
				[[NSUserDefaults standardUserDefaults] setObject:filename forKey:@"PathToFolder"];

				NSError *error = nil;
				NSData *bookmark = [fileURL   bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope
									   includingResourceValuesForKeys:nil
														relativeToURL:nil
																error:&error];
				if (error) {
					NSLog(@"Error creating bookmark for URL (%@): %@", fileURL, error);
					[NSApp presentError:error];
				} else {
					[[NSUserDefaults standardUserDefaults] setObject:bookmark forKey:@"PathToFolder"];
					[[NSUserDefaults standardUserDefaults] synchronize];
				}
				break;
			}
		}
	}];

	NSError *error = nil;
	NSData *bookmark = [[NSUserDefaults standardUserDefaults] objectForKey:@"PathToFolder"];
	NSURL *bookmarkedURL = [NSURL URLByResolvingBookmarkData:bookmark options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale:nil error:&error];
	BOOL ok = [bookmarkedURL startAccessingSecurityScopedResource];
	NSLog(@"Accessed ok: %d %@", ok, [bookmarkedURL relativePath]);
	return ok;
}
NSS * googleSearchFor(NSS *string) {
	static NSS *wan = nil;
	if (!wan) wan = WANIP();
	// query holds the search term
	NSS *theQuery = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSS *Q = $(@"%@%@", $(@"https://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=1&userip=%@&q=", wan), theQuery);
//	LOG_EXPR(Q);
	NSURL *url = [NSURL URLWithString:Q];
	// Create a request object using the URL.
	NSURLREQ *request = [NSURLREQ requestWithURL:url];
	// Prepare for the response back from the server
	NSHTTPURLResponse *response = nil;			  NSError *error = nil;
	[[NSThread mainThread]performBlock:^{
	} waitUntilDone:YES];
//	[NSURLConnection sendAsynchronousRequest:request queue: completionHandler]
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONWritingPrettyPrinted error:&error];
	if (error) NSLog(@"error: %@", error);
	id valueD = [dictionary recursiveObjectForKey:@"content"];
	if ([valueD ISKINDA:[NSString class]]) return [(NSS *)valueD stripHtml];
	else return nil;	//  valueD[@"content"];
//	NSLog(@"result: %@", content);
//	return content;
}
NSS * WANIP() {
	NSERR *error		= nil;  NSScanner *theScanner; NSS *externalIP, *text, *noway = @"External IP N/A";
	NSURL *iPURL	   = $URL(@"http://www.dyndns.org/cgi-bin/check_ip.cgi");
	NSS *theIpHtml	   = [NSS stringWithContentsOfURL:iPURL encoding:NSUTF8StringEncoding error:&error];
	if (error) return noway;
	theScanner		  = [NSScanner scannerWithString:theIpHtml];
	while (!theScanner.isAtEnd) {
		[theScanner scanUpToString:@"<" intoString:NULL];					// find start of tag
		[theScanner scanUpToString:@">" intoString:&text];				   // find end of tag
		// replace the found tag with a space  (you can filter multi-spaces out later if you wish)
		theIpHtml		= [theIpHtml stringByReplacingOccurrencesOfString:$(@"%@>", text) withString:@" "];
		NSA *ipItmsArr		  = theIpHtml.words;
		NSUI aIdx	= [ipItmsArr indexOfObject:@"Address:"];   externalIP  = ipItmsArr [ ++aIdx ];
	}
	return externalIP ? externalIP : noway;
}
char * GetPrivateIP() {
	struct hostent *h;
	char hostname[100];
	gethostname(hostname, 99);
	if ((h = gethostbyname(hostname)) == NULL) {
		perror("Error: "); return "(Error locating Private IP Address)";
	}
	return inet_ntoa(*((struct in_addr *)h->h_addr));
}
/** Converts a raw IPv4 address to an NSString in dotted-quad notation */
NSS * StringFromIPv4Addr(UInt32 ipv4Addr) {
	return ipv4Addr == 0 ? nil : ^{											   const UInt8 *addrBytes = (const UInt8 *)&ipv4Addr;
																				  return $(@"%lu,%lu.%lu.%lu", (NSUI)addrBytes[0],		(NSUI)addrBytes[1],
																						   (NSUI)addrBytes[2],	 (NSUI)addrBytes[3]);	} ();
}
// Private IP address ranges. See RFC 3330.
static const struct { unsigned int mask, value; }
kPrivateRanges[] = {
	{ 0xFF000000, 0x00000000				   }, //   0.x.x.x (hosts on "this" network)
	{ 0xFF000000, 0x0A000000				   }, //  10.x.x.x (private address range)
	{ 0xFF000000, 0x7F000000				   }, // 127.x.x.x (loopback)
	{ 0xFFFF0000, 0xA9FE0000				   }, // 169.254.x.x (link-local self-configured addresses)
	{ 0xFFF00000, 0xAC100000				   }, // 172.(16-31).x.x (private address range)
	{ 0xFFFF0000, 0xC0A80000				   }, // 192.168.x.x (private address range)
	{ 0,		  0							}
};
BOOL isIPlocal(UInt32 address) {
	int i;
	for (i = 0; kPrivateRanges[i].mask; i++) {
		if ( (address & kPrivateRanges[i].mask) == kPrivateRanges[i].value) return YES;
	}
	return NO;
}

//+ (NSString*) findPublicAddress
//{
//	// To find our public IP address, open a PortMapper with no port or protocols.
//	// This will cause the DNSService to look up our public address without creating a mapping.
//	NSString *addr;
//	PortMapper *mapper = [[self alloc] initWithPort: 0];
//	mapper.mapTCP = mapper.mapUDP = NO;
//	if( [mapper waitTillOpened] )
//		addr = mapper.publicAddress;
//	[mapper close];
//	[mapper release];
//	return addr;
//}


NSCharacterSet * _GetCachedCharacterSet(CharacterSet set) {
	static NSCharacterSet *cache[kNumCharacterSets] = { 0 };
	if (cache[set] == nil) {
		OSSpinLockLock(&_staticSpinLock);
		if (cache[set] == nil) {
			switch (set) {
				case kCharacterSet_Newline:
					cache[set] = NSCharacterSet.newlineCharacterSet;
					break;
				case kCharacterSet_WhitespaceAndNewline:
					cache[set] = NSCharacterSet.whitespaceAndNewlineCharacterSet;
					break;
				case kCharacterSet_WhitespaceAndNewline_Inverted:
					cache[set] = [NSCharacterSet.whitespaceAndNewlineCharacterSet invertedSet];
					break;
				case kCharacterSet_UppercaseLetters:
					cache[set] = NSCharacterSet.uppercaseLetterCharacterSet;
					break;
				case kCharacterSet_DecimalDigits_Inverted:
					cache[set] = [NSCharacterSet.decimalDigitCharacterSet invertedSet];
					break;
				case kCharacterSet_WordBoundaries:
					cache[set] = [[NSMutableCharacterSet alloc] init];
					[(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					[(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet punctuationCharacterSet]];
					[(NSMutableCharacterSet *)cache[set] removeCharactersInString : @"-"];
					break;
				case kCharacterSet_SentenceBoundaries:
					cache[set] = [[NSMutableCharacterSet alloc] init];
					[(NSMutableCharacterSet *)cache[set] addCharactersInString : @".?!"];
					break;
				case kCharacterSet_SentenceBoundariesAndNewlineCharacter:
					cache[set] = [[NSMutableCharacterSet alloc] init];
					[(NSMutableCharacterSet *)cache[set] formUnionWithCharacterSet :[NSCharacterSet newlineCharacterSet]];
					[(NSMutableCharacterSet *)cache[set] addCharactersInString : @".?!"];
					break;
				case kNumCharacterSets:
					break;
			}
		}
		OSSpinLockUnlock(&_staticSpinLock);
	}
	return cache[set];
}

OSStatus HotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData) {
	NSLog(@"HotKeyHandler theEvent:%@ ", theEvent);
	[AtoZ playRandomSound];
	return noErr;
}

CIFilter * CIFilterDefaultNamed(NSString *name) {
	CIFilter *x = [CIFilter filterWithName:name];
	[x setDefaults];
	return x;
}

CGFloat AZDeviceScreenScale(void) {
#if TARGET_OS_IPHONE
	return [UIScreen mainScreen].scale;
#else
	return NSScreen.mainScreen.backingScaleFactor;
#endif
}

// Check if the "thing" pass'd is empty
BOOL isEmpty(id thing) {
	return thing == nil
		   ? : [thing ISKINDA:[NSNull class]]
		   ? : [thing respondsToString:@"length"] && ![(NSData *)thing length]
		   ? : [thing respondsToString:@"count" ] && ![(NSA *)thing count]
		   ? : NO;
}

BOOL areSame(id a, id b) {
	return a == b
		   ? : [a ISKINDA:[NSS class]] && [b ISKINDA:[NSS class]] && [a isEqualToString:b]
//		?: [thing respondsToString:@"length"] && ![(NSData*)thing length]
//		?: [thing respondsToString:@"count" ] && ![(NSA*)thing	 count]
		   ? : NO;
}

BOOL areSameThenDo(id a, id b, VoidBlock doBlock) {
	BOOL same = areSame(a, b); if (same) doBlock(); return same;
}

BOOL SameChar		(const char *a, const char *b) {
	return [$(@"%s", a) isEqualToString:$(@"%s", b)];
}
BOOL SameString	(id a, id b) {
	return [$(@"%@", a) isEqualToString:$(@"%@", b)];
}


static NSString *humanReadableFScriptTypeDescriptionFromEncodedObjCType(const char *ptr)
{
  while (*ptr == 'r' || *ptr == 'n' || *ptr == 'N' || *ptr == 'o' || *ptr == 'O' || *ptr == 'R' || *ptr == 'V')
    ptr++;

  if      (strcmp(ptr,@encode(id))                  == 0) return @"";
  else if (strcmp(ptr,@encode(char))                == 0) return @"";
  else if (strcmp(ptr,@encode(int))                 == 0) return @"int";
  else if (strcmp(ptr,@encode(short))               == 0) return @"short";
  else if (strcmp(ptr,@encode(long))                == 0) return @"long";
  else if (strcmp(ptr,@encode(long long))           == 0) return @"long long";
  else if (strcmp(ptr,@encode(unsigned char))       == 0) return @"unsigned char";
  else if (strcmp(ptr,@encode(unsigned short))      == 0) return @"unsigned short";
  else if (strcmp(ptr,@encode(unsigned int))        == 0) return @"unsigned int";
  else if (strcmp(ptr,@encode(unsigned long))       == 0) return @"unsigned long";
  else if (strcmp(ptr,@encode(unsigned long long))  == 0) return @"unsigned long long";
  else if (strcmp(ptr,@encode(float))               == 0) return @"float";
  else if (strcmp(ptr,@encode(double))              == 0) return @"double";
  else if (strcmp(ptr,@encode(char *))              == 0) return @"pointer";
  else if (strcmp(ptr,@encode(SEL))                 == 0) return @"SEL";
  else if (strcmp(ptr,@encode(Class))               == 0) return @"Class";
  else if (strcmp(ptr,@encode(NSRange))             == 0) return @"NSRange";
  else if (strcmp(ptr,@encode(NSPoint))             == 0) return @"NSPoint";
  else if (strcmp(ptr,@encode(NSSize))              == 0) return @"NSSize";
  else if (strcmp(ptr,@encode(NSRect))              == 0) return @"NSRect";
  else if (strcmp(ptr,@encode(CGPoint))             == 0) return @"CGPoint";
  else if (strcmp(ptr,@encode(CGSize))              == 0) return @"CGSize";
  else if (strcmp(ptr,@encode(CGRect))              == 0) return @"CGRect";
  else if (strcmp(ptr,@encode(CGAffineTransform))   == 0) return @"CGAffineTransform";
  else if (strcmp(ptr,@encode(_Bool))               == 0) return @"boolean";
  else if (*ptr == '{')
  {
    NSMutableString *structName = [NSMutableString string];
    ptr++;
    while (isalnum(*ptr) || *ptr == '_')
    {
      [structName appendString:[[[NSString alloc] initWithBytes:ptr length:1 encoding:NSASCIIStringEncoding] autorelease]];
      ptr++;
    }
    if (*ptr == '=' && ![structName isEqualToString:@""])
      return [@"struct " stringByAppendingString:structName];
    else 
      return @"";
  }
  else if (*ptr == '^')
  {
    NSString *pointed = humanReadableFScriptTypeDescriptionFromEncodedObjCType(++ptr);
    if ([pointed isEqualToString:@""])
      return @"pointer";
    else
      return [@"pointer to " stringByAppendingString:pointed];
  }
  else                                                    return @"";  
}

static NSString *FScriptObjectTemplateForEncodedObjCType(const char *ptr)
{
  while (*ptr == 'r' || *ptr == 'n' || *ptr == 'N' || *ptr == 'o' || *ptr == 'O' || *ptr == 'R' || *ptr == 'V')
    ptr++;

/*  if      (strcmp(ptr,@encode(id))                  == 0) return @"";
  else if (strcmp(ptr,@encode(char))                == 0) return @"";
  else if (strcmp(ptr,@encode(int))                 == 0) return @"";
  else if (strcmp(ptr,@encode(short))               == 0) return @"";
  else if (strcmp(ptr,@encode(long))                == 0) return @"";
  else if (strcmp(ptr,@encode(long long))           == 0) return @"";
  else if (strcmp(ptr,@encode(unsigned char))       == 0) return @"";
  else if (strcmp(ptr,@encode(unsigned short))      == 0) return @"";
  else if (strcmp(ptr,@encode(unsigned int))        == 0) return @"";
  else if (strcmp(ptr,@encode(unsigned long))       == 0) return @"";
  else if (strcmp(ptr,@encode(unsigned long long))  == 0) return @"";
  else if (strcmp(ptr,@encode(float))               == 0) return @"";
  else if (strcmp(ptr,@encode(double))              == 0) return @"";
  else if (strcmp(ptr,@encode(char *))              == 0) return @"";
#warning 64BIT: Inspect use of @encode
  else*/ if (strcmp(ptr,@encode(SEL))                 == 0) return @"#selector";
  //else if (strcmp(ptr,@encode(Class))               == 0) return @"";
  //else if (*ptr == '^')                                   return @"";
  else if (strcmp(ptr,@encode(NSRange))             == 0) return @"NSValue rangeWithLocation:0 length:0";
  else if (strcmp(ptr,@encode(NSPoint))             == 0) return @"0<>0";
  else if (strcmp(ptr,@encode(NSSize))              == 0) return @"NSValue sizeWithWidth:0 height:0";
  else if (strcmp(ptr,@encode(NSRect))              == 0) return @"0<>0 extent:0<>0";
  else if (strcmp(ptr,@encode(CGPoint))             == 0) return @"0<>0";
  else if (strcmp(ptr,@encode(CGSize))              == 0) return @"NSValue sizeWithWidth:0 height:0";
  else if (strcmp(ptr,@encode(CGRect))              == 0) return @"0<>0 extent:0<>0";
  //else if (strcmp(ptr,@encode(_Bool))               == 0) return @"";
  else                                                    return @"";  
}



// Key to AZString
NSString * AZToStringFromTypeAndValue(const char *typeCode, void *value) {
				//  Compare
	return  SameChar( typeCode, @encode(   NSP )) ? AZStringFromPoint(*(NSPoint *)value)
		   : SameChar( typeCode, @encode( NSRNG )) ? NSStringFromRange(*(NSRNG *)value)
		   : SameChar( typeCode, @encode(  NSSZ )) ? NSStringFromSize(*(NSSize *)value)
		   : SameChar( typeCode, @encode(   NSR )) ? AZStringFromRect(*(NSRect *)value)
		   : SameChar( typeCode, @encode(  BOOL )) ? StringFromBOOL(*(BOOL *)value)
		   : SameChar( typeCode, @encode( AZPOS )) ? stringForPosition(*(AZWindowPosition *)value)
		   : SameChar( typeCode, @encode(   CGF )) ? $(@"%f",					   *((CGF *)value))
		   : SameChar( typeCode, @encode(  NSUI )) ? $(@"%lu",					  *((NSUI *)value))
		   : SameChar( typeCode, @encode(   int )) ? $(@"%d",					   *((int *)value))
		   : SameChar( typeCode, @encode(   NSI )) ? $(@"%ld",					  *((NSUI *)value))
		   : SameChar( typeCode, @encode(  CGCR )) ? [@"cg" withString : [[NSC colorWithCGColor:*((CGCR *)value)]nameOfColor]]
		   :			   SameChar(typeCode, @encode(id)) ? $(@"%@", (__bridge NSObject *)value)
		   : nil;
}

NSString * bitString(NSUInteger mask) {
	NSString *str = @"";									 // Prepend "0" or "1", depending on the bit
	for (NSUInteger i = 0; i < 8; i++) {
		str = [NSString stringWithFormat:@"%@%@", mask & 1 ? @"1":@"0", str];  mask >>= 1;
	}
	return str;
}

//int triple(int) = ^(int number) {
//	return number * 3;
//};

id LogStackAndReturn(id toLog) {
	[NSThread stackTraceAtIndex:2];
//	AZLOG([NSThread  callStackSymbols]);

	AZLOG($(@"Log+Return: %@", toLog));
	return toLog;
}

id LogAndReturn(id toLog) {
	AZLOG($(@"Log+Return: %@", toLog));
	return toLog;
}

id LogAndReturnWithCaller(id toLog, SEL caller) {
	AZLOG($(@"Caller:%@  Log+Return: %@", NSStringFromSelector(caller), toLog));
	return toLog;
}

//id LogKeyAndReturn(id toLog, NSString key) {
//	AZLOG([toLog valueForKey:<#(NSString *)#>);
//	return toLog;
//};

//id (^logAndReturn)(id) = ^(id toLog) {
//	AZLOG(toLog); return toLog;
//};


//NSString * stringForPosition(AZWindowPosition enumVal) {
//	return [[NSArray alloc]initWithObjects:AZWindowPositionTypeArray][enumVal];
//}

NSString * AZStringFromPoint(NSP p) {
	return $(@"[x.%0.f y.%0.f]", p.x, p.y);
}

NSString * AZStringFromRect(NSRect rect) {
//	NSString *demo=[NSS.alloc initWithData:[NSData dataWithBytes:"✖" length:0] encoding:NSUnicodeStringEncoding];
	return $(@"[x.%0.f y.%0.f [%0.f x %0.f]]", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

//static void glossInterpolation(void *info, const float *input);
//float *output);

//static
void glossInterpolation(void *info, const CGFloat *input, CGFloat *output);
//static void glossInterpolation(void *info, const CGFloat *input);

void perceptualCausticColorForColor(CGFloat *inputComponents, CGFloat *outputComponents);
extern void DrawGlossGradient(CGContextRef context, NSColor *color, NSRect inRect);
extern void DrawLabelAtCenterPoint(NSString *string, NSPoint center);

void NSRectFillWithColor(NSRect rect, NSColor *color) {
	[color set];
	NSRectFill(rect);
}

NSPoint getCenter(NSView *view) {
	return NSMakePoint(floorf(view.bounds.origin.x + (view.bounds.size.width / 2)),
					   floorf(view.bounds.origin.y + (view.bounds.size.height / 2)));
}

//void _AZSimpleLog(const char *file, int lineNumber, const char *funcName, NSString *format,...){
// va_list argList;
// va_start (argList, format);
// NSString *path = [[NSString stringWithUTF8String:file] lastPathComponent];
// NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
// fprintf (stderr, "[%s]:%i %s \n", [path UTF8String], lineNumber, [message UTF8String]);
// va_end  (argList);
// //	const char *threadName = [[[NSThread currentThread] name] UTF8String];
//}

//#define WIDTH 13600
//#define HEIGHT 100
//#define STEP 100

//void drawLines(BOOL horizontal, CGFloat from, CGFloat to, CGFloat step, NSRect bounds) {
//{
//	for (CGFloat i = from; i <= to; i += step) {
//		NSRect rect;
//		if (horizontal) rect = NSMakeRect (bounds.origin.x - x + i, bounds.origin.y + bounds.size.height - 1 + y - HEIGHT, 1, HEIGHT + 1);
//		 else rect = NSMakeRect(bounds.origin.x - x, bounds.origin.y + bounds.size.height - 1 + y - i, WIDTH + 1, 1);
//
//		NSString *string = [NSString stringWithFormat:@"%i",(int) (i/STEP)];
//			//		NSRect bounds = self.bounds;
//		[string drawAtPoint:AGCenterOfRect(bounds) withAttributes:nil];
//		 // NSMakePoint(10, bounds.origin.y + bounds.size.height - 20)
//		[NSBezierPath setDefaultLineWidth:5];
//		[NSBezierPath set
//		[RANDOMCOLOR set];
//		[NSBezierPath strokeRect:rect];
//		[NSBezierPath fillRect:rect];
//	}
//}

extern CGFloat randomComponent(void) {
	return (CGFloat)(random() / (CGFloat)INT_MAX);
}

NSString * prettyFloat(CGFloat f) {
	if (f == 0) {
		return @"0";
	} else if (f == 1) {
		return @"1";
	} else { return [NSString stringWithFormat:@"%.1f", f]; }
}

NSString * kindaPrettyFloat(CGFloat f) {
	if (f == 0) {
		return @"0";
	} else if (f == 1) {
		return @"1";
	} else { return [NSString stringWithFormat:@"%.3f", f]; }
}

NSString * StringFromCATransform3D(CATransform3D transform) {
	// format: [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]

	return CATransform3DIsIdentity(transform)
		   ? @"CATransform3DIdentity"
		   : [NSString stringWithFormat:@"[\n%@\t%@\t%@\t%@;\n%@\t%@\t%@\t%@;\n%@\t%@\t%@\t%@;\n%@\t%@\t%@\t%@]",
			  kindaPrettyFloat(transform.m11),
			  kindaPrettyFloat(transform.m12),
			  kindaPrettyFloat(transform.m13),
			  kindaPrettyFloat(transform.m14),
			  kindaPrettyFloat(transform.m21),
			  kindaPrettyFloat(transform.m22),
			  kindaPrettyFloat(transform.m23),
			  kindaPrettyFloat(transform.m24),
			  kindaPrettyFloat(transform.m31),
			  kindaPrettyFloat(transform.m32),
			  kindaPrettyFloat(transform.m33),
			  kindaPrettyFloat(transform.m34),
			  kindaPrettyFloat(transform.m41),
			  kindaPrettyFloat(transform.m42),
			  kindaPrettyFloat(transform.m43),
			  kindaPrettyFloat(transform.m44)
		   ];
}

NSI AZNormalizedNumberGreaterThan(NSI number, NSI min) {
	return number > min ? number : min;
}

NSUInteger normalizedNumberLessThan(id number, NSUInteger max) {
	NSUInteger u = [number integerValue];
	u = u <= max ? u : max;
	return u;
}

BOOL isEven(NSI aNumber) {
	return (aNumber % 2) == 0;
}

BOOL isOdd(NSI aNumber) {
	return (aNumber % 2) != 0;
}

//static inline
//BOOL isEmpty(id thing){
//	return	thing == nil
//	|| ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0)
//	|| ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0)
//	|| NO;
//}
BOOL IsEmpty(id obj) {
	return obj == nil
		   ||	  (NSNull *)obj == [NSNull null]
		   ||	  ([obj respondsToSelector:@selector(length)] && [obj length] == 0)
		   ||	  ([obj respondsToSelector:@selector(count)]	  && [obj count]  == 0);
}

extern CGFloat percent(CGFloat val) {
	return val > 5 && val < 100 ? val / 100 : val > 1 ? 1 : val < 0 ? 0 : val;
}

NSArray * ApplicationPathsInDirectory(NSString *searchPath) {
	__block BOOL isDir;
	__block NSMA *u = [NSMA array];
	[[AZFILEMANAGER contentsOfDirectoryAtPath:searchPath error:nil]az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[AZFILEMANAGER changeCurrentDirectoryPath:searchPath];
		if ([AZFILEMANAGER fileExistsAtPath:obj isDirectory:&isDir] && isDir) {
			NSString *fullpath = [searchPath stringByAppendingPathComponent:obj];
			if ([[obj pathExtension] isEqualToString:@"app"]) [u addObject:fullpath];
//			else ApplicationsInDirectory(fullpath, applications);
		}
	}];
	return u.copy;
}

extern void ApplicationsInDirectory(NSString *searchPath, NSMutableArray *applications) {
	__block BOOL isDir;
	[[AZFILEMANAGER contentsOfDirectoryAtPath:searchPath error:nil]az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[AZFILEMANAGER changeCurrentDirectoryPath:searchPath];
		if ([AZFILEMANAGER fileExistsAtPath:obj isDirectory:&isDir] && isDir) {
			NSString *fullpath = [searchPath stringByAppendingPathComponent:obj];
			if ([[obj pathExtension] isEqualToString:@"app"]) [applications addObject:fullpath];
			else ApplicationsInDirectory(fullpath, applications);
		}
	}];
}

//	BOOL isDir;
//	NSFileManager *manager = [NSFileManager defaultManager];
//	NSArray *files = [manager contentsOfDirectoryAtPath:searchPath error:nil];
//
//	NSEnumerator *fileEnum = [files objectEnumerator]; NSString *file;
//	while (file = [fileEnum nextObject]) {
//		[manager changeCurrentDirectoryPath:searchPath];
//		if ([manager fileExistsAtPath:file isDirectory:&isDir] && isDir) {
//			NSString *fullpath = [searchPath stringByAppendingPathComponent:file];
//			if ([[file pathExtension] isEqualToString:@"app"]) [applications addObject:fullpath];
//			else ApplicationsInDirectory(fullpath, applications);
//		}
//	}
//}
//void WithAutoreleasePool(BasicBlock block) {
//	@autoreleasepool {
//		block();
//}	}

//USAGE		//for(id obj in array) WithAutoreleasePool(^{   [self createLotsOfTemporaryObjectsWith:obj];  });

NSString *const AZMouseNotification = @"okWindowFadeOutNow";

BOOL isPathAccessible(NSString *path, SandBox mode) {
	return access([path UTF8String], mode) == 0;
}

static CGEventRef myEventTapCallback(CGEventTapProxy proxy,  CGEventType type,	   CGEventRef event,	   void *refcon) {
	// If we would get different kind of events, we can distinguish them by the variable "type", but we know we only get mouse moved events
	CGPoint mouseLocation = CGEventGetLocation(event);
	printf("Mouse is at x/y: %u/%u\n", (unsigned int)mouseLocation.x,  (unsigned int)mouseLocation.y);
	[[ NSNotificationCenter defaultCenter] postNotificationName:@"mouseMoved" object:nil];

	// Pass on the event, we must not modify it anyway, we are a listener
	return event;
}

void trackMouse() {
	CGEventMask emask;	  CFMachPortRef myEvTap;  CFRunLoopSourceRef evTapRLSrc;
	// We only want one kind of event at the moment: The mouse has moved
	emask = CGEventMaskBit(kCGEventMouseMoved);										 // Create the Tap
	myEvTap = CGEventTapCreate(kCGSessionEventTap,									  // Catch all events for current user session
							   kCGTailAppendEventTap,								   // Append to end of EventTap list
							   kCGEventTapOptionListenOnly,							 // We only listen, we don't modify
							   emask,  &myEventTapCallback, NULL);					  // We need no extra data in the callback
	evTapRLSrc = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, myEvTap, 0);		// Create a RunLoop Source for it
	CFRunLoopAddSource(CFRunLoopGetCurrent(), evTapRLSrc, kCFRunLoopDefaultMode);	   // Add the source to the current RunLoop
	CFRunLoopRun();																	 // Keep the RunLoop running forever
}

//based off http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
//
static BOOL TypeCodeIsCharArray(const char *typeCode) {
	size_t len = strlen(typeCode);
	if (len <= 2) return NO;
	size_t lastCharOffset = len - 1;
	size_t secondToLastCharOffset = lastCharOffset - 1;

	BOOL isCharArray = typeCode[0] == '[' &&
		typeCode[secondToLastCharOffset] == 'c' && typeCode[lastCharOffset] == ']';
	for (int i = 1; i < secondToLastCharOffset; i++) {
		isCharArray = isCharArray && isdigit(typeCode[i]);
	}
	return isCharArray;
}

//since BOOL is #defined as a signed char, we treat the value as
//a BOOL if it is exactly YES or NO, and a char otherwise.
static NSString * VTPGStringFromBoolOrCharValue(BOOL boolOrCharvalue) {
	if (boolOrCharvalue == YES) return @"YES";
	if (boolOrCharvalue == NO) return @"NO";
	return [NSString stringWithFormat:@"'%c'", boolOrCharvalue];
}

static NSString * VTPGStringFromFourCharCodeOrUnsignedInt32(FourCharCode fourcc) {
	return [NSString stringWithFormat:@"%u ('%c%c%c%c')",
			fourcc,
			(fourcc >> 24) & 0xFF,
			(fourcc >> 16) & 0xFF,
			(fourcc >> 8) & 0xFF,
			fourcc & 0xFF];
}

static NSString * StringFromNSDecimalWithCurrentLocal(NSDecimal dcm) {
	return NSDecimalString(&dcm, [NSLocale currentLocale]);
}

NSString * VTPG_DDToStringFromTypeAndValue(const char *typeCode, void *value) {
#define IF_TYPE_MATCHES_INTERPRET_WITH(typeToMatch, func) \
	if (strcmp(typeCode, @encode(typeToMatch)) == 0) \
		return (func)(*(typeToMatch *)value)

#if	 TARGET_OS_IPHONE
	IF_TYPE_MATCHES_INTERPRET_WITH(CGPoint, NSStringFromCGPoint);
	IF_TYPE_MATCHES_INTERPRET_WITH(CGSize, NSStringFromCGSize);
	IF_TYPE_MATCHES_INTERPRET_WITH(CGRect, NSStringFromCGRect);
#else
	IF_TYPE_MATCHES_INTERPRET_WITH(NSPoint, NSStringFromPoint);
	IF_TYPE_MATCHES_INTERPRET_WITH(NSSize, NSStringFromSize);
	IF_TYPE_MATCHES_INTERPRET_WITH(NSRect, NSStringFromRect);
#endif
	IF_TYPE_MATCHES_INTERPRET_WITH(NSRange, NSStringFromRange);
	IF_TYPE_MATCHES_INTERPRET_WITH(Class, NSStringFromClass);
	IF_TYPE_MATCHES_INTERPRET_WITH(SEL, NSStringFromSelector);
	IF_TYPE_MATCHES_INTERPRET_WITH(BOOL, VTPGStringFromBoolOrCharValue);
	IF_TYPE_MATCHES_INTERPRET_WITH(NSDecimal, StringFromNSDecimalWithCurrentLocal);

#define IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(typeToMatch, formatString) \
	if (strcmp(typeCode, @encode(typeToMatch)) == 0) \
		return [NSString stringWithFormat:(formatString), (*(typeToMatch *)value)]


	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(CFStringRef, @"%@");	//CFStringRef is toll-free bridged to NSString*
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(CFArrayRef, @"%@");	//CFArrayRef is toll-free bridged to NSArray*
	IF_TYPE_MATCHES_INTERPRET_WITH(FourCharCode, VTPGStringFromFourCharCodeOrUnsignedInt32);
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long long, @"%lld");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned long long, @"%llu");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(float, @"%f");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(double, @"%f");
#if __has_feature(objc_arc)
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(__unsafe_unretained id, @"%@");
#else /* not __has_feature(objc_arc) */
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(id, @"%@");
#endif
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(short, @"%hi");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned short, @"%hu");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(int, @"%i");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned, @"%u");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long, @"%li");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long double, @"%Lf");	//WARNING on older versions of OS X, @encode(long double) == @encode(double)

	//C-strings
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(char *, @"%s");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(const char *, @"%s");
	if (TypeCodeIsCharArray(typeCode)) return [NSString stringWithFormat:@"%s", (char *)value];

	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(void *, @"(void*)%p");

	//This is a hack to print out CLLocationCoordinate2D, without needing to #import <CoreLocation/CoreLocation.h>
	//A CLLocationCoordinate2D is a struct made up of 2 doubles.
	//We detect it by hard-coding the result of @encode(CLLocationCoordinate2D).
	//We get at the fields by treating it like an array of doubles, which it is identical to in memory.
	if (strcmp(typeCode, "{?=dd}") == 0) //@encode(CLLocationCoordinate2D)
		return [NSString stringWithFormat:@"{latitude=%g,longitude=%g}", ((double *)value)[0], ((double *)value)[1]];

	//we don't know how to convert this typecode into an NSString
	return nil;
}

NSS * serialNumber(void) {
	NSS *result = @"";
	mach_port_t masterPort;
	kern_return_t kr = noErr;
	io_registry_entry_t entry;
	CFDataRef propData;
	CFTypeRef prop;
	CFTypeID propID;
	UInt8 *data;
	NSUInteger i, bufSize;
	UInt8 *s, *t;
	UInt8 firstPart[64], secondPart[64];

	kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
	if (kr == noErr) {
		entry = IORegistryGetRootEntry(masterPort);
		if (entry != MACH_PORT_NULL) {
			prop = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, CFSTR("serial-number"), NULL, kIORegistryIterateRecursively);
			propID = CFGetTypeID(prop);
			if (propID == CFDataGetTypeID()) {
				propData = (CFDataRef)prop;
				bufSize = CFDataGetLength(propData);
				if (bufSize > 0) {
					data = (UInt8 *)CFDataGetBytePtr(propData);
					if (data) {
						i = 0;
						s = data;
						t = firstPart;
						while (i < bufSize) {
							i++;
							if (*s != '\0') {
								*t++ = *s++;
							} else {
								break;
							}
						}
						*t = '\0';

						while ((i < bufSize) && (*s == '\0')) {
							i++;
							s++;
						}

						t = secondPart;
						while (i < bufSize) {
							i++;
							if (*s != '\0') {
								*t++ = *s++;
							} else {
								break;
							}
						}
						*t = '\0';
						result = [NSString stringWithFormat:@"%s%s", secondPart, firstPart];
					}
				}
			}
		}
		mach_port_deallocate(mach_task_self(), masterPort);
	}
	return(result);
}

//
//	// In a source file
//NSString *const FormatTypeName[FormatTypeCount] = {
//	[JSON] = @"JSON",
//	[XML] = @"XML",
//	[Atom] = @"Atom",
//	[RSS] = @"RSS",
//};

//NSString *const AZOrientName[AZOrientCount] = {
//	[AZOrientTop] = @"Top",
//	[AZOrientLeft] = @"Left",
//	[AZOrientBottom] = @"Bottom",
//	[AZOrientRight] = @"Right",
//	[AZOrientFiesta] = @"Fiesta",
////	[AZOrientCount] = @"Count",
//};

// Log levels: off, error, warn, info, verbose
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//
//void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
//	va_list arglist;
//
//	va_start (arglist, format);
//	if (![format hasSuffix: @"\n"]) {
//		format = [format stringByAppendingString: @"\n"];
//	}
//	NSString *body =  [[NSString alloc] initWithFormat: format arguments: arglist];
//	va_end (arglist);
//	const char *threadName = [[[NSThread currentThread] name] UTF8String];
//	NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
//		//	if (threadName) {
//		//		fprintf(stderr,"%s/%s (%s:%d) %s",threadName,funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
//		//	} else {
//		//		fprintf(stderr,"%p/%s (%s:%d) %s",[NSThread currentThread],funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
//		//	}
//#ifdef PRINTMETHODS
//	fprintf(stderr,"%s:%d [%s] %s",[fileName UTF8String],lineNumber,funcName, [body UTF8String]);
//#else
//	fprintf(stderr,"line:%d %s",lineNumber, [body UTF8String]);
//#endif
//		//
//	[body release];
//}
//
//void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
//
//void QuietLog (const char *file, int lineNumber, const char *funcName, NSString *format, ...) {
//	if (format == nil) {
//		printf("nil\n");
//		return;
//	}
//		// Get a reference to the arguments that follow the format parameter
//	va_list argList;
//	va_start(argList, format);
//		// Perform format string argument substitution, reinstate %% escapes, then print
//	NSString *s = [[[NSString alloc] initWithFormat:format arguments:argList]stringByReplacingAllOccurancesOfString:@"fff" withString:@"%.1f"];
//		//for float the format specifier is %f and we can restrict it to print only two decimal place value by %.2f
//	printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
//	[s release];
//	va_end(argList);
//}

//void QuietLog (NSString *format, ...) { if (format == nil) { printf("nil\n"); return; }
//	// Get a reference to the arguments that follow the format parameter
//	va_list argList;  va_start(argList, format);
//	// Perform format string argument substitution, reinstate %% escapes, then print
//	NSString *s = [[NSString alloc] initWithFormat:format arguments:argList];
//	printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
//	[s release];
//	va_end(argList);
//}

// NSLog() writes out entirely too much stuff.  Most of the time I'm  not interested in the program name, process ID, and current time down to the subsecond level.
// This takes an NSString with printf-style format, and outputs it. regular old printf can't be used instead because it doesn't support the '%@' format option.

void QuietLog( NSString *fmt,...) {	va_list argList; va_start(argList, fmt);
	printf("%s",  [[NSS stringWithFormat:fmt arguments:argList]UTF8String]);
	va_end(argList);
} // QuietLog

#ifndef NDEBUG
#import <Foundation/Foundation.h>
#import <stdio.h>

extern void _NSSetLogCStringFunction(void (*)(const char *string, unsigned length, BOOL withSyslogBanner));

static void PrintNSLogMessage(const char *string, unsigned length, BOOL withSyslogBanner) {
	puts(string);
}

static void HackNSLog(void) __attribute__((constructor));
static void HackNSLog(void) {
	_NSSetLogCStringFunction(PrintNSLogMessage);
}

#endif

//void QuietLog (NSString *format, ...) {
//	va_list argList;	va_start (argList, format);
//	NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
//	fprintf (stderr, "*** %s ***\n", [message UTF8String]);	 va_end  (argList);
//} // QuietLog
void perceptualCausticColorForColor(CGFloat *inputComponents, CGFloat *outputComponents) {
	const CGFloat CAUSTIC_FRACTION = 0.60;
	const CGFloat COSINE_ANGLE_SCALE = 1.4;
	const CGFloat MIN_RED_THRESHOLD = 0.95;
	const CGFloat MAX_BLUE_THRESHOLD = 0.7;
	const CGFloat GRAYSCALE_CAUSTIC_SATURATION = 0.2;

	NSColor *source = [NSColor colorWithCalibratedRed:inputComponents[0] green:inputComponents[1] blue:inputComponents[2]	alpha:inputComponents[3]];

	CGFloat hue_, saturation_, brightness_, alpha_, targetHue, targetSaturation, targetBrightness;
	[source getHue:&hue_ saturation:&saturation_ brightness:&brightness_ alpha:&alpha_];
	[[NSColor yellowColor] getHue:&targetHue saturation:&targetSaturation brightness:&targetBrightness alpha:&alpha_];
	if (saturation_ < 1e-3) {
		hue_ = targetHue;			   saturation_ = GRAYSCALE_CAUSTIC_SATURATION;
	}
	if (hue_ > MIN_RED_THRESHOLD) hue_ -= 1.0;
	else if (hue_ > MAX_BLUE_THRESHOLD) [[NSColor magentaColor] getHue:&targetHue saturation:&targetSaturation brightness:&targetBrightness alpha:&alpha_];
	float scaledCaustic = CAUSTIC_FRACTION * 0.5 * (1.0 + cos(COSINE_ANGLE_SCALE * M_PI * (hue_ - targetHue)));
	NSColor *targetColor =
		[NSColor colorWithCalibratedHue:hue_ * (1.0 - scaledCaustic) + targetHue * scaledCaustic saturation:saturation_
							 brightness:brightness_ * (1.0 - scaledCaustic) + targetBrightness * scaledCaustic alpha:inputComponents[3]];
	[targetColor getComponents:outputComponents];
}

/*
   void glossInterpolation(void *info, const CGFloat *input, CGFloat *output) {
		GlossParameters *params = (GlossParameters *)info;
		CGFloat progress = *input;
		if (progress < 0.5)	{
				progress = progress * 2.0;
				progress =
				1.0 - params->expScale * (expf(progress * -params->expCoefficient) - params->expOffset);
				CGFloat currentWhite = progress * (params->finalWhite - params->initialWhite) + params->initialWhite;
				output[0] = params->color[0] * (1.0 - currentWhite) + currentWhite;
				output[1] = params->color[1] * (1.0 - currentWhite) + currentWhite;
				output[2] = params->color[2] * (1.0 - currentWhite) + currentWhite;
				output[3] = params->color[3] * (1.0 - currentWhite) + currentWhite;
		} else {
				progress = (progress - 0.5) * 2.0;
				progress = params->expScale *
				(expf((1.0 - progress) * -params->expCoefficient) - params->expOffset);
				output[0] = params->color[0] * (1.0 - progress) + params->caustic[0] * progress;
				output[1] = params->color[1] * (1.0 - progress) + params->caustic[1] * progress;
				output[2] = params->color[2] * (1.0 - progress) + params->caustic[2] * progress;
				output[3] = params->color[3] * (1.0 - progress) + params->caustic[3] * progress;
		}
   }

   CGFloat perceptualGlossFractionForColor(CGFloat *inputComponents)
   {
		const CGFloat REFLECTION_SCALE_NUMBER = 0.2;
		const CGFloat NTSC_RED_FRACTION = 0.299;
		const CGFloat NTSC_GREEN_FRACTION = 0.587;
		const CGFloat NTSC_BLUE_FRACTION = 0.114;

		CGFloat glossScale =
		NTSC_RED_FRACTION * inputComponents[0] +
		NTSC_GREEN_FRACTION * inputComponents[1] +
		NTSC_BLUE_FRACTION * inputComponents[2];
		glossScale = pow(glossScale, REFLECTION_SCALE_NUMBER);
		return glossScale;
   }
   void DrawGlossGradient(CGContextRef context, NSColor *color, NSRect inRect) {
		const CGFloat EXP_COEFFICIENT = 1.2;
		const CGFloat REFLECTION_MAX = 0.60;
		const CGFloat REFLECTION_MIN = 0.20;
		GlossParameters params;
		params.expCoefficient = EXP_COEFFICIENT;
		params.expOffset = expf(-params.expCoefficient);
		params.expScale = 1.0 / (1.0 - params.expOffset);

		NSColor *source =	[color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		[source getComponents:params.color];
		if ([source numberOfComponents] == 3)
				params.color[3] = 1.0;
		perceptualCausticColorForColor(params.color, params.caustic);
		CGFloat glossScale = perceptualGlossFractionForColor(params.color);
		params.initialWhite = glossScale * REFLECTION_MAX;
		params.finalWhite = glossScale * REFLECTION_MIN;
		static const CGFloat input_value_range[2] = {0, 1};
		static const CGFloat output_value_ranges[8] = {0, 1, 0, 1, 0, 1, 0, 1};
		CGFunctionCallbacks callbacks = {0, glossInterpolation, NULL};
		CGFunctionRef gradientFunction = CGFunctionCreate(
																										  (void *)&params,
																										  1, // number of input values to the callback
																										  input_value_range,
																										  4, // number of components (r, g, b, a)
																										  output_value_ranges,
																										  &callbacks);

		CGPoint startPoint = CGPointMake(NSMinX(inRect), NSMaxY(inRect));
		CGPoint endPoint = CGPointMake(NSMinX(inRect), NSMinY(inRect));

		CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
		CGShadingRef shading = CGShadingCreateAxial(colorspace, startPoint,
																								endPoint, gradientFunction, FALSE, FALSE);

		CGContextSaveGState(context);
		CGContextClipToRect(context, NSRectToCGRect(inRect));
		CGContextDrawShading(context, shading);
		CGContextRestoreGState(context);

		CGShadingRelease(shading);
		CGColorSpaceRelease(colorspace);
		CGFunctionRelease(gradientFunction);
   }
 */
void PoofAtPoint(NSPoint pt, CGFloat radius) {
	NSShowAnimationEffect(NSAnimationEffectPoof, pt, (CGSize) {radius, radius }, nil, 0, nil);
}

extern void DrawLabelAtCenterPoint(NSString *string, NSPoint center) {
	//	NSString *labelString = [NSString stringWithFormat:@"%ld", (long)dimension];
	NSDictionary *attributes = $map([NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]], NSFontAttributeName, BLACK, NSForegroundColorAttributeName, WHITE, NSBackgroundColorAttributeName);
	NSSize labelSize = [string sizeWithAttributes:attributes];
	NSRect labelRect = NSMakeRect(center.x - 0.5 * labelSize.width, center.y - 0.5 * labelSize.height, labelSize.width, labelSize.height);
	[string drawInRect:labelRect withAttributes:attributes];
}

#import <CoreServices/CoreServices.h>
#import <stdlib.h>
static void PrintUsageAndQuit(void) {
	printf("Usage: tmtool <status|include|exclude|excludep> <path>\n");
	exit(EXIT_FAILURE);
}

//static
double frandom(double start, double end) {
	double r = random();
	r /= RAND_MAX;
	r = start + r * (end - start);

	return r;
}

// ---------------------------------------------------------------------------
// -newRandomPath
// ---------------------------------------------------------------------------
// create a new CGPath with a series of random coordinates

CGPathRef AZRandomPathInRect(NSR rect) {
	CGPoint point;
	NSSize size = rect.size;
	NSInteger x = random() % ((NSInteger)(size.width) + 50);
	NSInteger y = random() % ((NSInteger)(size.height) + 50);
	point = CGPointMake(x, y);

	return AZRandomPathWithStartingPointInRect(point, rect);
}

// ---------------------------------------------------------------------------
// -newRandomPathWithStartingPoint:
// ---------------------------------------------------------------------------
// create a new CGPath with a series of random coordinates


CGPathRef AZRandomPathWithStartingPointInRect(CGPoint firstPoint, NSR inRect) {
	// create an array of points, with 'firstPoint' at the first index
	NSUInteger count = 10;
	CGPoint onePoint;
	CGPoint allPoints[count];
	allPoints[0] = firstPoint;

	// create several CGPoints with random x and y coordinates
	CGMutablePathRef thePath = CGPathCreateMutable();
	NSUInteger i;
	for (i = 1; i < count; i++) {
		// allow the coordinates to go slightly out of the bounds of the view (+50)
		NSInteger x = random() % ((NSInteger)(inRect.size.width) + 50);
		NSInteger y = random() % ((NSInteger)(inRect.size.height) + 50);
		onePoint = CGPointMake(x, y);
		allPoints[i] = onePoint;
	}

	CGPathAddLines(thePath, NULL, allPoints, count);
	return thePath;
}

//@implementation Slice
//@end

//@implementation NSNumber (SliceCreation)
//
//- (Slice *): (NSInteger)length
//{
//	Slice *slice = [[Slice alloc] init];
//	[slice setStart: [self integerValue]];
//	[slice setLength: length];
//	return slice;
//}
//
//@end

//@implementation NSArray (slicing)
//- (id)objectForKeyedSubscript: (id)subscript		{	Slice *slice = subscript;
//	return [self subarrayWithRange: NSMakeRange([slice start], [slice length])];
//}
//@end
/*
   int main(int argc, char **argv)
   {	@autoreleasepool
		{	NSMutableArray *array = [NSMutableArray array];
				for(int i = 0; i < 100; i++)
						[array addObject: @(i * i)];

				NSArray *sliced = array[[@5:8]];
				NSLog(@"%@", sliced);
		}
   }
 */
// 2012-07-09 17:15:12.705 a.out[84967:707] (
//	 25,
//	 36,
//	 49,
//	 64,
//	 81,
//	 100,
//	 121,
//	 144
// )


//@interface  NSArray (SubscriptsAdd)
//- (id)objectAtIndexedSubscript:(NSUInteger)index;
//@end

//@interface NSMutableArray (SubscriptsAdd)
//- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;
//@end
//@interface  NSDictionary (SubscriptsAdd)
//- (id)objectForKeyedSubscript:(id)key;
//@end
//@interface  NSMutableDictionary (SubscriptsAdd)
//- (void)setObject:(id)object forKeyedSubscript:(id)key;
//@end
#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
#include <Availability.h>
#endif //  TARGET_OS_IPHONE

// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
#define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
#define MAC_OS_X_VERSION_10_6 1060
#endif
#ifndef MAC_OS_X_VERSION_10_7
#define MAC_OS_X_VERSION_10_7 1070
#endif

// Not all __IPHONE_X macros defined in past SDKs
#ifndef __IPHONE_3_0
#define __IPHONE_3_0		  30000
#endif
#ifndef __IPHONE_3_1
#define __IPHONE_3_1		  30100
#endif
#ifndef __IPHONE_3_2
#define __IPHONE_3_2		  30200
#endif
#ifndef __IPHONE_4_0
#define __IPHONE_4_0		  40000
#endif
#ifndef __IPHONE_4_3
#define __IPHONE_4_3		  40300
#endif
#ifndef __IPHONE_5_0
#define __IPHONE_5_0		  50000
#endif

/*	// ----------------------------------------------------------------------------
		// CPP symbols that can be overridden in a prefix to control how the toolbox
		// is compiled.
		// ----------------------------------------------------------------------------
		// By setting the _CONTAINERS_VALIDATION_FAILED_LOG and
		// GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
		// when a validation fails. If you implement your own validators, you may want
		// to control their internals using the same macros for consistency.
   #ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
   #define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
   #endif

		// Give ourselves a consistent way to do inlines.  Apple's macros even use
		// a few different actual definitions, so we're based off of the foundation
		// one.
   #if !defined(GTM_INLINE)
   #if (defined (__GNUC__) && (__GNUC__ == 4)) || defined (__clang__)
   #define GTM_INLINE static __inline__ __attribute__((always_inline))
   #else
   #define GTM_INLINE static __inline__
   #endif
   #endif

		// Give ourselves a consistent way of doing externs that links up nicely
		// when mixing objc and objc++
   #if !defined (GTM_EXTERN)
   #if defined __cplusplus
   #define GTM_EXTERN extern "C"
   #define GTM_EXTERN_C_BEGIN extern "C" {
   #define GTM_EXTERN_C_END }
   #else
   #define GTM_EXTERN extern
   #define GTM_EXTERN_C_BEGIN
   #define GTM_EXTERN_C_END
   #endif
   #endif

		// Give ourselves a consistent way of exporting things if we have visibility
		// set to hidden.
   #if !defined (GTM_EXPORT)
   #define GTM_EXPORT __attribute__((visibility("default")))
   #endif

		// Give ourselves a consistent way of declaring something as unused. This
		// doesn't use __unused because that is only supported in gcc 4.2 and greater.
   #if !defined (GTM_UNUSED)
   #define GTM_UNUSED(x) ((void)(x))
   #endif

		// _GTMDevLog & _GTMDevAssert

		// _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
		// developer level errors.  This implementation simply macros to NSLog/NSAssert.
		// It is not intended to be a general logging/reporting system.

		// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
		// for a little more background on the usage of these macros.

		//	_GTMDevLog		   log some error/problem in debug builds
		//	_GTMDevAssert		assert if conditon isn't met w/in a method/function
		//						   in all builds.

		// To replace this system, just provide different macro definitions in your
		// prefix header.  Remember, any implementation you provide *must* be thread
		// safe since this could be called by anything in what ever situtation it has
		// been placed in.
		// We only define the simple macros if nothing else has defined this.
   #ifndef _GTMDevLog

   #ifdef DEBUG
   #define _GTMDevLog(...) NSLog(__VA_ARGS__)
   #else
   #define _GTMDevLog(...) do { } while (0)
   #endif

   #endif // _GTMDevLog

   #ifndef _GTMDevAssert
		// we directly invoke the NSAssert handler so we can pass on the varargs
		// (NSAssert doesn't have a macro we can use that takes varargs)
   #if !defined(NS_BLOCK_ASSERTIONS)
   #define _GTMDevAssert(condition, ...)									   \
   do {																	  \
   if (!(condition)) {													 \
   [[NSAssertionHandler currentHandler]								  \
   handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
   file:[NSString stringWithUTF8String:__FILE__]  \
   lineNumber:__LINE__								  \
   description:__VA_ARGS__];							 \
   }																	   \
   } while(0)
   #else // !defined(NS_BLOCK_ASSERTIONS)
   #define _GTMDevAssert(condition, ...) do { } while (0)
   #endif // !defined(NS_BLOCK_ASSERTIONS)

   #endif // _GTMDevAssert

		// _GTMCompileAssert
		// _GTMCompileAssert is an assert that is meant to fire at compile time if you
		// want to check things at compile instead of runtime. For example if you
		// want to check that a wchar is 4 bytes instead of 2 you would use
		// _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
		// Note that the second "arg" is not in quotes, and must be a valid processor
		// symbol in it's own right (no spaces, punctuation etc).

		// Wrapping this in an #ifndef allows external groups to define their own
		// compile time assert scheme.
   #ifndef _GTMCompileAssert
		// We got this technique from here:
		// http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

   #define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
   #define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
   #define _GTMCompileAssert(test, msg) \
   typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
   #endif // _GTMCompileAssert

		// ----------------------------------------------------------------------------
		// CPP symbols defined based on the project settings so the GTM code has
		// simple things to test against w/o scattering the knowledge of project
		// setting through all the code.
		// ----------------------------------------------------------------------------

		// Provide a single constant CPP symbol that all of GTM uses for ifdefing
		// iPhone code.
   #if TARGET_OS_IPHONE // iPhone SDK
										 // For iPhone specific stuff
   #define GTM_IPHONE_SDK 1
   #if TARGET_IPHONE_SIMULATOR
   #define GTM_IPHONE_SIMULATOR 1
   #else
   #define GTM_IPHONE_DEVICE 1
   #endif  // TARGET_IPHONE_SIMULATOR
				// By default, GTM has provided it's own unittesting support, define this
				// to use the support provided by Xcode, especially for the Xcode4 support
				// for unittesting.
   #ifndef GTM_IPHONE_USE_SENTEST
   #define GTM_IPHONE_USE_SENTEST 0
   #endif
   #else
		// For MacOS specific stuff
   #define GTM_MACOS_SDK 1
   #endif

		// Some of our own availability macros
   #if GTM_MACOS_SDK
   #define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
   #define GTM_AVAILABLE_ONLY_ON_MACOS
   #else
   #define GTM_AVAILABLE_ONLY_ON_IPHONE
   #define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
   #endif

		// Provide a symbol to include/exclude extra code for GC support.  (This mainly
		// just controls the inclusion of finalize methods).
   #ifndef GTM_SUPPORT_GC
   #if GTM_IPHONE_SDK
		// iPhone never needs GC
   #define GTM_SUPPORT_GC 0
   #else
		// We can't find a symbol to tell if GC is supported/required, so best we
		// do on Mac targets is include it if we're on 10.5 or later.
   #if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
   #define GTM_SUPPORT_GC 0
   #else
   #define GTM_SUPPORT_GC 1
   #endif
   #endif
   #endif
 */
// To simplify support for 64bit (and Leopard in general), we provide the type
// defines for non Leopard SDKs
#if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
// NSInteger/NSUInteger and Max/Mins
#ifndef NSINTEGER_DEFINED
#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long			NSInteger;
typedef unsigned long   NSUInteger;
#else
typedef int			 NSInteger;
typedef unsigned int	NSUInteger;
#endif
#define NSIntegerMax	  LONG_MAX
#define NSIntegerMin	  LONG_MIN
#define NSUIntegerMax	 ULONG_MAX
#define NSINTEGER_DEFINED 1
#endif  // NSINTEGER_DEFINED
// CGFloat
#ifndef CGFLOAT_DEFINED
#if defined(__LP64__) && __LP64__
// This really is an untested path (64bit on Tiger?)
typedef double   CGFloat;
#define CGFLOAT_MIN	   DBL_MIN
#define CGFLOAT_MAX	   DBL_MAX
#define CGFLOAT_IS_DOUBLE 1
#else /* !defined(__LP64__) || !__LP64__ */
typedef float	CGFloat;
#define CGFLOAT_MIN	   FLT_MIN
#define CGFLOAT_MAX	   FLT_MAX
#define CGFLOAT_IS_DOUBLE 0
#endif /* !defined(__LP64__) || !__LP64__ */
#define CGFLOAT_DEFINED   1
#endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5


/*
		// Some support for advanced clang static analysis functionality
		// See http://clang-analyzer.llvm.org/annotations.html
   #ifndef __has_feature	  // Optional.
   #define __has_feature(x) 0 // Compatibility with non-clang compilers.
   #endif

   #ifndef NS_RETURNS_RETAINED
   #if __has_feature(attribute_ns_returns_retained)
   #define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
   #else
   #define NS_RETURNS_RETAINED
   #endif
   #endif

   #ifndef NS_RETURNS_NOT_RETAINED
   #if __has_feature(attribute_ns_returns_not_retained)
   #define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
   #else
   #define NS_RETURNS_NOT_RETAINED
   #endif
   #endif

   #ifndef CF_RETURNS_RETAINED
   #if __has_feature(attribute_cf_returns_retained)
   #define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
   #else
   #define CF_RETURNS_RETAINED
   #endif
   #endif

   #ifndef CF_RETURNS_NOT_RETAINED
   #if __has_feature(attribute_cf_returns_not_retained)
   #define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
   #else
   #define CF_RETURNS_NOT_RETAINED
   #endif
   #endif

   #ifndef NS_CONSUMED
   #if __has_feature(attribute_ns_consumed)
   #define NS_CONSUMED __attribute__((ns_consumed))
   #else
   #define NS_CONSUMED
   #endif
   #endif

   #ifndef CF_CONSUMED
   #if __has_feature(attribute_cf_consumed)
   #define CF_CONSUMED __attribute__((cf_consumed))
   #else
   #define CF_CONSUMED
   #endif
   #endif

   #ifndef NS_CONSUMES_SELF
   #if __has_feature(attribute_ns_consumes_self)
   #define NS_CONSUMES_SELF __attribute__((ns_consumes_self))
   #else
   #define NS_CONSUMES_SELF
   #endif
   #endif
 */
//#else /* !defined(__LP64__) || !__LP64__ */
//typedef float CGFloat;
//#define CGFLOAT_MIN FLT_MIN
//#define CGFLOAT_MAX FLT_MAX
//#define CGFLOAT_IS_DOUBLE 0
//#endif /* !defined(__LP64__) || !__LP64__ */
//#define CGFLOAT_DEFINED 1
//#endif // CGFLOAT_DEFINED
//#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

/*
		// Some support for advanced clang static analysis functionality
		// See http://clang-analyzer.llvm.org/annotations.html
   #ifndef __has_feature	  // Optional.
   #define __has_feature(x) 0 // Compatibility with non-clang compilers.
   #endif

   #ifndef NS_RETURNS_RETAINED
   #if __has_feature(attribute_ns_returns_retained)
   #define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
   #else
   #define NS_RETURNS_RETAINED
   #endif
   #endif

   #ifndef NS_RETURNS_NOT_RETAINED
   #if __has_feature(attribute_ns_returns_not_retained)
   #define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
   #else
   #define NS_RETURNS_NOT_RETAINED
   #endif
   #endif

   #ifndef CF_RETURNS_RETAINED
   #if __has_feature(attribute_cf_returns_retained)
   #define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
   #else
   #define CF_RETURNS_RETAINED
   #endif
   #endif

   #ifndef CF_RETURNS_NOT_RETAINED
   #if __has_feature(attribute_cf_returns_not_retained)
   #define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
   #else
   #define CF_RETURNS_NOT_RETAINED
   #endif
   #endif

   #ifndef NS_CONSUMED
   #if __has_feature(attribute_ns_consumed)
   #define NS_CONSUMED __attribute__((ns_consumed))
   #else
   #define NS_CONSUMED
   #endif
   #endif

   #ifndef CF_CONSUMED
   #if __has_feature(attribute_cf_consumed)
   #define CF_CONSUMED __attribute__((cf_consumed))
   #else
   #define CF_CONSUMED
   #endif
   #endif

   #ifndef NS_CONSUMES_SELF
   #if __has_feature(attribute_ns_consumes_self)
   #define NS_CONSUMES_SELF __attribute__((ns_consumes_self))
   #else
   #define NS_CONSUMES_SELF
   #endif
   #endif

		// Defined on 10.6 and above.
   #ifndef NS_FORMAT_ARGUMENT
   #define NS_FORMAT_ARGUMENT(A)
   #endif

		// Defined on 10.6 and above.
   #ifndef NS_FORMAT_FUNCTION
   #define NS_FORMAT_FUNCTION(F,A)
   #endif

		// Defined on 10.6 and above.
   #ifndef CF_FORMAT_ARGUMENT
   #define CF_FORMAT_ARGUMENT(A)
   #endif

		// Defined on 10.6 and above.
   #ifndef CF_FORMAT_FUNCTION
   #define CF_FORMAT_FUNCTION(F,A)
   #endif

 */
/*
   #ifndef GTM_NONNULL
   #define GTM_NONNULL(x) __attribute__((nonnull(x)))
   //#endif
   //
   //#ifdef __OBJC__
   //
   //	// Declared here so that it can easily be used for logging tracking if
   //	// necessary. See GTMUnitTestDevLog.h for details.
   //@class NSString;
   //GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);
   //
		// Macro to allow you to create NSStrings out of other macros.
		// #define FOO foo
		// NSString *fooString = GTM_NSSTRINGIFY(FOO);
   #if !defined (GTM_NSSTRINGIFY)
   #define GTM_NSSTRINGIFY_INNER(x) @#x
   #define GTM_NSSTRINGIFY(x) GTM_NSSTRINGIFY_INNER(x)
   #endif

		// Macro to allow fast enumeration when building for 10.5 or later, and
		// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
		// does keys, so pick the right thing, nothing is done on the FastEnumeration
		// side to be sure you're getting what you wanted.
   #ifndef GTM_FOREACH_OBJECT
   #if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
   #define GTM_FOREACH_ENUMEREE(element, enumeration) \
   for (element in enumeration)
   #define GTM_FOREACH_OBJECT(element, collection) \
   for (element in collection)
   #define GTM_FOREACH_KEY(element, collection) \
   for (element in collection)
   #else
   #define GTM_FOREACH_ENUMEREE(element, enumeration) \
   for (NSEnumerator *_ ## element ## _enum = enumeration; \
   (element = [_ ## element ## _enum nextObject]) != nil; )
   #define GTM_FOREACH_OBJECT(element, collection) \
   GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
   #define GTM_FOREACH_KEY(element, collection) \
   GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
   #endif
   #endif

		//GTMDefines

   #import <objc/objc-api.h>
   #import <objc/objc-auto.h>

		// The file objc-runtime.h was moved to runtime.h and in Leopard, objc-runtime.h
		// was just a wrapper around runtime.h. For the iPhone SDK, this objc-runtime.h
		// is removed in the iPhoneOS2.0 SDK.

		// The |Object| class was removed in the iPhone2.0 SDK too.
   #if GTM_IPHONE_SDK
   #import <objc/message.h>
   #import <objc/runtime.h>
   #else
   #import <objc/objc-runtime.h>
   #import <objc/Object.h>
   #endif

   #import <libkern/OSAtomic.h>
   #import "objc/Protocol.h"

   OBJC_EXPORT Class object_getClass(id obj);
   OBJC_EXPORT const char *class_getName(Class cls);
   OBJC_EXPORT BOOL class_conformsToProtocol(Class cls, Protocol *protocol);
   OBJC_EXPORT BOOL class_respondsToSelector(Class cls, SEL sel);
   OBJC_EXPORT Class class_getSuperclass(Class cls);
   OBJC_EXPORT Method *class_copyMethodList(Class cls, unsigned int *outCount);
   OBJC_EXPORT SEL method_getName(Method m);
   OBJC_EXPORT void method_exchangeImplementations(Method m1, Method m2);
   OBJC_EXPORT IMP method_getImplementation(Method method);
   OBJC_EXPORT IMP method_setImplementation(Method method, IMP imp);
   OBJC_EXPORT struct objc_method_description protocol_getMethodDescription(Protocol *p,
																																				 SEL aSel,
																																				 BOOL isRequiredMethod,
																																				 BOOL isInstanceMethod);
   OBJC_EXPORT BOOL sel_isEqual(SEL lhs, SEL rhs);

 */

int max(int x, int y) {
	return x > y ? x : y;
}

// Released by Drew McCormack into the pubic domain (2010).

#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#import <stdlib.h>
#import <string.h>

Class object_getClass(id obj) {
	if (!obj) return NULL;
	return obj->isa;
}

const char * class_getName(Class cls) {
	if (!cls) return "nil";
	return cls->name;
}

BOOL class_conformsToProtocol(Class cls, Protocol *protocol) {
	// We intentionally don't check cls as it crashes on Leopard so we want
	// to crash on Tiger as well.
	// I logged
	// Radar 5572978 class_conformsToProtocol crashes when arg1 is passed as nil
	// because it seems odd that this API won't accept nil for cls considering
	// all the other apis will accept nil args.
	// If this does get fixed, remember to enable the unit tests.
	if (!protocol) return NO;

	struct objc_protocol_list *protos;
	for (protos = cls->protocols; protos != NULL; protos = protos->next) {
		for (long i = 0; i < protos->count; i++) {
			if ([protos->list[i] conformsTo:protocol]) {
				return YES;
			}
		}
	}
	return NO;
}

Class class_getSuperclass(Class cls) {
	if (!cls) return NULL;
	return cls->super_class;
}

BOOL class_respondsToSelector(Class cls, SEL sel) {
	return class_getInstanceMethod(cls, sel) != nil;
}

Method * class_copyMethodList(Class cls, unsigned int *outCount) {
	if (!cls) return NULL;

	unsigned int count = 0;
	void *iterator = NULL;
	struct objc_method_list *mlist;
	Method *methods = NULL;
	if (outCount) *outCount = 0;

	while ( (mlist = class_nextMethodList(cls, &iterator)) ) {
		if (mlist->method_count == 0) continue;
		methods = (Method *)realloc(methods,
									sizeof(Method) * (count + mlist->method_count + 1));
		if (!methods) {
			//Memory alloc failed, so what can we do?
			return NULL;			  // COV_NF_LINE
		}
		for (int i = 0; i < mlist->method_count; i++) {
			methods[i + count] = &mlist->method_list[i];
		}
		count += mlist->method_count;
	}

	// List must be NULL terminated
	if (methods) {
		methods[count] = NULL;
	}
	if (outCount) *outCount = count;
	return methods;
}

SEL method_getName(Method method) {
	if (!method) return NULL;
	return method->method_name;
}

IMP method_getImplementation(Method method) {
	if (!method) return NULL;
	return method->method_imp;
}

IMP method_setImplementation(Method method, IMP imp) {
	// We intentionally don't test method for nil.
	// Leopard fails here, so should we.
	// I logged this as Radar:
	// 5572981 method_setImplementation crashes if you pass nil for the
	// method arg (arg 1)
	// because it seems odd that this API won't accept nil for method considering
	// all the other apis will accept nil args.
	// If this does get fixed, remember to enable the unit tests.
	// This method works differently on SnowLeopard than
	// on Leopard. If you pass in a nil for IMP on SnowLeopard
	// it doesn't change anything. On Leopard it will. Since
	// attempting to change a sel to nil is probably an error
	// we follow the SnowLeopard way of doing things.
	IMP oldImp = NULL;
	if (imp) {
		oldImp = method->method_imp;
		method->method_imp = imp;
	}
	return oldImp;
}

void method_exchangeImplementations(Method m1, Method m2) {
	if (m1 == m2) return;
	if (!m1 || !m2) return;
	IMP imp2 = method_getImplementation(m2);
	IMP imp1 = method_setImplementation(m1, imp2);
	method_setImplementation(m2, imp1);
}

struct objc_method_description protocol_getMethodDescription(Protocol *p,
															 SEL	  aSel,
															 BOOL	 isRequiredMethod,
															 BOOL	 isInstanceMethod) {
	struct objc_method_description *descPtr = NULL;
	// No such thing as required in ObjC1.
	if (isInstanceMethod) {
		descPtr = [p descriptionForInstanceMethod:aSel];
	} else {
		descPtr = [p descriptionForClassMethod:aSel];
	}

	struct objc_method_description desc;
	if (descPtr) {
		desc = *descPtr;
	} else {
		bzero(&desc, sizeof(desc));
	}
	return desc;
}

BOOL sel_isEqual(SEL lhs, SEL rhs) {
	// Apple (informally) promises this will work in the future:
	// http://twitter.com/#!/gparker/status/2400099786
	return (lhs == rhs) ? YES : NO;
}

#endif


NSString *const AtoZSharedInstanceUpdated = @"AtoZSharedInstanceUpdated";
NSString *const AtoZDockSortedUpdated = @"AtoZDockSortedUpdated";
NSString *const AtoZSuperLayer = @"superlayer";
CGFloat AZScreenWidth() {
	return [[NSScreen mainScreen]frame].size.width;
}

CGFloat ScreenHighness() {
	return [[NSScreen mainScreen]frame].size.height;
}

//  usage	   profile("Long Task", ^{ performLongTask() } );
void profile(const char *name, void (^work) (void)) {
	struct timeval start, end;
	gettimeofday(&start, NULL);
	work();
	gettimeofday(&end, NULL);

	double fstart = (start.tv_sec * 1000000.0 + start.tv_usec) / 1000000.0;
	double fend = (end.tv_sec * 1000000.0 + end.tv_usec) / 1000000.0;

	printf("%s took %f seconds", name, fend - fstart);
}

CGFloat DegreesToRadians(CGFloat degrees) {
	return degrees * M_PI / 180;
}

NSNumber * DegreesToNumber(CGFloat degrees) {
	return [NSNumber numberWithFloat:
			DegreesToRadians(degrees)];
}

/*
   // Defined on 10.6 and above.
   #ifndef NS_FORMAT_ARGUMENT
   #define NS_FORMAT_ARGUMENT(A)
   #endif

   // Defined on 10.6 and above.
   #ifndef NS_FORMAT_FUNCTION
   #define NS_FORMAT_FUNCTION(F,A)
   #endif

   // Defined on 10.6 and above.
   #ifndef CF_FORMAT_ARGUMENT
   #define CF_FORMAT_ARGUMENT(A)
   #endif

   // Defined on 10.6 and above.
   #ifndef CF_FORMAT_FUNCTION
   #define CF_FORMAT_FUNCTION(F,A)
 #endif	*/

#ifndef GTM_NONNULL
#define GTM_NONNULL(x) __attribute__((nonnull(x)))
#endif

/*
   #ifdef __OBJC__

   // Declared here so that it can easily be used for logging tracking if
   // necessary. See GTMUnitTestDevLog.h for details.
   @class NSString;
   GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);

   // Macro to allow you to create NSStrings out of other macros.
   // #define FOO foo
   // NSString *fooString = GTM_NSSTRINGIFY(FOO);
   #if !defined (GTM_NSSTRINGIFY)
   #define GTM_NSSTRINGIFY_INNER(x) @#x
   #define GTM_NSSTRINGIFY(x) GTM_NSSTRINGIFY_INNER(x)
   #endif

   // Macro to allow fast enumeration when building for 10.5 or later, and
   // reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
   // does keys, so pick the right thing, nothing is done on the FastEnumeration
   // side to be sure you're getting what you wanted.
   #ifndef GTM_FOREACH_OBJECT
   #if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
   #define GTM_FOREACH_ENUMEREE(element, enumeration) \
   for (element in enumeration)
   #define GTM_FOREACH_OBJECT(element, collection) \
   for (element in collection)
   #define GTM_FOREACH_KEY(element, collection) \
   for (element in collection)
   #else
   #define GTM_FOREACH_ENUMEREE(element, enumeration) \
   for (NSEnumerator *_ ## element ## _enum = enumeration; \
   (element = [_ ## element ## _enum nextObject]) != nil; )
   #define GTM_FOREACH_OBJECT(element, collection) \
   GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
   #define GTM_FOREACH_KEY(element, collection) \
   GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
   #endif
   #endif

   // ============================================================================

   // To simplify support for both Leopard and Snow Leopard we declare
   // the Snow Leopard protocols that we need here.
   #if !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)
   #define GTM_10_6_PROTOCOLS_DEFINED 1
   @protocol NSConnectionDelegate
   @end
   @protocol NSAnimationDelegate
   @end
   @protocol NSImageDelegate
   @end
   @protocol NSTabViewDelegate
   @end
   #endif  // !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)

   // GTM_SEL_STRING is for specifying selector (usually property) names to KVC
   // or KVO methods.
   // In debug it will generate warnings for undeclared selectors if
   // -Wunknown-selector is turned on.
   // In release it will have no runtime overhead.
   #ifndef GTM_SEL_STRING
   #ifdef DEBUG
   #define GTM_SEL_STRING(selName) NSStringFromSelector(@selector(selName))
   #else
   #define GTM_SEL_STRING(selName) @#selName
   #endif  // DEBUG
   #endif  // GTM_SEL_STRING

   #endif // __OBJC__
   #include <AvailabilityMacros.h>
   #include <TargetConditionals.h>

   #if TARGET_OS_IPHONE
   #include <Availability.h>
   #endif //  TARGET_OS_IPHONE

   // Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
   #ifndef MAC_OS_X_VERSION_10_5
   #define MAC_OS_X_VERSION_10_5 1050
   #endif
   #ifndef MAC_OS_X_VERSION_10_6
   #define MAC_OS_X_VERSION_10_6 1060
   #endif
   #ifndef MAC_OS_X_VERSION_10_7
   #define MAC_OS_X_VERSION_10_7 1070
   #endif

   // Not all __IPHONE_X macros defined in past SDKs
   #ifndef __IPHONE_3_0
   #define __IPHONE_3_0 30000
   #endif
   #ifndef __IPHONE_3_1
   #define __IPHONE_3_1 30100
   #endif
   #ifndef __IPHONE_3_2
   #define __IPHONE_3_2 30200
   #endif
   #ifndef __IPHONE_4_0
   #define __IPHONE_4_0 40000
   #endif
   #ifndef __IPHONE_4_3
   #define __IPHONE_4_3 40300
   #endif
   #ifndef __IPHONE_5_0
   #define __IPHONE_5_0 50000
   #endif

   // ----------------------------------------------------------------------------
   // CPP symbols that can be overridden in a prefix to control how the toolbox
   // is compiled.
   // ----------------------------------------------------------------------------
   // By setting the GTM_CONTAINERS_VALIDATION_FAILED_LOG and
   // GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
   // when a validation fails. If you implement your own validators, you may want
   // to control their internals using the same macros for consistency.
   #ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
   #define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
   #endif

   // Give ourselves a consistent way to do inlines.  Apple's macros even use
   // a few different actual definitions, so we're based off of the foundation
   // one.
   #if !defined(GTM_INLINE)
   #if (defined (__GNUC__) && (__GNUC__ == 4)) || defined (__clang__)
   #define GTM_INLINE static __inline__ __attribute__((always_inline))
   #else
   #define GTM_INLINE static __inline__
   #endif
   #endif

   // Give ourselves a consistent way of doing externs that links up nicely
   // when mixing objc and objc++
   #if !defined (GTM_EXTERN)
   #if defined __cplusplus
   #define GTM_EXTERN extern "C"
   #define GTM_EXTERN_C_BEGIN extern "C" {
   #define GTM_EXTERN_C_END }
   #else
   #define GTM_EXTERN extern
   #define GTM_EXTERN_C_BEGIN
   #define GTM_EXTERN_C_END
   #endif
   #endif

   // Give ourselves a consistent way of exporting things if we have visibility
   // set to hidden.
   #if !defined (GTM_EXPORT)
   #define GTM_EXPORT __attribute__((visibility("default")))
   #endif

   // Give ourselves a consistent way of declaring something as unused. This
   // doesn't use __unused because that is only supported in gcc 4.2 and greater.
   #if !defined (GTM_UNUSED)
   #define GTM_UNUSED(x) ((void)(x))
   #endif

   // _GTMDevLog & _GTMDevAssert

   // _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
   // developer level errors.  This implementation simply macros to NSLog/NSAssert.
   // It is not intended to be a general logging/reporting system.

   // Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
   // for a little more background on the usage of these macros.

   //	_GTMDevLog		   log some error/problem in debug builds
   //	_GTMDevAssert		assert if conditon isn't met w/in a method/function
   //						   in all builds.

   // To replace this system, just provide different macro definitions in your
   // prefix header.  Remember, any implementation you provide *must* be thread
   // safe since this could be called by anything in what ever situtation it has
   // been placed in.
   // We only define the simple macros if nothing else has defined this.
   #ifndef _GTMDevLog

   #ifdef DEBUG
   #define _GTMDevLog(...) NSLog(__VA_ARGS__)
   #else
   #define _GTMDevLog(...) do { } while (0)
   #endif

   #endif // _GTMDevLog

   #ifndef _GTMDevAssert
   // we directly invoke the NSAssert handler so we can pass on the varargs
   // (NSAssert doesn't have a macro we can use that takes varargs)
   #if !defined(NS_BLOCK_ASSERTIONS)
   #define _GTMDevAssert(condition, ...)									   \
   do {																	  \
   if (!(condition)) {													 \
   [[NSAssertionHandler currentHandler]								  \
   handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
   file:[NSString stringWithUTF8String:__FILE__]  \
   lineNumber:__LINE__								  \
   description:__VA_ARGS__];							 \
   }																	   \
   } while(0)
   #else // !defined(NS_BLOCK_ASSERTIONS)
   #define _GTMDevAssert(condition, ...) do { } while (0)
   #endif // !defined(NS_BLOCK_ASSERTIONS)

   #endif // _GTMDevAssert

   // _GTMCompileAssert
   // _GTMCompileAssert is an assert that is meant to fire at compile time if you
   // want to check things at compile instead of runtime. For example if you
   // want to check that a wchar is 4 bytes instead of 2 you would use
   // _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
   // Note that the second "arg" is not in quotes, and must be a valid processor
   // symbol in it's own right (no spaces, punctuation etc).

   // Wrapping this in an #ifndef allows external groups to define their own
   // compile time assert scheme.
   #ifndef _GTMCompileAssert
   // We got this technique from here:
   // http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

   #define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
   #define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
   #define _GTMCompileAssert(test, msg) \
   typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
   #endif // _GTMCompileAssert

   // ----------------------------------------------------------------------------
   // CPP symbols defined based on the project settings so the GTM code has
   // simple things to test against w/o scattering the knowledge of project
   // setting through all the code.
   // ----------------------------------------------------------------------------

   // Provide a single constant CPP symbol that all of GTM uses for ifdefing
   // iPhone code.
   #if TARGET_OS_IPHONE // iPhone SDK
   // For iPhone specific stuff
   #define GTM_IPHONE_SDK 1
   #if TARGET_IPHONE_SIMULATOR
   #define GTM_IPHONE_SIMULATOR 1
   #else
   #define GTM_IPHONE_DEVICE 1
   #endif  // TARGET_IPHONE_SIMULATOR
   // By default, GTM has provided it's own unittesting support, define this
   // to use the support provided by Xcode, especially for the Xcode4 support
   // for unittesting.
   #ifndef GTM_IPHONE_USE_SENTEST
   #define GTM_IPHONE_USE_SENTEST 0
   #endif
   #else
   // For MacOS specific stuff
   #define GTM_MACOS_SDK 1
   #endif

   // Some of our own availability macros
   #if GTM_MACOS_SDK
   #define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
   #define GTM_AVAILABLE_ONLY_ON_MACOS
   #else
   #define GTM_AVAILABLE_ONLY_ON_IPHONE
   #define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
   #endif

   // Provide a symbol to include/exclude extra code for GC support.  (This mainly
   // just controls the inclusion of finalize methods).
   #ifndef GTM_SUPPORT_GC
   #if GTM_IPHONE_SDK
   // iPhone never needs GC
   #define GTM_SUPPORT_GC 0
   #else
   // We can't find a symbol to tell if GC is supported/required, so best we
   // do on Mac targets is include it if we're on 10.5 or later.
   #if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
   #define GTM_SUPPORT_GC 0
   #else
   #define GTM_SUPPORT_GC 1
   #endif
   #endif
   #endif

   // To simplify support for 64bit (and Leopard in general), we provide the type
   // defines for non Leopard SDKs
   #if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
   // NSInteger/NSUInteger and Max/Mins
   #ifndef NSINTEGER_DEFINED
   #if __LP64__ || NS_BUILD_32_LIKE_64
   typedef long NSInteger;
   typedef unsigned long NSUInteger;
   #else
   typedef int NSInteger;
   typedef unsigned int NSUInteger;
   #endif
   #define NSIntegerMax	LONG_MAX
   #define NSIntegerMin	LONG_MIN
   #define NSUIntegerMax   ULONG_MAX
   #define NSINTEGER_DEFINED 1
   #endif  // NSINTEGER_DEFINED
   // CGFloat
   #ifndef CGFLOAT_DEFINED
   #if defined(__LP64__) && __LP64__
   // This really is an untested path (64bit on Tiger?)
   typedef double CGFloat;
   #define CGFLOAT_MIN DBL_MIN
   #define CGFLOAT_MAX DBL_MAX
 #define CGFLOAT_IS_DOUBLE 1	*/


// MARK: Helper functions

// Creates a vertical grayscale gradient of the specified size and returns a CGImage
CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh) {
	CGImageRef theCGImage = NULL;

	// Create a grayscale color space
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

	// Create the bitmap context to draw into
	CGContextRef gradientContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, 0, colorSpace, kCGImageAlphaNone);

	// Define start and end color stops (alpha values required even though not used in the gradient)
	CGFloat colors[] = { 0.0, 1.0, 1.0, 1.0 };
	CGPoint gradientStartPoint = CGPointZero;
	CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);

	// Draw the gradient
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGContextDrawLinearGradient(gradientContext,
								grayScaleGradient,
								gradientStartPoint,
								gradientEndPoint,
								kCGGradientDrawsAfterEndLocation);

	// Create the image from the context
	theCGImage = CGBitmapContextCreateImage(gradientContext);

	// Clean up
	CGGradientRelease(grayScaleGradient);
	CGContextRelease(gradientContext);
	CGColorSpaceRelease(colorSpace);

	// Return the CGImageRef containing the gradient (with refcount = 1)
	return theCGImage;
}

NSImage * reflectedView(NSView *view) {
// Creates an autoreleased reflected image of the contents of the main view
	// Calculate the size of the reflection in devices units - supports hires displays
	CGFloat displayScale = 1.0f;

	CGSize deviceReflectionSize = view.bounds.size;
	deviceReflectionSize.width *= displayScale;
	deviceReflectionSize.height *= displayScale;

	// Create the bitmap context to draw into
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(NULL,
											 deviceReflectionSize.width,
											 deviceReflectionSize.height,
											 8,
											 0,
											 colorSpace,
											 // Optimal BGRA format for the device:
											 (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);

	if (!ctx) {
		return nil;
	}

	// Create a 1 pixel-wide gradient (will be stretched by CGContextClipToMask)
	CGImageRef gradientImage = CreateGradientImage(1, deviceReflectionSize.height);

	// Use the gradient image as a mask
	CGContextClipToMask(ctx, CGRectMake(0.0f, 0.0f, deviceReflectionSize.width, deviceReflectionSize.height), gradientImage);
	CGImageRelease(gradientImage);

	// Translate origin to position reflection correctly. Reflection will be flipped automatically because of differences between
	// Quartz2D coordinate system and CALayer coordinate system.
	CGContextTranslateCTM(ctx, 0.0, -view.bounds.size.height * displayScale + deviceReflectionSize.height);
	CGContextScaleCTM(ctx, displayScale, displayScale);

	// Render into the reflection context. Rendering is wrapped in a transparency layer otherwise sublayers
	// will be rendered individually using the gradient mask and hidden layers will show through
	CGContextBeginTransparencyLayer(ctx, NULL);
	[view.layer renderInContext:ctx];
	CGContextEndTransparencyLayer(ctx);

	// Create the reflection image from the context
	CGImageRef reflectionCGImage = CGBitmapContextCreateImage(ctx);
//	NSSize ww = [reflectionCGImage
	NSImage *reflectionImage = [NSImage imageFromCGImageRef:reflectionCGImage];	// alloc]initWithCGImage:reflectionCGImage];
	CGContextRelease(ctx);
	CGImageRelease(reflectionCGImage);

	return reflectionImage;
}