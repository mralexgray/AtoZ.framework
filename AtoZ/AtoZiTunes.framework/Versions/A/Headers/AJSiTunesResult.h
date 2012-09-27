
#import <Foundation/Foundation.h>

typedef enum {
    kAJSiTunesAPIMediaTypeAll = 0,
    kAJSiTunesAPIMediaTypeMusic = 1,
    kAJSiTunesAPIMediaTypeMusicVideos = 2,
    kAJSiTunesAPIMediaTypeMovies = 3,
    kAJSiTunesAPIMediaTypeTVShows = 4,
    kAJSiTunesAPIMediaTypeSoftware = 5,
    kAJSiTunesAPIMediaTypeAudiobook = 6,
    kAJSiTunesAPIMediaTypeEBook = 7,
    kAJSiTunesAPIMediaTypePodcast = 8,
    kAJSiTunesAPIMediaTypeShortFilm = 9
} kAJSiTunesAPIMediaType;

@interface AJSiTunesResult : NSObject 
{
    @private
    NSInteger _itemID;
    NSInteger _artistID;
    NSInteger _trackCount;
    NSInteger _trackNumber;
    
    kAJSiTunesAPIMediaType _mediaType;
    
    NSString *_title;
    NSString *_artistName;
    NSString *_collectionName;
    NSString *_genreName;
    NSString *_objectType;
    NSString *_itemDescription;
    
    NSDate *_releaseDate;
    
    NSURL *_imageURL;
    NSURL *_tbnImageURL;
    NSURL *_previewURL;
    NSURL *_viewURL;
    
    NSTimeInterval _duration;
}

@property (nonatomic, assign) NSInteger itemID;
@property (nonatomic, assign) NSInteger artistID;

@property (nonatomic, assign) NSInteger trackCount;
@property (nonatomic, assign) NSInteger trackNumber;

@property (nonatomic, assign) kAJSiTunesAPIMediaType mediaType;

//Title: Either track title, episode name, or item title (software)

@property (nonatomic, retain) NSString *title;

//Artist name: For film this is often lead actor / director

@property (nonatomic, retain) NSString *artistName;
@property (nonatomic, retain) NSDate *releaseDate;

//Path to the full fat image, may or may not exist

@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) NSURL *tbnImageURL;
@property (nonatomic, retain) NSURL *previewURL;
@property (nonatomic, retain) NSURL *viewURL;

//Collection name: usually the album name (music)

@property (nonatomic, retain) NSString *collectionName;
@property (nonatomic, retain) NSString *genreName;

@property (nonatomic, retain) NSString *objectType;

@property (nonatomic, retain) NSString *itemDescription;

@property (nonatomic, assign) NSTimeInterval duration;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
