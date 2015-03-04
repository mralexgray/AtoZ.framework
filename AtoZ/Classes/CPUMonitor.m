
#import <AtoZ/AtoZ.h>
#import "CPUMonitor.h"

@implementation CPUMonitor { unsigned long prevUsed, prevTotal; }

- (id) init { self = super.init; unsigned long cpuCount;

  [self getProcessorUsage:&prevUsed total:&prevTotal cpuCount:&cpuCount];
  [self bind:@"normalize" toObject:NSUserDefaultsController.sharedUserDefaultsController
                       withKeyPath:@"values.normalizeCPUUsage"
                           options:@{@"NSContinuouslyUpdatesValue":@YES}];
    self.interval = 4;
    return self;
}
- (void) setInterval:(NSTimeInterval)interval { static id timer = nil;

  timer ? [timer invalidate] : nil;
  timer = [NSTimer scheduledTimerWithTimeInterval:_interval = interval target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)getProcessorUsage:(unsigned long*)outUsed total:(unsigned long*)outTotal cpuCount:(unsigned long*)outCPUCount {

	natural_t cpuCount; processor_info_array_t infoArray;	mach_msg_type_number_t infoCount;

	kern_return_t error = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &cpuCount, &infoArray, &infoCount);
	if (error) mach_error("host_processor_info error:", error), abort();

	processor_cpu_load_info_data_t* cpuLoadInfo = (processor_cpu_load_info_data_t*) infoArray;

	unsigned long totalTicks = 0, usedTicks = 0;

	for (int cpu=0; cpu<cpuCount; cpu++)
		for (int state=0; state<CPU_STATE_MAX; state++) {
			unsigned long ticks = cpuLoadInfo[cpu].cpu_ticks[state];
			if (state != CPU_STATE_IDLE) usedTicks += ticks;
			totalTicks += ticks;
		}

	*outUsed = usedTicks;	*outTotal = totalTicks; *outCPUCount = cpuCount;

  vm_deallocate(mach_task_self(), (vm_address_t)infoArray, infoCount);
}

- (void)update:(id)unused {  unsigned long used, total, cpuCount;

    [self getProcessorUsage:&used total:&total cpuCount:&cpuCount];
    
    unsigned long diffUsed = used - prevUsed, diffTotal = total - prevTotal;

    if (!_normalize) diffTotal /= cpuCount;
		
    prevUsed      = used;
    prevTotal     = total;
    self.percent  = (CGFloat)diffUsed/(CGFloat)diffTotal;
}

- (NSString*)usage { return [NSString stringWithFormat:@"%0.f%%", 100. * _percent]; }

+ (NSSet*) keyPathsForValuesAffectingUsage { return [NSSet setWithObjects:@"normalize",@"percent",nil]; }
@end
