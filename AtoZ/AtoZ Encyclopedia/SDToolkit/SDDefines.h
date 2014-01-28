
// Convenience Macros
#define SDDefaults [NSUserDefaults standardUserDefaults]

#if defined(DEBUG)
	#define SDLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
	#define SDLog(format, ...)
#endif

//#define NSSTRINGF(x, args...) [NSString stringWithFormat:x , ## args]
#define NSINT(x) [NSNumber numberWithInt:x]
#define NSFLOAT(x) [NSNumber numberWithFloat:x]
#define NSDOUBLE(x) [NSNumber numberWithDouble:x]
#define NSBOOL(x) [NSNumber numberWithBool:x]

#define SDInfoPlistValueForKey(key) [[NSBundle mainBundle] objectForInfoDictionaryKey:key]
