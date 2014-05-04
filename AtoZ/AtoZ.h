                                                                                   #define AtoZLOGO @"\
																																																			\
							db            ,d                     888888888888																				\
						 d88b           88                              ,88																				\
            d8'`8b        MM88MMM                         ,88^ 																				\
           d8'  `8b         88        ,adPPYba,         ,88^   																				\
          d8YaaaaY8b        88       a8'     '8a      ,88^      																			\
         d8""""""""8b       88       8b       d8    ,88^       																				\
        d8'        `8b      88       '8a,   ,a8'   88^         																				\
       d8'          `8b     'Y888     `^YbbdP^'    888888888888																				\
																																																		  \
			     _    _     _           _            _    _																									\
          |_   |_)   /_\   |\/|  |_  |  |  |  / \  |_)  |/																						\
					|    | \  /   \  |  |  |_   \/ \/   \_/  | \  |\																						\
																																																			"
                                                                                  #define AZWELCOME @"\
Bienvenidos! いらっしゃいませ！добро пожаловать! Willkommen! 接 待! Bonjour!                          \
  Welcome to 𝗔𝗍𝗈𝗭•𝖿𝗋𝖺𝗆𝖾𝗐𝗈𝗋𝗄! © ⅯⅯⅯⅩⅠⅤ ! 𝗀𝗂𝗍𝗁𝗎𝖻.𝖼𝗈𝗆/𝗺𝗿𝗮𝗹𝗲𝘅𝗴𝗿𝗮𝘆                                         "

/*! @discussion 
  
  
  The DTFWYWTPL * The DO THE FUCK WHAT YOU WANT TO PUBLIC LICENSE, Version 2, Modified, ® 2013 Alex Gray, lol.

    You are permitted to copy and distribute verbatim (or modified), copies of this license document.
    As for the software, all rules and stipulations of the DO THE FUCK WHAT YOU WANT TO PUBLIC LICENSE apply, now and in perpetuity.

    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTING, MODIFYING, SLICING AND DICING:

    0.	You just DO WHAT THE FUCK YOU WANT TO DO, baby.
		1.  Stay sexy.

  
@note Important ENV VARS ->    OBJC_PRINT_REPLACED_METHODS   -> figure out which categories are stepping on who's toes! 

REFERECES

VARIADICS ->        /AtoZ.framework/Frameworks/Zangetsu/External/extobjc/Tests/EXTVarargsTest.m





 zero (0) == FALSE  == NO

NOTES:
BLOCKS:

	__block __typeof(self) selfish = self;

LAYERS:

	self.root = [self setupHostViewNamed:@"root"];

KVO:
	
	[AZNOTCENTER addObserverForName:BaseModelSharedInstanceUpdatedNotification object:self queue:AZSOQ usingBlock:^(NSNotification *note) {
			[AZTalker say:@"sharedinstance changed, grrrrl"];
	}];
	
	[self addObserverForKeyPaths:@[@"content" ] task:^(id obj, NSD *change) { [selfish setContentSubLayers];}];
	
	[self addObserverForKeyPaths:@[@"contentLayer",NSViewBoundsDidChangeNotification ] task:^(id obj, NSD *change) { ....
	
AZWORKSPACE:	
											
	selfcontent	= [AZFolder samplerWithCount:RAND_INT_VAL(12, 48)];



Current probs...

objc[81330]: REPLACED: -[NSObject description]  by category NSObject  (IMP was 0x7fff8e09f294 (/usr/lib/libobjc.A.dylib), now 0x7fff90136b30 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: -[NSObject methodSignatureForSelector:]  by category NSObject  (IMP was 0x7fff8e09f203 (/usr/lib/libobjc.A.dylib), now 0x7fff90103af0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: -[NSObject doesNotRecognizeSelector:]  by category NSObject  (IMP was 0x7fff8e09f02a (/usr/lib/libobjc.A.dylib), now 0x7fff901d1220 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: +[NSObject init]  by category NSObject  (IMP was 0x7fff8e09f4b8 (/usr/lib/libobjc.A.dylib), now 0x7fff901d15a0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: +[NSObject dealloc]  by category NSObject  (IMP was 0x7fff8e09f4c0 (/usr/lib/libobjc.A.dylib), now 0x7fff901d1650 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: +[NSObject description]  by category NSObject  (IMP was 0x7fff8e09f291 (/usr/lib/libobjc.A.dylib), now 0x7fff90129330 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: +[NSObject finalize]  by category NSObject  (IMP was 0x7fff8e09f4cd (/usr/lib/libobjc.A.dylib), now 0x7fff901d16f0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: +[NSObject methodSignatureForSelector:]  by category NSObject  (IMP was 0x7fff8e09f1f1 (/usr/lib/libobjc.A.dylib), now 0x7fff9008b2f0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: +[NSObject doesNotRecognizeSelector:]  by category NSObject  (IMP was 0x7fff8e09eff3 (/usr/lib/libobjc.A.dylib), now 0x7fff901d1120 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: +[NSObject instanceMethodSignatureForSelector:]  by category NSObject  (IMP was 0x7fff8e09f1df (/usr/lib/libobjc.A.dylib), now 0x7fff901d12f0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation))
objc[81330]: REPLACED: +[NSObject performSelector:]  by category AZClassProxy  (IMP was 0x7fff8e09f061 (/usr/lib/libobjc.A.dylib), now 0x10006748a (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject properties]  by category AQProperties  (IMP was 0x100028b30 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100166f56 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject properties]  by category Utilities  (IMP was 0x100166f56 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1001b0a61 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject associatedValueForKey:]  by category AssociatedValues  (IMP was 0x100972c20 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x10023bce2 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject valueForUndefinedKey:]  by category AtoZ  (IMP was 0x7fff9294df83 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation), now 0x10023e373 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject setValue:forUndefinedKey:]  by category AtoZ  (IMP was 0x7fff9294e07f (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation), now 0x10023e527 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performBlock:afterDelay:]  by category AtoZ  (IMP was 0x100972df0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x100241bae (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:afterDelay:]  by category AG  (IMP was 0x1001b03be (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002460b7 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSObject classPropsFor:]  by category AG  (IMP was 0x100166193 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100244b33 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withObject:afterSystemIdleTime:withinTimeLimit:startTime:]  by category NoodlePerformWhenIdle  (IMP was 0x100af7280 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x1002476df (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withObject:afterSystemIdleTime:]  by category NoodlePerformWhenIdle  (IMP was 0x100af7610 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x1002478fe (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withObject:afterSystemIdleTime:withinTimeLimit:]  by category NoodlePerformWhenIdle  (IMP was 0x100af7670 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x100247918 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject superclasses]  by category SadunUtilities  (IMP was 0x1001af538 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002479ca (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject invocationWithSelector:andArguments:]  by category SadunUtilities  (IMP was 0x1001af615 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100247a74 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject invocationWithSelectorAndArguments:]  by category SadunUtilities  (IMP was 0x1001afce5 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248149 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withReturnValue:andArguments:]  by category SadunUtilities  (IMP was 0x1001afd8b (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002481ef (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withReturnValueAndArguments:]  by category SadunUtilities  (IMP was 0x1001afdfe (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248262 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject objectByPerformingSelectorWithArguments:]  by category SadunUtilities  (IMP was 0x1001afefa (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10024835e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject objectByPerformingSelector:withObject:withObject:]  by category SadunUtilities  (IMP was 0x1001affbe (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248422 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject objectByPerformingSelector:withObject:]  by category SadunUtilities  (IMP was 0x1001b0254 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002486c7 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject objectByPerformingSelector:]  by category SadunUtilities  (IMP was 0x1001b0269 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002486dc (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withCPointer:afterDelay:]  by category SadunUtilities  (IMP was 0x1001b0280 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002486f3 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withBool:afterDelay:]  by category SadunUtilities  (IMP was 0x1001b0353 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002487c6 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withInt:afterDelay:]  by category SadunUtilities  (IMP was 0x1001b0375 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002487e8 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withFloat:afterDelay:]  by category SadunUtilities  (IMP was 0x1001b0397 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10024880a (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:afterDelay:]  by category SadunUtilities  (IMP was 0x1002460b7 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248831 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject getReturnValue:]  by category SadunUtilities  (IMP was 0x1001b03d2 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248845 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withDelayAndArguments:]  by category SadunUtilities  (IMP was 0x1001b041a (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10024888d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject valueByPerformingSelector:withObject:withObject:]  by category SadunUtilities  (IMP was 0x1001b04fd (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248970 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject valueByPerformingSelector:withObject:]  by category SadunUtilities  (IMP was 0x1001b06a9 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248b1c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject valueByPerformingSelector:]  by category SadunUtilities  (IMP was 0x1001b06be (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248b31 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject selectors]  by category SadunUtilities  (IMP was 0x1001b077d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248bf0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject properties]  by category SadunUtilities  (IMP was 0x1001b0a61 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248ed9 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject ivars]  by category SadunUtilities  (IMP was 0x1001b0d45 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002491c2 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject protocols]  by category SadunUtilities  (IMP was 0x1001b1040 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002494ab (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject hasProperty:]  by category SadunUtilities  (IMP was 0x1001b148d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002496d4 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject hasIvar:]  by category SadunUtilities  (IMP was 0x1001b162d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249874 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject returnTypeForSelector:]  by category SadunUtilities  (IMP was 0x1001b1838 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249abd (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject chooseSelector:]  by category SadunUtilities  (IMP was 0x1001b1884 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249b09 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject tryPerformSelector:withObject:withObject:]  by category SadunUtilities  (IMP was 0x1001b19c4 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249c49 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject tryPerformSelector:withObject:]  by category SadunUtilities  (IMP was 0x1001b1a58 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249cdd (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject tryPerformSelector:]  by category SadunUtilities  (IMP was 0x1001b1a6d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249cf2 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSObject getSelectorListForClass]  by category SadunUtilities  (IMP was 0x1001b06d5 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248b48 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSObject getPropertyListForClass]  by category SadunUtilities  (IMP was 0x1001b09a6 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100248e19 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSObject getIvarListForClass]  by category SadunUtilities  (IMP was 0x1001b0c8a (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249102 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSObject getProtocolListForClass]  by category SadunUtilities  (IMP was 0x1001b0f6e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1002493eb (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSObject classExists:]  by category SadunUtilities  (IMP was 0x1001b17cd (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249a14 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSObject instanceOfClassNamed:]  by category SadunUtilities  (IMP was 0x1001b17e4 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100249a2b (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject boolForKey:]  by category FOOCoding  (IMP was 0x1010c11a0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x10024a78b (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject doubleForKey:]  by category FOOCoding  (IMP was 0x1010c1070 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x10024aaac (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject floatForKey:]  by category FOOCoding  (IMP was 0x1010c0f40 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x10024ab03 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject integerForKey:]  by category FOOCoding  (IMP was 0x1010c1800 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x10024ab5a (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject unsignedIntegerForKey:]  by category FOOCoding  (IMP was 0x1010c1d20 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x10024ac14 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject sVs:fKs:]  by category FOOCoding  (IMP was 0x10023d70f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10024c19e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject performSelector:withValue:]  by category Primitives  (IMP was 0x100242fb2 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10026383e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSObject associatedValueForKey:]  by category REUtil  (IMP was 0x10023bce2 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100283d80 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSNull initWithCoder:]  by category NSNull  (IMP was 0x7fff901d0ef0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff929698cd (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSNull encodeWithCoder:]  by category NSNull  (IMP was 0x7fff901d0f00 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff928d7639 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: +[NSSet supportsSecureCoding]  by category NSSet  (IMP was 0x7fff901d4640 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff928dc7b7 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSSet initWithCoder:]  by category NSSet  (IMP was 0x7fff901d4650 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff9284e49c (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSSet encodeWithCoder:]  by category NSSet  (IMP was 0x7fff901d4660 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff928dc7c2 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSSet all:]  by category FunSize  (IMP was 0x100976490 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x1010c4100 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSSet any:]  by category FunSize  (IMP was 0x1009763b0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x1010c4380 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSSet map:]  by category FunSize  (IMP was 0x100975db0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x1010c4900 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: +[NSDictionary supportsSecureCoding]  by category NSDictionary  (IMP was 0x7fff901cbb20 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff928d0f26 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSDictionary initWithCoder:]  by category NSDictionary  (IMP was 0x7fff901cbb30 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff9286f5ad (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSDictionary encodeWithCoder:]  by category NSDictionary  (IMP was 0x7fff901cbb40 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff928b1739 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSDictionary each:]  by category F  (IMP was 0x10096eea0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x10011a436 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary map:]  by category F  (IMP was 0x10096f950 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x10011a45b (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary reject:]  by category F  (IMP was 0x10096f7e0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x10011a504 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary stringForKey:]  by category Types  (IMP was 0x100e78419 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100131e34 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary arrayForKey:]  by category Types  (IMP was 0x100e7848a (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100131f8f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary stringForKey:]  by category OFExtensions  (IMP was 0x100e78419 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x1001342e9 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary floatForKey:]  by category OFExtensions  (IMP was 0x100c45390 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x10013456d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary pointForKey:]  by category OFExtensions  (IMP was 0x100c45260 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x1001346cd (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary boolForKey:defaultValue:]  by category OFExtensions  (IMP was 0x100e78679 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x10013497f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary boolForKey:]  by category OFExtensions  (IMP was 0x100e78705 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100134a1c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary intForKey:defaultValue:]  by category OFExtensions  (IMP was 0x100e7871d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100134a34 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary intForKey:]  by category OFExtensions  (IMP was 0x100e78756 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100134a7f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary objectForKey:defaultObject:]  by category OFExtensions  (IMP was 0x100e78466 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100134bb0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary deepMutableCopy]  by category OFExtensions  (IMP was 0x100e78542 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100134c49 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDictionary dictionaryByAddingEntriesFromDictionary:]  by category SimpleMutations  (IMP was 0x1010d5970 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x1001352f1 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSArray arrayWithInts:]  by category AtoZ  (IMP was 0x100fe46d0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x10007e7a8 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSArray arrayWithDoubles:]  by category AtoZ  (IMP was 0x100fe4380 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x10007e931 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray initWithCoder:]  by category NSArray  (IMP was 0x7fff901c1050 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff9284f061 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSArray encodeWithCoder:]  by category NSArray  (IMP was 0x7fff901c1060 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff928af54d (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSArray containsObjectIdenticalTo:]  by category FezAdditions  (IMP was 0x7fff901bf130 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff88949b82 (/System/Library/PrivateFrameworks/IMFoundation.framework/Versions/A/IMFoundation))
objc[81330]: REPLACED: -[NSArray firstObject]  by category NUExtensions  (IMP was 0x7fff901258c0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x100fe4220 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs))
objc[81330]: REPLACED: -[NSArray map:]  by category BlocksKit  (IMP was 0x100fe5050 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x10096e220 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit))
objc[81330]: REPLACED: -[NSArray firstObject]  by category Utilities  (IMP was 0x100fe4220 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x10085e5c0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/UAGithubEngine.framework/UAGithubEngine))
objc[81330]: REPLACED: -[NSArray all:]  by category FunSize  (IMP was 0x10096e900 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x1010bc500 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSArray any:]  by category FunSize  (IMP was 0x10096e820 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x1010bc780 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSArray map:]  by category FunSize  (IMP was 0x100fe5050 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x1010bca00 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSArray filter:]  by category FunSize  (IMP was 0x100fe5ce0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x1010bd910 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSArray reversedArray]  by category FunSize  (IMP was 0x7fff901c0030 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x1010beb60 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSArray arrayByRemovingObject:]  by category FunSize  (IMP was 0x100fe4b10 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x1010bedf0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSArray arrayByRemovingObject:]  by category NTExtensions  (IMP was 0x100fe4b10 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x100e87596 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore))
objc[81330]: REPLACED: -[NSArray reversedArray]  by category NTExtensions  (IMP was 0x1010beb60 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x100e879ae (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore))
objc[81330]: REPLACED: -[NSArray stringWithEnum:]  by category AtoZ  (IMP was 0x10007ba40 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10007df99 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray enumFromString:default:]  by category AtoZ  (IMP was 0x10007ba52 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10007dfab (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray enumFromString:]  by category AtoZ  (IMP was 0x10007ba80 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10007e00f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray sortedWithKey:ascending:]  by category AtoZ  (IMP was 0x10085e640 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/UAGithubEngine.framework/UAGithubEngine), now 0x10007e6c7 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray map:]  by category AtoZ  (IMP was 0x100fe5050 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x10007fbcf (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray filter:]  by category AtoZ  (IMP was 0x100fe5ce0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x100080a77 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray firstObject]  by category AtoZ  (IMP was 0x100fe4220 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x100082802 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray firstObject]  by category Extensions  (IMP was 0x100fe4220 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x100083b59 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray stringValue]  by category StringExtensions  (IMP was 0x100c90ec0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x10008520d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray reversedArray]  by category StringExtensions  (IMP was 0x1010beb60 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x100085226 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray firstObject]  by category StringExtensions  (IMP was 0x100fe4220 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x100085276 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray firstObject]  by category UtilityExtensions  (IMP was 0x100fe4220 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x1000853c9 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray map:]  by category UtilityExtensions  (IMP was 0x100fe5050 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x100085a1d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray reject:]  by category UtilityExtensions  (IMP was 0x10096e0e0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x100085eaa (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray select:]  by category CollectionsAdditions  (IMP was 0x10096ded0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x10010f12d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray map:]  by category CollectionsAdditions  (IMP was 0x100fe5050 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x10010f29d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray each:]  by category F  (IMP was 0x10096d930 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x10011a089 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray map:]  by category F  (IMP was 0x100fe5050 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x10011a0d3 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray filter:]  by category F  (IMP was 0x100fe5ce0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaPuffs.framework/CocoaPuffs), now 0x10011a157 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray reject:]  by category F  (IMP was 0x10096e0e0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x10011a17c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSArray first]  by category F  (IMP was 0x1000811b4 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10011a2be (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSMutableArray removeFirstObject]  by category FezAdditions  (IMP was 0x7fff901c2d00 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff8895257d (/System/Library/PrivateFrameworks/IMFoundation.framework/Versions/A/IMFoundation))
objc[81330]: REPLACED: -[NSMutableArray insertObjectsFromArray:atIndex:]  by category NTExtensions  (IMP was 0x7fff901c1d30 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x100e8f9bf (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore))
objc[81330]: REPLACED: -[NSMutableArray removeFirstObject]  by category Extensions  (IMP was 0x7fff8895257d (/System/Library/PrivateFrameworks/IMFoundation.framework/Versions/A/IMFoundation), now 0x100083ba0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSMutableArray removeFirstObject]  by category AG  (IMP was 0x7fff8895257d (/System/Library/PrivateFrameworks/IMFoundation.framework/Versions/A/IMFoundation), now 0x1000840ee (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSMutableArray removeFirstObject]  by category UtilityExtensions  (IMP was 0x7fff8895257d (/System/Library/PrivateFrameworks/IMFoundation.framework/Versions/A/IMFoundation), now 0x1000860c7 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSMutableArray push:]  by category StackAndQueueExtensions  (IMP was 0x1000841fd (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100086319 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSMutableArray pop]  by category StackAndQueueExtensions  (IMP was 0x100084175 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10008632b (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSTimer scheduledTimerWithTimeInterval:repeats:block:]  by category FunSize  (IMP was 0x100af8260 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x1010c5d10 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: +[NSTimer timerWithTimeInterval:repeats:block:]  by category FunSize  (IMP was 0x100af83d0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x1010c5e00 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSLocale initWithCoder:]  by category NSLocale  (IMP was 0x7fff901f1180 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff9295b4b7 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSLocale encodeWithCoder:]  by category NSLocale  (IMP was 0x7fff901f1190 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff9295b433 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSCalendar initWithCoder:]  by category NSCalendar  (IMP was 0x7fff901d8400 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff92906b59 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSCalendar encodeWithCoder:]  by category NSCalendar  (IMP was 0x7fff901d8410 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff92906a0f (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: +[NSString stringWithBytes:length:encoding:]  by category Utilities  (IMP was 0x7fff928dc67a (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation), now 0x100e65ef3 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore))
objc[81330]: REPLACED: +[NSString stringWithData:encoding:]  by category AtoZ  (IMP was 0x100e66967 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x10008f08b (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSString stringWithData:encoding:]  by category Creations  (IMP was 0x100e66967 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100094121 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSString colorFromData:]  by category THColorConversion  (IMP was 0x10008cc78 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1000a74e6 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString stringValue]  by category DKAdditions  (IMP was 0x100c91440 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x100cbff80 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit))
objc[81330]: REPLACED: -[NSString containsString:]  by category Extensions  (IMP was 0x7fff8e88882d (/System/Library/PrivateFrameworks/ISSupport.framework/Versions/A/ISSupport), now 0x1000937b1 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString stringByDeletingPrefix:]  by category Extensions  (IMP was 0x100e6625f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100093b39 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString stringByDeletingSuffix:]  by category Extensions  (IMP was 0x100e66248 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100093bb4 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString range]  by category Shortcuts  (IMP was 0x10008926c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10009482f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString URLEncodedString]  by category SNRAdditions  (IMP was 0x100e666a9 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x100095219 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString startsWith:]  by category IngredientsUtilities  (IMP was 0x10008dbf0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10009594d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString containsString:]  by category IngredientsUtilities  (IMP was 0x7fff8e88882d (/System/Library/PrivateFrameworks/ISSupport.framework/Versions/A/ISSupport), now 0x100095acf (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString range]  by category DSCategory  (IMP was 0x10008926c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100098458 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString contains:]  by category DSCategory  (IMP was 0x10008d846 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100098615 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString containsString:]  by category DSCategory  (IMP was 0x7fff8e88882d (/System/Library/PrivateFrameworks/ISSupport.framework/Versions/A/ISSupport), now 0x100098cbd (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString colorData]  by category THColorConversion  (IMP was 0x10008cc59 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1000a74c7 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString hasCaseInsensitivePrefix:]  by category NSStringAdditions  (IMP was 0x100092c0f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1001ecf75 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSString stringByReplacingCharactersInSet:withString:]  by category NSStringAdditions  (IMP was 0x100cbf7c0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x1001ed342 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSMutableAttributedString setFont:]  by category Additions  (IMP was 0x1010fea70 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/TwUI.framework/TwUI), now 0x10009203f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSNumber zero]  by category AtoZ  (IMP was 0x1010d58b0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x1000c4ee4 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSNumber one]  by category AtoZ  (IMP was 0x1010d58e0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x1000c4eff (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSNumber times:]  by category F  (IMP was 0x1000c502d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10011a7af (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSTimeZone initWithCoder:]  by category NSTimeZone  (IMP was 0x7fff901f0780 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff928db3ae (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSTimeZone encodeWithCoder:]  by category NSTimeZone  (IMP was 0x7fff901f0790 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff929c949d (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: +[NSAffineTransform transformRotatingAroundPoint:byDegrees:]  by category UKShearing  (IMP was 0x1009e6ee0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZAppKit.framework/AtoZAppKit), now 0x1000b5d7a (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSAffineTransform mapFrom:to:]  by category RectMapping  (IMP was 0x100c99c80 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x1000b5660 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSAffineTransform scaleBounds:toHeight:centeredDistance:abovePoint:]  by category RectMapping  (IMP was 0x100c99eb0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x1000b570c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSAffineTransform scaleBounds:toHeight:centeredAboveOrigin:]  by category RectMapping  (IMP was 0x100c99fe0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x1000b57b8 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSAffineTransform flipVertical:]  by category RectMapping  (IMP was 0x100c9a0a0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x1000b57d0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSView isSubviewOfView:]  by category AtoZ  (IMP was 0x1010c6900 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x1000ac887 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSView removeAllSubviews]  by category AtoZ  (IMP was 0x100e7b7df (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x1000ae594 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSImage ikImageNamed:]  by category IKScan  (IMP was 0x7fff87542aca (/System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/ImageKit.framework/Versions/A/ImageKit), now 0x7fff875837a5 (/System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/ImageKit.framework/Versions/A/ImageKit))
objc[81330]: REPLACED: +[NSImage imageFromCGImageRef:]  by category AtoZ  (IMP was 0x100e72ee9 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x1000d7f2f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSImage imageWithPreviewOfFileAtPath:ofSize:asIcon:]  by category QuickLook  (IMP was 0x1000d7fd3 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1000df162 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSImage imageByTilingImages:spacingX:spacingY:vertically:]  by category ImageMerge  (IMP was 0x1000cab3d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100157d32 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSImage drawInRect:]  by category FunSize  (IMP was 0x7fff91e08dc7 (/System/Library/Frameworks/AppKit.framework/Versions/C/AppKit), now 0x1010bf920 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize))
objc[81330]: REPLACED: -[NSImage bitmap]  by category CGImageConversion  (IMP was 0x1000d4b37 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1000d8d83 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSImage cgImage]  by category CGImageConversion  (IMP was 0x1000d4f57 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1000d8f2e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSImage imageRotatedByDegrees:]  by category Transform  (IMP was 0x1000d5076 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100157a1e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSImage imageBorderedWithInset:]  by category ImageMerge  (IMP was 0x1000cafbd (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x100158193 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSImage imageBorderedWithOutset:]  by category ImageMerge  (IMP was 0x1000cb1b8 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x10015838e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDate initWithCoder:]  by category NSDate  (IMP was 0x7fff901c75a0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff92876cce (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSDate encodeWithCoder:]  by category NSDate  (IMP was 0x7fff901c75b0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff928b1d1c (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSNotificationCenter postNotificationOnMainThread:]  by category MainThread  (IMP was 0x1010c04c0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x1000f6603 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSColor randomColor]  by category AtoZ  (IMP was 0x100a37ff0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZAppKit.framework/AtoZAppKit), now 0x10009f9cb (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSColor colorWithHex:]  by category AtoZ  (IMP was 0x1010bef90 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x10009fe13 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSColor r:g:b:a:]  by category AtoZ  (IMP was 0x100a0d310 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZAppKit.framework/AtoZAppKit), now 0x1000a15ea (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSColor randomColor]  by category AIColorAdditions_RandomColor  (IMP was 0x100a37ff0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZAppKit.framework/AtoZAppKit), now 0x1000a533c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSColor tui_colorWithR:G:B:]  by category RGBHex  (IMP was 0x1010fe4f0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/TwUI.framework/TwUI), now 0x10010e68b (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSColor tui_colorWithR:G:B:A:]  by category RGBHex  (IMP was 0x1010fe540 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/TwUI.framework/TwUI), now 0x10010e6a5 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSColor tui_colorWithHex:alpha:]  by category RGBHex  (IMP was 0x1010fe5c0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/TwUI.framework/TwUI), now 0x10010e6e7 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSColor tui_colorWithHex:]  by category RGBHex  (IMP was 0x1010fe640 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/TwUI.framework/TwUI), now 0x10010e70d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSColor contrastingColor]  by category AIColorAdditions_DarknessAndContrast  (IMP was 0x100c43c90 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x1000a4981 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSColor hexString]  by category AIColorAdditions_RepresentingColors  (IMP was 0x100c44030 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/DrawKit.framework/DrawKit), now 0x1000a4b7d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSColor lighterColor]  by category AMAdditions  (IMP was 0x100e8b6e0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x1000a7727 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[CALayer debugDescription]  by category AtoZ  (IMP was 0x7fff8c1bb7c9 (/System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore), now 0x1000f1cee (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSException initWithCoder:]  by category NSException  (IMP was 0x7fff901ce2d0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff9292e9f0 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSException encodeWithCoder:]  by category NSException  (IMP was 0x7fff901ce2e0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff9292e8d4 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: +[NSInvocation invocationWithTarget:block:]  by category jr_block  (IMP was 0x1009711c0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/BlocksKit.framework/BlocksKit), now 0x1001af3eb (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSDateComponents initWithCoder:]  by category _  (IMP was 0x7fff901e62c0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff929071a0 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSDateComponents encodeWithCoder:]  by category _  (IMP was 0x7fff901e62d0 (/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation), now 0x7fff92906d99 (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation))
objc[81330]: REPLACED: -[NSHTTPCookie isEqual:]  by category IGPropertyTesting  (IMP was 0x7fff9294101f (/System/Library/Frameworks/Foundation.framework/Versions/C/Foundation), now 0x10004865f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSIndexPath section]  by category JAListViewExtensions  (IMP was 0x101131c70 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/TwUI.framework/TwUI), now 0x10019c4a1 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[CAAnimation flipAnimationWithDuration:forLayerBeginningOnTop:scaleFactor:]  by category AtoZ  (IMP was 0x10006dc99 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x1000e5644 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[CAAnimation animationDidStop:finished:]  by category AtoZ  (IMP was 0x1011859d0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/TwUI.framework/TwUI), now 0x1000e515e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSBezierPath bezierPathWithPlateInRect:]  by category AtoZ  (IMP was 0x100e76c9d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x1000b70b7 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSBezierPath bezierPathWithRoundedRect:radius:]  by category AtoZ  (IMP was 0x1010d4820 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x1000b9c6d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSBezierPath bezierPathWithRoundedRect:radius:]  by category RoundedRectangle  (IMP was 0x1010d4820 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/FunSize.framework/FunSize), now 0x1000baebe (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSBezierPath quartzPath]  by category AtoZ  (IMP was 0x100953bf0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CFAAction.framework/CFAAction), now 0x1000b8660 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSBezierPath fillWithInnerShadow:]  by category AtoZ  (IMP was 0x100a215d0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZAppKit.framework/AtoZAppKit), now 0x1000b9476 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSButton isSwitchButton]  by category NTExtensions  (IMP was 0x10157cfc8 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaTechStrings.framework/CocoaTechStrings), now 0x100e8f12a (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore))
objc[81330]: REPLACED: -[NSButton textColor]  by category SNRAdditions  (IMP was 0x100a37b00 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZAppKit.framework/AtoZAppKit), now 0x100176c3d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSButton setTextColor:]  by category SNRAdditions  (IMP was 0x100a37cf0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZAppKit.framework/AtoZAppKit), now 0x100176c8d (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSButtonCell isSwitchButtonCell]  by category NTExtensions  (IMP was 0x10157d01c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoaTechStrings.framework/CocoaTechStrings), now 0x100e8f17e (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore))
objc[81330]: REPLACED: -[NSWindow animateToFrame:duration:]  by category NoodleEffects  (IMP was 0x100af9550 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x10024d35f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSWindow _createZoomWindowWithRect:]  by category NoodleEffects  (IMP was 0x100af97e0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x10024d4e8 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSWindow zoomOnFromRect:]  by category NoodleEffects  (IMP was 0x100af9ef0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x10024d98f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSWindow zoomOffToRect:]  by category NoodleEffects  (IMP was 0x100afa0e0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/NoodleKit.framework/NoodleKit), now 0x10024daed (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSWindow copyWithZone:]  by category AtoZ  (IMP was 0x100e7d3d6 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/CocoatechCore.framework/CocoatechCore), now 0x1002502b3 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[NSColorWell _performActivationClickWithShiftDown:]  by category BFColorPickerPopover  (IMP was 0x7fff91d057ed (/System/Library/Frameworks/AppKit.framework/Versions/C/AppKit), now 0x100a38570 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZAppKit.framework/AtoZAppKit))
objc[81330]: REPLACED: +[NSMenuItem initialize]  by category Q  (IMP was 0x7fff918b2e77 (/System/Library/Frameworks/AppKit.framework/Versions/C/AppKit), now 0x10021b4e3 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: +[NSShadow shadow]  by category ADBShadowExtensions  (IMP was 0x7fff91f19e13 (/System/Library/Frameworks/AppKit.framework/Versions/C/AppKit), now 0x1000c2936 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
objc[81330]: REPLACED: -[DOMHTMLInputElement _setAutofilled:]  by category WebDOMHTMLInputElementOperationsPrivate  (IMP was 0x7fff854b7a50 (/System/Library/Frameworks/WebKit.framework/Versions/A/Frameworks/WebCore.framework/Versions/A/WebCore), now 0x7fff87bdd130 (/System/Library/Frameworks/WebKit.framework/Versions/A/WebKit))
objc[81330]: REPLACED: -[TUIView setSubviews:]  by category Subviews  (IMP was 0x10115f8f0 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/TwUI.framework/TwUI), now 0x1001dd4c8 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ))
LOGENV:LogEnvError
-[AZGoogleQuery loadMoreURLs]AZGoogleQuery
0.7984 seconds
objc[81330]: REPLACED: -[NSDictionary boolForKey:defaultValue:]  by category DictionaryExtensions  (IMP was 0x10013497f (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x7fff87300193 (/System/Library/PrivateFrameworks/DiskImages.framework/Versions/A/DiskImages))
objc[81330]: REPLACED: -[NSDictionary boolForKey:]  by category DictionaryExtensions  (IMP was 0x100134a1c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x7fff8737086d (/System/Library/PrivateFrameworks/DiskImages.framework/Versions/A/DiskImages))
objc[81330]: REPLACED: -[NSDictionary integerForKey:]  by category DictionaryExtensions  (IMP was 0x100134b9c (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x7fff87370885 (/System/Library/PrivateFrameworks/DiskImages.framework/Versions/A/DiskImages))
objc[81330]: REPLACED: -[NSDictionary stringForKey:]  by category BetterAccessors  (IMP was 0x1001342e9 (/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/AtoZ), now 0x7fff87370a5e (/System/Library/PrivateFrameworks/DiskImages.framework/Versions/A/DiskImages))


*/

#if 0

-+*%$%*+-+*%$%*+-+*%$-+*%$%*+-+*%$%*+-+*%$-+*%$%*+-+*%$%*+- EXAMPLE OF VARIAIDIC METHOD

- (void) appendObjects:(id)firstObject, ...	{  IF_RETURN(!firstObject);

 id eachObject; va_list argList;
 [self addObject: firstObject];             // The first argument isn't part of the varargs list, so we'll handle it separately.
 va_start(argList, firstObject);            // Start scanning for arguments after firstObject.
 while (eachObject = va_arg(argList,id))    // As many times as we can get an argument of type "id"
  [self addObject:eachObject];              // that isn't nil, add it to self's contents.
 va_end(argumentList);

}

#endif

#ifdef YOU_WANT_TO_UNDERSTAND_METAMACROS

from http://paul-samuels.com

/*! Meta macros are pretty nifty but trying to follow how they work can really challenge the limits of your mental stack frame.
  
  Let's start with a fictitious problem that I would like to solve with some metaprogramming. I would probably never do this in a real project but it gives me a realistic use case to work through.

  Imagine I want my view controllers to fail hard if I forget to connect up an outlet in the xib file. I could start with something like this:

@code
- (void)viewDidLoad {  [super viewDidLoad];
  
  NSParameterAssert(self.firstNameTextField);
  NSParameterAssert(self.lastNameTextField);
  NSParameterAssert(self.passwordTextField);
  NSParameterAssert(self.passwordConfirmationTextField);
}

whoa that's a lot of repetition and it's not going to scale well. What would be great is if I could write some code that would write this repetitious code for me, ideally I would just type something like this:

- (void)viewDidLoad { ...
  
  PASAssertConnections(firstNameTextField, lastNameTextField, passwordTextField, passwordConfirmation);
}
This seems a lot DRY'er so let's aim for something similar to this and see how we get on. @c metamacro_foreach

After examining the metamacros header I can see that there is a foreach macro that sounds like it would be perfect for this task.

The definition of metamacro_foreach looks like this: @c #define metamacro_foreach(MACRO, SEP, ...)

After reading the docs I can see that the MACRO argument should be the name of  */

  1. a macro that takes two arguments in the form of MACRO(INDEX, ARG).
  2. The INDEX parameter will be the index of the current iteration in the for loop 
  3. and the ARG parameter will be the argument for the current iteration in the for loop.

So I need to start of by defining a macro that takes these two arguments and expands to the NSParameterAssert that I want. Here's a first stab at such a macro

#define OUTLET_ASSERT(INDEX, NAME) NSParameterAssert([self NAME])

// I don't actually care to use the value of INDEX so it is ignored. This is the macro that will be used within the metamacro_foreach and will eventually expand into the required NSParameterAsserts.
// In each of the following examples I'll show the input (starting macro) above the 3 dashes and what this would theoretically expand into below the 3 dashes. I'll optionally show any macro definitions at the top of the code block.

// Here's how my OUTLET_ASSERT macro will work:

OUTLET_ASSERT(0, firstNameTextField);
  NSParameterAssert([self firstNameTextField]);


// Now let's see how we can use metamacro_foreach to write the PASAssertConnections macro that will take in a list of ivar names and expand them to the required NSParameterAsserts.

#define metamacro_foreach(MACRO, SEP, ...) \
        metamacro_foreach_cxt(metamacro_foreach_iter, SEP, MACRO, __VA_ARGS__)
        
  metamacro_foreach(OUTLET_ASSERT, ;, firstNameTextField, lastNameTextField)

  metamacro_foreach_cxt(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

// In this case I pass OUTLET_ASSERT as the macro to use on each iteration. I pass ; to use as a separator between iterations, which will terminate each NSParameterAssert. Then finally a comma separated list of ivar names that we are going to iterate over and generate the NSParameterAsserts for.

// With the previous expansion there are now two new macros that we need to look up and understand metamacro_foreach_cxt and metamacro_foreach_iter. metamacro_foreach_iter is arguably the simpler of the two but it's not needed until the end so let's see how metamacro_foreach_cxt expands.

metamacro_foreach_cxt
#define metamacro_foreach_cxt(MACRO, SEP, CONTEXT, ...) \
        metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(__VA_ARGS__))(MACRO, SEP, CONTEXT, __VA_ARGS__)

  metamacro_foreach_cxt(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

  metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(firstNameTextField, lastNameTextField))(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

// Great when this macro expands it introduces 2 more macros to look up, metamacro_concat and metamacro_argcount.

// metamacro_concat is the easier of the two so we'll take a look at that first.

  #define metamacro_concat(A, B) metamacro_concat_(A, B)
        
  #define metamacro_concat_(A, B) A ## B
        
metamacro_concat(metamacro_foreach_cxt, 2)

metamacro_foreach_cxt2

//Cool so metamacro_concat just expands to metamacro_concat_, which then just joins the tokens together using ##. So metamacro_concat just has the effect of joining it's two arguments into one string.

// Now we need to jump back to see how metamacro_argcount works

metamacro_argcount
#define metamacro_argcount(...) \
        metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
        
metamacro_argcount(firstNameTextField, lastNameTextField)

---
        
metamacro_at(20, firstNameTextField, lastNameTextField , 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
The metamacro_argcount macro uses another macro called metamacro_at. The metamacro_at is similar in concept to indexing into an array like myArray[index]. In plain English this macro is the same as "give me the nth item in the following list".

The metamacro_argcount macro uses a clever little trick. If we put the numbers from INDEX down to 0 into an array and then ask for the value at INDEX we would get the last number, which would be 0. If we preprend something to the beginning of this array and asked for the value at INDEX again we would now get 1.

Let's see this in Objective-C so it's easier to picture:

NSInteger index = 3;

@[                           @3, @2, @1, @0 ][index]; //=> @0 - 0 args
@[ @"argument",              @3, @2, @1, @0 ][index]; //=> @1 - 1 arg preprended
@[ @"argument", @"argument", @3, @2, @1, @0 ][index]; //=> @2 - 2 args preprended
The relationship is that when you prepend an argument to the array you shift all of the numeric values to the right by one step, which moves a higher number into the index that is being fetched. This of course only works up to the value of INDEX - so we can tell that this particular implementation of metamacros only supports 20 arguments.

NB - this implementation of metamacros requires at least one argument to be given when using metamacro_argcount.

You'll see the trick of inserting __VA_ARGS__ into argument lists at different points used a few times so it's worth making sure you understand what is happening above.

Ok so that makes sense but what about metamacro_at?

metamacro_at
#define metamacro_at(N, ...) \
        metamacro_concat(metamacro_at, N)(__VA_ARGS__)
Great there's our old friend metamacro_concat so we don't need to look up how that works again to know that this will expand like this:

metamacro_at(20, firstNameTextField, lastNameTextField , 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

---

metamacro_at20(firstNameTextField, lastNameTextField , 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
The change is very subtle. The 20 has moved from being an argument to now actually being part of the macro name. So now we need to look up metamacro_at20

#define metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) metamacro_head(__VA_ARGS__)
It turns out that there are variants of metamacro_at defined for 0 to 20, which allows you to access any of the first 20 arguments from the __VA_ARGS__ arguments.

This is another common trick you'll see with metamacros, at some point you have to knuckle down and write out multiple versions of the same macro to handle different length argument lists. You'll often see that metamacros are generated by other scripts that allow you to specify how many arguments you would like to support without having to hand roll all the variations of metamacro_at0..N.

To make metamacro_at a little easier to digest I'll examine one of the smaller versions of this macro.

#define metamacro_at2(_0, _1, ...) metamacro_head(__VA_ARGS__)

metamacro_at2(firstNameTextField, lastNameTextField, passwordTextField, passwordConfirmationTextField)

---

metamacro_head(passwordTextField, passwordConfirmationTextField)
The _0 and _1 arguments are basically used as placeholders to gobble up the items at indices 0 and 1 from the arguments. Then we bundle the rest of the arguments together with .... The newly trimmed __VA_ARGS__ is then passed into metamacro_head

metamacro_head
#define metamacro_head(...) \
        metamacro_head_(__VA_ARGS__, 0)

#define metamacro_head_(FIRST, ...) FIRST

metamacro_head(passwordTextField, passwordConfirmationTextField)

---

passwordTextField
metamacro_head uses the opposite trick to metamacro_at*. In this case we are only interested in the first item and we want to throw away the rest of the __VA_ARGS__ list. This is achieved by grabbing the first argument in FIRST and then collecting the rest with ....

Wow that escalated quickly. We now need to unwind out mental stack frame back to metamacro_foreach_cxt.

metamacro_foreach_cxt
Now we are more enlightened we can go back and expand both metamacro_concat and metamacro_argcount in the following:

#define metamacro_foreach_cxt(MACRO, SEP, CONTEXT, ...) \
        metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(__VA_ARGS__))(MACRO, SEP, CONTEXT, __VA_ARGS__)
        
metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(firstNameTextField, lastNameTextField))(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

---

metamacro_foreach_cxt2(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)
Don't worry the end is now very much in sight, just a couple more painless macro expansions. The previous expansion gives us the new metamacro_foreach_cxt2 macro to check out.

metamacro_foreach_cxt2
This is another example of macro that has multiple versions defined from 0..20. Each of these foreach macros works by utilising the foreach macro that is defined to take one less argument than itself until we get all the way down to metamacro_foreach_cxt1

#define metamacro_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
    metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) \
    SEP \
    MACRO(1, CONTEXT, _1)
    
metamacro_foreach_cxt2(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)
We are now at the point where we need to see what MACRO expands to. In this case MACRO is actually the metamacro_foreach_iter macro that we passed in near the beginning and I delayed explaining.

metamacro_foreach_iter
This macro is really just an implementation detail and as such shouldn't be used directly but we still want to see what part it plays:

#define metamacro_foreach_iter(INDEX, MACRO, ARG) MACRO(INDEX, ARG)

metamacro_foreach_iter(0, OUTLET_ASSERT, firstNameTextField)

---

OUTLET_ASSERT(0, firstNameTextField)
Nice and simple - metamacro_foreach_iter is just a helper that takes our macro OUTLET_ASSERT and the two arguments that our macro should receive and puts the pieces in the right order to be further expanded into the NSParameterAssert calls that we want.

Thankfully that was only a minor detour so let's get right back to metamacro_foreach_cxt2

#define metamacro_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
    metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) \
    SEP \
    MACRO(1, CONTEXT, _1)
    
metamacro_foreach_cxt2(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

---

metamacro_foreach_cxt1(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField) \
    ; \
    OUTLET_ASSERT(1, lastNameTextField)
If you have gotten this far then the above is nothing special so we can progress straight to the next step:

#define metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) MACRO(0, CONTEXT, _0)
    
metamacro_foreach_cxt1(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField) \
    ; \
    OUTLET_ASSERT(1, lastNameTextField)

---

    OUTLET_ASSERT(0, firstNameTextField) \
    ; \
    OUTLET_ASSERT(1, lastNameTextField)
And that's it - we've followed the metamacro_foreach macro from the beginning of it's use all the way to it's end expansion and hopefully our heads are still in one piece.

Wrapping up
At the beginning of the post I said I was aiming for

PASAssertConnections(firstNameTextField, lastNameTextField, passwordTextField, passwordConfirmation);
now I'm actually one step away from achieving this, but if this post has gotten your interest I'll leave that as a simple exercise - it's always better to learn by doing and not just skimming through blog posts hoping to learn by osmosis.

Metaprogramming is normally something that people associate with more dynamic languages like Ruby but there's a whole load of possibilities and cool tricks out there just waiting to be learned. As always I encourage you to join me in peeling back the curtain and seeing that there is normally no magic to be found in your favorite OSS projects.

#endif


#ifdef __cplusplus
  #define AtoZ_EXTERN extern "C" __attribute__((visibility ("default")))
#else
  #define AtoZ_EXTERN extern __attribute__((visibility ("default")))
#endif

#ifdef __OBJC__

  //@import Cocoa;
  #import <Cocoa/Cocoa.h>                               
  //@import ObjectiveC; 
  #import <Foundation/NSObjCRuntime.h>                  
  //@import QuartzCore; 
  #import <QuartzCore/QuartzCore.h>                   
                                                        //  @import Darwin;
  //#import <ApplicationServices/ApplicationServices.h>   //  @import ApplicationServices;
  //#import <AudioToolbox/AudioToolbox.h>                 //  @import AudioToolbox;
  //#import <AVFoundation/AVFoundation.h>                 //  @import AVFoundation;
  //#import <CoreServices/CoreServices.h>                 //  @import CoreServices;
  //#import <Dispatch/Dispatch.h>                         //  @import Dispatch;
  //#import <SystemConfiguration/SystemConfiguration.h>   //  @import SystemConfiguration;
  //#import <WebKit/WebView.h>
  #import <Zangetsu/Zangetsu.h>

//  #import <RoutingHTTPServer/RoutingHTTPServer.h> //@import RoutingHTTPServer;



  #import "AOPProxy/AOPProxy.h"
  #import "AtoZAutoBox/AtoZAutoBox.h"
  #import "AtoZSingleton/AtoZSingleton.h"
  #import "CollectionsKeyValueFilteringX/CollectionsKeyValueFiltering.h"
  #import "JATemplate/JATemplate.h"
  #import "KVOMap/KVOMap.h"
  #import "ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h"
  #import <AtoZAppKit/AtoZAppKit.h>
  #import <AtoZBezierPath/AtoZBezierPath.h>
  #import <BlocksKit/A2DynamicDelegate.h>
  #import <BlocksKit/BlocksKit.h>
  #import <BWTK/BWToolkitFramework.h>
  #import <CFAAction/CFAAction.h>
  #import <CocoaPuffs/CocoaPuffs.h>
  #import <CocoatechCore/CocoatechCore.h>
  #import <DrawKit/DKDrawKit.h>
  #import <FunSize/FunSize.h>
  #import <KSHTMLWriter/KSHTMLWriter.h>
  #import <MenuApp/MenuApp.h>
  #import <NMSSH/NMSSH.h>
  #import <NoodleKit/NoodleKit.h>
  #import <PhFacebook/PhFacebook.h>
  #import <Rebel/Rebel.h>
  #import <TwUI/TUIKit.h>
  #import <UAGithubEngine/UAGithubEngine.h>
  #import <UIKit/UIKit.h>
  //#import <MapKit/MapKit.h>
  //#import <RoutingHTTPServer/AZRouteResponse.h>

  #import "JREnum.h"
  #import "objswitch.h"
  #import "BaseModel.h"
  #import "AutoCoding.h"
  #import "HRCoder.h"
  #import "F.h"

  #import "AtoZAutoBox/AtoZAutoBox.h"

  #import "BoundingObject.h"

  #import "AtoZTypes.h"
  #import "AtoZMacroDefines.h"

  #import "AtoZUmbrella.h"
  #import "AtoZGeometry.h"
  #import "AtoZCategories.h"

  #import "BlocksAdditions.h"

  #import "AddressBookImageLoader.h"
  #import "AFNetworking.h"
  #import "AGNSSplitView.h"
  #import "AGNSSplitViewDelegate.h"
  #import "AHLayout.h"
  #import "ASIHTTPRequest.h"
  #import "BBMeshView.h"
  #import "BETaskHelper.h"
  #import "BlockDelegate.h"
  #import "ConciseKit.h"
  #import "CPAccelerationTimer.h"
  #import "CTBadge.h"
  #import "CTGradient.h"
  #import "DSObjectiveCSyntaxDefinition.h"
  #import "DSPodfileSyntaxDefinition.h"
  #import "DSPodspecSyntaxDefinition.h"
  #import "DSRubySyntaxDefinition.h"
  #import "DSSyntaxCollection.h"
  #import "DSSyntaxHighlighter.h"
  #import "DSSyntaxTextView.h"
  #import "iCarousel.h"
  #import "JsonElement.h"
  #import "JSONKit.h"
  #import "KGNoise.h"
  #import "LoremIpsum.h"
  #import "MAAttachedWindow.h"
  #import "MAKVONotificationCenter.h"
  #import "MASShortcut.h"  // SHortcut Manager and View
  
  #import "NotificationCenterSpy.h"
  #import "NSBag.h"
  #import "NSMenu+Dark.h" 
  #import "NSObject_KVOBlock.h"
  #import "M13OrderedDictionary.h"
//  #import "NSTerminal.h"
  #import "NSWindow_Flipr.h"
  #import "NullSafe.h"
  #import "ObjectMatcher.h"
  #import "PXListDocumentView.h"
  #import "PXListView.h"
  #import "PXListViewCell.h"
  #import "RuntimeReporter.h"
  #import "SDToolkit.h"
  #import "SelectorMatcher.h"
  #import "SIAppCookieJar.h"
  #import "SIAuthController.h"
  #import "SIConstants.h"
  #import "SIInboxDownloader.h"
  #import "SIInboxModel.h"
  #import "SIViewControllers.h"
  #import "SIWindow.h"
  #import "StandardPaths.h"
  #import "StarLayer.h"
  #import "StickyNoteView.h"
  #import "Transition.h"
  #import "TransparentWindow.h"
  #import "TUIFastIndexPath.h"
  #import "XLDragDropView.h"


  //#import "AtoZMacroDefines.h"
  //#import "AtoZUmbrella.h"
  //#import "AtoZTypes.h"
  //#import "AtoZGeometry.h"
  #import "AtoZFunctions.h"
  #import "AZLog.h"
  #import "AZProxy.h"
  #import "AZBaseModel.h"  // NSDocument / AZDoc

  #import "SynthesizeSingleton.h"
  #import "AZObserversAndBinders.h"

  #import "MondoSwitch.h"

  #import "AssetCollection.h"
  #import "AtoZColorWell.h"
  #import "AtoZContacts.h"
  #import "AtoZDelegate.h"
  #import "AtoZGridView.h"
  #import "AtoZGridViewProtocols.h"
  #import "AtoZInfinity.h"
  #import "AtoZMacroDefines.h"
  #import "AtoZModels.h"
  //#import "AtoZNodeProtocol.h"
  #import "AtoZWebSnapper.h"
  #import "AZApplePrivate.h"
  #import "AZASIMGV.h"
  #import "AZAttachedWindow.h"
  #import "AZAXAuthorization.h"
  #import "AZBackground.h"
  #import "AZBackgroundProgressBar.h"
  #import "AZBlockView.h"
  #import "AZBonjourBlock.h"
  #import "AZBorderlessResizeWindow.h"
  #import "AZBox.h"
  #import "AZBoxGrid.h"
  #import "AZBoxMagic.h"
  #import "AZCalculatorController.h"
  #import "AZCLI.h"
  #import "AZCLICategories.h"
  #import "AZColor.h"
  #import "AZCoreScrollView.h"
  #import "AZDebugLayer.h"
  #import "AZDockQuery.h"
  #import "AZExpandableView.h"
  #import "AZFacebookConnection.h"
  #import "AZFactoryView.h"
  #import "AZFavIconManager.h"
  #import "AZFoamView.h"
  #import "AZGit.h"
  #import "AZGoogleImages.h"
  #import "AZGrid.h"
  #import "AZHomeBrew.h"
  #import "AZHostView.h"
  #import "AZHTMLParser.h"
  #import "AZHTTPURLProtocol.h"
  #import "AZImageToDataTransformer.h"
  #import "AZIndeterminateIndicator.h"
  #import "AZIndexedObjects.h"
  #import "AZInfiniteCell.h"
  #import "AZInstantApp.h"

  #import "AZLassoView.h"
  #import "AZLaunchServices.h"
  #import "AZLayer.h"

  #import "AZLogConsole.h"
  #import "AZMacTrackBall.h"
  #import "AZMedallionView.h"
  #import "AZMouser.h"
  #import "AZObject.h"
  #import "AZObserversAndBinders.h"
  #import "AZPopupWindow.h"
  #import "AZPrismView.h"
  #import "AZProcess.h"
  #import "AZProgressIndicator.h"
  #import "AZPropellerView.h"
  #import "AZProportionalSegmentController.h"
  #import "AZQueue.h"
  #import "AZScrollerLayer.h"
  #import "AZScrollPaneLayer.h"
  #import "AZSegmentedRect.h"
  #import "AZSemiResponderWindow.h"
  #import "AZSimpleView.h"
  #import "AZSizer.h"
  #import "AZSnapShotLayer.h"
  #import "AZSound.h"
  #import "AZSourceList.h"
  #import "AZSpeechRecognition.h"
  #import "AZStopwatch.h"
  #import "AZSyntaxTheme.h"
  #import "AZSynthesize.h"
  #import "AZTalker.h"
  #import "AZTimeLineLayout.h"
  #import "AZToggleArrayView.h"
  #import "AZTrackingWindow.h"
//  #import "AZURLSnapshot.h"
  #import "AZVeil.h"
  #import "AZWeakCollections.h"
  #import "AZWindowExtend.h"
  #import "AZWindowTab.h"
  #import "AZXMLWriter.h"

  #import "NSOperationStack.h"
  #import "Bootstrap.h"
  #import "CalcModel.h"
  #import "CAScrollView.h"
  #import "CAWindow.h"
  #import "DefinitionController.h"
  #import "HTMLNode.h"
  #import "IsometricView.h"
  #import "LetterView.h"


  #import <RoutingHTTPServer/RoutingHTTPServer.h>


  #ifdef DEBUG
    static const int ddLogLevel = LOG_LEVEL_VERBOSE;
  #else
    static const int ddLogLevel = LOG_LEVEL_WARN;
  #endif
#endif

/*	INACTIVE
#import "AZLassoLayer.h"
*/

/*	COLOR AND IMAGE CLASSES */
/*  FACEBOOK	*/
/* CONTROLS */
/* CoreScroll */
/* ESSENTIAL */
/* FOUNDATION CLASSES */
/* MODEL */
/* old home of umbrellas */
/* STACKEXCHANGE */
/* WINDOWS */
//	#import "AtoZModels.h"
//	#import "AZFile.h"
//	#import "AZPalette.h"
//   CORE
// COREDATA
// END CORE
// TwUI
// UNUSED
// Views
//#import "AZBoxLayer.h"
//#import "azCarousel.h"
//#import "AZDarkButtonCell.h"
//#import "AZFileGridView.h"
//#import "AZHTTPRouter.h"
//#import "AZMatteButton.h"
//#import "AZMatteFocusedGradientBox.h"
//#import "AZMattePopUpButton.h"
//#import "AZMattePopUpButtonView.h"
//#import "AZMatteSegmentedControl.h"
//#import "AZNotificationCenter.h"
//#import "AZOverlay.h"
//#import "AZToggleView.h"
//#import "CKSingleton.h"
//#import "CTBlockDescription.h"  in autobox now
//#import "DSURLDataSource.h"
//#import "MondoSwitch.h"
//#import "PythonOperation.h"
//#import "SNRHUDButtonCell.h"
//#import "SNRHUDScrollView.h"
//#import "SNRHUDSegmentedCell.h"
//#import "SNRHUDTextFieldCell.h"
//#import "SNRHUDTextView.h"
//#import "SNRHUDWindow.h"
//#import "TUICarouselNavigationController.h"
//#import "TUINavigationController.h"
//#import "TUIRefreshControl.h"
//#import "TUITableOulineView.h"
//#import <AtoZ
//#import <AtoZUI/AtoZUI.h>
//#import <MapKit/MapKit.h>
//#import <NanoStore/NanoStore.h>
//#import <RMKit/RMKit.h>
//#import <XPCKit/XPCKit.h>
//#import <Zangetsu/Zangetsu.h>
////#import "AZStatusItemView.h"
////#import "SNRHUDImageCell.h"
////#import "SNRHUDKit.h"
//Classes


//
//  ARC Helper
//
//  Version 2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//

//#import <Availability.h>
#undef ah_retain
#undef ah_dealloc
#undef ah_autorelease           // autorelease
#undef ah_dealloc               // dealloc
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_release self
#define ah_autorelease self
#define ah_dealloc self
#else
#define ah_retain retain
#define ah_release release
#define ah_autorelease autorelease
#define ah_dealloc dealloc
#undef __bridge
#define __bridge
#undef __bridge_transfer
#define __bridge_transfer
#endif

//  Weak reference support

//#import <Availability.h>
#if !__has_feature(objc_arc_weak)
#undef ah_weak
#define ah_weak unsafe_unretained
#undef __ah_weak
#define __ah_weak __unsafe_unretained
#endif

//  Weak delegate support

//#import <Availability.h>
#undef ah_weak_delegate
#undef __ah_weak_delegate
#if __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define ah_weak_delegate weak
#define __ah_weak_delegate __weak
#else
#define ah_weak_delegate unsafe_unretained
#define __ah_weak_delegate __unsafe_unretained
#endif

@interface NSObject (AtoZEssential)

-   (id) objectForKeyedSubscript:(id)k;
- (void) setObject:(id)x forKeyedSubscript:(id<NSCopying>)k;

@property (NATOM) BOOL  faded;  // implementations for CALayer, NSView, NSWindow

@property (NATOM) id  representedObject;


@end

typedef id(^FilterBlock)(id element,NSUInteger idx, BOOL *stop);


//static NSEventMask AZMouseActive = NSMouseMovedMask | NSMouseExitedMask |NSMouseEnteredMask);
//static NSEventMask AZMouseButton = NS | NSMouseExitedMask |NSMouseEnteredMask;

/* A shared operation que that is used to generate thumbnails in the background. */
extern NSOperationQueue *AZSharedOperationQueue(void);
extern NSOperationQueue *AZSharedSingleOperationQueue(void);
extern NSOperationQueue *AZSharedOperationStack(void);
@interface NSObject (debugandreturn)
- (id) debugReturn:(id) val;
@end
extern NSString *const AtoZSharedInstanceUpdated;
extern NSString *const AtoZDockSortedUpdated;
@interface NSObject (AtoZDelegate)
- (void) dockItemDidUpdateValues:(NSNotification*)info;
@end


#import "OperationsRunner.h"


/*! @abstract AZClassProxy enables `performSelector` to be called on `Class`'s.  Yay!.
  @discussion (I actually added this to my application delegate and implemented application:delegateHandlesKey:)
              Now you are ready to bind class methods to the Application object, even in the interface builder,
              with the keyPath @"classProxy.CharacterSet.allCharacterSets". */
              
AZNSIFACE(AZClassProxy)
/*! Naive example: @c

 [[NSBundle bundleWithPath:[[NSString stringWithUTF8String:getenv("AZBUILD")] 
                            stringByAppendingPathComponent:@"AtoZ.framework"]] load];
                            
  NSLog(@"%@", objc_msgSend([NSString class], NSSelectorFromString(@"dicksonisms")));
  NSLog(@"%@", objc_msgSend([[@"" valueForKey:@"classProxy"] valueForKey:@"NSString"], NSSelectorFromString(@"dicksonisms")));
*/


@interface NSObject (AZClassProxy)
@property (readonly) AZClassProxy* classProxy;
+ (id)performSelector:(SEL)sel;
@end

#define NSCDR NSCoder
#define CPROXY(x) 	[[@"a" valueForKey:@"classProxy"] valueForKey:@#x]
#define MASCOLORE(x) [x setValue:[CXPROXY(@"NSColor") valueForKey:@"randomColor"] forKey:@"logForeground"]

#define NSPRINT(x) 	[[[@"a" valueForKey:@"classProxy"] valueForKey:@"NSTerminal"]performSelectorWithoutWarnings:NSSelectorFromString(@"printString:") withObject:[x valueForKey:@"colorLogString"]]

@interface AZDummy : NSObject
+ (instancetype) sharedInstance;
//- (void) addOperation:(NSOperation*)op;
@property (RONLY) NSOperationStack *sharedStack;
@property (RONLY) NSOperationQueue *sharedQ, *sharedSQ;
@end

#define TestVarArgs(fmt...) [AtoZ sendArrayTo:$SEL(@"testVarargs:") inClass:AtoZ.class withVarargs:fmt]
#define TestVarArgBlock(fmt...) [AtoZ  varargBlock:^(NSA*values) { [values eachWithIndex:^(id obj, NSInteger idx) {  printf("VARARG #%d:  %s <%s>\n", (int)idx, [obj stringValue].UTF8String, NSStringFromClass([obj class]).UTF8String); }]; } withVarargs:fmt]

@interface NSObject (AZTestRoutine)
+ (NSA*) testableClasses;
+ (NSD*) testableMethods;
@end

// extobjc EXTENSIONS

//#define synthesizeAssociations(...) ({ int x = metamacro_argcount(__VA_ARGS__); metamacro_tail( 
//int sum = firstNum, number;   va_start (args, firstNum);
//    while (1) if (!(number = va_arg (args, int))) break; else sum += number;
//    va_end (args);   return (sum);

/*!
 *	@class      AtoZ
 *	@abstract   A class used to interface with AtoZ
 *	@discussion This class provides a means to interface with AtoZ
 *	 Currently it provides a way to detect if AtoZ is installed and launch the AtoZHelper if it's not already running.
 */
@class MASShortcutView, MASShortcut, AZLiveReload; @interface AtoZ : BaseModel 

@property AZLiveReload *reloader;

/*!
 *	@method isAtoZRunning
 *	@abstract Detects whether AtoZHelper is currently running.
 *	@discussion Cycles through the process list to find whether AtoZHelper is running and returns its findings.
 *	@result Returns YES if AtoZHelper is running, NO otherwise.
 */
//+ (BOOL) isAtoZRunning;
/*	@method setAtoZDelegate:
	@abstract Set the object which will be responsible for providing and receiving Growl information.
	@discussion 
	This must be called before using AtoZApplicationBridge. The methods in the GrowlApplicationBridgeDelegate protocol are required and return the basic information needed to register with Growl. The methods in the GrowlApplicationBridgeDelegate_InformalProtocol informal protocol are individually optional.  They provide a greater degree of interaction between the application and growl such as informing the application when one of its Growl notifications is clicked by the user. The methods in the GrowlApplicationBridgeDelegate_Installation_InformalProtocol informal protocol are individually optional and are only applicable when using the Growl-WithInstaller.framework which allows for automated Growl installation.
	When this method is called, data will be collected from inDelegate, Growl will be launched if it is not already running, and the application will be registered with Growl.
	If using the Growl-WithInstaller framework, if Growl is already installed but this copy of the framework has an updated version of Growl, the user will be prompted to update automatically.
	@param inDelegate The delegate for the GrowlApplicationBridge. It must conform to the GrowlApplicationBridgeDelegate protocol.	*/

#define AZDELEGATE NSObject<AtoZDelegate>
/*!@method growlDelegate
	@abstract Return the object responsible for providing and receiving Growl information.
	@discussion See setGrowlDelegate: for details.
	@result The Growl delegate.	*/
//@property (weak) 	AZDELEGATE	* atozDelegate;
//+ (AZDELEGATE*)delegate;
//@property (readonly) NSMA *delegates;
//+ (NSMA*) delegates;

@property (NATOM) MASShortcutView	* azHotKeyView;
@property (NATOM) MASShortcut 		* azHotKey;
@property (NATOM) 		BOOL 					  azHotKeyEnabled;

@property (NATOM) NSW * azWindow;
@property (NATOM) NSC * logColor;
@property (NATOM)	NSA * basicFunctions,
                      * fonts,
                      * cachedImages;
@property (RONLY) NSB * bundle;
@property (RONLY) BOOL 	inTTY,
                        inXcode;

@property (ASS) IBO 	NSTXTV * stdOutView;

@property AZBonjourBlock *bonjourBlock;


+  (NSS*) macroFor:(NSS*)w;
+  (NSD*) macros;
+  (void) processInfo;
//-  (NSS*) formatLogMessage:(DDLogMessage*)lm;
-  (void) appendToStdOutView:(NSS*)text;
+  (void) playSound:(id)number;
+  (void) playRandomSound;
+  (NSF*) controlFont;
+ (CGFontRef) cfFont; // CF controlFont;
+  (NSA*) fonts;
+  (NSF*) font:(NSS*)family size:(CGF)size;
+  (NSS*) tempFilePathWithExtension:(NSS*)extension;
+  (NSS*) randomFontName;
+  (void) plistToXML: (NSS*) path;
+  (NSA*) dock; // aka AZDock.sharedInstance
+  (NSA*) dockSorted;
+  (NSA*) runningApps;
+  (NSA*) runningAppsAsStrings;
+  (void) trackIt;
-   (NSP) convertToScreenFromLocalPoint: (NSP) point relativeToView: (NSV*) view;
-  (void) moveMouseToScreenPoint: (NSP) point;
-  (void) handleMouseEvent: (NSEventMask)event inView: (NSV*)view withBlock: (void (^)())block;
+  (NSS*) stringForType:		(id)type;
+  (NSS*) version;
+  (NSB*) bundle;
+  (NSS*) resources;
+  (NSA*) appCategories;
+  (NSA*) macPortsCategories;
+  (void) playNotificationSound: (NSD*)apsDictionary;
+  (void) badgeApplicationIcon:  (NSS*)string;
+  (void) testVarargs: (NSA*)args;
+  (NSA*) globalPalette;

/* USAGE:	AZVA_ArrayBlock varargB = ^(NSA* enumerator){ NSLog(@"what a value!: %@", enumerator); };
				[AtoZ varargBlock:varargB withVarargs:@"vageen",@2, GREEN, nil];
*/
+  (void) varargBlock: (void(^)(NSA*enumerator))block withVarargs:(id)varargs, ... NS_REQUIRES_NIL_TERMINATION;
+  (void) sendArrayTo: (SEL)method inClass:(Class)klass withVarargs:(id)varargs, ... NS_REQUIRES_NIL_TERMINATION;
-  (void) performBlock:(VoidBlock)block waitUntilDone:(BOOL)wait;
- (NSJS*) jsonRequest: (NSString*) url;
+ (NSJS*) jsonRequest: (NSString*) url;

//+ (AZPOS) positionForString: (NSS*)strVal;
//+  (NSS*) stringForPosition:(AZPOS)enumVal;
//+ (NSFont*) fontWithSize: (CGFloat) fontSize;
//- (NSFont*) registerFonts:(CGFloat)size;
//+ (void) testSizzle;
//+ (void) testSizzleReplacement;
//+ (NSA*) currentScope;
//+ (NSA*) fengShui;
//+ (NSA*) appFolder;
//+ (NSA*) appCategories;
//+ (NSA*) appFolderSorted;
//+ (NSA*) appFolderSamplerWith: (NSUInteger) apps;
#ifdef GROWL_ENABLED 
- (BOOL) registerGrowl;	<GrowlApplicationBridgeDelegate>
#endif
//@property (NATOM, STRNG) SoundManager *sManager;
//@property (strong, nonatomic) NSLogConsole *console;

@end

@interface AtoZ (MiscFunctions)

+ (void) say:(NSS*)thing;

+  (CGF) clamp: 			(CGF)value	   from:(CGF)minimum to:(CGF)maximum;
+  (CGF) scaleForSize:	(CGS)size	  inRect:(CGR)rect;
+  (CGR) centerSize:		(CGS)size	  inRect:(CGR)rect;
+  (CGP) centerOfRect:	(CGR)rect;
+  (NSR) rectFromPointA:(NSP)pointA andPointB:(NSP)pointB;
+ (void) printRect:		(NSR)toPrint;
+ (void) printCGRect:	(CGR)cgRect;
+ (void) printPoint:		(NSP)toPrint;
+ (void) printCGPoint:	(CGP)cgPoint;
+ (void) printTransform:(CGAffineTransform)t;

+ (NSImage*)cropImage:(NSImage*)sourceImage withRect:(NSRect)sourceRect;

@end

@interface JustABox : NSView
@property (ASS) 		BOOL 	selected;
@property (RDWRT,CP) CASHL *shapeLayer;
@property (RDWRT,CP) NSC 	*save, *color;
@end

@interface CAAnimation (NSViewFlipper)
+(CAA*)flipAnimationWithDuration:(NSTI)duration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGF)scaleFactor;
@end

@interface NSViewFlipperController : NSObject {
	NSView *hostView, *frontView, *backView, *topView, *bottomView;
	CALayer *topLayer, *bottomLayer;
	NSTimeInterval duration;
	BOOL isFlipped;
}
@property (RONLY) 	BOOL isFlipped;
@property (ASS)		NSTI duration;
@property (WK,RONLY)	NSView *visibleView;
-  (id) initWithHostView:(NSV*)newHost frontView:(NSV*)newFrontView backView:(NSV*)newBackView;
-(void) flip;
@end

//typedef void(^log)(NSS*s);


/** The appledoc application handler.

 This is the principal tool class. It represents the entry point for the application. The main promises of the class are parsing and validating of command line arguments and initiating documentation generation. Generation is divided into several distinct phases:

 1. Parsing data from source files: This is the initial phase where input directories and files are parsed into a memory representation (i.e. objects) suitable for subsequent handling. This is where the source code files are  parsed and validated for possible file or object-level incosistencies. This step is driven by `GBParser` class.
 2. Post-processing of the data parsed in the previous step: At this phase, we already have in-memory representation of all source code objects, so we can post-process and validate things such as links to other objects etc. We can also update in-memory representation with this data and therefore prepare everything for the final phase. This step is driven by `GBProcessor` class.
 3. Generating output: This is the final phase where we use in-memory data to generate output. This step is driven by `GBGenerator` class.
 @warning *Global settings implementation details:* To be able to properly apply all levels of settings - factory defaults, global settings and command line arguments - we can't solely rely on `DDCli` for parsing command line args. As the user can supply templates path from command line (instead of using one of the default paths), we need to pre-parse command line arguments for templates switches. The last one found is then used to read global settings. This solves proper settings inheritance up to global settings level. Another issue is how to implement code that deals with global settings; there are several possible solutions (the simplest from programmers point of view would be to force the user to pass in templates path as the first parameter, then `DDCli` would first process this and when we would receive notification, we could parse the option, load in global settings and resume operation). At the end I chose to pre-parse command line for template arguments before passing it to `DDCli`. This did require some tweaking to `DDCli` code (specifically the method that converts option string to KVC key was moved to public interface), but ended up as very simple to inject global settings - by simply using the same KCV messages as `DDCli` uses. This small tweak allowed us to use exactly the same path of handling global settings as normal command line arguments. The benefits are many: all argument names are alreay unit tested to properly map to settings values, code reuse for setting the values.	*/

/*  xcode shortcuts  @property (nonatomic, assign) <\#type\#> <\#name\#>;	*/

/*
 @class AZTaskResponder;
 typedef void (^asyncTaskCallback)(AZTaskResponder *response);
 @interface AZTaskResponder: BaseModel
 @property (copy) BKReturnBlock 		returnBlock;
 @property (copy) asyncTaskCallback 	asyncTask;
 @property (NATOM,STRNG) id response;
 //Atoz
 + (void) aSyncTask:(asyncTaskCallback)handler;
 - (void) parseAsyncTaskResponse;
 // this is how we make the call:
 // [AtoZ aSyncTask:^(AZTaskResponder *response) {   respond to result;  }];
 @end
 */

/*  http://stackoverflow.com/questions/4224495/using-an-nsstring-in-a-switch-statement
 You can use it as

 FilterBlock fb1 = ^id(id element, NSUInteger idx, BOOL *stop){ if ([element isEqualToString:@"YES"]) { NSLog(@"You did it");  *stop = YES;} return element;};
 FilterBlock fb2 = ^id(id element, NSUInteger idx, BOOL *stop){ if ([element isEqualToString:@"NO"] ) { NSLog(@"Nope");		*stop = YES;} return element;};

 NSArray *filter = @[ fb1, fb2 ];
 NSArray *inputArray = @[@"NO",@"YES"];

 [inputArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 [obj processByPerformingFilterBlocks:filter];
 }];
 but you can also do more complicated stuff, like aplied chianed calculations:

 FilterBlock b1 = ^id(id element,NSUInteger idx, BOOL *stop) {return [NSNumber numberWithInteger:[(NSNumber *)element integerValue] *2 ];};
 FilterBlock b2 = ^id(NSNumber* element,NSUInteger idx, BOOL *stop) {
 *stop = YES;
 return [NSNumber numberWithInteger:[element integerValue]*[element integerValue]];
 };
 FilterBlock b3 = ^id(NSNumber* element, NSUInteger idx,BOOL *stop) {return [NSNumber numberWithInteger:[element integerValue]*[element integerValue]];};

 NSArray *filterBlocks = @[b1,b2, b3, b3, b3];
 NSNumber *numberTwo = [NSNumber numberWithInteger:2];
 NSNumber *numberTwoResult = [numberTwo processByPerformingFilterBlocks:filterBlocks];
 NSLog(@"%@ %@", numberTwo, numberTwoResult);
 */

//#pragma GCC diagnostic ignored "-Wformat-security"
//#import <NanoStore/NSFNanoObjectProtocol.h>
//#import <NanoStore/NSFNanoObject.h>
//#import <NanoStore/NSFNanoGlobals.h>
//#import <NanoStore/NSFNanoStore.h>
//#import <NanoStore/NSFNanoPredicate.h>
//#import <NanoStore/NSFNanoExpression.h>
//#import <NanoStore/NSFNanoSearch.h>
//#import <NanoStore/NSFNanoSortDescriptor.h>
//#import <NanoStore/NSFNanoResult.h>
//#import <NanoStore/NSFNanoBag.h>
//#import <NanoStore/NSFNanoEngine.h>
//#import <NanoStore/NSFNanoGlobals.h>
//#import <Growl/Growl.h>
//#import "Nu.h"

// ARC is compatible with iOS 4.0 upwards, but you need at least Xcode 4.2 with Clang LLVM 3.0 to compile it.
//#if !__has_feature(objc_arc)
//#error This project must be compiled with ARC (Xcode 4.2+ with LLVM 3.0 and above)
//#endif


//#define EXCLUDE_STUB_PROTOTYPES 1
//#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>



// #undef ah_retain #undef ah_dealloc #undef ah_autorelease autorelease #undef ah_dealloc dealloc

//
//  ARC Helper
//
//  Version 2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//
/*
	#import <Availability.h>
	#undef ah_retain
	#undef ah_dealloc
	#undef ah_autorelease autorelease
	#undef ah_dealloc dealloc
	#if __has_feature(objc_arc)
		#define ah_retain self
		#define ah_release self
		#define ah_autorelease self
		#define ah_dealloc self
	#else
		#define ah_retain retain
		#define ah_release release
		#define ah_autorelease autorelease
		#define ah_dealloc dealloc
		#undef __bridge
		#define __bridge
		#undef __bridge_transfer
		#define __bridge_transfer
	#endif

	//  Weak reference support

	#import <Availability.h>
	#if !__has_feature(objc_arc_weak)
		#undef ah_weak
		#define ah_weak unsafe_unretained
		#undef __ah_weak
		#define __ah_weak __unsafe_unretained
	#endif

	//  Weak delegate support

	#import <Availability.h>
	#undef ah_weak_delegate
	#undef __ah_weak_delegate
	#if __has_feature(objc_arc_weak) && \
		(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
		__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
		#define ah_weak_delegate weak
		#define __ah_weak_delegate __weak
	#else
		#define ah_weak_delegate unsafe_unretained
		#define __ah_weak_delegate __unsafe_unretained
	#endif

//  ARC Helper ends
*/

//#import "GCDAsyncSocket.h"
//#import "GCDAsyncSocket+AtoZ.h"
//#import "HTTPServer.h"
//#import "HTTPConnection.h"
//#import "HTTPMessage.h"
//#import "HTTPResponse.h"
//#import "HTTPDataResponse.h"
//#import "HTTPAuthenticationRequest.h"
//#import "DDNumber.h"
//#import "DDRange.h"
//#import "DDData.h"
//#import "HTTPFileResponse.h"
//#import "HTTPAsyncFileResponse.h"
//#import "HTTPDynamicFileResponse.h"
//#import "RoutingHTTPServer.h"
//#import "WebSocket.h"
//#import "RouteRequest.h"
//#import "RouteResponse.h"
//#import "WebSocket.h"
//#import "AZWebSocketServer.h"
//#import "HTTPLogging.h"

////@import ObjectiveC;
//#import <Foundation/NSObjCRuntime.h>
////@import Foundation;
//#import <Foundation/Foundation.h>
////@import Security;
//#import <Security/Security.h>
////@import Cocoa;
////@import Carbon;
//#import <Carbon/Carbon.h>
//#import <Python/Python.h>
////@import AppKit;
//#import <AppKit/AppKit.h>
////@import Quartz;
//#import <Quartz/Quartz.h>
////@import QuartzCore;
//#import <Cocoa/Cocoa.h>
//#import <QuartzCore/QuartzCore.h>

////@import AudioToolbox;
//#import <AudioToolbox/AudioToolbox.h>

////@import ApplicationServices;
//#import <ApplicationServices/ApplicationServices.h>

////@import AVFoundation;
//#import <AVFoundation/AVFoundation.h>

////@import CoreServices;
//#import <CoreServices/CoreServices.h>

////@import AudioToolbox;
//#import <AudioToolbox/AudioToolbox.h>

////@import AudioToolbox;
//#import <AudioToolbox/AudioToolbox.h>


//#import <objc/message.h>
//#import <objc/runtime.h>
//#import <AppKit/AppKit.h>
//#import <Quartz/Quartz.h>
//#import <Security/Security.h>
//#import <Foundation/Foundation.h>
//#import <QuartzCore/QuartzCore.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import <CoreServices/CoreServices.h>
//#import <AVFoundation/AVFoundation.h>
//#import <ApplicationServices/ApplicationServices.h>


//#import <stat.h>
//#import <Python/Python.h>
//#import <NanoStore/NanoStore.h>
//#import <Nu/Nu.h>


//  ARC Helper ends


/*
	#if __has_feature(objc_arc)											// ARC Helper Version 2.2
		#define ah_retain 		self
		#define ah_release 		self
		#define ah_autorelease 	self
//		#define release 			self										// Is this right?  Why's mine different?
	//	#define autorelease 		self										// But shit hits fan without.
		#define ah_dealloc 		self
	#else
		#define ah_retain 		retain
		#define ah_release 		release
		#define ah_autorelease 	autorelease
		#define ah_dealloc 		dealloc
		#undef 	__bridge
		#define  __bridge
		#undef   __bridge_transfer
		#define  __bridge_transfer
	#endif
	#if !__has_feature(objc_arc_weak)									// Weak reference support
		#undef 	  ah_weak
		#define 	  ah_weak   unsafe_unretained
		#undef 	__ah_weak
		#define 	__ah_weak __unsafe_unretained
	#endif
	#undef ah_weak_delegate													// Weak delegate support
	#undef __ah_weak_delegate
	#if	__has_feature(objc_arc_weak) && (!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
		#define   ah_weak_delegate weak
		#define __ah_weak_delegate __weak
	#else
		#define   ah_weak_delegate   unsafe_unretained
		#define __ah_weak_delegate __unsafe_unretained
	#endif																		// ARC Helper ends


	//  ARC Helper Version 1.3.1 Created by Nick Lockwood on 05/01/2012. Copyright 2012 Charcoal Design Distributed under the permissive zlib license  Get the latest version from here: https://gist.github.com/1563325
	#ifndef AH_RETAIN
		#if __has_feature(objc_arc)
			#define AH_RETAIN(x) (x)
			#define AH_RELEASE(x) (void)(x)
			#define AH_AUTORELEASE(x) (x)
			#define AH_SUPER_DEALLOC (void)(0)
			#define __AH_BRIDGE __bridge
		#else
			#define __AH_WEAK
			#define AH_WEAK assign
			#define AH_RETAIN(x) [(x) retain]
			#define AH_RELEASE(x) [(x) release]
			#define AH_AUTORELEASE(x) [(x) autorelease]
			#define AH_SUPER_DEALLOC [super dealloc]
			#define __AH_BRIDGE
		#endif
	#endif
	
*/
/*
#import <pwd.h>
#import <stdio.h>
#import <netdb.h>
#import <dirent.h>
#import <unistd.h>
#import <stdarg.h>
#import <unistd.h>
#import <dirent.h>
#import <xpc/xpc.h>
#import <xpc/xpc.h>
#import <sys/stat.h>
#import <sys/time.h>
#import <sys/types.h>
#import <sys/ioctl.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <sys/sysctl.h>
#import <sys/stat.h>
#import <sys/types.h>
#import <sys/xattr.h>
#import <arpa/inet.h>
#import <objc/objc.h>
#import <netinet/in.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <Cocoa/Cocoa.h>
#import <Python/Python.h>
#import <AppKit/AppKit.h>
#import <Quartz/Quartz.h>
#import <Carbon/Carbon.h>
#import <libkern/OSAtomic.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>
#import <AudioToolbox/AudioToolbox.h>
*/

//	#import <extobjc_OSX/e.h>
//	#import "extobjc_OSX/extobjc.h"
//	#import <extobjc/metamacros.h>
//	#import "GCDAsyncSocket.h"
//	#import "GCDAsyncSocket+AtoZ.h"
//	#import "AtoZAutoBox/NSObject+DynamicProperties.h"

//#import <AIUtilities/AIUtilities.h>
//#import "extobjc_OSX/extobjc.h"
//#import "AtoZAutoBox/AtoZAutoBox.h"
//#import "ObjcAssociatedObjectHelper/ObjcAssociatedObjectHelpers.h"
//#import "AtoZSingleton/AtoZSingleton.h"
//#import "ObjcAssociatedObjectHelper/ObjcAssociatedObjectHelpers.h"
//#import "TypedCollections/TypedCollections.h"
//#import "KVOMap/DCKeyValueObjectMapping.h"
//#import "KVOMap/DCArrayMapping.h"
//#import "KVOMap/DCDictionaryRearranger.h"
//#import "KVOMap/DCKeyValueObjectMapping.h"
//#import "KVOMap/DCObjectMapping.h"
//#import "KVOMap/DCParserConfiguration.h"
//#import "KVOMap/DCPropertyAggregator.h"
//#import "KVOMap/DCValueConverter.h"

//#endif 





/*!  PropertyMacros.h

  Created by Nicolas Bouilleaud on 12/04/12, 
   using ideas by Uli Kusterer (http://orangejuiceliberationfront.com/safe-key-value-coding/)
   Laurent Deniau (https://groups.google.com/forum/?fromgroups#!topic/comp.std.c/d-6Mj5Lko_s)
   and Nick Forge (http://forgecode.net/2011/11/compile-time-checking-of-kvc-keys/)


  Usage : 
   $keypath(foo)                    -> @"foo"
   $keypath(foo,bar)                -> @"foo.bar"
   $keypath(foo,inexistentkey)        -> compilation error: undeclared selector 'inexistentkey'

 @note Be sure to set -Wundeclared-selector.
*/

#define PP_RSEQ_N()                                 9,8,7,6,5,4,3,2,1,0 
#define PP_ARG_N(_1,_2,_3,_4,_5,_6,_7,_8,_9,N,...)  N 
#define PP_NARG_(...)                               PP_ARG_N(__VA_ARGS__) 
#define PP_NARG(...)                                PP_NARG_(__VA_ARGS__,PP_RSEQ_N()) 

#define KVCCHECK(p)                                 NSStringFromSelector(@selector(p))

#define KVCCHECK_1(_1)                              KVCCHECK(_1)
#define KVCCHECK_2(_1,_2)                           KVCCHECK_1(_1),KVCCHECK_1(_2)
#define KVCCHECK_3(_1,_2,_3)                        KVCCHECK_1(_1),KVCCHECK_2(_2,_3)
#define KVCCHECK_4(_1,_2,_3,_4)                     KVCCHECK_1(_1),KVCCHECK_3(_2,_3,_4)
#define KVCCHECK_5(_1,_2,_3,_4,_5)                  KVCCHECK_1(_1),KVCCHECK_4(_2,_3,_4,_5)
#define KVCCHECK_6(_1,_2,_3,_4,_5,_6)               KVCCHECK_1(_1),KVCCHECK_5(_2,_3,_4,_5,_6)
#define KVCCHECK_7(_1,_2,_3,_4,_5,_6,_7)            KVCCHECK_1(_1),KVCCHECK_6(_2,_3,_4,_5,_6,_7)
#define KVCCHECK_8(_1,_2,_3,_4,_5,_6,_7,_8)         KVCCHECK_1(_1),KVCCHECK_7(_2,_3,_4,_5,_6,_7,_8)
#define KVCCHECK_9(_1,_2,_3,_4,_5,_6,_7,_8,_9)      KVCCHECK_1(_1),KVCCHECK_8(_2,_3,_4,_5,_6,_7,_8,_9)

#define KVCPATH_1(_1)                               @#_1
#define KVCPATH_2(_1,_2)                            @#_1"."#_2
#define KVCPATH_3(_1,_2,_3)                         @#_1"."#_2"."#_3
#define KVCPATH_4(_1,_2,_3,_4)                      @#_1"."#_2"."#_3"."#_4
#define KVCPATH_5(_1,_2,_3,_4,_5)                   @#_1"."#_2"."#_3"."#_4"."#_5
#define KVCPATH_6(_1,_2,_3,_4,_5,_6)                @#_1"."#_2"."#_3"."#_4"."#_5"."#_6
#define KVCPATH_7(_1,_2,_3,_4,_5,_6,_7)             @#_1"."#_2"."#_3"."#_4"."#_5"."#_6"."#_7
#define KVCPATH_8(_1,_2,_3,_4,_5,_6,_7,_8)          @#_1"."#_2"."#_3"."#_4"."#_5"."#_6"."#_7"."#_8
#define KVCPATH_9(_1,_2,_3,_4,_5,_6,_7,_8,_9)       @#_1"."#_2"."#_3"."#_4"."#_5"."#_6"."#_7"."#_8"."#_9

#define KP_CONCAT(a,b)                              a ## b
#define KP_XCONCAT(a,b)                             KP_CONCAT(a,b)
#define KP_(m, ...)                                 m(__VA_ARGS__)
#define $keypath(...)                               (0?KP_(KP_XCONCAT(KVCCHECK_, PP_NARG(__VA_ARGS__)), __VA_ARGS__) :\
                                                       KP_(KP_XCONCAT(KVCPATH_, PP_NARG(__VA_ARGS__)), __VA_ARGS__) )

