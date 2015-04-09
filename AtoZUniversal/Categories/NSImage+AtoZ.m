//@import QuickLook;
//#import "AZSizer.h"
//@import SVGKit;

#if MAC_ONLY
@import Quartz;
#else
@import QuartzCore;
#endif

#import <AtoZUniversal/AtoZGeometry.h>
#import <AtoZUniversal/AtoZUniversal.h>

_IMPL CIFilter (WithDefaults)

+ (CIFilter*) filterWithDefaultsNamed:_Text_ n { id f; return [(f = [CIFilter filterWithName:n]) setDefaults], f; }

_FINI

_Pict AZIMGNamed(_Text constName) {  return objc_msgSend(NSIMG.class, NSSelectorFromString(constName)); }

Text        *const AZIMG_checkmark = @"checkmark",              *const AZIMG_addressBook = @"addressBook",
            *const AZIMG_paperclip = @"paperclip",              *const AZIMG_checkRound = @"checkRound",
            *const AZIMG_xCircle = @"xCircle",                  *const AZIMG_off = @"off",
            *const AZIMG_on = @"on",                            *const AZIMG_lightning = @"lightning",
            *const AZIMG_floppy = @"floppy",                    *const AZIMG_folder = @"folder",
            *const AZIMG_globe = @"globe",                      *const AZIMG_jewishHand = @"jewishHand",
            *const AZIMG_calendar = @"calendar",                *const AZIMG_cylinder = @"cylinder",
            *const AZIMG_document = @"document",                *const AZIMG_textDocument = @"textDocument",
            *const AZIMG_blinkingPlus = @"blinkingPlus",        *const AZIMG_blinkingMinus = @"blinkingMinus",
            *const AZIMG_printer = @"printer",                  *const AZIMG_lock = @"lock",
            *const AZIMG_magnifyingGlass = @"magnifyingGlass",  *const AZIMG_wavyDocument = @"wavyDocument",
            *const AZIMG_computerScreen = @"computerScreen",    *const AZIMG_foldedEdgeoc = @"foldedEdgeoc",
            *const AZIMG_volume = @"volume",                    *const AZIMG_starFilled = @"starFilled",
            *const AZIMG_starEmpty = @"starEmpty",              *const AZIMG_textsymbol = @"textsymbol",
            *const AZIMG_bold = @"bold",                        *const AZIMG_italic = @"italic",
            *const AZIMG_strikethrough = @"strikethrough",      *const AZIMG_trashcan = @"trashcan",
            *const AZIMG_tag = @"tag",                          *const AZIMG_envelope = @"envelope",
            *const AZIMG_plus = @"plus",                        *const AZIMG_minus = @"minus",
            *const AZIMG_recycle = @"recycle",                  *const AZIMG_umbrella = @"umbrella",
            *const AZIMG_XMark = @"XMark",                      *const AZIMG_roundX = @"roundX",
            *const AZIMG_roundCheck = @"roundCheck",            *const AZIMG_check = @"check",
            *const AZIMG_safari = @"safari",                    *const AZIMG_pointer = @"pointer",
            *const AZIMG_forbidden = @"forbidden",              *const AZIMG_forbiddenLight = @"forbiddenLight",
            *const AZIMG_atSymbol = @"atSymbol";


static inline _SInt get_bit(_UChr arr, _ULng bit_num) { return (arr[(bit_num / 8)] & (1 << (bit_num % 8))); }


_Flot distance(NSP aPoint) {
  return sqrt(aPoint.x * aPoint.x +
              aPoint.y * aPoint.y); /* Stole this from some guy named
                                       Pythagoras..  Returns the distance of
                                       aPoint from the origin. */
}



//	NSA sizes = [items[0] valueForKey:@"size"] ? [items valueForKeyPath:@"size"]
// : [obj respondsToString:@"frame"] ? [obj sizeForKey:@"frame"] :  [obj
// respondsToString:@"bounds"] ? [obj sizeForKey:@"bounds"]  : AZRectBy(1, 1).size;

/*
#import <CommonCrypto/CommonDigest.h>

@implementation NSImage (AtoZ)

- _Data_ PNGRepresentation {

#if TARGET_OS_IPHONE
  return UIImagePNGRepresentation(self);
#else
  NSBIR *bitmapRep;
  [self lockFocus];
  bitmapRep = [NSBIR.alloc initWithFocusedViewRect: _Rect_ {0,0,self.size}];
  [self unlockFocus];
  return [bitmapRep representationUsingType:NSPNGFileType properties:Nil];
#endif
}


+ _Pict_ gravatarForEmail: _Text_ e {

	_Text curatedEmail = [e stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet].lowercaseString;
	
	const char *cStr = curatedEmail.UTF8String;
  unsigned char result[16];
  CC_MD5(cStr, strlen(cStr), result); // compute MD5
	
	NSString *gravatarEndPoint = $(@"http://www.gravatar.com/avatar/%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x?s=512",
			result[0],  result[1],  result[2],  result[3],  result[4],  result[5],  result[6],  result[7],
			result[8],  result[9],  result[10], result[11],	result[12], result[13], result[14], result[15]); //md5email

  return ((id)self)[gravatarEndPoint];
//  XX(gravatarEndPoint);
//  return [self from:gravatarEndPoint];
}

//+ objectForKeyedSubscript: k { return [self imageNamed:k]; }
//- (CGF)width {	return self.size.width ;		}
//- (CGF)height {	return self.size.height ;	}
//- _Void_ setWidth:(CGF)t {  self.scalesWhenResized = YES; [self setSize:AZSizeExceptWide(self.size, t)]; }
//- _Void_ setHeight:(CGF)t 	{ self.scalesWhenResized = YES; [self setSize:AZSizeExceptHigh(self.size, t)]; }
*/
/*
-  (NSAS*) attributedString {

  NSTextAttachment *attachment = NSTextAttachment.new;
  attachment.attachmentCell = [NSTextAttachmentCell.alloc initImageCell:self];
  return [NSAttributedString attributedStringWithAttachment:attachment];
}
*/
/*
+ _Pict_ imageFromLockedFocusSize: _Size_ sz lock:(_Pict(^)(_Pict))block {

  _Pict newI = [self.alloc initWithSize:sz]; newI = block(newI); return newI;
}

- _Void_ lockFocusBlock:(_Void(^)(_Pict))block {

      [self lockFocus];
//  [NSGraphicsContext state:^{
      block(self);
      [self unlockFocus];
//  }];
}

- _Pict_ lockFocusBlockOut:(_Pict (^) _Pict_)block {

  [self lockFocusBlock:^(NSImage *s) { block(s); }];  return self;
}

+ _Pict_  faviconForDomain: _Text_ domainAsString     {

  static NSA *iconLocs = nil;
  static NSIMG *missing = nil;
  iconLocs = iconLocs ?: @[
                           @"/touch-icon-114x114.png",
                           @"/touch-icon-72x72.png",
                           @"/touch-icon-iphone.png",
                           @"/favicon.ico"
                         ];

  NSS *theUrl = [domainAsString startsWith:@"http://"]
                        ? domainAsString
                        : $(@"http://%@", domainAsString);
  __block NSIMG *theIcon;
  [iconLocs enumerateObjectsUsingBlock:^(NSS *obj, NSUInteger idx, BOOL *stop) {

      NSIMG *maybeImg = [NSImage.alloc
          initWithContentsOfURL:[NSURL URLWithString:obj
                                       relativeToURL:$URL(theUrl)]];
      if (maybeImg) {
        theIcon = maybeImg;
        theIcon.name =
            $(@"%@.%@", domainAsString,
              [[obj substringAfter:@"/"] stringByDeletingPathExtension]);
        *stop = YES;
      }
  }];
  if (!theIcon)
    missing = missing ?: [[NSIMG imageNamed:@"missing"] scaledToMax:64];
  NSLog(@"Favicon for %@: %@", domainAsString, theIcon ? @"FOUND" : @"MISSING");
  return theIcon ?: missing;
}

+ _Pict_ imageWithData: _Data_ data { return [self.class.alloc initWithData:data]; }

// create a new "sphere" layer and add it to the container layer

+ _Pict_ testGlowingSphereImageWithScaleFactor: _Flot_ scale
                                       coreColor: _Colr_ core
                                       glowColor: _Colr_ glow {
  NSLog(@"testing %@ with arguments 1.0 (scaleFactor), WHITE (coreColor)m and "
        @"RANDOMCOLOR (glowColor);",
        NSStringFromSelector(_cmd));
  return [NSImage glowingSphereImageWithScaleFactor:1
                                          coreColor:WHITE
                                          glowColor:RANDOMCOLOR];
}

+ _Pict_ glowingSphereImageWithScaleFactor: _Flot_ scale
                                 coreColor: _Colr_ core
                                 glowColor: _Colr_ glow {

if (scale > 10.0 || scale < 0.5) {
  NSLog(@"%@: larger than 10.0 or less than 0.5 scale. returning nil.",
        NSStringFromSelector(_cmd));
  return nil;
}
// the image is two parts: a core sphere and a blur. the blurred image is
// larger, and the final image must be large enough to contain it.
NSSZ sphereCoreSize = NSMakeSize(5 * scale, 5 * scale);
NSSZ sphereBlurSize = NSMakeSize(10 * scale, 10 * scale);
NSSZ finalImageSize =
    NSMakeSize(sphereBlurSize.width * 2, sphereBlurSize.width * 2);
NSRect finalImageRect;
finalImageRect.origin = NSZeroPoint;
finalImageRect.size = finalImageSize;

// define a drawing rect for the core of the sphere
NSRect sphereCoreRect;
sphereCoreRect.origin = NSZeroPoint;
sphereCoreRect.size = sphereCoreSize;
CGF sphereCoreOffset = (finalImageSize.width - sphereCoreSize.width) * 0.5;

// create the "core sphere" image
NSIMG *solidCircle = [NSImage.alloc initWithSize:sphereCoreSize];
[solidCircle lockFocus];
[[NSBP bezierPathWithOvalInRect:sphereCoreRect] fillWithColor:core];
[solidCircle unlockFocus];

// define a drawing rect for the sphere blur
NSRect sphereBlurRect;
sphereBlurRect.origin.x = (finalImageSize.width - sphereBlurSize.width) * 0.5;
sphereBlurRect.origin.y = (finalImageSize.width - sphereBlurSize.width) * 0.5;
sphereBlurRect.size = sphereBlurSize;

// create the "sphere blur" image (not yet blurred)
NSIMG *blurImage = [NSImage.alloc initWithSize:finalImageSize];
[blurImage lockFocus];
[[NSBP bezierPathWithOvalInRect:sphereBlurRect] fillWithColor:glow];
[blurImage unlockFocus];

// convert the "sphere blur" image to a CIImage for processing
NSData *dataForBlurImage = [blurImage TIFFRepresentation];
CIImage *ciBlurImage = [CIImage imageWithData:dataForBlurImage];

// apply the blur using CIGaussianBlur
CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
[filter setDefaults];
[filter setValue:@3 forKey:@"inputRadius"];
[filter setValue:ciBlurImage forKey:@"inputImage"];
CIImage *ciBlurredImage = [[filter valueForKey:@"outputImage"]
    imageByCroppingToRect:NSRectToCGRect(finalImageRect)];

// draw the final image
NSIMG *compositeImage = [NSImage.alloc initWithSize:finalImageSize];
[compositeImage lockFocus];
// draw glow first
[ciBlurredImage drawInRect:finalImageRect
                  fromRect:finalImageRect
                 operation:NSCompositeSourceOver
                  fraction:0.7];
// now draw solid sphere on top
[solidCircle drawInRect:NSOffsetRect(sphereCoreRect, sphereCoreOffset,
                                     sphereCoreOffset)
               fromRect:sphereCoreRect
              operation:NSCompositeSourceOver
               fraction:1.0];
[compositeImage unlockFocus];
return compositeImage;
//	[solidCircle release]; [blurImage release]; autorelease];
}

+ _List_ randomWebImages:_UInt_ ct { return [[@0 to:@(ct)]map:^id(id object) { return self.randomWebImage; }]; }

+ _Pict_ randomWebImage { return [self googleImages:AtoZ.randomUrbanD.word ct:1 eachBlock:nil]; }

+ _Pict_ googleImage: _Text_ query { return [self googleImages:query ct:1 eachBlock:nil]; }

+ _Pict_ googleImages: _Text_ query ct: _UInt_ ct eachBlock:(_Void(^)(_Pict results))block {

  __block NSIMG *returner = nil;
  __unused AZGoogleQuery *q = [AZGoogleImages
      searchGoogleImages:query
               withBlock:^(NSArray *imageURLs) {
                   if (!block || ct == 1)
                     return (void)(returner =
                                       imageURLs
                                           ? ((id)self)[imageURLs[0]]
                                           : nil);
                   for (int i = 0; i < ct; i++)
                     if (returner = ((id)self)[[imageURLs normal:i]])
                       block(returner);
               }];
  return returner;

  //	NSMA*images 	= NSMA.new;
  //	NSIMG *retVal 	= nil;
  //	NSS*q 			= query ? [self googleImageURL:query :
  // fixForGoogle(NSS.randomUrbanD.word);
  //	for (int i = 0; i < ct; i++) {
  //		if (![queries[q] count]) runQuery(q);
  //		if (![queries[q] count]) return images;
  //		if ((retVal = qBlock(q))) [images addObject:retVal];
  //	}
  //	return images;
}
*/

/*		LOG_EXPR(tags.count);
    NSA* urls = [tags map:^id(HTMLNode *object) {	return [object
getAttributeNamed:@"src"]; }];// stringByRemovingPrefix:f2]substringBefore:f3];
}];
    LOG_EXPR(tags);
  NSS *imageurl 		=       [[p.body findChildWithAttribute:@"alt"
matchingName:@"Random Image" allowPartial:TRUE]getAttributeNamed:@"src"];NSIMG
*gIMAGE = [NSIMG.alloc initWithContentsOfURL:google];	if (gIMAGE) return gIMAGE;
    HTMLNode* n = [parser.body findChildWithAttribute:@"id"
matchingName:@"search" allowPartial:YES];
    LOG_EXPR(n);
    if (urls) {
      [[NSS stringFromArray:urls] openInTextMate];
//			NSA* imageTags = [n findChildrenWithAttribute:@"href"
matchingName:@"/imgres?imgurl=" allowPartial:YES];
//			if (imageTags) [$(@"%@", imageTags) openInTextMate];
    } else [@"problem cerating node" log];
  } else	[@"problem fetching URL" log];

*/
/*
+ _Void_ loadImage:(NSURL*) url andDisplay:(void (^)(NSImage *i))b {

  //  __block NSImage *image = nil;

  //  void(^fini)(void) = ^{ dispatch_async(dispatch_get_main_queue(),^{
  // b(image); }); };

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^(void) {
      NSData *data = [NSData dataWithContentsOfURL:url];
      dispatch_async(dispatch_get_main_queue(),
                     ^(void) { b([NSImage imageWithData:data]); });
  });
  //  id op = [NSBlockOperation blockOperationWithBlock:^{ image = [NSIMG.alloc
  // initWithContentsOfURL:url]; }];
  //  [op setCompletionBlock:fini];

  //  [NSOQ.mainQueue addOperation:op];

  // [itemLoadQueue setSuspended:NO];
}
+ (void)random:(void (^)(NSImage *))display {

  [self loadImage:@"http://mrgray.com/randomimage.php".url andDisplay:display];
}

//+ _Pict_ randomFunny { return ((id)self)[@"http://mrgray.com/randomimage.php"]; }

+ _Pict_ randomFunnyImage {

  __block NSError *requestError;

  [AZStopwatch start:@"photoTimer"];

  NSURL    * addy = $URL(@"http://junglebiscuit.com/imagesrandomfunnyimagegenerator");
  //@"http://junglebiscuit.com/images/random/rand_image.pl");
  AZHTMLParser *p = [AZHTMLParser.alloc initWithContentsOfURL:addy error:&requestError];
  NSS *imageurl =
      [[p.body findChildWithAttribute:@"alt"
                         matchingName:@"Random Image"
                         allowPartial:TRUE] getAttributeNamed:@"src"];
  NSLog(@"imageurl: %@", imageurl);
  NSIMG *webI = [self.alloc initWithContentsOfURL:$URL(imageurl)];
  [AZStopwatch stop:@"photoTimer"];
  [webI lockFocusBlock:^(NSImage *i) {
      NSAS *stamp =
          [NSAS.alloc initWithString:[AZStopwatch runtime:@"photoTimer"]
                          attributes:NSAS.defaults];

      NSRectFillWithColor(AZRectFromSize(stamp.size), RED);
      [stamp drawAtPoint:NSZeroPoint];
  }];
  return webI;
}
*/
/*

	__strong ASIHTTPRequest *requester						 = [ASIHTTPRequest.alloc
 initWithURL:addy];
									 requester.completionBlock  =^(ASIHTTPRequest *request) {
			  requestError   = request.error;
		NSS *responsePage   = request.responseString.copy;
		NSLog(@"got response: %@", responsePage);
		AZHTMLParser 	*p =       [AZHTMLParser.alloc initWithString:responsePage
 error:&requestError];
		NSS *imageurl 		=       [[p.body findChildWithAttribute:@"alt"
 matchingName:@"Random Image" allowPartial:TRUE]getAttributeNamed:@"src"];
		NSLog(@"imageurl: %@", imageurl);
		webI = [self imageFromURL:imageurl];
	};
	requester.startSynchronous;

	wikiD = request.responseString.copy; requestError = [request error];	};


    AZHTMLParser *p		= [AZHTMLParser.alloc initWithString:wikiD error:nil];
    _rawResult = wikiD;
    NSString * stripped 	= [_rawResult stripHtml];
// parseXMLTag:@"text"]);
    self.results  			= requestError 		?  @[$(@"Error: %@  headers: %@",
requestError, _requester.responseHeaders)]
                  : ![wikiD IsEmpty]	?  @[[wikiD parseXMLTag:@"Description"]] :
nil;
  }
  if (_results.count) _completion(self);
  NSURLREQ *req 	= [NSURLREQ requestWithURL:addy];	NSURLRES *res 	= nil;
NSError 	*err  = nil;
  NSData  *data 	= [NSURLConnection sendSynchronousRequest:req
returningResponse:&res error:&err];
    _rawResult	= (NSArray*)((NSD*)[NSJSONSerialization JSONObjectWithData:data
options:kNilOptions error:NULL])[@"RelatedTopics"];
    self.results   = [_rawResult count] ? [_rawResult vFKP:@"Text"] : nil;


  ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:];
  [requester setCompletionBlock:^(ASIHTTPRequest *request) {

    NSS *responsePage               = request.responseString.copy;
    NSLog(@"got response: %@", responsePage);
    if (!requestError) {
//			NSS *desc                       =       [[p.head
findChildWithAttribute:@"property" matchingName:@"og:description"
allowPartial:YES]
//														  getAttributeNamed:@"content"];
    NSLog(@"found URL... %@", imageurl);
    webI = [self imageFromURL:imageurl];

//			urbanD = $DEFINE(title, desc);
///rawContents.urlDecoded.decodeHTMLCharacterEntities);
//			block(urbanD);
    } else NSLog(@"response error on random web dl:%@", requestError);// urbanD
= $DEFINE(@"undefined", @"no response from urban");

  }];
  [requester startAsynchronous];
  return webI;
*/

/*
#pragma mark - ClassKeyGet

+ objectForKeyedSubscript:x {

  return ISA(x,NSURL) ?  [self from:[x URLString]] :
         ISA(x,  NSS) ?  [x isValidURL] ? [self from:x] : [self imageNamed:x] : nil;
}

+ _Pict_ from: _Text_ stringURL {

  _Data  d = [Data dataWithContentsOfURL:stringURL.urlified];
  return d ? [self.alloc initWithData:d] : NSLog(@"failed to create image for url string:%@", stringURL), (id)nil;
}

+ _Pict_ screenShot {

  return [self.class.alloc initWithCGImage:CGWindowListCreateImage(CGRectInfinite, kCGWindowListOptionOnScreenOnly,
                                                                  kCGNullWindowID, kCGWindowImageDefault) size:AZScreenSize()];
}

static _List frameworkImageNames_ = nil, frameworkImagePaths_ = nil;

+ (NSA*) frameworkImagePaths { return frameworkImagePaths_ = frameworkImagePaths_ ?:

  [NSA arrayWithArrays: [@[ @"pdf", @"png", @"icns" ] map:^id(_Text obj) {

    return [AZFWORKBUNDLE pathsForResourcesOfType:obj inDirectory:@""];

  }]];
}

+ (NSA*) frameworkImageNames { return frameworkImageNames_ = frameworkImageNames_ ?:

  [[NSIMG.frameworkImagePaths mapSelector:@selector(lastPathComponent)]
                              mapSelector:@selector(stringByDeletingPathExtension)];
}

+ (NSA*) frameworkImages {
  //; error:nil] filter:^BOOL(id object) { return [(NSString*)object contains:@".icn"] ? YES : NO; return [f arrayUsingBlock:^id(id obj) {	return [base stringByAppendingPathComponent:obj]; }];
  return [[self.frameworkImagePaths nmap:^id(id obj, _UInt index) {
    return [self imageWithFile:obj named:NSIMG.frameworkImageNames[index]];
  }] filter:^BOOL(id object) { return ISA(object,Pict); }];
}

// void TestLog(const char* prettyF, ...) { }

#define TESTLOGDECLAREARGS(...)                                                \
  NSLog(@"Testing %@ w/args 1.0 (scaleFactor), WHITE (coreColor)m and "        \
        @"RANDOMCOLOR (glowColor);",                                           \
        NSStringFromSelector(_cmd));

- _Pict_ testNamed: _Text_ name { if (name) self.name = name; return self; }

- _Pict_     named: _Text_ name { if (name) self.name = [name copy]; return self; }

+ (INST) withFile:x { return [self imageWithFile:x named:[x lastPathComponent]]; }

+ (INST) imageWithFile: _Text_ file named: _Text_ name { return [self.class.alloc initWithFile:file named:name]; }

- _Pict_  initWithFile: _Text_ file named: _Text_ name {
  NSIMG *i = [(__typeof(self))self.class.alloc initWithContentsOfFile:file.stringByStandardizingPath];
  if(name) [i setName:name];
  return i;
}

+ _Pict_ imageWithSize: _Size_ size named: _Text_ name {
  return [NSIMG.alloc initWithSize:size named:name];
}

- _Pict_ initWithSize:(NSSZ)size named:(NSS*) name {
  return [[NSIMG.alloc initWithSize:size] named:name];
}

+ _List_ systemIcons      {
  _systemIconsFolder = _systemIconsFolder ?: @"/System/Library/CoreServices/"
                           @"CoreTypes.bundle/Contents/" @"Resources/";
  return _systemIcons =
             _systemIcons
                 ?: ^{  // This will only be true the first time the method is
                        // called...
                        return [[[NSIMG
                                systemIconNames_] arrayUsingBlock:^id(id
                                                                          obj) {
                          return [NSIMG
                              imageWithFile:[_systemIconsFolder
                                                stringByAppendingPathComponent:
                                                    (NSString*) obj]
                                      named:
                                          [obj stringByDeletingPathExtension]];
                        }]
                            filter:^BOOL(id object) {
                              return [object isKindOfClass:[NSImage class]];
                            }];
                    }();
}

+ _List_ systemIconNames_ {
  static NSA *theNamesOfSystemIcons_ = nil;
  return theNamesOfSystemIcons_ =
             theNamesOfSystemIcons_
                 ?: [[AZFILEMANAGER contentsOfDirectoryAtPath:_systemIconsFolder
                                                        error:nil]
                        filter:^BOOL(id object) {
                          return [(NSString*) object contains:@".icn"];
                        }];
}

+ (PDFDocument*) monoPDF  {

  AZSTATIC_OBJ(PDFDocument,doc, [PDFDocument.alloc initWithURL:[NSURL fileURLWithPath:[AZFWORKBUNDLE pathForResource:@"PicolSingulario" ofType:@"pdf"]]]);
  return doc;
}

//+ _Pict_ monoIconNamed:(NSS*)name { return [self.monoIcons filterOne:^BOOL(NSIMG*icon) { return SameS(icon.name, name); }]; }

+ _Pict_ randomMonoIcon {   return self.monoIcons.randomElement; }
*/
/*
	NSUI monoCt = self.monoIcons.count;//monoPDF.pageCount -1;
 	NSUI rand = RAND_INT_VAL(0, monoCt-1);
	NSLog(@"randomMono:[%lu / %lu]", rand, monoCt );
	return monosMade ? self.monoIcons[rand]
[self monoIconNamed:@(rand).stringValue];
	 imageFromPDF:self.monoPDF page:rand size:AZSizeFromDim(256)
 named:AZString(rand)];

+ (BOOL)resolveInstanceMethod:(SEL)aSEL {

      if (aSEL == @selector(resolveThisMethodDynamically)) {
          class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
          return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}

+ valueForUndefinedKey:(NSS*) k { AZLOGCMD;

+ (NSMethodSignature*) methodSignatureForSelector:(SEL)s {

  NSMethodSignature *sig = [super methodSignatureForSelector:s];

  if ([[self.monoIcons valueForKey:@"name"] containsString:NSStringFromSelector(s)]) {
    sig = [NSMethodSignature signatureWithObjCTypes:"@@:@"];


  if(!sig) {
            for(id obj in self)
                if((sig = [obj methodSignatureForSelector:sel]))
                    break;
        }
        return sig;
    }
    
    - _Void_ forwardInvocation:(NSInvocation*) inv
    {
        for(id obj in self)
            [inv invokeWithTarget:obj];
    }

+ (BOOL)resolveClassMethod:(SEL)m {

  return [[self.monoIcons valueForKey:@"name"] containsString:NSStringFromSelector(m)] ?


  : [super resolveClassMethod:name];
}
//      NSUI x = [self.monoIcons 
//             : nil;
//)
//    NSString *selectorString = [NSString stringWithFormat:@"crazyClass%@",classname];
//    NSLog(@"string is %@", selectorString);
//    SEL ourSelector = NSSelectorFromString(selectorString);

    if (name == ourSelector) {


        // adding class method to meta-class
        Class ourClass = object_getClass(NSClassFromString(classname));
        class_addMethod(ourClass, ourSelector, (IMP)crazyClassMethod, "@v:@");
        return YES;
    }
    return [super resolveClassMethod:name];
}

NSIMG* resolve(id self, SEL _cmd) {
    NSLog(@"crazyClassMethod has been added!");
}

#define ARRAYWITHOBJECTSATINDEXES(...)
*/
/*    map[43] = @"checkmark";       map[75] = @"paperclip";   map[44] = @"addressBook";
    map[43] = @"checkRound";      map[76] = @"xCircle";     map[81] = @"off";
    map[82] = @"on";              map[109] = @"lightning";  map[111] = @"floppy";
    map[115] = @"folder";         map[131] = @"globe";            map[136] = @"jewishHand";
    map[140] = @"calendar";       map[189] = @"cylinder";         map[220] = @"document";
    map[232] = @"textDocument";   map[261] = @"blinkingPlus";     map[262] = @"blinkingMinus";
    map[266] = @"printer";        map[280] = @"lock";             map[279] = @"magnifyingGlass";
    map[276] = @"wavyDocument";   map[278] = @"computerScreen";   map[273] = @"foldedEdgeoc";
    map[320] = @"volume";         map[323] = @"starFilled";       map[324] = @"starEMpty";
    map[332] = @"textsymbol";     map[337] = @"bold";             map[338] = @"italic";
    map[339] = @"strikethrough";  map[345] = @"trashcan";         map[409] = @"tag";
    map[422] = @"envelope";       map[488] = @"plus";             map[489] = @"minus";
    map[608] = @"recycle";        map[621] = @"umbrella";         map[631] = @"XMark";
    map[630] = @"roundX";         map[626] = @"roundCheck";       map[677] = @"check";
    map[692] = @"safari";         map[693] = @"pointer";          map[695] = @"forbidden";
    map[648] = @"forbiddenLight"; map[640] = @"atSymbol";

  static dispatch_once_t onceToken;
  NSMA *mono_temp = @[].mC;

  dispatch_once(&onceToken, ^{    // IndexedKeyMap *map = IndexedKeyMap.new;
*/
/*      [x enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id c = [self imageFromPDF:myPDF page:[key uIV] size:AZSizeFromDim(256)
                                        named:[@"AtoZMono-"withString:obj]];
        if (c) [mono_temp addObject:c];
      }];
  [mono_temp copy];
  });

    [[@0 to: @(myPDF.pageCount - 1)] az_map:^id(NSN* o){     //          NSString *name = match ? [match copy] : o.strV;
          return [self imageFromPDF:myPDF page:o.iV size:AZSizeFromDim(256)
                                      named:@(o.iV] ?:[@"AtoZMono-"withString:o.strV]];
    }];
  }); monos; }));
*/

/*

static NSMutableIndexSet *namedMonos;

+ _List_ namedMonoIcons { return [self.monoIcons objectsAtIndexes:namedMonos]; }

+ _List_ monoIcons { AZSTATIC_OBJ(List, monos, ({ namedMonos =  NSMutableIndexSet.new;


    id x = @{
      @"43" : AZIMG_checkmark,       @"75"  : @"paperclip",           @"44" : AZIMG_addressBook, //      @(43) : AZIMG_checkRound,
      @"76" : AZIMG_xCircle,         @"81"  : AZIMG_off,
      @"82" : AZIMG_on,              @"109" : AZIMG_lightning,        @"111" : AZIMG_floppy,
      @"115" : AZIMG_folder,         @"131" : AZIMG_globe,            @"136" : AZIMG_jewishHand,
      @"140" : AZIMG_calendar,       @"189" : AZIMG_cylinder,         @"220" : AZIMG_document,
      @"232" : AZIMG_textDocument,   @"261" : AZIMG_blinkingPlus,     @"262" : AZIMG_blinkingMinus,
      @"266" : AZIMG_printer,        @"280" : AZIMG_lock,             @"279" : AZIMG_magnifyingGlass,
      @"276" : AZIMG_wavyDocument,   @"278" : AZIMG_computerScreen,   @"273" : AZIMG_foldedEdgeoc,
      @"320" : AZIMG_volume,         @"323" : AZIMG_starFilled,       @"324" : AZIMG_starEmpty,
      @"332" : AZIMG_textsymbol,     @"337" : AZIMG_bold,             @"338" : AZIMG_italic,
      @"339" : AZIMG_strikethrough,  @"345" : AZIMG_trashcan,         @"409" : AZIMG_tag,
      @"422" : AZIMG_envelope,       @"488" : AZIMG_plus,             @"489" : AZIMG_minus,
      @"608" : AZIMG_recycle,        @"621" : AZIMG_umbrella,         @"631" : AZIMG_XMark,
      @"630" : AZIMG_roundX,         @"626" : AZIMG_roundCheck,       @"677" : AZIMG_check,
      @"692" : AZIMG_safari,         @"693" : AZIMG_pointer,          @"695" : AZIMG_forbidden,
      @"648" : AZIMG_forbiddenLight, @"640" : AZIMG_atSymbol };

      PDFDocument * myPDF =self.monoPDF;

      [@(myPDF.pageCount - 1) mapTimes:^id(NSNumber *o) {

        id name;
        NSN* adjusted = [o plus:@1];
        BOOL hasName = (( name = [x objectForKey:[adjusted sVal]] ));
        id z = [NSIMG imageFromPDF:myPDF page:o.iV size:AZSizeFromDim(256) named:[@"AtoZMono-" withString:name ?: [adjusted sVal]]];

//          LOGCOLORS(@" Adding Index ", [o minus:@1], nil);
        !hasName ?: [namedMonos addIndex:o.uIV];
        return z;
      }];
    })); return monos; }

#pragma TODO - NEED to make this shit dynamic , keysubbed, etc.

+ _Pict_ missing { return [self imageNamed:@"missing.png"]; }

+ _Pict_ imageFromPDF:(PDFDocument*)doc page: _UInt_ page size:_Size_ size named: _Text_ name {

  _Pict render = [Pict imageWithSize:size named:name];
  [render addRepresentation:[NSPDFImageRep imageRepWithData:[doc pageAtIndex:page].dataRepresentation]];
  return render;
}
*/
/*+ (NSA*) iconStrings {		NSBundle *aBundle = [NSBundle bundleForClass:
 * [DummyClass class]];	return [aBundle pathsForResourcesOfType:@"pdf"
 * inDirectory:@"picol"]; NSLog(@"%@", imagePaths); } */
/*
+ _Pict_ systemIconNamed: _Text_  name {

  return [self.systemIcons filterOne:^BOOL(NSIMG *o) {
    return [o.name.lowercaseString contains:name.lowercaseString];
  }];
}

+ _Pict_ frameworkImageNamed: _Text_ string { return [self imageWithFileName:string inBundle:AZFWORKBUNDLE]; }

+ _Pict_ randomIcon { return [self az_imageNamed:self.picolStrings.randomElement]; }

//+ (NSA*) iconsColoredWithColor:(NSC*) color;

+ _List_ picolStrings { AZSTATIC_OBJ(NSA,picolStrings_, [AZFILEMANAGER filesInFolder:[AZFWRESOURCES withPath:@"picol/"]]);
  return picolStrings_;
}
+ _List_ icons { return [NSA arrayWithArrays:@[ self.monoIcons, self.systemIcons ]]; }
*/
/*	return 	[[[NSImage picolStrings] map:^id(id obj) {		NSIMG*u =[[NSImage
alloc]initWithContentsOfFile:[[self
picolFolderPath]stringByAppendingPathComponent:obj]];		u.name = [obj
stringByDeletingPathExtension]; return u;	}]filter:^BOOL(id object) {		return
[object isKindOfClass:[NSImage class]] && !IsEmpty(object); }];
//	return  [[[self class] picolStrings] map:^id(id obj) {		NSIMG*i = [NSImage
az_imageNamed:obj];		NSLog(@"loading %@  aka %@", [obj lastPathComponent], i);
return i;	}];	 filter:^BOOL(id obj) {	return obj ? YES:  NO;	}];} */
/*

+ _Pict_ forFile:(AZFile*) file {

  NSSZ theSize = AZSizeFromDim(512);
  return [AZWORKSPACE iconForFile:file.path]
                 ? [[AZWORKSPACE iconForFile:file.path]
                       imageScaledToFitSize:theSize]
                 : [NSImage az_imageNamed:@"missing.png"];
}

+ _List_ randomImages:_UInt_ count {
  static NSA *randomImages_;

  randomImages_ =
      randomImages_
          ?: [NSA arrayWithArrays:@[ self.icons, self.frameworkImages ]];
  return [randomImages_ randomSubarrayWithSize:count];
}

+ _Pict_ blackBadgeForRect:(NSR)frame { return [self badgeForRect:frame withColor:BLACK]; }

+ _Pict_ badgeForRect: _Rect_ frame withColor: _Colr_ color { return [self badgeForRect:frame withColor:color stroked:nil]; }

+ _Pict_ badgeForRect: _Rect_ frame withColor: _Colr_ color stroked: _Colr_ stroke {

  return [self badgeForRect:frame withColor:color stroked:stroke withString:nil];
}

+ _Pict_ badgeForRect:(NSR)frame
              withColor:(NSC*) color
                stroked:(NSC*) stroke
             withString:(NSS*) string {

  return [self badgeForRect:frame
                  withColor:color
                    stroked:stroke
                 withString:string
                orDrawBlock:nil];
}
+ _Pict_ badgeForRect:(NSR)frame
              withColor:(NSC*) color
                stroked:(NSC*) stroke
             withString:(NSS*) string
            orDrawBlock:(void (^)(NSR))drawBlock {

  //	[AtoZ sharedInstance];

  CGF inset = AZMinDim(frame.size) * .1;
  NSR outerRect = AZCenterRectOnRect(
      AZRectFromDim((AZMinDim(frame.size) - inset)),
      frame); // AZSquareInRect( 	  NSInsetRect( newFrame, inset, inset ));
  NSR centerRect = NSInsetRect(outerRect, inset / 2, inset / 2);

  NSC *contraster = stroke ?: color.contrastingForegroundColor;
  NSC *variant = contraster.isDark ? contraster.brighter.brighter
                                   : contraster.darker.darker;

  NSSZ shadowOff = NSMakeSize(inset / 6, -inset / 6);
  NSBP *centerBP = [NSBP bezierPathWithOvalInRect:centerRect];
  NSBP *outerBP = [NSBP bezierPathWithOvalInRect:outerRect];
  NSShadow *innerShadow =
      [NSShadow shadowWithOffset:AZMultiplySize(shadowOff, .5)
                      blurRadius:inset / 4
                           color:color.darker.darker.darker];

  NSIMG *badge = [self imageWithSize:frame.size named:string];
  [badge lockFocus];
  [NSSHDW setShadowWithOffset:shadowOff
                   blurRadius:inset / 4
                        color:[BLACK alpha:.75]];
  [outerBP fill];
  [NSSHDW clearShadow];
  [outerBP fillGradientFrom:variant to:contraster angle:90];
  [centerBP fillGradientFrom:color.brighter.brighter
                          to:color.darker.darker
                       angle:270];

  [CLEAR set];
  [centerBP fillWithInnerShadow:innerShadow];
  if (drawBlock) drawBlock(frame);

  !string ?: ^{
                 [innerShadow set];
                 [string drawInRect:AZInsetRect(centerRect, inset)
                      withFontNamed:@"PrintBold"
                           andColor:contraster];
                 // Ubuntu Mono Bold // Nexa Bold" Ivolkswagen DemiBold"
             }();
  [badge unlockFocus];
  return badge;
}
- _Void_ draw { [self drawAtPoint:NSZeroPoint]; }

- _Void_ drawAtPoint:(NSP)point { [self drawAtPoint:point inRect:NSZeroRect]; }

- _Void_ drawAtPoint:(NSP)point inRect:(NSR)rect {

  [self drawAtPoint:point fromRect:rect operation:NSCompositeSourceOver fraction:1];
}
- (CAL*) imageLayerForRect:(NSR)rect {
  return ReturnImageLayer([CAL layerWithFrame:rect], self, 1);
}

+ _Pict_ imagesInQuadrants:(NSA*) images inRect:(NSR)frame {
  return [self imageWithSize:frame.size
             drawnUsingBlock:^{ [self drawInQuadrants:images inRect:frame]; }];
}
- _Void_ drawinQuadrant:(QUAD)quad inRect:(NSR)rect;
{
  [self
      drawInRect:
          quadrant(
              rect,
              quad)]; /// alignRectInRect(AZRectFromDim(rect.size.width/2),rect,quad)];
}
+ (void)drawInQuadrants:(NSA*) images inRect:(NSR)frame {

  [[images subarrayToIndex:4] eachWithIndex:^(NSIMG *obj, NSI idx) {
      [obj drawInRect:quadrant(frame, idx)];
  }];
}
//  alignRectInRect( AZRectFromDim( frame.size.width/2 ), frame, (QUAD)idx);/
//  NSRectFillWithColor(thisQ, RANDOMCOLOR);
- _Pict_ reflected:(float)amountFraction {

  return [self.class reflectedImage:self amountReflected:amountFraction];
}
+ _Pict_ reflectedImage:(NSIMG*) sourceImage amountReflected:(float)fraction {
  NSIMG *reflection = [NSIMG.alloc initWithSize:sourceImage.size];
  [reflection setFlipped:NO];
  NSRect reflectionRect = (NSRect) {0, 0, sourceImage.size.width,
                                    sourceImage.size.height * fraction};
  [reflection lockFocus];
  CTGradient *fade =
      [CTGradient gradientWithBeginningColor:GRAY5 endingColor:CLEAR];
  [fade fillRect:reflectionRect angle:90.0];
  [sourceImage drawAtPoint:NSZeroPoint
                  fromRect:reflectionRect
                 operation:NSCompositeSourceIn
                  fraction:1.0];
  [reflection unlockFocus];
  return reflection;
}
- (NSSZ)proportionalSizeForTargetSize:(NSSZ)targetSize {

  NSSZ imageSize = self.size;
  float width = imageSize.width;
  float height = imageSize.height;
  float targetWidth = targetSize.width;
  float targetHeight = targetSize.height;

/// scaleFactor will be the fraction that we'll use to adjust the size. \
  For example, if we shrink an image by half, scaleFactor will be 0.5. \
  the scaledWidth and scaledHeight will be the original, \
  multiplied by the scaleFactor. \
  IMPORTANT: the "targetHeight" is the size of the space we're drawing into. \
  The "scaledHeight" is the height that the image actually is drawn at, \
  once we take into account the idea of maintaining proportions

  float scaleFactor = 0.0;
  float scaledWidth = targetWidth;
  float scaledHeight = targetHeight;
  //	since not all images are square, we want to scale proportionately. To do
  // this, we find the longest edge and use that as a guide.
  if (NSEqualSizes(imageSize, targetSize) == NO) {
    // use the longeset edge as a guide. if the image is wider than tall, we'll
    // figure out the scale factor by dividing it by the intended width.
    // Otherwise, we'll use the height.
    float widthFactor = targetWidth / width;
    float heightFactor = targetHeight / height;
    scaleFactor = widthFactor < heightFactor ? widthFactor : heightFactor;
    scaledWidth = width * scaleFactor; // ex: 500 * 0.5 = 250 (newWidth)
    scaledHeight = height * scaleFactor;
  }
  return NSMakeSize(scaledWidth, scaledHeight);
}
- _Pict_ imageByScalingProportionallyToSize:(NSSZ)tSz {
  return [self imageByScalingProportionallyToSize:tSz flipped:NO];
}
- _Pict_ imageByScalingProportionallyToSize:(NSSZ)tSz flipped:(BOOL)f {

  return [self imageByScalingProportionallyToSize:tSz
                                          flipped:f
                                         addFrame:NO
                                        addShadow:NO];
}
- _Pict_ imageByScalingProportionallyToSize:(NSSZ)tSz
                                      flipped:(BOOL)f
                                     addFrame:(BOOL)n
                                    addShadow:(BOOL)q {

  return [self imageByScalingProportionallyToSize:tSz
                                          flipped:f
                                         addFrame:n
                                        addShadow:q
                                         addSheen:YES];
}
- _Pict_ imageByScalingProportionallyToSize:(NSSZ)tSz
                                      flipped:(BOOL)f
                                     addFrame:(BOOL)n
                                    addShadow:(BOOL)q
                                     addSheen:(BOOL)s {

  NSIMG *sourceImage = self;
  NSIR *rep = [sourceImage bestRepresentationForSize:tSz];
  NSI pixelsWide = rep.pixelsWide;
  NSI pixelsHigh = rep.pixelsHigh;
  sourceImage.size = NSMakeSize(pixelsWide, pixelsHigh);
  NSIMG *newImage = nil;
  if ([sourceImage isValid] == NO)
    return nil;
  // settings for shadow
  float shadowRadius = 4.0;
  NSSZ shadowTargetSize = tSz;
  if (q) {
    shadowTargetSize.width -= (shadowRadius * 2);
    shadowTargetSize.height -= (shadowRadius * 2);
  }
  NSSZ imageSize = sourceImage.size;
  float width = imageSize.width;
  float height = imageSize.height;
  float targetWidth = tSz.width;
  float targetHeight = tSz.height;
  // scaleFactor will be the fraction that we'll use to adjust the size. For
  // example, if we shrink an image by half, scaleFactor will be 0.5. the
  // scaledWidth and scaledHeight will be the original, multiplied by the
  // scaleFactor.
  //	IMPORTANT: the "targetHeight" is the size of the space we're drawing into.
  // The "scaledHeight" is the height that the image actually is drawn at, once
  // we take into account the idea of maintaining proportions

  float scaleFactor = 0.0;
  float scaledWidth = targetWidth;
  float scaledHeight = targetHeight;
  NSP thumbnailPoint = NSZeroPoint;

  // since not all images are square, we want to scale proportionately. To do
  // this, we find the longest edge and use that as a guide.
  if (NSEqualSizes(imageSize, tSz) == NO) {
    //	use the longeset edge as a guide. if th image is wider than tall, we'll
    // figure out the scale factor by dividing it by the intended width.
    // Otherwise, we'll use the height.

    float widthFactor =
        q ? shadowTargetSize.width / width : targetWidth / width;
    float heightFactor =
        q ? shadowTargetSize.height / height : targetHeight / height;

    scaleFactor = widthFactor < heightFactor
                      ? widthFactor
                      : heightFactor; // ex: 500 * 0.5 = 250 (newWidth)
    scaledWidth = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    //	center the thumbnail in the frame. if  wider than tall, we need to
    // adjust the vertical drawing point (y axis)
    if (widthFactor < heightFactor)
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    else if (widthFactor > heightFactor)
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
  }

  newImage = [NSIMG
        imageWithSize:tSz
      drawnUsingBlock:^{
          // once focus is locked, all drawing goes into this NSImage instance
          // directly, not to the screen. It also receives its own graphics
          // context. Also, keep in mind that we're doing this in a background
          // thread.  You only want to draw to the screen in the main thread,
          // but drawing to an offscreen image is (apparently) okay.

          [AZGRAPHICSCTX
              setImageInterpolation:
                  NSImageInterpolationHigh]; // create the properly-scaled rect
          NSRect thumbnailRect;
          thumbnailRect.origin = thumbnailPoint;
          thumbnailRect.size.width = scaledWidth;
          thumbnailRect.size.height = scaledHeight;

          // add shadow below the image?
          if (q) // shouldAddShadow
          {
            // we need to adjust the y coordinate to make sure
            // the image ends up in the right place in a flipped
            // coordinate system.
            if (f && height > width)
              thumbnailRect.origin.y += (shadowRadius * 2); // isFlipped

            // draw the shadow where the image will be
            NSShadow *shadow = NSShadow.new;
            shadow.shadowColor = GRAY5;
            if (f)
              [shadow setShadowOffset:NSMakeSize(shadowRadius,
                                                 shadowRadius)]; // isFlipped
            else
              [shadow setShadowOffset:NSMakeSize(shadowRadius, -shadowRadius)];
            [shadow setShadowBlurRadius:shadowRadius];
            [NSGraphicsContext saveGraphicsState];
            [shadow set];
            [[NSC whiteColor] set];
            [NSBP fillRect:thumbnailRect];
            [NSGraphicsContext restoreGraphicsState];
            //		[shadow release];
          }
          // draw the actual image
          [sourceImage drawInRect:thumbnailRect
                         fromRect:NSZeroRect
                        operation:NSCompositeSourceOver
                         fraction:1.0];
          // add a frame above the image content?
          if (n) // shouldAddFrame
          {
            // draw the larger internal frame
            NSRect insetFrameRect = NSInsetRect(thumbnailRect, 3, 3);
            NSBP *insetFrame = [NSBP bezierPathWithRect:insetFrameRect];
            [insetFrame setLineWidth:6.0];
            [[NSC whiteColor] set];
            [insetFrame stroke];

            // draw the external bounding frame with no anti-aliasing
            [[NSC colorWithCalibratedWhite:0.60 alpha:1.0] set];
            NSBP *outsetFrame = [NSBP bezierPathWithRect:thumbnailRect];
            [NSGraphicsContext saveGraphicsState];
            [AZGRAPHICSCTX setShouldAntialias:NO];
            [outsetFrame setLineWidth:1.0];
            [outsetFrame stroke];
            [NSGraphicsContext restoreGraphicsState];
          }

          if (s) // shouldAddSheen
          {
            NSRect sheenRect = NSInsetRect(thumbnailRect, 7, 7);
            CGF originalHeight = sheenRect.size.height;
            sheenRect.size.height = originalHeight * 0.75;
            sheenRect.origin.y += originalHeight * 0.25;

            NSBP *sheenPath = [NSBP bezierPath];
            NSP point1, point2, point3, controlPoint1, controlPoint2;
            point1 = (NSP) {sheenRect.origin.x + sheenRect.size.width,
                            sheenRect.origin.y + sheenRect.size.height};
            point2 = (NSP) {sheenRect.origin.x,
                            sheenRect.origin.y + sheenRect.size.height};
            point3 = (NSP) {sheenRect.origin.x, sheenRect.origin.y};
            controlPoint1 = point2;
            controlPoint2 = point1;
            [sheenPath moveToPoint:point1];
            [sheenPath lineToPoint:point2];
            [sheenPath lineToPoint:point3];
            [sheenPath curveToPoint:point1
                      controlPoint1:controlPoint1
                      controlPoint2:controlPoint2];
            NSGradient *gradient = [NSGradient.alloc
                initWithColorsAndLocations:
                    [NSC colorWithCalibratedWhite:1.0 alpha:0.60], 0.00,
                    [NSC colorWithCalibratedWhite:1.0 alpha:0.40], 0.15,
                    [NSC colorWithCalibratedWhite:1.0 alpha:0.20], 0.28,
                    [NSC colorWithCalibratedWhite:1.0 alpha:0.01], 0.85, nil];
            [gradient drawInBezierPath:sheenPath angle:285.0];
            //		[gradient release];
          }
      }];
  newImage.flipped = f;
  newImage.cacheMode = NSImageCacheNever;

  return newImage;
}
- _Pict_ imageByFillingVisibleAlphaWithColor:(NSC*) fillColor {

  // convert source image to CIImage	NSData* sourceImageData = [self
  // TIFFRepresentation];
  CIImage *imageToFill =
      [self toCIImage]; // [CIImage imageWithData:sourceImageData];
  // create CIFalseColor filter
  CIColor *color = [CIColor.alloc initWithColor:fillColor];
  CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
  [filter setValue:imageToFill forKey:@"inputImage"];
  [filter setValue:color forKey:@"inputColor0"];
  [filter setValue:color forKey:@"inputColor1"];
  // get resulting image and add as a NSCIImageRep
  CIImage *compositedImage = [filter valueForKey:@"outputImage"];
  NSIMG *finalImage = [NSImage.alloc initWithSize:self.size];
  NSCIImageRep *ciImageRep = [NSCIImageRep imageRepWithCIImage:compositedImage];
  [finalImage addRepresentation:ciImageRep];
  return finalImage;
}
- _Pict_ blackWhite {

  NSIMG *image = self.copy;
  [image lockFocus];
  // http://stackoverflow.com/a/10033772/304894
  CIImage *beginImage = [CIImage.alloc initWithData:image.TIFFRepresentation];
  CIImage *blackAndWhite = [[CIFilter
      filterWithName:@"CIColorControls"
       keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", @0,
                     @"inputContrast", @(1.1), @"inputSaturation", @0, nil]
      valueForKey:@"outputImage"];
  CIImage *output =
      [[CIFilter filterWithName:@"CIExposureAdjust"
                  keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV",
                                @0.7, nil] valueForKey:@"outputImage"];
  [output drawInRect:AZRectFromSize(self.size)
            fromRect:NSRectFromCGRect(output.extent)
           operation:NSCompositeSourceOver
            fraction:1.0];
  [image unlockFocus];
  return image;
}
+ _Pict_ offset:(NSIMG *)_image top:(CGF)top {

  NSIMG *newImage = [NSImage.alloc
      initWithSize:NSMakeSize(_image.size.width, _image.size.height + top)];
  [newImage lockFocus];
  [AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationHigh];
  [_image drawInRect:AZRectBy(_image.size.width, _image.size.height)
            fromRect:AZRectBy(_image.size.width, _image.size.height)
           operation:NSCompositeSourceOver
            fraction:1.0];
  [newImage unlockFocus];
  return newImage;
}
- _Pict_ inverted {

  NSIMG *image = self.copy;
  [image lockFocus];
  CIImage *ciImage = [CIImage.alloc initWithData:image.TIFFRepresentation];
  CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
  [filter setDefaults];
  [filter setValue:ciImage forKey:@"inputImage"];
  CIImage *output = [filter valueForKey:@"outputImage"];
  [output drawInRect:AZMakeRectFromSize(self.size)
            fromRect:NSRectFromCGRect(output.extent)
           operation:NSCompositeSourceOver
            fraction:1.0];
  [image unlockFocus];
  return image;
}
- _Pict_ imageByConvertingToBlackAndWhite {
  // convert source image to CIImage
  NSData *sourceImageData = [self TIFFRepresentation];
  CIImage *imageToFill = [CIImage imageWithData:sourceImageData];

  // create CIColorMonochrome filter
  CIColor *color = [CIColor.alloc initWithColor:[NSC whiteColor]];
  CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
  [filter setValue:imageToFill forKey:@"inputImage"];
  [filter setValue:color forKey:@"inputColor"];
  [filter setValue:@1.0f forKey:@"inputIntensity"];

  // get resulting image and add as a NSCIImageRep
  CIImage *compositedImage = [filter valueForKey:@"outputImage"];
  NSIMG *finalImage = [NSImage.alloc initWithSize:self.size];
  NSCIImageRep *ciImageRep = [NSCIImageRep imageRepWithCIImage:compositedImage];
  [finalImage addRepresentation:ciImageRep];

  return finalImage;
}
// this creates an image from the entire 'visible' rectangle of a view.  For
// offscreen views this is the entire view.
+ _Pict_ createImageFromView:(NSV*) view {
  NSR rect = view.bounds;
  return [self createImageFromSubView:view rect:rect];
}
// this creates an image from a subset of the view's visible rectangle
+ _Pict_ createImageFromSubView:(NSV*) view rect:(NSR)rect {
  // first get teh properly setup bitmap for this view
  NSBIR *imageRep =
      [view bitmapImageRepForCachingDisplayInRect:rect];
  // now use that bitmap to store the desired view rectangle as bits
  [view cacheDisplayInRect:rect toBitmapImageRep:imageRep];
  // jam that bitrep into an image and return it
  NSIMG *image = [NSImage.alloc initWithSize:rect.size];
  [image addRepresentation:imageRep];
  return image;
}
- _Pict_ maskWithColor:(NSC*) c {

  NSIMG *badgeImage = [NSImage.alloc initWithSize:self.size];
  //	[NSGraphicsContext saveGraphicsState];
  [badgeImage lockFocus];
  //	NSShadow *theShadow = NSShadow.new;
  //	[theShadow setShadowOffset: NSMakeSize(0,10)];
  //	[theShadow setShadowBlurRadius:10];
  //	[theShadow setShadowColor:[[NSC blackColor] colorWithAlphaComponent:.9]];
  //	[theShadow set];
  //	[badgeImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
  //	[NSGraphicsContext restoreGraphicsState];
  [c set];
  NSRectFill(AZMakeRectFromSize(self.size));
  //	[self drawAtPoint:NSZeroPoint fromRect:NSZeroRect
  // operation:NSCompositeDestinationAtop fraction:1];
  [badgeImage unlockFocus];
  return badgeImage;
}
- _Pict_ scaleImageToFillSize:(NSSZ)targetSize {
  NSSZ sourceSize = self.size;
  NSRect sourceRect, destinationRect;
  sourceRect = destinationRect = NSZeroRect;
  sourceRect =
      sourceSize.height > sourceSize.width
          ? AZMakeRect(
                (NSPoint) {0.0,
                           round((sourceSize.height - sourceSize.width) / 2)},
                sourceSize)
          : AZMakeRect(
                (NSPoint) {round((sourceSize.width - sourceSize.height) / 2),
                           0.0},
                sourceSize);

  destinationRect.size = targetSize;
  NSIMG *final = [NSImage.alloc initWithSize:targetSize];
  [final setSize:targetSize];
  [final lockFocus];
  [AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationLow];
  [final drawInRect:destinationRect
           fromRect:sourceRect
          operation:NSCompositeSourceOver
           fraction:1.0];
  [final unlockFocus];
  return final;
}
- _Pict_ coloredWithColor:(NSC*) inColor {
  return [self coloredWithColor:inColor composite:NSCompositeDestinationIn];
}
- _Pict_ coloredWithColor:(NSC*) inColor
                  composite:(NSCompositingOperation)comp {
  static __unused CGF kGradientShadowLevel = 0.25;
  static CGF kGradientAngle = 270.0;
  if (inColor) {
    BOOL avoidGradient = NO; // ( [self state] == NSOnState );
    NSRect targetRect = NSMakeRect(0, 0, self.size.width, self.size.height);
    NSIMG *target = [NSImage
          imageWithSize:self.size
        drawnUsingBlock:^{

            //		NSGradient *gradient = ( avoidGradient ? nil :
            //[NSGradient.alloc initWithStartingColor:inColor.brighter
            // endingColor:[inColor.darker
            // shadowWithLevel:kGradientShadowLevel]]
            //);
            //		[target lockFocus];
            if (avoidGradient)
              NSRectFillWithColor(AZRectFromSize(self.size), inColor);
            //		[shadowWithLevel:kGradientShadowLevel
            else {
              [[NSGradient gradientFrom:inColor.brighter to:inColor.darker]
                  drawInRect:AZRectFromSize(self.size)
                       angle:kGradientAngle];
              [self drawInRect:targetRect
                      fromRect:NSZeroRect
                     operation:comp
                      fraction:1.0];
            }
        }];
    target.name =
        self.name ?: $(@"Image filled with color: %@", [inColor name]);
    //		[target unlockFocus];
    return target;
  } else
    return self;
}

+ _Pict_ imageWithFileName:(NSS*) fileName inBundle:(NSBundle*) aBundle {
  NSIMG *img = nil;
  if (aBundle != nil) {
    NSString *imagePath;
    if ((imagePath = [aBundle pathForResource:fileName ofType:nil]) != nil) {
      img = [NSImage.alloc initWithContentsOfFile:imagePath];
    }
  }
  return img;
}

+ _Pict_ imageWithFileName:(NSS*) fileName inBundleForClass:(Class)aClass {
  return [self imageWithFileName:fileName
                        inBundle:[NSBundle bundleForClass:aClass]];
}

+ _Pict_ az_imageNamed:(NSS*) name {
  NSIMG *i;
  return i = [NSIMG az_imageNamed:name]
                     ?: [NSIMG.alloc
                            initWithContentsOfFile:
                                [AZFWORKBUNDLE pathForImageResource:name]],
         [i setName:name], i;
  //	i.name 	= i.name ?: name;	return i;
}

//+ _Pict_ az_imageNamed:(NSS*) fileName {
//	NSBundle *aBundle = [NSBundle bundleForClass: [self class]];
//	return [self imageWithFileName: fileName inBundle: aBundle]; }

+ _Pict_ swatchWithColors:(NSA*)cs size:(NSSZ)z oriented:(AZO)o {

//  [NSC.randomColor
  //[AZSizer forQuantity:cs.count ofSize:z withColumns:isVertical(o) ? 1 : cs.count];
  return [self imageForSize:z withDrawingBlock:^{

    AZSizer *szr = [AZSizer forQuantity:cs.count inRect:AZRectFromSize(z)];
    [szr.rects eachWithIndex:^(NSVAL*v, NSI idx){
      NSRectFillWithColor(v.rV, [cs normal:idx]);
    }];
  }]; //  [color drawSwatchInRect:NSMakeRect(0, 0, size.width, size.height)];
}


+ _Pict_ swatchWithColor:(NSC*) color size:(NSSZ)size {
  NSIMG *image = [NSImage.alloc initWithSize:size];
  [image lockFocus];
  [color drawSwatchInRect:NSMakeRect(0, 0, size.width, size.height)];
  [image unlockFocus];
  return image;
}

+ _Pict_ swatchWithGradientColor:(NSC*) color size:(NSSZ)size {
  NSIMG *image = [NSImage.alloc initWithSize:size];
  [image lockFocus];
  NSGradient *fade =
      [NSGradient.alloc initWithStartingColor:color.brighter
                                  endingColor:color.darker.darker];
  [fade drawInRect:NSMakeRect(0, 0, size.width, size.height) angle:270];
  [image unlockFocus];
  return image;
}

- _Pict_ resizeWhenScaledImage { return [self setScalesWhenResized:YES], self; }

+ _Pict_ prettyGradientImage {

  NSSZ gradientSize = AZSizeFromDim(256);
  NSImage *newImage =
      [self.alloc initWithSize:gradientSize]; // In this case, the pixel
                                              // dimensions match the image
                                              // size.

  int pixelsWide = gradientSize.width, pixelsHigh = gradientSize.height;

  NSBIR *bitmapRep = [NSBIR.alloc
      initWithBitmapDataPlanes:nil // Nil pointer makes the kit allocate the
                                   // pixel buffer for us.
                    pixelsWide:pixelsWide // The compiler will convert these to
                                          // integers, but I just wanted to
                                          // make it quite explicit
                    pixelsHigh:pixelsHigh //
                 bitsPerSample:8
               samplesPerPixel:4 // Four samples, that is: RGBA
                      hasAlpha:YES
                      isPlanar:NO // The math can be simpler with planar images,
                                  // but performance suffers..
                colorSpaceName:NSCalibratedRGBColorSpace // A calibrated color
                                                         // space gets us
                                                         // ColorSync for free.
                   bytesPerRow:0    // Passing zero means "you figure it out."
                  bitsPerPixel:32]; // This must agree with bitsPerSample and
                                    // samplesPerPixel.

  unsigned char *imageBytes = [bitmapRep bitmapData]; // -bitmapData returns a
                                                      // void*, not an NSData
                                                      // object ;-)

  int row = pixelsHigh;

  while (row--) {
    int col = pixelsWide;
    while (col--) {
      int pixelIndex = 4 * (row * pixelsWide + col);
      imageBytes[pixelIndex + red] = rint(fmod(
          distance(NSMakePoint(col / 1.5, (255 - row) / 1.5)), 255.0)); // red
      imageBytes[pixelIndex + green] = rint(
          fmod(distance(NSMakePoint(col / 1.5, row / 1.5)), 255.0)); // green
      imageBytes[pixelIndex + blue] =
          rint(fmod(distance(NSMakePoint((255 - col) / 1.5, (255 - row) / 1.5)),
                    255.0)); // blue
      imageBytes[pixelIndex + alpha] =
          255; // Not doing anything tricky with the Alpha value here...
    }
  }
  [newImage addRepresentation:bitmapRep];
  return newImage;
}

- (NSC*) quantized {
  NSA *q = self.quantize;
  return (q.count) ? q.first : CHECKERS;
}

- (NSBIR*) quantizerRepresentation {

  return objc_getAssociatedObject(self, _cmd) ?: ({ id x;

//    NSIMG *cp = [self scaleDown:AZSizeFromDim(16)];//scaledToMax:16];
//    cp.size = AZSizeFromDim(16);
//    NSBIR *imageRep = cp.bitmap;
//    if (imageRep.colorSpace != NSColorSpace.deviceRGBColorSpace)
//      [imageRep bitmapImageRepByRetaggingWithColorSpace:NSColorSpace.deviceRGBColorSpace];

    objc_setAssociatedObject(self, _cmd, x = [self bitmapBy:16 y:16], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    x;

  });
}

- (NSA*) quantize { return objc_getAssociatedObject(self, _cmd) ?: ({

//    if ([[self.representations.firstObject colorSpac] )
    NSBag *satchel = NSBag.bag;
    NSBIR *imageRep = self.quantizerRepresentation;

    IterateGridWithBlock($RNG(0, 16), $RNG(0, 16), ^(NSI i, NSI j) { NSC *thisPx;

      !(thisPx = [imageRep colorAtX:i y:j]).alphaComponent ?: [satchel add:thisPx];

    });

//    NSUI ctr = satchel.objects.count < 10 ? satchel.objects.count : 10;
//
//    for (int j = 0; j < ctr; j++)
//      for (int s = 0; s < [satchel occurrencesOf:satchel.objects[j]]; s++)
//        [savedQs addObject:satchel.objects[j]];

    objc_setAssociatedObject(self, _cmd, [satchel sortedObjects], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_getAssociatedObject(self, _cmd);
  });
}
*/
/*
	[imageRep bitmapImageRepByConvertingToColorSpace:NSColorSpace.deviceRGBColorSpace
 renderingIntent:NSColorRenderingIntentDefault];
	NSI width = 32, height = 32;				//
                      [imageRep pixelsWide]; NSI height
                      = 	[imageRep pixelsHigh];

	for (int i = 0; i < width; i++) {
		for (int j = 0; j < height; j++) {  				//	[self
 setColor:AGColorFromNSColor([imageRep colorAtX:i y:j])
			NSC *thisPx = [imageRep colorAtX:i y:j];
			[thisPx alphaComponent] == 0 ?: [satchel add:thisPx];
		}
	}
	int counter = ( [satchel objects].count < 10 ? [satchel objects].count : 10
);
	for (int j = 0; j < counter; j++) {
		for (int s = 0; s < [satchel occurrencesOf:[satchel objects] [j]]; s++)
			[catcher addObject:[satchel objects][j]];
	}
		[NSGraphicsContext saveGraphicsState];
	NSIMG*quantized = self.copy;
	[self setSize:NSMakeSize(32, 32)];
	[anImage setSize:NSMakeSize(32, 32)];
	NSSZ size = [self size];
	NSRect iconRect = NSMakeRect(0, 0, size.width, size.height);
	[self lockFocus];
	NSBIR *imageRep = [self bitmap];
	NSBIR *imageRep = [NSBIR.alloc
 initWithFocusedViewRect:iconRect];
	[self unlockFocus];
	[nSImage imageNamed:NSImageNameHomeTemplate
	NSIMG*image = [NSImage.alloc initWithData:[rep
 representationUsingType:NSPNGFileType properties:nil]];
	NSBIR *imageRep = (NSBIR*)[[image representations]
 objectAtIndex:0];
	NSIMG*resizedIcon = [NSImage.alloc initWithIconRef:[self]];
	[resizedIcon lockFocus];
	[self drawInRect:resizedBounds fromRect:NSZeroRect operation:NSCompositeCopy
 fraction:1.0];
	[resizedIcon unlockFocus];

	NSBIR* imageRep = [[resizedIcon representations]
 objectAtIndex:0];
	NSBIR *imageRep = nil;
	if (![firstRep isKindOfClass:[NSBIR class]])	{
		NSRect resizedBounds = NSMakeRect(0,0,32,32);
		[self lockFocus];
		[self drawInRect:resizedBounds fromRect:NSZeroRect
 operation:NSCompositeCopy fraction:1.0];
		imageRep = [NSBIR imageRepWithData:[self TIFFRepresentation]];
		[self unlockFocus];
	} else imageRep = (NSBIR *) firstRep;

	NSBIR *imageRep = (NSBIR *)[self smallestRepresentation];
*/
/*
- _Pict_ generateQuantizedSwatch {

  NSA *q = self.quantize;
  NSIMG *u = [NSIMG.alloc initWithSize:AZSizeFromPoint((NSPoint) {512, 256})];
  AZSizer *s = [AZSizer forQuantity:q.count inRect:AZRectFromDim(256)];
  [u lockFocus];
  [s.rects eachWithIndex:^(id obj, NSI idx) {
      [(NSC*) q[idx] set];
      NSRectFill([obj rectValue]);
  }];
  [[self scaledToMax:256] drawAtPoint:(NSPoint) { 256, 0 }
                             fromRect:NSZeroRect
                            operation:NSCompositeSourceOver
                             fraction:1];
  [u unlockFocus];
  return u;
}

+ _Pict_ svg2png:(NSString*) inFile out:(NSString*) optionalOutFile;
{
  NSS *p = optionalOutFile ?: $(@"/tmp/atoztempimage.%@.png",
                                [NSString newUniqueIdentifier]);
  NSTask *job = [NSTask launchedTaskWithLaunchPath:@"/usr/local/bin/svg2png"
                                         arguments:@[ inFile, p ]];
  [job waitUntilExit];
  return [[NSIMG alloc] initWithContentsOfFile:p];
}

- (NSS*) saveToWeb {
  NSS *localFix = @"/mg/";
  NSS *p = $(@"atoz/%@.png", self.name);
  NSS *websave = LogAndReturn($(@"%@%@", localFix, p));
  [self saveAs:websave];
  return LogAndReturn($(@"http://mrgray.com/%@", p));
}

- (NSS*) asTempFile {

  NSS *p; [self saveAs:p = [AtoZ tempFilePathWithExtension:@"png"]];
  return NSLog(@"Saved temp image as: %@",p), p;
}

- (void) openInPreview { NSS *p = [self asTempFile];

  if ([AZFILEMANAGER fileExistsAtPath:p])
    [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open"
                             arguments:@[ @"-a", @"Preview", p ]];

//  		[AZWORKSPACE openFile:p withApplication:@"Preview"];
}

- (NSS*) htmlEncodedImg {

  return $(@"<img style='width:%0.f px; height:%0.f px;' "
           @"src='%@' />", self.size.width, self.size.height, self.dataURL);
}

- (NSS*) dataURL { return $(@"data:image/png;base64,%@",[self base64EncodingWithFileType:NSPNGFileType]); }

- _Void_ openQuantizedSwatch {
  [AZStopwatch named:@"openQuantizedSwatch"
               block:^{
    NSS *p = $(@"/tmp/quantization.%@.png", NSString.newUniqueIdentifier);
     [self.generateQuantizedSwatch saveAs:p];
     AZLOG(p);
     [AZWORKSPACE openFile:p withApplication:@"Preview"];
 }];
}

+ (void) openQuantizeChartFor:(NSA*) images {
  [AZStopwatch named:@"openQuantizedChart"
               block:^{

                   NSA *swatches = [images map:^id(id obj) {
                     return [obj generateQuantizedSwatch];
                   }];
                   NSSZ single = [(NSIMG*) swatches[0] size];
                   NSRect chartRect = [AZSizer rectForQuantity:swatches.count
                                                        ofSize:single
                                                   withColumns:4];
                   // AZMakeRectFromSize((NSSZ){ single.width*4,
                   // swatches.count/4 *single.height });
                   AZSizer *s =
                       [AZSizer forQuantity:swatches.count inRect:chartRect];
                   AZLOG(AZStringFromRect(chartRect));
                   NSIMG *locker = [[NSIMG alloc] initWithSize:chartRect.size];
                   //		[NSGraphicsContext state:^{
                   [locker lockFocus];
                   [s.rects eachWithIndex:^(id obj, NSI idx) {
                       [swatches[idx] drawAtPoint:[obj rectValue].origin
                                         fromRect:NSZeroRect
                                        operation:NSCompositeSourceOver
                                         fraction:1];
                   }];
                   [locker unlockFocus];
                   //		}];
                   NSS *p = $(@"/tmp/quantization.%@.png",
                              [NSString newUniqueIdentifier]);
                   [locker saveAs:p];
                   AZLOG(p);
                   [AZWORKSPACE openFile:p withApplication:@"Preview"];
               }];
}

+ _Pict_ desktopImage {
  return [NSImage.alloc
      initWithContentsOfURL:
          [[AZFILEMANAGER
                contentsOfDirectoryAtURL:
                    [NSURL fileURLWithPath:@"/Library/Desktop Pictures"
                               isDirectory:YES]
              includingPropertiesForKeys:nil
                                 options:0
                                   error:nil] randomElement]];
}

#ifdef RETARDO

/// ~ ❯❯❯ jp2a --colors -f file:///tmp/quantization.A3CB1F74-FD32-4A04-A785-B1117D27D6CB.jpg \
\
NNNNNNNNNOddddddddxXXXXXXXXXkoxxxOKXXXXXK00Okkdl:;;,,\
NNNNNNNNNOddddddddxXXXXXXXXXOxkkxk0KKXXXXK0koddc::;;,.\
NNNNNNNNNOddddddddxXXXXXXXXXOk00xxkO0KKXkl,..;clcc::;'.\
xxxxxxxxxdooooooood0KKKKKKKKOO0OxxOXXXKK'    ':ooollo;.\
         'cccccccclxxxxxxxxxxOOkxkKXXXKKc ..;.;dx0kk0;\
         'cccccccclxxxxxxxxxdxkl  ;lxOKX0 ,   ,kkkO0Kc.\
         ,llllllllldddddddddxkOk;. ...;o0o,..:O0OOkk0c.\
kkkkkkkkkkxxxxxxxxx.........:OOkOkl'   .cNXc..;0OOxdd.\
kkkkkkkkkkxxxxxxxxx.........;xkkkO0d  ;lkN0Kl.;OOkdol'\
kkkkkkkkkkxxxxxxxxx.........;oxkOO0O, ',',,;, .kkkdlo'.\
oooooooooONNNNNNNNNK00000000kodxxkkOx'klddld; .dddolc'.\
lllllllll0MMMMMMMMMMMMMMMMMMx.,..'..;,,.........,,,'.;,,;\
lllllllll0MMMMMMMMMMMMMMMMMMKxxxxdoxo;oddko;.,;.c,k:,Oddd\
lllllllll0MMMMMMMMMMMMMMMMMMK:,,;,;;,';,,;,..''.c:'',;,'\
\


#endif

- _Void_ drawFloatingRightInFrame:(NSRect)aFrame {
  NSRect r = aFrame;

  float max =
      (r.size.width > r.size.height ? r.size.height : r.size.width) * .8;
  self.size = r.size = NSMakeSize(max, max);

  [self compositeToPoint:(NSPoint) { aFrame.size.width - (max * 1.2), max * .1 }
                fromRect:NSZeroRect
               operation:NSCompositeSourceOver];
}

/// draws the passed image into the passed rect, centered and scaled appropriately.
    @note that this method doesn't know anything about the current focus, so the focus must be locked outside this method

- _Void_ drawCenteredinRect:(NSRect)inRect
                 operation:(NSCompositingOperation)op
                  fraction:(float)delta {
  NSRect srcRect = NSZeroRect;
  srcRect.size = [self size];

  // create a destination rect scaled to fit inside the frame
  NSRect drawnRect = srcRect;
  if (drawnRect.size.width > inRect.size.width) {
    drawnRect.size.height *= inRect.size.width / drawnRect.size.width;
    drawnRect.size.width = inRect.size.width;
  }

  if (drawnRect.size.height > inRect.size.height) {
    drawnRect.size.width *= inRect.size.height / drawnRect.size.height;
    drawnRect.size.height = inRect.size.height;
  }

  drawnRect.origin = inRect.origin;

  // center it in the frame
  drawnRect.origin.x += (inRect.size.width - drawnRect.size.width) / 2;
  drawnRect.origin.y += (inRect.size.height - drawnRect.size.height) / 2;

  [self drawInRect:drawnRect fromRect:srcRect operation:op fraction:delta];
}

- _Pict_ tintedImage {
  NSIMG *tintImage = [NSImage.alloc initWithSize:[self size]];

  [tintImage lockFocus];
  [[[NSC blackColor] colorWithAlphaComponent:1] set];
  [[NSBP bezierPathWithRect:(NSRect) {NSZeroPoint, [self size]}] fill];
  [tintImage unlockFocus];

  NSIMG *tintMaskImage = [NSImage.alloc initWithSize:[self size]];
  [tintMaskImage lockFocus];
  [self compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
  [tintImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceIn];
  [tintMaskImage unlockFocus];

  NSIMG *newImage = [NSImage.alloc initWithSize:[self size]];
  [newImage lockFocus];
  [self dissolveToPoint:NSZeroPoint fraction:0.6];
  [tintMaskImage compositeToPoint:NSZeroPoint
                        operation:NSCompositeDestinationAtop];
  [newImage unlockFocus];

  return newImage;
}
- _Pict_ tintedWithColor:(NSC*) tint {
  if (tint == nil)
    return self;
  NSIMG *tintedImage = [NSImage.alloc initWithSize:self.size];
  [tintedImage lockFocusBlock:^(NSImage *i) {

      CIFilter *colorGenerator =
          [CIFilter filterWithName:@"CIConstantColorGenerator"];
      CIColor *color = [CIColor.alloc initWithColor:tint];

      [colorGenerator setValue:color forKey:@"inputColor"];

      CIFilter *monochromeFilter =
          [CIFilter filterWithName:@"CIColorMonochrome"];
      CIImage *baseImage = [CIImage imageWithData:self.TIFFRepresentation];

      [monochromeFilter setValue:baseImage forKey:@"inputImage"];
      [monochromeFilter
          setValue:[CIColor colorWithRed:0.75 green:0.75 blue:0.75]
            forKey:@"inputColor"];
      [monochromeFilter setValue:@1.0f forKey:@"inputIntensity"];

      CIFilter *compositingFilter =
          [CIFilter filterWithName:@"CIMultiplyCompositing"];

      [compositingFilter setValue:[colorGenerator valueForKey:@"outputImage"]
                           forKey:@"inputImage"];
      [compositingFilter setValue:[monochromeFilter valueForKey:@"outputImage"]
                           forKey:@"inputBackgroundImage"];

      CIImage *outputImage = [compositingFilter valueForKey:@"outputImage"];

      if (outputImage)
        [outputImage drawAtPoint:NSZeroPoint
                        fromRect:AZRectFromSize(self.size)
                       operation:NSCompositeCopy
                        fraction:1.0];
  }]; //		[tintedImage unlockFocus];
  return tintedImage;
}

- _Pict_ filteredMonochromeEdge {
  NSSZ size = [self size];
  NSRect bounds = {NSZeroPoint, size};
  NSIMG *tintedImage = [NSImage.alloc initWithSize:size];
  CIImage *filterPreviewImage = [self toCIImage];
  [tintedImage lockFocus];
  CIFilter __unused *edgeWork =
      [CIFilter filterWithName:@"CIEdgeWork"
                 keysAndValues:kCIInputImageKey, filterPreviewImage,
                               @"inputRadius", @4.6f, nil];

  CIFilter *masktoalpha = [CIFilter filterWithName:@"CIMaskToAlpha"];
  [masktoalpha setValue:filterPreviewImage forKey:@"inputImage"];
  filterPreviewImage = [masktoalpha valueForKey:@"outputImage"];

  [filterPreviewImage drawAtPoint:NSZeroPoint
                         fromRect:bounds
                        operation:NSCompositeCopy
                         fraction:1.0];

  [tintedImage unlockFocus];

  return tintedImage;
  //	}
  //	else {
  //		return [self copy];
  //	}
}

- (NSBIR*) bitmap {

  // returns a 32-bit bitmap rep of the receiver, whatever its original format.
  // The image rep is not added to the image.
  NSSZ size = [self size];
  int rowBytes = ((int)(ceil(size.width)) * 4 + 0x0000000F) &
                 ~0x0000000F; // 16-byte aligned
  int bps = 8, spp = 4, bpp = bps * spp;
  // NOTE: These settings affect how pixels are converted to NSColors
  NSBIR *imageRep =
      [NSBIR.alloc initWithBitmapDataPlanes:nil
                                            pixelsWide:size.width
                                            pixelsHigh:size.height
                                         bitsPerSample:bps
                                       samplesPerPixel:spp
                                              hasAlpha:YES
                                              isPlanar:NO
                                        colorSpaceName:NSCalibratedRGBColorSpace
                                          bitmapFormat:NSAlphaFirstBitmapFormat
                                           bytesPerRow:rowBytes
                                          bitsPerPixel:bpp];
  if (!imageRep)
    return nil;

  [NSGC swapToBitmapContext:imageRep do:^{
    [self drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
  }];

  return imageRep;
}

- (NSBIR*) bitmapBy:(CGF)x y:(CGF)y {

  // creating the rectangle that defines the bounds of our bitmap image
  NSRect offscreenRect = NSMakeRect(0.0, 0.0, x, y);
  NSBIR *offscreenRep = nil;
  // creating the bitmap image
  offscreenRep =
      [NSBIR.alloc initWithBitmapDataPlanes:nil
                                 pixelsWide:offscreenRect.size.width
                                 pixelsHigh:offscreenRect.size.height
                              bitsPerSample:8
                            samplesPerPixel:4
                                   hasAlpha:YES
                                   isPlanar:NO
                             colorSpaceName:NSCalibratedRGBColorSpace
                               bitmapFormat:0
                                bytesPerRow:(4 * offscreenRect.size.width)
                               bitsPerPixel:32];
  [NSGC state:^{
      // setting the current context to a bitmap context
      [NSGC setCurrentContext:
                [NSGC graphicsContextWithBitmapImageRep:offscreenRep]];
      [self drawInRect:offscreenRect];
  }];
  return offscreenRep;

}

- (CGImageRef)cgImage {
  NSBIR *bm = [self bitmap]; // data provider will release this
  int rowBytes, width, height;

  rowBytes = [bm bytesPerRow];
  width = [bm pixelsWide];
  height = [bm pixelsHigh];

  CGDataProviderRef provider =
      CGDataProviderCreateWithData((__bridge void*) bm, [bm bitmapData],
                                   rowBytes * height, BitmapReleaseCallback);
  CGColorSpaceRef colorspace =
      CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
  CGBitmapInfo bitsInfo = kCGImageAlphaLast;

  //	CGImageRef img
  return CGImageCreate(width, height, 8, 32, rowBytes, colorspace, bitsInfo,
                       provider, NULL, NO, kCGRenderingIntentDefault);

  //	CGDataProviderRelease( provider );
  //	CGColorSpaceRelease( colorspace );
  //
  //	return img;
}
*/
/*!
 @brief	Rotates an image around its center by a given
 angle in degrees and returns the new image.

 @details  The width and height of the returned image are,
 respectively, the height and width of the receiver.

 I have not yet tested this with a non-square image.	*/
/*
- _Pict_ imageRotatedByDegrees:(CGF)degrees {
  NSSZ rotatedSize = NSMakeSize(self.size.height, self.size.width);
  NSIMG *rotatedImage = [NSImage.alloc initWithSize:rotatedSize];

  NSAffineTransform *transform = [NSAffineTransform transform];

  // In order to avoid clipping the image, translate
  // the coordinate system to its center
  [transform translateXBy:+self.size.width / 2 yBy:+self.size.height / 2];
  // then rotate
  [transform rotateByDegrees:degrees];
  // Then translate the origin system back to
  // the bottom left
  [transform translateXBy:-rotatedSize.width / 2 yBy:-rotatedSize.height / 2];

  [rotatedImage lockFocus];
  [transform concat];
  [self drawAtPoint:NSMakePoint(0, 0)
           fromRect:NSZeroRect
          operation:NSCompositeCopy
           fraction:1.0];
  [rotatedImage unlockFocus];

  return rotatedImage;
}

- _Pict_ imageByScalingProportionallyToSize:(NSSZ)targetSize
                                   background:(NSC*) bk {
  NSIMG *sourceImage = self;
  NSIMG *newImage = nil;

  if ([sourceImage isValid]) {
    NSSZ imageSize = [self sizeLargestRepresentation];

    if (imageSize.width <= targetSize.width &&
        imageSize.height <= targetSize.height) {
      [self setSize:imageSize];
      return self;
    }

    float scaleFactor = 0.0;
    float scaledWidth = targetSize.width;
    float scaledHeight = targetSize.height;

    float widthFactor = targetSize.width / imageSize.width;
    float heightFactor = targetSize.height / imageSize.height;

    if (widthFactor < heightFactor)
      scaleFactor = widthFactor;
    else
      scaleFactor = heightFactor;

    scaledWidth = imageSize.width * scaleFactor;
    scaledHeight = imageSize.height * scaleFactor;

    newImage =
        [NSImage.alloc initWithSize:NSMakeSize(scaledWidth, scaledHeight)];

    NSRect thumbnailRect;
    thumbnailRect.origin = NSMakePoint(0, 0);
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [newImage lockFocus];
    [bk drawSwatchInRect:thumbnailRect];

    [AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationHigh];

    [sourceImage drawInRect:thumbnailRect
                   fromRect:NSZeroRect
                  operation:NSCompositeSourceOver
                   fraction:1.0];

    [newImage unlockFocus];
  }

  return newImage;
}
*/
/*- (NSIMG*)imageByScalingProportionallyToSize:(NSSZ)targetSize
{
  NSIMG* sourceImage = self;
  NSIMG* newImage = nil;

  if ([sourceImage isValid])
  {
    NSSZ imageSize = [self sizeLargestRepresentation];

    if (imageSize.width  <= targetSize.width &&
      imageSize.height <= targetSize.height)
    {
      [self setSize:imageSize];
      return self;
    }

    float scaleFactor  = 0.0;
    float scaledWidth  = targetSize.width;
    float scaledHeight = targetSize.height;

    float widthFactor  = targetSize.width / imageSize.width;
    float heightFactor = targetSize.height / imageSize.height;

    if ( widthFactor < heightFactor )
      scaleFactor = widthFactor;
    else
      scaleFactor = heightFactor;

    scaledWidth  = imageSize.width  * scaleFactor;
    scaledHeight = imageSize.height * scaleFactor;

    newImage = [NSImage.alloc initWithSize:NSMakeSize(scaledWidth,
scaledHeight)];

    [newImage lockFocus];
    [AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationHigh];

    NSRect thumbnailRect;
    thumbnailRect.origin	  = NSMakePoint(0,0);
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect: thumbnailRect
             fromRect: NSZeroRect
            operation: NSCompositeSourceOver
             fraction: 1.0];

    [newImage unlockFocus];
  }

  return newImage;
}*/
/*
- _Void_ drawInRect:(NSRect)dstRect
         operation:(NSCompositingOperation)op
          fraction:(float)delta
            method:(AGImageResizingMethod)resizeMethod {
  float sourceWidth = [self sizeLargestRepresentation].width;
  float sourceHeight = [self sizeLargestRepresentation].height;
  float targetWidth = dstRect.size.width;
  float targetHeight = dstRect.size.height;
  BOOL cropping = !(resizeMethod == AGImageResizeScale);

  // Calculate aspect ratios
  float sourceRatio = sourceWidth / sourceHeight;
  float targetRatio = targetWidth / targetHeight;

  // Determine what side of the source image to use for proportional scaling
  BOOL scaleWidth = (sourceRatio <= targetRatio);
  // Deal with the case of just scaling proportionally to fit, without cropping
  scaleWidth = (cropping) ? scaleWidth : !scaleWidth;

  // Proportionally scale source image
  float scalingFactor, scaledWidth, scaledHeight;
  if (scaleWidth) {
    scalingFactor = 1.0 / sourceRatio;
    scaledWidth = targetWidth;
    scaledHeight = round(targetWidth * scalingFactor);
  } else {
    scalingFactor = sourceRatio;
    scaledWidth = round(targetHeight * scalingFactor);
    scaledHeight = targetHeight;
  }
  float scaleFactor = scaledHeight / sourceHeight;

  // Calculate compositing rectangles
  NSRect sourceRect;
  if (cropping) {
    float destX = 0, destY = 0;
    if (resizeMethod == AGImageResizeCrop) {
      // Crop center
      destX = round((scaledWidth - targetWidth) / 2.0);
      destY = round((scaledHeight - targetHeight) / 2.0);
    } else if (resizeMethod == AGImageResizeCropStart) {
      // Crop top or left (prefer top)
      if (scaleWidth) {
        // Crop top
        destX = round((scaledWidth - targetWidth) / 2.0);
        destY = round(scaledHeight - targetHeight);
      } else {
        // Crop left
        destX = 0.0;
        destY = round((scaledHeight - targetHeight) / 2.0);
      }
    } else if (resizeMethod == AGImageResizeCropEnd) {
      // Crop bottom or right
      if (scaleWidth) {
        // Crop bottom
        destX = 0.0;
        destY = 0.0;
      } else {
        // Crop right
        destX = round(scaledWidth - targetWidth);
        destY = round((scaledHeight - targetHeight) / 2.0);
      }
    }
    sourceRect =
        NSMakeRect(destX / scaleFactor, destY / scaleFactor,
                   targetWidth / scaleFactor, targetHeight / scaleFactor);
  } else {
    sourceRect = NSMakeRect(0, 0, sourceWidth, sourceHeight);
    dstRect.origin.x += (targetWidth - scaledWidth) / 2.0;
    dstRect.origin.y += (targetHeight - scaledHeight) / 2.0;
    dstRect.size.width = scaledWidth;
    dstRect.size.height = scaledHeight;
  }

  [self drawInRect:dstRect fromRect:sourceRect operation:op fraction:delta];
}

- _Pict_ imageToFitSize:(NSSZ)size
                   method:(AGImageResizingMethod)resizeMethod {
  NSIMG *result = [NSImage.alloc initWithSize:size];

  // Composite image appropriately
  [result lockFocus];
  //	[AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationHigh];
  [self drawInRect:NSMakeRect(0, 0, size.width, size.height)
         operation:NSCompositeSourceOver
          fraction:1.0
            method:resizeMethod];
  [result unlockFocus];

  return result;
}

- _Pict_ imageCroppedToFitSize:(NSSZ)size {
  return [self imageToFitSize:size method:AGImageResizeCrop];
}

- _Pict_ scaledToMax:(CGF)f {
  return [self imageScaledToFitSize:AZSizeFromDim(f)];
}

- _Pict_ imageScaledToFitSize:(NSSZ)size {

  if (NSEqualSizes(self.size, NSZeroSize) || NSEqualSizes(self.size, size)) return self;

  NSRect corrected = AZFitRectInRect(self.frame, AZRectFromSize(size),NO);

  return [self.class imageWithSize:size
                   drawnUsingBlock:^{
                       [self drawInRect:corrected
                               fromRect:NSZeroRect
                              operation:NSCompositeSourceOver
                               fraction:1];
                   }];
}
// NSIMG *scaled = [NSIMG.alloc initWithSize:size]; [scaled lockFocus];	[self
// setScalesWhenResized:YES];
//	[self setSize: size]; [scaled unlockFocus]; scaled.name  = self.name  ?:
//@"scaled image"; return scaled;

- (NSIR*) smallestRepresentation {
  int area = 0;
  NSIR *smallest = nil;

  for (NSIR *rep in [self representations]) {
    int a = [rep pixelsWide] * [rep pixelsHigh];
    if (a < area) {
      area = a;
      smallest = rep;
    }
  }
  return smallest;
}
- (NSSZ)sizeSmallestRepresentation {
  NSIR *rep = [self smallestRepresentation];
  if (rep)
    return NSMakeSize([rep pixelsWide], [rep pixelsHigh]);
  else
    return [self size];
}
- (NSIR*) largestRepresentation {
  int area = 0;
  NSIR *largest = nil;

  for (NSIR *rep in [self representations]) {
    int a = [rep pixelsWide] * [rep pixelsHigh];
    if (a > area) {
      area = a;
      largest = rep;
    }
  }
  return largest;
}

- (NSSZ)sizeLargestRepresentation {
  NSIR *rep = [self largestRepresentation];
  if (rep)
    return NSMakeSize([rep pixelsWide], [rep pixelsHigh]);
  else
    return [self size];
}

- _Pict_ rotated:(int)angle
{
  if (angle != 90 && angle != 270)
    return self;

  NSIMG *existingImage = self;
  NSSZ existingSize;

  /// Get the size of the original image in its raw bitmap format.  \
      The bestRepresentationForDevice: nil tells the NSImage to just \
      give us the raw image instead of it's wacky DPI-translated version.
  //	 NSBIR = [existingImage bitmap];

  existingSize.width =
      [[existingImage bestRepresentationForRect:AZMakeRectFromSize(existingSize)
                                        context:AZGRAPHICSCTX
                                          hints:nil] pixelsWide];
  existingSize.height =
      [[existingImage bestRepresentationForRect:AZMakeRectFromSize(existingSize)
                                        context:AZGRAPHICSCTX
                                          hints:nil] pixelsHigh];
  NSSZ newSize = NSMakeSize(existingSize.height, existingSize.width);
  NSIMG *rotatedImage = [NSImage.alloc initWithSize:newSize];
  [rotatedImage lockFocus];

  // Apply the following transformations:\
    - bring the rotation point to the centre of the image instead of the default lower, left corner (0,0). \
   - rotate it by 90 degrees, either clock or counter clockwise. \
   - re-translate the rotated image back down to the lower left corner so that it appears in the right place.

  NSAffineTransform *rotateTF = [NSAffineTransform transform];
  NSP centerPoint = NSMakePoint(newSize.width / 2, newSize.height / 2);

  [rotateTF translateXBy:centerPoint.x yBy:centerPoint.y];
  [rotateTF rotateByDegrees:angle];
  [rotateTF translateXBy:-centerPoint.y yBy:-centerPoint.x];
  [rotateTF concat];

  /// We have to get the image representation to do its drawing directly, \
      because otherwise the stupid NSImage DPI thingie bites us in the butt again.\

  NSRect r1 = NSMakeRect(0, 0, newSize.height, newSize.width);
  [existingImage bestRepresentationForRect:r1
                                   context:nil
                                     hints:nil]; // drawInRect: r1];

  [rotatedImage unlockFocus];

  return rotatedImage;
}

- (NSRect)proportionalRectForTargetRect:(NSRect)targetRect {
  // if the sizes are the same, we're already done.
  if (NSEqualSizes(self.size, targetRect.size))
    return targetRect;
  NSSZ imageSize = self.size;
  CGF soureWidth = imageSize.width;
  CGF sourceHeight = imageSize.height;
  // figure out the difference in size for each side, and use
  // the larger adjustment for both edges (maintains aspect ratio).
  CGF widthAdjust = targetRect.size.width / soureWidth;
  CGF heightAdjust = targetRect.size.height / sourceHeight;
  CGF scaleFactor = 1.0;
  if (widthAdjust < heightAdjust)
    scaleFactor = widthAdjust;
  else
    scaleFactor = heightAdjust;
  // resize both edges by the same amount.
  CGF finalWidth = soureWidth * scaleFactor;
  CGF finalHeight = sourceHeight * scaleFactor;
  NSSZ finalSize = NSMakeSize(finalWidth, finalHeight);
  // actual rect we'll use for the image.
  NSRect finalRect;
  finalRect.size = finalSize;
  // use the same base origin as the target rect, but adjust for the resized
  // image.
  finalRect.origin = targetRect.origin;
  finalRect.origin.x += (targetRect.size.width - finalWidth) * 0.5;
  finalRect.origin.y += (targetRect.size.height - finalHeight) * 0.5;
  // return exact coordinates for a sharp image.
  return NSIntegralRect(finalRect);
}

- (CIImage*) toCIImage {
  NSBIR *bitmapimagerep = [self bitmap];
  CIImage *im = [CIImage.alloc initWithBitmapImageRep:bitmapimagerep];
  return im;
}

- _Pict_ imageByRemovingTransparentAreasWithFinalRect:(NSRect*) outBox {
  NSRect oldRect = NSZeroRect;
  oldRect.size = [self size];
  *outBox = oldRect;

  [self lockFocus];

  // Cut off any empty rows at the bottom:
  for (int y = 0; y < oldRect.size.height; y++) {
    for (int x = 0; x < oldRect.size.width; x++) {
      NSC *theCol = NSReadPixel(NSMakePoint(x, y));
      if ([theCol alphaComponent] > 0.01)
        goto bottomDone;
    }

    outBox->origin.y += 1;
    outBox->size.height -= 1;
  }

bottomDone:
  // Cut off any empty rows at the top:
  for (int y = oldRect.size.height - 1; y >= 0; y--) {
    for (int x = 0; x < oldRect.size.width; x++) {
      NSC *theCol = NSReadPixel(NSMakePoint(x, y));
      if ([theCol alphaComponent] > 0.01)
        goto topDone;
    }

    outBox->size.height -= 1;
  }

topDone:
  // Cut off any empty rows at the left:
  for (int x = 0; x < oldRect.size.width; x++) {
    for (int y = 0; y < oldRect.size.height; y++) {
      NSC *theCol = NSReadPixel(NSMakePoint(x, y));
      if ([theCol alphaComponent] > 0.01)
        goto leftDone;
    }

    outBox->origin.x += 1;
    outBox->size.width -= 1;
  }

leftDone:
  // Cut off any empty rows at the right:
  for (int x = oldRect.size.width - 1; x >= 0; x--) {
    for (int y = 0; y < oldRect.size.height; y++) {
      NSC *theCol = NSReadPixel(NSMakePoint(x, y));
      if ([theCol alphaComponent] > 0.01)
        goto rightDone;
    }

    outBox->size.width -= 1;
  }

rightDone:
  [self unlockFocus];

  // Now create new image with that subsection:
  NSIMG *returnImg = [NSImage.alloc initWithSize:outBox->size];
  NSRect destBox = *outBox;
  destBox.origin = NSZeroPoint;

  [returnImg lockFocus];
  [self drawInRect:destBox
          fromRect:*outBox
         operation:NSCompositeCopy
          fraction:1.0];
  [[NSC redColor] set];
  [NSBP strokeRect:destBox];
  [returnImg unlockFocus];

  return returnImg;
}

+ _Pict_ fromSVG:(NSS*) documentName withAlpha:(BOOL)hasAlpha {

  SVGDocument *document = [SVGDocument documentNamed:documentName];
  NSBIR *rep =
      [NSBIR.alloc initWithBitmapDataPlanes:NULL
                                            pixelsWide:document.width
                                            pixelsHigh:document.height
                                         bitsPerSample:8
                                       samplesPerPixel:3
                                              hasAlpha:hasAlpha
                                              isPlanar:NO
                                        colorSpaceName:NSCalibratedRGBColorSpace
                                           bytesPerRow:4 * document.width
                                          bitsPerPixel:32];

  CGContextRef context =
      [[NSGraphicsContext graphicsContextWithBitmapImageRep:rep] graphicsPort];
  //	if (!hasAlpha)
  CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white background
  CGContextFillRect(context,
                    CGRectMake(0.0f, 0.0f, document.width, document.height));
  CGContextScaleCTM(context, 1.0f, -1.0f); // flip
  CGContextTranslateCTM(context, 0.0f, -document.height);
  [[document layerTree] renderInContext:context];
  CGImageRef image = CGBitmapContextCreateImage(context);
  NSBIR *rendering = [NSBIR.alloc initWithCGImage:image];
  CGImageRelease(image);
  NSIMG *rendered = [NSImage.alloc initWithSize:[rendering size]];
  [rendered setScalesWhenResized:YES];
  [rendered addRepresentation:rendering];
  return rendered;
}

+ (NSA*) systemImages {
  static NSA *_systemImages = nil;
  return _systemImages = _systemImages // This will only be true the first time
                                       // the method is called...
                             ?: [@[
                                  NSImageNameQuickLookTemplate,
                                  NSImageNameBluetoothTemplate,
                                  NSImageNameIChatTheaterTemplate,
                                  NSImageNameSlideshowTemplate,
                                  NSImageNameActionTemplate,
                                  NSImageNameSmartBadgeTemplate,
                                  NSImageNameIconViewTemplate,
                                  NSImageNameListViewTemplate,
                                  NSImageNameColumnViewTemplate,
                                  NSImageNameFlowViewTemplate,
                                  NSImageNamePathTemplate,
                                  NSImageNameInvalidDataFreestandingTemplate,
                                  NSImageNameLockLockedTemplate,
                                  NSImageNameLockUnlockedTemplate,
                                  NSImageNameGoRightTemplate,
                                  NSImageNameGoLeftTemplate,
                                  NSImageNameRightFacingTriangleTemplate,
                                  NSImageNameLeftFacingTriangleTemplate,
                                  NSImageNameAddTemplate,
                                  NSImageNameRemoveTemplate,
                                  NSImageNameRevealFreestandingTemplate,
                                  NSImageNameFollowLinkFreestandingTemplate,
                                  NSImageNameEnterFullScreenTemplate,
                                  NSImageNameExitFullScreenTemplate,
                                  NSImageNameStopProgressTemplate,
                                  NSImageNameStopProgressFreestandingTemplate,
                                  NSImageNameRefreshTemplate,
                                  NSImageNameRefreshFreestandingTemplate,
                                  NSImageNameBonjour,
                                  NSImageNameComputer,
                                  NSImageNameFolderBurnable,
                                  NSImageNameFolderSmart,
                                  NSImageNameFolder,
                                  NSImageNameNetwork,
                                  NSImageNameDotMac,
                                  NSImageNameMobileMe,
                                  NSImageNameMultipleDocuments,
                                  NSImageNameUserAccounts,
                                  NSImageNamePreferencesGeneral,
                                  NSImageNameAdvanced,
                                  NSImageNameInfo,
                                  NSImageNameFontPanel,
                                  NSImageNameColorPanel,
                                  NSImageNameUser,
                                  NSImageNameUserGroup,
                                  NSImageNameEveryone,
                                  NSImageNameUserGuest,
                                  NSImageNameMenuOnStateTemplate,
                                  NSImageNameMenuMixedStateTemplate,
                                  NSImageNameApplicationIcon,
                                  NSImageNameTrashEmpty,
                                  NSImageNameTrashFull,
                                  NSImageNameHomeTemplate,
                                  NSImageNameBookmarksTemplate,
                                  NSImageNameCaution,
                                  NSImageNameStatusAvailable,
                                  NSImageNameStatusPartiallyAvailable,
                                  NSImageNameStatusUnavailable,
                                  NSImageNameStatusNone,
                                  @"NSDefaultApplicationIcon",
                                  @"NSDeadKeyMenuImage",
                                  @"NSGrayResizeCorner",
                                  @"NSHelpCursor",
                                  @"NSMysteryDocument",
                                  @"NSMultipleFiles",
                                  @"NSOpacitySlider",
                                  @"NSUtilityInactivePattern",
                                  @"NSUtilityKeyPattern",
                                  @"SpellingDot",
                                  @"NSTriangleNormalRight",
                                  @"NSTrianglePressedRight",
                                  @"NSTriangleNormalDown",
                                  @"NSTrianglePressedDown"
                                ]
                                    map:^id(id object) {
                                      return [NSIMG imageNamed:object] ?: nil;
                                    }];
}

- _Pict_ addReflection:(CGF)percentage {
  NSAssert(percentage > 0 && percentage <= 1.0,
           @"Please use percentage between 0 and 1");
  CGRect offscreenFrame =
      CGRectMake(0, 0, self.size.width, self.size.height * (1.0 + percentage));
  NSBIR *offscreen = [NSBIR.alloc
      initWithBitmapDataPlanes:NULL
                    pixelsWide:offscreenFrame.size.width
                    pixelsHigh:offscreenFrame.size.height
                 bitsPerSample:8
               samplesPerPixel:4
                      hasAlpha:YES
                      isPlanar:NO
                colorSpaceName:NSDeviceRGBColorSpace
                  bitmapFormat:0
                   bytesPerRow:offscreenFrame.size.width * 4
                  bitsPerPixel:32];

  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext
      setCurrentContext:[NSGraphicsContext
                            graphicsContextWithBitmapImageRep:offscreen]];

  [[NSC clearColor] set];
  NSRectFill(offscreenFrame);

  NSGradient *fade = [NSGradient.alloc
      initWithStartingColor:[NSC colorWithCalibratedWhite:1.0 alpha:0.2]
                endingColor:[NSC clearColor]];
  CGRect fadeFrame = CGRectMake(0, 0, self.size.width,
                                offscreen.size.height - self.size.height);
  [fade drawInRect:fadeFrame angle:270.0];

  NSAffineTransform *transform = [NSAffineTransform transform];
  [transform translateXBy:0.0 yBy:fadeFrame.size.height];
  [transform scaleXBy:1.0 yBy:-1.0];
  [transform concat];

  // Draw the image over the gradient -> becomes reflection
  [self drawAtPoint:NSMakePoint(0, 0)
           fromRect:CGRectMake(0, 0, self.size.width, self.size.height)
          operation:NSCompositeSourceIn
           fraction:1.0];

  [transform invert];
  [transform concat];

  // Draw the original image
  [self
      drawAtPoint:CGPointMake(0, offscreenFrame.size.height - self.size.height)
         fromRect:NSZeroRect
        operation:NSCompositeSourceOver
         fraction:1.0];

  [NSGraphicsContext restoreGraphicsState];

  NSIMG *imageWithReflection = [NSImage.alloc initWithSize:offscreenFrame.size];
  [imageWithReflection addRepresentation:offscreen];

  return imageWithReflection;
}

- _Pict_ etched {
  NSIMG *etched = [NSIMG.alloc initWithSize:self.size];
  [etched lockFocus];
  [self drawEtchedInRect:AZRectFromSize(self.size)];
  [etched unlockFocus];
  return etched;
}

- _Pict_ alpha:(CGF)fraction {
  NSIMG *alpha = [NSIMG.alloc initWithSize:self.size];
  [alpha lockFocus];
  [self drawInRect:AZRectFromSize(self.size) fraction:fraction];
  [alpha unlockFocus];
  return alpha;
}

- _Void_ drawEtchedInRect:(NSRect)rect {
  NSSize size = rect.size;
  CGFloat dropShadowOffsetY = -size.width / 64;    //<= 64.0 ? -1.0 : -2.0;
  CGFloat innerShadowBlurRadius = size.width / 32; //<= 3 2.0 ? 1.0 : 4.0;

  CGContextRef c = [NSGraphicsContext.currentContext graphicsPort];

  // save the current graphics state
  CGContextSaveGState(c);

  // Create mask image:
  NSRect maskRect = rect;
  CGImageRef maskImage =
      [self CGImageForProposedRect:&maskRect context:AZGRAPHICSCTX hints:nil];

  // Draw image and white drop shadow:
  CGContextSetShadowWithColor(c, CGSizeMake(0, dropShadowOffsetY), 0,
                              CGColorGetConstantColor(kCGColorWhite));
  [self drawInRect:maskRect
          fromRect:NSMakeRect(0, 0, self.size.width, self.size.height)
         operation:NSCompositeSourceOver
          fraction:1.0];

  // Clip drawing to mask:
  CGContextClipToMask(c, NSRectToCGRect(maskRect), maskImage);

  // Draw gradient:
  NSGradient *gradient = [NSG.alloc initWithStartingColor:GRAY5 endingColor:GRAY2];
  [gradient drawInRect:maskRect angle:90.0];
  CGContextSetShadowWithColor(c, CGSizeMake(0, -1), innerShadowBlurRadius,
                              CGColorGetConstantColor(kCGColorBlack));

  // Draw inner shadow with inverted mask:
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef maskContext = CGBitmapContextCreate(
      NULL, CGImageGetWidth(maskImage), CGImageGetHeight(maskImage), 8,
      CGImageGetWidth(maskImage) * 4, colorSpace,
      kCGImageAlphaPremultipliedLast);
  CGColorSpaceRelease(colorSpace);
  CGContextSetBlendMode(maskContext, kCGBlendModeXOR);
  CGContextDrawImage(maskContext, maskRect, maskImage);
  CGContextSetRGBFillColor(maskContext, 1.0, 1.0, 1.0, 1.0);
  CGContextFillRect(maskContext, maskRect);
  CGImageRef invertedMaskImage = CGBitmapContextCreateImage(maskContext);
  CGContextDrawImage(c, maskRect, invertedMaskImage);
  CGImageRelease(invertedMaskImage);
  CGContextRelease(maskContext);

  // restore the graphics state
  CGContextRestoreGState(c);
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh) {
  CGContextRef myContext = NULL;
  CGColorSpaceRef myColorSpace;
  void *bitmapData;
  int bitmapByteCount;
  int bitmapBytesPerRow;

  bitmapBytesPerRow = (pixelsWide * 4);
  bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);

  myColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);

  bitmapData = malloc(bitmapByteCount);

  if (bitmapData == NULL) {
    fprintf(stderr, "Memory not Allocated");
    return NULL;
  }

  myContext =
      CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8,
                            bitmapBytesPerRow, myColorSpace, kCGImageAlphaNone);
  if (myContext == NULL) {
    free(bitmapData);
    fprintf(stderr, "myContext not created");
    return NULL;
  }

  CGColorSpaceRelease(myColorSpace);

  return myContext;
}

- _Pict_ maskedWithColor:(NSC*) color {
  NSIMG *image = self;
  CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
  CGContextRef c = MyCreateBitmapContext(image.size.width, image.size.height);
  [image drawInRect:rect
           fromRect:NSZeroRect
          operation:NSCompositeSourceOver
           fraction:1.0];
  CGContextSetFillColorWithColor(c, [color CGColor]);
  CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
  CGContextFillRect(c, rect);
  CGImageRef ciImage = CGBitmapContextCreateImage(c);
  CGContextDrawImage(c, rect, ciImage);
  NSIMG *newImage = [NSImage.alloc initWithCGImage:ciImage size:image.size];
  CGContextRelease(c);
  CGImageRelease(ciImage);
  return newImage;
}

#pragma mark CGImage to NSImage and vice versa

+ _Pict_ imageFromCGImageRef:(CGImageRef)image {
  // #if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
  // This is 10.6 only
  NSIMG *newImage = [NSImage.alloc initWithCGImage:image size:NSZeroSize];

  return newImage;
}

- (CGImageRef)cgImageRef {
  NSData *imageData = [self TIFFRepresentation];
  CGImageRef imageRef;

  if (imageData) {
    // #if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5  THIS MEANS
    // 10.6
    imageRef = [self CGImageForProposedRect:NULL context:nil hints:nil]; // 10.6
    return imageRef;
  }

  // original approach
  // if (imageData) {

  // CGImageSourceRef imageSource =
  // CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
  // imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
  // CFRelease(imageSource);

  // [(id)aCGImageRef autorelease];
  // Be carefull when you mix CFType memory management, and obj-c memory
  // management.
  // It works well when you do not use GC, but may become problematic if you do
  // not take special care with GC code.
  // If I'm not wrong, it should be something like this:
  // [NSMakeCollectable(aCGImageRef) autorelease]

  // bad: memory leak
  // return imageRef;

  // good: no memory leak
  //[NSMakeCollectable(imageRef) autorelease];
  // return imageRef;
  //}

  return NULL;
}


#pragma mark Quicklook Preview

+ _Pict_ imageWithPreviewOfFileAtPath:(NSS*) path
                                 ofSize:(NSSZ)size
                                 asIcon:(BOOL)icon {
  NSURL *fileURL = [NSURL fileURLWithPath:path];
  if (!path || !fileURL)
    return nil;
  NSDictionary *dict = @{(NSS*) kQLThumbnailOptionIconModeKey : @(icon)};
  CGImageRef ref = QLThumbnailImageCreate(
      kCFAllocatorDefault, (__bridge CFURLRef)fileURL,
      CGSizeMake(size.width, size.height), (__bridge CFDictionaryRef)dict);

  if (ref != NULL) {
    // Take advantage of NSBIR's -initWithCGImage: initializer, new
    // in Leopard,
    // which is a lot more efficient than copying pixel data into a brand new
    // NSImage.
    // Thanks to Troy Stephens @ Apple for pointing this new method out to me.
    NSBIR *bitmapImageRep =
        [NSBIR.alloc initWithCGImage:ref];
    NSIMG *newImage = nil;
    if (bitmapImageRep) {
      newImage = [NSImage.alloc initWithSize:[bitmapImageRep size]];
      [newImage addRepresentation:bitmapImageRep];
      if (newImage) {
        CFRelease(ref);
        return newImage;
      }
    }
    CFRelease(ref);
  } else {
    // If we couldn't get a Quick Look preview, fall back on the file's Finder
    // icon.
    NSIMG *icon;
    if ((icon  = [[NSWorkspace sharedWorkspace] iconForFile:path])) [icon setSize:size];
    return icon;
  }

  return nil;
}

//  NSImage+QuickLook.m
//  QuickLookTest
//  Created by Matt Gemmell on 29/10/2007.
//@implementation NSImage (QuickLook)
//
//+ (NSImage*) imageWithPreviewOfFileAtPath:(NSString*) path
//                                   ofSize:(NSSize)size
//                                   asIcon:(BOOL)asIcon {
//
//  NSURL *fileURL = [NSURL fileURLWithPath:path];
//  if (!path || !fileURL)
//    return nil;
//  NSDictionary *dict = @{(NSS*) kQLThumbnailOptionIconModeKey : @(asIcon)};
//  CGImageRef ref = QLThumbnailImageCreate(
//      kCFAllocatorDefault, (__bridge CFURLRef)fileURL,
//      CGSizeMake(size.width, size.height), (__bridge CFDictionaryRef)dict);
//  if (ref != NULL) {
//    // Take advantage of NSBIR's -initWithCGImage: initializer, new
//    // in Leopard,
//    // which is a lot more efficient than copying pixel data into a brand new
//    // NSImage.
//    // Thanks to Troy Stephens @ Apple for pointing this new method out to me.
//    NSBIR *bitmapImageRep =
//        [NSBIR.alloc initWithCGImage:ref];
//    NSImage *newImage = nil;
//    if (bitmapImageRep) {
//      newImage = [NSImage.alloc initWithSize:[bitmapImageRep size]];
//      [newImage addRepresentation:bitmapImageRep];
//      //            [bitmapImageRep release];
//      if (newImage)
//        return newImage;
//    }
//    CFRelease(ref);
//  } else {
//    // If we couldn't get a Quick Look preview, fall back on the file's Finder
//    // icon.
//    NSImage *icon = [NSWorkspace.sharedWorkspace iconForFile:path];
//    if (icon)
//      [icon setSize:size];
//    return icon;
//  }
//  return nil;
//}
//
//@end

#pragma mark Resizing Image

+ _Pict_ resizedImage:(NSIMG*) sourceImage
                newSize:(NSSZ)size
        lockAspectRatio:(BOOL)lock // pass YES if you want to lock aspect ratio
  lockAspectRatioByWidth:(BOOL)flag // pass YES to lock aspect ratio by width or passing NO to lock by height
{

  NSSZ oldSize = [sourceImage size];
  CGF ratio = oldSize.width / oldSize.height;
  // if new size is equal to or larger than the original image, we won't resize it
  if (size.height >= oldSize.height || size.width >= oldSize.width)
    return sourceImage;

  if (lock) {
    if (flag) size.height = size.width / ratio;
    else      size.width = size.height * ratio;
  }

  NSIMG *resizedImage = [NSImage.alloc initWithSize:size];
  [AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationHigh];
  [resizedImage lockFocus];

  [sourceImage drawInRect:NSMakeRect(0.0, 0.0, size.width, size.height)
                 fromRect:NSMakeRect(0.0, 0.0, [sourceImage size].width,
                                     [sourceImage size].height)
                operation:NSCompositeSourceOver
                 fraction:1.0];

  [resizedImage unlockFocus];

  return resizedImage;
}

#pragma mark Cropping Image

- _Pict_ croppedImage:(CGRect)bounds {
  [self lockFocus];
  CGImageRef imageRef = CGImageCreateWithImageInRect([self cgImageRef], bounds);
  NSIMG *croppedImage = [NSImage imageFromCGImageRef:imageRef];
  CGImageRelease(imageRef);
  [self unlockFocus];
  return croppedImage;
}

#pragma mark Save Image

- (BOOL)saveImage:(NSS*) path
         fileName:(NSS*) name
         fileType:(NSBitmapImageFileType)type {
  // deal with the file type and assign the filename suffix by the file type
  NSString *suffix;
  NSString *filename = [NSString stringWithString:name];
  ;
  switch (type) {
  case NSTIFFFileType:
    suffix = @".tiff";
    if (![name hasSuffix:suffix])
      filename = [name stringByAppendingString:suffix];
    break;
  case NSBMPFileType:
    suffix = @".bmp";
    if (![name hasSuffix:suffix])
      filename = [name stringByAppendingString:suffix];
    break;
  case NSGIFFileType:
    suffix = @".gif";
    if (![name hasSuffix:suffix])
      filename = [name stringByAppendingString:suffix];
    break;
  case NSJPEGFileType:
    suffix = @".jpg";
    if (![name hasSuffix:suffix])
      filename = [name stringByAppendingString:suffix];
    break;
  case NSPNGFileType:
    suffix = @".png";
    if (![name hasSuffix:suffix])
      filename = [name stringByAppendingString:suffix];
    break;
  case NSJPEG2000FileType:
    suffix = @".jp2";
    if (![name hasSuffix:suffix])
      filename = [name stringByAppendingString:suffix];
    break;
  default:
    break;
  }

  NSString *destination = [path stringByAppendingPathComponent:filename];
  NSBIR *bmpImageRep =
      [NSBIR.alloc initWithData:[self TIFFRepresentation]];
  NSData *data = [bmpImageRep representationUsingType:type properties:nil];

  return [data writeToFile:destination atomically:NO];
}

- (BOOL)saveAs:(NSS*) path {
  NSBIR *bmpImageRep =
      [NSBIR.alloc initWithData:[self TIFFRepresentation]];
  NSData *data =
      [bmpImageRep representationUsingType:NSPNGFileType properties:nil];
  return [data writeToFile:path atomically:YES];
}

- _Pict_ scaleToFillSize:(NSSZ)targetSize {
  NSSZ sourceSize = self.size;
  NSRect sourceRect = NSZeroRect;
  if (sourceSize.height > sourceSize.width) {
    sourceRect =
        NSMakeRect(0.0, round((sourceSize.height - sourceSize.width) / 2),
                   sourceSize.width, sourceSize.width);
  } else {
    sourceRect = NSMakeRect(round((sourceSize.width - sourceSize.height) / 2),
                            0.0, sourceSize.height, sourceSize.height);
  }
  NSRect destinationRect = NSZeroRect;
  destinationRect.size = targetSize;
  NSIMG *final = [NSImage.alloc initWithSize:targetSize];
  [final lockFocus];
  [AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationHigh];
  [self drawInRect:destinationRect
          fromRect:sourceRect
         operation:NSCompositeSourceOver
          fraction:1.0];
  [final unlockFocus];
  return final;
}
@end

@implementation CIImage (ToNSImage)

// While we're at it, let's get the conversion back to NSImage out of the way. Here's a similar category method on CIImage. Well, two actually: one that assumes you want the whole extent of the image; the other to grab just a particular rectangle:

- _Pict_ toNSImageFromRect:(CGRect)r {
  NSIMG *image;
  NSCIImageRep *ir;
  ir = [NSCIImageRep imageRepWithCIImage:self];
  image = [NSImage.alloc initWithSize:NSMakeSize(r.size.width, r.size.height)];
  [image addRepresentation:ir];
  return image;
}

- _Pict_ toNSImage {

  return [self toNSImageFromRect:[self extent]];
}

- (CIImage*) rotateDegrees:(float)aDegrees {
  CIImage *im = self;
  if (aDegrees > 0.0 && aDegrees < 360.0) {
    CIFilter *f = [CIFilter filterWithName:@"CIAffineTransform"];
    NSAffineTransform *t = [NSAffineTransform transform];
    [t rotateByDegrees:aDegrees];
    [f setValue:t forKey:@"inputTransform"];
    [f setValue:im forKey:@"inputImage"];
    im = [f valueForKey:@"outputImage"];

    CGRect extent = [im extent];
    f = [CIFilter filterWithName:@"CIAffineTransform"];
    t = [NSAffineTransform transform];
    [t translateXBy:-extent.origin.x yBy:-extent.origin.y];
    [f setValue:t forKey:@"inputTransform"];
    [f setValue:im forKey:@"inputImage"];
    im = [f valueForKey:@"outputImage"];
  }
  return im;
}

@end


@implementation NSImage (AtoZScaling)

- _Pict_ imageByAdjustingHue:(float)hue {
  return self;
}

- _Pict_ imageByAdjustingHue:(float)hue saturation:(float)saturation {
  return self;
}

- (NSSZ)adjustSizeToDrawAtSize:(NSSZ)theSize {
  NSIR *bestRep = [self bestRepresentationForSize:theSize];
  [self setSize:[bestRep size]];
  return [bestRep size];
}


- (BOOL)createIconRepresentations {
  [self setFlipped:NO];

  //[self createRepresentationOfSize:NSMakeSize(128, 128)];
  [self createRepresentationOfSize:NSMakeSize(32, 32)];
  [self createRepresentationOfSize:NSMakeSize(16, 16)];
  [self setScalesWhenResized:NO];
  return YES;
}

- (BOOL)createRepresentationOfSize:(NSSZ)newSize {
  // ***warning   * !? should this be done on the main thread?
  //

  if ([self representationOfSize:newSize])
    return NO;

  NSBIR *bestRep =
      (NSBIR *)[self bestRepresentationForSize:newSize];
  if ([bestRep respondsToSelector:@selector(CGImage)]) {
    CGImageRef imageRef = [bestRep CGImage];

    CGColorSpaceRef cspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef smallContext = CGBitmapContextCreate(
        NULL, newSize.width, newSize.height, 8, // bits per component
        newSize.width * 4,                      // bytes per pixel
        cspace, kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedLast);
    CFRelease(cspace);

    if (!smallContext)
      return NO;

    NSRect drawRect = AZFitRectInRect(AZRectFromSize([bestRep size]),
                                      AZRectFromSize(newSize), NO);

    CGContextDrawImage(smallContext, NSRectToCGRect(drawRect), imageRef);

    CGImageRef smallImage = CGBitmapContextCreateImage(smallContext);
    if (smallImage) {
      NSBIR *cgRep =
          [NSBIR.alloc initWithCGImage:smallImage];
      [self addRepresentation:cgRep];
    }
    CGImageRelease(smallImage);
    CGContextRelease(smallContext);

    return YES;
  }

  //
  //  {
  //	NSDate *date = [NSDate date];
  //	NSData *data = [(NSBIR*) bestRep TIFFRepresentation];
  //
  //	CGDataProviderRef provider =
  // CGDataProviderCreateWithCFData((CFDataRef)data);
  //	CGImageSourceRef isrc = CGImageSourceCreateWithDataProvider (provider,
  // NULL);
  //	CGDataProviderRelease( provider );
  //
  //	NSDictionary* thumbOpts = [NSDictionary dictionaryWithObjectsAndKeys:
  //							   (id)kCFBooleanTrue,
  //(id)kCGImageSourceCreateThumbnailWithTransform,
  //							   (id)kCFBooleanTrue,
  //(id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
  //							   [NSNumber numberWithInt:newSize.width],
  //(id)kCGImageSourceThumbnailMaxPixelSize,
  //							   nil];
  //	CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex (isrc, 0,
  //(CFDictionaryRef)thumbOpts);
  //	if (isrc) CFRelease(isrc);
  //
  //	NSBIR *cgRep = [[NSBIR.alloc
  // initWithCGImage:thumbnail] autorelease];
  //	CGImageRelease(thumbnail);
  //	NSLog(@"time1 %f", -[date timeIntervalSinceNow]);
  //  }
  //
  //
  //
  //
  //  {
  //	NSDate *date = [NSDate date];
  //	NSIMG* scaledImage = [[NSImage.alloc initWithSize:newSize] autorelease];
  //	[scaledImage lockFocus];
  //	NSGraphicsContext *graphicsContext = AZGRAPHICSCTX;
  //	[graphicsContext setImageInterpolation:NSImageInterpolationHigh];
  //	[graphicsContext setShouldAntialias:YES];
  //	NSRect drawRect = fitRectInRect(rectFromSize([bestRep size]),
  // rectFromSize(newSize), NO);
  //	[bestRep drawInRect:drawRect];
  //	NSBIR* nsRep = [[NSBIR.alloc
  // initWithFocusedViewRect:NSMakeRect(0, 0, newSize.width, newSize.height)]
  // autorelease];
  //	[scaledImage unlockFocus];
  //
  //	NSLog(@"time3 %f", -[date timeIntervalSinceNow]);
  //  }
  //  [self addRepresentation:rep];

  return YES;

  //
  //
  //  [self addRepresentation:iconRep];
  //  return YES;
}

- _Void_ removeRepresentationsLargerThanSize:(NSSZ)size {
  NSEnumerator *e = [[self representations] reverseObjectEnumerator];
  NSIR *thisRep;
  while ((thisRep = [e nextObject])) {
    if ([thisRep size].width > size.width &&
        [thisRep size].height > size.height)
      [self removeRepresentation:thisRep];
  }
}

- _Pict_ duplicateOfSize:(NSSZ)newSize {
  NSIMG *dup = [self copy];
  [dup shrinkToSize:newSize];
  [dup setFlipped:NO];
  return dup;
}

- (BOOL)shrinkToSize:(NSSZ)newSize {
  [self createRepresentationOfSize:newSize];
  [self setSize:newSize];
  [self removeRepresentationsLargerThanSize:newSize];
  return YES;
}

@end

@implementation NSImage (AtoZTrim)

- (NSRect) usedRect {

  NSData *tiffData = [self TIFFRepresentation];
  NSBIR *bitmap = [NSBIR.alloc initWithData:tiffData];

  if (![bitmap hasAlpha])
    return NSMakeRect(0, 0, [bitmap size].height, [bitmap size].width);

  int minX = [bitmap pixelsWide];
  int minY = [bitmap pixelsHigh];
  int maxX = 0;
  int maxY = 0;

  int i, j;
  unsigned char *pixels = [bitmap bitmapData];

  // int alpha;
  for (i = 0; i < [bitmap pixelsWide]; i++) {
    for (j = 0; j < [bitmap pixelsHigh]; j++) {
      // alpha = *(pixels + i*[bitmap pixelsWide] *[bitmap samplesPerPixel] +
      // j*[bitmapsamplesPerPixel] + 3);
      if (*(pixels + j * [bitmap pixelsWide] * [bitmap samplesPerPixel] +
            i * [bitmap samplesPerPixel] +
            3)) { // This pixel is not transparent! Readjust bounds.
        // QSLog(@"Pixel Occupied: (%d, %d) ", i, j);
        minX = MIN(minX, i);
        maxX = MAX(maxX, i);
        minY = MIN(minY, j);
        maxY = MAX(maxY, j);
      }
    }
  }
  //  [`bitmap release];
  // flip y!!
  // QSLog(@"%d, %d, %d, %d", minX, minY, maxX, maxY);
  return NSMakeRect(minX, [bitmap pixelsHigh] - maxY - 1, maxX - minX + 1,
                    maxY - minY + 1);
}

- _Pict_ scaleImageToSize:(NSSZ)newSize
                       trim:(BOOL)trim
                     expand:(BOOL)expand
                    scaleUp:(BOOL)scaleUp {
  NSRect sourceRect = (trim ? [self usedRect] : AZRectFromSize([self size]));
  NSRect drawRect =
      (scaleUp || NSHeight(sourceRect) > newSize.height ||
               NSWidth(sourceRect) > newSize.width
           ? AZSizeRectInRect(sourceRect, AZRectFromSize(newSize), expand)
           : NSMakeRect(0, 0, NSWidth(sourceRect), NSHeight(sourceRect)));
  NSIMG *tempImage = [NSImage.alloc
      initWithSize:NSMakeSize(NSWidth(drawRect), NSHeight(drawRect))];
  [tempImage lockFocus];
  {
    [AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationHigh];
    [self drawInRect:drawRect
            fromRect:sourceRect
           operation:NSCompositeSourceOver
            fraction:1];
  }
  [tempImage unlockFocus];
  // QSLog(@"%@", tempImage);
  return [NSImage.alloc initWithData:[tempImage TIFFRepresentation]]; //// UGH!
  // why do I
  // have to do
  // this to
  // commit the
  // changes?;
}
@end

@implementation NSImage (AtoZAverage)

- (NSC*) averageColor {

  NSBIR *rep = [self representations][0];
  //	 filterOne:<#^BOOL(id object)block#>: (NSBIR *)[self
  // bestRepresentationForDevice:nil];
  if (![rep isKindOfClass:[NSBIR class]])
    return nil;
  unsigned char *pixels = [rep bitmapData];

  int red = 0, blue = 0, green = 0; //, alpha = 0;
  int n = [rep size].width * [rep size].height;
  int i = 0;
  for (i = 0; i < n; i++) {
    //	pixels[(j*imageWidthInPixels+i) *bitsPerPixel+channel]
    // QSLog(@"%d %d %d %d", pixels[0] , pixels[1] , pixels[2] , pixels[3]);
    red += *pixels++;
    green += *pixels++;
    blue += *pixels++;
    // alpha += *pixels++;
  }

  // QSLog(@"%d %f %d", blue, (float) blue/n/256, n);
  NSC *color = [NSC colorWithDeviceRed:(float)red / n / 256
                                 green:(float)green / n / 256
                                  blue:(float)blue / n / 256
                                 alpha:1.0];
  //		QSLog(@"color %@", color);
  return color;
}

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
  CGImageRef retVal = NULL;
  size_t width = CGImageGetWidth(sourceImage);
  size_t height = CGImageGetHeight(sourceImage);
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef offscreenContext = CGBitmapContextCreate(
      NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
  if (offscreenContext != NULL) {
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height),
                       sourceImage);
    retVal = CGBitmapContextCreateImage(offscreenContext);
    CGContextRelease(offscreenContext);
  }
  CGColorSpaceRelease(colorSpace);
  return retVal;
}

+ _Pict_ maskImage:(NSIMG*) image withMask:(NSIMG*) maskImage {
  CGImageRef maskRef = [maskImage cgImageRef];
  CGImageRef mask = CGImageMaskCreate(
      CGImageGetWidth(maskRef), CGImageGetHeight(maskRef),
      CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef),
      CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), NULL,
      false);

  CGImageRef sourceImage = [image cgImageRef];
  CGImageRef imageWithAlpha = sourceImage;
  // add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
  // this however has a computational cost
  if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
    imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
  }

  CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
  CGImageRelease(mask);

  // release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
  if (sourceImage != imageWithAlpha) {
    CGImageRelease(imageWithAlpha);
  }

  NSIMG *retImage = [NSImage imageFromCGImageRef:masked];
  CGImageRelease(masked);

  return retImage;
}

@end

//#define LEOPARD 0x1050
//#define TIGER   0x1040

//@implementation NSBIR (GrabWindow)

//+ (NSBIR*) bitmapRepWithScreenShotInRect:(NSRect)cocoaRect
//{
//	NSIMG*image = [NSImage imageWithScreenShotInRect: cocoaRect];
//	// convert it to a bitmap rep and return
////	return [NSBitmapIm/ageRep bitmapRepFromNSImage:
//	return [image bitmap];
//}
//@end
*/
/*+ (NSA*) picolStrings {		static NSA*_picolSrtrings;
                if (_picolSrtrings == nil)	{ // This will only be true the
first time the method is called...

_picolSrtrings = [@[@"xml_document.pdf", @"xml.pdf", @"zoom_in.pdf",
@"zoom_out.pdf", @"website.pdf", @"video_edit.pdf", @"video_information.pdf",
@"video_pause.pdf", @"video_remove.pdf", @"video_run.pdf",
@"video_security.pdf", @"video_settings.pdf", @"video_stop.pdf",
@"video_up.pdf", @"video.pdf", @"view.pdf", @"viewer_image.pdf",
@"viewer_text.pdf", @"viewer_video.pdf", @"video_add.pdf", @"video_cancel.pdf",
@"video_down.pdf", @"user_full_add.pdf", @"user_full_edit.pdf",
@"user_full_information.pdf", @"user_full_remove.pdf",
@"user_full_security.pdf", @"user_full_settings.pdf", @"user_full.pdf",
@"user_half_add.pdf", @"user_half_edit.pdf", @"user_half_information.pdf",
@"user_half_remove.pdf", @"user_half_security.pdf", @"user_half_settings.pdf",
@"user_half.pdf", @"user_profile_edit.pdf", @"user_profile.pdf",
@"video_accept.pdf", @"server_information.pdf", @"server_remove.pdf",
@"server_run.pdf", @"server_security.pdf", @"server_settings.pdf",
@"server_stop.pdf", @"server.pdf", @"settings.pdf", @"shopping_cart.pdf",
@"sitemap.pdf", @"size_both_accept.pdf", @"size_both_add.pdf",
@"size_both_cancel.pdf", @"size_both_edit.pdf", @"size_both_remove.pdf",
@"size_both_security.pdf", @"size_both_settings.pdf", @"size_both.pdf",
@"size_height_accept.pdf", @"size_height_add.pdf", @"size_height_cancel.pdf",
@"size_height_edit.pdf", @"size_height_remove.pdf", @"size_height_security.pdf",
@"size_height_settings.pdf", @"size_height.pdf", @"size_width_accept.pdf",
@"size_width_add.pdf", @"size_width_cancel.pdf", @"size_width_edit.pdf",
@"size_width_remove.pdf", @"size_width_security.pdf",
@"size_width_settings.pdf", @"size_width.pdf", @"social_network.pdf",
@"source_code.pdf", @"speaker_louder.pdf", @"speaker_off.pdf",
@"speaker_silent.pdf", @"star_outline.pdf", @"star.pdf", @"statistics.pdf",
@"synchronize.pdf", @"tab_add.pdf", @"tab_cancel.pdf", @"tab.pdf",
@"target.pdf", @"terminal_computer.pdf", @"text_align_center.pdf",
@"text_align_full.pdf", @"text_align_left.pdf", @"text_align_right.pdf",
@"text_bold.pdf", @"text_italic.pdf", @"text_strikethrough.pdf", @"text.pdf",
@"transportation_bus.pdf", @"transportation_car.pdf",
@"transportation_plane.pdf", @"transportation_ship.pdf",
@"transportation_train.pdf", @"trash_full.pdf", @"trash.pdf",
@"upload_accept.pdf", @"upload_cancel.pdf", @"upload_pause.pdf",
@"upload_run.pdf", @"upload_security.pdf", @"upload_settings.pdf",
@"upload_stop.pdf", @"upload.pdf", @"user_close_add.pdf",
@"user_close_edit.pdf", @"user_close_information.pdf", @"user_close_remove.pdf",
@"user_close_security.pdf", @"user_close_settings.pdf", @"user_close.pdf",
@"mailbox_incoming.pdf", @"mailbox_outgoing.pdf", @"mailbox_settings.pdf",
@"mailbox.pdf", @"mainframe.pdf", @"mashup.pdf", @"mobile_phone.pdf",
@"move.pdf", @"music_accept.pdf", @"music_add.pdf", @"music_cancel.pdf",
@"music_edit.pdf", @"music_eject.pdf", @"music_information.pdf",
@"music_pause.pdf", @"music_remove.pdf", @"music_run.pdf",
@"music_security.pdf", @"music_settings.pdf", @"music_stop.pdf", @"music.pdf",
@"network_intranet.pdf", @"network_protocol.pdf", @"network_sans_add.pdf",
@"network_sans_edit.pdf", @"network_sans_remove.pdf",
@"network_sans_security.pdf", @"network_sans.pdf", @"network_wireless_add.pdf",
@"network_wireless_edit.pdf", @"network_wireless_security.pdf",
@"network_wireless.pdf", @"news.pdf", @"notes_accept.pdf", @"notes_add.pdf",
@"notes_cancel.pdf", @"notes_down.pdf", @"notes_edit.pdf", @"notes_remove.pdf",
@"notes_settings.pdf", @"notes_up.pdf", @"notes.pdf", @"ontology.pdf",
@"owl_dl_document.pdf", @"owl_dl.pdf", @"owl_full_document.pdf",
@"owl_full.pdf", @"owl_lite_document.pdf", @"owl_lite.pdf", @"paragraph.pdf",
@"paste.pdf", @"path.pdf", @"pda.pdf", @"phone_home.pdf", @"phone_off.pdf",
@"phone_on.pdf", @"plus.pdf", @"printer_add.pdf", @"printer_cancel.pdf",
@"printer_information.pdf", @"printer_pause.pdf", @"printer_remove.pdf",
@"printer_run.pdf", @"printer_settings.pdf", @"printer_stop.pdf",
@"printer.pdf", @"questionmark.pdf", @"rdf_document.pdf", @"rdf.pdf",
@"recent_changes.pdf", @"refresh.pdf", @"relevance.pdf", @"remix.pdf",
@"satellite_ground.pdf", @"satellite.pdf", @"screen_4to3.pdf",
@"screen_16to9.pdf", @"script.pdf", @"search.pdf", @"security_closed.pdf",
@"security_open.pdf", @"semantic_web.pdf", @"server_accept.pdf",
@"server_add.pdf", @"server_cancel.pdf", @"server_edit.pdf",
@"server_eject.pdf", @"edit.pdf", @"equal.pdf", @"filepath.pdf",
@"filter_settings.pdf", @"filter.pdf", @"firewall_pause.pdf",
@"firewall_run.pdf", @"firewall_settings.pdf", @"firewall_stop.pdf",
@"firewall.pdf", @"flash_off.pdf", @"flash.pdf", @"floppy_disk.pdf",
@"folder_downloads.pdf", @"folder_image.pdf", @"folder_music.pdf",
@"folder_sans_accept.pdf", @"folder_sans_add.pdf", @"folder_sans_cancel.pdf",
@"folder_sans_down.pdf", @"folder_sans_edit.pdf",
@"folder_sans_information.pdf", @"folder_sans_remove.pdf",
@"folder_sans_run.pdf", @"folder_sans_security.pdf",
@"folder_sans_settings.pdf", @"folder_sans_up.pdf", @"folder_sans.pdf",
@"folder_text.pdf", @"folder_video.pdf", @"fullscreen_cancel.pdf",
@"fullscreen.pdf", @"globe.pdf", @"group_full_add.pdf", @"group_full_edit.pdf",
@"group_full_remove.pdf", @"group_full_security.pdf", @"group_full.pdf",
@"group_half_add.pdf", @"group_half_edit.pdf", @"group_half_remove.pdf",
@"group_half_security.pdf", @"group_half.pdf", @"harddisk_sans_eject.pdf",
@"harddisk_sans_security.pdf", @"harddisk_sans_settings.pdf",
@"harddisk_sans.pdf", @"hierarchy.pdf", @"home.pdf", @"image_accept.pdf",
@"image_add.pdf", @"image_cancel.pdf", @"image_edit.pdf", @"image_pause.pdf",
@"image_remove.pdf", @"image_run.pdf", @"image_security.pdf",
@"image_settings.pdf", @"image.pdf", @"imprint.pdf", @"information.pdf",
@"internet.pdf", @"keyboard.pdf", @"label_add.pdf", @"label_edit.pdf",
@"label_remove.pdf", @"label_security.pdf", @"label.pdf", @"light_off.pdf",
@"light.pdf", @"link_add.pdf", @"link_edit.pdf", @"link_remove.pdf",
@"link.pdf", @"list_numbered.pdf", @"list.pdf", @"mail_accept.pdf",
@"mail_add.pdf", @"mail_cancel.pdf", @"mail_edit.pdf", @"mail_fwd.pdf",
@"mail_remove.pdf", @"mail_run.pdf", @"mail_security.pdf", @"mail.pdf",
@"mailbox_down.pdf", @"mailbox_eject.pdf", @"document_sans_run.pdf",
@"document_sans_security.pdf", @"document_sans_settings.pdf",
@"document_sans_up.pdf", @"document_sans.pdf", @"document_text_accept.pdf",
@"document_text_add.pdf", @"document_text_cancel.pdf",
@"document_text_down.pdf", @"document_text_edit.pdf",
@"document_text_information.pdf", @"document_text_remove.pdf",
@"document_text_run.pdf", @"document_text_security.pdf",
@"document_text_settings.pdf", @"document_text_up.pdf", @"document_text.pdf",
@"document_video_accept.pdf", @"document_video_add.pdf",
@"document_video_cancel.pdf", @"document_video_down.pdf",
@"document_video_edit.pdf", @"document_video_information.pdf",
@"document_video_remove.pdf", @"document_video_run.pdf",
@"document_video_security.pdf", @"document_video_settings.pdf",
@"document_video_up.pdf", @"document_video.pdf", @"donate.pdf",
@"download_accept.pdf", @"download_cancel.pdf", @"download_information.pdf",
@"download_pause.pdf", @"download_run.pdf", @"download_security.pdf",
@"download_settings.pdf", @"download_stop.pdf", @"download.pdf", @"dropbox.pdf",
@"document_sans_down.pdf", @"document_sans_edit.pdf",
@"document_sans_information.pdf", @"document_sans_remove.pdf",
@"document_image_add.pdf", @"document_image_cancel.pdf",
@"document_image_down.pdf", @"document_image_edit.pdf",
@"document_image_information.pdf", @"document_image_remove.pdf",
@"document_image_run.pdf", @"document_image_security.pdf",
@"document_image_settings.pdf", @"document_image_up.pdf", @"document_image.pdf",
@"document_music_accept.pdf", @"document_music_add.pdf",
@"document_music_cancel.pdf", @"document_music_down.pdf",
@"document_music_edit.pdf", @"document_music_information.pdf",
@"document_music_remove.pdf", @"document_music_run.pdf",
@"document_music_security.pdf", @"document_music_settings.pdf",
@"document_music_up.pdf", @"document_music.pdf", @"document_sans_accept.pdf",
@"document_sans_add.pdf", @"document_sans_cancel.pdf", @"category_edit.pdf",
@"category_remove.pdf", @"category_settings.pdf", @"category.pdf",
@"cd_eject.pdf", @"cd_pause.pdf", @"cd_run.pdf", @"cd_security.pdf",
@"cd_stop.pdf", @"cd_write.pdf", @"cd.pdf", @"chat_pause.pdf", @"chat_run.pdf",
@"chat_security.pdf", @"chat_settings.pdf", @"chat_stop.pdf", @"chat.pdf",
@"clock_mini.pdf", @"clock.pdf", @"combine.pdf", @"comment_accept.pdf",
@"comment_add.pdf", @"comment_cancel.pdf", @"comment_edit.pdf",
@"comment_remove.pdf", @"comment_settings.pdf", @"comment.pdf",
@"computer_accept.pdf", @"computer_add.pdf", @"computer_cancel.pdf",
@"computer_remove.pdf", @"computer_settings.pdf", @"computer.pdf",
@"controls_chapter_next.pdf", @"controls_chapter_previous.pdf",
@"controls_eject.pdf", @"controls_fast_forward.pdf", @"controls_pause.pdf",
@"controls_play_back.pdf", @"controls_play.pdf", @"controls_rewind.pdf",
@"controls_stop.pdf", @"cooler.pdf", @"copy.pdf", @"cut.pdf",
@"data_privacy.pdf", @"database_add.pdf", @"database_edit.pdf",
@"database_information.pdf", @"database_remove.pdf", @"database_run.pdf",
@"database_security.pdf", @"database.pdf", @"document_image_accept.pdf",
@"book_audio_pause.pdf", @"book_audio_remove.pdf", @"book_audio_run.pdf",
@"book_audio_security.pdf", @"book_audio_settings.pdf", @"book_audio_stop.pdf",
@"book_audio.pdf", @"book_image_add.pdf", @"book_image_information.pdf",
@"book_image_pause.pdf", @"book_image_remove.pdf", @"book_image_run.pdf",
@"book_image_security.pdf", @"book_image_settings.pdf", @"book_image_stop.pdf",
@"book_image.pdf", @"book_sans_add.pdf", @"book_sans_down.pdf",
@"book_sans_information.pdf", @"book_sans_remove.pdf", @"book_sans_run.pdf",
@"book_sans_security.pdf", @"book_sans_up.pdf", @"book_sans.pdf",
@"book_text_add.pdf", @"book_text_down.pdf", @"book_text_information.pdf",
@"book_text_remove.pdf", @"book_text_run.pdf", @"book_text_security.pdf",
@"book_text_settings.pdf", @"book_text_stop.pdf", @"book_text_up.pdf",
@"book_text.pdf", @"bookmark_settings.pdf", @"bookmark.pdf",
@"brightness_brighten.pdf", @"brightness_darken.pdf", @"browser_window_add.pdf",
@"browser_window_cancel.pdf", @"browser_window_remove.pdf",
@"browser_window_security.pdf", @"browser_window_settings.pdf",
@"browser_window.pdf", @"buy.pdf", @"calculator.pdf", @"calendar.pdf",
@"cancel.pdf", @"category_add.pdf", @"accept.pdf", @"adressbook.pdf",
@"agent.pdf", @"api.pdf", @"application.pdf", @"arrow_full_down.pdf",
@"arrow_full_left.pdf", @"arrow_full_lowerleft.pdf",
@"arrow_full_lowerright.pdf", @"arrow_full_right.pdf", @"arrow_full_up.pdf",
@"arrow_full_upperleft.pdf", @"arrow_full_upperright.pdf",
@"arrow_sans_down.pdf", @"arrow_sans_left.pdf", @"arrow_sans_lowerleft.pdf",
@"arrow_sans_lowerright.pdf", @"arrow_sans_right.pdf", @"arrow_sans_up.pdf",
@"arrow_sans_upperleft.pdf", @"arrow_sans_upperright.pdf",
@"attachment_add.pdf", @"attachment_down.pdf", @"attachment.pdf",
@"avatar_edit.pdf", @"avatar_information.pdf", @"avatar.pdf",
@"backup_pause.pdf", @"backup_run.pdf", @"backup_settings.pdf",
@"backup_stop.pdf", @"backup.pdf", @"badge_accept.pdf", @"badge_cancel.pdf",
@"badge_down.pdf", @"badge_edit.pdf", @"badge_eject.pdf",
@"badge_information.pdf", @"badge_minus.pdf", @"badge_pause.pdf",
@"badge_plus.pdf", @"badge_run.pdf", @"badge_security.pdf",
@"badge_settings.pdf", @"badge_stop.pdf", @"badge_up.pdf", @"battery_1.pdf",
@"battery_2.pdf", @"battery_3.pdf", @"battery_4.pdf", @"battery_empty.pdf",
@"battery_full.pdf", @"battery_plugged.pdf", @"book_audio_add.pdf",
@"book_audio_eject.pdf", @"book_audio_information.pdf"]
    arrayUsingBlock:^id(id obj) {
      return  $(@"/picol/%@",obj);
    }];
  }
  return _picolSrtrings;
}
@end
*/

/*
@implementation NSImage (GrabWindow)
+ _Pict_ captureScreenImageWithFrame: (NSRect) frame
{
  // Fetch a graphics port of the screen

  CGrafPtr screenPort = CreateNewPort ();
  Rect screenRect;
  GetPortBounds (screenPort, &screenRect);

  // Make a temporary window as a receptacle

  NSWindow *grabWindow = [NSWindow.alloc initWithContentRect: frame
                             styleMask: NSBorderlessWindowMask
                             backing: NSBackingStoreRetained
                               defer: NO
                              screen: nil];
  CGrafPtr windowPort = GetWindowPort ([grabWindow windowRef]);
  Rect windowRect;
  GetPortBounds (windowPort, &windowRect);
  SetPort (windowPort);

  // Copy the screen to the temporary window

  CopyBits (GetPortBitMapForCopyBits(screenPort),
        GetPortBitMapForCopyBits(windowPort),
        &screenRect,
        &windowRect,
        srcCopy,
        NULL);

  // Get the contents of the temporary window into an NSImage

  NSView *grabContentView = [grabWindow contentView];

  [grabContentView lockFocus];
  NSBIR *screenRep;
  screenRep = [NSBIR.alloc initWithFocusedViewRect: frame];
  [grabContentView unlockFocus];

  NSIMG*screenImage = [NSImage.alloc initWithSize: frame.size];
  [screenImage addRepresentation: screenRep];

  // Clean up
  [grabWindow close];
  DisposePort(screenPort);

  return (screenImage);

} // captureScreenImageWithFrame

+ (NSIMG*)screenShotWithinRect:(NSRect)rect
{
  NSWindow *window = [NSWindow.alloc initWithContentRect:rect
styleMask:NSBorderlessWindowMask
                       backing:NSBackingStoreNonretained defer:NO];
  [window setBackgroundColor:[NSC clearColor]];
  [window setLevel:NSScreenSaverWindowLevel + 1];
  [window setHasShadow:NO];
  [window setAlphaValue:0.0];
  [window orderFront:self];
  [window setContentView:[NSView.alloc initWithFrame:rect]];
  [[window contentView] lockFocus];
  NSBIR *rep = [NSBIR.alloc
initWithFocusedViewRect:[[window contentView] bounds]];
  [[window contentView] unlockFocus];
  [window orderOut:self];
  [window close];

  NSIMG*image = [[ NSImage alloc] initWithData:[rep TIFFRepresentation]];
//	[[ NSImage alloc] initWithSize:[rep size]];
//	[image addRepresentation:rep];

  return image;
}
*/
/*

+ (NSIMG*)imageWithCGContextCaptureWindow: (int)wid {

  // get window bounds
  CGRect windowRect;
  CGSGetWindowBounds(_CGSDefaultConnection(), wid, &windowRect);
  windowRect.origin = CGPointZero;

  // create an NSImage fo the window, cutting off the titlebar
  NSIMG*image = [NSImage.alloc initWithSize: NSMakeSize(windowRect.size.width,
windowRect.size.height - 22)];
  [image lockFocus];  // lock focus on the image for drawing

  // copy the contents of the window to the graphic context
  CGContextCopyWindowCaptureContentsToRect([AZGRAPHICSCTX graphicsPort],
                       windowRect,
                       _CGSDefaultConnection(),
                       wid,
                       0);
  [image unlockFocus];
  return image;// autorelease];
}

+ (NSIMG*)imageWithScreenShotInRect:(NSRect)cocoaRect {
  PicHandle picHandle;
  GDHandle mainDevice;
  Rect rect;

  // Convert NSRect to Rect
  SetRect(&rect, NSMinX(cocoaRect), NSMinY(cocoaRect), NSMaxX(cocoaRect),
NSMaxY(cocoaRect));

  // Get the main screen. No multiple screen support here.
  mainDevice = GetMainDevice();

  // Capture the screen into the PicHandle.
  picHandle = OpenPicture(&rect);
  CopyBits((BitMap *)*(**mainDevice).gdPMap, (BitMap *)*(**mainDevice).gdPMap,
       &rect, &rect, srcCopy, 0l);
  ClosePicture();

  // Convert the PicHandle into an NSImage
  // First lock the PicHandle so it doesn't move in memory while we copy
  HLock((Handle)picHandle);

  NSIR *pictImageRep = [NSPICTImageRep imageRepWithData:[NSData
dataWithBytes:(*picHandle)
                                         length:GetHandleSize((Handle)picHandle)]];
  HUnlock((Handle)picHandle);

  // We can release the PicHandle now that we're done with it
  KillPicture(picHandle);

  // Create an image with the PICT representation
  NSIMG*image = [NSImage.alloc initWithSize: [pictImageRep size]];
  [image addRepresentation: pictImageRep];
  return image;// autorelease];
}
*/
/*
+ _Pict_ imageBelowWindow:(NSWindow*) window {

  // Get the CGWindowID of supplied window
  CGWindowID windowID = [window windowNumber];

  // Get window's rect in flipped screen coordinates
  CGRect windowRect = NSRectToCGRect([window frame]);
  windowRect.origin.y =
      NSMaxY([[window screen] frame]) - NSMaxY([window frame]);

  // Get a composite image of all the windows beneath your window
  CGImageRef capturedImage = CGWindowListCreateImage(
      windowRect, kCGWindowListOptionOnScreenBelowWindow, windowID,
      kCGWindowImageDefault);

  // The rest is as in the previous example...
  if (CGImageGetWidth(capturedImage) <= 1) {
    CGImageRelease(capturedImage);
    return nil;
  }

  // Create a bitmap rep from the window and convert to NSImage...
  //	NSBIR *bitmapRep = [[[NSBIR] alloc] initWithCGImage:
  // capturedImage];
  NSIMG *image =
      [NSImage imageFromCGImageRef:capturedImage]; // [NSImage]alloc] init];
  //	[image addRepresentation: bitmapRep];
  CGImageRelease(capturedImage);

  return image;
}
@end
// from http://developer.apple.com/technotes/tn2005/tn2143.html

CGImageRef CreateCGImageFromData(NSData *data) {
  CGImageRef imageRef = NULL;
  CGImageSourceRef sourceRef;

  sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
  if (sourceRef) {
    imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    CFRelease(sourceRef);
  }

  return imageRef;
}

//	CIFilter *matrix = (CIPerspectiveMatrix){  w*.1, h*.8,	 w*.7, h , w*.1, 0,
// w*.7, h/2};
//	[someNSImage addPerspectiveMatrix: matrix];

@implementation NSImage (Matrix)
- _Pict_ addPerspectiveMatrix:(CIPerspectiveMatrix)matrix { // 8PointMatrix

  CIImage *cImg =
      [self toCIImage]; //  [CIImage.alloc initWithCGImage: screenie];
  CIFilter *filter = [CIFilter filterWithName:@"CIPerspectiveTransform"];
  [filter setDefaults];
  [filter setValue:cImg forKey:@"inputImage"]; //	CGImageRelease(screenie);
  filter[@"inputTopLeft"] = [CIVector vectorWithX:matrix.tlX Y:matrix.tlY];
  filter[@"inputTopRight"] = [CIVector vectorWithX:matrix.trX Y:matrix.trY];
  filter[@"inputBottomLeft"] = [CIVector vectorWithX:matrix.blX Y:matrix.blY];
  filter[@"inputBottomRight"] = [CIVector vectorWithX:matrix.brX Y:matrix.brY];
  return [[filter valueForKey:@"outputImage"] toNSImage];
}
@end
@implementation CIFilter (Subscript)
- (id)objectForKeyedSubscript:(NSS*) key {
  return [self valueForKey:key];
}
- _Void_ setObject: object forKeyedSubscript:(NSS*) key {
  IsEmpty(object) ? [self setValue:@"" forKey:key]
                  : [self setValue:object forKey:key];
}
@end

@implementation NSImageView (AtoZ)

+ (NSIV*) imageViewWithImage:(NSIMG*) img {
  NSImageView *i = [[NSImageView alloc] initWithFrame:AZRectFromDim(100)];
  i.autoresizesSubviews = YES;
  i.arMASK = NSSIZEABLE;
  i.image = img;
  i.imageScaling = NSImageScaleProportionallyUpOrDown;
  return i;
}
+ (void)addImageViewWithImage:(NSIMG*) img toView:(NSV*) v;
{
  NSIV *u = [self imageViewWithImage:img];
  [u setFrame:v.bounds];
  [v addSubview:u];
}
@end
*/
/*
@implementation NSImage (NSImageThumbnailExtensions)

/// Create an NSImage from with the contents of the url of the specified width. The height of the resulting NSImage maintains the proportions in source.

+ thumbnailImageWithContentsOfURL:(NSURL*) url width:(CGF)width {
  NSIMG *thumbnailImage = nil;
  NSIMG *image = [NSImage.alloc initWithContentsOfURL:url];
  if (image != nil) {
    NSSize imageSize = [image size];
    CGFloat imageAspectRatio = imageSize.width / imageSize.height;
    // Create a thumbnail image from this image (this part of the slow
    // operation)
    NSSize thumbnailSize = NSMakeSize(width, width * imageAspectRatio);
    thumbnailImage = [NSImage.alloc initWithSize:thumbnailSize];

    [thumbnailImage lockFocus];
    [image
        drawInRect:NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height)
          fromRect:NSZeroRect
         operation:NSCompositeSourceOver
          fraction:1.0];
    [thumbnailImage unlockFocus];

    /// In general, the accessibility description is a localized description of the image.  In this app, and in the Desktop & Screen Saver preference pane, the name of the desktop picture file is what is used as the localized description in the user interface, and so it is appropriate to use the file name in this case.

    /// When an accessibility description is set on an image, the description is automatically reported to accessibility when that image is displayed in image views/cells, buttons/button cells, segmented controls, etc.  In this case the description is set programatically.  For images retrieved by name, using +imageNamed:, you can use a strings file named AccessibilityImageDescriptions.strings, which uses the names of the images as keys and the description as the string value, to automatically provide accessibility descriptions for named images in your application.

    NSString *imageName =
        [[url lastPathComponent] stringByDeletingPathExtension];
    [thumbnailImage setAccessibilityDescription:imageName];

    //		[thumbnailImage autorelease];
    //		[image release];
  }

  /// This is a sample code feature that delays the creation of the thumbnail for demonstration purposes only. Hold down the control key to extend thumnail creation by 2 seconds.
  if ([NSEvent modifierFlags] & NSControlKeyMask) {
    usleep(2000000);
  }

  return thumbnailImage;
}

@end

@implementation NSGraphicsContext (AtoZ)

+ (void)addNoiseToContext {
  static CIImage *noisePattern = nil;
  [self state:^{
      if (noisePattern == nil) {
        CIFilter *randomGenerator =
            [CIFilter filterWithName:@"CIColorMonochrome"];
        [randomGenerator
            setValue:[[CIFilter filterWithName:@"CIRandomGenerator"]
                         valueForKey:@"outputImage"]
              forKey:@"inputImage"];
        [randomGenerator setDefaults];
        noisePattern = [randomGenerator valueForKey:@"outputImage"];
      }
      [noisePattern drawAtPoint:NSZeroPoint
                       fromRect:NSZeroRect
                      operation:NSCompositePlusLighter
                       fraction:.5];
  }];
}

@end

// Copyright (c) 2013, Alun Bestor (alun.bestor@gmail.com)


//#import "NSImage+ADBImageEffects.h"
//#import "ADBGeometry.h"
//#import "ADBAppKitVersionHelpers.h"
//#import "NSShadow+ADBShadowExtensions.h"

@implementation NSImage (ADBImageEffects)

+ (NSPoint)anchorForImageAlignment:(NSImageAlignment)alignment {
  switch (alignment) {
  case NSImageAlignCenter:
    return NSMakePoint(0.5f, 0.5f);

  case NSImageAlignBottom:
    return NSMakePoint(0.5f, 0.0f);

  case NSImageAlignTop:
    return NSMakePoint(0.5f, 1.0f);

  case NSImageAlignLeft:
    return NSMakePoint(0.0f, 0.5f);

  case NSImageAlignRight:
    return NSMakePoint(1.0f, 0.5f);

  case NSImageAlignBottomLeft:
    return NSMakePoint(0.0f, 0.0f);

  case NSImageAlignBottomRight:
    return NSMakePoint(1.0f, 0.0f);

  case NSImageAlignTopLeft:
    return NSMakePoint(0.0f, 1.0f);

  case NSImageAlignTopRight:
    return NSMakePoint(1.0f, 1.0f);

  default:
    return NSZeroPoint;
  }
}

- (NSRect)imageRectAlignedInRect:(NSRect)outerRect
                       alignment:(NSImageAlignment)alignment
                         scaling:(NSImageScaling)scaling {
  NSRect drawRect = NSZeroRect;
  drawRect.size = self.size;
  NSPoint anchor = [[self class] anchorForImageAlignment:alignment];

  switch (scaling) {
  case NSImageScaleProportionallyDown:
    drawRect = constrainToRect(drawRect, outerRect, anchor);
    break;
  case NSImageScaleProportionallyUpOrDown:
    drawRect = fitInRect(drawRect, outerRect, anchor);
    break;
  case NSImageScaleAxesIndependently:
    drawRect = outerRect;
    break;
  case NSImageScaleNone:
  default:
    drawRect = alignInRectWithAnchor(drawRect, outerRect, anchor);
    break;
  }
  return drawRect;
}

- (NSImage*) imageFilledWithColor:(NSColor*) color atSize:(NSSize)targetSize {
  if (NSEqualSizes(targetSize, NSZeroSize))
    targetSize = [self size];

  NSRect imageRect = NSMakeRect(0, 0, targetSize.width, targetSize.height);

  NSImage *maskedImage = [NSImage.alloc initWithSize:targetSize];
  NSImage *sourceImage = self;

  [maskedImage lockFocus];
  [color set];
  NSRectFillUsingOperation(imageRect, NSCompositeSourceOver);
  [sourceImage drawInRect:imageRect
                 fromRect:NSZeroRect
                operation:NSCompositeDestinationIn
                 fraction:1.0f];
  [maskedImage unlockFocus];

  return maskedImage;
}

- (NSImage*) imageMaskedByImage:(NSImage*) image atSize:(NSSize)targetSize {
  if (NSEqualSizes(targetSize, NSZeroSize))
    targetSize = [self size];

  NSImage *maskedImage = [self copy];
  [maskedImage setSize:targetSize];

  NSRect imageRect =
      NSMakeRect(0.0f, 0.0f, targetSize.width, targetSize.height);

  [maskedImage lockFocus];
  [image drawInRect:imageRect
           fromRect:NSZeroRect
          operation:NSCompositeDestinationIn
           fraction:1.0f];
  [maskedImage unlockFocus];

  return maskedImage;
}

- _Void_ drawInRect:(NSRect)drawRect
      withGradient:(NSGradient*) gradient
        dropShadow:(NSShadow*) dropShadow
       innerShadow:(NSShadow*) innerShadow
    respectFlipped:(BOOL)respectContextIsFlipped {
  NSAssert(self.isTemplate, @"drawInRect:withGradient:dropShadow:innerShadow: "
           @"can only be used with template images.");

  // Check if we're rendering into a backing intended for retina displays.
  NSSize pointSize = NSMakeSize(1, 1);
  if ([[NSView focusView] respondsToSelector:@selector(convertSizeToBacking:)])
    pointSize = [[NSView focusView] convertSizeToBacking:pointSize];

  NSSize contextSize = [NSView focusView].bounds.size;

  NSGraphicsContext *context = [NSGraphicsContext currentContext];
  CGContextRef cgContext = (CGContextRef)context.graphicsPort;

  BOOL drawFlipped = respectContextIsFlipped && context.isFlipped;

  // Now calculate the total area of the context that will be affected by our
  // drawing,
  // including our drop shadow. Our mask images will be created at this size to
  // ensure
  // that the whole canvas is properly masked.

  NSRect totalDirtyRect = drawRect;
  if (dropShadow) {
    totalDirtyRect = NSUnionRect(totalDirtyRect,
                                 [dropShadow shadowedRect:drawRect flipped:NO]);
  }

  // TWEAK: also expand the dirty rect to encompass our *inner* shadow as well.
  // Because the resulting mask is used to draw the inner shadow, it needs to
  // have enough
  // padding around all relevant edges that the inner shadow appears 'solid' and
  // doesn't
  // get cut off.
  if (innerShadow) {
    totalDirtyRect = NSUnionRect(
        totalDirtyRect, [dropShadow rectToCastInnerShadow:drawRect flipped:NO]);
  }

  CGRect maskRect = CGRectIntegral(NSRectToCGRect(totalDirtyRect));

  // First get a representation of the image suitable for drawing into the
  // destination.
  CGRect imageRect = NSRectToCGRect(drawRect);
  CGImageRef baseImage =
      [self CGImageForProposedRect:&drawRect context:context hints:nil];

  // Next, render it into a new bitmap context sized to cover the whole dirty
  // area.
  // We then grab regular and inverted CGImages from that context to use as
  // masks.

  // NOTE: Because CGBitmapContexts are not retina-aware and use device pixels,
  // we have to compensate accordingly when we're rendering for a retina
  // backing.
  CGSize maskPixelSize = CGSizeMake(maskRect.size.width * pointSize.width,
                                    maskRect.size.height * pointSize.height);

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef maskContext = CGBitmapContextCreate(
      NULL, maskPixelSize.width, maskPixelSize.height, 8,
      maskPixelSize.width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
  CGColorSpaceRelease(colorSpace);

  CGRect relativeMaskRect =
      CGRectMake((imageRect.origin.x - maskRect.origin.x) * pointSize.width,
                 (imageRect.origin.y - maskRect.origin.y) * pointSize.height,
                 imageRect.size.width * pointSize.width,
                 imageRect.size.height * pointSize.height);

  CGContextDrawImage(maskContext, relativeMaskRect, baseImage);
  // Grab our first mask image, which is just the original image with padding.
  CGImageRef imageMask = CGBitmapContextCreateImage(maskContext);

  // Now invert the colors in the context and grab another image, which will be
  // our inverse mask.
  CGContextSetBlendMode(maskContext, kCGBlendModeXOR);
  CGContextSetRGBFillColor(maskContext, 1.0, 1.0, 1.0, 1.0);
  CGContextFillRect(
      maskContext, CGRectMake(0, 0, maskPixelSize.width, maskPixelSize.height));
  CGImageRef invertedImageMask = CGBitmapContextCreateImage(maskContext);

  // To render the drop shadow, draw the original mask but clipped by the
  // inverted mask:
  // so that the shadow is only drawn around the edges, and not within the
  // inside of the image.
  //(IMPLEMENTATION NOTE: we draw the drop shadow in a separate pass instead of
  // just setting the
  // drop shadow when we draw the fill gradient, because otherwise a
  // semi-transparent gradient would
  // render a drop shadow underneath the translucent parts: making the result
  // appear muddy.)
  if (dropShadow) {
    CGContextSaveGState(cgContext);
    if (drawFlipped) {
      CGContextTranslateCTM(cgContext, 0.0f, contextSize.height);
      CGContextScaleCTM(cgContext, 1.0f, -1.0f);
    }

    // IMPLEMENTATION NOTE: we want to draw the drop shadow but not the image
    // that's 'causing' the shadow.
    // So, we draw that image wayyy off the top of the canvas, and offset the
    // shadow far enough that
    // it lands in the expected position.

    CGRect imageOffset = CGRectOffset(maskRect, 0, maskRect.size.height);
    CGSize shadowOffset =
        CGSizeMake(dropShadow.shadowOffset.width,
                   dropShadow.shadowOffset.height - maskRect.size.height);

    CGFloat components[dropShadow.shadowColor.numberOfComponents];
    [dropShadow.shadowColor getComponents:components];
    CGColorRef shadowColor = CGColorCreate(
        dropShadow.shadowColor.colorSpace.CGColorSpace, components);

    CGContextClipToMask(cgContext, maskRect, invertedImageMask);
    CGContextSetShadowWithColor(cgContext, shadowOffset,
                                dropShadow.shadowBlurRadius, shadowColor);
    CGContextDrawImage(cgContext, imageOffset, imageMask);

    CGColorRelease(shadowColor);

    CGContextRestoreGState(cgContext);
  }

  // Finally, render the inner region with the gradient and inner shadow (if
  // any)
  // by clipping the drawing area to the regular mask.
  if (gradient || innerShadow) {
    CGContextSaveGState(cgContext);
    if (drawFlipped) {
      CGContextTranslateCTM(cgContext, 0.0f, contextSize.height);
      CGContextScaleCTM(cgContext, 1.0f, -1.0f);
    }
    CGContextClipToMask(cgContext, maskRect, imageMask);

    if (gradient) {
      [gradient drawInRect:drawRect angle:270.0];
    }

    if (innerShadow) {
      // See dropShadow note above about offsets.
      CGRect imageOffset = CGRectOffset(maskRect, 0, maskRect.size.height);
      CGSize shadowOffset =
          CGSizeMake(innerShadow.shadowOffset.width,
                     innerShadow.shadowOffset.height - maskRect.size.height);

      CGFloat components[innerShadow.shadowColor.numberOfComponents];
      [innerShadow.shadowColor getComponents:components];
      CGColorRef shadowColor = CGColorCreate(
          innerShadow.shadowColor.colorSpace.CGColorSpace, components);

      CGContextSetShadowWithColor(cgContext, shadowOffset,
                                  innerShadow.shadowBlurRadius, shadowColor);
      CGContextDrawImage(cgContext, imageOffset, invertedImageMask);

      CGColorRelease(shadowColor);
    }
    CGContextRestoreGState(cgContext);
  }

  CGContextRelease(maskContext);
  CGImageRelease(imageMask);
  CGImageRelease(invertedImageMask);
}

@end

@implementation NSImage (AIImageDrawingAdditions)

// Draw this image in a rect, tiling if the rect is larger than the image
- _Void_ tileInRect:(NSRect)rect {
  NSSize size = [self size];
  NSRect destRect =
      NSMakeRect(rect.origin.x, rect.origin.y, size.width, size.height);
  CGFloat top = rect.origin.y + rect.size.height;
  CGFloat right = rect.origin.x + rect.size.width;

  // Tile vertically
  while (destRect.origin.y < top) {
    // Tile horizontally
    while (destRect.origin.x < right) {
      NSRect sourceRect = NSMakeRect(0, 0, size.width, size.height);

      // Crop as necessary
      if ((destRect.origin.x + destRect.size.width) > right) {
        sourceRect.size.width -=
            (destRect.origin.x + destRect.size.width) - right;
      }

      if ((destRect.origin.y + destRect.size.height) > top) {
        sourceRect.size.height -=
            (destRect.origin.y + destRect.size.height) - top;
      }

      // Draw and shift
      [self compositeToPoint:destRect.origin
                    fromRect:sourceRect
                   operation:NSCompositeSourceOver];
      destRect.origin.x += destRect.size.width;
    }

    destRect.origin.y += destRect.size.height;
  }
}

- (NSImage*) imageByScalingToSize:(NSSize)size {
  return ([self imageByScalingToSize:size
                            fraction:1.0f
                           flipImage:NO
                      proportionally:YES
                      allowAnimation:YES]);
}

- (NSImage*) imageByFadingToFraction:(CGFloat)delta {
  return [self imageByScalingToSize:[self size]
                           fraction:delta
                          flipImage:NO
                     proportionally:NO
                     allowAnimation:YES];
}

- (NSImage*) imageByScalingToSize:(NSSize)size fraction:(CGFloat)delta {
  return [self imageByScalingToSize:size
                           fraction:delta
                          flipImage:NO
                     proportionally:YES
                     allowAnimation:YES];
}

- (NSImage*) imageByScalingForMenuItem {
  return [self imageByScalingToSize:NSMakeSize(16, 16)
                           fraction:1.0f
                          flipImage:NO
                     proportionally:YES
                     allowAnimation:NO];
}

- (NSImage*) imageByScalingToSize:(NSSize)size
                         fraction:(CGFloat)delta
                        flipImage:(BOOL)flipImage
                   proportionally:(BOOL)proportionally
                   allowAnimation:(BOOL)allowAnimation {
  NSSize originalSize = [self size];

  // Proceed only if size or delta are changing
  if ((NSEqualSizes(originalSize, size)) && (delta == 1.0) && !flipImage) {
    return [self copy];

  } else {
    NSImage *newImage;
    NSRect newRect;

    // Scale proportionally (rather than stretching to fit) if requested and
    // needed
    if (proportionally && (originalSize.width != originalSize.height)) {
      if (originalSize.width > originalSize.height) {
        // Give width priority: Make the height change by the same proportion as
        // the width will change
        size.height = originalSize.height * (size.width / originalSize.width);
      } else {
        // Give height priority: Make the width change by the same proportion as
        // the height will change
        size.width = originalSize.width * (size.height / originalSize.height);
      }
    }

    newRect = NSMakeRect(0.0f, 0.0f, size.width, size.height);
    newImage = [NSImage.alloc initWithSize:size];

    if (flipImage) {
      [newImage setFlipped:YES];
    }

    NSIR *bestRep;

    if (allowAnimation &&
        (bestRep =
             [self bestRepresentationForRect:NSMakeRect(0, 0, self.size.width,
                                                        self.size.height)
                                     context:nil
                                       hints:nil]) &&
        [bestRep isKindOfClass:[NSBIR class]] && (delta == 1.0) &&
        ([[(NSBIR*) bestRep
             valueForProperty:NSImageFrameCount] intValue] > 1)) {

      // We've got an animating file, and the current alpha is fine.  Just copy
      // the representation.
      NSMutableData *GIFRepresentationData = nil;

      unsigned frameCount = [[(NSBIR*) bestRep
          valueForProperty:NSImageFrameCount] intValue];

      if (!frameCount) {
        frameCount = 1;
      }

      NSMutableArray *images = [NSMutableArray array];

      for (unsigned i = 0; i < frameCount; i++) {
        // Set current frame
        [(NSBIR*) bestRep
            setProperty:NSImageCurrentFrame
              withValue:[NSNumber numberWithUnsignedInt:i]];

        [newImage lockFocus];

        [self drawInRect:newRect
                fromRect:NSMakeRect(0.0f, 0.0f, originalSize.width,
                                    originalSize.height)
               operation:NSCompositeCopy
                fraction:delta];

        [newImage unlockFocus];

        // Add frame representation
        [images addObject:[NSBIR
                              imageRepWithData:[newImage TIFFRepresentation]]];
      }

      GIFRepresentationData = [NSMutableData
          dataWithData:
              [NSBIR
                  representationOfImageRepsInArray:images
                                         usingType:NSGIFFileType
                                        properties:
                                            [self
                                                GIFPropertiesForRepresentation:
                                                    (NSBIR *)
                                                bestRep]]];

      // Write GIF Extension Blocks
      [self writeGIFExtensionBlocksInData:GIFRepresentationData
                         forRepresenation:(NSBIR*) bestRep];

      // You must release before you re-allocate. The data is retained in an
      // autorelease loop in the images array.
      //			[newImage release];

      newImage = [NSImage.alloc initWithData:GIFRepresentationData];
    } else {
      [newImage lockFocus];
      // Highest quality interpolation
      [[NSGraphicsContext currentContext]
          setImageInterpolation:NSImageInterpolationHigh];

      [self drawInRect:newRect
              fromRect:NSMakeRect(0.0f, 0.0f, originalSize.width,
                                  originalSize.height)
             operation:NSCompositeCopy
              fraction:delta];

      [newImage unlockFocus];
    }

    return newImage;
  }
}

- (NSImage*) imageByFittingInSize:(NSSize)size {
  return ([self imageByFittingInSize:size
                            fraction:1.0f
                           flipImage:NO
                      proportionally:YES
                      allowAnimation:YES]);
}

- (NSImage*) imageByFittingInSize:(NSSize)size
                         fraction:(CGFloat)delta
                        flipImage:(BOOL)flipImage
                   proportionally:(BOOL)proportionally
                   allowAnimation:(BOOL)allowAnimation {
  NSSize originalSize = [self size];
  NSSize scaleSize = size;
  NSSize fitSize = size;

  // Proceed only if size or delta are changing
  if ((NSEqualSizes(originalSize, size)) && (delta == 1.0) && !flipImage) {
    return [self copy];

  } else {
    // Scale proportionally (rather than stretching to fit) if requested and
    // needed
    if (proportionally && (originalSize.width != originalSize.height)) {
      if (originalSize.width > originalSize.height) {
        // Give width priority: Make the height change by the same proportion as
        // the width will change
        scaleSize.height =
            originalSize.height * (size.width / originalSize.width);
      } else {
        // Give height priority: Make the width change by the same proportion as
        // the height will change
        scaleSize.width =
            originalSize.width * (size.height / originalSize.height);
      }
    }

    // Fit
    if (proportionally && (originalSize.width != originalSize.height)) {
      if (originalSize.width > originalSize.height) {
        // Give width priority: Make the height change by the same proportion as
        // the width will change
        fitSize.height =
            originalSize.height * (size.width / originalSize.width);
      } else {
        // Give height priority: Make the width change by the same proportion as
        // the height will change
        fitSize.width =
            originalSize.width * (size.height / originalSize.height);
      }
    }

    NSRect scaleRect =
        NSMakeRect(0.0f, 0.0f, scaleSize.width, scaleSize.height);
    NSPoint fitFromPoint = NSMakePoint((size.width - scaleSize.width) / 2.0f,
                                       (size.height - scaleSize.height) / 2.0f);

    NSImage *newImage = [NSImage.alloc initWithSize:size];
    NSImage *scaledImage = [NSImage.alloc initWithSize:scaleSize];

    if (flipImage) {
      [newImage setFlipped:YES];
    }

    NSIR *bestRep;

    if (allowAnimation &&
        (bestRep =
             [self bestRepresentationForRect:NSMakeRect(0, 0, self.size.width,
                                                        self.size.height)
                                     context:nil
                                       hints:nil]) &&
        [bestRep isKindOfClass:[NSBIR class]] && (delta == 1.0) &&
        ([[(NSBIR*) bestRep
             valueForProperty:NSImageFrameCount] intValue] > 1)) {

      // We've got an animating file, and the current alpha is fine.  Just copy
      // the representation.
      NSMutableData *GIFRepresentationData = nil;

      unsigned frameCount = [[(NSBIR*) bestRep
          valueForProperty:NSImageFrameCount] intValue];

      if (!frameCount) {
        frameCount = 1;
      }

      NSMutableArray *images = [NSMutableArray array];

      for (unsigned i = 0; i < frameCount; i++) {
        // Set current frame
        [(NSBIR*) bestRep
            setProperty:NSImageCurrentFrame
              withValue:[NSNumber numberWithUnsignedInt:i]];

        [scaledImage lockFocus];

        // Scale
        [self drawInRect:scaleRect
                fromRect:NSMakeRect(0.0f, 0.0f, originalSize.width,
                                    originalSize.height)
               operation:NSCompositeCopy
                fraction:delta];

        [scaledImage unlockFocus];
        [newImage lockFocus];

        // Fit
        [scaledImage drawAtPoint:fitFromPoint
                        fromRect:NSMakeRect(0.0f, 0.0f, newImage.size.width,
                                            newImage.size.height)
                       operation:NSCompositeCopy
                        fraction:delta];

        [newImage unlockFocus];

        // Add frame representation
        [images addObject:[NSBIR
                              imageRepWithData:[newImage TIFFRepresentation]]];
      }

      GIFRepresentationData = [NSMutableData
          dataWithData:
              [NSBIR
                  representationOfImageRepsInArray:images
                                         usingType:NSGIFFileType
                                        properties:
                                            [self
                                                GIFPropertiesForRepresentation:
                                                    (NSBIR *)
                                                bestRep]]];

      // Write GIF Extension Blocks
      [self writeGIFExtensionBlocksInData:GIFRepresentationData
                         forRepresenation:(NSBIR*) bestRep];

      // Release before you re-allocate.
      //			[newImage release];

      newImage = [NSImage.alloc initWithData:GIFRepresentationData];
    } else {
      [scaledImage lockFocus];
      // Highest quality interpolation
      [[NSGraphicsContext currentContext]
          setImageInterpolation:NSImageInterpolationHigh];

      // Scale
      [self drawInRect:scaleRect
              fromRect:NSMakeRect(0.0f, 0.0f, originalSize.width,
                                  originalSize.height)
             operation:NSCompositeCopy
              fraction:delta];

      [scaledImage unlockFocus];
      [newImage lockFocus];

      // Fit
      [scaledImage drawAtPoint:fitFromPoint
                      fromRect:NSMakeRect(0.0f, 0.0f, newImage.size.width,
                                          newImage.size.height)
                     operation:NSCompositeCopy
                      fraction:delta];

      [newImage unlockFocus];
    }

    //		[scaledImage release];

    return newImage;
  }
}

// Fun drawing toys
// Draw an image, altering and returning the available destination rect
- (NSRect)drawInRect:(NSRect)rect
              atSize:(NSSize)size
            position:(IMAGE_POSITION)position
            fraction:(CGFloat)inFraction {
  // We use our own size for drawing purposes no matter the passed size to avoid
  // distorting the image via stretching
  NSSize ownSize = [self size];

  // If we're passed a 0,0 size, use the image's size for the area taken up by
  // the image
  // (which may exceed the actual image dimensions)
  if (size.width == 0 || size.height == 0) {
    size = ownSize;
  }

  NSRect drawRect =
      [self rectForDrawingInRect:rect atSize:size position:position];

  // If we are drawing in a rect wider than we are, center horizontally
  if (drawRect.size.width > ownSize.width) {
    drawRect.origin.x += (drawRect.size.width - ownSize.width) / 2;
    drawRect.size.width -= (drawRect.size.width - ownSize.width);
  }

  // If we are drawing in a rect higher than we are, center vertically
  if (drawRect.size.height > ownSize.height) {
    drawRect.origin.y += (drawRect.size.height - ownSize.height) / 2;
    drawRect.size.height -= (drawRect.size.height - ownSize.height);
  }

  // Draw
  [self drawInRect:drawRect
          fromRect:NSMakeRect(0, 0, ownSize.width, ownSize.height)
         operation:NSCompositeSourceOver
          fraction:inFraction];

  // Shift the origin if needed, and decrease the available destination rect
  // width, by the passed size
  // (which may exceed the actual image dimensions)
  if (position == IMAGE_POSITION_LEFT) {
    rect.origin.x += size.width;
  }

  rect.size.width -= size.width;

  return rect;
}

- (NSRect)rectForDrawingInRect:(NSRect)rect
                        atSize:(NSSize)size
                      position:(IMAGE_POSITION)position {
  NSRect drawRect;

  // If we're passed a 0,0 size, use the image's size
  if (size.width == 0 || size.height == 0) {
    size = [self size];
  }

  // Adjust the positioning
  switch (position) {
  case IMAGE_POSITION_LEFT:
    drawRect = NSMakeRect(rect.origin.x,
                          rect.origin.y +
                              (int)((rect.size.height - size.height) / 2.0),
                          size.width, size.height);
    break;
  case IMAGE_POSITION_RIGHT:
    drawRect = NSMakeRect(rect.origin.x + rect.size.width - size.width,
                          rect.origin.y +
                              (int)((rect.size.height - size.height) / 2.0),
                          size.width, size.height);
    break;
  case IMAGE_POSITION_LOWER_LEFT:
    drawRect = NSMakeRect(rect.origin.x,
                          rect.origin.y + (rect.size.height - size.height),
                          size.width, size.height);
    break;
  case IMAGE_POSITION_LOWER_RIGHT:
    drawRect = NSMakeRect(rect.origin.x + (rect.size.width - size.width),
                          rect.origin.y + (rect.size.height - size.height),
                          size.width, size.height);
    break;
  }

  return drawRect;
}

// General purpose draw image rounded in a NSRect.
- (NSRect)drawRoundedInRect:(NSRect)rect radius:(CGFloat)radius {
  return [self drawRoundedInRect:rect
                          atSize:NSMakeSize(0, 0)
                        position:0
                        fraction:1.0f
                          radius:radius];
}

// Perhaps if you desired to draw it rounded in the tooltip.
- (NSRect)drawRoundedInRect:(NSRect)rect
                   fraction:(CGFloat)inFraction
                     radius:(CGFloat)radius {
  return [self drawRoundedInRect:rect
                          atSize:NSMakeSize(0, 0)
                        position:0
                        fraction:inFraction
                          radius:radius];
}

// Draw an image, round the corner. Meant to replace the method above.
- (NSRect)drawRoundedInRect:(NSRect)rect
                     atSize:(NSSize)size
                   position:(IMAGE_POSITION)position
                   fraction:(CGFloat)inFraction
                     radius:(CGFloat)radius {
  NSRect drawRect;

  // We use our own size for drawing purposes no matter the passed size to avoid
  // distorting the image via stretching
  NSSize ownSize = [self size];

  // If we're passed a 0,0 size, use the image's size for the area taken up by
  // the image
  // (which may exceed the actual image dimensions)
  if (size.width == 0 || size.height == 0) {
    size = ownSize;
  }

  drawRect = [self rectForDrawingInRect:rect atSize:size position:position];

  // If we are drawing in a rect wider than we are, center horizontally
  if (drawRect.size.width > ownSize.width) {
    drawRect.origin.x += (drawRect.size.width - ownSize.width) / 2;
    drawRect.size.width -= (drawRect.size.width - ownSize.width);
  }

  // If we are drawing in a rect higher than we are, center vertically
  if (drawRect.size.height > ownSize.height) {
    drawRect.origin.y += (drawRect.size.height - ownSize.height) / 2;
    drawRect.size.height -= (drawRect.size.height - ownSize.height);
  }

  // Create Rounding.
  [NSGraphicsContext saveGraphicsState];
  NSBezierPath *clipPath =
      [NSBezierPath bezierPathWithRoundedRect:drawRect radius:radius];
  [clipPath addClip];

  // Draw
  [self drawInRect:drawRect
          fromRect:NSMakeRect(0, 0, ownSize.width, ownSize.height)
         operation:NSCompositeSourceOver
          fraction:inFraction];

  [NSGraphicsContext restoreGraphicsState];

  // Shift the origin if needed, and decrease the available destination rect
  // width, by the passed size
  // (which may exceed the actual image dimensions)
  if (position == IMAGE_POSITION_LEFT) {
    rect.origin.x += size.width;
  }

  rect.size.width -= size.width;

  return rect;
}

@end

//#import "AIBezierPathAdditions.h"

//@implementation NSImage (AIImageDrawingAdditions)
//@end

@interface NSImage (AIImageAdditions_PRIVATE)

- (NSBIR*) bitmapRep;

@end

@implementation NSImage (AIImageAdditions)

+ (NSImage*) imageNamed:(NSString*) name
               forClass:(Class)inClass
             loadLazily:(BOOL)flag {
  NSBundle *ownerBundle;
  NSString *imagePath;
  NSImage *image;

  // Get the bundle
  ownerBundle = [NSBundle bundleForClass:inClass];

  // Open the image
  imagePath = [ownerBundle pathForImageResource:name];

  if (flag) {
    image = [NSImage.alloc initByReferencingFile:imagePath];
  } else {
    image = [NSImage.alloc initWithContentsOfFile:imagePath];
  }

  return image;
}

// Returns an image from the owners bundle with the specified name
+ (NSImage*) imageNamed:(NSString*) name forClass:(Class)inClass {
  return [self imageNamed:name forClass:inClass loadLazily:NO];
}

+ (NSImage*) imageForSSL {
  static NSImage *SSLIcon = nil;

  if (!SSLIcon) {
    NSBundle *securityInterfaceFramework =
        [NSBundle bundleWithIdentifier:@"com.apple.securityinterface"];

    if (!securityInterfaceFramework) {
      securityInterfaceFramework = [NSBundle
          bundleWithPath:
              @"/System/Library/Frameworks/SecurityInterface.framework"];
    }

    SSLIcon = [NSImage.alloc
        initByReferencingFile:[securityInterfaceFramework
                                  pathForImageResource:@"CertSmallStd"]];
  }

  return SSLIcon;
}

+ (AIBitmapImageFileType)fileTypeOfData:(NSData*) inData {
  const char *data = [inData bytes];
  NSUInteger len = [inData length];
  AIBitmapImageFileType fileType = AIUnknownFileType;

  if (len >= 4) {
    if (!strncmp((char*) data, "GIF8", 4))
      fileType = AIGIFFileType;
    else if (!strncmp((char*) data, "\xff\xd8\xff",
                      3)) // 4th may be e0 through ef
      fileType = AIJPEGFileType;
    else if (!strncmp((char*) data, "\x89PNG", 4))
      fileType = AIPNGFileType;
    else if (!strncmp((char*) data, "MM", 2) || !strncmp((char*) data, "II", 2))
      fileType = AITIFFFileType;
    else if (!strncmp((char*) data, "BM", 2))
      fileType = AIBMPFileType;
  }

  return fileType;
}

+ (NSString*) extensionForBitmapImageFileType:
                  (AIBitmapImageFileType)inFileType {
  NSString *extension = nil;

  switch (inFileType) {
  case AIUnknownFileType:
    break;
  case AITIFFFileType:
    extension = @"tif";
    break;
  case AIBMPFileType:
    extension = @"bmp";
    break;
  case AIGIFFileType:
    extension = @"gif";
    break;
  case AIJPEGFileType:
    extension = @"jpg";
    break;
  case AIPNGFileType:
    extension = @"png";
    break;
  case AIJPEG2000FileType:
    extension = @"jp2";
    break;
  }

  return extension;
}

// Create and return an opaque bitmap image rep, replacing transparency with
// [NSColor whiteColor]
- (NSBIR*) opaqueBitmapImageRep {
  NSImage *tempImage = nil;
  NSBIR *imageRep = nil;
  NSSize size = [self size];

  // Work with a temporary image so we don't modify self
  tempImage = [NSImage.alloc initWithSize:size];

  // Lock before drawing to the temporary image
  [tempImage lockFocus];

  // Fill with a white background
  [[NSColor whiteColor] set];
  NSRectFill(NSMakeRect(0, 0, size.width, size.height));

  // Draw the image
  [self compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];

  // We're done drawing
  [tempImage unlockFocus];

  // Find an NSBIR from the temporary image
  for (NSIR *rep in tempImage.representations) {
    if ([rep isKindOfClass:[NSBIR class]]) {
      imageRep = (NSBIR*) rep;
    }
  }

  // Make one if necessary
  if (!imageRep) {
    imageRep =
        [NSBIR imageRepWithData:[tempImage TIFFRepresentation]];
  }

  // 10.6 behavior: Drawing into a new image copies the display's color profile
  // in.
  // Remove the color profile so we don't bloat the image size.
  [imageRep setProperty:NSImageColorSyncProfileData withValue:nil];

  return imageRep;
}

- (NSBIR*) largestBitmapImageRep {
  // Find the biggest image
  NSBIR *bestRep = nil;
  Class NSBIRClass = [NSBIR class];
  CGFloat maxWidth = 0.0f;

  for (NSIR *rep in [self representations]) {
    if ([rep isKindOfClass:NSBIRClass]) {
      CGFloat thisWidth = [rep size].width;

      if (thisWidth >= maxWidth) {
        // Cast explanation: GCC warns about us returning an NSIR here,
        // presumably because it could be some other kind of NSIR if we
        // don't check the class.
        // Fortunately, we have such a check. This cast silences the warning.
        bestRep = (NSBIR*) rep;
        maxWidth = thisWidth;
      }
    }
  }

  // We don't already have one, so forge one from our TIFF representation.
  if (!bestRep) {
    bestRep = [NSBIR imageRepWithData:[self TIFFRepresentation]];
  }

  return bestRep;
}

- (NSData*) JPEGRepresentation {
  return [self JPEGRepresentationWithCompressionFactor:1.0f];
}

- (NSData*) JPEGRepresentationWithCompressionFactor:(float)compressionFactor {
  /// JPEG does not support transparency, but NSImage does. We need to create a non-transparent NSImage. before creating our representation or transparent parts will become black. White is preferabl
  return ([[self opaqueBitmapImageRep]
      representationUsingType:NSJPEGFileType
                   properties:
                       [NSDictionary
                           dictionaryWithObject:[NSNumber
                                                    numberWithFloat:(float)
                                                    compressionFactor]
                                         forKey:NSImageCompressionFactor]]);
}
- (NSData*) JPEGRepresentationWithMaximumByteSize:(NSUInteger)maxByteSize {
  /// JPEG does not support transparency, but NSImage does. We need to create a non-transparent NSImage. before creating our representation or transparent parts will become black. White is preferable.

  NSBIR *opaqueBitmapImageRep = [self opaqueBitmapImageRep];
  NSData *data = nil;

  for (float compressionFactor = 0.99f; compressionFactor > 0.4f;
       compressionFactor -= 0.01f) {
    data = [opaqueBitmapImageRep
        representationUsingType:NSJPEGFileType
                     properties:
                         [NSDictionary
                             dictionaryWithObject:
                                 [NSNumber numberWithFloat:compressionFactor]
                                           forKey:NSImageCompressionFactor]];
    if (data && ([data length] <= maxByteSize)) {
      break;
    } else {
      data = nil;
    }
  }

  return data;
}

- (NSData*) PNGRepresentation {
  /// PNG is easy; it supports everything TIFF does, and NSImage's PNG support is great.
  NSBIR *bitmapRep = [self largestBitmapImageRep];

  return ([bitmapRep representationUsingType:NSPNGFileType properties:nil]);
}

- (NSData*) GIFRepresentation {
  // GIF requires special treatment, as Apple doesn't allow you to save
  // animations.

  NSMutableData *GIFRepresentation = nil;
  NSBIR *bitmap = [[self representations] objectAtIndex:0];

  if (bitmap && [bitmap isKindOfClass:[NSBIR class]]) {
    unsigned frameCount =
        [[bitmap valueForProperty:NSImageFrameCount] intValue];

    if (!frameCount) {
      frameCount = 1;
    }

    NSSize size = [self size];

    if (size.width > 0 && size.height > 0) {
      NSMutableArray *images = [NSMutableArray array];

      for (unsigned i = 0; i < frameCount; i++) {
        // Set current frame
        [bitmap setProperty:NSImageCurrentFrame
                  withValue:[NSNumber numberWithUnsignedInt:i]];
        // Add frame representation
        [images addObject:[NSBIR
                              imageRepWithData:
                                  [bitmap representationUsingType:NSGIFFileType
                                                       properties:nil]]];
      }

      GIFRepresentation = [NSMutableData
          dataWithData:
              [NSBIR
                  representationOfImageRepsInArray:images
                                         usingType:NSGIFFileType
                                        properties:
                                            [self
                                                GIFPropertiesForRepresentation:
                                                    bitmap]]];

      // Write GIF Extension Blocks
      [self writeGIFExtensionBlocksInData:GIFRepresentation
                         forRepresenation:bitmap];
    }
  }

  return GIFRepresentation;
}

- (NSData*) BMPRepresentation {
  /// BMP does not support transparency, but NSImage does. We need to create a non-transparent NSImage before creating our representation or transparent parts will become black. White is preferable.

  return ([[self opaqueBitmapImageRep] representationUsingType:NSBMPFileType
                                                    properties:nil]);
}

/// @brief Returns a GIF representation for GIFs, and PNG represenation for all other types

- (NSData*) bestRepresentationByType {
  NSData *data = nil;
  NSBIR *bitmap = nil;

  if ((bitmap = [[self representations] objectAtIndex:0]) &&
      [bitmap isKindOfClass:[NSBIR class]] &&
      ([[bitmap valueForProperty:NSImageFrameCount] intValue] > 1)) {
    data = [self GIFRepresentation];
  } else {
    data = [self PNGRepresentation];
  }

  return data;
}

- (NSBIR*) getBitmap {
  [self lockFocus];

  NSSize size = [self size];
  NSRect rect = NSMakeRect(0.0f, 0.0f, size.width, size.height);
  NSBIR *bm =
      [NSBIR.alloc initWithFocusedViewRect:rect];

  [self unlockFocus];

  return bm;
}

/// @brief Retrieve an image rep with a maximum size \
    Returns the NSData of an image representation.\
    @param fileType The NSBitmapImageFileType to be outputted for sizing\
    @param maximumSize The maximum size in bytes for the image\
    @return the NSData representation using fileType

- (NSData*) representationWithFileType:(NSBitmapImageFileType)fileType
                       maximumFileSize:(NSUInteger)maximumSize {
  NSBIR *imageRep = [self largestBitmapImageRep];

  // If no rep is found, return nil.
  if (!imageRep)
    return nil;

  NSData *data = [imageRep representationUsingType:fileType properties:nil];

  // If no maximum size, return the base representation.
  if (!maximumSize)
    return data;

  // Ratio of height/width
  CGFloat ratio = (CGFloat)imageRep.pixelsHigh / (CGFloat)imageRep.pixelsWide;

  // Loop until we're small enough to fit into our max size
  while (data.length > maximumSize) {
    // New width/height using our ratio
    NSUInteger width = (imageRep.pixelsWide - 100);
    NSUInteger height = ((CGFloat)imageRep.pixelsWide - 100.0f) * ratio;

    // Create a new rep with the lowered size
    NSBIR *newImageRep = [NSBIR.alloc
        initWithBitmapDataPlanes:NULL
                      pixelsWide:width
                      pixelsHigh:height
                   bitsPerSample:imageRep.bitsPerSample
                 samplesPerPixel:imageRep.samplesPerPixel
                        hasAlpha:imageRep.hasAlpha
                        isPlanar:imageRep.isPlanar
                  colorSpaceName:NSCalibratedRGBColorSpace
                     bytesPerRow:imageRep.bytesPerRow
                    bitsPerPixel:imageRep.bitsPerPixel];

    // Draw the old rep into the new rep
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext
        setCurrentContext:[NSGraphicsContext
                              graphicsContextWithBitmapImageRep:newImageRep]];
    [imageRep drawInRect:NSMakeRect(0, 0, width, height)];
    [NSGraphicsContext restoreGraphicsState];

    // Override the old rep
    imageRep = newImageRep;

    // Grab a new representation
    data = [imageRep representationUsingType:fileType properties:nil];
  }

  return data;
}

- _Void_ writeGIFExtensionBlocksInData:(NSMutableData*) data
                     forRepresenation:(NSBIR*) bitmap {
  // GIF Application Extension Block - 0x21FF0B
  const char *GIFApplicationExtensionBlock = "\x21\xFF\x0B\x4E\x45\x54\x53\x43"
                                             "\x41\x50\x45\x32\x2E\x30\x03\x01"
                                             "\x00\x00\x00";
  // GIF Graphic Control Extension Block - 0x21F904
  NSData *GIFGraphicControlExtensionBlock =
      [NSData dataWithBytes:"\x00\x21\xF9\x04" length:4];

  NSRange blockRange;
  NSUInteger blockLocation = [data length];

  unsigned frameCount = [[bitmap valueForProperty:NSImageFrameCount] intValue];
  unsigned frameDuration;
  unsigned i = 0;

  while (!NSEqualRanges(blockRange =
                            [data rangeOfData:GIFGraphicControlExtensionBlock
                                      options:NSDataSearchBackwards
                                        range:NSMakeRange(0, blockLocation)],
                        NSMakeRange(NSNotFound, 0))) {
    // Set current frame
    [bitmap setProperty:NSImageCurrentFrame
              withValue:[NSNumber numberWithUnsignedInt:i++]];

    // Frame Duration flag, 1/100 sec
    frameDuration =
        [[bitmap valueForProperty:NSImageCurrentFrameDuration] floatValue] *
        100;

    blockLocation = blockRange.location;

    // Replace bytes in Graphic Extension Block
    [data replaceBytesInRange:NSMakeRange(NSMaxRange(blockRange) + 1, 2)
                    withBytes:&frameDuration
                       length:2];

    // Write Application Extension Block
    if (i == frameCount) {
      [data replaceBytesInRange:NSMakeRange(blockRange.location + 1, 0)
                      withBytes:GIFApplicationExtensionBlock
                         length:strlen(GIFApplicationExtensionBlock) + 3];
    }

    frameDuration = 0;
  }
}

- (NSDictionary*) GIFPropertiesForRepresentation:(NSBIR*) bitmap {
  NSNumber *frameCount = [bitmap valueForProperty:NSImageFrameCount];

  if (!frameCount) {
    frameCount = [NSNumber numberWithUnsignedInt:1];
  }

  // Setting NSImageLoopCount & NSImageCurrentFrameDuration through -
  // NSDictionary *properties - is not allowed!
  return [NSDictionary
      dictionaryWithObjects:
          [NSArray arrayWithObjects:frameCount,
                                    [NSNumber numberWithUnsignedInt:0], nil]
                    forKeys:[NSArray arrayWithObjects:NSImageFrameCount,
                                                      NSImageCurrentFrame,
                                                      nil]];
}

@end


@implementation NSImage (Base64Encoding)

NSS *kXML_Base64ReferenceAttribute = @"xlink:href=\"data:;base64,";

+ _Pict_ imageWithBase64EncodedString:(NSS*) inString {
  return [self.alloc initWithBase64EncodedString:inString];
}
- initWithBase64EncodedString:(NSS*) inBase64String {
  if (!inBase64String)
    return nil;

  NSSize tempSize = {100, 100};
  NSData *data = nil;
  NSIR *imageRep = nil;
  if (!(self = [self initWithSize:tempSize]))
    return nil;
  // Now, interpret the inBase64String.
  return (data = [NSData dataWithBase64String:inBase64String]) ?
         // Create an image representation from the data.
         (imageRep = [NSBIR imageRepWithData:data])
         ?
         // Set the real size of the image and add the representation.
         [self setSize:imageRep.size],
         [self addRepresentation:imageRep], self : nil : nil;
}
- (NSString*) base64EncodingWithFileType:(NSBitmapImageFileType)inFileType {
  __block NSBIR *imageRep = nil;
  NSData *t_filetype_data = nil;
  // Look for an existing representation in the NSBIR class.
  [self.representations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx,
                                                     BOOL *stop) {
      imageRep = [obj isKindOfClass:NSBIR.class] ? obj : imageRep;
      if (imageRep)
        *stop = YES;
  }];
  imageRep =
      imageRep ?: [NSBIR imageRepWithData:self.TIFFRepresentation];
  // Need to make a NSBIR for so we can get whatever the caller wants
  // later.
  imageRep ? [self addRepresentation:imageRep] : nil;
  // Get the image data as whatever type the caller wants.
  t_filetype_data =
      imageRep ? [imageRep representationUsingType:inFileType
                                        properties:@{NSImageInterlaced : @NO}]
               : t_filetype_data;
  // Now, convert the t_filetype_data into Base64 encoding.
  return t_filetype_data ? [t_filetype_data base64String]
                         : nil; // base64EncodingWithLineLength:120] : nil;
}

@end

//  AZFavIconOp

@interface AZImageCache () @property(assign) dispatch_queue_t queue; @end

@implementation AZImageCache

SYNTHESIZE_SINGLETON_FOR_CLASS(AZImageCache, sharedCache);

- init { SUPERINIT;

  _queue          = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
  _cacheDirectory = [AZCACHEDIR withPath:[APP_NAME withString:@"_ImageCache"]];
  MAKEDIR_IFNEEDED(_cacheDirectory);
  return self;
}

- (void) removeAllObjects {

  [AZFILEMANAGER removeItemAtPath:_cacheDirectory error:nil];
  MAKEDIR(_cacheDirectory);
  [super removeAllObjects];
}

- _Pict_ imageForKey:(NSS*) key { if (![self hasPropertyForKVCKey:@"key"] || !key) return nil;

  NSIMG *image = [self objectForKey:key]; return image ?: ({ NSS *path = [self pathForImage:image key:key];

    if ((image = [NSIMG.alloc initWithContentsOfFile:path])) [self setObject:image forKey:key];  image;  });
}

+ (void) cacheImage:(NSIMG*)i { [i saveAs:[self.sharedCache pathForImage:i key:i.name ?: NSS.randomWord]]; }

- (void) setImage:(NSIMG*)i forKey:(NSS*)k { IF_RETURNV(!i || !k);

  [self setObject:i forKey:k];
  dispatch_async(_queue, ^{ [i saveAs:[self pathForImage:i key:k]];  }); // path

//  NSLog(@"%@", path); NSData *imageD = NSIMGPNGRepresentation(image);
//  if (imageD) [imageData writeToFile:path atomically:NO];
}

#pragma mark - Private Methods

- (NSS*) pathForImage:(NSIMG*) image key:(NSS*) key {

  NSS *path = key;
#if TARGET_OS_IPHONE
  if (image.scale == 2.0f) path = [key stringByAppendingString:@"@2x"];
#endif
  return [_cacheDirectory withPath:[path withExtIfMissing:@"png"]];
}

@end

NSString *stringForBrightness( CGF brightness )	{	return
	brightness < ( 19.0 / 255) ? @"&" 	: brightness < ( 50.0 / 255) 	? @"8" : brightness < ( 75.0 / 255) ? @"0" : brightness < (100.0 / 255) ? @"$" :
	brightness < (130.0 / 255) ? @"2" 	: brightness < (165.0 / 255) 	? @"1" : brightness < (180.0 / 255) ? @"|" : brightness < (200.0 / 255) ? @";" :
	brightness < (218.0 / 255) ? @":" 	: brightness < (229.0 / 255) 	? @"'" :																						  @" " ;
}
@implementation NSImage(ASCII)
- (NSS*)asciiArtWithWidth:(NSI)width height:(NSI)height	{
	if (!width || !height) return nil;
	NSMS *string = NSMS.new;

	NSImage *tempImage = [NSIMG imageWithSize:NSMakeSize(width, height) drawnUsingBlock:^{
		[self drawInRect:AZRectBy(width,height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	}];

	NSBitmapImageRep *bitmapImage = [NSBitmapImageRep.alloc initWithData:tempImage.TIFFRepresentation];

	for (int i = 0; i < height; i++) {
		for (int j = 0; j < width; j++)[string appendString:stringForBrightness([[bitmapImage colorAtX:j y:i] colorUsingColorSpaceName:NSDeviceWhiteColorSpace].whiteComponent)];
		[string appendString:@"\n"];
	}
	return string;
}
@end
*/

#if MAC_ONLY

///	 from http://developer.apple.com/technotes/tn2005/tn2143.html

CGImageRef CreateCGImageFromData(NSData* data) {

  CGImageRef imageRef = NULL;
  CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
  if(sourceRef) {
    imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    CFRelease(sourceRef);
  }

  return imageRef;
}

/*
@implementation NSImage (AtoZDrawBlock)

+ _Pict_ imageWithSize: _Size_ s drawnUsingBlock:(Blk)dBlk {

  if (NSEqualSizes(s, NSZeroSize)) return self.new;

  NSImage *newer = [self imageWithSize:s named:@"AtoZNSImageDrawBlockImage"];

  if (!newer) return self.new;

  [newer lockFocus]; dBlk(); [newer unlockFocus]; return newer;
}

+ _Pict_  imageInFrame: _Rect_ f withBlock:(RBlk)blk {

  NSR originRect = AZRectFromSize(f.size);
  NSSZ s = originRect.size;
  NSIMG *newImg =
      [self imageWithSize:s named:@"AtoZNSImageDrawBlockImageWithFrame"];
  [newImg lockFocus];
  CLANG_IGNORE(-Wunused - value) blk(originRect);
  CLANG_POP;
  [newImg unlockFocus];
  return newImg;
}

@end

JREnumDefine(AIBitmapImageFileType);

*/
static void BitmapReleaseCallback(void *info, const void *data, size_t size) {
  __unused id bir = (__bridge_transfer NSBIR*) info;
}


@implementation Pict (MacOnly)

/*
+ _Pict_ isometricShelfInRect: _Rect_ rect { return [self isometricShelfInRect:rect color:[NSC r:.58 g:.81 b:.782 a:1.]]; }

+ _Pict_ isometricShelfInRect: _Rect_ rect color: _Colr_ c {

  return [self imageWithSize:(AZScaleRect(rect, .5)).size drawnUsingBlock:^{

          [NSGraphicsContext state:^{
              [NSGC.currentContext
                  setImageInterpolation:NSImageInterpolationHigh];
              CGF height = rect.size.height - 1.0f;
              CGF width = rect.size.width - 1.0f;
              CGF pcp = 10.0f;
              CGF shelfH = 10.0f; // shelf Height
              NSBP *path = NSBP.new;
              path.lineJoinStyle = NSRoundLineJoinStyle;
              [path moveToPoint:(NSP) {0, shelfH}];
              [path lineToPoint:(NSP) {width, shelfH}];
              [path lineToPoint:(NSP) {width - pcp, height}];
              [path lineToPoint:(NSP) {pcp, height}];
              [path fill];
              [[NSG gradientFrom:[c colorWithBrightnessOffset:-.4] to:c]
                  drawInBezierPath:path
                             angle:90.0f];
              //			  [NSC r:0.85f g:0.66f b:0.45f a:1.0f] to:[NSC r:0.78f
              // g:0.61f b:0.42f a:1.0f]]drawInBezierPath:path angle:90.0f];
              [[NSG gradientFrom:[c colorWithBrightnessOffset:-1]
                              to:[c colorWithBrightnessOffset:-.5]]
                  drawInBezierPath:[NSBezierPath
                                       bezierPathWithRect:NSMakeRect(0.0f, 0.0f,
                                                                     width,
                                                                     shelfH)]
                             angle:90.0f];
              // [NSC r:0.29f g:0.16f b:0.04f a:1.0f] to:[NSC r:0.48f g:0.30f
              // b:0.16f a:1.0f]] ;
              //[[NSG gradientFrom: [NSC r:0.29f g:0.16f b:0.04f a:1.0f] to:[NSC
              // r:0.48f g:0.30f b:0.16f a:1.0f]] drawInBezierPath:[NSBezierPath
              // bezierPathWithRect:NSMakeRect(0.0f, 0.0f, width, shelfH)]
              // angle:90.0f];
          }];
      }];
}


+ _Pict_ imageWithBitmapRep:(NSBIR*)rep { if(!rep) return nil; NSIMG*image = NSImage.new;

  return [image addRepresentation: rep], image;
}
- (NSIR*) representationOfSize:(NSSZ)theSize {
  NSA *reps = [self representations];
  int i;
  for (i = 0; i < (int)[reps count]; i++)
    if (NSEqualSizes([(NSBIR*) reps[i] size], theSize))
      return reps[i];
  return nil;
}
- (NSIR*) bestRepresentationForSize:(NSSZ)theSize {
  NSIR *bestRep = [self representationOfSize:theSize];
  //[self setCacheMode:NSImageCacheNever];
  if (bestRep) {

    //	QSLog(@"getRep? %f", theSize.width);
    return bestRep;

  } else {
    //	QSLog(@"getRex? %f", theSize.width);
  }
  NSA *reps = [self representations];
  // if (theSize.width == theSize.height) {
  // ***warning   * handle other sizes
  float repDistance = 65536.0;
  // ***warning   * this is totally not the highest, but hey...
  NSIR *thisRep;
  float thisDistance;
  int i;
  for (i = 0; i < (int)[reps count]; i++) {
    thisRep = reps[i];
    thisDistance = MIN(theSize.width - [thisRep size].width,
                       theSize.height - [thisRep size].height);

    if (repDistance < 0 && thisDistance > 0)
      continue;
    if (ABS(thisDistance) < ABS(repDistance) ||
        (thisDistance < 0 && repDistance > 0)) {
      repDistance = thisDistance;
      bestRep = thisRep;
    }
  }
  /// QSLog(@"   Rex? %@", bestRep);
  return bestRep =
             bestRep
                 ? bestRep
                 : [self bestRepresentationForRect:AZMakeRectFromSize(theSize)
                                           context:AZGRAPHICSCTX
                                             hints:nil]; //   QSLog(@"unable to
                                                         // find reps %@",
                                                         // reps);
  return nil;
}


//- (NSBitmapImageRep*) bitmap;
//@prop_RO NSBIR * quantizerRepresentation;
//- (NSIMG*) coloredWithColor:		(NSC*) inColor	composite:(NSCompositingOperation)comp;

@end

@implementation NSImage (CGImageConversion)

- (NSBIR*) bitmap   {
  // returns a 32-bit bitmap rep of the receiver, whatever its original format.
  // The image rep is not added to the image.
  NSSZ size = [self size];
  int rowBytes = ((int)(ceil(size.width)) * 4 + 0x0000000F) &
                 ~0x0000000F; // 16-byte aligned
  int bps = 8, spp = 4, bpp = bps * spp;

  // NOTE: These settings affect how pixels are converted to NSColors
  NSBIR *imageRep =
      [NSBIR.alloc initWithBitmapDataPlanes:nil
                                            pixelsWide:size.width
                                            pixelsHigh:size.height
                                         bitsPerSample:bps
                                       samplesPerPixel:spp
                                              hasAlpha:YES
                                              isPlanar:NO
                                        colorSpaceName:NSCalibratedRGBColorSpace
                                          bitmapFormat:NSAlphaFirstBitmapFormat
                                           bytesPerRow:rowBytes
                                          bitsPerPixel:bpp];

  if (!imageRep)
    return nil;

  NSGraphicsContext *imageContext =
      [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep];

  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext setCurrentContext:imageContext];
  [self drawAtPoint:NSZeroPoint
           fromRect:NSZeroRect
          operation:NSCompositeCopy
           fraction:1.0];
  [NSGraphicsContext restoreGraphicsState];

  return imageRep;
}

- (CGIREF) cgImage  {
  NSBIR *bm = [self bitmap]; // data provider will release this
  int rowBytes, width, height;

  rowBytes = [bm bytesPerRow];
  width = [bm pixelsWide];
  height = [bm pixelsHigh];

  CGDataProviderRef provider =
      CGDataProviderCreateWithData((__bridge void*) bm, [bm bitmapData],
                                   rowBytes * height, BitmapReleaseCallback);
  CGColorSpaceRef colorspace =
      CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
  CGBitmapInfo bitsInfo = kCGImageAlphaLast;

  CGImageRef img =
      CGImageCreate(width, height, 8, 32, rowBytes, colorspace, bitsInfo,
                    provider, NULL, NO, kCGRenderingIntentDefault);

  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorspace);

  return img;
}
*/
@end

//@interface NSImageView (AtoZ)
//+(NSIV*)imageViewWithImage:(NSIMG*)img ;
//+(void) addImageViewWithImage:(NSIMG*)img toView:(NSV*)v;
//@end
//
//@interface NSGraphicsContext (AtoZ)
//+ (void) addNoiseToContext;
//@end


#endif


