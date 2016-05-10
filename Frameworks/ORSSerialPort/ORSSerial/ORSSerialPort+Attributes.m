
#import "ORSSerialPort.h"
#import <IOKit/usb/USBSpec.h>

@implementation ORSSerialPort (Attributes)

- (NSDictionary *)ioDeviceAttributes
{
  NSDictionary *result = nil;

    io_iterator_t iterator = 0;
    if (IORegistryEntryCreateIterator(self.IOKitDevice,
                                      kIOServicePlane,
                                      kIORegistryIterateRecursively + kIORegistryIterateParents,
                                      &iterator) != KERN_SUCCESS) return nil;

    io_object_t device = 0;
    while ((device = IOIteratorNext(iterator)) && result == nil)
    {
        CFMutableDictionaryRef usbProperties = 0;
        if (IORegistryEntryCreateCFProperties(device, &usbProperties, kCFAllocatorDefault, kNilOptions) != KERN_SUCCESS)
        {
            IOObjectRelease(device);
            continue;
        }
        NSDictionary *properties = CFBridgingRelease(usbProperties);

        NSNumber *vendorID = properties[(__bridge NSString *)CFSTR(kUSBVendorID)];
        NSNumber *productID = properties[(__bridge NSString *)CFSTR(kUSBProductID)];
        if (!vendorID || !productID) { IOObjectRelease(device); continue; } // not a USB device

        result = properties;

        IOObjectRelease(device);
    }

    IOObjectRelease(iterator);
    return result;
}

- (NSNumber *)vendorID;
{
    return [self ioDeviceAttributes][(__bridge NSString *)CFSTR(kUSBVendorID)];
}

- (NSNumber *)productID;
{
    return [self ioDeviceAttributes][(__bridge NSString *)CFSTR(kUSBProductID)];
}

@end
