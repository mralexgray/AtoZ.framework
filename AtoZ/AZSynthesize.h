//
//  EXTSynthesize.h
//  extobjc
//
//  Created by Justin Spahr-Summers on 2012-09-04.
//  Copyright (C) 2012 Justin Spahr-Summers.
//  Released under the MIT license.
//

#import "extobjc_OSX/extobjc.h"
//#import  <extobjc_OSX/EXTRuntimeExtensions.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger,AZGETORSET){ AZGETTER, AZSETTER };

/**
 * \@synthesizeAssociation synthesizes a property for a class using associated
 * objects. This is primarily useful for adding properties to a class within
 * a category.
 *
 * PROPERTY must have been declared with \@property in the interface of the
 * specified class (or a category upon it), and must be of object type.
 */
#define synthesizeAssGetSet(CLASS,PROPERTY,_AZGETORSET_,_MODBLOCK_) \
	dynamic PROPERTY; \
	\
	void *ext_uniqueKey_ ## CLASS ## _ ## PROPERTY = &ext_uniqueKey_ ## CLASS ## _ ## PROPERTY; \
	\
	__attribute__((constructor)) \
	static void ext_ ## CLASS ## _ ## PROPERTY ## _synthesize (void) { \
		Class cls = objc_getClass(# CLASS); \
		objc_property_t property = class_getProperty(cls, # PROPERTY); \
		NSCAssert(property, @"Could not find property %s on class %@", # PROPERTY, cls); \
		\
		ext_propertyAttributes *attributes = ext_copyPropertyAttributes(property); \
		if (!attributes) { \
			NSLog(@"*** Could not copy property attributes for %@.%s", cls, # PROPERTY); \
			return; \
		} \
		\
		NSCAssert(!attributes->weak, @"@synthesizeAssociation does not support weak properties (%@.%s)", cls, # PROPERTY); \
		\
		objc_AssociationPolicy policy = OBJC_ASSOCIATION_ASSIGN; \
		switch (attributes->memoryManagementPolicy) { \
			case ext_propertyMemoryManagementPolicyRetain: \
				policy = attributes->nonatomic ? OBJC_ASSOCIATION_RETAIN_NONATOMIC : OBJC_ASSOCIATION_RETAIN; \
				break; \
			\
			case ext_propertyMemoryManagementPolicyCopy: \
				policy = attributes->nonatomic ? OBJC_ASSOCIATION_COPY_NONATOMIC : OBJC_ASSOCIATION_COPY; \
				break; \
			\
			case ext_propertyMemoryManagementPolicyAssign: \
				break; \
			\
			default: \
				NSCAssert(NO, @"Unrecognized property memory management policy %i", (int)attributes->memoryManagementPolicy); \
		} \
		\
		id getter = ^(id self){ __typeof(self) _self = self; \
			id _TEMPGET_ = objc_getAssociatedObject(self, ext_uniqueKey_ ## CLASS ## _ ## PROPERTY); \
			do{ if (_AZGETORSET_ == AZGETTER) _TEMPGET_ =_MODBLOCK_(_self,_TEMPGET_); }while(0); return _TEMPGET_; \
		}; \
		\
		id setter = ^(id self, id value){ __typeof(self) _self = self; \
			id setVal = value; do {  if (_AZGETORSET_ == AZSETTER) setVal = _MODBLOCK_(_self,value); }while(0);   \
			objc_setAssociatedObject(self, ext_uniqueKey_ ## CLASS ## _ ## PROPERTY, setVal, policy); \
		}; \
		\
		if (!ext_addBlockMethod(cls, attributes->getter, getter, "@@:")) { \
			NSCAssert(NO, @"Could not add getter %s for property %@.%s", sel_getName(attributes->getter), cls, # PROPERTY); \
		} \
		\
		if (!ext_addBlockMethod(cls, attributes->setter, setter, "v@:@")) { \
			NSCAssert(NO, @"Could not add setter %s for property %@.%s", sel_getName(attributes->setter), cls, # PROPERTY); \
		} \
		\
		free(attributes); \
	}
