var $ = require('NodObjC');

$.import('Cocoa');

var installNSBundleHook = function() {
    var cls = $.NSBundle;

    if (cls) {
        var bundleIdentifier = cls.getInstanceMethod('bundleIdentifier');
        bundleIdentifier.setImplementation(function(val) {
            return $('com.tinyspeck.slackmacgap');
        });
        return true;
    }
    return false;
};

installNSBundleHook();
var pool = $.NSAutoreleasePool('alloc')('init');

var NSUserNotificationCenterDelegate = $.NSObject.extend('NSUserNotificationCenterDelegate');

NSUserNotificationCenterDelegate.addMethod('init', {
    retval: '@',
    args: ['@', ':']
}, function(self) {
    $.NSUserNotificationCenter('defaultUserNotificationCenter')('setDelegate', self);

    return self;
});

NSUserNotificationCenterDelegate.addMethod('sendNotificationWithTitle:withInfo:', {
    retval: 'v',
    args: ['@', ':', '@', '@']
}, function(self) {
    console.log(arguments);
    var center = $.NSUserNotificationCenter('defaultUserNotificationCenter');
    var notification = $.NSUserNotification('alloc')('init');
    notification('setTitle', $('title'));
    notification('setInformativeText', $('hello, world!'));
    notification('setSoundName', $('NSUserNotificationDefaultSoundName'));

    center('deliverNotification', notification);
});

NSUserNotificationCenterDelegate.addMethod('userNotificationCenter:didActivateNotification:', {
    retval: 'v',
    args: ['@', ':', '@', '@']
}, function(self, e, center, notification) {
    console.log('CLICKED');
});

NSUserNotificationCenterDelegate.addMethod('userNotificationCenter:shouldPresentNotification:', {
    retval: 'v',
    args: ['@', ':', '@', '@']
}, function(self) {
    return true;
});

var center = NSUserNotificationCenterDelegate('alloc')('init');
var string = $.NSString('stringWithUTF8String', 'Hello Objective-C World!');
console.log(string);
center('sendNotificationWithTitle', string, 'withInfo', string);

$.NSRunLoop('mainRunLoop')('run');