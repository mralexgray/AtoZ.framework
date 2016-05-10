//
//  AZUSBMonitor.m
//  AtoZ
//
//  Created by Alex Gray on 9/29/15.
//  Copyright © 2015 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"

@import IOKit;
#include <IOKit/usb/IOUSBLib.h>

@implementation AZUSBMonitor
{

	io_iterator_t           gNewDeviceAddedIter, gNewDeviceRemovedIter;
	IONotificationPortRef		gNotifyPort;
	CFMutableDictionaryRef	classToMatch;
  CFRunLoopSourceRef      runLoopSource;
	mach_port_t             masterPort;

  mList _deviceArray;
  BOOL initializing;
}

#pragma mark ######### static wrappers #########

_LT deviceArray { return _deviceArray.copy; }

static void staticDeviceAdded (void *refCon, io_iterator_t iterator) {

	AZUSBMonitor *me;

	if ((me = (__bridge AZUSBMonitor *)refCon)) [me deviceAdded:iterator];
}

static void staticDeviceRemoved (void *refCon, io_iterator_t iterator)
{
	AZUSBMonitor *del = (__bridge AZUSBMonitor *)(refCon);

  !del ?: [del deviceRemoved:iterator];
}

#pragma mark ######### hotplug callbacks #########

- (void)   deviceAdded:(io_iterator_t)iterator {

  io_service_t            serviceObject;


	while ((serviceObject = IOIteratorNext(iterator))) {

    if (!initializing) [IO echo:@"%Device added %d",(int) serviceObject];

    CFMutableDictionaryRef	entryProperties = NULL;

		IORegistryEntryCreateCFProperties(serviceObject, &entryProperties, NULL, 0);

    SInt32 score;
    IOCFPlugInInterface  ** plugInInterface = NULL;

    kern_return_t kr = IOCreatePlugInInterfaceForService( serviceObject,
                                           kIOUSBDeviceUserClientTypeID,
                                                 kIOCFPlugInInterfaceID,
                                                       &plugInInterface,
                                                                 &score );

		if ((kr != kIOReturnSuccess) || !plugInInterface) {

      [IO echo:@"Unable to create a plug-in (%08x)\n", kr];
			continue;
		}

    IOUSBDeviceInterface ** dev = NULL;

		// create the device interface
    HRESULT result = (*plugInInterface)->QueryInterface( plugInInterface,
                             CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID),
                                                           (LPVOID*)&dev );

		// don’t need the intermediate plug-in after device interface is created
		(*plugInInterface)->Release(plugInInterface);

		if (result || !dev) {

			[IO echo:@"Couldn’t create a device interface (%08x)\n",(int) result];
			continue;
		}

		NSMutableDictionary *dict = @{}.mutableCopy;

		UInt16 vendorID, productID;
		(*dev)->GetDeviceVendor(dev, &vendorID);
		(*dev)->GetDeviceProduct(dev, &productID);
		NSString *name = (NSString *) CFDictionaryGetValue(entryProperties, CFSTR(kUSBProductString));
		if (!name)
			continue;
		
    if (!initializing) [IO echo:@"*dev = %p", *dev];

		dict[@"VID"]      = $(@"0x%04x", vendorID);
		dict[@"PID"]      = $(@"0x%04x", productID);
		dict[@"name"]     = [NSString stringWithString: name];
		dict[@"dev"]      = [NSValue valueWithPointer: dev];
		dict[@"service"]  = @(serviceObject);

		[_deviceArray addObject: dict];
	}
}

- (void) deviceRemoved:(io_iterator_t)iterator {

  io_service_t serviceObject;

	while ((serviceObject = IOIteratorNext(iterator))) {

		printf("Device removed %d.\n", (int) serviceObject);

    [_deviceArray enumerateObjectsUsingBlock:^(_Dict dict, NSUInteger idx, BOOL *stop) {

			if ((io_service_t)[dict intForKey:@"service"] == serviceObject) return;
      [_deviceArray removeObject: dict];
      *stop = YES;
		}];
  }
  IOObjectRelease(serviceObject);
}

#pragma mark ######### GUI related #########

- (void) listenForDevices {

	kern_return_t kernResult;

  initializing = YES;

	_deviceArray = @[].mutableCopy;

	// Returns the mach port used to initiate communication with IOKit.
	kernResult = IOMasterPort(MACH_PORT_NULL, &masterPort);

	if (kernResult != kIOReturnSuccess)
    return (void)printf("%s(): IOMasterPort() returned %08x\n", __func__, kernResult);

	classToMatch = IOServiceMatching(kIOUSBDeviceClassName);
	if (!classToMatch)
    return (void)printf("%s(): IOServiceMatching returned a NULL dictionary.\n", __func__);

	// increase the reference count by 1 since die dict is used twice.
	CFRetain(classToMatch);

	gNotifyPort   = IONotificationPortCreate(masterPort);
	runLoopSource = IONotificationPortGetRunLoopSource(gNotifyPort);

	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);

	OSStatus ret = IOServiceAddMatchingNotification(gNotifyPort,
					       kIOFirstMatchNotification,
					       classToMatch,
					       staticDeviceAdded,
					       (__bridge void *)(self),
					       &gNewDeviceAddedIter);

	// Iterate once to get already-present devices and arm the notification
	[self deviceAdded: gNewDeviceAddedIter];

	ret = IOServiceAddMatchingNotification(gNotifyPort,
					       kIOTerminatedNotification,
					       classToMatch,
					       staticDeviceRemoved,
					       (__bridge void *)(self),
					       &gNewDeviceRemovedIter);

	// Iterate once to get already-present devices and arm the notification
	[self deviceRemoved : gNewDeviceRemovedIter];

	// done with the masterport
	mach_port_deallocate(mach_task_self(), masterPort);

  initializing = NO;
}

static AZUSBMonitor *monitor;

+ (void) listen {

  [monitor = monitor ?: AZUSBMonitor.new listenForDevices];
}
@end
