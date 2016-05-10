

@import AtoZUniversal;
#import "ORSSerialPort.h"

/*! USAGE:

  _meter = [MM2200087 meterOnPort:SERIALPORTS[1] onChange:^(id<MultiMeter> thing){

			_display.stringValue = [thing display];  // [thing display][kLCD] ??
  }];
	
	or
	
	MM2200087 *m = MM2200087.new;
	m.port			 = SERIALPORTS[0];
	m.onChange   = ^(id thing){ [thing log]; };

*/


_EnumKind(MMMode, DC = 0x00000000,
                  AC = 0x00000001,
               VOLTS = 0x00000010,
                AMPS = 0x00000100,
                OHMS = 0x00001000,
              FARADS = 0x00010000,
          CONTINUITY = 0x00100000,
                TEMP = 0x01000000,
                  HZ,
                  DIODE
)
_EnumKind(MMFlags,
  kVOLTS = 0x0000001,
	AUTO,
	NEGATIVE,
	LOWBATTERY,
	HOLD,
	MAX,
	MIN,
	REL_DELTA,
	HFE,
	Percent,
	SECONDS,
	dBm,
	n, /* n (1e-9), */
	u, /* u (1e-6) */
	m, /* m (1e-3) */
  M, /* M (1e6) */
	K /* K (1e3) */
)

🆅 MultiMeterReading 🅥(NObj)  /* Protocol */

#define Metr MultiMeterReading
_Type _Void (^ ＾Metr)(Ｐ(Metr)) ___

@concrete

_RO  _Text display        ___  // Literal rendering of what is on meter screen.
_RO  _SInt decimalPlace   ___  // Location of dec. place, from right.  Neg. means none.
_RO  _Flot delta          ___
_RO MMFlags flagBits      ___
_RO   List <_Text>
         * bits __ *flags ___
￭

🆅 MultiMeter 🅥(MultiMeterReading)  /* Protocol */

@Optn
_NC ＾Metr onChange     ___  // Assignable block. Fires on meter value change.
_NA  _SPrt port         ___  // ORSSerial port for the meter.

- initWithID __UInt_ prod onChange:(＾Metr) onChange ___
- initOnPort __SPrt_ port onChange:(＾Metr) onChange ___

@concrete
_WK ListX 🅥(Metr)* history ___
￭

🅺 MM2200087 : NObj <MultiMeter>
//_RO List 🅥(Metr)* history ___

￭

#define kVOLTS      @"VOLTS"
#define kAMPS       @"AMPS"
#define kOHMS       @"OHMS"

#define kLCD				@"lcd"
#define kFLAGS   		@"flags"


#define kNEGATIVE   @"MINUS"				// 0001 | 1___      BYTE 1
#define kAC					@"AC"						//			| _1__
#define kAUTO       @"AUTO"					//		  | ___1

#define kCONTINUITY @"CONTINUITY"		// 0010 | X___      BYTE 2
#define kDIODE      @"DIODE"        //	 	  | _X__
#define kLOWBATT    @"LOW BATTERY"  //		  | __X_
#define kHOLD       @"HOLD"					//			| ___X

#define kMAX				@"MAX"					// 0011 | X___      BYTE 3


#define SERIALPORTMANAGER [ORSSerialPortManager sharedSerialPortManager]
#define SERIALPORTS       [SERIALPORTMANAGER             availablePorts]

@import IOKit.serial;
@import IOKit.usb;
@import IOKit;

@interface USBWatcher : NSArrayController
{
  io_iterator_t		   gNewDeviceAddedIter, gNewDeviceRemovedIter;
  IONotificationPortRef   gNotifyPort;
  CFMutableDictionaryRef  classToMatch;
}
@end

