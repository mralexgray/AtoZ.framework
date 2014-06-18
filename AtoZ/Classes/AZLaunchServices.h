
/*! @abstract This class allows you to deal with some LaunchServices functions (such a Shared Lists, files types and extension information) via ligth-weight API. You can find the list of all availabe Shared Lists below:
*/

#import "AtoZUmbrella.h"

extern CFStringRef  kLSSharedFileListFavoriteVolumes,         kLSSharedFileListFavoriteItems,
                    kLSSharedFileListRecentApplicationItems,  kLSSharedFileListRecentDocumentItems,
                    kLSSharedFileListRecentServerItems,       kLSSharedFileListSessionLoginItems,
                    kLSSharedFileListGlobalLoginItems;

JREnumDeclare(AZItemsViewFormat, AZItemsAsBundleIDs,	AZItemsAsPaths,	AZItemsAsNames);

AZNSIFACEDECL(AZLaunchServices)

/* Convenience */
+ (NSA*) allApplications; // formatted as AZItemsAsNames

/* Shared lists */
+ (NSA*)    allItemsFromList:(CFStringRef)list_name;
+ (BOOL)      addItemWithURL:(NSURL*)url
                      toList:(CFStringRef)list_name;
+ (BOOL) removeItemWithIndex:(NSInteger)index
                    fromList:(CFStringRef)list_name;
+ (BOOL)   removeItemWithURL:(NSURL*)url
                    fromList:(CFStringRef)list_name;
+ (BOOL)           clearList:(CFStringRef)list_name;

/* Application abilities */
+ (NSA*)            allApplicationsFormattedAs:(AZItemsViewFormat)response_format;
+ (NSA*)allApplicationsAbleToOpenFileExtension:(NSS*)ext
                                responseFormat:(AZItemsViewFormat)response_format;

+ (NSA*)      allAvailableFileTypesForApplication:(NSS*)full_path;
+ (NSA*)      allAvailableMIMETypesForApplication:(NSS*)full_path;
+ (NSA*) allAvailableFileExtensionsForApplication:(NSS*)full_path;

/* General file info - MIME type, preferred extension and human-readable type*/
+ (NSS*)          humanReadableTypeForFile:(NSS*)full_path;
+ (NSS*)                   mimeTypeForFile:(NSS*)full_path;
+ (NSS*) preferredFileExtensionForMIMEType:(NSS*)mime_type;

+ (NSA*)           allAvailableFileExtensionsForUTI:(NSS*)file_type;
+ (NSA*)      allAvailableFileExtensionsForMIMEType:(NSS*)mime_type;
+ (NSA*)    allAvailableFileExtensionsForPboardType:(NSS*)pboard_type;
+ (NSA*) allAvailableFileExtensionsForFileExtension:(NSS*)extension;

@end	

@interface AZLaunchServicesListItem : NSObject
@prop_NA NSString *name;
@prop_NA NSURL *url;
@prop_NA NSImage *icon;
@end

//
//  AZLaunchServices.h
//  AtoZ
//
//  Created by Alex Gray on 8/17/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
/*
 EBLaunchServices.h
 Copyright (c) eric_bro, 2012 (eric.broska@me.com)

 Permission to use, copy, modify, and/or distribute this software for any
 purpose with or without fee is hereby granted, provided that the above
 copyright notice and this permission notice appear in all copies.

 THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.	*/

	//  This class allows you to deal with some LaunchServices functions (such a Shared Lists, files types and extension information) via ligth-weight API.
	//  You can find the list of all availabe Shared Lists below:
	//
	//  kLSSharedFileListFavoriteVolumes
	//  kLSSharedFileListFavoriteItems
	//  kLSSharedFileListRecentApplicationItems
	//  kLSSharedFileListRecentDocumentItems
	//  kLSSharedFileListRecentServerItems
	//  kLSSharedFileListSessionLoginItems
	//  kLSSharedFileListGlobalLoginItems
