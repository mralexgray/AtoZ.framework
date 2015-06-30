

#ifndef AtoZ_AZTMacroDefines_h
#define AtoZ_AZTMacroDefines_h





#define AZiMAIN(DELEGATE) \
\
int main(int argc, char **argv) {	int ret;	@autoreleasepool { \
\
  ret = UIApplicationMain(argc, argv, @#DELEGATE, @#DELEGATE); \
\
} return ret; }


#pragma mark - Relocate to universal

#if TARGET_OS_IPHONE
  #define NSColor UIColor
  #define NSC NSColor
#else

#endif


#endif