//
//  main.m
//  Router
//
//  Created by Alex Gray on 5/2/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//

@import Cocoa;
#import <RoutingHTTPServer/RoutingHTTPServer.h>

static RoutingHTTPServer  *http;

int main(int argc, const char * argv[]) {

  @autoreleasepool {


   http = [RoutingHTTPServer new];
//    [http get:@"/dir" handler:^(RouteRequest *q, RouteResponse *n) {
//      [n respondWithString:[NetworkHelpers createindexForDir:@"/"]];
//    }];
    [FSWalker serveFilesForURI:@"/js" withPath:@"/js" onRouter:http];


  WSDelegate *d =  WSDelegate.new;
  [d setDidOpenBlock:^(WebSocket *ws) {
	
    [ws sendJSON:@"Welcome to my WebSocket"];
  }];

  [d setDidReceiveMessageBlock:^(WebSocket *ws, NSString *msg) {
//    HTTPLogTrace2(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);
    [ws sendJSON:NSDate.date.description];
  }];

  [http setDelegate:d forWSURI:@"/"];

  [http get:@"/dynamic.html" handler:^(RouteRequest *q, RouteResponse *n) {


      NSString *story = @"<br/><br/>\
                         I'll tell you a story     <br/>\
                         About Jack a Nory;        <br/>\
                         And now my story's begun; <br/>\
                         I'll tell you another     <br/>\
                         Of Jack and his brother,  <br/>\
                         And now my story is done. <br/>";
      
      NSDictionary *replacementDict = @{
      @"COMPUTER_NAME":NSHost.currentHost.localizedName,
      @"TIME":NSDate.date.description,
      @"STORY":story,
      @"ALPHABET":@"A",@"QUACK":@"  QUACK  "};
      
  //		HTTPLogVerbose(@"%@[%p]: replacementDict = \n%@", THIS_FILE, self, replacementDict);

      [n respondBySwappingDelimited:@"%%"
              with:replacementDict];
	}];

    [http start:nil];
			// printf("well helllo %s",NSS.dicksonBible.UTF8String);
    NSLog(@"routes:%@", http.routes);
    [http openInBrowser];
    [NSRunLoop.currentRunLoop run];
  }
    return 0;
}

