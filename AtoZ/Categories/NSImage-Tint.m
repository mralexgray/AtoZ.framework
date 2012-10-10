//
//  NSImage-Tint.m
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-11.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import "NSImage-Tint.h"


CGFloat const TBITintMatrixGrayscale[] = {
    0.3, 0.59, 0.11,
    0.3, 0.59, 0.11,
    0.3, 0.59, 0.11
};

CGFloat const TBITintMatrixSepia[] = {
    0.393, 0.769, 0.189,
    0.349, 0.686, 0.168,
    0.272, 0.534, 0.131
};

CGFloat const TBITintMatrixBluetone[] = {
    0.272, 0.534, 0.131,
    0.349, 0.686, 0.168,
    0.393, 0.769, 0.189
};

void
tint_pixel_rgb (unsigned char *bitmapData, int red_index, const CGFloat *matrix)
{
    int green_index = red_index + 1;
    int blue_index = red_index + 2;
    
    CGFloat red = bitmapData[red_index];
    CGFloat green = bitmapData[green_index] ;
    CGFloat blue = bitmapData[blue_index];
    
    bitmapData[red_index] = MIN (red * matrix[0] + green * matrix[1] + blue * matrix[2], 255.0f); // red
    bitmapData[green_index] = MIN (red * matrix[3] + green * matrix[4] + blue * matrix[5], 255.0f); // green
    bitmapData[blue_index] = MIN (red * matrix[6] + green * matrix[7] + blue * matrix[8], 255.0f); // blue    
}

@implementation NSImage (Tint)

- (NSImage *)tintWithMatrix:(const CGFloat *)matrix;
{
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
    
    NSSize imageSize = [bitmap size];
    
    int pixels = imageSize.height * [bitmap bytesPerRow];
    unsigned char *bitmapData = [bitmap bitmapData];
    int samplesPerPixel = [bitmap samplesPerPixel];
    
    NSDate *start = [NSDate date];

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1060 // libdispatch is only available on Mac OS X 10.6 or later.
    int stride = [bitmap bytesPerRow] / samplesPerPixel;
    dispatch_apply(pixels / samplesPerPixel / stride,
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^(size_t i){
                       size_t j = i * samplesPerPixel * stride;
                       size_t jStop = j + samplesPerPixel * stride;
                       
                       do {
                           tint_pixel_rgb(bitmapData, j, matrix);
                           
                           j += samplesPerPixel;
                       } while (j < jStop);
                   });
#else
    for (int i = 0; i < pixels; i = i + samplesPerPixel) {
        tint_pixel_rgb(bitmapData, i, matrix);
    }
#endif

    NSImage *image = [[NSImage alloc] initWithSize:[bitmap size]];
    [image addRepresentation:bitmap];
        
    NSTimeInterval elapsedSeconds = -[start timeIntervalSinceNow];
    NSLog(@"Elapsed time: %.2f ms", elapsedSeconds * 1000);
    
    return image;
}

- (NSImage *)grayscaleImage
{
    return [self tintWithMatrix:TBITintMatrixGrayscale];
}

- (NSImage *)sepiaImage
{
    return [self tintWithMatrix:TBITintMatrixSepia];
}

- (NSImage *)bluetoneImage
{
    return [self tintWithMatrix:TBITintMatrixBluetone];
}

@end
