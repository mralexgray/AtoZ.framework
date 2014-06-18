//
//  AZLaunchServices.m
//  AtoZ
//
//  Created by Alex Gray on 8/17/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
@import CoreServices;
#import "AtoZ.h"
#import "AZLaunchServices.h"

JREnumDefine(AZItemsViewFormat);

NSString * CoercePlist (NSString* path) {

  return [path hasSuffix:@".plist"] ? path :
         [path hasSuffix:@".app"] ? [NSBundle bundleWithPath:path].infoPlistPath : path;

//        isExe = [AZFILEMANAGER fileExistsAtPath:path];
  return @"";

}
/* Private prototype from the LaunchServices framework */
OSStatus _LSCopyAllApplicationURLs(CFArrayRef *array);
typedef  id (^AZMappingBlock)(id obj);

@implementation AZLaunchServicesListItem @end

//@interface AZLaunchServices (Private)
//+ (NSA*)mappingArray:(NSA*)array usingBlock:(AZMappingBlock)block;
//+ (NSInteger)indexOfItemWithURL:(NSURL*)url inList:(CFStringRef)list_name;
//+ (NSA*)prepareArray:(NSA*)array withFormat:(AZItemsViewFormat)format;
//@end

@implementation AZLaunchServices

#pragma mark Shared Lists

+ (NSA*)allItemsFromList:(CFStringRef)list_name {
	LSSharedFileListRef list = LSSharedFileListCreate(NULL, (CFStringRef)list_name, NULL);
	NSA*tmp = (NSA*)LSSharedFileListCopySnapshot(list, NULL);
	CFRelease(list);
	id value = [AZLaunchServices mappingArray: tmp usingBlock:^id(id obj) {
		AZLaunchServicesListItem *item =AZLaunchServicesListItem.new;
		[item setName: [(NSS*)LSSharedFileListItemCopyDisplayName((LSSharedFileListItemRef)obj) autorelease]];
		NSURL *url = nil;
		LSSharedFileListItemResolve((LSSharedFileListItemRef)obj, 0, (CFURLRef*)&url, NULL);
		if (url) [item setUrl: url];
		[item setIcon: [[NSImage.alloc initWithIconRef:
						 LSSharedFileListItemCopyIconRef((LSSharedFileListItemRef)obj)] autorelease]];
		return [item autorelease];
	}];
	CFRelease(tmp);
	return (value);
}

+ (BOOL)addItemWithURL:(NSURL*)url toList:(CFStringRef)list_name {
	LSSharedFileListRef list = LSSharedFileListCreate(NULL, (CFStringRef)list_name, NULL);
	if (!list) return NO;
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(list,
																 kLSSharedFileListItemLast,
																 NULL, NULL,
																 (CFURLRef)url,
																 NULL, NULL);
	CFRelease(list);
	return item ? (CFRelease(item), YES) : NO;
}

+ (BOOL)removeItemWithIndex:(NSInteger)index fromList:(CFStringRef)list_name {
	if (index == -1) return NO;
	LSSharedFileListRef list = LSSharedFileListCreate(NULL, (CFStringRef)list_name, NULL);
	LSSharedFileListItemRef item_to_remove = (LSSharedFileListItemRef)((NSA*)LSSharedFileListCopySnapshot(list, NULL))[index];
	if (!item_to_remove || !list) return (NO);
	LSSharedFileListItemRemove(list , item_to_remove);
	CFRelease(list);
	return (YES);
}

+ (BOOL)removeItemWithURL:(NSURL*)url fromList:(CFStringRef)list_name {
	return [AZLaunchServices removeItemWithIndex:
			[AZLaunchServices indexOfItemWithURL: url inList: (CFStringRef)list_name]
										fromList: list_name];
}

+ (BOOL)clearList:(CFStringRef)list_name {
	LSSharedFileListRef list = LSSharedFileListCreate(NULL, (CFStringRef)list_name, NULL);
	BOOL isok = (LSSharedFileListRemoveAllItems(list) == noErr);
	return (CFRelease(list), isok);
}
#pragma mark Applications

+ (NSA*)allApplications { return [self allApplicationsFormattedAs:AZItemsAsNames]; }

+ (NSA*)allApplicationsFormattedAs:(AZItemsViewFormat)response_format {

	NSA*tmp = nil;
	_LSCopyAllApplicationURLs((CFArrayRef*)&tmp);
	return [AZLaunchServices prepareArray: [tmp autorelease] withFormat: response_format];

}

+ (NSA*)allApplicationsAbleToOpenFileExtension:(NSS*)extension
                                     responseFormat:(AZItemsViewFormat)response_format
{
	CFStringRef uttype = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
															   (CFStringRef)extension, NULL);
	CFArrayRef bundles = LSCopyAllRoleHandlersForContentType(uttype, kLSRolesAll);
	CFRelease(uttype);
	if (!bundles) return nil;
	return [AZLaunchServices prepareArray: [(NSA*)bundles autorelease]
							   withFormat: response_format];
}
+ (NSA*)allAvailableFileTypesForApplication:(NSS*)full_path
{
	NSA*all_doc_types = [NSDictionary dictionaryWithContentsOfFile: full_path][@"CFBundleDocumentTypes"];
	if ( ! all_doc_types) return nil;

	return [AZLaunchServices mappingArray: all_doc_types
							   usingBlock:^id(NSDictionary * obj) {
								   /* Use 0 as index because it's highest level of file types' hierarchy */
								   id tmp =  obj[@"LSItemContentTypes"][0];
								   return tmp;
							   }];
}

/* Return only MIMEs defined in LaunchService database */
+ (NSA*)allAvailableMIMETypesForApplication:(NSS*)full_path {

	NSA*all_doc_types = [NSDictionary dictionaryWithContentsOfFile: full_path][@"CFBundleDocumentTypes"];
	if ( ! all_doc_types) return nil;

	return [AZLaunchServices mappingArray: all_doc_types usingBlock:^id(id obj) {

		NSA* tmp_array = obj[@"LSItemContentTypes"];
		/* If we can't recognize a MIME type for some file type - take a look on it' parent type */
		/* e.g. com.pkware.zip-archive (no MIME type) --> public.zip-archive (MIME is OK)*/
		id value = nil;
		for (NSUInteger i = 0; i < [tmp_array count] && !value; i++) {
			value = (NSS*)UTTypeCopyPreferredTagWithClass((CFStringRef)tmp_array[i],
																kUTTagClassMIMEType);
		}
		return value;
	}];
}

+ (NSA*)allAvailableFileExtensionsForApplication:(NSS*)full_path {

	NSA*all_doc_types = [NSDictionary dictionaryWithContentsOfFile: full_path][@"CFBundleDocumentTypes"];
	if ( !all_doc_types) {
		return nil;
	}
	NSMutableArray *value = NSMA.new;
	[all_doc_types enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[value addObjectsFromArray: obj[@"CFBundleTypeExtensions"]];
	}];
	return [value autorelease];
}


#pragma mark Files

#define fileExists(x) ([[NSFileManager defaultManager] fileExistsAtPath: (x)])

+ (NSS*)humanReadableTypeForFile:(NSS*)full_path {

	if ( ! fileExists(full_path)) return nil;

	FSRef fsref; CFStringRef ftype;
	FSPathMakeRef((const UInt8*)[full_path fileSystemRepresentation], &fsref, NULL);
	LSCopyKindStringForRef(&fsref, &ftype);
	NSS * value = (NSS*)ftype;
	CFRelease(ftype);
	return value;
}

+ (NSS*)mimeTypeForFile:(NSS*)full_path {

	if ( ! fileExists(full_path)) return nil;

	NSS * extension = [full_path pathExtension];
	if (!extension || [extension isEqualToString: @""]) return nil;

	CFStringRef uttype = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
															   (CFStringRef)extension, NULL);
	CFStringRef mime = UTTypeCopyPreferredTagWithClass(uttype, kUTTagClassMIMEType);
	CFRelease(uttype);
	return mime ? [(NSS*)mime autorelease] : nil;
}

+ (NSA*)allAvailableFileExtensionsForUTI:(NSS*)file_type
{
	NSDictionary * tmp_dict = (NSDictionary*)UTTypeCopyDeclaration((CFStringRef)file_type);
	id value = [[tmp_dict valueForKey: @"UTTypeTagSpecification"]
				valueForKey: @"public.filename-extension"];
	[tmp_dict release];

	return ISA(value,NSA) ? value : @[value];
}

+ (NSS*)preferredFileExtensionForMIMEType:(NSS*)mime_type
{
	CFStringRef uttype = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,
															   (CFStringRef)mime_type, NULL);
	CFStringRef extension = UTTypeCopyPreferredTagWithClass(uttype, kUTTagClassFilenameExtension);
	CFRelease(uttype);
	return extension ? [(NSS*)extension autorelease] : nil;
}

+ (NSA*)allAvailableFileExtensionsForMIMEType:(NSS*)mime_type
{
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,
															(CFStringRef)mime_type, NULL);
	id value = [AZLaunchServices allAvailableFileExtensionsForUTI: (NSS*)uti];
	return (CFRelease(uti), value);
}

+ (NSArray *)allAvailableFileExtensionsForPboardType:(NSS*)pboard_type
{
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassNSPboardType,
															(CFStringRef)pboard_type, NULL);
	id value = [AZLaunchServices allAvailableFileExtensionsForUTI: (NSS*)uti];
	return (CFRelease(uti), value);
}

+ (NSA*)allAvailableFileExtensionsForFileExtension:(NSS*)extension
{
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
															(CFStringRef)extension, NULL);
	id value = [AZLaunchServices allAvailableFileExtensionsForUTI: (NSS*)uti];
	return (CFRelease(uti), value);
}

#pragma mark Private

+ (NSA*)prepareArray:(NSA*)array withFormat:(/*enum */AZItemsViewFormat)format { return

  format == AZItemsAsPaths ? [AZLaunchServices mappingArray: array usingBlock:^id(id obj) {

				id path = [AZWORKSPACE absolutePathForAppBundleWithIdentifier: obj];
				return path;;
  }]
: format == AZItemsAsNames ? [AZLaunchServices mappingArray: array usingBlock:^id(id obj) {
        return [AZFILEMANAGER displayNameAtPath:
						   [AZWORKSPACE absolutePathForAppBundleWithIdentifier: obj]]; // name
  }] : array;
}

+ (NSInteger)indexOfItemWithURL:(NSURL*)url inList:(CFStringRef)list_name {
	NSA*tmp = [AZLaunchServices allItemsFromList: list_name];
	NSInteger idx = -1;
	return [tmp indexOfObjectPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [[(AZLaunchServicesListItem*)obj url] isEqualTo: url];
	}]; // idx
}
/* Going throw an array's elements doing something with them, and create items for a new array */

+ (NSA*)mappingArray:(NSA*)array usingBlock:(AZMappingBlock)block {

	NSUInteger count = array.count;
	id *objects = malloc(sizeof(objects)*count);
	[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		objects[idx] = [block(obj) retain];
		if ( ! objects[idx]) objects[idx] = AZNULL;
	}];
	NSMutableArray *return_value = [NSArray arrayWithObjects: objects count: count].mC;
	[return_value removeObjectsAtIndexes:
	 [return_value indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj isEqualTo: [NSNull null]];
	}]];

	for (NSUInteger i = 0; i < count; i++) [objects[i] release];
	free(objects);
	return (return_value);
}

@end
