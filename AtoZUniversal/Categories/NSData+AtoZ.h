
@interface NSData (AtoZ)
@prop_RO NSS* UTF8String, *UTF16String;
@end

@interface NSString (FromAtoZ)
+ (NSS*) stringFromArray:(NSA*)a;
+ (NSS*) stringFromArray:(NSA*)a withSpaces:(BOOL)spaces onePerline:(BOOL)newl;
+ (NSS*) stringFromArray:(NSA*)a withDelimeter:(NSS*)del last:(NSS*)last; // needs blockskit
@prop_RO BOOL  isIntegerNumber, isFloatNumber;

- (NSS*) withString:(NSS*)string;
- (NSS*) withPath:(NSS*)path;
- (NSS*) withExt:	(NSS*)ext;

@end

@interface NSParagraphStyle (AtoZ)
+ (NSParagraphStyle*) defaultParagraphStyleWithDictionary:(NSD*)d;
@end

@interface NSC (AtoZRefugee)
+ (NSC*) r:(CGF)r g:(CGF)g b:(CGF)b a:(CGF)a;
@end
