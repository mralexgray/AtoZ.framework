//
//  GoogleTTS.h
//  GoogleTTS
//
//  Created by Rishabh Jain on 12/24/13.
//  Copyright (c) 2013 RJVK Productions. All rights reserved.
//

@import Foundation; @import AudioToolbox; @import AVFoundation;

@interface GoogleTTS : NSObject 

+ (void) say:(NSString*)string;

+ (void) sayDignostics;

@end
