//
//  ORSSerialCommunicator.m
//  PacketParsingDemo
//
//  Created by Andrew Madsen on 8/10/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ORSSerialCommunicator.h"
@import ORSSerial;

@interface ORSSerialCommunicator () <ORSSerialPortDelegate>

@property (nonatomic, readwrite) NSInteger sliderPosition;

@end

@implementation ORSSerialCommunicator

#pragma mark - ORSSerialPortDelegate

- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort
{
	self.serialPort = nil;
}

- (void)serialPort:(ORSSerialPort *)serialPort didEncounterError:(NSError *)error
{
	NSLog(@"Serial port %@ encountered an error: %@", self.serialPort, error);
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceivePacket:(NSData *)packetData matchingDescriptor:(ORSSerialPacketDescriptor *)descriptor
{
	NSString *dataAsString = [[NSString alloc] initWithData:packetData encoding:NSASCIIStringEncoding];
//  NSLog(@"%@", dataAsString);
	NSString *valueString = [dataAsString substringWithRange:NSMakeRange(4, [dataAsString length]-5)];
  printf("slider %ld\n", valueString.integerValue);
	self.sliderPosition = valueString.integerValue;
}

- (void)serialPortWasOpened:(ORSSerialPort *)serialPort
{
	ORSSerialPacketDescriptor *descriptor =
  [[ORSSerialPacketDescriptor alloc] initWithPrefixString:@"!pos"
																					   suffixString:@";"
																				maximumPacketLength:8
																						   userInfo:nil];
	[serialPort startListeningForPacketsMatchingDescriptor:descriptor];
}

#pragma mark - Properties

- (void)setSerialPort:(ORSSerialPort *)serialPort
{
	if (serialPort == _serialPort) return;

  [_serialPort close];

  _serialPort.delegate = nil;
  
  _serialPort = serialPort;
  _serialPort.baudRate = @9600;
  _serialPort.RTS = YES;
  _serialPort.DTR = YES;
  _serialPort.delegate = self;
  [_serialPort open];

}
@end
