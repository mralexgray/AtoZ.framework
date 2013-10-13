


#include <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>

int main(int argc, char *argv[], char**argp ){	@autoreleasepool {

	AZSHAREDAPP;


	[NSApp run];
	
}	return EXIT_SUCCESS;	}




//	[NSS randomUrabanDBlock:^(AZDefinition *d) {
//
//		[AZTalker say:[d.word withString:d.definition]];
//		XX(d.word);
//		XX(d.definition);
//		XX(d.propertyNamesAndTypes);
//	 	[AZGoogleImages searchGoogleImages:d.word withBlock:^(NSA*imageURLs){
//			[imageURLs each:^(id u) { 		[[NSImage imageFromURL:u] openInPreview];			}];
//			[AZSHAREDAPP performSelector:@selector(terminate:) withObject:nil afterDelay:6];
//		}];
//	}];
