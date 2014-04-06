


@interface                CPUMonitor : NSObject

@property (readonly)        NSString * usage;
@property (nonatomic) NSTimeInterval   interval;
@property                       BOOL   normalize;
@property                    CGFloat   percent;

@end
