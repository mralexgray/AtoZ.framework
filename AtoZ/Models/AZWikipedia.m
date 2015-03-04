//
//  AZWikipedia.m
//  AtoZ
//
//  Created by Alex Gray on 3/31/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.


#import <AtoZ/AtoZ.h>
#import "AZWikipedia.h"

@implementation AZWikipedia
//  SaverView.m
//  TestScreenSaver
@synthesize  webView, currentLinks, currentURL, displayedPages;

- (void)collectCurrentLinks {
    int i, numLinks;
    NSString *link;

    numLinks = [[webView stringByEvaluatingJavaScriptFromString:@"document.links.length"] intValue];

    NSMutableArray *links = [NSMutableArray arrayWithCapacity:numLinks];

    for (i = 0; i < numLinks; i++) {
        link = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.links[%d].href", i]];
        if ([self linkIsFollowable:link] && ![links containsObject:link]) [links addObject:link];
    }

    currentLinks = links;
}

- (BOOL)linkIsFollowable:(NSString *)link {
    if ([link isEqualToString:currentURL]) return NO;
    if ([displayedPages containsObject:link]) return NO;

    link = [link substringFromIndex:7];

    if ([[link pathExtension] length] > 0) return NO;                                        //this should filter out images, attachements, etc
    if ([link rangeOfString:@"#"].location != NSNotFound) return NO;                         //this should filter out anchors
    if ([link rangeOfString:@":"].location != NSNotFound) return NO;                         //this should filter out special pages like categories

    if ([link isEqualToString:@"en.wikipedia.org/wiki/Main_Page"] ||
        [link isEqualToString:@"en.wikipedia.org/wiki/Non-profit_organization"] ||
        [link isEqualToString:@"en.wikipedia.org/wiki/Charitable_organization"]) return NO;  //these links are on ALL pages, and should be skipped

    link = [link stringByDeletingLastPathComponent];

    if (![link isEqualToString:[NSString stringWithFormat:@"%@.wikipedia.org/wiki", @"en"]]) return NO;

    return YES;
}

- (NSString *)generateInitialURL {
    NSString *seedPage = [NSS randomUrbanD].word;
    NSString *url;

    if ([seedPage isEqualToString:@"##RANDOM##"]) url = @"http://en.wikipedia.org/wiki/Special:Random";
    else {
        seedPage = [[seedPage componentsSeparatedByString:@" "] componentsJoinedByString:@"_"];
        url = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", seedPage];
    }

    return url;
}

#pragma mark WEBVIEW DELEGATE
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
//	[currentImageCell updateImageFromView: webView proportionally: YES];
    if (frame == [sender mainFrame]) {                                  //the whole thing's done. Clear it out
//		[currentImageCell release];
//		currentImageCell = nil;

        [self collectCurrentLinks];
    }

//	[self setNeedsDisplay: YES];
}

- (void)webView:(WebView *)sender didCommitLoadForFrame:(WebFrame *)frame {
//	currentLoadStarted = YES;
//	[currentImageCell updateImageFromView: webView proportionally: YES];
}

- (void)setInTestHarness:(BOOL)inHarness {
//	inTestHarness = inHarness;
}

@end
