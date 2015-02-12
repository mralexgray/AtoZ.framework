  //
  //  GoogleTTS.m
  //  GoogleTTS
  //
  //  Created by Rishabh Jain on 12/24/13.
  //  Copyright (c) 2013 RJVK Productions. All rights reserved.
  //

#import "GoogleTTS.h"

@interface            Phrase : NSObject <NSURLConnectionDataDelegate> + (instancetype) instanceWithString:(NSString*)_;
@property      NSMutableData * downloadedData;
@property               BOOL   ready;
@end

@interface        GoogleTTS () <AVAudioPlayerDelegate>

@property (readonly) NSArray * thingsToSay;
@property      AVAudioPlayer * player;
@property             Phrase * phrasePlaying;
@end

static GoogleTTS             * _shared = nil;
static NSRegularExpression   * wordLengthRegExp;
static NSUInteger              phrasesSpoken = 0,
                               maxLength = 99; // max length of one line

@implementation GoogleTTS

+ (void) say:(NSString *)string {

  wordLengthRegExp = wordLengthRegExp ?: [NSRegularExpression regularExpressionWithPattern:
                                                                [NSString stringWithFormat:@".{1,%lu}", (unsigned long)maxLength]
                                                                                   options:0 error:nil];

  NSMutableArray *sentences = @[].mutableCopy;

  [string enumerateSubstringsInRange:(NSRange){0,string.length}
                             options:NSStringEnumerationBySentences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

    [sentences addObject:substring];
  }];

  [sentences enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {

    if (line.length <= maxLength)
      return [[self.shared mutableArrayValueForKey:@"thingsToSay"] addObject:[Phrase instanceWithString:line.copy]];

    // line too long
    NSMutableString *cutLine = @"".mutableCopy; // current cut line

    for (NSString *word in [line componentsSeparatedByString:@" "]) { // split into words

      if (word.length > maxLength) { // word too long for a line

        for (NSTextCheckingResult *match in  [wordLengthRegExp matchesInString:word options:0 range:NSMakeRange(0,word.length)])
          [[self.shared mutableArrayValueForKey:@"thingsToSay"] addObject:[Phrase instanceWithString:[word substringWithRange:match.range]]];

      } else if ((cutLine.length && cutLine.length + word.length + 1 <= maxLength) ||
                (!cutLine.length &&                  word.length     <= maxLength)) { // word fits into this line (with or without space)

        if (cutLine.length) [cutLine appendString:@" "]; [cutLine appendString:word];

      } else { // word must be in next line

        [[self.shared mutableArrayValueForKey:@"thingsToSay"] addObject:[Phrase instanceWithString:[cutLine copy]]];
        cutLine = @"".mutableCopy;
        [cutLine appendString:word];
      }
    }
    if (cutLine.length)
      [[self.shared mutableArrayValueForKey:@"thingsToSay"] addObject:[Phrase instanceWithString:cutLine]]; // add final words of line
  }];

  [self.shared keepPlaying];
}


- (void) keepPlaying {

  if (_player.isPlaying || !_thingsToSay.count || !((Phrase*)_thingsToSay.firstObject).ready ||
                                          !(_phrasePlaying = _thingsToSay.firstObject)) return;

//  [_thingsToSay removeObjectIdenticalTo:_phrasePlaying];

  _player = [AVAudioPlayer.alloc initWithData:_phrasePlaying.downloadedData error:nil];
  [_player setDelegate:self];
  [_player play];
}

+ (GoogleTTS*) shared { static dispatch_once_t onceToken;

  return dispatch_once(&onceToken, ^{ _shared = self.new; }), _shared; // _shared.thingsToSay = @[].mutableCopy;

}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer*)p successfully:(BOOL)x {

  phrasesSpoken++;
  [[self mutableArrayValueForKey:@"thingsToSay"] removeObject:_phrasePlaying];

  _phrasePlaying = nil;
  NSLog(@"%@ spoken:%lu %@ ", NSStringFromSelector(_cmd), (unsigned long)phrasesSpoken, [self.thingsToSay valueForKey:@"ready"]);

  [self keepPlaying];

}
+ (void) sayDignostics {

  [[self.shared mutableArrayValueForKey:@"thingsToSay"] addObject:
             [Phrase instanceWithString:[NSString stringWithFormat: @"I have spoken %lu sentences, I have %lu to go.",
                                                                    (unsigned long)phrasesSpoken++, // arc4random() % 10,
                                                                    (unsigned long)self.shared.thingsToSay.count]]];
}

@end

@implementation Phrase

+ (instancetype) instanceWithString:(NSString*)_ { Phrase *x = self.class.new;

  NSString *search = [[NSString stringWithFormat:@"http://translate.google.com/translate_tts?tl=en&q=%@",_]
                      stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:search]];

  [request setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];

  NSURLConnection *connect = [NSURLConnection.alloc initWithRequest:request delegate:x];

  x.downloadedData = [NSMutableData.alloc initWithLength:0];

  return [connect start], x;
}
#define Connection__ - (void) connection:(NSURLConnection*)c

Connection__ didReceiveResponse:(NSURLResponse*)f { _downloadedData.length = 0; }

Connection__     didReceiveData:(NSData*)data     { [_downloadedData appendData:data]; }

Connection__   didFailWithError:(NSError*)e       { NSLog(@"Failure"); }

- (void) connectionDidFinishLoading:(NSURLConnection*)connection { self.ready = YES; [[GoogleTTS shared] keepPlaying]; }

@end
