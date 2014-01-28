#import <objc/runtime.h>


@implementation NSA (MappingSanity)
-(NSA*) map:(id(^)(id))sieve {	__block NSMutableArray *mapper = NSMutableArray.new;
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id rObj = sieve(obj);	if (rObj) [mapper addObject:rObj];
	}];											return mapper.count ? mapper : nil;
}
@end
@implementation NSObject (PropertiesPlease)
+ (NSArray*) propertyNames {	unsigned int i, count = 0;
	
	objc_property_t * properties = class_copyPropertyList( self, &count );
	if ( count == 0 )	{		free( properties );		return ( nil );	}
	NSMutableArray * list = NSMutableArray.new;
	for ( i = 0; i < count; i++ )
		[list addObject:[NSString stringWithUTF8String:property_getName(properties[i])]];
	return [list copy];
}
@end


int main(int argc, char *argv[])	{	return NSApplicationMain(argc, (const char **)argv);	}
