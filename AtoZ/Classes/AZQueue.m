//
//  DKQueue.m
//
//  Created by Dominik Krejčík on 25/09/2011.
//  Feel free to use and distribute as long as you mention me. Or buy me a beer.
//

#import "AZQueue.h"

@implementation AZQueue

-(id)init
{
    if ( (self = [super init]) ) {
        array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(id)dequeue 
{
    if ([array count] > 0) {
		id object = [self peek];
        [array removeObjectAtIndex:0];
		return object;
	}
	
	return nil;
}

-(void)enqueue:(id)element
{
    [array addObject:element];
}

-(void)enqueueElementsFromArray:(NSArray*)arr 
{
    [array addObjectsFromArray:arr];
}

-(void)enqueueElementsFromQueue:(AZQueue*)queue
{
    while (![queue isEmpty]) {
        [self enqueue:[queue dequeue]];
    }
}

-(id)peek 
{
    if ([array count] > 0)
        return array[0];
	
    return nil;
}

-(NSInteger)size 
{
    return [array count];
}

-(BOOL)isEmpty 
{
    return [array count] == 0;
}

-(void)clear 
{
    [array removeAllObjects];
}

@end
