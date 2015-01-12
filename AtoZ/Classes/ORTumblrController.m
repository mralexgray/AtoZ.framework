//
//  ORTumblrController.m
//  GIFs
//
//  Created by orta therox on 21/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ORTumblrController.h"
#import "AFNetworking.h"

@implementation ORTumblrController {
    NSString *_url;
    NSInteger _offset;
    BOOL _downloading;
}

- (void)setTumblrURL:(NSString *)tumblrURL {

    _url = tumblrURL;
    _gifs = @[];
    _offset = 0;
    _downloading = NO;

    [self getNextGIFs];
}

- (void)getNextGIFs {
    if (_downloading) return;

    [ORAppDelegate setNetworkActivity:YES];
}


- (NSInteger)numberOfGifs {
    return _gifs.count;
}

- (GIF *)gifAtIndex:(NSInteger)index {
    return _gifs[index];
}

@end
