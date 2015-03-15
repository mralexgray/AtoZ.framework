


#import <AtoZUniversal/AtoZUniversal.h>
@import FunSize; // maptoDictionary

       SEL	          property_getGetter (objc_property_t property) {
	const char *attrs = property_getAttributes( property );
	if ( attrs == NULL ) return ( NULL );

	const char *p = strstr( attrs, ",G" );
	if ( p == NULL ) return ( NULL );

	p += 2;
	const char *e = strchr( p, ',' );
	if ( e == NULL ) return ( sel_getUid(p) );
	if ( e == p ) return ( NULL );

	int len = (int)(e - p);
	char *selPtr = malloc( len + 1 );
	memcpy( selPtr, p, len );
	selPtr[len] = '\0';
	SEL result = sel_getUid( selPtr );
	free( selPtr );

	return ( result );
}
		   SEL	          property_getSetter (objc_property_t property) {
	const char *attrs = property_getAttributes( property );
	if ( attrs == NULL ) return ( NULL );

	const char *p = strstr( attrs, ",S" );
	if ( p == NULL ) return ( NULL );

	p += 2;
	const char *e = strchr( p, ',' );
	if ( e == NULL ) return ( sel_getUid(p) );
	if ( e == p ) return ( NULL );

	int len = (int)(e - p);
	char *selPtr = malloc( len + 1 );
	memcpy( selPtr, p, len );
	selPtr[len] = '\0';
	SEL result = sel_getUid( selPtr );
	free( selPtr );

	return ( result );
}
const char *      property_getTypeString (objc_property_t property) {

	const char *attrs = property_getAttributes(property);
	if (attrs == NULL) return NULL;
	static char buffer[256];
	const char *e = strchr(attrs, ',');
	if (e == NULL) return NULL;
	int len = (int)(e - attrs);
	memcpy( buffer, attrs, len );
	buffer[len] = '\0';
	return ( buffer );
}
const char * property_getRetentionMethod (objc_property_t property) {
	const char *attrs = property_getAttributes( property );
	if ( attrs == NULL ) return ( NULL );

	const char *p = attrs;
	do
	{
		if ( p == NULL ) break;

		if ( p[0] == '\0' ) break;

		if ( p[1] == '&' ) return ( "retain" );

		if ( p[1] == 'C' ) return ( "copy" );

		p = strchr( p, ',' );
	} while (1);

	// this is the default, and thus has no specifier character in the attr string
	return ( "assign" );
}

@implementation NSObject (AQProperties)

- (INST)    objectBySettingValuesWithDictionary:(NSD*)d   { [self sVs:d.allValues fKs:d.allKeys]; return self; }
- (INST) objectBySettingValues:(NSA*)vs forKeys:(NSA*)ks  { [self sVs:vs fKs:ks];                 return self; }
- (INST)  objectBySettingValue: v     forKey:(NSS*)k   {

  if ([self canSetValueForKey:k]) [self sV:v fK:k];
  else [self respondsToStringThenDo:@"setObject:forKey:" withObject:k withObject:v];

  return self;
}

- _Void_         incrementKey:(NSS*)k by:(NSN*)v { id n = [self vFK:k]; if(ISA(n,NSN)) [self sV:[n plus:v] fK:k]; }
- (INST) objectByIncrementing:(NSS*)k by:(NSN*)v { [self incrementKey:k by:v]; return self; }

- _Void_  setKVs: firstKey,... { id item = nil, key = firstKey; va_list list; va_start(list, firstKey);

  while (!!key && (item = va_arg(list, id))) { [self sV:item fK:key]; key = va_arg(list, id); } va_end(list);
}
- _Void_  setValuesForKeys:(AZKP*)kp,... { azva_list_to_nsarray(kp,keyVals);

  [keyVals each:^(AZKP* obj) { [self sV:obj.value fK:obj.key]; }];
}
- (INST) withValuesForKeys: v,...     { azva_list_to_nsarray(v,vals); return [self objectBySettingVariadicPairs:vals]; }
- (INST)            wVsfKs: v,...     { azva_list_to_nsarray(v,vals); return [self objectBySettingVariadicPairs:vals]; }

- (INST) objectBySettingVariadicPairs:(NSA*)vsForKs { AZBlockSelf(x); [vsForKs eachWithVariadicPairs:^(id a,id b){ [x setValue:a forKey:b]; }]; return x; }

static const char* getPropertyType    (objc_property_t property) 	{
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

+ (NSS*) propertyTypeStringOfProperty:(objc_property_t)property	{
	const char *attr = property_getAttributes(property);
	NSString *const attributes = [NSString stringWithCString:attr encoding:NSUTF8StringEncoding];

	NSRange const typeRangeStart = [attributes rangeOfString:@"T@\""];	  // start of type string
	if (typeRangeStart.location != NSNotFound) {
		NSString *const typeStringWithQuote = [attributes substringFromIndex:typeRangeStart.location + typeRangeStart.length];
		NSRange const typeRangeEnd = [typeStringWithQuote rangeOfString:@"\""];		 // end of type string
		if (typeRangeEnd.location != NSNotFound) {
			NSString *const typeString = [typeStringWithQuote substringToIndex:typeRangeEnd.location];
			return typeString;
		}
	}
	return nil;
}/** @returns A string describing the type of the property		*/
+ (NSD *)classPropsFor:(Class)klass	  				{
	if (klass == NULL) {
		return nil;
	}
	NSMutableDictionary *results = NSMutableDictionary.new;

	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList(klass, &outCount);
	for (i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if (propName) {
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
+ (NSD*) classObjectPropertiesAndTypes				{
//+ (NSD*)propertyTypeDictionaryOfClass:(Class)klass {
	NSMD *propertyMap = NSMD.new;
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
	for (i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if (propName) {
			NSS *propertyName = [NSS stringWithUTF8String:propName];
			NSS *propertyType = [self propertyTypeStringOfProperty:property];
			[propertyMap setValue:propertyType forKey:propertyName];
		}
	}
	free(properties);
	return propertyMap;
}	/** @returns (NSString) Dictionary of property name --> type	*/
+ (NSD*) classPropertiesAndTypes						{
	unsigned int i, count = 0;
	objc_property_t *properties = class_copyPropertyList( self, &count );
	if ( count == 0 ) {
		free( properties );	 return nil;
	}
	NSMD *list = NSMD.new;

	for ( i = 0; i < count; i++ ) {
		NSS *name = [NSS stringWithUTF8String:property_getName(properties[i])];
		NSS *nsClass = [self propertyTypeStringOfProperty:properties[i]];
		if (!nsClass) {
			const char *whatever = property_getTypeString(properties[i]);
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
+ (BOOL) hasProperties									{
	unsigned int count = 0;
	objc_property_t *properties = class_copyPropertyList( self, &count );
	if ( properties != NULL ) free( properties );

	return ( count != 0 );
}
+ (BOOL) hasPropertyNamed:(NSS*)name				{
	return ( class_getProperty(self, [name UTF8String]) != NULL );
}
+ (BOOL) hasPropertyNamed:(NSS*)name 
						 ofType:(const char *)ty		{
	objc_property_t property = class_getProperty( self, name.UTF8String );
	return property == NULL ? NO : strcmp(ty, property_getTypeString( property )) == 0;

//	const char * value = property_getTypeString( property );	return strcmp(ty, property_getTypeString( property )) == 0  ? ( YES ) : ( NO );
}
+ (BOOL) hasPropertyForKVCKey:		(NSS*)key	{
	return [self hasPropertyNamed:key] ? : [self hasPropertyNamed:[key propertyStyleString]];
}
+ (const char*) typeOfPropertyNamed:(NSS*)name	{

	objc_property_t property = class_getProperty( self, [name UTF8String] );
	if ( property == NULL ) return ( NULL );

	return ( property_getTypeString(property) );
}
//+ (NSS*) typeOrClassNameOfProperty:(NSS*)name	{ 
+ (SEL) getterForPropertyNamed:		(NSS*)name	{
	objc_property_t property = class_getProperty( self, name.UTF8String );
	if ( property == NULL ) return NULL;

	SEL result = property_getGetter( property );
	if ( result != NULL ) return NULL;

	return [self instancesRespondToSelector:NSSelectorFromString(name)] ? NSSelectorFromString(name) :
		[$(@"%@ has property '%@' with no custom getter, but does not respond to the default getter",
			self, name) log], NULL;
//		[NSException raise:NSInternalInconsistencyException
//			format:@"%@ has property '%@' with no custom getter, but does not respond to the default getter",
//			self, name, nil], NULL;
}
+ (SEL) setterForPropertyNamed:		(NSS*)name	{
	objc_property_t property = class_getProperty( self, [name UTF8String] );
	if ( property == NULL ) return ( NULL );

	SEL result = property_getSetter( property );
	if ( result != NULL ) return ( result );

	// build a setter name
	NSMutableString *str = [NSMutableString stringWithString:@"set"];
	[str appendString:[[name substringToIndex:1] uppercaseString]];
	if ( [name length] > 1 ) [str appendString:[name substringFromIndex:1]];

	if ( [self instancesRespondToSelector:NSSelectorFromString(str)] == NO )
		[NSException raise:NSInternalInconsistencyException
		 format:@"%@ has property '%@' with no custom setter, but does not respond to the default setter",
		 self, str];

	return ( NSSelectorFromString(str) );
}
+ (NSS*) retentionMethodOfPropertyNamed:(NSS*)n	{
	objc_property_t property = class_getProperty( self, [n UTF8String] );
	if ( property == NULL ) return ( nil );
	const char *str = property_getRetentionMethod( property );
	if ( str == NULL ) return ( nil );
	NSString *result = [NSString stringWithUTF8String:str];
	free( (void *)str );
	return ( result );
}
+ (NSA*) propertyNames									{ return [self propertyList]; }

//   unsigned int propertyCount;
//   objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
//	if (!propertyCount) return free( properties ), nil;
//	NSMutableArray *list = NSMA.new;
//	for (unsigned int i = 0; i < propertyCount; i++)
//	{
//   	NSString *selector = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
//		if (selector) [list addObject:selector];
//	}
//	return free( properties ), list;
//}
- (NSD*) propertyNamesAndTypes						{ return [self.class propertyNamesAndTypes]; }
+ (NSD*) propertyNamesAndTypes						{

	
	unsigned int i, count = 0;
	objc_property_t *properties = class_copyPropertyList( self, &count );

	if ( count == 0 ) {
		free( properties );
		return ( nil );
	}
	NSMutableArray *list = [NSMutableArray array];

	for ( i = 0; i < count; i++ ) {
		[list addObject:[NSS stringWithUTF8String:property_getName(properties[i])]];
	}
	
	return [list.alphabetize reduce:NSMD.new withBlock:^id(NSMD * sum, id obj) { NSS *type = nil;
		const char* t = [self typeOfPropertyNamed:obj]; if (t != NULL)  type = $UTF8(t).humanReadableEncoding; 
    if (!type) return sum;
		if (![sum objectForKey:type]) [sum setValue:@[obj].mutableCopy forKey:type];
		else [(NSMA*)[sum objectForKey:type] addObject:obj];
		return sum;
	}];
}

- (NSS*) properties_disabled	{ return [self.propertyNames formatAsListWithPadding:30]; }

- (NSA*) propertyNames									{
	return self.class.propertyNames;
}
- (NSD*) propertiesSans:(NSS*) someKey				{
	return [self propertiesSansKeys:@[someKey]];
}
- (NSD*) propertiesSansKeys:(NSA*) someKeys		{
	return [self.propertiesPlease subdictionaryWithKeys:
			[self.propertyNames arrayByRemovingObjectsFromArray:someKeys]];
}
- (NSS*) ppString                      {// NSUI truncation = 25;

  NSA *props = [self.propertyNames reduce:@[@"Properties: \n"].mC withBlock:^id(id sum, id obj) {
  
      id x = [self vFK:obj], z =[x className]; z = [NSClassFromString(@"AtoZ") performString:@"macroFor:" withObject:z] ?: z;

      [sum addObject:$(@"%@:%@ [%@]", obj, ISA(x,NSA)||ISA(x,NSD) ? $(@"@count.%lu", [x count]) : x, 
        
          $UTF8([self typeOfPropertyNamed:obj]).humanReadableEncoding ).stringByRemovingReturns];
      return sum;
  }]; 
  return [props formatAsListWithPadding:props.lengthOfLongestMemberString + 3];// truncation + 3];
  
//	NSA *phrases = [[self.propertyNames.alphabetized mapArray:^id (id obj) { 
//    id x = [self vFK:obj], z = [x className]; z = [AtoZ macroFor:z] ?: z;
//    
//    return [$(@"%@:%@ [%@]", obj, ISA(x,NSA)||ISA(x,NSD) ? $(@"@count.%lu", [x count]) : x,z) 
//            truncateInMiddleToCharacters:truncation]; 
            
//  }] arrayByAddingObjectToFront:@"Properties: \n"];
//	NSUI *mostLong = [[phrases sortedWithKey:@"length" ascending:NO].first length];
//	return [phrases formatAsListWithPadding:truncation + 3];

}
+ (NSA*) objcProperties 								{
	NSArray *result = [self objcPropertiesWithoutSuperclass];

	Class superclass = class_getSuperclass(self);

	if (superclass == [NSObject class]) {
		return result;
	}
	return [result arrayByAddingObjectsFromArray:[superclass objcProperties]];
}
+ (NSA*) objcPropertiesWithoutSuperclass 			{
//	unsigned int nrOfProps;
//	objc_property_t *properties = class_copyPropertyList(self, &nrOfProps);
//
	NSMutableArray *result = NSMutableArray.new; // arrayWithCapacity:nrOfProps];
//	for (int i = 0; i < nrOfProps; i++) {
//		TBObjcProperty *property = [[TBObjcProperty allocWithZone:nil] initWithProperty:properties[i]];
//		[result addObject:property];
//	}
//
//	free(properties);

	return result;
}
- (NSD*) propertiesPlease								{

	return [[[self.propertyNames map:^id (NSS *name) { SEL select = NULL;
		if ((select = [self getterForPropertyNamed:name]) != NULL) return nil;
		return [self respondsToSelector:select] && [self hasPropertyForKVCKey:name] ? name : nil;
	}] map:^id (id canGet) {
		SEL getter = [self getterForPropertyNamed:canGet];
		return [self canPerformSelector:getter] ? NSStringFromSelector(getter) : nil;
	}] mapToDictionary:^id (id object) {
		return [self performSelectorWithoutWarnings:NSSelectorFromString(object)];
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
- (NSD*) pp										 	 		{
	return self.propertiesPlease;
}
- (BOOL) hasProperties									{
	return ( [[self class] hasProperties] );
}
- (BOOL) hasPropertyNamed:				(NSS*)name	{
	return ( [[self class] hasPropertyNamed:name] );
}
- (BOOL) hasPropertyNamed:				(NSS*)name 
						 ofType:   (const char*)type	{
	return ( [[self class] hasPropertyNamed:name ofType:type] );
}
- (BOOL) hasPropertyForKVCKey:		(NSS*)key	{
	return ( [[self class] hasPropertyForKVCKey:key] );
}
-(Class) classOfPropertyNamed:		(NSS*)name 	{
	NSString *classS = [self attributesOfProp:name][0];		 //  "T@\"NSShadow\""
//	LOG_EXPR(classS);
	return NSClassFromString([[classS substringAfter:@"@"]
          stringByReplacingAllOccurancesOfString:@"\"" withString:@""]);
}
- (const char*) typeOfPropertyNamed:(NSS*)name	{
	return ( [[self class] typeOfPropertyNamed:name] );
} // returns an @encode() or statictype() string. Copy to keep
-  (SEL) getterForPropertyNamed:		(NSS*)name	{
	return ( [[self class] getterForPropertyNamed:name] );
}
-  (SEL) setterForPropertyNamed:		(NSS*)name	{
	return ( [[self class] setterForPropertyNamed:name] );
}
- (NSA*) attributesOfProp:(NSS*)propName {
	objc_property_t prop = class_getProperty(self.class, [propName UTF8String]);
	if (!prop) {
		// doesn't exist for object
		return nil;
	}
	const char *propAttr = property_getAttributes(prop);
	NSString *propString = [NSString stringWithUTF8String:propAttr];
	NSArray *attrArray = [propString componentsSeparatedByString:@","];
	return attrArray;
}
- (NSS*) retentionMethodOfPropertyNamed:(NSS*)name	{
	return ( [[self class] retentionMethodOfPropertyNamed:name] );
}

+ (NSA*) az_propertyNames { return self.az_propertyNamesAndTypes.allKeys; }
+ (NSD*) az_propertyNamesAndTypes {

	NSMutableDictionary *propertyNames = NSMutableDictionary.new;
	//include superclass properties
	Class currentClass = self.class;
	while (currentClass != nil) {
		// Get the raw list of properties
		unsigned int outCount;
		objc_property_t *propList = class_copyPropertyList(currentClass, &outCount);

		// Collect the property names
		int i;
		NSString *propName;
		for (i = 0; i < outCount; i++)
		{
			objc_property_t * propert = propList + i;
			NSString *type = [NSString stringWithCString:property_getAttributes(*propert) encoding:NSUTF8StringEncoding];
            propName = [NSString stringWithCString:property_getName(*propert) encoding:NSUTF8StringEncoding];
      // check for exclusions
      if([self respondsToString:@"_excludedPropertyNames"] &&
        [[self performString:@"_excludedPropertyNames"] containsObject:propName])  continue; // skip this one
      
      if([[propName substringToIndex:1] isEqualToString:@"_"]) { NSLog(@"PRIVATE PROPERTY! %@", propName); continue; }
      [propertyNames setObject:[self az_getPropertyType:type] forKey:propName];
		}
		free(propList);
		currentClass = currentClass.superclass;
	}
	return propertyNames;
}
- (NSA*) az_properties { return self.class.az_propertyNames; }
+ (NSS*) az_getPropertyType:(NSS*)attributeString {
	NSString *type = NSString.string;
	NSScanner *typeScanner = [NSScanner scannerWithString:attributeString];
	[typeScanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"@"] intoString:NULL];

	// we are not dealing with an object
	if(typeScanner.isAtEnd) return @"NULL";
	[typeScanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"@"] intoString:NULL];
	// this gets the actual object type
	[typeScanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""] intoString:&type];
	return type;
}

- (NSA*) objectKeys { return [self.propertyNames map:^id(id k) { return ([self classOfPropertyNamed:k] != NULL) ? k : nil; }];}
- (NSA*) primitiveKeys { return [self.propertyNames map:^id(id k) { return ([self classOfPropertyNamed:k] == NULL) ? k : nil; }];}

@end

@implementation NSD (PropertyMap)

- _Void_ mapPropertiesToObject: instance {
	
//	NSA* codables = [self allKeys];
//	codables = [[instance class] respondsToSelector:@selector(codableKeys)] ? [instance class].codableKeys : self.allKeys;
//	if ([codables doesNotContainObjects:[self allKeys]]) {
//		NSLog(@"possible error:  not going to set values for keys: %@", [self.allKeys arrayByRemovingObjectsFromArray:codables]);
//	}
	
	[self each:^(NSS *propertyKey, id value) {
		[instance canSetValueForKey:propertyKey] && value!=nil ?
		[instance setValue:value forKey:propertyKey] :	^{
			SEL select = NULL;
			select = [instance setterForPropertyNamed:propertyKey];
			if (select != NULL && [instance respondsToSelector:select])
				[instance performSelectorWithoutWarnings:select withObject:value];

		}();//: NSLog(@"couldnt set:%@ on %@", propertyKey, instance);
	}];
}
@end

/*
//- (NSD *)propertiesPlease { return [self.codableKeys mapToDictionaryKeys:^id(id object) { return [self valueForKey:object];}];
//	NSA* propN = self.propertyNames;	NSLog(@"trying to get props: %@", propN)	NSA *hasV = [propN map:^id(id object) {
////		return [self valueForKey:object] ? object : nil;
////	}];
////	NSLog(@"hasV: %@", hasV)
//	NSA * responds = [propN map:^id(NSS* select) {
//		return [self respondsToSelector:NSSelectorFromString(select)] ? select : nil;
//	}];
//	NSLog(@"responds: %@", responds)
//	return [responds mapToDictionaryKeys:^id(NSS*props) {	return [self performSelectorSafely:NSSelectorFromString(props)];	}];
//	}][self.class propertyTypeDictionaryOfClass:self.class];
//	return  [[props.allKeys map:^id(id object) {		return [self respondsToString:object] ? object : nil;	}] mapToDictionaryKeys:^id(NSS* propName) {		return [self valueForKey:propName];	}];

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
