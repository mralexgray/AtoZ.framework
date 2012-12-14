//
//  AZCIFilters.m
//  AtoZ
//
//  Created by Alex Gray on 10/18/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZCIFilters.h"
#import"NSError+AtoZ.h"
static NSMutableDictionary *classToKernel = nil;

@implementation AZIrisOpenFilter

/*
+ (void)initialize
{
	if (self == [AZIrisOpenFilter class]) {
		classToKernel = [[NSMutableDictionary alloc] init];
		return;
	}
//	OBASSERT(classToKernel); // superclasses should be initialized first

	// Subclasses might not be linked against a debug copy of this framework (3rd parties).  So, check at runtime.
	NSString *className = NSStringFromClass(self);
	if (![self conformsToProtocol:@protocol(AZConcreteIrisOpenFilter)]) {
		// Don't log here (we'll log down in +fitlerWithName: if they try to ask for something that didn't get registered)
		// This allows us to have abstract subclasses of OQSimpleFilter
		//NSLog(@"The subclass '%@' OQSimpleFilter does not conform to the 'OQConcreteSimpleFilter' protocol!", className);
		return;
	}

	NSBundle *bundle = [NSBundle bundleForClass:self];
	NSString *kernelSourceFileName = [self filterSourceFileName];
	NSString *kernelSourcePath = [bundle pathForResource:kernelSourceFileName ofType:@"cikernel"];
	if (!kernelSourcePath) {
		NSLog(@"Unable to locate '%@.cikernel' for filter class '%@' in bundle '%@'", kernelSourceFileName, className, bundle);
		return;
	}

	NSError *error = nil;
	NSString *kernelSource = [[NSString alloc] initWithContentsOfFile:kernelSourcePath encoding:NSUTF8StringEncoding error:&error];
	if (!kernelSource) {
		NSLog(@"Unable to load source for kernel for \"%@\" from \"%@\": %@", className, kernelSource, [error toPropertyList]);
		return;
	}

	NSArray *kernels = [CIKernel kernelsWithString:kernelSource];
//	OBASSERT([kernels count] == 1);

	CIKernel *kernel = [kernels objectAtIndex:0];
	[kernelSource release];
	if (!kernel) {
		NSLog(@"Unable to create kernel from source at '%@'", kernelSourcePath);
		return;
	}
	[classToKernel setObject:kernel forKey:(id)self];

	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								className, kCIAttributeFilterDisplayName,
								[NSArray arrayWithObject:@"OmniMagicWand Internal"], kCIAttributeFilterCategories, nil];

#if defined(MAC_OS_X_VERSION_10_7) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
	id constructor = (id <CIFilterConstructor>)self; // OBFinishPorting: Can't declare that the class implements CIFilterConstructor (just +filterWithName:).
#else
	id constructor = self;
#endif

	[CIFilter registerFilterName:className
					 constructor:constructor
				 classAttributes:attributes];
}
*/

+ (CIFilter *)filterWithName:(NSString *)name
{
	Class cls = NSClassFromString(name);
	if (!cls) {
		NSLog(@"%s: Unable to find class '%@'", __PRETTY_FUNCTION__, name);
		return nil;
	}

	if (![cls kernel]) {
		NSLog(@"%s: No kernel registered for class '%@' (perhaps it didn't conform to OQConcreteSimpleFilter)", __PRETTY_FUNCTION__, name);
		return nil;
	}

	return [[[cls alloc] init] autorelease];
}

+ (CIKernel *)kernel; {
	CIKernel *kernel = [classToKernel objectForKey:self];
//	OBASSERT(kernel);
	return kernel;
}

+ (NSString *)filterSourceFileName; {	return NSStringFromClass(self); }

//@end
//
//
//@implementation AZIrisOpenFilter
@synthesize inputImage, inputTime,inputTargetImage;



static CIKernel *sIrisFilterKernel = nil;

+(void) initialize
{
	[CIFilter registerFilterName: @"AZIrisOpenFilter"
					 constructor: (id)self
				 classAttributes: @{	kCIAttributeFilterDisplayName: @"Iris Open Effect",
									   kCIAttributeFilterCategories:@[kCICategoryTransition]}];
}
/*
+(CIFilter *) filterWithName: (NSString *)name
{
	CIFilter *filter = [[self alloc] init];
	return [filter autorelease];
}
*/
-(id) init
{
	if(sIrisFilterKernel == nil)
		{
		NSBundle *bundle  = [NSBundle bundleForClass: [self class]];
		NSString *code 	  = [NSString stringWithContentsOfFile:[bundle pathForResource: @"AZIrisOpenFilter" ofType: @"cikernel"]encoding:NSUTF8StringEncoding error:nil];
		NSArray *kernels  = [CIKernel kernelsWithString: code];
		sIrisFilterKernel = [kernels objectAtIndex: 0];
		}
	self = [super init];
	if( self )		inputTime = @0.5;
	return self;
}

-(void) dealloc
{
	[inputImage release];
	[inputTargetImage release];
	[inputTime release];

//	[super dealloc];
}

-(NSDictionary *) customAttributes
{
	return @{	kCIInputTimeKey: @{	kCIAttributeMin: 		@0.0,
									kCIAttributeMax: 		@1.0,
									kCIAttributeSliderMin:	@0.0,
									kCIAttributeSliderMax: 	@1.0,
									kCIAttributeDefault:		@0.5,
									kCIAttributeIdentity: 	@0.0 ,
									kCIAttributeType: 		kCIAttributeTypeScalar}};
}

-(CIImage *)outputImage
{
	CISampler *src 		= [CISampler samplerWithImage: inputImage];
	CISampler *target 	= [CISampler samplerWithImage: inputTargetImage];
	return [self apply: sIrisFilterKernel, src, target, inputTime, kCIApplyOptionDefinition, [src definition], nil];
}

@end