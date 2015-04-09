


@Xtra(Data,AtoZ) _RO _Text UTF8String, UTF16String, ASCIIString; @end

@Xtra(Text,FromAtoZ)

+ _Text_ stringFromArray:_List_ l ___
+ _Text_ stringFromArray:_List_ l    withSpaces:_IsIt_ spcs onePerline:_IsIt_ newl ___
+ _Text_ stringFromArray:_List_ l withDelimeter:_Text_ deli       last:_Text_ last ___ // needs blockskit

_RO _IsIt  isIntegerNumber, isFloatNumber ___

- _Text_ withString:_Text_ s ___
- _Text_   withPath:_Text_ p ___
- _Text_    withExt:_Text_ e ___

@end

@Xtra(NSParagraphStyle,AtoZ)

+ _PStl_ defaultParagraphStyleWithDictionary: _Dict_ d ___

@end

@Xtra(Colr,AtoZRefugee) + _Kind_ r:_Flot_ r g:_Flot_ g b:_Flot_ b a:_Flot_ a ___ @end



JREnumDeclare(AZChecksumType, AZChecksumTypeMD5,
                              AZChecksumTypeSha512) /*...any CC algo can be used*/

@Xtra(Data,AZChecksum)

- _Text_ checksum:(AZChecksumType)type;

@XtraStop(AZChecksum)

