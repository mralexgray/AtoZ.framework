
//  HTMLND.m  StackOverflow
//  Created by Ben Reeves on 09/03/2010.  Copyright 2010 Ben Reeves. All rights reserved.

#import <AtoZ/AtoZ.h>
#import "HTMLNode.h"
#import <libxml/HTMLtree.h>
#import <libxml/HTMLparser.h>
#import <libxml/parser.h>

JREnumDefine ( HTMLNodeType )

EL_TYPE nodeType(xmlNode * node) {

	return node == NULL || node->name == NULL ? HTMLUnkownNode : ({
	
	const char * tagName = (const char*)node->name;

  !strcmp(tagName, "a")           ? HTMLHrefNode        :
  !strcmp(tagName, "text")		    ? HTMLTextNode        :
  !strcmp(tagName, "code")    		? HTMLCodeNode        :
	!strcmp(tagName, "span")		    ? HTMLSpanNode        :
	!strcmp(tagName, "p")           ? HTMLPNode           :
	!strcmp(tagName, "ul")          ? HTMLUlNode          :
	!strcmp(tagName, "li")          ? HTMLLiNode          :
	!strcmp(tagName, "image")    		? HTMLImageNode       :
	!strcmp(tagName, "ol")          ? HTMLOlNode          :
	!strcmp(tagName, "strong")	    ? HTMLStrongNode      :
	!strcmp(tagName, "pre")	        ? HTMLPreNode         :
	!strcmp(tagName, "blockquote")	? HTMLBlockQuoteNode  : HTMLUnkownNode; });
	
}
     NSS *   allNodeContents(xmlNode * node) { if (node == NULL) return nil; void * contents;

 return ((contents  = xmlNodeGetContent(node))) ? ({
		
		NSString * string = $UTF8(contents); xmlFree(contents); string; 	}) : @"";
}
     NSS * rawContentsOfNode(xmlNode * node) {

	xmlBufferPtr    buffer = xmlBufferCreateSize(1000);
	xmlOutputBufferPtr buf = xmlOutputBufferCreateBuffer(buffer, NULL);
	
	htmlNodeDumpOutput(buf, node->doc, node, (const char*)node->doc->encoding);
		
	xmlOutputBufferFlush(buf);
		
	NSString * string = (buffer->content) ? [NSString.alloc initWithBytes:(const void *)xmlBufferContent(buffer)
                                                                 length:xmlBufferLength(buffer)
                                                               encoding:NSUTF8StringEncoding] : nil;
	
	xmlOutputBufferClose(buf); xmlBufferFree(buffer); return string;
}
     NSS * getAttributeNamed(xmlNode * node, const char * nameStr) {

	for(xmlAttrPtr attr = node->properties; NULL != attr; attr = attr->next)

		if (!strcmp((char*)attr->name, nameStr))	{

			for(xmlNode * child = attr->children; NULL != child; child = child->next)

				return [NSString stringWithCString:(void*)child->content encoding:NSUTF8StringEncoding];

			break;
		}
	return NULL;
}
    void   setAttributeNamed(xmlNode * node, const char * nameStr, const char * value) {
	
	char * newVal = (char *)malloc(strlen(value)+1);	memcpy (newVal, value, strlen(value)+1);

	for(xmlAttrPtr attr = node->properties; NULL != attr; attr = attr->next)

		if (!strcmp((char*)attr->name, nameStr)) {

			for(xmlNode * child = attr->children; NULL != child; child = child->next) {

				free(child->content);	child->content = (xmlChar*)newVal; break;
			}
			break;
		}
}

@implementation EL { xmlNode *_node;}

+ (instancetype) instanceWithXMLNode:(void*)xmlNode { return [self.class.alloc initWithXMLNode:xmlNode]; }
-           (id)     initWithXMLNode:(void*)xmlNode	{ return self = super.init ? _node = xmlNode, self : nil;  }

- (INST) parent          {	return [self.class.alloc initWithXMLNode:   (void*)_node->parent  ]; }
- (INST) nextSibling     { return [self.class.alloc initWithXMLNode:   (void*)_node->next    ]; }
- (INST) previousSibling { return [self.class.alloc initWithXMLNode:   (void*)_node->prev    ]; }
- (INST) firstChild      { return [self.class.alloc initWithXMLNode:(xmlNode*)_node->children]; }

- (EL_TYPE) nodetype       {	return nodeType(_node); }

- (NSS*) className    {	return [self getAttributeNamed:@"class"]; }
- (NSS*) tagName      { return $UTF8((void*)_node->name); }
- (NSA*) children     {	xmlNode *cur_node = NULL; AZNew(NSMA, array);

	for (cur_node = _node->children; cur_node; cur_node = cur_node->next)	[array addObject:[self.class.alloc initWithXMLNode:(void*)cur_node]];
	return array;
}
- (NSS*) contents     { return _node->children && _node->children->content ? $UTF8((void*)_node->children->content) : nil; }
- (NSS*) allContents  {
	return allNodeContents(_node);
}
- (NSS*) rawContents  { return rawContentsOfNode(_node); }

- (NSS*)         getAttributeNamed:(NSS*)name           { return getAttributeNamed(_node, name.UTF8String); }
- (NSA*)             findChildTags:(NSS*)tagName        { AZNew(NSMA, array);
	
	[self findChildTags:tagName inXMLNode:_node->children inArray:array];
	
	return array;
}
- (NSA*)       findChildrenOfClass:(NSS*)className      {
	return [self findChildrenWithAttribute:@"class" matchingName:className allowPartial:NO];
}
- (INST)           findChildTag:(NSS*)tagName        {	return [self findChildTag:tagName inXMLNode:_node->children]; }
- (INST)       findChildOfClass:(NSS*)className      {
  return [self findChildWithAttribute:"class" matchingName:[className UTF8String]  inXMLNode:_node->children allowPartial:NO];
}

- (void)             findChildTags:(NSS*)tagName     inXMLNode:(xmlNode*)node
                                                       inArray:(NSMA*)array       {

	xmlNode *cur_node = NULL;	const char * tagNameStr = tagName.UTF8String;
	
	if (!tagNameStr) return;
	
	for (cur_node = node; cur_node; cur_node = cur_node->next) 
	{				
		if (cur_node->name && !strcmp((char*)cur_node->name, tagNameStr))
			[array addObject:[self.class.alloc initWithXMLNode:(void*)cur_node]];

		[self findChildTags:tagName inXMLNode:cur_node->children inArray:array];
	}	
}
- (NSA*) findChildrenWithAttribute:(NSS*)attr     matchingName:(NSS*)name
                                                  allowPartial:(BOOL)partial      {

  AZNew(NSMA, array);

	[self findChildrenWithAttribute:attr.UTF8String matchingName:name.UTF8String inXMLNode:_node->children inArray:array allowPartial:partial];
	
	return array;
}
- (void) findChildrenWithAttribute:(const char*)a matchingName:(const char*)name
                                                     inXMLNode:(xmlNode*)   node
                           inArray:(NSMA*)array   allowPartial:(BOOL)partial      {

	xmlNode *cur_node = NULL;	const char * classNameStr = name;
	//BOOL found = NO;
	
	for (cur_node = node; cur_node; cur_node = cur_node->next) 
	{				
		for(xmlAttrPtr attr = cur_node->properties; NULL != attr; attr = attr->next)
		{
			
			if (!strcmp((char*)attr->name, a))
			{				
				for(xmlNode * child = attr->children; NULL != child; child = child->next)
				{
					
					BOOL match = !partial && !strcmp((char*)child->content, classNameStr)
                    ||  partial &&  strstr((char*)child->content, classNameStr) != NULL;
	
					if (match)
					{
						//Found node
						[array addObject:[self.class.alloc initWithXMLNode:(void*)cur_node]];
						break;
					}
				}
				break;
			}
		}
		
		[self findChildrenWithAttribute:a matchingName:name inXMLNode:cur_node->children inArray:array allowPartial:partial];
	}	
	
}

- (INST) findChildWithAttribute:(const char*)a matchingName:(const char*)name
                         inXMLNode:(xmlNode*)node allowPartial:(BOOL)partial      {

	xmlNode *cur_node = NULL;	const char * classNameStr = name; 	if (node == NULL)	return NULL;
	//BOOL found = NO;

	for (cur_node = node; cur_node; cur_node = cur_node->next) {
		for(xmlAttrPtr attr = cur_node->properties; NULL != attr; attr = attr->next)
		{			
			if (!strcmp((char*)attr->name, a))
			{				
				for(xmlNode * child = attr->children; NULL != child; child = child->next)
				{
					
					BOOL match = !partial && !strcmp((char*)child->content, classNameStr)
                    ||  partial &&  strstr((char*)child->content, classNameStr) != NULL;

					if (match)
						return [self.class.alloc initWithXMLNode:(void*)cur_node];
				}
				break;
			}
		}
		
		__typeof(self) cNode = [self findChildWithAttribute:a matchingName:name inXMLNode:cur_node->children allowPartial:partial];
		if (cNode != NULL) return cNode;
	}
	return NULL;
}
- (INST) findChildWithAttribute:(NSS*)attr     matchingName:(NSS*)name
                                                  allowPartial:(BOOL)partial      {
	return [self findChildWithAttribute:attr.UTF8String matchingName:name.UTF8String inXMLNode:_node->children allowPartial:partial];
}
- (INST)           findChildTag:(NSS*)tagName     inXMLNode:(xmlNode*)node     {
	xmlNode *cur_node = NULL;
	const char * tagNameStr =  [tagName UTF8String];
	
	for (cur_node = node; cur_node; cur_node = cur_node->next) 
	{				
		if (cur_node && cur_node->name && !strcmp((char*)cur_node->name, tagNameStr))
			return [self.class.alloc initWithXMLNode:(void*)cur_node];

		__typeof(self) cNode = [self findChildTag:tagName inXMLNode:cur_node->children];
		if (cNode != NULL) return cNode;
	}
	
	return NULL;
}

- (void)appendChildContentsToString:(NSMS*)string       inNode:(xmlNode*)node     {
	if (node == NULL)
		return;
	
	xmlNode *cur_node = NULL;	
	for (cur_node = node; cur_node; cur_node = cur_node->next) 
	{
		if (cur_node->content)
		{			
			[string appendString:[NSString stringWithCString:(void*)cur_node->content encoding:NSUTF8StringEncoding]];
		}
		
		[self appendChildContentsToString:string inNode:cur_node->children];
	}
}

@end

/*

#import "libxml/parser.h"
#import <libxml/parser.h>/usr/include/libxml2 / * *
#import "/usr/include/libxml2/libxml/HTMLParser.h"//<libxml/HTMLparser.h>
@class HTMLParser;

Init with a lib xml node (shouldn't need to be called manually)
Use [parser doc] to get the root Node
-(id)initWithXMLNode:(xmlNode*)xmlNode;
C functions for minor performance increase in tight loops
@public

- (NSString*) description
{
	NSString * string = [NSString stringWithFormat:@"<%s>%@\n", _node->name, [self contents]];
	
	for (HTMLND * child in [self children])
	{
		string = [string stringByAppendingString:[child description]];
	}
	
	string = [string stringByAppendingString:[NSString stringWithFormat:@"<%s>\n", _node->name]];

	return string;
}*/
