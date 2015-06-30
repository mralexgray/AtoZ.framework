//
//  AZCIFilters.h
//  AtoZ
//
//  Created by Alex Gray on 10/18/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


@interface AZFilters : BaseModel
_RO NSA *filterNames;
@end

@interface AZIrisOpenFilter : CIFilter


@property (NA, retain) CIImage* inputImage;
@property (NA, retain) CIImage* inputTargetImage;
@property (NA, retain) NSNumber* inputTime;

+ (CIFilter*) filterWithName: (NSString *)name;
+ (CIKernel*) kernel;
+ (NSString*) filterSourceFileName; // "<name>.cikernel" must exist in the class's bundle

@end

//@interface OQSimpleFilter : CIFilter
//+ (CIKernel *)kernel;
//+ (NSString *)filterSourceFileName; // "<name>.cikernel" must exist in the class's bundle
//@end

// Subclasses must implement this protocol
@protocol AZConcreteIrisOpenFilter
- (CIImage *)outputImage; // Instances must use the kernel and pass their variables.
@end

@interface AZIrisOpenFilter (AZConcreteIrisOpenFilter) <AZConcreteIrisOpenFilter>
@end
