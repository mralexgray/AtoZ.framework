

@import AtoZUniversal; @class SPrt ___ /*! USAGE:

  _meter = [MM2200087 meterOnPort:SERIALPORTS[1] onChange:^{

    [_meter log];
    [_display setStringValue:_meter.display];

  }];

*/

🆅 MultiMeter <NObj> @Optn

_NC  Blk      onChange ___
_RO _SPrt         port ___

_RO _SInt decimalPlace ___
_RO _IsIt          max __
               updated ___

_RO _Text      display ___
_RO _List        flags ___

￭

🅺 MM2200087 : NSO <MultiMeter>

+ _Kind_  meterOnPort __SPrt_ port onChange: _Blk_ onChange ___

￭

#define kAUTO       @"AUTO"
#define kNEGATIVE   @"MINUS"
#define kLOWBATT    @"LOW BATTERY"
#define kVOLTS      @"VOLTS"
#define kAMPS       @"AMPS"
#define kOHMS       @"OHMS"

#define SERIALPORTS ORSSerialPortManager.sharedSerialPortManager.availablePorts




/*

# converts serial data to an array of strings
# each of which is a binary representation of a single byte
def getArrFromStr(serialData):
    output = []
    inputList = serialData.split(" ")
    for value in inputList:
        # The [2:] removes the first 2 characters so as to trim off the 0b
        binStr = bin(int(value, base=16))[2:]
        # we add enough 0s to the front in order to make it 8 bytes
        # (since bin() trims off zeros in the start)
        for i in range(8 - len(binStr)):
            binStr = '0' + binStr
        output.append(binStr)
    return output


def processDigit(digitNumber, binArray):
    decimalPointBool = False
    # Allows easy detection of failed digit detection
    digitValue = -1
    bin = []
    if digitNumber == 4:
        # reverse. start with bit 0, not bit 7
        bin.append(binArray[2][::-1])
        # reverse. start with bit 0, not bit 7
        bin.append(binArray[3][::-1])
    if digitNumber == 3:
        # reverse. start with bit 0, not bit 7
        bin.append(binArray[4][::-1])
        # reverse. start with bit 0, not bit 7
        bin.append(binArray[5][::-1])
    if digitNumber == 2:
        # reverse. start with bit 0, not bit 7
        bin.append(binArray[6][::-1])
        # reverse. start with bit 0, not bit 7
        bin.append(binArray[7][::-1])
    if digitNumber == 1:
        # reverse. start with bit 0, not bit 7
        bin.append(binArray[8][::-1])
        # reverse. start with bit 0, not bit 7
        bin.append(binArray[9][::-1])
    digitDict = {}
    # Creates a dictionary where the key;s follow the protocol desc in
    # readme.md
    digitDict['A'] = int(bin[0][0])
    digitDict['F'] = int(bin[0][1])
    digitDict['E'] = int(bin[0][2])
    digitDict['B'] = int(bin[1][0])
    digitDict['G'] = int(bin[1][1])
    digitDict['C'] = int(bin[1][2])
    digitDict['D'] = int(bin[1][3])
    # passes the digit dict to getCharFromDigitDict to decode what the value is
    digitValue = getCharFromDigitDict(digitDict)
    # checks if there should be a decimal point
    decimalPointBool = bool(int(bin[0][3]))
    # if it is digit 4, a decimal point actually means MAX not decimal pt
    # (see readme.md for full description of protocol)
    if digitNumber == 4:
        decimalPointBool = False
    # Returns a tuple containing both whether or not to include a decimal pt
    # and the digit on the display
    return (decimalPointBool, digitValue)


# Returns a char based off of the digitDictionary sent to it
def getCharFromDigitDict(digitDict):
    if is9(digitDict):
        return 9
    if is8(digitDict):
        return 8
    if is7(digitDict):
        return 7
    if is6(digitDict):
        return 6
    if is5(digitDict):
        return 5
    if is4(digitDict):
        return 4
    if is3(digitDict):
        return 3
    if is2(digitDict):
        return 2
    if is1(digitDict):
        return 1
    if is0(digitDict):
        return 0
    if isC(digitDict):
        return 'C'
    if isF(digitDict):
        return 'F'
    if isE(digitDict):
        return 'E'
    if isP(digitDict):
        return 'P'
    if isN(digitDict):
        return 'N'
    if isL(digitDict):
        return 'L'

'''
All of these is*(digitDict) methods are essentially implementing a
bitmask to convert a series of bits into characters or numbers
While this is a horrible format, it works and is unlikely to be changed
as switching to a more traditional bitmask is not that advantageous
'''


def isE(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 1 and digitDict['B'] == 0 and \
       digitDict['C'] == 0 and digitDict['D'] == 1 and digitDict['E'] == 1:
        return True
    return False


def isN(digitDict):
    if digitDict['A'] == 0 and digitDict['F'] == 0 and \
       digitDict['G'] == 1 and digitDict['B'] == 0 and \
       digitDict['C'] == 1 and digitDict['D'] == 0 and digitDict['E'] == 1:
        return True
    return False


def isL(digitDict):
    if digitDict['A'] == 0 and digitDict['F'] == 1 and \
       digitDict['G'] == 0 and digitDict['B'] == 0 and \
       digitDict['C'] == 0 and digitDict['D'] == 1 and digitDict['E'] == 1:
        return True
    return False


def isP(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 1 and digitDict['B'] == 1 and \
       digitDict['C'] == 0 and digitDict['D'] == 0 and digitDict['E'] == 1:
        return True
    return False


def isF(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 1 and digitDict['B'] == 0 and \
       digitDict['C'] == 0 and digitDict['D'] == 0 and digitDict['E'] == 1:
        return True
    return False


def isC(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 0 and digitDict['B'] == 0 and \
       digitDict['C'] == 0 and digitDict['D'] == 1 and digitDict['E'] == 1:
        return True
    return False


def is9(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 1 and digitDict['B'] == 1 and \
       digitDict['C'] == 1 and digitDict['D'] == 1 and digitDict['E'] == 0:
        return True
    return False


def is8(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 1 and digitDict['B'] == 1 and \
       digitDict['C'] == 1 and digitDict['D'] == 1 and digitDict['E'] == 1:
        return True
    return False


def is7(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 0 and \
       digitDict['G'] == 0 and digitDict['B'] == 1 and \
       digitDict['C'] == 1 and digitDict['D'] == 0 and digitDict['E'] == 0:
        return True
    return False


def is6(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 1 and digitDict['B'] == 0 and \
       digitDict['C'] == 1 and digitDict['D'] == 1 and digitDict['E'] == 1:
        return True
    return False


def is5(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 1 and digitDict['B'] == 0 and \
       digitDict['C'] == 1 and digitDict['D'] == 1 and digitDict['E'] == 0:
        return True
    return False


def is4(digitDict):
    if digitDict['A'] == 0 and digitDict['F'] == 1 and \
       digitDict['G'] == 1 and digitDict['B'] == 1 and \
       digitDict['C'] == 1 and digitDict['D'] == 0 and digitDict['E'] == 0:
        return True
    return False


def is3(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 0 and \
       digitDict['G'] == 1 and digitDict['B'] == 1 and \
       digitDict['C'] == 1 and digitDict['D'] == 1 and digitDict['E'] == 0:
        return True
    return False


def is2(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 0 and \
       digitDict['G'] == 1 and digitDict['B'] == 1 and \
       digitDict['C'] == 0 and digitDict['D'] == 1 and digitDict['E'] == 1:
        return True
    return False


def is1(digitDict):
    if digitDict['A'] == 0 and digitDict['F'] == 0 and \
       digitDict['G'] == 0 and digitDict['B'] == 1 and \
       digitDict['C'] == 1 and digitDict['D'] == 0 and digitDict['E'] == 0:
        return True
    return False


def is0(digitDict):
    if digitDict['A'] == 1 and digitDict['F'] == 1 and \
       digitDict['G'] == 0 and digitDict['B'] == 1 and \
       digitDict['C'] == 1 and digitDict['D'] == 1 and digitDict['E'] == 1:
        return True
    return False

global debug
debug = False


'''
    Checks all possible flags that might be needed
    and returns a list containing all currently active flags
    strToFlags('12 20 37 4d 53 6f 79 8f 97 ad b0 c0 d2 e0'
    binArray =
        ['00010010', '00100000', '00110111', '01001101',
         '01010011', '01101111', '01111001', '10001111',
         '10010111', '10101101', '10110000', '11000000',
         '11010010', '11100000']
'''


def strToFlags(strOfBytes):

    flags = []
    binArray = getArrFromStr(strOfBytes)
    if debug:
        print('strToFlags. strOfBytes: {0}\n binarray: {1}',
              strOfBytes, binArray)

    for index, binStr in enumerate(binArray):
        binArray[index] = binStr[::-1]
    if binArray[0][2] == '1':
        flags.append('AC')
    # Don't display this because it will always be on since
    # whenever we are getting input, it will be on.
    # if binArray[0][1] == '1':
    #   flags.append('SEND')
    if binArray[0][0] == '1':
        flags.append('AUTO')
    if binArray[1][3] == '1':
        flags.append('CONTINUITY')
    if binArray[1][2] == '1':
        flags.append('DIODE')
    if binArray[1][1] == '1':
        flags.append('LOW BATTERY')
    if binArray[1][0] == '1':
        flags.append('HOLD')
    if binArray[10][0] == '1':
        flags.append('MIN')
    if binArray[10][1] == '1':
        flags.append('REL DELTA')
    if binArray[10][2] == '1':
        flags.append('HFE')
    if binArray[10][3] == '1':
        flags.append('Percent')
    if binArray[11][0] == '1':
        flags.append('SECONDS')
    if binArray[11][1] == '1':
        flags.append('dBm')
    if binArray[11][2] == '1':
        flags.append('n (1e-9)')
    if binArray[11][3] == '1':
        flags.append('u (1e-6)')
    if binArray[12][0] == '1':
        flags.append('m (1e-3)')
    if binArray[12][1] == '1':
        flags.append('VOLTS')
    if binArray[12][2] == '1':
        flags.append('AMPS')
    if binArray[12][3] == '1':
        flags.append('FARADS')
    if binArray[13][0] == '1':
        flags.append('M (1e6)')
    if binArray[13][1] == '1':
        flags.append('K (1e3)')
    if binArray[13][2] == '1':
        flags.append('OHMS')
    if binArray[13][3] == '1':
        flags.append('Hz')
    return flags


'''
    converts a string of space separated hexadecimal bytes
    into numbers following the protocol in readme.md


    ('strToDigits(strOfBytes = '12 20 37 4d 53 6f 79 8f 97 ad b0 c0 d2 e0')
    strToDigits got:09.30
    | 09.30 VOLTS |
'''


def strToDigits(strOfBytes):

    if debug:
        print('strToDigits(strOfBytes) {0}', strOfBytes)
    # Create an array of the binary values from those hexadecimal bytes
    binArray = getArrFromStr(strOfBytes)
    digits = ""
    # reversed rabge so that we iterate through values 4,3,2,1 in that order
    # due to how serial protocol works (see readme.md)
    for number in reversed(range(1, 5)):
        out = processDigit(number, binArray)
        if out[1] == -1:
            print("Protocol Error: Please start an issue here: \
                https://github.com/ddworken/2200087-Serial-Protocol/issues \
                and include the following data: '" + strOfBytes + "'")
            sys.exit(1)
        # append the decimal point if the decimalPointBool in the tuple is true
        if out[0]:
            digits += "."
        digits += str(out[1])
    # following the serial protocol, calc. whether or not a neg sign is needed
    minusBool = bool(int(binArray[0][::-1][3]))
    if minusBool:
        digits = '-' + digits
    if debug:
        print('strToDigits got:' + digits)
    return digits


def mainLoop(args):
    if len(args.port) == 1:
        ser = serial.Serial(port=args.port[0], baudrate=2400,
                            bytesize=8, parity='N', stopbits=1, timeout=5,
                            xonxoff=False, rtscts=False, dsrdtr=False)
        # global grapher
        # grapher = grapher([0])
        # if args.csv:
        #     print args.port[0] + ','
        if not args.csv:
            print("| " + args.port[0] + " |")
        while(True):
            chunk = getSerialChunk(ser)
            digits = strToDigits(chunk)
            flags = ' '.join(strToFlags(chunk))
            if "None" not in digits:
                # if args.csv:
                #     if not args.quiet:
                #         print(digits + ' ' + flags + ",")
                #     if args.quiet:
                #         print(digits + ",")
                # if not args.csv:
                if not args.quiet:
                    print("| " + digits + ' ' + flags + " |")
                else:
                    print("| " + digits + " |")


def getSerialChunk(ser):
    while True:
        chunk = []
        for i in range(14):
            ch = ser.read(1).encode('hex')
            if debug:
                print('appending chunk ' + ch)
            '''
                appending chunk 12
                appending chunk 20
                appending chunk 37
                appending chunk 4d
                appending chunk 53
                appending chunk 6f
                appending chunk 79
                appending chunk 8f
                appending chunk 97
                appending chunk ad
                appending chunk b0
                appending chunk c0
                appending chunk d2
                appending chunk e0
                | 09.30 VOLTS |
            '''
            chunk.append(ch)
        if chunk[0][0] != '1':
            startChunk = []
            endChunk = []
            for index, byte in enumerate(chunk):
                if byte[0] == '1':
                    startChunk = chunk[index:]
                    endChunk = chunk[:index]
                    chunk = startChunk + endChunk
                    if debug:
                        print('startChunk:{0}, endChunk:{1}. chunk;{2}',
                              startChunk, endChunk, chunk)
                    return " ".join(chunk)


'''
['13','20','30','42','50','62','70','82','98','a2','b0','c0','d3'],
['e0'],
['13','20','30','42','50','62','70','82','98','a2','b0','c0','d3','e0']
'''


# Allows for usage of above methods in a library
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--graph", help="Use this argument if you want \
                        to display a graph. ",
                        action="store_true")
    parser.add_argument("-p", "--port", nargs='*',
                        help="The serial port to use",
                        default="/dev/ttyUSB0")
    parser.add_argument("-q", "--quiet", help="Use this argument if you \
                        only want the numbers, not the description. ",
                        action="store_true")
    parser.add_argument("-c", "--csv", help="Use this argument to enable \
                        csv output", action="store_true")
    args = parser.parse_args()
    mainLoop(args)  # Call the mainLoop method with a list cont. serial data

*/


//#define CKSUMOFF	0x57	/* checksum offset */
//#define SEGBITS		0xf7	/* digit segment bits */
//#define DPBIT		0x08	/* decimal point bit */
//#define NODIGIT		-1	/* no digit */
//#define NMODES		26	/* number of mode values */
//#define NBYTES		0x100	/* number of possible bytes */

//typedef struct frame_t
//{
//  unsigned char mode;     /* multimeter mode */
//  unsigned char units1;   /* units and other flags */
//  unsigned char units2;   /* more units and stuff */
//  unsigned char digit4;   /* digit 4 */
//  unsigned char digit3;   /* digit 3 */
//  unsigned char digit2;   /* digit 2 */
//  unsigned char digit1;   /* digit 1 */
//  unsigned char flags;    /* flags */
//  unsigned char cksum;    /* checksum */
//} frame;

//typedef struct frame frame_t;

//typedef struct digit_t
//{
//  unsigned segments;	 /* segment bits */
//  int digit;		 /* resulting digit */
//
//} digit;

//typedef struct digit digit_t;

//static char *modes[] = {
//  "DC V",
//  "AC V",
//  "DC uA",
//  "DC mA",
//  "DC A",
//  "AC uA",
//  "AC mA",
//  "AC A",
//  "OHM",
//  "CAP",
//  "HZ",
//  "NET HZ",
//  "AMP HZ",
//  "DUTY",
//  "NET DUTY",
//  "AMP DUTY",
//  "WIDTH",
//  "NET WIDTH",
//  "AMP WIDTH",
//  "DIODE",
//  "CONT",
//  "HFE",
//  "LOGIC",
//  "DBM",
//  "EF",
//  "TEMP"
//};

//static struct digit_t digits[] = {
//  {0xd7, '0'},
//  {0x50, '1'},
//  {0xb5, '2'},
//  {0xf1, '3'},
//  {0x72, '4'},
//  {0xe3, '5'},
//  {0xe6, '6'},
//  {0xe7, '6'},
//  {0x51, '7'},
//  {0xf7, '8'},
//  {0x73, '9'},
//  {0xf3, '9'},
//  {0x20, '-'},
//  {0, NODIGIT}
//};
