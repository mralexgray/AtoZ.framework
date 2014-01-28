

@interface AZSpeech2Text : BaseModel
@property (weak) IBOutlet NSTextField *outputArea;
@property (weak) IBOutlet WebView *audioView;

AZPROP(NSString,whatever);

- (IBAction) recognizerForLabel:(id)sender;
- (IBAction) record:(id)sender;
@end


typedef void (^SpeechToTextDone) 	(NSString *text);
//typedef void (^SpeechToOutlet) (NSControl *control);

@interface GoogleSpeechAPI : BaseModel
extern BOOL const useSox;

@property (nonatomic,copy) 	SpeechToTextDone recognizerFinished;
//@property (nonatomic,copy) 	SpeechToOutlet outlet;

@property (nonatomic,strong) NSString 	*recognizedText,
													*wordsToSynthesize,
													*audioToRecognize;

@property (readonly) CGFloat	confidence,	time;

//+ (instancetype) recognizeAudioFile:			(NSString*)s completion:(SpeechToTextDone)done;
+ (instancetype) recognizeSynthesizedText:(NSString*)s completion:(SpeechToTextDone)done;
+ (instancetype) recordFor:(NSUI)s completion:(SpeechToTextDone)done;
+ (instancetype) recognizeSynthesizedText:(NSString*)s toControl:(id)outlet;
+ (instancetype) recognizeSynthesizedText:(NSString*)s toControl:(id)outlet withAudioView:(WebView*)wv;

@end


//@property (NATOM,CP)	void (^handler)(NSS *text, NSS* wavpath);
//typedef void (^TTSDoneBlock) 			(NSString *text,  NSString* wavpath);
//- (void) getText:(NSS*)text withCompletion:(void (^)(NSS *text, NSS* wavpath))block;
//+ (void) getSynthesizedText:(NSS*)text ((^)())block;
//@property(copy) TextConversionCompleteBlock completionBlock;
//-(void)launchTaskWithResult:(void (^)(NSS *textOutput)block;
//+ (instancetype) instanceWithWavFile:(NSS*)path;
//+ (instancetype) instanceWithWordsToSpeak:(NSS*)words completion:(NSString* (^)(void))blockThatReturnsString;
//+ (instancetype) instanceWithWordsToSpeak:(NSS*)words;
//+ (instancetype) instanceWithFlacFile:(NSS*)path;
