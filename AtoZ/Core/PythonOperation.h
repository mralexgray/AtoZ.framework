//
//  PythonOperation.h
//  AtoZ
//
//  Created by Alex Gray on 09/03/2013.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PYO PythonOperation
#import <QuartzCore/QuartzCore.h>
#import "AtoZ.h"


@interface  PYRunner : BaseModel
@property (nonatomic, assign) dispatch_once_t interpreter;
@end

@interface PythonOperation : NSOperation

- (id)	 initInDir:(NSS*)d withPath:(NSS*)path pythonPATH:(NSS*)pyPath optArgs:(NSA*)a;
+ (instancetype) inDir:(NSS*)d withPath:(NSS*)p pythonPATH:(NSS*)py optArgs:(NSA*)a;

	// Downloads the specific URL to a unique file within the specified
	// directory.  depth is just along for the ride.
 
// Things that are configured by the init method and can't be changed.
 
@property (copy,   readonly ) NSString 		*workingD, *spriptP, *pyPATH;
@property (copy,   readonly ) NSA 			*optArgs;

@property (nonatomic,readonly) int	exitStatus;
 
// Things that are only meaningful after the operation is finished.
 
//@property (copy,   readonly ) NSString *	imageFilePath;

@end
