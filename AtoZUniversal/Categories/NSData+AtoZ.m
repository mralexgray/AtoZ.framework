
#import <AtoZUniversal/AtoZUniversal.h>

@XtraPlan(NSData,AtoZ)

- _Text_ UTF16String  { return INIT_(NSS,WithData:self encoding:NSUTF16StringEncoding); }
- _Text_ UTF8String   { return INIT_(NSS,WithData:self encoding: NSUTF8StringEncoding); }
- _Text_ ASCIIString  { return INIT_(NSS,WithData:self encoding:NSASCIIStringEncoding); }

@end

@XtraPlan(Text,FromAtoZ)

+ _Kind_ stringFromArray:_List_ a       {	return [self stringFromArray:a withDelimeter:@"" last:@""]; }

+ _Kind_ stringFromArray:_List_ a
              withSpaces:_IsIt_ spaces
              onePerline:_IsIt_ newl 		{

	return [self stringFromArray:a withDelimeter:spaces ? @" " : newl ? @"\n" : @"" last:spaces ? @" " : newl ? @"\n" : @""];
}

+ _Kind_ stringFromArray:_List_ a
           withDelimeter:_Text_ del
                    last:_Text_ last    {	if (!a.count) return nil;

	NSMS* outString = @"".mutableCopy;
  for (id x in a) [outString appendFormat:@"%@%@",x,del];
  [outString replaceCharactersInRange:NSMakeRange(outString.length-1,1) withString:last];
  return outString.copy;
}

- _IsIt_   isFloatNumber {

  return !self.length ? NO : [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]
            isSupersetOfSet:  [NSCharacterSet characterSetWithCharactersInString:self]];
}

- _IsIt_ isIntegerNumber { NSRange range = NSMakeRange(0, self.length);

	if (!range.length) return NO;

  unichar character = [self characterAtIndex:0];

  if ((character == '+') || (character == '-')) { range.location = 1; range.length -= 1; }

  range = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_DecimalDigits_Inverted)
                                options:0 range:range];

  return range.location == NSNotFound;
}

- _Text_    withExt:_Text_ e { return      [self stringByAppendingPathExtension:e]; }
- _Text_ withString:_Text_ s { return !s ? self : [self stringByAppendingString:s]; }
- _Text_   withPath:_Text_ p { return      [self stringByAppendingPathComponent:p]; }

@end

@XtraPlan(NSParagraphStyle,AtoZ)

+ _Kind_ defaultParagraphStyleWithDictionary:_Dict_ d {	NSMutableParagraphStyle *s;
  s = self.defaultParagraphStyle.mutableCopy;
  [s setValuesForKeysWithDictionary:d]; return s;
}

@end

@XtraPlan(NSC,AtoZRefugee)

+ _Kind_ r:_Flot_ r g:_Flot_ g b:_Flot_ b a:_Flot_ a {  return

#if !TARGET_OS_IPHONE
  [self colorWithDeviceRed:r green:g blue:b alpha:a];
#else
  [self colorWithRed:r green:g blue:b alpha:a];
#endif
}

@end

#import <CommonCrypto/CommonDigest.h>

JREnumDefine(AZChecksumType)

@XtraPlan(Data,AZChecksum)

#pragma mark sha

+ _Text_ hexForDigest:(unsigned char*)ret ofLength:(int)l {

  if(!ret || !l) return nil;

  NSMutableString* output = [NSMutableString stringWithCapacity:l * 2];

  for(int i = 0; i < l; i++) [output appendFormat:@"%02x", ret[i]]; return output;
}

- _Text_ checksum:(AZChecksumType)type {

  unsigned char *ret = nil;   int l = 0;

  type == AZChecksumTypeSha512 ? ({

    l = CC_SHA512_DIGEST_LENGTH;
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    ret = CC_SHA512([self bytes], (CC_LONG)[self length], digest);

   }) : type == AZChecksumTypeMD5 ? ({

    l = CC_MD5_DIGEST_LENGTH;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    ret = CC_MD5(self.bytes, (CC_LONG)self.length, digest);

  }) : nil;

  return [self.class hexForDigest:ret ofLength:l];
}

@XtraStop(AZChecksum)

