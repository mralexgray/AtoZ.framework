

#import <Availability.h>
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
#import <UIKit/UIKit.h>
#define SM_USE_AV_AUDIO_PLAYER
#else
#import <Cocoa/Cocoa.h>
#if __MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_6
#define SM_USE_AV_AUDIO_PLAYER
#endif
#endif
#ifdef SM_USE_AV_AUDIO_PLAYER
#import <AVFoundation/AVFoundation.h>
#define SM_SOUND AVAudioPlayer
#else
#define SM_SOUND NSSound
#endif
#import "AtoZ.h"
extern NSString *const SoundDidFinishPlayingNotification;
typedef void (^SoundCompletionHandler)(BOOL didFinish);
@interface Sound : NSObject

	//required for 32-bit Macs
#ifdef __i386__
{
@private

    float baseVolume;
    float startVolume;
    float targetVolume;
    NSTimeInterval fadeTime;
    NSTimeInterval fadeStart;
    NSTimer *timer;
    Sound *selfReference;
    NSURL *url;
    SM_SOUND *sound;
    SoundCompletionHandler completionHandler;
}
#endif

+ (Sound *) randomSound;
+ (Sound *)soundNamed:(NSString *)name;
+ (Sound *)soundWithContentsOfFile:(NSString *)path;
- (Sound *)initWithContentsOfFile:(NSString *)path;
+ (Sound *)soundWithContentsOfURL:(NSURL *)url;
- (Sound *)initWithContentsOfURL:(NSURL *)url;

@property (NATOM, RONLY, copy ) 			 NSS *name;
@property (NATOM, RONLY, STRNG) 			 NSURL *url;
@property (NATOM, RONLY, getter = isPlaying) BOOL playing;
@property (NATOM, ASSGN, getter = isLooping) BOOL looping;
@property (NATOM, copy ) SoundCompletionHandler completionHandler;
@property (NATOM, ASSGN) 					float baseVolume;
@property (NATOM, ASSGN) 					float volume;

- (void)fadeTo:(float)volume duration:(NSTimeInterval)duration;
- (void)fadeIn:(NSTimeInterval)duration;
- (void)fadeOut:(NSTimeInterval)duration;
- (void)play;
- (void)stop;

@end
@interface SoundManager : NSObject

	//required for 32-bit Macs
#ifdef __i386__
{
@private

    Sound *currentMusic;
    NSMutableArray *currentSounds;
    BOOL allowsBackgroundMusic;
    float soundVolume;
    float musicVolume;
    NSTimeInterval soundFadeDuration;
    NSTimeInterval musicFadeDuration;
}
#endif

@property (nonatomic, readonly, getter = isPlayingMusic) BOOL playingMusic;
@property (nonatomic, assign) BOOL allowsBackgroundMusic;
@property (nonatomic, assign) float soundVolume;
@property (nonatomic, assign) float musicVolume;
@property (nonatomic, assign) NSTimeInterval soundFadeDuration;
@property (nonatomic, assign) NSTimeInterval musicFadeDuration;
@property (NATOM, STRNG) NSArray *soundPaths;

+ (SoundManager *)sharedManager;

- (void)prepareToPlayWithSound:(id)soundOrName;
- (void)prepareToPlay;

- (void)playMusic:(id)soundOrName looping:(BOOL)looping fadeIn:(BOOL)fadeIn;
- (void)playMusic:(id)soundOrName looping:(BOOL)looping;
- (void)playMusic:(id)soundOrName;

- (void)stopMusic:(BOOL)fadeOut;
- (void)stopMusic;

- (void)playSound:(id)soundOrName looping:(BOOL)looping fadeIn:(BOOL)fadeIn;
- (void)playSound:(id)soundOrName looping:(BOOL)looping;
- (void)playSound:(id)soundOrName;

- (void)stopSound:(id)soundOrName fadeOut:(BOOL)fadeOut;
- (void)stopSound:(id)soundOrName;
- (void)stopAllSounds:(BOOL)fadeOut;
- (void)stopAllSounds;

@end
