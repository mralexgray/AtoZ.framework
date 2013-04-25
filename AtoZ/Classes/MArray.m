#import "MArray.h"
#import <objc/objc-class.h>




static const BOOL __MArrayPrint=NO;

@interface MArray (Private)
-(id)_init_;
-(void)setProxiedObject:(id)object;
@end

@implementation MArray
+(NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
	return [NSMutableArray methodSignatureForSelector:selector];
}

+(void)forwardInvocation:(NSInvocation*)invocation
{
	SEL selector;
	id ret,obj;
	NSString *selName;

	selector=[invocation selector];
	selName=NSStringFromSelector(selector);
	if(__MArrayPrint)
		NSLog(@"+forwardInvocation: %@",selName);
	//class creation method
	[invocation invokeWithTarget:[NSMutableArray class]];
	[invocation getReturnValue:&ret];
	obj=[[MArray alloc] _init_];
	[obj setProxiedObject:ret];
	[invocation setReturnValue:&obj];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	if(__MArrayPrint)
		NSLog(@"-methodSig: %@",NSStringFromSelector(selector));
	return [NSMutableArray instanceMethodSignatureForSelector:selector];
}

-(id)_init_
{
	_proxiedObject=nil;
	return self;
}
/**
-(void)release
{
	if(__MArrayPrint)
		NSLog(@"-release %d",[[self proxiedObject] retainCount]);
	if([[self proxiedObject] retainCount]-1==0)
	{
		if(__MArrayPrint)
			NSLog(@"final release for %@",self);
		[[self proxiedObject] release];
		[self dealloc];
	}
	else
	{
		[[self proxiedObject] release];
	}
}
*/
//[[MArray alloc] init]
-(void)forwardInvocation:(NSInvocation*)invocation
{
	NSString *sel;

	sel=NSStringFromSelector([invocation selector]);
	if(__MArrayPrint)
		NSLog(@"-forwardInvocation: %@",sel);
	//check if this is an initializer- intercept to return MArray
	if([sel hasPrefix:@"init"]
	   && strcmp([[invocation methodSignature] methodReturnType],@encode(id))==0)
	{
		__unsafe_unretained id blockself = self;
		id newProxiedObject;
		if(__MArrayPrint)
			NSLog(@"proxied -init");
		newProxiedObject=[NSMutableArray alloc];
		[invocation invokeWithTarget:newProxiedObject];
		[invocation getReturnValue:&newProxiedObject];
		[self setProxiedObject:newProxiedObject];
		[invocation setReturnValue:&blockself];
	}
	else
	{
		id ret;
		const char *retType;
		[invocation invokeWithTarget:_proxiedObject];
		//if the return type is an NSArray, make it an MArray instead
		retType=[[invocation methodSignature] methodReturnType];
		if(strcmp(retType,@encode(id))==0)
		{
			id newMArray;
			[invocation getReturnValue:&ret];
			if([ret isKindOfClass:[NSArray class]])
			{
				newMArray=[MArray arrayWithArray:(NSArray*)ret];
				[invocation setReturnValue:&newMArray];
			}
		}
	}
}

-(id)proxiedObject
{
	return _proxiedObject;
}

-(void)setProxiedObject:(id)object
{
	_proxiedObject=object;
}

#pragma mark NSObject protocol conformance
//I need to implement these to nuke compiler warnings- otherwise the forwarding would be fine
//-(id)autorelease
//{
//	//	[[self proxiedObject] autorelease];
//	[NSAutoreleasePool addObject:self];
//
//	return self;
//}

-(Class)class
{
	//return objc_getMetaClass("NSArray");
	return [MArray class];
}

-(BOOL)conformsToProtocol:(Protocol *)proto
{
	return proto==@protocol(NSObject) || [[self proxiedObject] conformsToProtocol:proto];
}

-(NSString *)description
{
	return [[self proxiedObject] description];
}

-(NSString*)_copyDescription
{
	return [[self description] copy];
}

-(NSString *)descriptionWithLocale:(NSDictionary *)locale
{
	return [self description];
}

-(NSUInteger)hash
{
	return [[self proxiedObject] hash];
}

-(BOOL)isEqual:(id)obj
{
	return [[self proxiedObject] isEqual:obj];
}

-(BOOL)isKindOfClass:(Class)class
{
	return [self class]==class || [[self proxiedObject] isKindOfClass:class];
}

-(BOOL)isMemberOfClass:(Class)class
{
	return [self class]==class || [[self proxiedObject] isMemberOfClass:class];
}

-(BOOL)isProxy
{
	return YES;
}

-(id)performSelector:(SEL)selector
{
	return [[self proxiedObject] performSelectorWithoutWarnings:selector];
}

-(id)performSelector:(SEL)selector withObject:(id)object
{
	return [[self proxiedObject] performSelectorWithoutWarnings:selector withObject:object];
}

-(id)performSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2
{
	return [[self proxiedObject] performSelectorWithoutWarnings:selector withObject:object1 withObject:object2];
}

//release implemented above

-(BOOL)respondsToSelector:(SEL)selector
{
	if(class_getInstanceMethod([self class],selector)!=NULL)
		return YES;
	return [[self proxiedObject] respondsToSelector:selector];
}

//-(id)retain
//{
//	return [[self proxiedObject] retain];
//}
//
//-(unsigned)retainCount
//{
//	return [[self proxiedObject] retainCount];
//}
//
//-(id)self
//{
//	return self;
//}

-(Class)superclass
{
	return [[self proxiedObject] superclass]; //returns NSArray (superclass of NSMutableArray)
}

-(NSZone *)zone
{
	return [[self proxiedObject] zone];
}
@end



@implementation NSMutableArray (objectsWithFormat)
-(unsigned)addObjectsWithFormat:(NSString*)format,...
{
	//format: @"%@ %d %lf %f %ud
	va_list ap;
	NSScanner *scanner;
	NSCharacterSet *spaceSet;
	NSString *string;
	NSMutableArray *tempArray;
	unsigned count;

	va_start(ap,format);
	tempArray=[[NSMutableArray alloc] initWithCapacity:[format length]/3];
	scanner=[NSScanner scannerWithString:format];
	spaceSet=[NSCharacterSet whitespaceCharacterSet];
	count=0;
	while([scanner isAtEnd]==NO)
	{
		[scanner scanUpToCharactersFromSet:spaceSet intoString:&string];
		if([string isEqualToString:@"%@"])
		{
			id arg;
			//regular object
			arg=va_arg(ap,id);
			[tempArray addObject:arg];
			count++;
		}
		else if([string isEqualToString:@"%d"])
		{
			//int
			int arg;
			arg=va_arg(ap,int);
			[tempArray addObject:[NSNumber numberWithInt:arg]];
			count++;
		}
		else if([string isEqualToString:@"%ud"])
		{
			unsigned int arg;
			arg=va_arg(ap,unsigned int);
			[tempArray addObject:[NSNumber numberWithUnsignedInt:arg]];
			count++;
		}
		else if([string isEqualToString:@"%f"] || [string isEqualToString:@"%lf"])
		{
			//float
			double arg;
			arg=va_arg(ap,double); //`float' is promoted to `double' when passed through `...'
			[tempArray addObject:[NSNumber numberWithDouble:arg]];
			count++;
		}
		else
		{
			//just insert the string
			[tempArray addObject:[string copy]];
			[[tempArray lastObject] release];
		}
	}
	[self addObjectsFromArray:tempArray];
	va_end(ap);
	return count;
}
@end

@implementation NSProxy (Description)

+(NSString*)_copyDescription
{
	return [NSStringFromClass([self class]) copy];
}

@end


@implementation MTypedArray
-(id)initWithTypeClass:(Class)class
{
	if(self=[super initWithCapacity:5])
	{
		_class=class;
	}
	return self;
}

-(void)addObject:(id)object
{
	if(![object isKindOfClass:_class])
		[NSException raise:NSInvalidArgumentException format:@"Instance of MTypedArray takes \'%@\' only!",_class];
	[[self proxiedObject] addObject:object];
}

-(Class)typeClass
{
	return _class;
}
@end
