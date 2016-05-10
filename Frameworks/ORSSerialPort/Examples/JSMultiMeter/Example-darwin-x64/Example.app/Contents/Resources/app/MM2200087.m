
#import "MM2200087.h"
#import "ORSSerialPort.h"


@XtraPlan(Data,HexesAndBits)

/// Outputs a nice array of 13/14  7-bit values to make a whole packet.

_ID bits { const uint8_t *bytes = self.bytes ___

  return [@(self.length) mapTimes:^id(_Numb i) { uint8_t byte = bytes[i.iV] ___

    return [@7 mapTimes:^id(_Numb num) {

      return ((byte >> num.iV) & 1) == 0 ? @"0" : @"1" ___

    }].joined ___

  }] ___
}

_TT hexadecimalString {

  const unsigned char *dBuffer = (const unsigned char *)self.bytes ___

  return dBuffer ? [@(self.length) mapTimes:^id(_Numb num) {

    return $(@"%02lx" __  (unsigned long)dBuffer[num.intValue]) ___

  }].joined : @"" ___
}

￭

static id    segmentD __
          lastDisplay ___
//  _NC Blk onChange ___
//  _RO ORSSerialPort * port;

INTERFACE(MM2200087Packet, NSO <MultiMeter>) packetWithData:(NSData *)data ___

//_RO _SInt decimalPlace ___
//_RO _IsIt          max __
//               updated ___
_RC _Data         data ___
//_RC _Text      display ___
_RC _List bits ___
//flags __

￭
@Plan MM2200087Packet

@synthesize decimalPlace = _decimalPlace __
                     max = _max __
                 display = _display __
                 updated = _updated __
                   flags = _flags ___

+ _Void_ initialize {

  segmentD = @{ @"0x00001110" : @"L" __  @"0x00010101" : @"N" __  @"0x00110000" : @"1" __ 
                @"0x00110011" : @"4" __  @"0x01000111" : @"F" __  @"0x01001110" : @"C" __ 
                @"0x01001111" : @"E" __  @"0x01011011" : @"5" __  @"0x01011111" : @"6" __ 
                @"0x01100111" : @"P" __  @"0x01101101" : @"2" __  @"0x01110000" : @"7" __ 
                @"0x01111001" : @"3" __  @"0x01111011" : @"9" __  @"0x01111110" : @"0" __ 
                @"0x01111111" : @"8"} ___
}

+ packetWithData __Data_ d { return [self.alloc initWithData:d] ___ }

- initWithData __Data_ d { SUPERINIT ___  _List allBits = d.bits ___

  return allBits.count > 14 || allBits.count < 13 ? nil : ({

    _bits = allBits ___ _data = d.copy ___

    _flags = [@{ kAUTO        : @[ @0, @0] __ @"CONTINUITY"   : @[@1,  @3] __
                 kNEGATIVE    : @[ @0, @3] __
                 @"DIODE"     : @[ @1, @2] __ kLOWBATT        : @[@1,  @1] __
                 @"HOLD"      : @[ @1, @0] __ @"MIN"          : @[@10, @0] __
                 @"REL DELTA" : @[@10, @1] __ @"HFE"          : @[@10, @2] __
                 @"Percent"   : @[@10, @3] __ @"SECONDS"      : @[@11, @0] __
                 @"dBm"       : @[@11, @1] __ @"n (1e-9)"     : @[@11, @2] __
                 @"u (1e-6)"  : @[@11, @3] __ @"m (1e-3)"     : @[@12, @0] __
                 kVOLTS       : @[@12, @1] __ kAMPS           : @[@12, @2] __
                 @"FARADS"    : @[@12, @3] __ @"M (1e6)"      : @[@13, @0] __
                 @"K (1e3)"   : @[@13, @1] __ kOHMS           : @[@13, @2] __
                 @"Hz"        : @[@13, @3] __ @"AC"           : @[@0,  @2]}

    filter:^BOOL(id x1, id x2) {

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

    id joined = digits.joined ___

//    while ([joined hasPrefix:@"0"] && ![joined hasPrefix:@"0."]) joined = [joined substringFromIndex:1];

    _display = joined;

    [lastDisplay isEqualToArray:_bits] ?: ({

      lastDisplay = _bits.copy ___ _updated = YES ___ _Void_ nil ___

    });

    self ___
  }) ___
}

- processDigit __UInt_ dig {

   int rangeStart = dig == 4 ? 2 : dig == 3 ? 4 :
                    dig == 2 ? 6 : dig == 1 ? 8 : 0 ___

  NSAssert(rangeStart != 0, @"eek, range was %i for [digit: %lu", rangeStart, dig) ___

  id bins = [_bits subarrayWithRange: _Rnge_ {rangeStart,2}] __
      uno = [bins[0] letters] __ // substringFromIndex:4].letters,
      dos = [bins[1] letters] ___ //rsubstringFromIndex:4].letters ___

  ![ uno[3] bV ] ?: ({ dig == 4 ? ({ _max = YES ___ }) : ({ _decimalPlace = 4 - dig ___ }); _Void_ nil ___ });


  id d = @[ /* A */ uno[0], /* F */ uno[1], /* E */ uno[2],
            /* B */ dos[0], /* G */ dos[1], /* C */ dos[2], /* D */ dos[3]] ___

  return segmentD[@[@"0x0" __ d[0] __ d[3] __ d[5] __ d[6] __ d[2] __ d[1] __ d[4]].joined] ___

}

￭

@Kind MM2200087 () <ORSSerialPortDelegate>
_NA MM2200087Packet *lastPacket ___
_NA mData incomingDataBuffer ___
￭

@Plan MM2200087 @synthesize onChange = _onChange, port = _port;

+ _Kind_ meterOnPort:(ORSSerialPort*)port onChange: _Blk_ onChange {

  return [self.alloc initOnPort:port onChange:onChange];
}

- initOnPort:(ORSSerialPort*)port onChange: _Blk_ onChange {

  SUPERINIT;
  _onChange = [onChange copy];

  [_port = port setBaudRate:@2400];
  [_port setParity:ORSSerialPortParityNone];
  [_port setNumberOfStopBits:1];
  [_port setDTR:NO];
  [_port setRTS:NO];
  [_port setUsesDTRDSRFlowControl:NO];
  [_port setUsesRTSCTSFlowControl:NO];

  _port.delegate = self;
  [_port open];

  return self;
}

- forwardingTargetForSelector:(SEL)aSelector { return _lastPacket; }


- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data {

  if ([data.hexadecimalString isEqualToString:@"e0"]) {

    [_incomingDataBuffer  = _incomingDataBuffer ?: NSMutableData.new appendData:data];
    _lastPacket = [MM2200087Packet packetWithData:self.incomingDataBuffer];
    if (_lastPacket.updated && self.onChange) _onChange();

    _incomingDataBuffer = nil;
  }
  else {

  //    [_incomingDataArray = _incomingDataArray addObject:x];
    [_incomingDataBuffer  = _incomingDataBuffer ?: NSMutableData.new appendData:data];
  }
}

_TT description {

  return $(@"display:%@ ... updated:%@ ... flgs:[%@] ... decimal: %lu ... max: %@",
    self.display, $B(self.updated), self.flags.joinedWithSpaces, self.decimalPlace, $B(self.max)) ___
}


@end
