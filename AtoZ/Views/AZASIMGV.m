//
//  PVAsyncImageView.m
//
//  Created by Pedro Vieira on 7/11/12
//  Copyright (c) 2012 Pedro Vieira. ( https://twitter.com/W1TCH_ )
//  All rights reserved.
//
#import "AZASIMGV.h"
#import "AtoZ.h"

@interface AZASIMGV ()
	@property (readwrite) BOOL isLoadingImage;
	@property (readwrite) BOOL userDidCancel;
	@property (readwrite) BOOL didFailLoadingImage;
	@property (nonatomic, strong)	NSURLConnection *imageURLConnection;
	@property (nonatomic, strong)	NSMutableData *imageDownloadData;
	@property (nonatomic, strong)	NSImage *errorImage;
	@property (nonatomic, strong)	NSProgressIndicator *spinningWheel;
	@property (nonatomic, strong)	NSTrackingArea *trackingArea;
@end

@implementation AZASIMGV
@synthesize  imageDownloadData, imageURLConnection, errorImage, spinningWheel, trackingArea;


- (void) setURL:(NSString *)URL
{
	_URL = URL;
	[self downloadImageFromURL:_URL withPlaceholderImage:nil errorImage:nil andDisplaySpinningWheel:YES];
}

- (void)downloadImageFromURL:(NSString *)url{
	[self downloadImageFromURL:url withPlaceholderImage:nil errorImage:nil andDisplaySpinningWheel:NO];
}
- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img{
	[self downloadImageFromURL:url withPlaceholderImage:img errorImage:nil andDisplaySpinningWheel:NO];
}
- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img andErrorImage:(NSImage *)errorImg{
	[self downloadImageFromURL:url withPlaceholderImage:img errorImage:errorImg andDisplaySpinningWheel:NO];
}
- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img errorImage:(NSImage *)errorImg andDisplaySpinningWheel:(BOOL)usesSpinningWheel{
	[self cancelDownload];
	
	self.isLoadingImage = YES;
	self.didFailLoadingImage = NO;
	self.userDidCancel = NO;
	
	self.image = img;
	errorImage = errorImg;
	imageDownloadData = [NSMutableData data];
	NSURLConnection *conn = [NSURLConnection.alloc initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
	imageURLConnection = conn;
	
	if(usesSpinningWheel){
		
		//If the NSImageView size is 64+ height and 64+ width display Spinning Wheel 32x32
		if (self.frame.size.height >= 64 && self.frame.size.width >= 64){
			spinningWheel = NSProgressIndicator.new;
			[spinningWheel setStyle:NSProgressIndicatorSpinningStyle];
			[self addSubview:spinningWheel];
			[spinningWheel setDisplayedWhenStopped:NO];
			[spinningWheel setFrame: NSMakeRect(self.frame.size.width * 0.5 - 16, self.frame.size.height * 0.5 - 16, 32, 32)];
			[spinningWheel setControlSize:NSRegularControlSize];
			[spinningWheel startAnimation:self];
			
		//If not, and size between 63 and 16 height and 63 and 16 width display Spinning Wheel 16x16
		}else if((self.frame.size.height < 64 && self.frame.size.height >= 16) && (self.frame.size.width < 64 && self.frame.size.width >= 16)){
			spinningWheel = NSProgressIndicator.new;
			[spinningWheel setStyle:NSProgressIndicatorSpinningStyle];
			[self addSubview:spinningWheel];
			[spinningWheel setDisplayedWhenStopped:NO];
			[spinningWheel setFrame: NSMakeRect(self.frame.size.width * 0.5 - 8, self.frame.size.height * 0.5 - 8, 16, 16)];
			[spinningWheel setControlSize:NSSmallControlSize];
			[spinningWheel startAnimation:self];
		}
	}
}
- (void)cancelDownload{
	[self setPropertiesWithDictionary: @{ @"userDidCancel" : @(YES), @"isLoadingImage": @(NO), @"didFailLoadingImage":@(NO)}];
	
	[self deleteToolTips];
	[spinningWheel stopAnimation:self];
	[spinningWheel removeFromSuperview];
	[imageURLConnection cancel];
	[@[@"imageURLConnection",@"imageDownloadData",@"errorImage",@"image"] setStringsToNilOnbehalfOf:self];// do:^(id obj) {  obj = nil; }];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[imageDownloadData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.isLoadingImage = NO;
	self.didFailLoadingImage = YES;
	self.userDidCancel = NO;
	
	[spinningWheel stopAnimation:self];
	[spinningWheel removeFromSuperview];
	
	imageDownloadData = nil;
	imageURLConnection = nil;
	
	self.image = errorImage;
	errorImage = nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	self.didFailLoadingImage = NO;
	self.userDidCancel		 = NO;
	NSImage *img = [NSImage.alloc initWithData:imageDownloadData];
	
	if(img){ //if NSData is from an image
		self.image 			= img;
		self.isLoadingImage = NO;
		[spinningWheel stopAnimation:self];
		[spinningWheel removeFromSuperview];
		imageDownloadData 	= nil;
		imageURLConnection 	= nil;
		errorImage 			= nil;
	} else  [self connection:nil didFailWithError:nil];
}
-(void)setToolTipWhileLoading:(NSString *)ttip1 whenFinished:(NSString *)ttip2 andWhenFinishedWithError:(NSString *)ttip3{
	self.toolTipWhileLoading = ttip1;
	self.toolTipWhenFinished = ttip2;
	self.toolTipWhenFinishedWithError = ttip3;
}
- (void)deleteToolTips
{
	[self setPropertiesWithDictionary: [NSD dictionaryWithValue:@"" forKeys:@[@"toolTip",@"toolTipWhileLoading", @"toolTipWhenFinished", @"toolTipWhenFinishedWithError"]]];
}

#pragma mark Mouse Enter Events to display tooltips
- (void)mouseEntered:(NSEvent *)theEvent
{
	if (!self.userDidCancel){ //if the user didn't cancel the operation show the tooltips
		self.toolTip = self.isLoadingImage
/*if is loading */	 ? self.toolTipWhileLoading != nil && ![self.toolTipWhileLoading isEqualToString:@""]
					 ? self.toolTipWhileLoading
					 : @""
					 : self.didFailLoadingImage
/*if conn fail */	? self.toolTipWhenFinishedWithError != nil && ![self.toolTipWhenFinishedWithError isEqualToString:@""]
					 ? self.toolTipWhenFinishedWithError
					 : @""
					 : !self.isLoadingImage
/*if not loading*/	 ? self.toolTip = self.toolTipWhenFinished != nil && ![self.toolTipWhenFinished isEqualToString:@""]
					 ? self.toolTipWhenFinished
					 : @""
					 : self.toolTip;
	}
}
- (void)updateTrackingAreas
{
	if(trackingArea != nil)	   [self removeTrackingArea:trackingArea];
	int opts 	 = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
	trackingArea = [NSTrackingArea.alloc initWithRect:self.bounds options:opts owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}
@end
