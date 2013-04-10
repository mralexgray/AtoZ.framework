
@interface AZExpandableView : TUIView

@property (NATOM,STRNG) NSIMG			   *favicon;
@property (NATOM,STRNG) NSC		  	  *color;
@property (NATOM,STRNG)	NSS 		  		*name;
@property (NATOM,STRNG)	NSURL				 *url;
@property (NATOM,STRNG)	NSAS			*attrString;
@property (RONLY)	BOOL 	  		  faviconOK;

@property (NATOM,STRNG)	NSMD  *dictionary;
@property (NATOM,   WK) NSMA  	*objects;
@property (NATOM,  ASS)	BOOL	   expanded, 
											selected;
@end

