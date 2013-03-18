//
//  AZFacebookConnection.m
//  AtoZ
//

#import "AZFacebookConnection.h"

NSString* APPLICATION_ID = @"223404761008769";


@interface AZFacebookConnection ()
@property (strong, nonatomic) NSOperationQueue *q;
@end

@implementation AZFacebookConnection

+ (instancetype) initWithQuery:(NSString*)q param:(NSString*)key thenDo:(FBTextBlock)block {

	AZFacebookConnection *me = [AZFacebookConnection sharedInstance];
	

}
//+ (NSString*) query:(NSString*)q param:(NSString*)key;

- (PhFacebook*)	fb { return _fb = _fb ?: [PhFacebook.alloc initWithApplicationID: APPLICATION_ID delegate: self]; }

- (void) setUp
{
	_q= NSOQ.new;
	_q.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
	//	self.token_label.stringValue = @"Invalid";
	//	[self.request_label setEnabled: NO];	[self.request_text setEnabled: NO];
	//	[self.send_request setEnabled: NO];		[self.result_text setEditable: NO];
	//	[self.result_text setFont: [NSFont fontWithName: @"Monaco" size: 10.0]];
}

#pragma mark IBActions

-(void) myPosts { 	[self.fb sendRequest: @"me/posts"]; }

- (IBAction) getAccessToken: (id) sender
{
//	[NSThread performBlockInBackground:^{
		// Always get a new token, don't get a cached one
		[self.fb getAccessTokenForPermissions: @[@"read_stream", @"export_stream"] cached: NO];
//	}];
}

- (IBAction) sendRequest: (id) sender
{
//	[self.send_request setEnabled: NO];
	[self.fb sendRequest: [sender stringValue]];// request_text.stringValue];
}

#pragma mark PhFacebookDelegate methods

- (void) tokenResult: (NSDictionary*) result
{
	if ([[result valueForKey: @"valid"] boolValue])
	{
//		self.token_label.stringValue = @"Valid";
//		[self.request_label setEnabled: YES];
//		[self.request_text setEnabled: YES];
//		[self.send_request setEnabled: YES];
//		[self.result_text setEditable: YES];
		[self.fb sendRequest: @"me/picture"];
//		[self sendRequest:nil];
	}
	else
	{
//		[self.result_text setString: [NSString stringWithFormat: @"Error: {%@}", [result valueForKey: @"error"]]];
	}

}

- (void) requestResult: (NSDictionary*) result
{
	if ( [result[@"request"] isEqualTo: @"me/picture"] )
			self.pic = [[NSImage alloc] initWithData: result[@"raw"]];	//		self.profile_picture.image = pic;
	else
			NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[result[@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil] );
//		[self.send_request setEnabled: YES];
		//		NSDictionary *s = [NSJSONSerialization JSONObjectWithData:[result[@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
		//		NSLog(@"%@",s);
		//		[self.result_text setString: [NSString stringWithFormat: @"Request: {%@}\n%@", result[@"request"], result[@"result"]]];
}

//- (void) jsonView:(id)v
//{
//	NSScrollView* c = [[v view].subviews filterOne:^BOOL(id object) {
//		return  [object isKindOfClass:NSScrollView.class];
//	}] ?: [v view];
//
//	c.frame = _target.frame;
//	c.backgroundColor = [NSColor redColor];
//	[_target replaceSubview:_target.subviews[0] with:c];
	//	[NSBundle loadNibNamed: @"FBOutlineViewController" owner: window];
//}


- (void) willShowUINotification: (PhFacebook*) sender
{
	[NSApp requestUserAttention: NSInformationalRequest];
}


@end
