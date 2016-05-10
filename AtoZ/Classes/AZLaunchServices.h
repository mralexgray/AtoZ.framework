
/*! @abstract This class allows you to deal with some LaunchServices functions (such a Shared Lists, files types and extension information) via ligth-weight API. You can find the list of all availabe Shared Lists below:
  
    @see NSBundle+AtoZ.h!
*/

extern CFStringRef  kLSSharedFileListFavoriteVolumes,         kLSSharedFileListFavoriteItems,
                    kLSSharedFileListRecentApplicationItems,  kLSSharedFileListRecentDocumentItems,
                    kLSSharedFileListRecentServerItems,       kLSSharedFileListSessionLoginItems,
                    kLSSharedFileListGlobalLoginItems;

_EnumKind(AZItemsViewFormat, AZItemsAsBundleIDs,	AZItemsAsPaths,	AZItemsAsNames);

@KIND(AZLaunchServices)

+ _List_ allApplications; // Conveniencem all apps formatted as AZItemsAsNames

/* Application abilities */

+ _List_                 pathsForAppsWithIdentifier __Text_ identifier ___

+ _List_               allApplicationsFormattedAs:(AZItemsViewFormat) f ___

+ _List_     allApplicationsAbleToOpenFileExtension __Text_ ext
                                     responseFormat:(AZItemsViewFormat) f ___

+ _List_        allAvailableFileTypesForApplication __Text_ full_path;

+ _List_        allAvailableMIMETypesForApplication __Text_ full_path;

+ _List_   allAvailableFileExtensionsForApplication __Text_ full_path;

/* General file info - MIME type, preferred extension and human-readable type*/

+ _Text_                   humanReadableTypeForFile __Text_ full_path;

+ _Text_                            mimeTypeForFile __Text_ full_path;

+ _Text_          preferredFileExtensionForMIMEType __Text_ mime_type;

+ _List_           allAvailableFileExtensionsForUTI __Text_ file_type;

+ _List_      allAvailableFileExtensionsForMIMEType __Text_ mime_type;

+ _List_    allAvailableFileExtensionsForPboardType __Text_ pboard_type;

+ _List_ allAvailableFileExtensionsForFileExtension __Text_ extension;

/* Shared lists */

+ _List_    allItemsFromList:(CFStringRef)list_name;

+ _IsIt_      addItemWithURL:(NSURL*)url
                      toList:(CFStringRef)list_name;

+ _IsIt_ removeItemWithIndex:(NSInteger)index
                    fromList:(CFStringRef)list_name;

+ (BOOL)   removeItemWithURL:(NSURL*)url
                    fromList:(CFStringRef)list_name;

+ (BOOL)           clearList:(CFStringRef)list_name;

@end	

/*!
 @brief	Methods which Apple should have provided in NSWorkspace	*/
@interface NSWorkspace (AppleShoulda)

_RC _Text appSupportSubdirectory ___

_VD registerDefaultsFromMainBundleFile __Text_ defaultsFilename ___

/*! [NSWorkspace appNameForBundleIdentifier:@"org.mgorbach.macfusion2"] = Macfusiob */

+ _Text_ appNameForBundleIdentifier __Text_ bundleIdentifier ___

/*! [NSWorkspace bundleIdentifierForAppName:@"Macfusion"] = org.mgorbach.macfusion2 */

+ _Text_ bundleIdentifierForAppName __Text_ appName ___


@end


@KIND(AZLaunchServicesListItem)
_NA _Text name ___
_NA _NUrl  url ___
_NA _Pict icon ___
@end

/*
//- (NSString*) appName;
//- (NSString*) appDisplayName;
//- (NSString*) appVersion;


   AZLaunchServices.h
   AtoZ
 
   Created by Alex Gray on 8/17/12.
   Copyright (c) 2012 mrgray.com, inc. All rights reserved.
 
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
