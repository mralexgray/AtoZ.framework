//
//  AZCIFilters.h
//  AtoZ
//
//  Created by Alex Gray on 10/18/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


@interface AZIrisOpenFilter : CIFilter

@property (NATOM, retain) CIImage* inputImage;
@property (NATOM, retain) CIImage* inputTargetImage;
@property (NATOM, retain) NSNumber* inputTime;

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
