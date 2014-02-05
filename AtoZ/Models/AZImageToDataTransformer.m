
#import "AtoZ.h"
#import "AZImageToDataTransformer.h"
@implementation AZImageToDataTransformer
+ (BOOL)allowsReverseTransformation
{
	return YES;
}
+ (Class)transformedValueClass
{
	return [NSData class];
}
- (id)transformedValue:(id)value {


	NSPDFImageRep *img =  value;
	//[NSPDFImageRep imageRepsWithContentsOfFile:[AZBUNDLE pathForImageResource:@"volume_mute.pdf"]];
	NSSize size = AZSizeFromDimension(512);
	NSBitmapImageRep* bmRep = [NSBitmapImageRep.alloc initWithBitmapDataPlanes:NULL
																	  pixelsWide:size.width
																	  pixelsHigh:size.height
																   bitsPerSample:8
																 samplesPerPixel:4
																		hasAlpha:YES
																		isPlanar:NO
																  colorSpaceName:NSCalibratedRGBColorSpace
																	 bytesPerRow:0
																	bitsPerPixel:0];

	[NSGraphicsContext state:^{
		[img drawInRect:AZMakeRectFromSize(size)];
	}];

	AZLOG(bmRep);

	NSData *data = [bmRep representationUsingType:NSJPEGFileType properties:nil];

//	NSBitmapImageRep* bmRep = [NSBitmapImageRep.alloc initWithBitmapDataPlanes:NULL
//													pixelsWide:img.size.width
//													pixelsHigh:img.size.height
//												 bitsPerSample:8
//											   samplesPerPixel:4
//													  hasAlpha:YES
//													  isPlanar:NO
//												colorSpaceName:NSCalibratedRGBColorSpace
//												   bytesPerRow:0
//												  bitsPerPixel:0];
//
//	NSAssert( bmRep != nil, @"couldn't create bitmap for export");
////	NSLog(@"size = %@, dpi = %d, rep = %@", NSStringFromSize( img.size ),
////		  dpi, bmRep );
//
//	NSGraphicsContext* context = [NSGraphicsContext
//								  graphicsContextWithBitmapImageRep:bmRep];
//	[NSGraphicsContext saveGraphicsState];
//	[NSGraphicsContext setCurrentContext:context];
//	NSRect destRect = NSZeroRect;
//	destRect.size = img.size;
//	[img drawInRect:AZMakeRectFromSize(img.size)];
//	[NSGraphicsContext restoreGraphicsState];

	
//										 imageRepWithContentsOfFile:path];
//	int count = [img pageCount];
//	for(int i = 0 ; i < count ; i++){
//		[img setCurrentPage:0];
//		NSImage* pdfImage = [NSImage.alloc initWithSize:AZSizeFromDimension(64)];
//		[pdfImage addRepresentation:img];
//	NSImage *temp = NSImage.new;
//		[temp addRepresentation:img];
//		NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:[pdfImage TIFFRepresentation]];
//		NSString *pageName = [NSString stringWithFormat:@"_Page_%d.jpg", [img currentPage]]; [fileMangr createFileAtPath:[NSString stringWithFormat:@"%@/%@", foldr, pageName] contents:finalData attributes:nil];}


//	NSBitmapImageRep *rep = [[value representations] objectAtIndex: 0];
//	NSData *data = [rep representationUsingType: NSPNGFileType
//									 properties: nil];
	return data;
}
- (id)reverseTransformedValue:(id)value
{

	NSPDFImageRep *img = // value;
	[NSPDFImageRep imageRepWithData:value];////   imageRepsWithContentsOfFile:[AZBUNDLE pathForImageResource:@"volume_mute.pdf"]];
	NSSize size = AZSizeFromDimension(512);
	NSBitmapImageRep* bmRep = [NSBitmapImageRep.alloc initWithBitmapDataPlanes:NULL
																	  pixelsWide:size.width
																	  pixelsHigh:size.height
																   bitsPerSample:8
																 samplesPerPixel:4
																		hasAlpha:YES
																		isPlanar:NO
																  colorSpaceName:NSCalibratedRGBColorSpace
																	 bytesPerRow:0
																	bitsPerPixel:0];

	NSImage*uiImage =	[NSIMG.alloc initWithSize:size];
	[NSGraphicsContext state:^{
		[uiImage lockFocus];
		[bmRep drawInRect:AZMakeRectFromSize(size)];
		[uiImage unlockFocus];
	}];
	//	NSImage*uiImage = [[NSImage  alloc]initWithData:[bmRep TIFFRepresentation]];
//
//	AZLOG(bmRep);
//
//	NSData *data = [bmRep representationUsingType:NSJPEGFileType properties:nil];
//	NSImage *uiImage = [NSImage.alloc initWithData:value];
//	
	return uiImage;
}

@end

