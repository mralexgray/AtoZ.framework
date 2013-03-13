//
//  AZFacebookBrowserView.m
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//#error Delete this line and enter your application ID below
NSString* APPLICATION_ID = @"223404761008769";


#import "AZFacebookBrowserView.h"

@implementation AZFacebookBrowserView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self != [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) return nil;		return self;
}


@synthesize token_label, request_label, request_text, result_text, profile_picture, send_request, fb;

- (void) awakeFromNib
{
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = NSSIZEABLE;
	fb = [[PhFacebook alloc] initWithApplicationID: APPLICATION_ID delegate: self];
	self.token_label.stringValue = @"Invalid";

	NSControlActionBlock block = ^(id inSender) {

		AZLOG(@"xlisidud")
		[self getAccessToken:nil];
	};
	[self.send_request setActionBlock:block];
//	[self.request_label setEnabled: NO];
//	[self.request_text setEnabled: NO];
//	[self.send_request setEnabled: NO];
//	[self.result_text setEditable: NO];
//	[self.result_text setFont: [NSFont fontWithName: @"Monaco" size: 10.0]];
}

#pragma mark IBActions

- (IBAction) getAccessToken: (id) sender
{
	// Always get a new token, don't get a cached one
	[fb getAccessTokenForPermissions: @[@"read_stream", @"export_stream"] cached: NO];
}

- (IBAction) sendRequest: (id) sender
{
	[self.send_request setEnabled: NO];
	[fb sendRequest: request_text.stringValue];
}

#pragma mark PhFacebookDelegate methods

- (void) tokenResult: (NSDictionary*) result
{
	if ([[result valueForKey: @"valid"] boolValue])
	{
		self.token_label.stringValue = @"Valid";
		[self.request_label setEnabled: YES];
		[self.request_text setEnabled: YES];
		[self.send_request setEnabled: YES];
		[self.result_text setEditable: YES];
		[fb sendRequest: @"me/picture"];
		[self sendRequest:nil];
	}
	else
	{
		[self.result_text setString: [NSString stringWithFormat: @"Error: {%@}", [result valueForKey: @"error"]]];
	}
}

- (void) requestResult: (NSDictionary*) result
{
	if ([result[@"request"] isEqualTo: @"me/picture"])
		self.profile_picture.image = [NSImage.alloc initWithData: result[@"raw"]];
	else {
		[self.send_request setEnabled: YES];
		id s = [NSJSONSerialization JSONObjectWithData:result[@"raw"] options:0 error:nil];
		[result_text insertText: [[(NSD*)s jsonStringValue]attributedWithFont:AtoZ.controlFont andColor:BLACK]];
	}
}

- (void) visualize {
/**
		//				[result.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		//					NSLog(@"obj:  %@  class: %@  %@", obj, [result[obj] class], [NSJSONSerialization isValidJSONObject: result[obj]] ? @"YES" : @"NO");
		////					if ( [result[obj] isKindOfClass:NSData.class] )
		////						NSLog(@"VALID %@", [NSJSONSerialization isValidJSONObject: [NSString.alloc initWithUTF8String:[result[obj]] ? @"YES" : @"NO");]]
		//				}];
//		[_delegate performSelectorOnMainThread:@selector(requestResult:) withObject: result waitUntilDone:YES];
		//				JsonElement *s = [JsonElement elementWithObject:[

		//				NSString *json = [NSString stringWithFormat:@"%@",result[@"result"]];
		//				NSLog(@"class:  %@", [NSString.alloc initWithBytesNoCopy:(void*)[data bytes] length: [data length] encoding:NSASCIIStringEncoding freeWhenDone: NO] );
		id s = [NSJSONSerialization JSONObjectWithData:[result[@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
		if (s) //[result[@"result"] isKindOfClass:NSString.class])
			_fbOutlineView = [FBOutlineViewController.alloc initWithJSON:s forRequest:allParams[@"request"]];
		[NSBundle loadNibNamed: @"FBOutlineViewController" owner: _fbOutlineView];
		NSLog(@"fboutlien:  %@",_fbOutlineView);
		{
			//					_fbOutlineView = [[FBOutlineViewController alloc] initWithJSONData:result[@"raw"] inFrame:[[[NSApplication sharedApplication]mainWindow] frame]];
			//					NSLog(@"fboutlien:  %@", _fbOutlineView);

//		NSDictionary *s = [NSJSONSerialization JSONObjectWithData:[result[@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//		NSLog(@"%@",s);
//		[self.result_text setString: [NSString stringWithFormat: @"Request: {%@}\n%@", result[@"request"], result[@"result"]]];
	}
	*/
}

- (void) jsonView:(id)v
{
	NSScrollView* c = [[v view].subviews filterOne:^BOOL(id object) {
			return  [object isKindOfClass:NSScrollView.class];
	}] ?: [v view];
	
	c.frame = _target.frame;
	c.backgroundColor = [NSColor redColor];
	[_target replaceSubview:_target.subviews[0] with:c];
//	[NSBundle loadNibNamed: @"FBOutlineViewController" owner: window];
}


- (void) willShowUINotification: (PhFacebook*) sender
{
	[NSApp requestUserAttention: NSInformationalRequest];
}


@end
