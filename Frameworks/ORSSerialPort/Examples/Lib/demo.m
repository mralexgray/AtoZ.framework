
#import "usbserialquery.h"

int USAGE () {

  const char * app = NSProcessInfo.processInfo.processName.UTF8String;

  return fprintf(stderr, "USAGE: %s [port]"
                         "  # by default will guess [port] or provide [port] explicitly like \"/dev/tty.usbmodem935591\" \n"
                         "       %s --help"
                         "  # show this text\n\n"
                         "Note: If running in Xcode, add arguments in \"Scheme Settings...\\n", app, app), 1;
}


ssize_t whatecver = 1;


int main() {

  @autoreleasepool {

    id args = NSProcessInfo.processInfo.arguments, tty = [args count] > 1 ? args[1] : nil, info = nil;

    if ([args containsObject:@"--help"] || !(info = getInfoForSerialUSB(tty)) || !(info[kVID] && info[kPID])) return USAGE();

    printf("%s\n\nProduct ID: %s\nVendor ID: %s\n",[info[kUSB] UTF8String], [info[kVID] UTF8String], [info[kPID] UTF8String]);

  }

  return 0;
}
