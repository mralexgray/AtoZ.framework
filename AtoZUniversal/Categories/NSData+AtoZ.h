


@Xtra(Data,AtoZ) _RO _Text UTF8String, UTF16String, ASCIIString; @end

@Xtra(Text,FromAtoZ)

+ _Text_ stringFromArray:_List_ __ _
+ _Text_ stringFromArray:_List_ __    withSpaces:_IsIt_ spcs onePerline:_IsIt_ newl _
+ _Text_ stringFromArray:_List_ __ withDelimeter:_Text_ deli       last:_Text_ last _ // needs blockskit

_RO _IsIt  isIntegerNumber, isFloatNumber _

- _Text_ withString:_Text_ __ _
- _Text_   withPath:_Text_ __ _
- _Text_    withExt:_Text_ __ _

@end

@Xtra(NSParagraphStyle,AtoZ)

+ _PStl_ defaultParagraphStyleWithDictionary: _Dict_ __ _

@end

@Xtra(Colr,AtoZRefugee) + _Kind_ r:_Flot_ r g:_Flot_ g b:_Flot_ b a:_Flot_ a _ @end



JREnumDeclare(AZChecksumType, AZChecksumTypeMD5,
                              AZChecksumTypeSha512) /*...any CC algo can be used*/

@Xtra(Data,AZChecksum)

- _Text_ checksum:(AZChecksumType)type;

@XtraStop(AZChecksum)

