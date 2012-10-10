/**
 
 \category  NSURL(CompatibleUTTypes)
 
 \brief     Adds methods that allows the user to test UTType conformity of
            resources pointed to by URLs.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <Foundation/Foundation.h>

@interface NSURL (CompatibleUTTypes)

/// Returns YES if the URL points to something that conforms to the type.
- (BOOL) conformsToType:(NSString*)type;

/// Returns YES if the URL points to something that conform to at least one
/// of the types in the array.
- (BOOL) conformsToAnyTypeInTypes:(NSArray*)types;

/// Process the lines in the file content one at a time.
/// Returns the number of lines processed.
- (NSUInteger) eachLine:(void(^)(uint64_t line_no, char *text, long length, BOOL *stop))handler;

/// Process each field in a file where fields are seperated by newlines or splitChar.
- (NSUInteger) eachFieldSplitBy:(char)splitChar do:(void(^)(uint64_t line_no, uint64_t field_no, char *field, long length, BOOL *stop))handler;

/// Process each field in a file expecting N fields per line.
- (NSUInteger) eachFieldSplitBy:(char)splitChar fieldCount:(uint64_t)fieldCount do:(void(^)(uint64_t line_no, uint64_t field_no, char *field, long length, BOOL *stop))handler;

/// Returns the UTI for this URL.
- (NSString*) URLTypeIdentifier;

@end
