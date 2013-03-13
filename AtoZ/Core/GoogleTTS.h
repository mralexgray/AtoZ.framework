//
//  GoogleTTS.h
//  RoutingHTTPServer
//
//  Created by Alex Gray on 06/03/2013.
//
//

#import <AtoZ/AtoZ.h>

//typedef void (^TextConversionCompleteBlock)(void);
//typedef NSString*(^TextConversionCompleteBlock)();
typedef void (^TTSDoneBlock) (NSS *text,  NSS* wavpath);

@interface GoogleTTS : BaseModel
//public readonly vars
@property (NATOM, STRNG) NSS 	*flacFile, 	*nonFlacFile,
								*response,	*uuid;

@property (NATOM, STRNG) NSS 	*words;
//public read/write vars

@property (nonatomic, copy) void (^handler)(NSS *text, NSS* wavpath);

//@property(copy) TextConversionCompleteBlock completionBlock;

//-(void)launchTaskWithResult:(void (^)(NSS *textOutput)block;

//+ (instancetype) instanceWithWavFile:(NSS*)path;
//+ (instancetype) instanceWithWordsToSpeak:(NSS*)words completion:(NSString* (^)(void))blockThatReturnsString;
//+ (instancetype) instanceWithWordsToSpeak:(NSS*)words;
- (void) getText:(NSS*)text withCompletion:(void (^)(NSS *text, NSS* wavpath))block;

//+ (instancetype) instanceWithFlacFile:(NSS*)path;

@end
