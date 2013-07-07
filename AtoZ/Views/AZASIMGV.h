//
//  PVAsyncImageView.h
//
//  Created by Pedro Vieira on 7/11/12
//  Copyright (c) 2012 Pedro Vieira. ( https://twitter.com/W1TCH_ )
//  All rights reserved.
//



@interface AZASIMGV : NSImageView

@property (readonly) BOOL isLoadingImage, userDidCancel, didFailLoadingImage;

@property (nonatomic, strong) NSString *URL;
//@property (nonatomic, strong) NSURL* properURL;



@property (NATOM, STRNG) NSString *toolTipWhileLoading;
@property (NATOM, STRNG) NSString *toolTipWhenFinished;
@property (NATOM, STRNG) NSString *toolTipWhenFinishedWithError;


//Loads an image from the web
//- (void)downloadImageFromURL:(NSString *)url;

//Loads an image from the web and displays a placeholder image on the NSImageView
//- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img;

//Loads an image from the web, displays a placeholder image on the NSImageView and displays another image if there's an error while loading
//- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img andErrorImage:(NSImage *)errorImg;

//Loads an image from the web, displays a placeholder image on the NSImageView with a spinning wheel on top of it and displays another image if there's an error while loading
//- (void)downloadImageFromURL:(NSString *)url withPlaceholderImage:(NSImage *)img errorImage:(NSImage *)errorImg andDisplaySpinningWheel:(BOOL)usesSpinningWheel;

//Stops loading the image
- (void)cancelDownload;

//Method to set all tooltips at once. Just to make things fast and easy
-(void)setToolTipWhileLoading:(NSString *)ttip1 whenFinished:(NSString *)ttip2 andWhenFinishedWithError:(NSString *)ttip3;

//Deletes all the ToolTips
-(void)deleteToolTips;


@end
