//
//  AZBeetljuice.h
//  AtoZ
//
//  Created by Alex Gray on 5/2/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//
#ifndef AtoZ_AZBeetljuice_h
#define AtoZ_AZBeetljuice_h
NS_INLINE void AZBeetlejuiceLoadAtoZ (void) {
	NSString *basePath = @"/Volumes/2T/ServiceData/Developer/Xcode/DerivedData/AtoZ-hfqteqfcvjfinlajqwkydsqyzpiz/Build/Products/Debug/AtoZ.framework/Versions/A/Frameworks";
	NSString* path = basePath.stringByDeletingLastPathComponent
									.stringByDeletingLastPathComponent
									 .stringByDeletingLastPathComponent;
	fprintf ( stderr, "Preflighting path: %s\n", path.UTF8String);
	NSBundle *b = [NSBundle bundleWithPath:  path];
	NSLog(@"bundle:%@",b);
	NSError *e;
	BOOL okdok = [b preflightAndReturnError:&e];
	if (okdok) {	[b load];	NSLog(@"%@ %@  %@  %@",path, b, e, [b bundleIdentifier] ); 	}
	else fprintf(stderr, "%s\n", e.debugDescription.UTF8String);
}
#endif
