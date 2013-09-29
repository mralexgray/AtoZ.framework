
#import "AssetCollection.h"

@implementation Asset

+ (instancetype) test {

	NSS *sampleJS = @"function myFunction() { $('#h01').attr('style','color:red').html('Hello jQuery'); } $(document).ready(myFunction);";

	Asset *n 		= [self instanceOfType:JS withPath:nil orContents:sampleJS printInline:YES];
	return n;
}
+ (instancetype) instanceOfType:(AssetType)type withPath:(NSS*)path orContents:(NSS*)contents printInline:(BOOL)isit {

	Asset *n 		= self.instance;
	n.assetType		= type == NSNotFound ? UNKNOWN : type;
	n.path 			= path;
	n.printInline 	= path == nil || isit ?: NO;
	n.contents 		= contents;
	NSS *apath = @keypath(NSIMG.monoIcons, first);

	return n;
}
- (void) setUp {  _active = @(NSOffState); _priority = @(0); }

- (NSS*) markup
{
	return $(@"<%@ src='%@'></%@>", assetStringValue[self.assetType], self.path, assetStringValue[self.assetType]);
}

- (NSS*) cssInline 	{ return $(@"<style>\n%@\n</style>\n", self.contents); 		}
- (NSS*) cssTag 	{ return $(@"<link href='%@' />\n", self.path); 				}
- (NSS*) jsInline 	{ return $(@"<script>\n%@\n</sscript>\n", self.contents); 	}
- (NSS*) jsTag	 	{ return $(@"<script src=%@</script>\n", self.path); 	}


@end

@implementation AssetCollection

- (void) setUp { _folders = NSMA.new; _assets = NSMA.new;  }


- (void) addFolder: (NSS*)path matchingType:(AssetType)fileType
{
	[[self mutableArrayValueForKey:@"folders"] addObject:path];
	NSS * ext =  assetStringValue[fileType];
	NSError *error;
	NSA* filed = [AZFILEMANAGER contentsOfDirectoryAtPath:path error:&error];
	if (!error) {
		filed = [filed filter:^BOOL(id object) {
			return 	[[object pathExtension] isEqualToString:ext];
		}];
		AZLOG(filed);
		[[filed map:^id(id obj) { return  [Asset instanceOfType:fileType withPath:obj orContents:nil printInline:NO]; 	}] each:^(id obj) {
//			AZLOG([obj propertiesPlease]);
			[self insertObject:obj inAssetsAtIndex:self.assets.count];
		}];
	}
	NSLog(@"folders: %@   assets:%@", _folders, _assets);
	
}

- (NSUI)countOfAssets 											{	return self.assets.count; 					  }

- (id)objectInAssetsAtIndex:(NSUI)index 							{	return self.assets[index];	 				  }

- (void)removeObjectFromAssetsAtIndex:(NSUI)index 				{ 	[self.assets removeObjectAtIndex:index];		  }

- (void)insertObject:(Asset*)todo inAssetsAtIndex:(NSUI)index {	[self.assets insertObject:todo atIndex:index]; }

@end

@implementation AssetTypeTransformer

+(Class)transformedValueClass {
	return NSString.class;
}

-(id)transformedValue:(id)value {
//	AssetType t = [value intValue];
	return assetStringValue[[value intValue]];
//	if (quality == kQualityBest)
//		return @"Best";
//	else if (quality == kQualityWorst)
//		return @"Worst";
//
	return nil;
}
@end

	// To convert enum to string:	NSString *str = FormatType_toString[theEnumValue];
NSString * const assetStringValue[] = {  @"js",@"css",@"html",@"php",@"sh",@"m",@"txt",@"n/a" };
NSString * const assetTagName[] = {  @"script",@"style",@"div",@"php",@"sh",@"m",@"txt",@"n/a" };

@implementation NSString (AssetType)
- (AssetType)assetFromString	{	static NSD *types = nil;  	return types = types  ?:

	@{	@"js" : @(JS), @"html"	: @(HTML5), 	@"css"	: @(CSS),	@"php" : @(PHP), 	@"sh" : @(BASH),		@"m"  	: @(ObjC),	@"txt"	: @(TXT),	@"n/a" :@(UNKNOWN) },  (AssetType)[types[self] unsignedIntegerValue];
}
- (NSS*)wrapInHTML { return $(@"<html><title></title>%@", self); }

@end
	//NSString* assetType(AssetType enumVal)
	//{
	//	static NSArray * assetTypes = nil;
	//	return assetTypes ?: [NSArray.alloc initWithObjects:AssetTypeArray][enumVal];
	//}
	//	static NSD *types = nil;		if (!types) types =
	//		@{	@"script" : @(JS), @"div"	: @(HTML), 	@"style"	: @(CSS),	@"php" : @(PHP), 	@"sh" : @(BASH),		@"m"  	: @(ObjC),	@"txt"	: @(TXT),	@"n/a" :@(UNKNOWN) };
	//	return (AssetType)[types[self] intValue];
	//}
