//
//  AZFacebookConnection.m
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZFacebookConnection.h"

NSString* APPLICATION_ID = @"223404761008769";


@implementation AZFacebookConnection
@synthesize fb;

- (void) setUp
{
	fb = [[PhFacebook alloc] initWithApplicationID: APPLICATION_ID delegate: self];
//	self.token_label.stringValue = @"Invalid";
	[self getAccessToken:nil];
	//	[self.request_label setEnabled: NO];	[self.request_text setEnabled: NO];
	//	[self.send_request setEnabled: NO];		[self.result_text setEditable: NO];
	//	[self.result_text setFont: [NSFont fontWithName: @"Monaco" size: 10.0]];
}

#pragma mark IBActions

- (IBAction) getAccessToken: (id) sender
{
//	[NSThread performBlockInBackground:^{
		// Always get a new token, don't get a cached one
		[fb getAccessTokenForPermissions: @[@"read_stream", @"export_stream"] cached: NO];
//	}];
}

- (IBAction) sendRequest: (id) sender
{
//	[self.send_request setEnabled: NO];
	[fb sendRequest: [sender stringValue]];// request_text.stringValue];
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
		[fb sendRequest: @"me/picture"];
//		[self sendRequest:nil];
		[fb sendRequest: @"me/posts"];
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
