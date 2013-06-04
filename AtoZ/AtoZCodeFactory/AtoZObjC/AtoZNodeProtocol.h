//
//  BundleProtocol.h
//  Doodad
//
//  Created by Alex Gray on 10/18/12.
//
//

#import <Foundation/Foundation.h>


#define CEL NSCell
#define AZNODEPRO (id<AtoZNodeProtocol>)

@protocol AtoZNodeProtocol	<NSObject>
@required
@property (strong) id value, key,children;
@optional
@property (strong) id expanded;
@end

#ifdef JRENUM 
JREnumDeclare(AZMethod,	AZMethodNotFound, 	// method not found (LRMethodNotFound )
	AZMethodAuthor,    	// first in tree to implement method (LRMethodImplement)
	AZMethodOverrider,   // class overrides method (LRMethodOverride)
 	AZMethodInherits     // class does not override superclass method (LRMethodSuper)
);
#else
typedef NS_ENUM(NSUInteger, AZMethod){
	AZMethodNotFound, 	// method not found (LRMethodNotFound )
	AZMethodAuthor,    	// first in tree to implement method (LRMethodImplement)
	AZMethodOverrider,   // class overrides method (LRMethodOverride)
 	AZMethodInherits     // class does not override superclass method (LRMethodSuper)
};
#endif


@interface NSObject (ProtocolConformance)
+ (AZMethod) implementationOfSelector:(SEL)selector;
- (BOOL) implementsProtocol:(id)nameOrProtocol;
@end
@interface  NSObject (AtoZNodeProtocol)
@property (readonly)         NSArray * allDescendants, 
//									          * allAncestors, 
									          * allSiblings;
@property (readonly)            BOOL   isLeaf, isaNode;
@property (readonly)        NSNumber * of, 
											    * index, 
											    * numberOfChildren;
- (void) addChild:(id<AtoZNodeProtocol>)o; 
@property (weak,readonly) 	  		   id<AtoZNodeProtocol>   parent;
@end

@interface	AZNode : NSObject	<AtoZNodeProtocol > //NSCopying, NSCoding
//@property (nonatomic,strong)      id   key, 
//													value, 
//									        	 	expanded; 
//@property (nonatomic) NSMutableArray * 
//@property (readonly)         NSArray * allDescendants, 
//									          * allAncestors, 
//									          * allSiblings;
//@property (readonly)            BOOL   isLeaf;
//@property (readonly)        NSNumber * of, 
//											    * index, 
//											    * numberOfChildren;
//@property (weak) 	  		      AZNode * parent;

//- (void) addChild:    (AZNode*)o; 
//- (void) removeChild: (AZNode*)o;
//- (void) insertChild: (AZNode*)o atIndex:(NSUInteger)i;
//-   (id) childAtIndex:(NSUInteger)index;
//- (void) sortChildrenUsingFunction:(NSComparisonResult (*)(id, id, void *))compare context:(void *)context;

@end


//@protocol AtoZBundleProtocol <NSObject>
//@optional
//@property (readonly) NSWindowController *azBundle_windowController;
//@property (readonly) NSString	*azBundle_bundleTitle, 
//										*azBundle_bundleDescription;	// may not the same as the actual bundle title @end
//@property (readonly) NSImage 	*azBundle_bundleIcon;
//@property (readonly) BOOL azBundle_isOpen, azBundle_select, azBundle_open;
//- (void) azBundle_close;
//@end

@interface NSObject (AtoZBundleProtocol)
@property (readonly) NSString	*azBundle_bundleTitle, *azBundle_bundleDescription;	// may not the same as the actual bundle title on disk
@property (readonly) NSImage 											*azBundle_bundleIcon;	// may not the same as [NSObject description]
@property (readonly) BOOL  		azBundle_isOpen, azBundle_select, azBundle_open;	// returns YES if its window is currently open
- (void) azBundle_close;																				// closes its window
@end


//azBundle_hasOpenWindows
//@optional
//@property (readonly) NSDictionary *classes;
//@property (readonly) NSDictionary *symbols;
//-(void)close;	// closes its window

//@interface AZBundle : NSObject <AtoZNodeProtocol>
/* properties for the bundle information.  
	note:		information like this is also available in: [NSBundle infoDictionary], which gives you key information from the bundle's Info.plist. However, these accessors are merely convenience accessors for the same information but conveniently provides you, for example, the actual icon image, plus extended localized string information (display name and description)
	note: 	these are provided due to the fact that this information may be different than what's on disk, they are localized strings used for display purposes in the UI
	NOTE: may not the same as the actual bundle title on disk /  may not the same as [NSObject description]
*/

//@property (readonly) NSString	*bundleTitle, *bundleDescription;
//@property (readonly) NSImage	*bundleIcon;
//@end
