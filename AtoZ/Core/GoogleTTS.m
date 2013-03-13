//@synthesize  flacFile = _flacFile, nonFlacFile = _nonFlacFile, response = _response, uuid = _uuid;

#import "GoogleTTS.h"

@interface GoogleTTS ()
@property (NATOM, ASS) BOOL 	wavDone, flacDone, textDone;
@end

@implementation GoogleTTS

- (void) setUp { _wavDone = NO;  _flacDone = NO; _textDone = NO; }

//+ (instancetype) instanceWithWordsToSpeak:(NSS*)words completion:(void (^)(NSString *))block
//+ (instancetype) instanceWithWordsToSpeak:(NSS*)words completion:(void (^)(NSS *text, NSS* wavpath))block;
//{
//	GoogleTTS *g = GoogleTTS.instance;	g.words = words; g.handler = block; return g;
//}

- (void) getText:(NSS*)text withCompletion:(void (^)(NSS *text, NSS* wavpath))block;
{
	self.words = text;
	self.handler = block;
	
}
- (void) setWords:(NSString *)words
{
	_words = words;
	NSA* sayArgs = @[ @"--data-format=LEF32@16000", @"-o", self.nonFlacFile, _words];
	CWTask *u = [CWTask.alloc initWithExecutable:@"/usr/bin/say" andArguments:sayArgs atDirectory:NSTemporaryDirectory()];
	[u launchTaskOnQueue:AZSOQ withCompletionBlock:^(NSString *output, NSError *error) {
		NSLog(@"saving wave to %@", self.nonFlacFile);
		if (!error) self.wavDone = YES;
	}];
}

- (void) setWavDone:(BOOL)wavDone { NSLog(@"NOW CONVERT TO FLAC");
	CWTask *u = [CWTask.alloc initWithExecutable:@"/usr/local/bin/ffmpeg" andArguments:@[ @"-i", self.nonFlacFile, self.flacFile ] atDirectory:NSTemporaryDirectory()];
	[u launchTaskOnQueue:AZSOQ withCompletionBlock:^(NSString *output, NSError *error) {
		NSLog(@"saved FLAC!  %@", self.flacFile);
		if (!error) self.flacDone = YES;
	}];
}

- (void) setFlacDone:(BOOL)flacDone
{
	if (!flacDone) return;
	[AZSSOQ addOperationWithBlock:^{	_response = self.response;
									[NSOperationQueue.mainQueue addOperationWithBlock:^{
										_handler (_response, self.nonFlacFile);
									}];
	}];
}

- (NSS*) response
{
	NSData    *myData	= [NSData dataWithContentsOfFile:self.flacFile];
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
	NSS*translated = [NSString.alloc initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"The answer is: %@",translated);
	return  _response = translated.copy;

}

- (NSS*) uuid 		{ return _uuid		  = _uuid 		 ?: [NSTemporaryDirectory() withPath:NSS.UUIDString]; }
- (NSS*) nonFlacFile{ return _nonFlacFile = _nonFlacFile ?: 					 [self.uuid withExt: @"wav"]; }
- (NSS*) flacFile	{ return _flacFile 	  = _flacFile 	 ?: 				 	 [self.uuid withExt:@"flac"]; }

- (NSS*) userAgent 	{ return @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/27.0.1427.3 Safari/537.33"; }
- (NSS*) header 	{ return  @"Content-Type: audio/x-flac; rate=16000;"; }
- (NSS*) googleURL 	{ return  @"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"; }




@end
