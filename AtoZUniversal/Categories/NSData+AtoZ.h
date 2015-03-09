
@IFCE Data (AtoZ)
@prop_RO _Text UTF8String, UTF16String, ASCIIString;
@FINI

@IFCE Text (FromAtoZ)

+ _Text_ stringFromArray: _List_ a;
+ _Text_ stringFromArray: _List_ a    withSpaces: _IsIt_ spaces onePerline: _IsIt_ newl;
+ _Text_ stringFromArray: _List_ a withDelimeter: _Text_ del         last: _Text_ last; // needs blockskit

@prop_RO _IsIt  isIntegerNumber,
                isFloatNumber;

- _Text_ withString: _Text_ s;
- _Text_   withPath: _Text_ p;
- _Text_    withExt: _Text_ x;

@FINI

@IFCE NSParagraphStyle (AtoZ)
+ _PStl_ defaultParagraphStyleWithDictionary: _Dict_ d;
@FINI

@IFCE NSC (AtoZRefugee)
+ (NSC*) r:(CGF)r g:(CGF)g b:(CGF)b a:(CGF)a;
@FINI
