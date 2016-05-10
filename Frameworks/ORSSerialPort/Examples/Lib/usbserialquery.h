
//  usbserialquery.h - Created by github.com/mralexgray on 12/1/15.

#ifndef usbserialquery_h
#define usbserialquery_h

@import Foundation;

#import "ORSSerialPort.h"
#import "ORSSerialPortManager.h"

#define kPID @"ProductID"
#define kVID @"VendorID"
#define kUSB @"BoardName"

NS_INLINE ORSSerialPort * guessPort(id hint) {

  NSString * port = hint ? [hint lastPathComponent].pathExtension : nil;

  for (ORSSerialPort * obj in ORSSerialPortManager.sharedSerialPortManager.availablePorts)

  if ((!port && [obj.name rangeOfString:@"Bluetooth-Incoming-Port"].location == NSNotFound)

    || [port isEqualToString:obj.name]) return obj;

  return nil;
}

NS_INLINE NSDictionary * getInfoForSerialUSB(id name) {

  ORSSerialPort *port = guessPort(name);

  return !port ? nil : ({

    @{  kUSB : port.name,
        kVID : [NSString stringWithFormat:@"0x%04x", port.vendorID.intValue],
        kPID : [NSString stringWithFormat:@"0x%04x", port.productID.intValue] }; });
}


#endif /* usbserialquery_h */

