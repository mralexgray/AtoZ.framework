/* Copyright (c) 2006-2007 Johannes Fortmann

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
#import <Foundation/NSObject.h>

@class NSDictionary, NSArray, NSError;

FOUNDATION_EXPORT NSString * const NSUndefinedKeyException;

@interface NSObject (KeyValueCoding)
+(BOOL)accessInstanceVariablesDirectly;

// primitive methods
-(id)valueForKey:(NSString*)key;
-(void)setValue:(id)value forKey:(NSS*)key;
-(BOOL)validateValue:(id *)ioValue forKey:(NSS*)key error:(NSERR*__autoreleasing*)outError;

// key path methods
-(id)valueForKeyPath:(NSString*)keyPath;
-(void)setValue:(id)value forKeyPath:(NSS*)keyPath;
-(BOOL)validateValue:(id *)ioValue forKeyPath:(NSS*)keyPath error:(NSERR*__autoreleasing*)outError;

// dictionary methods
-(NSD*)dictionaryWithValuesForKeys:(NSA*)keys;
-(void)setValuesForKeysWithDictionary:(NSD*)keyedValues;

// undefined keys etc.
-(id)valueForUndefinedKey:(NSS*)key;
-(void)setValue:(id)value forUndefinedKey:(NSS*)key;
-(void)setNilValueForKey:(id)key;

-(id)mutableArrayValueForKey:(id)key;
-(id)mutableArrayValueForKeyPath:(id)keyPath;
@end
