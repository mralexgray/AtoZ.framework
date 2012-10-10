
#import <Foundation/Foundation.h>

@interface NSMutableData (NUExtensions)

/**
 
  \brief    Reverses the the order of the byte chunks within the buffer.
 
  \details  One way of explaining how this method works is to imagine the
            buffer as being an array of values in the following way:
 
                countBytes=1  =>  array of uint8_t
                countBytes=2  =>  array of uint16_t
                countBytes=4  =>  array of uint32_t
                countBytes=8  =>  array of uint64_t
 
            The method reverses the content of the array.
 
  \param    sizeOfChunc     either 1,2,4 or 8. 
                            Any other value raises an exception.
 
 */
- (void) reverseBytesInChunksOfSize:(NSUInteger)sizeOfChunk;

@end
