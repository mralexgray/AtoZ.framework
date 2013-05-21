/*
 *  NSObject+Properties.m
 *  AQToolkit
 *
 *  Created by Jim Dovey on 10/7/2008.
 *
 *  Copyright (c) 2008-2009, Jim Dovey
 *  All rights reserved.
 *  
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  Redistributions of source code must retain the above copyright notice,
 *  this list of conditions and the following disclaimer.
 *  
 *  Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *  
 *  Neither the name of this project's author nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 *  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	*/

#import <Foundation/Foundation.h>
#import "NSObject+Properties.h"
#import "AtoZ.h"

@implementation NSObject (AQProperties)

static const char * getPropertyType(objc_property_t property) 		{
	const char *attributes = property_getAttributes(property);
	printf("attributes=%s\n", attributes);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	char *state = buffer, *attribute;
	while ((attribute = strsep(&state, ",")) != NULL) {
		if (attribute[0] == 'T' && attribute[1] != '@') {
			// it's a C primitive type:
			/*
			 if you want a list of what will be returned for these primitives, search online for
			 "objective-c" "Property Attribute Description Examples"
			 apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
			 */
			return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
		}
		else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
			// it's an ObjC id type:
			return "id";
		}
		else if (attribute[0] == 'T' && attribute[1] == '@') {
			// it's another ObjC object type:
			return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
		}
	}
	return "";
}

+ (NSD*)classPropsFor:(Class)klass	{
	if (klass == NULL) {
		return nil;
	}

	NSMutableDictionary *results = [[[NSMutableDictionary alloc] init] autorelease];

	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList(klass, &outCount);
	for (i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if(propName) {
			const char *propType = getPropertyType(property);
			NSString *propertyName = [NSString stringWithUTF8String:propName];
			NSString *propertyType = [NSString stringWithUTF8String:propType];
			[results setObject:propertyType forKey:propertyName];
		}
	}
	free(properties);

	// returning a copy here to make sure the dictionary is immutable
	return [NSDictionary dictionaryWithDictionary:results];
}
/** @returns A string describing the type of the property		*/
+ (NSS*)propertyTypeStringOfProperty:(objc_property_t) property 	{
	const char *attr = property_getAttributes(property);
	NSString *const attributes = [NSString stringWithCString:attr encoding:NSUTF8StringEncoding];

	NSRange const typeRangeStart = [attributes rangeOfString:@"T@\""];  // start of type string
	if (typeRangeStart.location != NSNotFound) {
		NSString *const typeStringWithQuote = [attributes substringFromIndex:typeRangeStart.location + typeRangeStart.length];
		NSRange const typeRangeEnd = [typeStringWithQuote rangeOfString:@"\""]; // end of type string
		if (typeRangeEnd.location != NSNotFound) {
			NSString *const typeString = [typeStringWithQuote substringToIndex:typeRangeEnd.location];
			return typeString;
		}
	}
	return nil;
}
/** @returns (NSString) Dictionary of property name --> type	*/
+ (NSD*)classObjectPropertiesAndTypes 										{

//+ (NSD*)propertyTypeDictionaryOfClass:(Class)klass {
	NSMD *propertyMap = NSMD.new;
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
	for(i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if(propName) {
			NSS *propertyName = [NSS stringWithUTF8String:propName];
			NSS *propertyType = [self propertyTypeStringOfProperty:property];
			[propertyMap setValue:propertyType forKey:propertyName];
		}
	}
	free(properties);
	return propertyMap;
}
+ (NSD*)classPropertiesAndTypes 												{


	unsigned int i, count = 0;
	objc_property_t * properties = class_copyPropertyList( self, &count );
	if ( count == 0 ) {	free( properties );	return nil;	}

	NSMD * list = NSMD.new;

	for ( i = 0; i < count; i++ ) {
		NSS*name = [NSS stringWithUTF8String:property_getName(properties[i])];
		NSS *nsClass = [self propertyTypeStringOfProperty:properties[i]];
		if (!nsClass) {
			const char * whatever = property_getTypeString(properties[i]);
			nsClass = whatever ? [NSS stringWithUTF8String:whatever] : nil;
		}
		if (nsClass) [list setValue:nsClass forKey:name];
	}
	return list;
//
//	NSA* propN = self.propertyNames;
//	return [propN mapToDictionaryKeys:^id(NSS* object) {
//		NSS* typeName = [self.class ]
//		//[object UTF8String];
//		return propFromname ? [NSS stringWithUTF8String:propFromname] : nil;
//
//	}];
}
+ (BOOL) hasProperties															{
	unsigned int count = 0;
	objc_property_t * properties = class_copyPropertyList( self, &count );
	if ( properties != NULL )
		free( properties );
	
	return ( count != 0 );
}
+ (BOOL) hasPropertyNamed:     (NSS*)name									{
	return ( class_getProperty(self, [name UTF8String]) != NULL );
}
+ (BOOL) hasPropertyNamed:     (NSS*)name ofType:(const char*)ty	{

	objc_property_t property = class_getProperty( self, name.UTF8String );
	return  	property == NULL  	? ( NO )	:	strcmp(ty, property_getTypeString( property )) == 0;

//	const char * value = property_getTypeString( property );	return strcmp(ty, property_getTypeString( property )) == 0  ? ( YES ) : ( NO );
}
+ (BOOL) hasPropertyForKVCKey: (NSS*) key									{
	if ( [self hasPropertyNamed: key] )
		return ( YES );

	return ( [self hasPropertyNamed: [key propertyStyleString]] );
}
+ (const char*) typeOfPropertyNamed:     (NSS*) name					{
	objc_property_t property = class_getProperty( self, [name UTF8String] );
	if ( property == NULL )
		return ( NULL );
	
	return ( property_getTypeString(property) );
}
+ (SEL) getterForPropertyNamed:		     (NSS*) name					{
	objc_property_t property = class_getProperty( self, [name UTF8String] );
	if ( property == NULL )
		return ( NULL );
	
	SEL result = property_getGetter( property );
	if ( result != NULL )
		return ( NULL );
	
	if ( [self instancesRespondToSelector: NSSelectorFromString(name)] == NO )
		[NSException raise: NSInternalInconsistencyException 
					format: @"%@ has property '%@' with no custom getter, but does not respond to the default getter",
		 self, name];
	
	return ( NSSelectorFromString(name) );
}
+ (SEL) setterForPropertyNamed: 		 	  (NSS*) name					{
	objc_property_t property = class_getProperty( self, [name UTF8String] );
	if ( property == NULL )
		return ( NULL );
	
	SEL result = property_getSetter( property );
	if ( result != NULL )
		return ( result );
	
	// build a setter name
	NSMutableString * str = [NSMutableString stringWithString: @"set"];
	[str appendString: [[name substringToIndex: 1] uppercaseString]];
	if ( [name length] > 1 )
		[str appendString: [name substringFromIndex: 1]];
	
	if ( [self instancesRespondToSelector: NSSelectorFromString(str)] == NO )
		[NSException raise: NSInternalInconsistencyException 
					format: @"%@ has property '%@' with no custom setter, but does not respond to the default setter",
		 self, str];
	
	return ( NSSelectorFromString(str) );
}
+ (NSS*) retentionMethodOfPropertyNamed: (NSS*) name					{
	objc_property_t property = class_getProperty( self, [name UTF8String] );
	if ( property == NULL )
		return ( nil );
	
	const char * str = property_getRetentionMethod( property );
	if ( str == NULL )
		return ( nil );
	
	NSString * result = [NSString stringWithUTF8String: str];
	free( (void *)str );
	
	return ( result );
}
+ (NSA*) propertyNames															{
	unsigned int i, count = 0;
	objc_property_t * properties = class_copyPropertyList( self, &count );
	
	if ( count == 0 )
	{
		free( properties );
		return ( nil );
	}
	
	NSMutableArray * list = [NSMutableArray array];
	
	for ( i = 0; i < count; i++ )
		[list addObject:[NSS stringWithUTF8String:property_getName(properties[i])]];
	return [[[list alphabetize] copy] autorelease];
}
- (NSS*) properties 																{
	return [[self propertyNames]formatAsListWithPadding:30];
}
- (NSA*) propertyNames															{	return self.class.propertyNames;	}
- (NSD*) propertiesSans: 	  (NSS*)someKey 								{	return [self propertiesSansKeys:@[someKey]]; }
- (NSD*) propertiesSansKeys: (NSA*)someKeys								{	return [self.propertiesPlease subdictionaryWithKeys:
																									 	 [self.propertyNames arrayByRemovingObjectsFromArray:someKeys]]; }

- (NSS*) ppString 																{

	NSUI truncation = 20;
	NSA* phrases = [[self.propertyNames map:^id(id obj) { return [$(@"%@ : %@", obj, [self valueForKey:obj]) truncateInMiddleToCharacters:truncation]; }] arrayByAddingObjectToFront:@"Properties: \n"];
//	NSUI *mostLong = [[phrases sortedWithKey:@"length" ascending:NO].first length];
	return [phrases formatAsListWithPadding:truncation +3];
}
- (NSD*) propertiesPlease														{
	return [[[self.propertyNames cw_mapArray:^id(NSS* name) {
 		return [self hasPropertyForKVCKey:name] ? name : nil;
	}] cw_mapArray:^id(id canGet) {
		SEL getter = [self getterForPropertyNamed:canGet];
		return [self canPerformSelector:getter] ? NSStringFromSelector(getter) : nil;
	}] mapToDictionary:^id(id object) {
		return   [self performSelectorWithoutWarnings:NSSelectorFromString(object)];
	}];
/*
	NSMD *props = NSMD.new;
	unsigned outCount, i;
	objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
	for (i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];

		NSS *propertyName = [NSS.alloc initWithUTF8String:property_getName(property)];
		if (propertyName) {
			//			if ( [self hasPropertyForKVCKey:propertyName] &&
			if ([self respondsToString:propertyName]) {
				id propertyValue = [self valueForKey:propertyName];
				if (propertyValue) props[propertyName] = [propertyValue copy];
			}

		}else NSLog(@"Responds:%@ to:%@", StringFromBOOL([self respondsToString:propertyName]), propertyName);
	}
	free(properties);
	return props.copy;
	*/
}
- (NSD*) pp 																		{	return self.propertiesPlease; }
- (BOOL) hasProperties															{
	return ( [[self class] hasProperties] );
}
- (BOOL) hasPropertyNamed: (NSS*)name										{
	return ( [[self class] hasPropertyNamed: name] );
}
- (BOOL) hasPropertyNamed: (NSS*)name ofType:(const char*)type		{
	return ( [[self class] hasPropertyNamed: name ofType: type] );
}
- (BOOL) hasPropertyForKVCKey: 		     (NSS*)key						{
	return ( [[self class] hasPropertyForKVCKey: key] );
}
- (const char*) typeOfPropertyNamed:     (NSS*) name					{
	return ( [[self class] typeOfPropertyNamed: name] );
}
- (SEL) getterForPropertyNamed: 		     (NSS*) name					{
	return ( [[self class] getterForPropertyNamed: name] );
}
- (SEL) setterForPropertyNamed: 		 	  (NSS*) name					{
	return ( [[self class] setterForPropertyNamed: name] );
}
- (NSS*) retentionMethodOfPropertyNamed: (NSS*) name					{
	return ( [[self class] retentionMethodOfPropertyNamed: name] );
}

@end
/*
//- (NSD *)propertiesPlease { return [self.codableKeys mapToDictionaryKeys:^id(id object) { return [self valueForKey:object];}];
//	NSA* propN = self.propertyNames;	NSLog(@"trying to get props: %@", propN)	NSA *hasV = [propN cw_mapArray:^id(id object) {
////		return [self valueForKey:object] ? object : nil;
////	}];
////	NSLog(@"hasV: %@", hasV)
//	NSA * responds = [propN cw_mapArray:^id(NSS* select) {
//		return [self respondsToSelector:NSSelectorFromString(select)] ? select : nil;
//	}];
//	NSLog(@"responds: %@", responds)
//	return [responds mapToDictionaryKeys:^id(NSS*props) {	return [self performSelectorSafely:NSSelectorFromString(props)];	}];
//	}][self.class propertyTypeDictionaryOfClass:self.class];
//	return  [[props.allKeys cw_mapArray:^id(id object) {		return [self respondsToString:object] ? object : nil;	}] mapToDictionaryKeys:^id(NSS* propName) {		return [self valueForKey:propName];	}];

//	NSMD *props = NSMD.new;
//	unsigned outCount, i;
//	objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
//	for (i = 0; i < outCount; i++) {
//		objc_property_t property = properties[i];
//
//		NSS *propertyName = [NSS.alloc initWithUTF8String:property_getName(property)];
//		if (propertyName) {
////			if ( [self hasPropertyForKVCKey:propertyName] &&
//			if ([self respondsToString:propertyName]) {
//				id propertyValue = [self valueForKey:propertyName];
//				if (propertyValue) props[propertyName] = [propertyValue respondsToString:@"copy"] ? [propertyValue copy] : propertyValue;
//			}
//
//		}else NSLog(@"Responds:%@ to:%@", StringFromBOOL([self respondsToString:propertyName]), propertyName);
//	}
//	free(properties);
//	return props;
//}
*/
const char* property_getTypeString		 ( objc_property_t property )	{
	const char * attrs = property_getAttributes( property );
	if ( attrs == NULL )
		return ( NULL );
	
	static char buffer[256];
	const char * e = strchr( attrs, ',' );
	if ( e == NULL )
		return ( NULL );
	
	int len = (int)(e - attrs);
	memcpy( buffer, attrs, len );
	buffer[len] = '\0';
	
	return ( buffer );
}
		 SEL	property_getGetter	 		 ( objc_property_t property )	{
	const char * attrs = property_getAttributes( property );
	if ( attrs == NULL )
		return ( NULL );
	
	const char * p = strstr( attrs, ",G" );
	if ( p == NULL )
		return ( NULL );
	
	p += 2;
	const char * e = strchr( p, ',' );
	if ( e == NULL )
		return ( sel_getUid(p) );
	if ( e == p )
		return ( NULL );
	
	int len = (int)(e - p);
	char * selPtr = malloc( len + 1 );
	memcpy( selPtr, p, len );
	selPtr[len] = '\0';
	SEL result = sel_getUid( selPtr );
	free( selPtr );
	
	return ( result );
}
		 SEL	property_getSetter	       ( objc_property_t property )	{
	const char * attrs = property_getAttributes( property );
	if ( attrs == NULL )
		return ( NULL );
	
	const char * p = strstr( attrs, ",S" );
	if ( p == NULL )
		return ( NULL );
	
	p += 2;
	const char * e = strchr( p, ',' );
	if ( e == NULL )
		return ( sel_getUid(p) );
	if ( e == p )
		return ( NULL );
	
	int len = (int)(e - p);
	char * selPtr = malloc( len + 1 );
	memcpy( selPtr, p, len );
	selPtr[len] = '\0';
	SEL result = sel_getUid( selPtr );
	free( selPtr );
	
	return ( result );
}
const char* property_getRetentionMethod ( objc_property_t property )	{
	const char * attrs = property_getAttributes( property );
	if ( attrs == NULL )
		return ( NULL );
	
	const char * p = attrs;
	do
	{
		if ( p == NULL )
			break;
		
		if ( p[0] == '\0' )
			break;
		
		if ( p[1] == '&' )
			return ( "retain" );
		
		if ( p[1] == 'C' )
			return ( "copy" );
		
		p = strchr( p, ',' );
		
	} while (1);
	
	// this is the default, and thus has no specifier character in the attr string
	return ( "assign" );
}