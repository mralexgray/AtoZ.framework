

@import AtoZ;

#define LOG_EVENT(event) printf( "" #event " device: %s\n", device.description.UTF8String);

int main()
{
    AZSHAREDAPP;

    NSLog(@"%@", [USBDevice.getAllAttachedDevices valueForKey:@"DeviceFriendlyName"]);

    [USBDevice monitorConnected:^(NSDictionary *device){ LOG_EVENT(CONNECTED); }
                        removed:^(NSDictionary *device){ LOG_EVENT(REMOVED);   }];

    return [IO run], 0;
}
