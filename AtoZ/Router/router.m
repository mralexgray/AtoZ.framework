
#import <AtoZ/AtoZ.h>

int main() { @autoreleasepool { static RoutingHTTPServer  *http;

  XX([NET localeOfIP:NET.externalIP].autoDescribe);

  http = RoutingHTTPServer.new;

  http.port = 22080;

  [http get:@"/index.html" handler:^(RouteRequest *req, RouteResponse *res) {

//    NSLog(@"%@", req.message.allHeaderFields);
//    NSLog(@"%@", res.connection.asyncSocket.autoDescribe);
//    NSLog(@"%@", res.connection.asyncSocket.connectedHost);

    [res respondWithFile:@"/Volumes/2T/ServiceData/www/Alex.Gray.Resume.pdf"];
    //[res setHeader:@"Location" value:@"http://google.com/"];

  }];

  [http get:@"/dir" handler:^(RouteRequest *req, RouteResponse *res) {
    [res respondWithString:[NetworkHelpers createindexForDir:@"/"]];
   }];

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

  [http get:@"/dynamic.html" handler:^(RouteRequest *req, RouteResponse *res) {


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

      [res respondBySwappingDelimited:@"%%"
              with:replacementDict];
	}];
  http.name         = @"mrgray.com";
  http.port         = 22080;
  http.bonjourBlock = ^(HTTPServer* _http) { [(RoutingHTTPServer*)_http openInBrowser]; };

  [http start:nil];

			// printf("well helllo %s",NSS.dicksonBible.UTF8String);
    NSLog(@"routes:%@", http.routes);
    [NSRunLoop.currentRunLoop run];
  }
  return 0;
}

