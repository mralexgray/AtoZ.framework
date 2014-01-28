
#import "KSHTMLWriter+AtoZ.h"

@implementation KSHTMLWriter (AtoZ)	static KSStringWriter *writer = nil; static id shared = nil; 	static dispatch_once_t uno;

+ (instancetype) shared { return dispatch_once(&uno, ^{ writer = KSStringWriter.new; shared = [KSHTMLWriter.alloc initWithOutputWriter:writer]; }), shared; }

+ (NSA*) _combineArray:(NSA*)a withBase:(NSS*)base { return [a map:^id(id obj) { return [base withString:obj]; }]; }

+ (NSS*) markupForStyles:(NSA*)cssLinks base:(NSS*)base { return [self  markupForStyles:[self _combineArray:cssLinks withBase:base]]; }
+ (NSS*) markupForScripts:(NSA*)jsSrcs  base:(NSS*)base { return [self markupForScripts:[self _combineArray:jsSrcs   withBase:base]]; }

+ (NSS*) markupForStyles:(NSA*)cssLinks { [writer removeAllCharacters];
	[cssLinks do:^(id obj) { [self.shared writeLinkToStylesheet:obj title:@"" media:@""];	[self.shared startNewline]; }];
	return [self.shared startNewline], writer.string;
}
+ (NSS*) markupForScripts:(NSA*)jsSrcs { 	[writer removeAllCharacters];
	[jsSrcs do:^(id obj) { [self.shared writeJavascriptWithSrc:obj encoding:NSUTF8StringEncoding];	[self.shared startNewline]; }];
	return [self.shared startNewline], writer.string;
}
//		AZLOG(obj.propertiesPlease);
//			if (obj.contents && obj.isActive) {
//				if (obj.isInline && obj.contents) 	[_writer writeStyleElementWithCSSString:obj.contents];
//		   else if (obj.path)
//:obj.path type:nil rel:nil title:nil media:nil];
//			if (obj.contents && obj.isActive) {
//				if (obj.isInline && obj.contents) 	[_writer writeJavascript:obj.contents useCDATA:NO];
//		   else if (obj.path)
//			[_writer writeJavascriptWithSrc:obj.path encoding:NSUTF8StringEncoding];

+ (NSS*) markupForAZJSWithID:(NSS*)delimeter { static NSD* jsContents = nil;

	NSS*(^parseDelim)(NSS*) = ^(NSS*getFrom) { return [getFrom.stringByRemovingExtraneousWhitespace substringBetweenPrefix:@"/*atoz" andSuffix:@"*/"].stringByRemovingExtraneousWhitespace; };

	if (!jsContents) {

		__block NSMD *collector = NSMD.new; __block NSS* currentDelim = nil; __block BOOL recording = NO; __block NSMA *recorder = nil;

		NSA* lines = [[NSS stringWithContentsOfFile:[AZFWORKBUNDLE pathForResource:@"AtoZ" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil]lines];

		[lines each:^(NSS* line) {
			if ([line.stringByRemovingExtraneousWhitespace startsWith:@"/*atoz"]) { 	NSS *contentiousDelim = parseDelim(line);

				if (recording) { NSAssert(SameString(currentDelim,contentiousDelim), @"delimeters should match");

					collector[contentiousDelim] = recorder.joinedByNewlines;
					recording										= NO;
					currentDelim								= nil;	}

				else {
					currentDelim	= contentiousDelim;  // save delimeter so as to match with end delimeter
					recorder			= NSMA.new;  // reset the recorder string
					recording			= YES;	}

			} else 	[recorder addObject:line];
		}];

		LOGCOLORS(@"+ [",AZCLSSTR, zSPC, AZSELSTR, @"] Added ",
							@((jsContents = collector).allKeys.count), @" delimeted scripts for ID:",delimeter,zNL,zNL,
							[[jsContents.allKeys map:^id(id obj) {
								return $(@"delimeter:%@\n%@ ...\n",	obj, [[jsContents[obj] lines] subarrayToIndex:5].joinedByNewlines);
							}]joinedByNewlines], nil);
	}
	return jsContents[delimeter.stringByRemovingExtraneousWhitespace] ?: ^{ NSLog(@"WARNING.. NIL script for delim:%@",delimeter); return $(@"/* broken script with delimeter %@ */",delimeter); }();
}
@end
