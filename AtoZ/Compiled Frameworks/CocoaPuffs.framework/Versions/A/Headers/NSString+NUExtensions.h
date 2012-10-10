
#import <Foundation/Foundation.h>

@interface NSString (NSStringTempFiles)

/**
 
 stringForPathToTemporaryFileWithTemplate:andExtension:
 
 \brief    Returns a path string to a file that is guaranteed to be unique 
           and resides in a temporary directory.
 
 \details  the method uses `mktemp` to create the path. This means that 
           `template` should be suffixed with X characters. These Xs will be
           replaced by random alpha-NUmeric characters. If you need a file 
           extension you can specify it using the `ext` parmeter otherwise 
           pass nil.
 
 \param    in template    string ending with a number of 'X' characters.
                          for example: @"myTempFileXXXXXXXX".
 
 \param    in ext         string to be appended as a file extension.
   
 \return   a path that is unique residing in a temporary directory.
 
 */
+ (NSString*) stringForPathToTemporaryFileWithTemplate:(NSString*)template andExtension:(NSString*)ext;

/// Returns like stringForPathToTemporaryFileWithTemplate:andExtension:
/// by passing a template of 16 consecutive Xs and `ext` for the file extension.
+ (NSString*) stringForPathToTemporaryFileWithExtension:(NSString*)ext;

/// Returns like stringForPathToTemporaryFileWithTemplate:andExtension:
/// by passing a `template` and nil for the file extension.
+ (NSString*) stringForPathToTemporaryFileWithTemplate:(NSString*)template;

/// Returns like stringForPathToTemporaryFileWithTemplate:andExtension:
/// by passing a template of 16 consecutive Xs and nil for the file extension.
+ (NSString*) stringForPathToTemporaryFile;

/// Returns the string where capital letters are prefixed with a space 
/// (to separate words in a camelCase string), underscores are substituted with 
/// a space, white space is trimmed from both the ends of the string, which is 
/// then capitalized. 
- (NSString*) stringWithTitleCase;

- (NSString*) stringByRemovingAccents;

/// Returns a UUID in the from of a string.
+ (NSString*) stringFromUUID;

@end
