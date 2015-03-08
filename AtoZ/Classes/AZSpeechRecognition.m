
#import "AZSpeechRecognition.h"
#import "CWTask.h"
#import <AtoZ/AtoZ.h>
@interface AZSpeech2Text ()
@property (nonatomic, assign) FilterBlock filter;
@end
@implementation AZSpeech2Text

- (NSS*) whatever { return @"hello"; }

- (IBAction) recognizerForLabel:(NSBUTT*)sender;	{	NSA* say =

	[@[@[ @"dicksonism",	NSS.randomDicksonism										   ],
	   @[ @"random",		NSS.randomWord			 									   ],
	   @[ @"urband", 	   [NSS.randomUrbanD.word withString:NSS.randomUrbanD.definition]],
	   @[ @"bad word",		NSS.badWords.randomElement									   ]]

		subIndex:0 blockReturnsIndex:^id(NSS*s){ return [s contains: sender.title.lowercaseString] ? s : nil;
	}];
	[GoogleSpeechAPI recognizeSynthesizedText:say[1] completion:^(NSS *result) {
		_outputArea.stringValue = $(@"Original: \n\n%@\n\nResult:\n%@", say[1], result);
	}];
}
- (IBAction)record:(id)sender
{
	[GoogleSpeechAPI recordFor:10
					completion:^(NSS *result) {_outputArea.stringValue = $(@"Result:\n%@", result);
	}];
}
@end

//^{ api = [GoogleSpeechAPI recognizeSynthesizedText:NSS.randomWord.wikiDescription toControl:_outputArea];

//	FilterBlock fb2 = ^id(id element, NSUInteger idx, BOOL *stop){
//		if ([element isEqualToString:@"NO"] ) {		*stop = YES;} return element;};
/*
	NSArray *filter = @[ fb1, fb2 ];
	NSArray *inputArray = @[@"NO",@"YES"];

	[inputArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj processByPerformingFilterBlocks:filter];
	}];
//	but you can also do more complicated stuff, like aplied chianed calculations:

	FilterBlock b1 = ^id(id element,NSUInteger idx, BOOL *stop) {return [NSNumber numberWithInteger:[(NSNumber *)element integerValue] *2 ];};
	FilterBlock b2 = ^id(NSNumber* element,NSUInteger idx, BOOL *stop) {
		*stop = YES;
		return [NSNumber numberWithInteger:[element integerValue]*[element integerValue]];
	};
	FilterBlock b3 = ^id(NSNumber* element, NSUInteger idx,BOOL *stop) {return [NSNumber numberWithInteger:[element integerValue]*[element integerValue]];};

	NSArray *filterBlocks = @[b1,b2, b3, b3, b3];
	NSNumber *numberTwo = [NSNumber numberWithInteger:2];
	NSNumber *numberTwoResult = [numberTwo processByPerformingFilterBlocks:filterBlocks];
	NSLog(@"%@ %@", numberTwo, numberTwoResult);
	*/

@interface GoogleSpeechAPI ()
@property (nonatomic, strong) NSString 					 *tempPath, *flacTempPath;
@property (nonatomic, strong) NSData 					 *flacData,	*cafData;
@property (readwrite) 			CGFloat 					confidence, 	 time;
@end

const BOOL usr = YES;

@implementation GoogleSpeechAPI

-(NSA*) SOX 		{ return 	@[ @"/usr/local/bin/sox", /** [AZFWRESOURCES withPath:@"sox"], */
						  		@[ @"-d", @"-r", @"8000", _flacTempPath, @"trim", @"0", @"00:10"]]; }
//								 @"--vol", @"2", 
-(NSA*) FFMPEG { return @[ @"/usr/local/bin/ffmpeg",
								@[ @"-ab", @"8000", @"-ac", @"1",@"-y", @"-vn",  @"-i", _audioToRecognize, [self.tempPath withExt:@"flac"]]]; 			}
-(NSA*) SAY 		{ return @[ @"/usr/bin/say",
								@[ @"--data-format=LEF32@8000", @"-o", [self.tempPath withExt:@"caf"], self.wordsToSynthesize]];													}


//+ (instancetype) recognizeSynthesizedText:(NSString*)s toControl:(id)outlet withAudioView:(WebView*)wv
//{
//
//}

+ (instancetype) recognizeSynthesizedText:(NSString*)s toControl:(id)outlet
{
	return [self.alloc initWithProperties:@{ @"wordsToSynthesize":s.copy, @"recognizerFinished" : ^(NSS*s){ ((NSControl*)outlet).stringValue = s; }}];
//	g.wordsToSynthesize	= s.copy;
//	g.recognizerFinished = ^(NSS*s){ ((NSControl*)outlet).stringValue = s; };
//	g.audioToRecognize = nil;
//	return g;
}

+ (instancetype) recordFor:(NSUI)s completion:(SpeechToTextDone)done;
{
	GoogleSpeechAPI 	*g 	= self.new;		g.recognizerFinished	= done;	NSLog(@"START RECORDING!");
					g.audioToRecognize = nil;		return g;
}

- (NSS*) tempPath {	return _tempPath = _tempPath ?: ^{ 	NSS *u = @"a".uuid;
																			[AZStopwatch start:_wordsToSynthesize ?: u];
							return [[NSTemporaryDirectory() withPath:@"com.mrgray.TTS"]withExt:u]; }();
}

+ (instancetype) recognizeSynthesizedText:(NSString*)string completion:(SpeechToTextDone)done;
{
	GoogleSpeechAPI			   *g = [self.class.alloc init];
	g.wordsToSynthesize	= string.copy;
	g.recognizerFinished 	= done;								return g;
}

- (void) setWordsToSynthesize:(NSString *)wordsToSynthesize	{		_wordsToSynthesize = wordsToSynthesize;

	NSLog(@"\"saying\" caf to %@", [self.tempPath withExt:@"caf"]);

	CWTask *u = [CWTask.alloc initWithExecutable:self.SAY[0] andArguments:self.SAY[1] atDirectory:AZTEMPD];
	[u launchTaskOnQueue:AZSSOQ withCompletionBlock:^(NSString *output, NSError *error) {
		if (!error)	self.audioToRecognize = [self.tempPath withExt:@"caf"];
	}];
}

- (void) setAudioToRecognize:(NSString *)audioToRecognize
{
	CWTask  *u;
	if ( audioToRecognize )  { 	_audioToRecognize = audioToRecognize; AZLOG($(@"setting ffmpeg args: %@",self.FFMPEG[1]));
		
		u = [CWTask.alloc initWithExecutable:self.FFMPEG[0] andArguments:self.FFMPEG[1] atDirectory:AZTEMPD];
		[u launchTaskOnQueue:AZSSOQ withCompletionBlock:^(NSString *output, NSError *error) {
			if (!error) 	self.flacTempPath = [self.tempPath withExt:@"flac"];
		}];
	} else {
				_flacTempPath = [self.tempPath withExt:@"flac"];  NSLog(@"SOX:  %@  ARG: %@", self.SOX[0], self.SOX[1]);
				u = [CWTask.alloc initWithExecutable: self.SOX[0] andArguments:self.SOX[1] atDirectory:NSTemporaryDirectory()];
				[u launchTaskOnQueue:AZSSOQ withCompletionBlock:^(NSS *output, NSError *error) {  NSLog(@"finished recording");  self.flacTempPath = _flacTempPath; }];
			}

}
//	NSLog(@"audio to recognize is %@.  tryo to save to flac: %@", _audioToRecognize, self.flacTempFile);
//	if ([audioToRecognize.pathExtension isEqualToString:@"flac"]) self.flacTempPath = _audioToRecognize;
//	else {
//@"-vn",  @"-ar", @"16000",

//- (void) setFlacData:(NSData *)flacData		{ _flacData = flacData;
//
//	[AZSSOQ addOperationWithBlock:^{	self.recognizedText = [self getTextFromGoogleWithFlacData:_flacData]; // withCompletion:^(NSString *text, NSString *wavpath) {
//	}];
//}


- (void) setFlacTempPath:(NSString *)flacTempPath	{	_flacTempPath = flacTempPath;  NSLog(@"flacpathSet: %@", _flacTempPath);
	[AZSSOQ addOperationWithBlock:^{
		self.recognizedText = [self getTextFromGoogleWithFlac:_flacTempPath]; // withCompletion:^(NSString *text, NSString *wavpath) {
	}];
}

-(void) setRecognizedText:(NSString *)recognizedText
{
 	id json = [NSJSONSerialization JSONObjectWithData:[recognizedText dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
	if (json) {
		NSArray *hyp = [(NSD*)json recursiveObjectForKey:@"hypotheses"];
		if ( hyp.count ) {
			_recognizedText = hyp[0][@"utterance"];
			self.confidence = [hyp[0][@"confidence"] fV];
			[AZStopwatch stop:_wordsToSynthesize ?: self.tempPath.pathExtension];
		  	_recognizerFinished(_recognizedText);
		}
	}
}


- (NSString*) getTextFromGoogleWithFlac:(NSS*)path
{
	NSData *data = [NSData dataWithContentsOfFile:path];
	NSMURLREQ *request 	= [NSMURLREQ.alloc initWithURL:	$URL(@"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US")];
	request.HTTPMethod 	= @"POST";														//set headers
 	[request setAllHTTPHeaderFields:@{ @"Content-Type" : @"audio/x-flac; rate=8000", 	@"Content-length"	: $(@"%ld",data.length) }];
	request.HTTPBody	=	data;
	//	NSLog(@"The request is: %@",request);
	//	[request addValue:@"Content-Type" forHTTPHeaderField:@"audio/x-flac; rate=16000"];
	//	[request addValue:@"audio/x-flac; rate=16000" forHTTPHeaderField:@"Content-Type"];
	//	[request setValue:$(@"%ld",myData.length) forHTTPHeaderField:@"Content-length"];

	NSHTTPURLResponse* urlResponse 	= nil;			NSError *error 			= NSError.new;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	NSString*translated 	= [NSString.alloc initWithData:responseData encoding:NSUTF8StringEncoding];
	//	NSLog(@"The answer is: %@",translated);
	return  translated ?: $(@"ERROR:  %@", error);

}

- (NSString*) googleURL 	{ return @"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"; }
- (NSString*) userAgent 	{ return @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/27.0.1427.3 Safari/537.33"; }
- (NSString*) header 			{ return @"Content-Type: audio/x-flac; rate=16000;"; }

@end

/**	_wavData = [NSData dataWithContentsOfFile:[self.tempPath withExt:@"caf"] options:0 error:&error];
if(!error)	{	NSLog(@"Made Data: %@", _wavData.description);
NSString *e;
CWTask *u = [CWTask.alloc initWithExecutable:[AZFWRESOURCES withPath:@"sox"] andArguments:@[@"-", @"-t", @"flac", @"-"] atDirectory:NSTemporaryDirectory()];
[u launchTaskOnQueue:AZSOQ withCompletionBlock:^(NSString *output, NSError *error) {
NSLog(@"sox and args: %@", output);
//								int flax = [NSTask executeTaskWithArguments:sox input:wavout outputData:&flac errorString:&e];
if (!error) { self.flacData = output.dataUsingUTF8Encoding; }
else {   NSLog(@"Data encoding error..  line39:  %@", error);
		//  [_tempPath withExt:@"wav"];
		//	CWTask *u = [CWTask.alloc initWithExecutable:@"/usr/bin/say" andArguments:sayArgs atDirectory:NSTemporaryDirectory()];
		//	[u launchTaskOnQueue:AZSOQ withCompletionBlock:^(NSString *output, NSError *error) {
//			} else NSLog(@"Data encoding error..  line42:  %@", e
//	}];
//	}
		}];
}
//	}];
//		NSLog(@"saving wave to %@", _wavTempFile);  */


//+ (instancetype) instanceWithWordsToSpeak:(NSString*)words completion:(void (^)(NSString *))block
//+ (instancetype) instanceWithWordsToSpeak:(NSString*)words completion:(void (^)(NSS *text, NSString* wavpath))block;
///	GoogleSpeechAPI *g = GoogleSpeechAPI.instance;	g.words = words; g.handler = block; return g; }

//@synthesize  flacFile = _flacFile, nonFlacFile = _nonFlacFile, response = _response, uuid = _uuid;


//- (void) getText:(NSString*)text withCompletion:(void (^)(NSS *text, NSString* wavpath))block; {
//	self.textToRecognize = text;
//	self.handler = block;				}
