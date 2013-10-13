
/**  NSObject+StrictProtocols.h  *//* 𝘗𝘈𝘙𝘛 𝘖𝘍 𝗔𝖳𝖮𝗭.𝖥𝖱𝖠𝖬𝖤𝖶𝖮𝖱𝖪  © 𝟮𝟬𝟭𝟯 𝖠𝖫𝖤𝖷 𝖦𝖱𝖠𝖸  𝗀𝗂𝗍𝗁𝗎𝖻.𝖼𝗈𝗆/𝗺𝗿𝗮𝗹𝗲𝘅𝗴𝗿𝗮𝘆 */

#import <Foundation/Foundation.h>

@interface NSObject (StrictProtocols)

-			  (BOOL) isaProtocol;
-			  (BOOL) implementsProtocol:		(id)nameOrProtocol;
-			  (BOOL) implementsFullProtocol:	(id)nameOrProtocol;
+			  (BOOL) implementsProtocol: 		(id)nameOrProtocol;
+			  (BOOL) implementsFullProtocol:	(id)nameOrProtocol;
+ (NSDictionary*) cachedConformance;

@end
