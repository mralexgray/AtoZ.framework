//
//  AZQueue.h
// 	FIFO (first in first out) data structure for Objective-C


#import <Foundation/Foundation.h>



@interface AZQueue : NSObject {
    NSMutableArray* array;
}

// Removes and returns the element at the front of the queue
-(id)dequeue;
// Add the element to the back of the queue
-(void)enqueue:(id)element;
// Remove all elements
-(void)enqueueElementsFromArray:(NSArray*)arr;
-(void)enqueueElementsFromQueue:(AZQueue*)queue;
-(void)clear;

// Returns the element at the front of the queue
-(id)peek;
// Returns YES if the queue is empty
-(BOOL)isEmpty;
// Returns the size of the queue
-(NSInteger)size;

@end