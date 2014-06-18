
#import "AtoZ.h"
#import "AssetCollection.h"

JREnumDefine(AssetType);

static NSArray* extensionsForAssetType(AssetType type) {
 return   type == AssetTypeBASH   ? @[@"sh"]
        :	type == AssetTypeJS     ? @[@"js"]
        : type == AssetTypeCSS    ? @[@"css"]
        :	type == AssetTypeHTML5 	? @[@"shtml", @"html"]
        :	type == AssetTypePHP    ? @[@"php"]
        :	type == AssetTypeObjC 	? @[@"m"]
        :	type == AssetTypeTXT    ? @[@"txt", @"rtf"] : nil;
}

@implementation Asset
+ (instancetype) test {
	NSS *sampleJS 	= @"function myFunction() { $('#h01').attr('style','color:red').html('Hello jQuery'); } $(document).ready(myFunction);";
	Asset *n 		= [self instanceOfType:AssetTypeJS withPath:nil orContents:sampleJS printInline:YES];
	return n;
}
+ (instancetype) instanceOfType:(AssetType)type withPath:(NSS*)path orContents:(NSS*)contents printInline:(BOOL)isit {

	Asset *n        = self.instance;
	n.assetType     = type == AssetTypeNotFound ? AssetTypeUNKNOWN : type;
	n.path          = path;
	n.printInline 	= path == nil || isit ?: NO;
	n.contents      = contents;
	NSS *apath      = @keypath(NSIMG.monoIcons, first);
	return n;
}
- (void) setUp 	{  _active = @(NSOffState); _priority = @(0); }
- (NSS*) markup	{

	return
	_assetType == AssetTypeCSS ? 	_printInline ? $(@"<style type='text/css'>%@</style>",self.contents)
										:	_path 		 ? $(@"<link type='text/css' rel='stylesheet' href='%@'>",_path)
: 	_assetType == AssetTypeJS  ? 	_printInline ? $(@"<script>%@</sscript>",self.contents)
										:	$(@"<script src='%@'></sscript>",_path) : nil : nil;
}
//	return $(@"<%@ src='%@'></%@>",  self.path, assetStringValue[self.assetType]);

- (NSS*) cssInline 	{ return $(@"<style>\n%@\n</style>\n", self.contents); 		}
- (NSS*) cssTag 		{ return $(@"<link href='%@' />\n", self.path); 				}
- (NSS*) jsInline 	{ return $(@"<script>\n%@\n</sscript>\n", self.contents); 	}
- (NSS*) jsTag	 		{ return $(@"<script src=%@</script>\n", self.path); 	}
@end

@implementation AssetController
//+ (instancetype) shared			  {  __strong static AssetController *shared = nil;   static dispatch_once_t uno;
//
//  dispatch_once(&uno, ^{   shared 			 = [[self _alloc] _init];
//												shared.content = shared.assets = NSMA.new;  	}); return shared;
//}
//+ (id) allocWithZone:(NSZone*)z { return [self shared];              }
//+ (id) alloc                    { return [self shared];              }
- (id) init                     {
  if (!(self = super.init)) return nil;
  _content = NSMA.new;
  return self;
}

//+ (id)_alloc                    { return [super allocWithZone:NULL]; }
//- (id)_init                     { return [super init];               }

@end
@implementation AssetCollection { NSMA *assets; }

+ (instancetype) instanceWithFolder:(NSS*)path matchingType:(AssetType)fileType printInline:(BOOL)isit{

  AssetCollection *new = self.class.new;
  [new addFolder:path.stringByStandardizingPath matchingType:fileType printInline:isit];
  return new;
}

- (void) addFolder: (NSS*)path matchingType:(AssetType)fileType	printInline:(BOOL)printI {


	NSA * ext =  extensionsForAssetType(fileType);
	NSError *error;
	NSA* filed = [AZFILEMANAGER contentsOfDirectoryAtPath:path error:&error];
	if (error) return;
  filed = [filed filter:^BOOL(id object) { return 	[ext containsObject:[object pathExtension]]; }];
  AZLOG(filed);
  [filed do:^(id obj) {

    [self addObject://insertObject:
          [Asset instanceOfType:fileType withPath:obj orContents:nil printInline:printI]];
//       inAssetsAtIndex:self.assets.count];
  }];
//	NSLog(@"folders: %@   assets:%@", _folders, _assets);
}

//- (NSUI) countOfAssets 											{	return self.assets.count; 					  }
//
//-   (id) objectInAssetsAtIndex:(NSUI)index 							{	return self.assets[index];	 				  }
//
//- (void) removeObjectFromAssetsAtIndex:(NSUI)index 				{ 	[self.assets removeObjectAtIndex:index];		  }
//
//- (void) insertObject:(Asset*)todo inAssetsAtIndex:(NSUI)index {	[self.assets insertObject:todo atIndex:index]; }

@end

@implementation AssetTypeTransformer

+(Class)transformedValueClass {
	return NSString.class;
}

-(id)transformedValue:(id)value {
//	AssetType t = [value intValue];
	return @"";// assetStringValue[[value intValue]];
//	if (quality == kQualityBest)
//		return @"Best";
//	else if (quality == kQualityWorst)
//		return @"Worst";
//
	return nil;
}
@end


// To convert enum to string:	NSString *str = FormatType_toString[theEnumValue];
//NSString * const assetStringValue[] = {  @"js",@"css",@"html",@"php",@"sh",@"m",@"txt",@"n/a" },
//			* const assetTagName[] = {  @"script",@"style",@"div",@"php",@"sh",@"m",@"txt",@"n/a" };




//@implementation NSString (AssetType)
////- (AssetType)assetFromString	{	static NSD *types = nil;  	return types = types  ?:
////
////	@{	@"js" : @(JS), @"html"	: @(HTML5), 	@"css"	: @(CSS),	@"php" : @(PHP), 	@"sh" : @(BASH),		@"m"  	: @(ObjC),	@"txt"	: @(TXT),	@"n/a" :@(UNKNOWN) },  (AssetType)[types[self] unsignedIntegerValue];
////}
//- (NSS*)wrapInHTML { return $(@"<html><title></title>%@", self); }
//
//@end
//NSString* assetType(AssetType enumVal)
//{
//	static NSArray * assetTypes = nil;
//	return assetTypes ?: [NSArray.alloc initWithObjects:AssetTypeArray][enumVal];
//}
//	static NSD *types = nil;		if (!types) types =
//		@{	@"script" : @(JS), @"div"	: @(HTML), 	@"style"	: @(CSS),	@"php" : @(PHP), 	@"sh" : @(BASH),		@"m"  	: @(ObjC),	@"txt"	: @(TXT),	@"n/a" :@(UNKNOWN) };
//	return (AssetType)[types[self] intValue];
//}
