
//  HTMLNode.h  StackOverflow
//  Created by Ben Reeves on 09/03/2010.  Copyright 2010 Ben Reeves. All rights reserved.

#import "AtoZUmbrella.h"
#import "AZHTMLParser.h"
#define ParsingDepthUnlimited 0
#define      ParsingDepthSame -1
#define          ParsingDepth size_t
#define              HTMLNODE HTMLNodeType
#define                HTMLND HTMLNode

JREnumDeclare ( HTMLNodeType,  HTMLHrefNode,   HTMLTextNode,   HTMLUnkownNode,
                               HTMLCodeNode,   HTMLSpanNode,   HTMLPNode,
                               HTMLLiNode,     HTMLUlNode,     HTMLImageNode,
                               HTMLOlNode,     HTMLStrongNode, HTMLPreNode, HTMLBlockQuoteNode)
@interface HTMLNode : NSO

+ (instancetype) instanceWithXMLNode:(void*)xmlNode;

@property (RONLY)       NSS * contents,         // plaintext contents of node
                            * allContents,      // plaintext contents of this node + all children
                            * rawContents,      // html contents of the node
                            * className;
@property (RONLY)  HTMLNode * firstChild,       // the first child element
                            * nextSibling,      // next sibling in tree
                            * previousSibling,  // previous sibling in tree
                            * tagName,
                            * parent;
@property (RONLY)       NSA * children;         // the first level of children
@property (RONLY)  HTMLNODE   nodetype;         // if known

/*! single node finders */

- (HTMLND*)          findChildOfClass:(NSS*)classN;      // Returns a single child of class
/*! @param  allowPartial to match partial matches  @code <img src="http://www.google.com> [findChildWithAttribute:@"src" matchingName:"google.com" allowPartial:TRUE] */
- (HTMLND*)    findChildWithAttribute:(NSS*)attr matchingName:(NSS*)classN allowPartial:(BOOL)p;
/*! Looks for a tag name e.g. "h3" */
- (HTMLND*)              findChildTag:(NSS*)tagN;
/*! Gets the attribute value matching tha name */
-    (NSS*)         getAttributeNamed:(NSS*)name;

/*! globbing finders */

- (NSA*)             findChildTags:(NSS*)tagN;
- (NSA*)       findChildrenOfClass:(NSS*)classN;
- (NSA*) findChildrenWithAttribute:(NSS*)attr
                      matchingName:(NSS*)classN
                      allowPartial:(BOOL)p;
@end

//@class xmlNode;
