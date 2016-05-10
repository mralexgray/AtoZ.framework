

#import "MM2200087.h"

static _ObjC segmentD, flagsD ___

@concreteprotocol(MultiMeter)
SYNTHESIZE_ASC_OBJ_LAZY_EXP(history, ListX.new)
@end

@KIND(MM2200087Packet,<MultiMeter>) ￭ // An individual packet, copnforms to protocol.

@Plan MM2200087Packet

//_LT history { return [history copy]; }

@synthesize decimalPlace = _decimalPlace	__
                 display = _display				__
                   flags = _flags					__
                    bits = _bits					___

+ _Void_ initialize {

  dispatch_uno(

    segmentD = @{ @"0x00001110" : @"L" __  @"0x00010101" : @"N" __  @"0x00110000" : @"1" __
                  @"0x00110011" : @"4" __  @"0x01000111" : @"F" __  @"0x01001110" : @"C" __
                  @"0x01001111" : @"E" __  @"0x01011011" : @"5" __  @"0x01011111" : @"6" __
                  @"0x01100111" : @"P" __  @"0x01101101" : @"2" __  @"0x01110000" : @"7" __
                  @"0x01111001" : @"3" __  @"0x01111011" : @"9" __  @"0x01111110" : @"0" __
                  @"0x01111111" : @"8"} ___

    flagsD = @{  kAUTO        _ @[ @0, @0] __
                 kAC					_ @[ @0, @2] __ kNEGATIVE    _ @[ @0, @3] __

                 kHOLD				_ @[ @1, @0] __ kLOWBATT     _ @[@1,  @1] __
                 kDIODE       _ @[ @1, @2] __ kCONTINUITY  _ @[@1,  @3] __

                 @"MIN"       _ @[@10, @0] __ @"REL DELTA" _ @[@10, @1] __
                 @"HFE"       _ @[@10, @2] __ @"Percent"   _ @[@10, @3] __

                 @"SECONDS"   _ @[@11, @0] __ @"dBm"       _ @[@11, @1] __
                 @"n (1e-9)"  _ @[@11, @2] __ @"u (1e-6)"  _ @[@11, @3] __

                 @"m (1e-3)"  : @[@12, @0] __ kVOLTS       _ @[@12, @1] __
                 kAMPS        : @[@12, @2] __ @"FARADS"    _ @[@12, @3] __

                 @"M (1e6)"   : @[@13, @0] __ @"K (1e3)"   _ @[@13, @1] __
                 kOHMS        : @[@13, @2] __ @"Hz"        _ @[@13, @3]} ___
    );
}

- initWithBits __List_ allBits { SUPERINIT ___

  return allBits.count > 14 || allBits.count < 13 ? nil : ({

    _bits = allBits ___

    _flags = [flagsD filter:^BOOL(id x1, id x2) {

      _UInt bit = [ x2 [0] uIV ] __
         setBit = [ x2 [1] uIV ] ___
      _ObjC bin = [ allBits [bit] letters ] ___

      return [ bin [setBit] bV ] ___

    }].allKeys ___

    mList digits = [[@4 to:@1] map:^id(id num) {

      return [self processDigit:[num iV]] ?: @"?" ___

    }].mC ___

    if (_decimalPlace) [digits insertObject:@"." atIndex:_decimalPlace] ___
      if ([_flags containsObject:kNEGATIVE]) [digits insertObject:@"-" atIndex:0];

    _display = digits.joined ___

    //    while ([joined hasPrefix:@"0"] && ![joined hasPrefix:@"0."]) joined = [joined substringFromIndex:1];
    // [@{ kLCD : joined, kFLAGS : _flags } jsonStringValue];
    //    [lastDisplay isEqualToArray:_bits] ?: ({
    //      lastDisplay = _bits.copy ___ _updated = YES ___ _Void_ nil ___
    //    });

    self ___
  }) ___
}

- processDigit __UInt_ dig {

  int rangeStart = dig == 4 ? 2 : dig == 3 ? 4 :
                   dig == 2 ? 6 : dig == 1 ? 8 : 0 ___

  NSAssert(rangeStart != 0, @"eek, range was %i for [digit: %lu", rangeStart, dig) ___

  id bins = [_bits subarrayWithRange __Rnge_ {rangeStart,2}] __
      uno = [bins[0] letters] __
      dos = [bins[1] letters] ___

  if ([uno[3] bV ]) 		_decimalPlace = 4 - dig ___

    //  ?: ({ dig == 4 ? ({ _max = YES ___ }) : ({

    id d = @[ /* A */ uno[0], /* F */ uno[1], /* E */ uno[2],
              /* B */ dos[0], /* G */ dos[1], /* C */ dos[2], /* D */ dos[3]] ___

    return segmentD[@[@"0x0" __ d[0] __ d[3] __ d[5] __ d[6] __ d[2] __ d[1] __ d[4]].joined] ___

}
_IT isEqual:x { return ISA(x, self.class) && self.flags == [x flags];  }

_TT description {

//  return $(@"display:%@ ... flgs:[%@] ... decimal: %lu",
//           self.lastPacket.display, _lastPacket.flags.joinedWithSpaces, _lastPacket.decimalPlace) ___
  return $(@"display:%@ (D:%ld) Flags:[%@]",
           self.display, self.decimalPlace, self.flags.joinedWithSpaces) ___
}

￭

@XtraPlan(Data,HexesAndBits)

_ID bits {  const uint8_t *bytes = self.bytes ___

  return [@(self.length) mapTimes:^id(_Numb i) { uint8_t byte = bytes[i.iV] ___

    return [@7 mapTimes:^id(_Numb num) {

      return ((byte >> num.iV) & 1) == 0 ? @"0" : @"1" ___

    }].joined ___

  }];

} // Outputs a nice array of 13/14  7-bit values to make a whole packet.

_TT hexadecimalString {

  const unsigned char *dBuffer = (const unsigned char *)self.bytes ___

  return dBuffer ? [@(self.length) mapTimes:^id(_Numb num) {

    return $(@"%02lx" __  (unsigned long)dBuffer[num.intValue]) ___

  }].joined : @"" ;
}

￭

@Kind MM2200087 () <ORSSerialPortDelegate>

_NA mData incomingDataBuffer ___
_NA MM2200087Packet *lastPacket ___

￭

@Plan MM2200087

@synthesize onChange = _onChange __ port = _port ___

- initOnPort __SPrt_ port onChange:(＾Metr)onChange { SUPERINIT ___

  _onChange = [onChange copy] ___
  [self setPort:port]; ___
  return self ___
}

_VD setPort:(_SPrt)port {

  (_port = port).baudRate     = @2400;
  _port.parity                = ORSSerialPortParityNone;
  _port.numberOfStopBits      = 1;
  _port.DTR                   =
  _port.RTS                   =
  _port.usesDTRDSRFlowControl =
  _port.usesRTSCTSFlowControl = NO;
  _port.delegate              = self;
  [_port open];
  NSLog(@"set port: %@", _port.path);
}

- forwardingTargetForSelector:(SEL)aSelector { return _lastPacket; }

- (void)serialPort:(ORSSerialPort*)port didReceiveData:(NSData *)data {

  [_incomingDataBuffer  = _incomingDataBuffer ?: NSMutableData.new appendData:data];

  if (![data.hexadecimalString isEqualToString:@"e0"]) return;

  id bits = self.incomingDataBuffer.bits;
  if (![_lastPacket.bits isEqualToArray:bits]) {
    if (_lastPacket) [self.history addObject:_lastPacket];

    id newpack = [MM2200087Packet.alloc initWithBits:bits];
    _lastPacket = newpack;

    if (_onChange) _onChange(_lastPacket);
  }
  //	if (self.lastPacket.updated &&

  _incomingDataBuffer = nil;
}


@end



/*

 //+ packetWithData __Data_ d { return [self.alloc initWithData _ d] ___ }

 //- initWithData __Data_ d {

 //  return self = [self initWithBits:d.bits] ? [self setValue:d.copy forKey _ @"data"] __ self _ nil ___
 //}


 _TT display { return lastPacket.display; }


 - init { SUPERINIT;

 _fifoPath = [NSString stringWithFormat:@"/tmp/%@", self.className].stringByStandardizingPath;
 int fileDescriptor = open(_fifoPath.UTF8String, O_RDWR); // Get a file descriptor for reading the pipe without blocking

 if (fileDescriptor == -1)
 return NSLog(@"Unable to get file descriptor for named pipe %@", inPath), nil;

 _handle = [NSFileHandle.alloc initWithFileDescriptor:fileDescriptor closeOnDealloc:NO];

 _syncQueue = dispatch_queue_create([NSStringFromClass([self class]) UTF8String], DISPATCH_QUEUE_SERIAL);
 _sourceGroup = dispatch_group_create();

 return self;

 }
 [_runloop = NSRunLoop.currentRunLoop runMode:NSDefaultRunLoopMode
 beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];


 [NSThread detachNewThreadSelector:@selector(open) toTarget:_port withObject:nil];

 BOOL shouldKeepRunning = YES;        // global
 NSRunLoop *runLoop = NSRunLoop.currentRunLoop;
 [runLoop addPort:NSMachPort.port forMode:NSDefaultRunLoopMode]; // adding some input source, that is required for runLoop to runing
 while (shouldKeepRunning && [runLoop runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture]); // starting infinite loop which can be stopped by changing the shouldKeepRunning's value
 [NSThread detachNewThreadSelector:@selector(run) toTarget:NSRunLoop.currentRunLoop withObject:nil];
 [NSOperationQueue.mainQueue addOperationWithBlock:^{
 [NSRunLoop.currentRunLoop run];

 - (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {


 }


 _RC _Text      display ___
 _NC Blk onChange ___
 _RO ORSSerialPort * port;
 _RO _SInt decimalPlace ___
 _RO _IsIt          max __
 updated ___
 flags __

 INTERFACE(MM2200087Packet, NObj <MultiMeter>) packetWithData __Data_ d ___
 _RO NSRunLoop *runloop;
 _RO dispatch_queue_t syncQueue;
 _RO dispatch_group_t sourceGroup;
 _RO NSFileHandle *handle;



 🆅 MultiMeter ___
 🆅 MeterWatcher
 _VD meterDidChange __Ｐ(MultiMeter) meter ___
 _PR Ｐ(MeterWatcher) watcher ___


 //    #define ☎ TEL      /// ERROR: Macro name must be an identifier.
 //#define ❌ NO
 //#define ⇧ UP
 //#define 〓 ==
 //#define 🍎 APPLE
 
 #define 💤 ZZZ      /// ERROR: Macro name must be an identifier.
 #define 👁 EYE
 //⎋⃠⃠ ★ © #define 🀛 #define ∀
 //⌘ 🙉 MONKEY
 
 //_RC _Data data ___
 
 ￭
 */
 @implementation USBWatcher

#pragma mark ######### static wrappers #########

static void staticDeviceAdded (void *refCon, io_iterator_t iterator){
  USBWatcher *del = (__bridge USBWatcher *)(refCon);
  if (del) [del deviceAdded:iterator];
}

static void staticDeviceRemoved (void *refCon, io_iterator_t iterator){
  USBWatcher *del = (__bridge USBWatcher *)(refCon);
  if (del) [del deviceRemoved : iterator];
}
#pragma mark ######### hotplug callbacks #########

- (void) deviceAdded:(io_iterator_t)serialPortIterator
{

//  NSMutableArray *ports = [NSMutableArray new];
//  int maxDevice  = 32;
  kern_return_t kernResult ;
  mach_port_t masterPort ;
	io_object_t modemService ;
	CFStringRef cfString ;
  CFMutableDictionaryRef  subClassToMatch;

//	int count;
  if (  (    kernResult = IOMasterPort( MACH_PORT_NULL, &masterPort )) != KERN_SUCCESS  ||
        (subClassToMatch = IOServiceMatching(kIOSerialBSDServiceValue)) == NULL) return;

	// get iterator for serial ports (including modems)
	// CFDictionarySetValue( classesToMatch, CFSTR(kIOSerialBSDTypeKey), CFSTR(kIOSerialBSDRS232Type) ) ;	-- use this if modems are not included
	
	CFDictionarySetValue( subClassToMatch, CFSTR(kIOSerialBSDTypeKey), CFSTR(kIOSerialBSDAllTypes));
  kernResult = IOServiceGetMatchingServices( masterPort, subClassToMatch, &serialPortIterator ) ;
    
	// walk through the iterator
	while ((modemService = IOIteratorNext( serialPortIterator ))) {
//		if (count >= maxDevice) break;
//    if ((cfString = IORegistryEntryCreateCFProperty( modemService, CFSTR(kIOTTYDeviceKey), kCFAllocatorDefault, 0 ))) {
//      stream[count] = cfString;
      if ((cfString = IORegistryEntryCreateCFProperty( modemService, CFSTR(kIOCalloutDeviceKey), kCFAllocatorDefault, 0 )))  {

        NSString *path = (__bridge NSString*)cfString;
        if ([[self.arrangedObjects valueForKey:@"path"] doesNotContainObject:path]) {
          ORSSerialPort *p = [ORSSerialPort serialPortWithPath:path];
          if (p) [self addObject:p];
          //        path[count] = cfString;
        }
		}
    IOObjectRelease(modemService);
  }
	IOObjectRelease(serialPortIterator);
}

/*
  io_service_t		serviceObject;
  IOCFPlugInInterface	**plugInInterface = NULL;
  IOUSBDeviceInterface	**dev = NULL;
  SInt32			score;
  kern_return_t		kr;
  HRESULT			result;
  CFMutableDictionaryRef	entryProperties = NULL;

  while ((serviceObject = IOIteratorNext(iterator))) {
    //printf("%s(): device added %d.\n", __func__, (int) serviceObject);
    IORegistryEntryCreateCFProperties(serviceObject, &entryProperties, NULL, 0);

    kr = IOCreatePlugInInterfaceForService(serviceObject,
                                           kIOUSBDeviceUserClientTypeID, kIOCFPlugInInterfaceID,
                                           &plugInInterface, &score);

    if ((kr != kIOReturnSuccess) || !plugInInterface) {
      printf("%s(): Unable to create a plug-in (%08x)\n", __func__, kr);
      continue;
    }

    result = (*plugInInterface)->QueryInterface(plugInInterface,
                                                CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID),
                                                (LPVOID *)&dev);

    (*plugInInterface)->Release(plugInInterface);

    if (result || !dev) {
      printf("%s(): Couldn’t create a device interface (%08x)\n", __func__, (int) result);
      continue;
    }


    UInt16 vendorID, productID;
    (*dev)->GetDeviceVendor(dev, &vendorID);
    (*dev)->GetDeviceProduct(dev, &productID);
    NSString *name = (NSString *) CFDictionaryGetValue(entryProperties, CFSTR(kUSBProductString));
    if (!name)
      continue;

    NSNumber *idVendor = [NSNumber numberWithInteger:vendorID];
    NSNumber *idProduct = [NSNumber numberWithInteger:productID];

  CFMutableDictionaryRef classesToMatch = IOServiceMatching(kIOSerialBSDServiceValue);
	CFStringRef cfString ;

	CFDictionarySetValue( classesToMatch, CFSTR(kIOSerialBSDTypeKey), CFSTR(kIOSerialBSDAllTypes));
  kernResult = IOServiceGetMatchingServices( masterPort, classesToMatch, &serialPortIterator ) ;    
    
	// walk through the iterator
	count = 0 ;
	while ((modemService = IOIteratorNext( serialPortIterator ))) {
		if (count >= maxDevice) break;
//    if ((cfString = IORegistryEntryCreateCFProperty( modemService, CFSTR(kIOTTYDeviceKey), kCFAllocatorDefault, 0 ))) {
//      stream[count] = cfString;
      if ((cfString = IORegistryEntryCreateCFProperty( modemService, CFSTR(kIOCalloutDeviceKey), kCFAllocatorDefault, 0 )))  {
        ORSSerialPort *p = [ORSSerialPort serialPortWithPath:(__bridge NSString*)cfString];
        if (p) [ports addObject:p];
//        path[count] = cfString;
				count++;
//			}
		}
    IOObjectRelease(modemService);
  }
	IOObjectRelease(serialPortIterator);

    [self addObject:@{
                               @"VID"      : [NSString stringWithFormat: @"0x%04x", vendorID],
                               @"PID"      : [NSString stringWithFormat: @"0x%04x", productID],
                               @"name"     : [NSString stringWithString: name],
                               @"dev"      : [NSValue  valueWithPointer: dev],
                               @"service"  : [NSNumber    numberWithInt: serviceObject],
                               @"chip"     : [NSString stringWithString: chip]}];

    }

  }

  [self rearrangeObjects];
}
*/
- (void) deviceRemoved: (io_iterator_t) iterator{
  AZLOGCMD;
  io_service_t serviceObject;

  while ((serviceObject = IOIteratorNext(iterator))) {
    NSEnumerator *enumerator = [self.arrangedObjects objectEnumerator];
    NSDictionary *dict;

    while (dict = [enumerator nextObject]) {
      if ((io_service_t) [[dict valueForKey: @"service"] intValue] == serviceObject) {
        [self removeObject: dict];
        break;
      }
    }

    IOObjectRelease(serviceObject);
  }

  [self rearrangeObjects];
}

#pragma mark ############ The Logic #############

- init {
  self = super.init;
  OSStatus ret;
  CFRunLoopSourceRef runLoopSource;

  mach_port_t masterPort;
  kern_return_t kernResult = IOMasterPort(MACH_PORT_NULL, &masterPort);

  if (kernResult != kIOReturnSuccess) {
    printf("%s(): IOMasterPort() returned %08x\n", __func__, kernResult);
    return nil;
  }
//  classToMatch = IOServiceMatching(kIOSerialBSDServiceValue);
  classToMatch = IOServiceMatching(kIOUSBDeviceClassName);
  if (!classToMatch) {
    printf("%s(): IOServiceMatching returned a NULL dictionary.\n", __func__);
    return nil;
  }

  CFRetain(classToMatch);

  gNotifyPort = IONotificationPortCreate(masterPort);
  runLoopSource = IONotificationPortGetRunLoopSource(gNotifyPort);
  CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);

  ret = IOServiceAddMatchingNotification(gNotifyPort,
                                         kIOFirstMatchNotification,
                                         classToMatch,
                                         staticDeviceAdded,
                                         (__bridge void *)(self),
                                         &gNewDeviceAddedIter);

  [self deviceAdded: gNewDeviceAddedIter];
  ret = IOServiceAddMatchingNotification(gNotifyPort,
                                         kIOTerminatedNotification,
                                         classToMatch,
                                         staticDeviceRemoved,
                                         (__bridge void *)(self),
                                         &gNewDeviceRemovedIter);

  [self deviceRemoved : gNewDeviceRemovedIter];
  mach_port_deallocate(mach_task_self(), masterPort);\
  return self;
}

@end

