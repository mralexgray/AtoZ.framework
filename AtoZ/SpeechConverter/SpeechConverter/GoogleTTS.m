
#import "GoogleTTS.h"

@interface GoogleTTS ()
@property (nonatomic, strong) NSString 					*tempPath,
																								*tempFile,
																								*flacTempPath;
@end
@implementation GoogleTTS

- (NSString*) tempPath {	static NSS * u = nil; if (!u) { u = NSS.UUIDString;			[AZStopwatch start:u]; }
			return _tempPath = _tempPath ?: [[NSTemporaryDirectory() withPath:@"com.mrgray.TTS"]withExt:u];
}
+ (instancetype) recognizeSynthesizedText:(NSString*)string completion:(SpeechToTextDone)done;
{
																					GoogleTTS *g = self.class.alloc.init;
	g.textToRecognize 		= string.copy;
	g.recognizerFinished 	= done;								return g;
}

- (void) setTextToRecognize:(NSString *)textToRecognize	{		_textToRecognize = textToRecognize;

	NSArray* sayArgs = @[ @"--data-format=LEF32@16000", @"-o", [self.tempPath withExt:@"wav"], _textToRecognize];
	CWTask *u = [CWTask.alloc initWithExecutable:@"/usr/bin/say" andArguments:sayArgs atDirectory:NSTemporaryDirectory()];
	[u launchTaskOnQueue:AZSOQ withCompletionBlock:^(NSString *output, NSError *error) {
//		NSLog(@"saving wave to %@", _wavTempFile);
		if (!error) self.audioToRecognize = [_tempPath withExt:@"wav"];
	}];
}

- (void) setAudioToRecognize:(NSString *)audioToRecognize
{
	_audioToRecognize = audioToRecognize;
//	NSLog(@"audio to recognize is %@.  tryo to save to flac: %@", _audioToRecognize, self.flacTempFile);
	if ([audioToRecognize.pathExtension isEqualToString:@"flac"]) self.flacTempPath = _audioToRecognize;
	else {



		NSA *ffmpegargs = @[ @"-vn", @"-ac", @"1", @"-ar", @"16000", @"-i", _audioToRecognize, [self.tempPath withExt:@"flac"]];
		AZLOG($(@"setting ffmpeg args: %@",ffmpegargs));
		CWTask *u = [CWTask.alloc initWithExecutable:@"/usr/local/bin/ffmpeg" andArguments:ffmpegargs atDirectory:NSTemporaryDirectory()];
		[u launchTaskOnQueue:AZSOQ withCompletionBlock:^(NSString *output, NSError *error) {
			if (!error)  {		// NSLog(@"saved FLAC!  %@", flacTempFile );
												self.flacTempPath = [self.tempPath withExt:@"flac"];
			}
		}];
	}
}


- (void) setFlacTempPath:(NSString *)flacTempPath
{
	_flacTempPath = flacTempPath;

	[AZSSOQ addOperationWithBlock:^{
				self.recognizedText = [self getTextFromGoogleWithFlac:_flacTempPath]; // withCompletion:^(NSString *text, NSString *wavpath) {
	}];
}

-(void) setRecognizedText:(NSString *)recognizedText
{ 	id json = [NSJSONSerialization JSONObjectWithData:[recognizedText dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
		NSArray *hyp = [(NSD*)json recursiveObjectForKey:@"hypotheses"];
		_recognizedText = hyp[0][@"utterance"];
		self.confidence = @([hyp[0][@"confidence"] fV]);
		[AZStopwatch stop:_tempPath.pathExtension];
	  self.recognizerFinished(_recognizedText); }

- (NSString*) getTextFromGoogleWithFlac:(NSString*) flac
{
	NSData	*myData	= [NSData dataWithContentsOfFile:flac];
	NSMURLREQ *request 	= [NSMURLREQ.alloc initWithURL:	$URL(@"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US")];
	request.HTTPMethod 	= @"POST";														//set headers
 	[request setAllHTTPHeaderFields:@{ 	@"Content-Type" 		: 	@"audio/x-flac; rate=16000",
										@"Content-length"	:	$(@"%ld",myData.length) }];
	request.HTTPBody	= myData;

//	[request addValue:@"Content-Type" forHTTPHeaderField:@"audio/x-flac; rate=16000"];
//	[request addValue:@"audio/x-flac; rate=16000" forHTTPHeaderField:@"Content-Type"];
//	[request setValue:$(@"%ld",myData.length) forHTTPHeaderField:@"Content-length"];

	NSHTTPURLResponse* urlResponse 	= nil;
	NSError *error 					= NSError.new;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	NSString*translated = [NSString.alloc initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"The answer is: %@",translated);
	return  translated;

}

- (NSString*) googleURL 	{ return @"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"; }
- (NSString*) userAgent 	{ return @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/27.0.1427.3 Safari/537.33"; }
- (NSString*) header 			{ return @"Content-Type: audio/x-flac; rate=16000;"; }




@end


//+ (instancetype) instanceWithWordsToSpeak:(NSString*)words completion:(void (^)(NSString *))block
//+ (instancetype) instanceWithWordsToSpeak:(NSString*)words completion:(void (^)(NSS *text, NSString* wavpath))block;
///	GoogleTTS *g = GoogleTTS.instance;	g.words = words; g.handler = block; return g; }

//@synthesize  flacFile = _flacFile, nonFlacFile = _nonFlacFile, response = _response, uuid = _uuid;


//- (void) getText:(NSString*)text withCompletion:(void (^)(NSS *text, NSString* wavpath))block; {
//	self.textToRecognize = text;
//	self.handler = block;				}
