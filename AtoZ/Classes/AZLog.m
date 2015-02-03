
//@import Darwin;
//#import <stdio.h>
//#import <asl.h>
//#import <sys/time.h>

#import "AtoZ.h"
#import "AZLog.h"
#import <notify.h>
#import <notify_keys.h>


//+ (void) initiablize { [DDLog addLogger:DDSHARED]; DDSHARED.colorsEnabled = YES; DDSHARED.logFormatter = self.new; }

@implementation NSO (AtoZObjectLog)
- (void) log { NSLog(@"%@",self);  } // return (void*)nil; }
@end

JREnumDefine ( LogEnv );

//@interface AtoZLumberLog() <DDLogFormatter> @end


/*
 return [NSString stringWithFormat:@"%@ | %@\n", logLevel, logMessage->logMsg];
 NSString *logLevel;  switch (logMessage->logFlag)  { case LOG_FLAG_ERROR : logLevel = @"E"; break; case LOG_FLAG_WARN  : logLevel = @"W"; break; case LOG_FLAG_INFO  : logLevel = @"I"; break; case LOG_FLAG_DEBUG : logLevel = @"D"; break; default : logLevel = @"V"; break;   }

 - (void)logMessage:(DDLogMessage*)logMessage{

 NSString *logMsg = logMessage->logMsg;

 if (self->formatter)
 logMsg = [self->formatter formatLogMessage:logMessage];

 if (logMsg)
 {
 // Write logMsg to wherever...
 }
 }
 */
//+ (void) load { AZLOGCMD;
//
//[DDLog addLogger:DDSHARED];
//  DDSHARED.colorsEnabled = YES; DDSHARED.logFormatter = self.new; }

//+ (void) logFile:(const char*)file line:(int)ln func:(const char*)fnc format:(id)fmt,... {
//
//	if (!fmt || ISNOTA(fmt,NSS)) return NSLog(@"you tried formatting with a %@, not a string!", [fmt className]);
//
//	va_list argList;  va_start(argList, fmt);   // Get a reference to the arguments that follow the format parameter
//
//  [DDLog log:YES level:1 flag:0 context:0 file:file function:fnc line:ln tag:0 format:fmt args:argList]; 	va_end(argList);
//}

//- (NSS*) formatLogMessage:(DDLogMessage*)m{ return //NSS* meth = "]; return
//
//  @[[AZLog colorizeString:m->logMsg withColor:AtoZ.globalPalette.nextNormalObject].clr, zTAB,
//    [m.methodName substringBetweenPrefix:@"⬆[" andSuffix:@"]"] ?: @""].componentString;
//}


@implementation NSLogMessage @synthesize  JSONRepresentation = _JSONRep, data = _data, message = _message, file = _file, function = _function, line = _line, date = _date;

- (INST) initWithLog:		(id)data file:(char*)file func:(char*)func line:(int)line sev:(NSUI)sev {	self = super.init;

  ISA(data,NSS) ? _message = data : ISA(data,NSData) ? _data = data : nil;
  _file = $(@"%s",file); _date = NSDate.date; _line = @(line ?: 0); _severity = @(sev ?: 0); _function = func ? $UTF8(func) : nil;
  return self;
}
+ (INST) messageWithLog:(id)data file:(char*)file func:(char*)func line:(int)line sev:(NSUI)sev {
  return [self.alloc initWithLog:data file:file func:func line:line sev:sev];
}
-   (id) JSONRepresentation				{ if (_JSONRep) return _JSONRep; NSERR*error;

  id x = [NSJSONSerialization dataWithJSONObject:self.dictionaryRepresentation options:NSJSONWritingPrettyPrinted error:&error];
  // Pass 0 if you don't care about the readability of the generated string
  return _JSONRep = error ? NSLog(@"Got an error: %@", error), (id)nil: [NSS stringWithUTF8Data:x];
}
- (NSD*) dictionaryRepresentation {
  return @{@"message":self.message,	@"date": _date.string, @"file": _file ?:@"", @"line":_line ? _line.stringValue : @"0", @"severity":self.severityString};
}
- (NSS*) severityString						{ objswitch(_severity) objcase(@0) return @"INFO"; objcase(@1) return @"WARN"; defaultcase return @"DEBUG"; endswitch }
- (NSS*) message									{ return _message = _message ?: _data ? [NSS stringWithUTF8Data:_data] : @""; }
@end

void WEBLOG	   (id fmt, ...)  { AZLogConsoleView* __unused e = (AZLogConsoleView*)[AZLogConsole.sharedConsole webView]; /* [e logString: file:(char*)filename lineNumber:(int)lineNum];*/ }
NSA* AZEnvVars (char** envp)  { 					NSMA * vars = NSMA.new; char** env;

  for (env = envp; *env != 0; env++)	{ NSS * var, * raw;
    raw = [NSS stringWithCString:*env encoding:NSASCIIStringEncoding];
    objc_setAssociatedObject(	var = [raw substringBefore:@"="],	 	__VSTR(@"envVarValue"),
                             [raw substringAfter:@"="],	OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [vars addObject:var];
  }
  return vars;
}
NSD* AZEnv		 (char** envp)	{	return [AZEnvVars(envp) mapToDictionary:^id(id o) {
  return objc_getAssociatedObject(o, __VSTR(@"envVarValue"));		}];
}
void AZLogEnv	 (char** envp)	{

  NSMA *env= @[].mC;
  while (*envp) {
    char *thisenv = *envp;
    char *equals = strchr(thisenv, '=');
    if (equals) [env addObject:[NSS.alloc initWithBytes:*envp length:equals-*envp encoding:NSISOLatin1StringEncoding]];
    envp++;
  }
  NSD* envD   = AZEnv(envp);
  NSUI length = [envD.allKeys lengthOfLongestMemberString] + 2;
  NSC *keys   = NSC.randomBrightColor, *vals = NSC.randomBrightColor;
  NSA *keysA   = [NSC gradientPalletteBetween:keys.darkerColor c2:keys.brighter steps:envD.count],
      *valuesA = [NSC gradientPalletteBetween:vals.darkerColor c2:vals.brighter steps:envD.count];

  //  LOGCOLORS( 	[NSA arrayWithArrays:[envD mapToArray:^NSArray *(id k, id v) {
  //    return @[[k paddedTo:length], v, zNL]; }]], [NSC colorsInListNamed:@"flatui"], nil);

  [envD eachWithIndex:^(id key, NSS* value, NSUI idx, BOOL *stop) {
    NSS *k = [key paddedRightTo:length];
    k.logForeground = keysA[idx];
    value.logForeground = valuesA[idx];

    printf("ZZZZ:%s  %s\n", k.colorLogString.UTF8String, value.colorLogString.UTF8String);
  }];
  //[NSC colorsInListNamed:@"flatui"], nil);
}
void QuietLog  (NSS*fmt,...)	{	va_list argList; va_start(argList, fmt);
  printf("%s\n",  [[NSS stringWithFormat:fmt arguments:argList]UTF8String]);
  va_end(argList);
}

@implementation AZLog @synthesize logEnv = _logEnv;  //- (void) setUp { _logEnv = LogEnvUnknown; }


-   (void) logThese:(const char *)pretty things:(id)colorsAndThings,...	{  // This does Bienvenidos, etc, pretty coplors..

  __block NSMA *colors = NSMA.mutableArrayUsingWeakReferences, *words  = NSMA.mutableArrayUsingWeakReferences;

  AZVA_Block sort = ^(id it) { objswitch(it)

    objkind(NSC) [colors addObject:it];
    objkind(NSS) [words  addObject:it];
    objkind(NSA) ALLARE(it,NSC) ? [colors addObjectsFromArray:it]
    : [words addObjectsFromArray:[(NSA*)it map:^id(id obj) { return [obj debugDescription]; }]];
    defaultcase  [words addObject:it[@"debugDescription"]?:[it description]];
    endswitch
  };

  azva_iterate_list(colorsAndThings, sort);

  if (!words.count)   ({ printf( "WARNING, NO WORDS TO PRINT: %s", pretty); return; });
  if (!colors.count)  colors = RANDOMPAL.mutableCopy;

  [words addObject:zNL];

  fprintf(stdout, "%s", [[words reduce:NSMS.new withBlock:^NSS*(NSMS *sum,NSS *o) { // LOG_CALLER_VERBOSE ? @"LOGCOLORS: ":@""

    [sum appendString:[o isEqualToAnyOf:@[@" ",@"\n", @""]] ? o : ([o setLogForeground:colors.nextNormalObject], o.clr)];  return sum;

  }] UTF8String]);

  //		NSC  *c = [colors advance];
  //     c.isDark ? [c colorWithBrightnessMultiplier:2]: c;
  //		return [sum withString:o.colorLogString];
  //	}
  //	else return  o]; }]UTF8String]);
}

#pragma mark - Class Util

+ (NSA*) rgbColorValues:(id)color																		{

  __block CGF r = 255., g = 255., b= 255.;  __block NSC *x;

  if (ISA(color,NSS))		{ x = [NSC colorWithName:color] ?: [NSC colorWithCSSRGB:color] ?: RED;
    r = (x.redComponent * 255); g = (x.greenComponent * 255); b = (x.blueComponent * 255);
  }
  else if (ISA(color, NSC))	{ x = color;  x = x.isDark ? [x colorWithBrightnessOffset:2] : x;
    x = [x colorUsingColorSpace:NSColorSpace.genericRGBColorSpace];
    r = (x.redComponent * 255); g = (x.greenComponent * 255); b = (x.blueComponent * 255);
  }
  else if (ISA(color,NSA) && [color count] == 3) {
    r = [color[0] fV]; g = [color[1] fV]; b = [color[2] fV];
    r = r < 1.0 ? r *255. : r; g = g < 1.0 ? g *255. : g; b = b < 1.0 ? b *255. : b;

  }
  return @[@(r), @(g), @(b)];
}
+ (NSS*) colorizeString:(NSS*)string front:(id)front back:(id)back  {
  if (front) [string setLogForeground:front];
  if (back)  [string setLogBackground:back];
  return string;
}
+ (NSS*) colorizeString:(NSS*)string withColor:(id)color						{
  return [self colorizeString:string front:color back:nil];
}
+ (NSA*) colorizeAndReturn:(id) colorsAndThings, ...								{

  __block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;

  AZVA_Block sort   = ^(id thing) { ISA(thing,NSC) ? [colors addObject:thing] : [words addObject:thing]; };
  AZVA_Block theBlk = ^(id thing) { ISA(thing,NSA) ? [(NSA*)thing each:^(id obj){ sort(thing); }] : sort (thing); };

  azva_iterate_list(colorsAndThings, theBlk);
  return [words nmap:^id (id o, NSUI i) {
    NSS *n = $(@"%@", o); NSC *c  = [colors normal:i];
    n.logForeground = c.isDark ? c.invertedColor : c;  return n;
  }];
}

#pragma mark - Properties

JREnum(zLoggingTo,
    kLoggingToOther,
    kLoggingToFile,
    kLoggingToTTY,
    kLoggingToColorTTY,     // Terminal that supports ANSI color escape codes
    kLoggingToColorXcode    // Xcode with XcodeColors plugin installed
)



/** Does the file descriptor connect to console output, i.e. a terminal or Xcode? */
+ (NSString *) log {

  AZSTATIC_OBJ(NSS, getLoggingMode, ^{

    int fd = STDERR_FILENO;
      if( isatty(fd) ) {
          const char *xcode_colors = getenv("XcodeColors");
          if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
              return zLoggingToToString(kLoggingToColorXcode);

          const char *term = getenv("TERM");
          if( term && (strstr(term,"ANSI") || strstr(term,"ansi") || strstr(term,"color")) )
              return zLoggingToToString(kLoggingToColorTTY);
          else
              return zLoggingToToString(kLoggingToTTY);
        } else {
  #if GNUSTEP
          return zLoggingToToString(kLoggingToFile);
  #else
          char path[MAXPATHLEN];
          if( fcntl(fd, F_GETPATH, path) == 0 )
              return zLoggingToToString(kLoggingToFile);
          else
              return zLoggingToToString(kLoggingToOther);
  #endif
        }
  }());
  return getLoggingMode;
}



//- (LogEnv) logEnv	{ if (_logEnv) return _logEnv;
//
//  BOOL isXcode = [NSProcessInfo.processInfo.arguments[0] containsString:@"Xcode"];
//  BOOL useXCColors = NSProcessInfo.processInfo.environment[@"XCODE_COLORS"];
//
//  _logEnv = isXcode ||  SameString(term,@"YES") ? LogEnvXcodeColors // : SameString(term,@"NO")  ? LogEnvXcodeNOColor
//  :	isatty(STDERR_FILENO) && (term = AZPROCINFO.environment[@"TERM"])
//  ? [term containsAllOf:@[@"color",@"256"]] ? LogEnvTTY256
//  : [term contains:@"color"]								? LogEnvTTYColor
//  : LogEnvTTY : LogEnvError;  //: LogEnvUnknown
//
//  JATLog(@"LOGENV:{0} isXcode:{isXcode} term:{term}", LogEnvToString(_logEnv), isXcode, term);
//
//  return _logEnv;
//}

# pragma mark -+*%$%*+-+*%$%*+-+*%$-+*%$%*+-+*%$%*+-+*%$-+*%$%*+-+*%$%*+- ACTIVE NSLOG

-(void) logInColor:(id)colr file:(const char*)file
              line:(int)ln  func:(const char*)fnc format:(id)fmt,...{

  static NSArray *logPalette; logPalette = logPalette ?: RANDOMPAL;

  if (!fmt || ISNOTA(fmt,NSS)) return NSLog(@"you tried formatting with a %@, not a string!", [fmt className]);

  // Get a reference to the arguments that follow the format parameter
  va_list argList;  va_start(argList, fmt);

  // Perform format string argument substitution, reinstate %% escapes, then print
  NSS *s,*funcString = $UTF8(fnc);

  if ((s = [NSS.alloc initWithFormat:fmt arguments:argList]) && s.length)
    printf("%s %s[%s %i] %s" CHAR_RESET "\n", [s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"].UTF8String,
           self.logEnv == LogEnvXcodeColors ? CHAR_ESCAPE "fg13,144,144;" : "",
           $UTF8(file).lastPathComponent.UTF8String, ln, funcString.UTF8String);
  va_end(argList);
}
- (void) logMessage:(NSLogMessage*)msg { printf("%s\n", [AZLog colorizeString:msg.JSONRepresentation front:RANDOMCOLOR back:RANDOMCOLOR].cchar); }

@end

@implementation NSString (AtoZColorLog)

-        (NSS*) times:(NSUI)x           { return [self stringByPaddingToLength:x withString:self startingAtIndex:0]; }
-				 (void) setLogForeground:(id)f  {	//	printf("setting fg: %s", ((NSC*)color).nameOfColor.UTF8String);
  objc_setAssociatedObject(self, __VSTR(@"logFG"), [AZLog rgbColorValues:f], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-				 (void) setLogBackground:(id)b  {
  objc_setAssociatedObject(self, __VSTR(@"logBG"), [AZLog rgbColorValues:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (const char*) cchar                   {  return self.clr.UTF8String; }
-        (NSS*) colorLogString					{

  NSA *fgs = [self hasAssociatedValueForKey:@"logFG"] ? [self associatedValueForKey:@"logFG"] : nil;
  NSA *bgs = [self hasAssociatedValueForKey:@"logBG"] ? [self associatedValueForKey:@"logBG"] : nil;
  if (!fgs && !bgs) return self;
  NSS *colored = self.copy;
  if ((( fgs && fgs.count == 3) || (bgs && bgs.count ==3) ) && AZLOGSHARED.logEnv == LogEnvXcodeColors) {
    if (fgs && fgs.count ==3) {
      colored = $(XCODE_COLORS_ESCAPE @"fg%i,%i,%i;%@" XCODE_COLORS_RESET,
                  [fgs[0] intValue], [fgs[1] intValue], [fgs[2] intValue], colored);
    }
    if (bgs && bgs.count ==3) {
      colored = colored ? : self;
      colored = $(XCODE_COLORS_ESCAPE @"bg%i,%i,%i;%@" XCODE_COLORS_RESET,
                  [bgs[0] intValue], [bgs[1] intValue], [bgs[2] intValue], colored);
    }
    return colored;
  }
  if (AZLOGSHARED.logEnv == LogEnvTTYColor || AZLOGSHARED.logEnv == LogEnvTTY256){
    static NSArray* cs, *bg;
    cs = cs ?: @[@31,@32,@33,@34,@35,@36,@37];
    bg = bg ?: @[@40,@41,@42];//,@43,@44,@45,@46,@47];
    return [NSString stringWithFormat:@"\033[%@;%@m%@\033[0m", [cs[arc4random() % 7 ]stringValue],
            [bg[arc4random() % 3 ]stringValue], self];
  }
  else return self;
}
@end




@implementation AZASLEntry @end

@implementation AZASLLogger

//- (Class) objectClass { return NSTN.class; }

- init		{	return self = super.init ? _log = @{}.mC, [self startLogging], self : nil; } // )) self.objectClass = NSTN.class; self.selectsInsertedObjects = YES; [self log]; return self; }

- (void) ConfigureQuery:(aslmsg)query { const char param[] = "5";	// ASL_LEVEL_NOTICE

  asl_set_query(query, ASL_KEY_LEVEL, param, ASL_QUERY_OP_LESS_EQUAL | ASL_QUERY_OP_NUMERIC);
}

- (void) MessageRecieved:(aslmsg)msg {

  const char  * sender  = asl_get(msg, ASL_KEY_SENDER),
              * message = asl_get(msg, ASL_KEY_MSG);

  printf("%s: %s\n", sender, message);

  NSString *ssender = $(@"%s",sender);

  AZASLEntry *n =  AZASLEntry.new;

  [n setValuesForKeysWithDictionary:@{@"sender":ssender, @"message":$(@"%s", message)}];

  NSMA *senderEntry = _log[ssender] ?: (_log[ssender] = @[].mC);

  [senderEntry addObject:n];

//  [self addObject:@{ @"title": @"BOOKS", @"isLeaf": @(NO), @"children":@[
//                                        [Book bookWithTitle:@"Pride and Prejudice"    andAuthor:@"Jane Austen"],
//                                        [Book bookWithTitle:@"To Kill a Mockingbird"  andAuthor:@"Harper Lee"],
//                                        [Book bookWithTitle:@"The Catcher in the Rye" andAuthor:@"J.D. Salinger"]].mutableCopy }.mutableCopy];

//  NSTN *node  = [self.content filteredArrayUsingBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//
//    return [[evaluatedObject representedObject] isEqualToString:ssender];
//
//  }].firstObject;
//
//  if (!node) [self addObject: node = [NSTN treeNodeWithRepresentedObject:ssender]];
//
//  [node.mutableChildNodes addObject:n];

//  }
}
    ////[NSString stringWithFormat:@"%s: %s\n", sender, message]];


- (void) startLogging    {

    /*
     We use ASL_KEY_MSG_ID to see each message once, but there's no
     obvious way to get the "next" ID. To bootstrap the process, we'll
     search by timestamp until we've seen a message.
     */

    struct timeval timeval = { .tv_sec = 0 };
    gettimeofday(&timeval, NULL);
    unsigned long long startTime = timeval.tv_sec;
    __block unsigned long long lastSeenID = 0;

/*!
     syslogd posts kNotifyASLDBUpdate (com.apple.system.logger.message) through the notify API when it saves messages to the ASL database.
     There is some coalescing - currently it is sent at most twice per second - but there is no documented guarantee about this. In any case, there may be multiple messages per notification.
     Notify notifications don't carry any payload, so we need to search for the messages.
*/
    int notifyToken;	// Can be used to unregister with notify_cancel().
    notify_register_dispatch(kNotifyASLDBUpdate, &notifyToken, dispatch_get_main_queue(), ^(int token) {
        // At least one message has been posted; build a search query.
      @autoreleasepool
      {
        aslmsg query = asl_new(ASL_TYPE_QUERY);
        char stringValue[64];
        if (lastSeenID > 0)
        {
          snprintf(stringValue, sizeof stringValue, "%llu", lastSeenID);
          asl_set_query(query, ASL_KEY_MSG_ID, stringValue, ASL_QUERY_OP_GREATER | ASL_QUERY_OP_NUMERIC);
        }
        else
        {
          snprintf(stringValue, sizeof stringValue, "%llu", startTime);
          asl_set_query(query, ASL_KEY_TIME, stringValue, ASL_QUERY_OP_GREATER_EQUAL | ASL_QUERY_OP_NUMERIC);
        }
        [self ConfigureQuery:query];

          // Iterate over new messages.
        aslmsg msg;
        aslresponse response = asl_search(NULL, query);
        while ((msg = aslresponse_next(response)))
        {
            // Do stuff.
          [self MessageRecieved:msg];

            // Keep track of which messages we've seen.
          lastSeenID = atoll(asl_get(msg, ASL_KEY_MSG_ID));
        }
        aslresponse_free(response);
      }
    });

}
- (void) watch	{
/*
  /// We use ASL_KEY_MSG_ID to see each message once, but there's no obvious way to get the "next" ID. To bootstrap the process, we'll search by timestamp until we've seen a message.

  struct timeval						  timeval	= { .tv_sec = 0 };		gettimeofday(&timeval, NULL);
  unsigned long long			  startTime	= timeval.tv_sec;
		__block unsigned long long lastSeenID = 0;

		// syslogd posts kNotifyASLDBUpdate (com.apple.system.logger.message) through the notify API when it saves messages to the ASL database.
    // There is some coalescing - currently it is sent at most twice per second - but there is no documented guarantee about this. In any case, there may be multiple messages per notification.

    // Notify notifications don't carry any payload, so we need to search for the messages.


  int notifyToken;	// Can be used to unregister with notify_cancel().

  notify_register_dispatch(kNotifyASLDBUpdate, &notifyToken, dispatch_get_main_queue(),^(int token) {	@autoreleasepool	{		// At least one message has been posted; build a search query.

    aslmsg    query	= asl_new(ASL_TYPE_QUERY);		char stringValue[64];

				lastSeenID	? snprintf(stringValue, sizeof stringValue, "%llu", lastSeenID) : snprintf(stringValue, sizeof stringValue, "%llu", startTime);
				lastSeenID	? asl_set_query(query, ASL_KEY_MSG_ID, stringValue, ASL_QUERY_OP_GREATER			 | ASL_QUERY_OP_NUMERIC)
    : asl_set_query(query, ASL_KEY_TIME,	 stringValue, ASL_QUERY_OP_GREATER_EQUAL | ASL_QUERY_OP_NUMERIC);

				[self ConfigureQuery:query]; aslmsg msg;		// Iterate over new messages.
				aslresponse response = asl_search(NULL, query);

				NSString *lastSender = nil, *newSender = nil;		NSTreeNode *node;

				while ((msg =	aslresponse_next(response))) {

          newSender =		[NSString stringWithUTF8String:asl_get(msg, ASL_KEY_SENDER)];

          if (lastSender && newSender && [lastSender isEqualToString:newSender])
            node = node ?:	[NSTreeNode treeNodeWithRepresentedObject:lastSender = newSender];
          else      node ?  [self addObject:node] : nil,
            [self addObject:node =	[NSTreeNode treeNodeWithRepresentedObject:lastSender = newSender]];

          [node.mutableChildNodes                     addObject:
           [NSTreeNode treeNodeWithRepresentedObject:
											 [NSString           stringWithUTF8String: asl_get(msg, ASL_KEY_MSG)]]];


          printf("%ld Nodes: Current node:%s children:%ld\n", [self.arrangedObjects count], lastSender.UTF8String, node.childNodes.count);

          lastSeenID = atoll(asl_get(msg, ASL_KEY_MSG_ID)); // Keep track of which messages we've seen.
        }
    aslresponse_free(response);
		}
  });
  */
}

- (NSW*) show   {

  _show = [NSWindow.alloc initWithContentRect:NSInsetRect(NSScreen.mainScreen.frame,200,200) styleMask:0|1|2|8 backing:0 defer:NO];
  _show.level = NSScreenSaverWindowLevel;
  NSScrollView *v;  _show.contentView = v = [NSScrollView.alloc initWithFrame:[_show.contentView bounds]];
  NSOutlineView *o; v.documentView = o = [NSOutlineView.alloc initWithFrame:v.bounds];
  NSTableColumn *t; [o addTableColumn:t=[NSTableColumn.alloc initWithIdentifier:@"value"]];
  [t bind:NSValueBinding toObject:self withKeyPath:@"arrangedObjects.representedObject" options:nil];
  [_show makeKeyAndOrderFront:nil]; return _show;
}

#pragma mark - NSOutlineViewDelegate

OVMETHOD (BOOL)      isGroupItem:item                 { return ISA(item,NSTN); }

OVMETHOD (BOOL) shouldSelectItem:item                 { return !ISA(item,NSTN); }

OVMETHOD (NSV*) viewForTableColumn:(NSTC*)t item:item {

  return ISA(item,NSTN)       ? !ISA(((NSTN*)item).representedObject,AZASLEntry) ? [ov makeViewWithIdentifier:@"HeaderCell" owner:self]
       : ISA(item,AZASLEntry) ? [ov makeViewWithIdentifier:@"DataCell"   owner:self] : nil : nil;
}

@end

/*
-   (id) init		{	if (!(self = super.init)) return nil; self.childrenKeyPath = @"childNodes"; self.content = @[[NSTreeNode treeNodeWithRepresentedObject:@"LOGS"]].mutableCopy;  return self; }


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{        
  return [item isFolder]
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{    
    if (item==nil)
    {
        // Root
        return [[filePath folderContentsWithPathAndBackIgnoringHidden] count];
    }
    else
    {        
        if ([item isFolder])
        {
            return [[item folderContentsWithPathAndBackIgnoringHidden] count];
        }
        else
        {
            return 0;
        }
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil)
    { 
        // Root
        return [[filePath folderContentsWithPathAndBackIgnoringHidden] objectAtIndex:index];
    }

    if ([item isFolder])
    {
        return [[item folderContentsWithPathAndBackIgnoringHidden] objectAtIndex:index];
    }

    // File
    return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)theColumn byItem:(id)item
{          
    if ([[theColumn identifier] isEqualToString:@"NameColumn"])
    {
        return [item lastPathComponent];
    }
    else if ([[theColumn identifier] isEqualToString:@"SizeColumn"])
    {
        if ([item isFolder]) return @"--";
        else return [NSString stringWithFormat:@"%d",[item getFileSize]];
    }
    else if ([[theColumn identifier] isEqualToString:@"ModifiedColumn"])
    {
        if ([item isFolder]) return @"";
        else return [NSString stringWithFormat:@"%@",[item getDateModified]];
    }

    // Never reaches here
    return nil;
}


OVMETHOD(BOOL) isItemExpandable:_ { return ISA(_,NSD); }

OVMETHOD(NSI) numberOfChildrenOfItem:_ {


    return !_ ? senders.count :  // item is nil when the outline view wants to inquire for root level items
    }   

    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"children"] count];
    }

    return 0;
}

OVMETHOD(id) child:(NSI)i ofItem:_ {

    return !_ ? senders.allValues[i] //item is nil when the outline view wants to inquire for root level items



    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"children"] objectAtIndex:index];
    }     

    return nil;
}

OVMETHOD(id) objectValueForTableColumn:(NSTC*)c byItem:_ {

    return [c.identifier isEqualToString:@"children"] ? ISA(_,NSD) ? $(@"%lu kids", [_[@"children"] count])
                                                                   : _ : ISA(_,NSD) ? _[@"parent"] : nil;
}
*/

/*
 e != LogEnvXcodeColor ? [words componentsJoinedByString:@" "].UTF8String :
 [(NSA*)it each:^(id obj) {
 [obj ISKINDA:NSC.class] ? [colors addObject:[obj copy]] :
 [obj ISKINDA:NSS.class] ? [words  addObject:[obj copy]] : nil;
 NSS* first = [obj firstResponsiveString:@[@"stringValue", @"name"]];
 if (first) [words addObject:[obj vFK:first]]; }]:
 NSS* first = [it firstResponsiveString:@[@"stringValue", @"name"]];
 ? [words addObject:[[ it stringValue]copy]] : nil;
	NSLog(@"colors:%ld:%@ words:%ld:%@", colors.count, colors, words.count, words);
	NSA *colors, *words, *colorStringArray;  colorStringArray = colors1strings2(colorsAndThings); colors = colorStringArray[0]; words = colorStringArray[1];


 int main(int argc, const char * argv[])	{	@autoreleasepool {	id x = [NSApplication sharedApplication]; [x setActivationPolicy:NSApplicationActivationPolicyRegular];

	SysLogger *s; [s = SysLogger.new watch]; [s show]; [NSApp run];
 //	/dispatch_main();
	}

 } 		// Run forever.


 NSA * COLORIZE		  ( id colorsAndThings, ...

 - (BOOL) inTTY 			{   return [@(isatty(STDERR_FILENO))boolValue]; }
 of ([tty sharedInstance]) 		objc_msgSend([tty class],
 NSSelectorFromString( isaColor256TTY ? @"initialize_colors_256" : @"initialize_colors_16"));
 Xcode does NOT natively support colors in the Xcode debugging console.
 You'll need to install the XcodeColors plugin to see colors in the Xcode console
 NSS *xcode_colors = $UTF8(getenv("XcodeColors"));
 isaXcodeColorTTY = xcode_colors && SameString(xcode_colors,@"YES");
 }();
 fprintf(stdout, "%sisaColorTTY\t=\t%s%s\t%sisaColor256TTY\t=\t%s%s\t%s\n",
 isaColorTTY ? "\033[38;5m" : "",  isaColorTTY ? "YES" : "NO", isaColorTTY ? "\033[0m" : "",
 isaColorTTY ? "\033[38;5m" : "",  isaColor256TTY ? "YES" : "NO", isaColorTTY ? "\033[0m" : "",
 $(@"%@isaXcodeColorTTY\t=\t%@%@",isaXcodeColorTTY ? XCODE_COLORS_ESCAPE @"fg244,100,80;" : zSPC, StringFromBOOL(isaXcodeColorTTY), isaXcodeColorTTY ? XCODE_COLORS_RESET : @"").UTF8String);

 azva_list_to_nsarray(fmt, FORMATTER)
 NSMS * formateed = [fmt mutableCopy];
 [FORMATTER each:^(id obj) {
 if (![formateed containsString:@"%"]) return;  NSRNG r = [formateed rangeOfString:@"%"]; r.length++; [formateed replaceCharactersInRange:r withString:obj];
 }];
 [((NSS*)formateed) setLogForeground:colr];
 fprintf(stdout,"%s",formateed.clr.UTF8String);


 [self logNilTerminatedListOfColorsAndStrings:file things:[NSString stringWithFormat:fmt arguments:VA_A]]
 va_list argList;  va_start(argList,fmt);	NSS *path = nil, *fullPath = nil; __block NSS *lineNum = nil,*mess = nil,*func = nil,*output = nil; __block NSUI numberofspaces;

 fullPath = file ? $UTF8(file) : nil;
 if (fullPath) path = [[@"[" withString:[fullPath contains:@"/"] ? [fullPath lastPathComponent] : fullPath]withString:@"]"];
 /// : @"";
 mess 	= [NSS stringWithFormat:fmt arguments:argList];

 //:fl lineNumber:ln];setFakeStdin:$(@"%@%i%s%@",path, line, funcName, mess)];
 self.logEnv == LogEnvXcodeColor ? ^{

 path.logForeground 		= gPal [0];
 lineNum						= $( @":%i ", ln );
 lineNum.logForeground 	= gPal [1];
 numberofspaces		 		=      10;	//MIN(MAX((paddedString.length - concat.length), 2), 20);
 func  						= [$UTF8(fnc) truncateInMiddleToCharacters:30];
 func.logForeground 		= [gPal[2] darker];
 //	output = $(@"%@%@", path.colorLogString, lineNum.colorLogString);   //, [NSS spaces:numberofspaces]);
 NSC* messColor				= clr 	? : gPal [4];
 mess.logForeground      = messColor;
 mess 							= mess.colorLogString ?: mess;  //  actual log message

 output 						= [mess paddedTo:120];//withString:output];
 output 						= [output withString:func.colorLogString];
 //	[func containsAnyOf:@[@"///Color"]] ? @"" : func.colorLogString];	//	fflush(stdout);
 [NSTerminal printString:output];
 ///		fprintf(stderr, "%s\n", output.UTF8String);

 }() : [NSTerminal printString:mess];

 //		[%@]:%i @"%s* / @"%@\n", / / * path, line, funcName,* /
 //										XCODE_COLORS_ESCAPE @"fg140,140,140;"   @":%i"  XCODE_COLORS_RESET
 //										XCODE_COLORS_ESCAPE @"fg109,0,40;"  @" %s "		 XCODE_COLORS_RESET
 //										XCODE_COLORS_ESCAPE @"%@" "%@"XCODE_COLORS_RESET @"\n",
 //										path,
 //										line, funcName,
 //										colorString,
 //										mess)
 //	 toLog.UTF8String);//
 va_end(argList);

 - (const char*) ttyClr {
 BOOL inTTY =  [@(isatty(STDERR_FILENO))boolValue];
 if (inTTY) return s;
 NSArray* cs = @[@31,@32,@33,@34,@35,@36,@37];
 NSArray* bg = @[@40];//,@41,@42,@43,@44,@45,@46,@47];
 NSNumber* num = cs[arc4random() % 7 ];
 NSNumber* nub = bg[arc4random() % 1 ];
 NSString *let = [num stringValue];
 NSString *blet = [nub stringValue];
 return [NSString stringWithFormat:@"\033[%@;%@m%@\033[0m - %@", let,blet, s, num];
 }
 BLINKING	 "\033[38;5mWhatever\033[0m"
 Log levels: off, error, warn, info, verbose
 static const int ddLogLevel = LOG_LEVEL_VERBOSE;

 void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
 va_list arglist;

 va_start (arglist, format);
 if (![format hasSuffix: @"\n"]) {
 format = [format stringByAppendingString: @"\n"];
 }
 NSString *body =  [NSString.alloc initWithFormat: format arguments: arglist];
 va_end (arglist);
 const char *threadName = [[[NSThread currentThread] name] UTF8String];
 NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
 //	if (threadName) {
 //		fprintf(stderr,"%s/%s (%s:%d) %s",threadName,funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
 //	} else {
 //		fprintf(stderr,"%p/%s (%s:%d) %s",[NSThread currentThread],funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
 //	}
 #ifdef PRINTMETHODS
 fprintf(stderr,"%s:%d [%s] %s",[fileName UTF8String],lineNumber,funcName, [body UTF8String]);
 #else
 fprintf(stderr,"line:%d %s",lineNumber, [body UTF8String]);
 #endif
 //
 [body release];
 }

 void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);

 void QuietLog (const char *file, int lineNumber, const char *funcName, NSString *format, ...) {
 if (format == nil) {
 printf("nil\n");
 return;
 }
 // Get a reference to the arguments that follow the format parameter
 va_list argList;
 va_start(argList, format);
 // Perform format string argument substitution, reinstate %% escapes, then print
 NSString *s = [[NSString.alloc initWithFormat:format arguments:argList]stringByReplacingAllOccurancesOfString:@"fff" withString:@"%.1f"];
 //for float the format specifier is %f and we can restrict it to print only two decimal place value by %.2f
 printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
 [s release];
 va_end(argList);
 }
 void QuietLog (NSString *format, ...) { if (format == nil) { printf("nil\n"); return; }
 // Get a reference to the arguments that follow the format parameter
 va_list argList;  va_start(argList, format);
 // Perform format string argument substitution, reinstate %% escapes, then print
 NSString *s = [NSString.alloc initWithFormat:format arguments:argList];
 printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
 [s release];
 va_end(argList);
 }
 NSLog() writes out entirely too much stuff.  Most of the time I'm  not interested in the program name, process ID, and current time down to the subsecond level.
 This takes an NSString with printf-style format, and outputs it. regular old printf can't be used instead because it doesn't support the '%@' format option.
 void QuietLog (NSString *format, ...) {
 va_list argList;	va_start (argList, format);
 NSString *message = [NSString.alloc initWithFormat:format arguments:argList];
 fprintf (stderr, "*** %s ***\n", [message UTF8String]);	 va_end  (argList);
 } // QuietLog
 NSUInteger fgCodeIndex;	NSString *fgCodeRaw;	char fgCode[24];	size_t fgCodeLen;	char resetCode[8];	size_t resetCodeLen;

 if (fgs && isaColorTTY) {
 NSC*fgColor = [NSC r:[fgs[0] floatValue] g:[fgs[1]floatValue] b:[fgs[2] floatValue] a:1];
 // Map foreground color to closest available shell color
 fgCodeRaw   = DDTTYLogger.codes_fg[fgCodeIndex];
 NSString *escapeSeq = @"\033[";
 NSUInteger len1 = [escapeSeq lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
 NSUInteger len2 = [fgCodeRaw lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
 [escapeSeq getCString:(fgCode)      maxLength:(len1+1) encoding:NSUTF8StringEncoding];
 [fgCodeRaw getCString:(fgCode+len1) maxLength:(len2+1) encoding:NSUTF8StringEncoding];

 fgCodeLen = len1+len2;
 }
 NSS* save = [AZTEMPD withPath:@"whatever.txt"];
 [@{@"color": colored } writeToFile:save atomically:YES];
 printf("%s", save.UTF8String);
 return colored ? : self;//@"Something went wrong";
 else if (fgColor && isaXcodeColorTTY)
 {
 Convert foreground color to color code sequence
 const char *escapeSeq = XCODE_COLORS_ESCAPE_SEQ;
 int result = snprintf(fgCode, 24, "%sfg%u,%u,%u;", escapeSeq, fg_r, fg_g, fg_b);
 fgCodeLen = MIN(result, (24-1));
 }
 else
 {
 // No foreground color or no color support

 fgCode[0] = '\0';
 fgCodeLen = 0;
 }

 //void _AZColorLog		( id color, const char *filename, int line, const char *funcName, id format, ...) {

 if (!gPal) gPal = NSC.randomPalette;
 va_list argList;  va_start(argList,format);	__block NSS *lineNum,*path,*mess,*func,*output; __block NSUI numberofspaces;

 path	= $(@"[%@]", $UTF8(filename).lastPathComponent);
 mess 	= [NSS stringWithFormat:format arguments:argList];

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
 fprintf(stderr, "%s\n", output.UTF8String);

 }() : ^{ fprintf(stderr, "%s", $(/ *@"[%@]:%i @"%s* / @"%@\n",/ * path, line, funcName,* / mess).UTF8String); return; }();
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


 typedef NSA*(^SeperateColorsThenStrings)(id colorsAndThings);
 AZVA_Block theBlk = ^(id thing) { [thing ISKINDA:NSC.class] ? [colors addObject:thing] : [words addObject:thing]; };

 SeperateColorsThenStrings colors1strings2 = ^(id colorsAndThings){

 __block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;
 azva_iterate_list(colorsAndThings, theBlk);
 return @[Block_copy(colors), Block_copy(words)];
 };

 +(BOOL) inTTY 					{   return [@(isatty(STDERR_FILENO))boolValue]; }
 LogEnv AZLogEnv(void) 		{

 if (inTTY()) return LogEnvTTY;
 char *XcodeSaysColor	= getenv("XCODE_COLORS");
 return XcodeSaysColor != NULL && SameChar(XcodeSaysColor,"YES") ? LogEnvXcodeColor :  LogEnvXcodeNOColor;
 }

 #define LOG_CALLER_VERBOSE NO		// Rediculous logging of calling method
 #define LOG_CALLER_INFO	YES		// Slighlty less annoying logging of calling method

 NSA * rgbColorValues			 	             (id color) 				{
 __block float r, g, b;  __block NSC *x;									   //  printf("%s", $(@"%@",[color class]).UTF8String);

 if ([color ISKINDA:NSS.class]) x = [NSC colorWithName:color] ? : [NSC colorWithCSSRGB:color] ? : RED;

 ISA(color, NSC) ? ^{	 x = color;  x = x.isDark ? [x colorWithBrightnessOffset:2] : x;
 x = [x colorUsingColorSpace:NSColorSpace.genericRGBColorSpace];
 r = (x.redComponent * 255); g = (x.greenComponent * 255); b = (x.blueComponent * 255);					} ()

 : ISA(color, NSA) && [color count] == 3 ? ^{
 r = [color[0] integerValue]; g = [color[1] integerValue]; b = [color[2] integerValue];
 } () : nil;  return @[@(r), @(g), @(b)];
 }
 NSS * colorizeStringWithColors (NSS *string, id front, id back)	{				//NSA *rgbs;
 if (front) [string setLogForeground:front];
 if (back)  [string  setLogBackground:back];
 return string;
 }
 NSS * colorizeStringWithColor	 (NSS *string, id color) 				{
 return colorizeStringWithColors(string, color, nil);
 }

 // Pass a variadic list of Colors, and Ovjects, in any order, TRMINATED BY NIL, abd it wiull use those colors to log those objects!
 NSA * COLORIZE		  ( id colorsAndThings, ... )							{
 __block NSMA *colors = NSMA.new;  __block NSMA *words  = NSMA.new;

 AZVA_Block sort   = ^(id thing) { [thing ISKINDA:NSC.class] ? [colors addObject:thing] : [words addObject:thing]; };
 AZVA_Block theBlk = ^(id thing) { if ([thing ISKINDA:NSA.class])  [(NSA*)thing each:^(id obj) {   sort(thing);		}];
 else sort (thing);
 };

 azva_iterate_list(colorsAndThings, theBlk);   return [words nmap:^id (id o, NSUI i) { NSS *n = $(@"%@", o); NSC *c  = [colors normal:i];  n.logForeground = c.isDark ? c.invertedColor : c;  return n; }];
 }
 void logNilTerminatedListOfColorsAndStrings ( const char*pretty, id colorsAndThings,...) 	{

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
 fprintf(stderr, "%s", //e != LogEnvXcodeColor ? [words componentsJoinedByString:@" "].UTF8String :

 [[words reduce:LOG_CALLER_VERBOSE ? @"LOGCOLORS: ":@"" withBlock:^NSS*(NSS *sum,NSS *o) {
 NSC  *c 				= [colors normal:ctr];	ctr++;
 o.logForeground 	= c.isDark ? [c colorWithBrightnessMultiplier:2]: c;
 return [sum withString:o.colorLogString];
 }]UTF8String]);
 }
 void WEBLOG (id format, ...) {

 AZLogConsoleView* e = (AZLogConsoleView*)[AZLogConsole.sharedConsole webView];
 [e logString: file:(char*)filename lineNumber:(int)lineNum];

 }
 void _AZColorLog		( id color, const char *filename, int line, const char *funcName, id format, ...) {

 if (!gPal) gPal = NSC.randomPalette;
 va_list argList;  va_start(argList,format);	__block NSS *lineNum,*path,*mess,*func,*output; __block NSUI numberofspaces;

 path	= $(@"[%@]", $UTF8(filename).lastPathComponent);
 mess 	= [NSS stringWithFormat:format arguments:argList];

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
 fprintf(stderr, "%s\n", output.UTF8String);

 }() : ^{ fprintf(stderr, "%s", $(/ *@"[%@]:%i @"%s* / @"%@\n",/ * path, line, funcName,* / mess).UTF8String); return; }();
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


 #ifdef DEBUG  // Log levels: off, error, warn, info, verbose
 static const int ddLogLevel = LOG_LEVEL_VERBOSE;
 #else
 static const int ddLogLevel = LOG_LEVEL_WARN;
 #endif
 BOOL isXcodeColorsEnabled = (getenv("XcodeColors")  && (strcmp(getenv("XcodeColors"),  "YES") == 0) ||
 getenv("XCODE_COLORS") && (strcmp(getenv("XCODE_COLORS"), "YES") == 0));
 Perform format string argument substitution, reinstate %% escapes, then print
 NSString *s,*funcString = $UTF8(fnc);

 funcString = [funcString containsString:@"_block_invoke"] ? $(@"[%@ (block)", [[funcString substringAfter:@"["] stringByDeletingSuffix:@"_block_invoke"]) : funcString;
 if ((s = [NSString.alloc initWithFormat:fmt arguments:argList]) && s.length)
 printf("%s %s[%s %i] %s" CHAR_RESET "\n",[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"].UTF8String, self.logEnv == LogEnvXcodeColor ? CHAR_ESCAPE "fg13,144,144;" : "", $UTF8(file).lastPathComponent.UTF8String, ln, funcString.UTF8String);


 ![lM.methodName containsString:@"_block_invoke"] ? lM.methodName : $(@"[%@ (block)", [[lM.methodName substringAfter:@"["] stringByDeletingSuffix:@"_block_invoke"]));// [x clr], [lM.methodName substringToIndex:20]); // lM.fileName lM->lineNumber);
 int  DDLEVEL2INT			  (DDLogMessage*m)	{ int dd = m->logFlag; return dd == LOG_FLAG_ERROR ? 0 : dd == LOG_FLAG_WARN ? 1 : dd == LOG_FLAG_INFO ? 2 : 3; }
 NSS* DDLEVEL2STRING		  (DDLogMessage*m) 	{	int dd = m->logFlag; return dd == LOG_FLAG_ERROR ? @"ERR" : dd == LOG_FLAG_WARN ? @"WARN" : dd == LOG_FLAG_INFO ? @"INFO" : @"VERBOSE"; }
 NSS *logLevel = lM->logFlag == LOG_FLAG_ERROR ? @"ERROR  " : lM->logFlag == LOG_FLAG_INFO     ? @"INFO   " :
 lM->logFlag == LOG_FLAG_WARN  ? @"WARNING" : lM->logFlag == LOG_FLAG_VERBOSE  ? @"VERBOSE" : @"";
 id x = [lM->logMsg paddedRightTo:100]; [x setLogForeground:AtoZ.globalPalette.nextNormalObject];
 lM->logMsg 		lM->file		lm->lineNumber	lM->function	lM.fileName	DDLEVEL2STRING(lm) addLEVEL2INT(lM)
 NSS* file = $(@"[%@]", [$UTF8(lM->file).lastPathComponent stringByDeletingPathExtension]);
 file = [[file truncateInMiddleToCharacters:12]paddedTo:12];
 file = [AZLog colorizeString:file withColor:GREEN];
 printf("%s", file.UTF8String); return $(@"%@:%i%@", file , lM->lineNumber, lM->logMsg); }
 
 */

