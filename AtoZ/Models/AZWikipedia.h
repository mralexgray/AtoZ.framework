//
//  AZWikipedia.h
//  AtoZ
//
//  Created by Alex Gray on 3/31/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>

@interface AZWikipedia : BaseModel

@property (nonatomic, retain) NSMA *currentLinks, *displayedPages;
@property (nonatomic, retain) NSS *currentURL;

@property (nonatomic, strong) WebView *webView;
@end
