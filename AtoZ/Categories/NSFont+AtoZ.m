
#import "AtoZ.h"

@implementation NSRegularExpression (Additions)
+ (NSRegularExpression *) cachedRegularExpressionWithPattern:(NSString *) pattern options:(NSRegularExpressionOptions) options error:(NSError *__autoreleasing*) error {
	static NSMutableDictionary *dangerousCache = nil;
	static dispatch_once_t pred;
	dispatch_once(&pred, ^{
		dangerousCache = [[NSMutableDictionary alloc] init];
	});

	NSString *key = [NSString stringWithFormat:@"%ld-%@", options, pattern];
	NSRegularExpression *regularExpression = dangerousCache[key];

	if (regularExpression)
		return regularExpression;

	regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:options error:nil];

	dangerousCache[key] = regularExpression;

	return regularExpression;
}
@end

#import "NSFont+AtoZ.h"

@implementation NSFont (AtoZ)

- (CGF) size { return self.pointSize; } // [[self.fontDescriptor objectForKey:NSFontSizeAttribute] floatValue]; }

//- (void) setSize:(CGF) size {  [
//
- (NSFont *)fontWithSize:(CGFloat)fontSize {

		return [NSFont fontWithName:self.fontName size:fontSize];
}
@end
@implementation NSFont (AMFixes)

- (float)fixed_xHeight
{
	float result = [self xHeight];
	if ([[self familyName] isEqualToString:[[NSFont systemFontOfSize:[NSFont systemFontSize]] familyName]]) {
		switch (lrintf([self pointSize])) {
			case 9: // mini
			{
				result = 5.655762;
				break;
			}
			case 11: // small
			{
				result = 6.912598;
				break;
			}
			case 13: // regular
			{
				result = 8.169434;
				break;
			}
		}
	}
	return result;
}

- (float)fixed_capHeight
{
	float result = [self capHeight];
	if (result == [self ascender]) { // instead of checking for appkit version
		if ([[self familyName] isEqualToString:[[NSFont systemFontOfSize:[NSFont systemFontSize]] familyName]]) { // we do have this info for the system font only 
			switch (lrintf([self pointSize])) {
				case 9: // mini
				{
					result = 7.00;
					break;
				}
				case 11: // small
				{
					result = 8.00;
					break;
				}
				case 13: // regular
				{
					result = 9.50;
					break;
				}
			}
		}
	}
	return result;
}


@end


// NSCharacterSet (EmojisAddition)

static const char emoji6[] = { 
    0xff, 0xfe, 0x3d, 0xd8, 0x04, 0xde, 0x3d, 0xd8, 0x03, 0xde, 0x3d, 0xd8, 0x00, 0xde, 0x3d, 0xd8, 
    0x0a, 0xde, 0x3a, 0x26, 0x3d, 0xd8, 0x09, 0xde, 0x3d, 0xd8, 0x0d, 0xde, 0x3d, 0xd8, 0x18, 0xde, 
    0x3d, 0xd8, 0x1a, 0xde, 0x3d, 0xd8, 0x17, 0xde, 0x3d, 0xd8, 0x19, 0xde, 0x3d, 0xd8, 0x1c, 0xde, 
    0x3d, 0xd8, 0x1d, 0xde, 0x3d, 0xd8, 0x1b, 0xde, 0x3d, 0xd8, 0x33, 0xde, 0x3d, 0xd8, 0x01, 0xde, 
    0x3d, 0xd8, 0x14, 0xde, 0x3d, 0xd8, 0x0c, 0xde, 0x3d, 0xd8, 0x12, 0xde, 0x3d, 0xd8, 0x1e, 0xde, 
    0x3d, 0xd8, 0x23, 0xde, 0x3d, 0xd8, 0x22, 0xde, 0x3d, 0xd8, 0x02, 0xde, 0x3d, 0xd8, 0x2d, 0xde, 
    0x3d, 0xd8, 0x2a, 0xde, 0x3d, 0xd8, 0x25, 0xde, 0x3d, 0xd8, 0x30, 0xde, 0x3d, 0xd8, 0x05, 0xde, 
    0x3d, 0xd8, 0x13, 0xde, 0x3d, 0xd8, 0x29, 0xde, 0x3d, 0xd8, 0x2b, 0xde, 0x3d, 0xd8, 0x28, 0xde, 
    0x3d, 0xd8, 0x31, 0xde, 0x3d, 0xd8, 0x20, 0xde, 0x3d, 0xd8, 0x21, 0xde, 0x3d, 0xd8, 0x24, 0xde, 
    0x3d, 0xd8, 0x16, 0xde, 0x3d, 0xd8, 0x06, 0xde, 0x3d, 0xd8, 0x0b, 0xde, 0x3d, 0xd8, 0x37, 0xde, 
    0x3d, 0xd8, 0x0e, 0xde, 0x3d, 0xd8, 0x34, 0xde, 0x3d, 0xd8, 0x35, 0xde, 0x3d, 0xd8, 0x32, 0xde, 
    0x3d, 0xd8, 0x1f, 0xde, 0x3d, 0xd8, 0x26, 0xde, 0x3d, 0xd8, 0x27, 0xde, 0x3d, 0xd8, 0x08, 0xde, 
    0x3d, 0xd8, 0x7f, 0xdc, 0x3d, 0xd8, 0x2e, 0xde, 0x3d, 0xd8, 0x2c, 0xde, 0x3d, 0xd8, 0x10, 0xde, 
    0x3d, 0xd8, 0x15, 0xde, 0x3d, 0xd8, 0x2f, 0xde, 0x3d, 0xd8, 0x36, 0xde, 0x3d, 0xd8, 0x07, 0xde, 
    0x3d, 0xd8, 0x0f, 0xde, 0x3d, 0xd8, 0x11, 0xde, 0x3d, 0xd8, 0x72, 0xdc, 0x3d, 0xd8, 0x73, 0xdc, 
    0x3d, 0xd8, 0x6e, 0xdc, 0x3d, 0xd8, 0x77, 0xdc, 0x3d, 0xd8, 0x82, 0xdc, 0x3d, 0xd8, 0x76, 0xdc, 
    0x3d, 0xd8, 0x66, 0xdc, 0x3d, 0xd8, 0x67, 0xdc, 0x3d, 0xd8, 0x68, 0xdc, 0x3d, 0xd8, 0x69, 0xdc, 
    0x3d, 0xd8, 0x74, 0xdc, 0x3d, 0xd8, 0x75, 0xdc, 0x3d, 0xd8, 0x71, 0xdc, 0x3d, 0xd8, 0x7c, 0xdc, 
    0x3d, 0xd8, 0x78, 0xdc, 0x3d, 0xd8, 0x3a, 0xde, 0x3d, 0xd8, 0x38, 0xde, 0x3d, 0xd8, 0x3b, 0xde, 
    0x3d, 0xd8, 0x3d, 0xde, 0x3d, 0xd8, 0x3c, 0xde, 0x3d, 0xd8, 0x40, 0xde, 0x3d, 0xd8, 0x3f, 0xde, 
    0x3d, 0xd8, 0x39, 0xde, 0x3d, 0xd8, 0x3e, 0xde, 0x3d, 0xd8, 0x79, 0xdc, 0x3d, 0xd8, 0x7a, 0xdc, 
    0x3d, 0xd8, 0x48, 0xde, 0x3d, 0xd8, 0x49, 0xde, 0x3d, 0xd8, 0x4a, 0xde, 0x3d, 0xd8, 0x80, 0xdc, 
    0x3d, 0xd8, 0x7d, 0xdc, 0x3d, 0xd8, 0xa9, 0xdc, 0x3d, 0xd8, 0x25, 0xdd, 0x28, 0x27, 0x3c, 0xd8, 
    0x1f, 0xdf, 0x3d, 0xd8, 0xab, 0xdc, 0x3d, 0xd8, 0xa5, 0xdc, 0x3d, 0xd8, 0xa2, 0xdc, 0x3d, 0xd8, 
    0xa6, 0xdc, 0x3d, 0xd8, 0xa7, 0xdc, 0x3d, 0xd8, 0xa4, 0xdc, 0x3d, 0xd8, 0xa8, 0xdc, 0x3d, 0xd8, 
    0x42, 0xdc, 0x3d, 0xd8, 0x40, 0xdc, 0x3d, 0xd8, 0x43, 0xdc, 0x3d, 0xd8, 0x45, 0xdc, 0x3d, 0xd8, 
    0x44, 0xdc, 0x3d, 0xd8, 0x4d, 0xdc, 0x3d, 0xd8, 0x4e, 0xdc, 0x3d, 0xd8, 0x4c, 0xdc, 0x3d, 0xd8, 
    0x4a, 0xdc, 0x0a, 0x27, 0x0c, 0x27, 0x3d, 0xd8, 0x4b, 0xdc, 0x0b, 0x27, 0x3d, 0xd8, 0x50, 0xdc, 
    0x3d, 0xd8, 0x46, 0xdc, 0x3d, 0xd8, 0x47, 0xdc, 0x3d, 0xd8, 0x49, 0xdc, 0x3d, 0xd8, 0x48, 0xdc, 
    0x3d, 0xd8, 0x4c, 0xde, 0x3d, 0xd8, 0x4f, 0xde, 0x1d, 0x26, 0x3d, 0xd8, 0x4f, 0xdc, 0x3d, 0xd8, 
    0xaa, 0xdc, 0x3d, 0xd8, 0xb6, 0xde, 0x3c, 0xd8, 0xc3, 0xdf, 0x3d, 0xd8, 0x83, 0xdc, 0x3d, 0xd8, 
    0x6b, 0xdc, 0x3d, 0xd8, 0x6a, 0xdc, 0x3d, 0xd8, 0x6c, 0xdc, 0x3d, 0xd8, 0x6d, 0xdc, 0x3d, 0xd8, 
    0x8f, 0xdc, 0x3d, 0xd8, 0x91, 0xdc, 0x3d, 0xd8, 0x6f, 0xdc, 0x3d, 0xd8, 0x46, 0xde, 0x3d, 0xd8, 
    0x45, 0xde, 0x3d, 0xd8, 0x81, 0xdc, 0x3d, 0xd8, 0x4b, 0xde, 0x3d, 0xd8, 0x86, 0xdc, 0x3d, 0xd8, 
    0x87, 0xdc, 0x3d, 0xd8, 0x85, 0xdc, 0x3d, 0xd8, 0x70, 0xdc, 0x3d, 0xd8, 0x4e, 0xde, 0x3d, 0xd8, 
    0x4d, 0xde, 0x3d, 0xd8, 0x47, 0xde, 0x3c, 0xd8, 0xa9, 0xdf, 0x3d, 0xd8, 0x51, 0xdc, 0x3d, 0xd8, 
    0x52, 0xdc, 0x3d, 0xd8, 0x5f, 0xdc, 0x3d, 0xd8, 0x5e, 0xdc, 0x3d, 0xd8, 0x61, 0xdc, 0x3d, 0xd8, 
    0x60, 0xdc, 0x3d, 0xd8, 0x62, 0xdc, 0x3d, 0xd8, 0x55, 0xdc, 0x3d, 0xd8, 0x54, 0xdc, 0x3d, 0xd8, 
    0x5a, 0xdc, 0x3d, 0xd8, 0x57, 0xdc, 0x3c, 0xd8, 0xbd, 0xdf, 0x3d, 0xd8, 0x56, 0xdc, 0x3d, 0xd8, 
    0x58, 0xdc, 0x3d, 0xd8, 0x59, 0xdc, 0x3d, 0xd8, 0xbc, 0xdc, 0x3d, 0xd8, 0x5c, 0xdc, 0x3d, 0xd8, 
    0x5d, 0xdc, 0x3d, 0xd8, 0x5b, 0xdc, 0x3d, 0xd8, 0x53, 0xdc, 0x3c, 0xd8, 0x80, 0xdf, 0x3c, 0xd8, 
    0x02, 0xdf, 0x3d, 0xd8, 0x84, 0xdc, 0x3d, 0xd8, 0x9b, 0xdc, 0x3d, 0xd8, 0x99, 0xdc, 0x3d, 0xd8, 
    0x9c, 0xdc, 0x3d, 0xd8, 0x9a, 0xdc, 0x64, 0x27, 0x3d, 0xd8, 0x94, 0xdc, 0x3d, 0xd8, 0x97, 0xdc, 
    0x3d, 0xd8, 0x93, 0xdc, 0x3d, 0xd8, 0x95, 0xdc, 0x3d, 0xd8, 0x96, 0xdc, 0x3d, 0xd8, 0x9e, 0xdc, 
    0x3d, 0xd8, 0x98, 0xdc, 0x3d, 0xd8, 0x8c, 0xdc, 0x3d, 0xd8, 0x8b, 0xdc, 0x3d, 0xd8, 0x8d, 0xdc, 
    0x3d, 0xd8, 0x8e, 0xdc, 0x3d, 0xd8, 0x64, 0xdc, 0x3d, 0xd8, 0x65, 0xdc, 0x3d, 0xd8, 0xac, 0xdc, 
    0x3d, 0xd8, 0x63, 0xdc, 0x3d, 0xd8, 0xad, 0xdc, 0x3d, 0xd8, 0x36, 0xdc, 0x3d, 0xd8, 0x3a, 0xdc, 
    0x3d, 0xd8, 0x31, 0xdc, 0x3d, 0xd8, 0x2d, 0xdc, 0x3d, 0xd8, 0x39, 0xdc, 0x3d, 0xd8, 0x30, 0xdc, 
    0x3d, 0xd8, 0x38, 0xdc, 0x3d, 0xd8, 0x2f, 0xdc, 0x3d, 0xd8, 0x28, 0xdc, 0x3d, 0xd8, 0x3b, 0xdc, 
    0x3d, 0xd8, 0x37, 0xdc, 0x3d, 0xd8, 0x3d, 0xdc, 0x3d, 0xd8, 0x2e, 0xdc, 0x3d, 0xd8, 0x17, 0xdc, 
    0x3d, 0xd8, 0x35, 0xdc, 0x3d, 0xd8, 0x12, 0xdc, 0x3d, 0xd8, 0x34, 0xdc, 0x3d, 0xd8, 0x11, 0xdc, 
    0x3d, 0xd8, 0x18, 0xdc, 0x3d, 0xd8, 0x3c, 0xdc, 0x3d, 0xd8, 0x27, 0xdc, 0x3d, 0xd8, 0x26, 0xdc, 
    0x3d, 0xd8, 0x24, 0xdc, 0x3d, 0xd8, 0x25, 0xdc, 0x3d, 0xd8, 0x23, 0xdc, 0x3d, 0xd8, 0x14, 0xdc, 
    0x3d, 0xd8, 0x0d, 0xdc, 0x3d, 0xd8, 0x22, 0xdc, 0x3d, 0xd8, 0x1b, 0xdc, 0x3d, 0xd8, 0x1d, 0xdc, 
    0x3d, 0xd8, 0x1c, 0xdc, 0x3d, 0xd8, 0x1e, 0xdc, 0x3d, 0xd8, 0x0c, 0xdc, 0x3d, 0xd8, 0x19, 0xdc, 
    0x3d, 0xd8, 0x1a, 0xdc, 0x3d, 0xd8, 0x20, 0xdc, 0x3d, 0xd8, 0x1f, 0xdc, 0x3d, 0xd8, 0x2c, 0xdc, 
    0x3d, 0xd8, 0x33, 0xdc, 0x3d, 0xd8, 0x0b, 0xdc, 0x3d, 0xd8, 0x04, 0xdc, 0x3d, 0xd8, 0x0f, 0xdc, 
    0x3d, 0xd8, 0x00, 0xdc, 0x3d, 0xd8, 0x03, 0xdc, 0x3d, 0xd8, 0x05, 0xdc, 0x3d, 0xd8, 0x07, 0xdc, 
    0x3d, 0xd8, 0x09, 0xdc, 0x3d, 0xd8, 0x0e, 0xdc, 0x3d, 0xd8, 0x10, 0xdc, 0x3d, 0xd8, 0x13, 0xdc, 
    0x3d, 0xd8, 0x15, 0xdc, 0x3d, 0xd8, 0x16, 0xdc, 0x3d, 0xd8, 0x01, 0xdc, 0x3d, 0xd8, 0x02, 0xdc, 
    0x3d, 0xd8, 0x32, 0xdc, 0x3d, 0xd8, 0x21, 0xdc, 0x3d, 0xd8, 0x0a, 0xdc, 0x3d, 0xd8, 0x2b, 0xdc, 
    0x3d, 0xd8, 0x2a, 0xdc, 0x3d, 0xd8, 0x06, 0xdc, 0x3d, 0xd8, 0x08, 0xdc, 0x3d, 0xd8, 0x29, 0xdc, 
    0x3d, 0xd8, 0x3e, 0xdc, 0x3d, 0xd8, 0x90, 0xdc, 0x3c, 0xd8, 0x38, 0xdf, 0x3c, 0xd8, 0x37, 0xdf, 
    0x3c, 0xd8, 0x40, 0xdf, 0x3c, 0xd8, 0x39, 0xdf, 0x3c, 0xd8, 0x3b, 0xdf, 0x3c, 0xd8, 0x3a, 0xdf, 
    0x3c, 0xd8, 0x41, 0xdf, 0x3c, 0xd8, 0x43, 0xdf, 0x3c, 0xd8, 0x42, 0xdf, 0x3c, 0xd8, 0x3f, 0xdf, 
    0x3c, 0xd8, 0x3e, 0xdf, 0x3c, 0xd8, 0x44, 0xdf, 0x3c, 0xd8, 0x35, 0xdf, 0x3c, 0xd8, 0x34, 0xdf, 
    0x3c, 0xd8, 0x32, 0xdf, 0x3c, 0xd8, 0x33, 0xdf, 0x3c, 0xd8, 0x30, 0xdf, 0x3c, 0xd8, 0x31, 0xdf, 
    0x3c, 0xd8, 0x3c, 0xdf, 0x3c, 0xd8, 0x10, 0xdf, 0x3c, 0xd8, 0x1e, 0xdf, 0x3c, 0xd8, 0x1d, 0xdf, 
    0x3c, 0xd8, 0x1a, 0xdf, 0x3c, 0xd8, 0x11, 0xdf, 0x3c, 0xd8, 0x12, 0xdf, 0x3c, 0xd8, 0x13, 0xdf, 
    0x3c, 0xd8, 0x14, 0xdf, 0x3c, 0xd8, 0x15, 0xdf, 0x3c, 0xd8, 0x16, 0xdf, 0x3c, 0xd8, 0x17, 0xdf, 
    0x3c, 0xd8, 0x18, 0xdf, 0x3c, 0xd8, 0x1c, 0xdf, 0x3c, 0xd8, 0x1b, 0xdf, 0x3c, 0xd8, 0x19, 0xdf, 
    0x3c, 0xd8, 0x0d, 0xdf, 0x3c, 0xd8, 0x0e, 0xdf, 0x3c, 0xd8, 0x0f, 0xdf, 0x3c, 0xd8, 0x0b, 0xdf, 
    0x3c, 0xd8, 0x0c, 0xdf, 0x3c, 0xd8, 0x20, 0xdf, 0x50, 0x2b, 0x00, 0x26, 0xc5, 0x26, 0x01, 0x26, 
    0xa1, 0x26, 0x14, 0x26, 0x44, 0x27, 0xc4, 0x26, 0x3c, 0xd8, 0x00, 0xdf, 0x3c, 0xd8, 0x01, 0xdf, 
    0x3c, 0xd8, 0x08, 0xdf, 0x3c, 0xd8, 0x0a, 0xdf, 0x3c, 0xd8, 0x8d, 0xdf, 0x3d, 0xd8, 0x9d, 0xdc, 
    0x3c, 0xd8, 0x8e, 0xdf, 0x3c, 0xd8, 0x92, 0xdf, 0x3c, 0xd8, 0x93, 0xdf, 0x3c, 0xd8, 0x8f, 0xdf, 
    0x3c, 0xd8, 0x86, 0xdf, 0x3c, 0xd8, 0x87, 0xdf, 0x3c, 0xd8, 0x90, 0xdf, 0x3c, 0xd8, 0x91, 0xdf, 
    0x3c, 0xd8, 0x83, 0xdf, 0x3d, 0xd8, 0x7b, 0xdc, 0x3c, 0xd8, 0x85, 0xdf, 0x3c, 0xd8, 0x84, 0xdf, 
    0x3c, 0xd8, 0x81, 0xdf, 0x3c, 0xd8, 0x8b, 0xdf, 0x3c, 0xd8, 0x89, 0xdf, 0x3c, 0xd8, 0x8a, 0xdf, 
    0x3c, 0xd8, 0x88, 0xdf, 0x3c, 0xd8, 0x8c, 0xdf, 0x3d, 0xd8, 0x2e, 0xdd, 0x3c, 0xd8, 0xa5, 0xdf, 
    0x3d, 0xd8, 0xf7, 0xdc, 0x3d, 0xd8, 0xf9, 0xdc, 0x3d, 0xd8, 0xfc, 0xdc, 0x3d, 0xd8, 0xbf, 0xdc, 
    0x3d, 0xd8, 0xc0, 0xdc, 0x3d, 0xd8, 0xbd, 0xdc, 0x3d, 0xd8, 0xbe, 0xdc, 0x3d, 0xd8, 0xbb, 0xdc, 
    0x3d, 0xd8, 0xf1, 0xdc, 0x0e, 0x26, 0x3d, 0xd8, 0xde, 0xdc, 0x3d, 0xd8, 0xdf, 0xdc, 0x3d, 0xd8, 
    0xe0, 0xdc, 0x3d, 0xd8, 0xe1, 0xdc, 0x3d, 0xd8, 0xfa, 0xdc, 0x3d, 0xd8, 0xfb, 0xdc, 0x3d, 0xd8, 
    0x0a, 0xdd, 0x3d, 0xd8, 0x09, 0xdd, 0x3d, 0xd8, 0x08, 0xdd, 0x3d, 0xd8, 0x07, 0xdd, 0x0a, 0x00, 
    0x3d, 0xd8, 0x14, 0xdd, 0x3d, 0xd8, 0x15, 0xdd, 0x3d, 0xd8, 0xe2, 0xdc, 0x3d, 0xd8, 0xe3, 0xdc, 
    0xf3, 0x23, 0x1b, 0x23, 0xf0, 0x23, 0x1a, 0x23, 0x3d, 0xd8, 0x13, 0xdd, 0x3d, 0xd8, 0x12, 0xdd, 
    0x3d, 0xd8, 0x0f, 0xdd, 0x3d, 0xd8, 0x10, 0xdd, 0x3d, 0xd8, 0x11, 0xdd, 0x3d, 0xd8, 0x0e, 0xdd, 
    0x3d, 0xd8, 0xa1, 0xdc, 0x3d, 0xd8, 0x26, 0xdd, 0x3d, 0xd8, 0x06, 0xdd, 0x3d, 0xd8, 0x05, 0xdd, 
    0x3d, 0xd8, 0x0c, 0xdd, 0x3d, 0xd8, 0x0b, 0xdd, 0x3d, 0xd8, 0x0d, 0xdd, 0x3d, 0xd8, 0xc1, 0xde, 
    0x3d, 0xd8, 0xc0, 0xde, 0x3d, 0xd8, 0xbf, 0xde, 0x3d, 0xd8, 0xbd, 0xde, 0x3d, 0xd8, 0x27, 0xdd, 
    0x3d, 0xd8, 0x29, 0xdd, 0x3d, 0xd8, 0x28, 0xdd, 0x3d, 0xd8, 0xaa, 0xde, 0x3d, 0xd8, 0xac, 0xde, 
    0x3d, 0xd8, 0xa3, 0xdc, 0x3d, 0xd8, 0x2b, 0xdd, 0x3d, 0xd8, 0x2a, 0xdd, 0x3d, 0xd8, 0x8a, 0xdc, 
    0x3d, 0xd8, 0x89, 0xdc, 0x3d, 0xd8, 0xb0, 0xdc, 0x3d, 0xd8, 0xb4, 0xdc, 0x3d, 0xd8, 0xb5, 0xdc, 
    0x3d, 0xd8, 0xb7, 0xdc, 0x3d, 0xd8, 0xb6, 0xdc, 0x3d, 0xd8, 0xb3, 0xdc, 0x3d, 0xd8, 0xb8, 0xdc, 
    0x3d, 0xd8, 0xf2, 0xdc, 0x3d, 0xd8, 0xe7, 0xdc, 0x3d, 0xd8, 0xe5, 0xdc, 0x3d, 0xd8, 0xe4, 0xdc, 
    0x09, 0x27, 0x3d, 0xd8, 0xe9, 0xdc, 0x3d, 0xd8, 0xe8, 0xdc, 0x3d, 0xd8, 0xef, 0xdc, 0x3d, 0xd8, 
    0xeb, 0xdc, 0x3d, 0xd8, 0xea, 0xdc, 0x3d, 0xd8, 0xec, 0xdc, 0x3d, 0xd8, 0xed, 0xdc, 0x3d, 0xd8, 
    0xee, 0xdc, 0x3d, 0xd8, 0xe6, 0xdc, 0x3d, 0xd8, 0xdd, 0xdc, 0x3d, 0xd8, 0xc4, 0xdc, 0x3d, 0xd8, 
    0xc3, 0xdc, 0x3d, 0xd8, 0xd1, 0xdc, 0x3d, 0xd8, 0xca, 0xdc, 0x3d, 0xd8, 0xc8, 0xdc, 0x3d, 0xd8, 
    0xc9, 0xdc, 0x3d, 0xd8, 0xdc, 0xdc, 0x3d, 0xd8, 0xcb, 0xdc, 0x3d, 0xd8, 0xc5, 0xdc, 0x3d, 0xd8, 
    0xc6, 0xdc, 0x3d, 0xd8, 0xc7, 0xdc, 0x3d, 0xd8, 0xc1, 0xdc, 0x3d, 0xd8, 0xc2, 0xdc, 0x02, 0x27, 
    0x3d, 0xd8, 0xcc, 0xdc, 0x3d, 0xd8, 0xce, 0xdc, 0x12, 0x27, 0x0f, 0x27, 0x3d, 0xd8, 0xcf, 0xdc, 
    0x3d, 0xd8, 0xd0, 0xdc, 0x3d, 0xd8, 0xd5, 0xdc, 0x3d, 0xd8, 0xd7, 0xdc, 0x3d, 0xd8, 0xd8, 0xdc, 
    0x3d, 0xd8, 0xd9, 0xdc, 0x3d, 0xd8, 0xd3, 0xdc, 0x3d, 0xd8, 0xd4, 0xdc, 0x3d, 0xd8, 0xd2, 0xdc, 
    0x0a, 0x00, 0x3d, 0xd8, 0xda, 0xdc, 0x3d, 0xd8, 0xd6, 0xdc, 0x3d, 0xd8, 0x16, 0xdd, 0x3d, 0xd8, 
    0xdb, 0xdc, 0x3d, 0xd8, 0x2c, 0xdd, 0x3d, 0xd8, 0x2d, 0xdd, 0x3d, 0xd8, 0xf0, 0xdc, 0x3c, 0xd8, 
    0xa8, 0xdf, 0x3c, 0xd8, 0xac, 0xdf, 0x3c, 0xd8, 0xa4, 0xdf, 0x3c, 0xd8, 0xa7, 0xdf, 0x3c, 0xd8, 
    0xbc, 0xdf, 0x3c, 0xd8, 0xb5, 0xdf, 0x3c, 0xd8, 0xb6, 0xdf, 0x3c, 0xd8, 0xb9, 0xdf, 0x3c, 0xd8, 
    0xbb, 0xdf, 0x3c, 0xd8, 0xba, 0xdf, 0x3c, 0xd8, 0xb7, 0xdf, 0x3c, 0xd8, 0xb8, 0xdf, 0x3d, 0xd8, 
    0x7e, 0xdc, 0x3c, 0xd8, 0xae, 0xdf, 0x3c, 0xd8, 0xcf, 0xdc, 0x3c, 0xd8, 0xb4, 0xdf, 0x3c, 0xd8, 
    0x04, 0xdc, 0x3c, 0xd8, 0xb2, 0xdf, 0x3c, 0xd8, 0xaf, 0xdf, 0x3c, 0xd8, 0xc8, 0xdf, 0x3c, 0xd8, 
    0xc0, 0xdf, 0xbd, 0x26, 0xbe, 0x26, 0x3c, 0xd8, 0xbe, 0xdf, 0x3c, 0xd8, 0xb1, 0xdf, 0x3c, 0xd8, 
    0xc9, 0xdf, 0x3c, 0xd8, 0xb3, 0xdf, 0xf3, 0x26, 0x3d, 0xd8, 0xb5, 0xde, 0x3d, 0xd8, 0xb4, 0xde, 
    0x3c, 0xd8, 0xc1, 0xdf, 0x3c, 0xd8, 0xc7, 0xdf, 0x3c, 0xd8, 0xc6, 0xdf, 0x3c, 0xd8, 0xbf, 0xdf, 
    0x3c, 0xd8, 0xc2, 0xdf, 0x3c, 0xd8, 0xca, 0xdf, 0x3c, 0xd8, 0xc4, 0xdf, 0x3c, 0xd8, 0xa3, 0xdf, 
    0x15, 0x26, 0x3c, 0xd8, 0x75, 0xdf, 0x3c, 0xd8, 0x76, 0xdf, 0x3c, 0xd8, 0x7c, 0xdf, 0x3c, 0xd8, 
    0x7a, 0xdf, 0x3c, 0xd8, 0x7b, 0xdf, 0x3c, 0xd8, 0x78, 0xdf, 0x3c, 0xd8, 0x79, 0xdf, 0x3c, 0xd8, 
    0x77, 0xdf, 0x3c, 0xd8, 0x74, 0xdf, 0x3c, 0xd8, 0x55, 0xdf, 0x3c, 0xd8, 0x54, 0xdf, 0x3c, 0xd8, 
    0x5f, 0xdf, 0x3c, 0xd8, 0x57, 0xdf, 0x3c, 0xd8, 0x56, 0xdf, 0x3c, 0xd8, 0x5d, 0xdf, 0x3c, 0xd8, 
    0x5b, 0xdf, 0x3c, 0xd8, 0x64, 0xdf, 0x3c, 0xd8, 0x71, 0xdf, 0x3c, 0xd8, 0x63, 0xdf, 0x3c, 0xd8, 
    0x65, 0xdf, 0x3c, 0xd8, 0x59, 0xdf, 0x3c, 0xd8, 0x58, 0xdf, 0x3c, 0xd8, 0x5a, 0xdf, 0x3c, 0xd8, 
    0x5c, 0xdf, 0x3c, 0xd8, 0x72, 0xdf, 0x3c, 0xd8, 0x62, 0xdf, 0x3c, 0xd8, 0x61, 0xdf, 0x3c, 0xd8, 
    0x73, 0xdf, 0x3c, 0xd8, 0x5e, 0xdf, 0x3c, 0xd8, 0x69, 0xdf, 0x3c, 0xd8, 0x6e, 0xdf, 0x3c, 0xd8, 
    0x66, 0xdf, 0x3c, 0xd8, 0x68, 0xdf, 0x3c, 0xd8, 0x67, 0xdf, 0x3c, 0xd8, 0x82, 0xdf, 0x3c, 0xd8, 
    0x70, 0xdf, 0x3c, 0xd8, 0x6a, 0xdf, 0x3c, 0xd8, 0x6b, 0xdf, 0x3c, 0xd8, 0x6c, 0xdf, 0x3c, 0xd8, 
    0x6d, 0xdf, 0x3c, 0xd8, 0x6f, 0xdf, 0x3c, 0xd8, 0x4e, 0xdf, 0x3c, 0xd8, 0x4f, 0xdf, 0x3c, 0xd8, 
    0x4a, 0xdf, 0x3c, 0xd8, 0x4b, 0xdf, 0x3c, 0xd8, 0x52, 0xdf, 0x3c, 0xd8, 0x47, 0xdf, 0x3c, 0xd8, 
    0x49, 0xdf, 0x3c, 0xd8, 0x53, 0xdf, 0x3c, 0xd8, 0x51, 0xdf, 0x3c, 0xd8, 0x48, 0xdf, 0x3c, 0xd8, 
    0x4c, 0xdf, 0x3c, 0xd8, 0x50, 0xdf, 0x3c, 0xd8, 0x4d, 0xdf, 0x3c, 0xd8, 0x60, 0xdf, 0x3c, 0xd8, 
    0x46, 0xdf, 0x3c, 0xd8, 0x45, 0xdf, 0x3c, 0xd8, 0x3d, 0xdf, 0x3c, 0xd8, 0xe0, 0xdf, 0x3c, 0xd8, 
    0xe1, 0xdf, 0x3c, 0xd8, 0xeb, 0xdf, 0x3c, 0xd8, 0xe2, 0xdf, 0x3c, 0xd8, 0xe3, 0xdf, 0x3c, 0xd8, 
    0xe5, 0xdf, 0x3c, 0xd8, 0xe6, 0xdf, 0x3c, 0xd8, 0xea, 0xdf, 0x3c, 0xd8, 0xe9, 0xdf, 0x3c, 0xd8, 
    0xe8, 0xdf, 0x3d, 0xd8, 0x92, 0xdc, 0xea, 0x26, 0x3c, 0xd8, 0xec, 0xdf, 0x3c, 0xd8, 0xe4, 0xdf, 
    0x3c, 0xd8, 0x07, 0xdf, 0x3c, 0xd8, 0x06, 0xdf, 0x3c, 0xd8, 0xef, 0xdf, 0x3c, 0xd8, 0xf0, 0xdf, 
    0xfa, 0x26, 0x3c, 0xd8, 0xed, 0xdf, 0x3d, 0xd8, 0xfc, 0xdd, 0x3d, 0xd8, 0xfe, 0xdd, 0x3d, 0xd8, 
    0xfb, 0xdd, 0x3c, 0xd8, 0x04, 0xdf, 0x3c, 0xd8, 0x05, 0xdf, 0x3c, 0xd8, 0x03, 0xdf, 0x3d, 0xd8, 
    0xfd, 0xdd, 0x3c, 0xd8, 0x09, 0xdf, 0x3c, 0xd8, 0xa0, 0xdf, 0x3c, 0xd8, 0xa1, 0xdf, 0xf2, 0x26, 
    0x3c, 0xd8, 0xa2, 0xdf, 0x3d, 0xd8, 0xa2, 0xde, 0xf5, 0x26, 0x3d, 0xd8, 0xa4, 0xde, 0x3d, 0xd8, 
    0xa3, 0xde, 0x93, 0x26, 0x3d, 0xd8, 0x80, 0xde, 0x08, 0x27, 0x3d, 0xd8, 0xba, 0xdc, 0x3d, 0xd8, 
    0x81, 0xde, 0x3d, 0xd8, 0x82, 0xde, 0x3d, 0xd8, 0x8a, 0xde, 0x3d, 0xd8, 0x89, 0xde, 0x3d, 0xd8, 
    0x8e, 0xde, 0x3d, 0xd8, 0x86, 0xde, 0x3d, 0xd8, 0x84, 0xde, 0x3d, 0xd8, 0x85, 0xde, 0x3d, 0xd8, 
    0x88, 0xde, 0x3d, 0xd8, 0x87, 0xde, 0x3d, 0xd8, 0x9d, 0xde, 0x3d, 0xd8, 0x8b, 0xde, 0x3d, 0xd8, 
    0x83, 0xde, 0x3d, 0xd8, 0x8e, 0xde, 0x3d, 0xd8, 0x8c, 0xde, 0x3d, 0xd8, 0x8d, 0xde, 0x3d, 0xd8, 
    0x99, 0xde, 0x3d, 0xd8, 0x98, 0xde, 0x3d, 0xd8, 0x97, 0xde, 0x3d, 0xd8, 0x95, 0xde, 0x3d, 0xd8, 
    0x96, 0xde, 0x3d, 0xd8, 0x9b, 0xde, 0x3d, 0xd8, 0x9a, 0xde, 0x3d, 0xd8, 0xa8, 0xde, 0x3d, 0xd8, 
    0x93, 0xde, 0x3d, 0xd8, 0x94, 0xde, 0x3d, 0xd8, 0x92, 0xde, 0x3d, 0xd8, 0x91, 0xde, 0x3d, 0xd8, 
    0x90, 0xde, 0x3d, 0xd8, 0xb2, 0xde, 0x3d, 0xd8, 0xa1, 0xde, 0x3d, 0xd8, 0x9f, 0xde, 0x3d, 0xd8, 
    0xa0, 0xde, 0x3d, 0xd8, 0x9c, 0xde, 0x3d, 0xd8, 0x88, 0xdc, 0x3d, 0xd8, 0x8f, 0xde, 0x3c, 0xd8, 
    0xab, 0xdf, 0x3d, 0xd8, 0xa6, 0xde, 0x3d, 0xd8, 0xa5, 0xde, 0xa0, 0x26, 0x3d, 0xd8, 0xa7, 0xde, 
    0x3d, 0xd8, 0x30, 0xdd, 0xfd, 0x26, 0x3c, 0xd8, 0xee, 0xdf, 0x3c, 0xd8, 0xb0, 0xdf, 0x68, 0x26, 
    0x3d, 0xd8, 0xff, 0xdd, 0x3c, 0xd8, 0xaa, 0xdf, 0x3c, 0xd8, 0xad, 0xdf, 0x3d, 0xd8, 0xcd, 0xdc, 
    0x3d, 0xd8, 0xa9, 0xde, 0x3c, 0xd8, 0xef, 0xdd, 0x3c, 0xd8, 0xf5, 0xdd, 0x3c, 0xd8, 0xf0, 0xdd, 
    0x3c, 0xd8, 0xf7, 0xdd, 0x3c, 0xd8, 0xe9, 0xdd, 0x3c, 0xd8, 0xea, 0xdd, 0x3c, 0xd8, 0xe8, 0xdd, 
    0x3c, 0xd8, 0xf3, 0xdd, 0x3c, 0xd8, 0xfa, 0xdd, 0x3c, 0xd8, 0xf8, 0xdd, 0x3c, 0xd8, 0xeb, 0xdd, 
    0x3c, 0xd8, 0xf7, 0xdd, 0x3c, 0xd8, 0xea, 0xdd, 0x3c, 0xd8, 0xf8, 0xdd, 0x3c, 0xd8, 0xee, 0xdd, 
    0x3c, 0xd8, 0xf9, 0xdd, 0x3c, 0xd8, 0xf7, 0xdd, 0x3c, 0xd8, 0xfa, 0xdd, 0x3c, 0xd8, 0xec, 0xdd, 
    0x3c, 0xd8, 0xe7, 0xdd, 0x3d, 0xd8, 0x1f, 0xdd, 0x3d, 0xd8, 0x22, 0xdd, 0x3d, 0xd8, 0x23, 0xdd, 
    0x06, 0x2b, 0x07, 0x2b, 0x05, 0x2b, 0xa1, 0x27, 0x3d, 0xd8, 0x20, 0xdd, 0x3d, 0xd8, 0x21, 0xdd, 
    0x3d, 0xd8, 0x24, 0xdd, 0x97, 0x21, 0x96, 0x21, 0x98, 0x21, 0x99, 0x21, 0x94, 0x21, 0x95, 0x21, 
    0x3d, 0xd8, 0x04, 0xdd, 0xc0, 0x25, 0xb6, 0x25, 0x3d, 0xd8, 0x3c, 0xdd, 0x3d, 0xd8, 0x3d, 0xdd, 
    0xa9, 0x21, 0xaa, 0x21, 0x39, 0x21, 0xea, 0x23, 0xe9, 0x23, 0xeb, 0x23, 0xec, 0x23, 0x35, 0x29, 
    0x34, 0x29, 0x3c, 0xd8, 0x97, 0xdd, 0x3d, 0xd8, 0x00, 0xdd, 0x3d, 0xd8, 0x01, 0xdd, 0x3d, 0xd8, 
    0x02, 0xdd, 0x3c, 0xd8, 0x95, 0xdd, 0x3c, 0xd8, 0x99, 0xdd, 0x3c, 0xd8, 0x92, 0xdd, 0x3c, 0xd8, 
    0x93, 0xdd, 0x3c, 0xd8, 0x96, 0xdd, 0x3d, 0xd8, 0xf6, 0xdc, 0x3c, 0xd8, 0xa6, 0xdf, 0x3c, 0xd8, 
    0x01, 0xde, 0x3c, 0xd8, 0x2f, 0xde, 0x3c, 0xd8, 0x33, 0xde, 0x3c, 0xd8, 0x35, 0xde, 0x3c, 0xd8, 
    0x34, 0xde, 0x3c, 0xd8, 0x32, 0xde, 0x3c, 0xd8, 0x50, 0xde, 0x3c, 0xd8, 0x39, 0xde, 0x3c, 0xd8, 
    0x3a, 0xde, 0x3c, 0xd8, 0x36, 0xde, 0x3c, 0xd8, 0x1a, 0xde, 0x3d, 0xd8, 0xbb, 0xde, 0x3d, 0xd8, 
    0xb9, 0xde, 0x3d, 0xd8, 0xba, 0xde, 0x3d, 0xd8, 0xbc, 0xde, 0x3d, 0xd8, 0xbe, 0xde, 0x3d, 0xd8, 
    0xb0, 0xde, 0x3d, 0xd8, 0xae, 0xde, 0x3c, 0xd8, 0x7f, 0xdd, 0x7f, 0x26, 0x3d, 0xd8, 0xad, 0xde, 
    0x3c, 0xd8, 0x37, 0xde, 0x3c, 0xd8, 0x38, 0xde, 0x3c, 0xd8, 0x02, 0xde, 0xc2, 0x24, 0x3d, 0xd8, 
    0xc2, 0xde, 0x3d, 0xd8, 0xc4, 0xde, 0x3d, 0xd8, 0xc5, 0xde, 0x3d, 0xd8, 0xc3, 0xde, 0x3c, 0xd8, 
    0x51, 0xde, 0x99, 0x32, 0x97, 0x32, 0x3c, 0xd8, 0x91, 0xdd, 0x3c, 0xd8, 0x98, 0xdd, 0x3c, 0xd8, 
    0x94, 0xdd, 0x3d, 0xd8, 0xab, 0xde, 0x3d, 0xd8, 0x1e, 0xdd, 0x3d, 0xd8, 0xf5, 0xdc, 0x3d, 0xd8, 
    0xaf, 0xde, 0x3d, 0xd8, 0xb1, 0xde, 0x3d, 0xd8, 0xb3, 0xde, 0x3d, 0xd8, 0xb7, 0xde, 0x3d, 0xd8, 
    0xb8, 0xde, 0xd4, 0x26, 0x33, 0x27, 0x47, 0x27, 0x4e, 0x27, 0x05, 0x27, 0x34, 0x27, 0x3d, 0xd8, 
    0x9f, 0xdc, 0x3c, 0xd8, 0x9a, 0xdd, 0x3d, 0xd8, 0xf3, 0xdc, 0x3d, 0xd8, 0xf4, 0xdc, 0x3c, 0xd8, 
    0x70, 0xdd, 0x3c, 0xd8, 0x71, 0xdd, 0x3c, 0xd8, 0x8e, 0xdd, 0x3c, 0xd8, 0x7e, 0xdd, 0x3d, 0xd8, 
    0xa0, 0xdc, 0xbf, 0x27, 0x7b, 0x26, 0x48, 0x26, 0x49, 0x26, 0x4a, 0x26, 0x4b, 0x26, 0x4c, 0x26, 
    0x4d, 0x26, 0x4e, 0x26, 0x4f, 0x26, 0x50, 0x26, 0x51, 0x26, 0x52, 0x26, 0x53, 0x26, 0xce, 0x26, 
    0x3d, 0xd8, 0x2f, 0xdd, 0x3c, 0xd8, 0xe7, 0xdf, 0x3d, 0xd8, 0xb9, 0xdc, 0x3d, 0xd8, 0xb2, 0xdc, 
    0x3d, 0xd8, 0xb1, 0xdc, 0xa9, 0x00, 0xae, 0x00, 0x22, 0x21, 0x4c, 0x27, 0x3c, 0x20, 0x49, 0x20, 
    0x57, 0x27, 0x53, 0x27, 0x55, 0x27, 0x54, 0x27, 0x55, 0x2b, 0x3d, 0xd8, 0x1d, 0xdd, 0x3d, 0xd8, 
    0x1a, 0xdd, 0x3d, 0xd8, 0x19, 0xdd, 0x3d, 0xd8, 0x1b, 0xdd, 0x3d, 0xd8, 0x1c, 0xdd, 0x3d, 0xd8, 
    0x03, 0xdd, 0x3d, 0xd8, 0x5b, 0xdd, 0x3d, 0xd8, 0x67, 0xdd, 0x3d, 0xd8, 0x50, 0xdd, 0x3d, 0xd8, 
    0x5c, 0xdd, 0x3d, 0xd8, 0x51, 0xdd, 0x3d, 0xd8, 0x5d, 0xdd, 0x3d, 0xd8, 0x52, 0xdd, 0x3d, 0xd8, 
    0x5e, 0xdd, 0x3d, 0xd8, 0x53, 0xdd, 0x3d, 0xd8, 0x5f, 0xdd, 0x3d, 0xd8, 0x54, 0xdd, 0x3d, 0xd8, 
    0x60, 0xdd, 0x3d, 0xd8, 0x55, 0xdd, 0x3d, 0xd8, 0x61, 0xdd, 0x3d, 0xd8, 0x56, 0xdd, 0x3d, 0xd8, 
    0x62, 0xdd, 0x3d, 0xd8, 0x57, 0xdd, 0x3d, 0xd8, 0x63, 0xdd, 0x3d, 0xd8, 0x58, 0xdd, 0x3d, 0xd8, 
    0x64, 0xdd, 0x3d, 0xd8, 0x59, 0xdd, 0x3d, 0xd8, 0x65, 0xdd, 0x3d, 0xd8, 0x5a, 0xdd, 0x3d, 0xd8, 
    0x66, 0xdd, 0x16, 0x27, 0x95, 0x27, 0x96, 0x27, 0x97, 0x27, 0x60, 0x26, 0x65, 0x26, 0x63, 0x26, 
    0x66, 0x26, 0x3d, 0xd8, 0xae, 0xdc, 0x3d, 0xd8, 0xaf, 0xdc, 0x14, 0x27, 0x11, 0x26, 0x3d, 0xd8, 
    0x18, 0xdd, 0x3d, 0xd8, 0x17, 0xdd, 0xb0, 0x27, 0x30, 0x30, 0x3d, 0x30, 0x3d, 0xd8, 0x31, 0xdd, 
    0xfc, 0x25, 0xfb, 0x25, 0xfe, 0x25, 0xfd, 0x25, 0xaa, 0x25, 0xab, 0x25, 0x3d, 0xd8, 0x3a, 0xdd, 
    0x3d, 0xd8, 0x32, 0xdd, 0x3d, 0xd8, 0x33, 0xdd, 0xab, 0x26, 0xaa, 0x26, 0x3d, 0xd8, 0x34, 0xdd, 
    0x3d, 0xd8, 0x35, 0xdd, 0x3d, 0xd8, 0x3b, 0xdd, 0x1c, 0x2b, 0x1b, 0x2b, 0x3d, 0xd8, 0x36, 0xdd, 
    0x3d, 0xd8, 0x37, 0xdd, 0x3d, 0xd8, 0x38, 0xdd, 0x3d, 0xd8, 0x39, 0xdd
};

@implementation NSCharacterSet (EmojisAddition)

+ (NSCharacterSet *) illegalXMLCharacterSet {
	static NSMutableCharacterSet *illegalSet = nil;
	if (!illegalSet) {
		illegalSet = [[NSCharacterSet characterSetWithRange:NSMakeRange( 0, 0x1f )] mutableCopy];

		[illegalSet removeCharactersInRange:NSMakeRange( 0x09, 1 )];

		[illegalSet addCharactersInRange:NSMakeRange( 0x7f, 1 )];
		[illegalSet addCharactersInRange:NSMakeRange( 0xfffe, 1 )];
		[illegalSet addCharactersInRange:NSMakeRange( 0xffff, 1 )];

		illegalSet = [illegalSet copy];
	}
	return [illegalSet copy];
}
+ (NSCharacterSet*) emojiCharacterSet {
    
  return [NSCharacterSet characterSetWithCharactersInString:
                              [[NSString.alloc initWithData:
                                      [NSData dataWithBytes:emoji6 length:sizeof(emoji6)] encoding:NSUTF16StringEncoding]
                                                  stringByAppendingString:@"\u20e3"]]; // Add keyring character
}


- (void) log { [self.class logCharacterSet:self];}

+ (void) logCharacterSet:(NSCharacterSet*)characterSet {

    unichar unicharBuffer[20]; int index = 0;
    for (unichar uc = 0; uc < (0xFFFF); uc ++) {
        if ([characterSet characterIsMember:uc]) {
            unicharBuffer[index] = uc;
            index ++;
            if (index == 20) {
                NSS* characters = [NSString stringWithCharacters:unicharBuffer length:index];
                NSLog(@"%@", characters);
                index = 0;
            }
        }
    }
   if (index) {
        NSS* characters = [NSString stringWithCharacters:unicharBuffer length:index];
        NSLog(@"%@", characters);
    }
}
@end




#import <sys/time.h>

struct EmojiEmoticonPair {
	const unichar emoji;
	CFStringRef emoticon;
};

static const struct EmojiEmoticonPair emojiToEmoticonList[] = {
	{ 0xe00e, CFSTR("(Y)") },
	{ 0xe022, CFSTR("<3") },
	{ 0xe023, CFSTR("</3") },
	{ 0xe032, CFSTR("@};-") },
	{ 0xe048, CFSTR(":^)") },
	{ 0xe04e, CFSTR("O:)") },
	{ 0xe056, CFSTR(":)") },
	{ 0xe057, CFSTR(":D") },
	{ 0xe058, CFSTR(":(") },
	{ 0xe059, CFSTR(">:(") },
	{ 0xe05a, CFSTR("~<:)") },
	{ 0xe105, CFSTR(";P") },
	{ 0xe106, CFSTR("(<3") },
	{ 0xe107, CFSTR(":O") },
	{ 0xe108, CFSTR("-_-'") },
	{ 0xe11a, CFSTR(">:)") },
	{ 0xe401, CFSTR(":'(") },
	{ 0xe402, CFSTR(":j") },
	{ 0xe403, CFSTR(":|") },
	{ 0xe404, CFSTR(":-!") },
	{ 0xe405, CFSTR(";)") },
	{ 0xe406, CFSTR("><") },
	{ 0xe407, CFSTR(":X") },
	{ 0xe408, CFSTR(";'(") },
	{ 0xe409, CFSTR(":P") },
	{ 0xe40a, CFSTR(":->") },
	{ 0xe40b, CFSTR(":o") },
	{ 0xe40c, CFSTR(":-&") },
	{ 0xe40d, CFSTR("O.O") },
	{ 0xe40e, CFSTR(":/") },
	{ 0xe40f, CFSTR(":'o") },
	{ 0xe410, CFSTR("x_x") },
	{ 0xe411, CFSTR(":\"o") },
	{ 0xe412, CFSTR(":'D") },
	{ 0xe413, CFSTR(";(") },
	{ 0xe414, CFSTR(":[") },
	{ 0xe415, CFSTR("^-^") },
	{ 0xe416, CFSTR("}:(") },
	{ 0xe417, CFSTR(":-*") },
	{ 0xe418, CFSTR(";-*") },
	{ 0xe421, CFSTR("(N)") },
	{ 0xe445, CFSTR("(~~)") },
	{ 0xe50c, CFSTR("**==") },
	{ 0, nil }
};

static const struct EmojiEmoticonPair emoticonToEmojiList[] = {
// Most Common
	{ 0xe056, CFSTR(":)") },
	{ 0xe056, CFSTR("=)") },
	{ 0xe058, CFSTR(":(") },
	{ 0xe058, CFSTR("=(") },
	{ 0xe405, CFSTR(";)") },
	{ 0xe409, CFSTR(":P") },
	{ 0xe409, CFSTR(":p") },
	{ 0xe409, CFSTR("=P") },
	{ 0xe409, CFSTR("=p") },
	{ 0xe105, CFSTR(";p") },
	{ 0xe105, CFSTR(";P") },
	{ 0xe057, CFSTR(":D") },
	{ 0xe057, CFSTR("=D") },
	{ 0xe403, CFSTR(":|") },
	{ 0xe403, CFSTR("=|") },
	{ 0xe40e, CFSTR(":/") },
	{ 0xe40e, CFSTR(":\\") },
	{ 0xe40e, CFSTR("=/") },
	{ 0xe40e, CFSTR("=\\") },
	{ 0xe414, CFSTR(":[") },
	{ 0xe414, CFSTR("=[") },
	{ 0xe056, CFSTR(":]") },
	{ 0xe056, CFSTR("=]") },
	{ 0xe40b, CFSTR(":o") },
	{ 0xe107, CFSTR(":O") },
	{ 0xe40b, CFSTR("=o") },
	{ 0xe107, CFSTR("=O") },
	{ 0xe107, CFSTR(":0") },
	{ 0xe107, CFSTR("=0") },
	{ 0xe04e, CFSTR("O:)") },
	{ 0xe04e, CFSTR("0:)") },
	{ 0xe04e, CFSTR("o:)") },
	{ 0xe04e, CFSTR("O=)") },
	{ 0xe04e, CFSTR("0=)") },
	{ 0xe04e, CFSTR("o=)") },
	{ 0xe022, CFSTR("<3") },
	{ 0xe023, CFSTR("</3") },
	{ 0xe023, CFSTR("<\3") },
	{ 0xe406, CFSTR("><") },
	{ 0xe40d, CFSTR("O.O") },
	{ 0xe40d, CFSTR("o.o") },
	{ 0xe40d, CFSTR("O.o") },
	{ 0xe40d, CFSTR("o.O") },
	{ 0xe409, CFSTR("XD") },
	{ 0xe409, CFSTR("xD") },
	{ 0xe407, CFSTR(":X") },
	{ 0xe407, CFSTR(":x") },
	{ 0xe407, CFSTR("=X") },
	{ 0xe407, CFSTR("=x") },
	{ 0xe059, CFSTR(">:(") },
	{ 0xe11a, CFSTR(">:)") },
	{ 0xe415, CFSTR("^.^") },
	{ 0xe415, CFSTR("^-^") },
	{ 0xe415, CFSTR("^_^") },

// Less Common
	{ 0xe056, CFSTR("(:") },
	{ 0xe056, CFSTR("(=") },
	{ 0xe056, CFSTR("[:") },
	{ 0xe056, CFSTR("[=") },
	{ 0xe058, CFSTR("):") },
	{ 0xe058, CFSTR(")=") },
	{ 0xe058, CFSTR("]=") },
	{ 0xe058, CFSTR("]:") },
	{ 0xe056, CFSTR(":-)") },
	{ 0xe056, CFSTR("=-)") },
	{ 0xe058, CFSTR(":-(") },
	{ 0xe409, CFSTR(":-P") },
	{ 0xe409, CFSTR(":-p") },
	{ 0xe409, CFSTR("=-P") },
	{ 0xe409, CFSTR("=-p") },
	{ 0xe105, CFSTR(";-p") },
	{ 0xe105, CFSTR(";-P") },
	{ 0xe405, CFSTR(";-)") },
	{ 0xe057, CFSTR(":-D") },
	{ 0xe057, CFSTR("=-D") },
	{ 0xe058, CFSTR("=-(") },
	{ 0xe059, CFSTR(">=(") },
	{ 0xe11a, CFSTR(">=)") },
	{ 0xe414, CFSTR(":-[") },
	{ 0xe414, CFSTR("=-[") },
	{ 0xe107, CFSTR(":-0") },
	{ 0xe107, CFSTR("=-0") },
	{ 0xe04e, CFSTR("O=-)") },
	{ 0xe04e, CFSTR("o=-)") },
	{ 0xe108, CFSTR("-_-'") },
	{ 0xe403, CFSTR("-_-") },
	{ 0xe409, CFSTR("Xd") },
	{ 0xe409, CFSTR("xd") },
	{ 0xe409, CFSTR(";D") },
	{ 0xe409, CFSTR("D:") },
	{ 0xe409, CFSTR("D:<") },
	{ 0xe406, CFSTR(">_<") },
	{ 0xe410, CFSTR("X_X") },
	{ 0xe410, CFSTR("x_x") },
	{ 0xe410, CFSTR("X_x") },
	{ 0xe410, CFSTR("x_X") },
	{ 0xe410, CFSTR("x.x") },
	{ 0xe410, CFSTR("X.X") },
	{ 0xe410, CFSTR("X.x") },
	{ 0xe410, CFSTR("x.X") },
	{ 0xe417, CFSTR(":*") },
	{ 0xe417, CFSTR(":-*") },
	{ 0xe417, CFSTR("=*") },
	{ 0xe417, CFSTR("=-*") },
	{ 0xe418, CFSTR(";*") },
	{ 0xe418, CFSTR(";-*") },
	{ 0xe401, CFSTR(":'(") },
	{ 0xe401, CFSTR("='(") },
	{ 0xe404, CFSTR(":!") },
	{ 0xe404, CFSTR(":-!") },
	{ 0xe404, CFSTR("=!") },
	{ 0xe404, CFSTR("=-!") },
	{ 0xe40c, CFSTR(":&") },
	{ 0xe40c, CFSTR(":-&") },
	{ 0xe40c, CFSTR("=&") },
	{ 0xe40c, CFSTR("=-&") },
	{ 0xe40c, CFSTR(":#") },
	{ 0xe40c, CFSTR(":-#") },
	{ 0xe40c, CFSTR("=#") },
	{ 0xe40c, CFSTR("=-#") },
	{ 0xe411, CFSTR(":\"o") },
	{ 0xe411, CFSTR("=\"o") },
	{ 0xe411, CFSTR(":\"O") },
	{ 0xe411, CFSTR("=\"O") },
	{ 0xe412, CFSTR(":'D") },
	{ 0xe412, CFSTR("='D") },
	{ 0xe413, CFSTR(";(") },
	{ 0xe408, CFSTR(";'(") },
	{ 0xe40f, CFSTR(":'o") },
	{ 0xe40f, CFSTR(":'O") },
	{ 0xe40f, CFSTR("='o") },
	{ 0xe40f, CFSTR("='O") },
	{ 0xe40e, CFSTR(":-/") },
	{ 0xe40e, CFSTR(":-\\") },
	{ 0xe40e, CFSTR("=-/") },
	{ 0xe40e, CFSTR("=-\\") },
	{ 0xe40b, CFSTR(":-o") },
	{ 0xe107, CFSTR(":-O") },
	{ 0xe40b, CFSTR("=-o") },
	{ 0xe107, CFSTR("=-O") },
	{ 0xe402, CFSTR(":j") },
	{ 0xe402, CFSTR(":-j") },
	{ 0xe402, CFSTR("=j") },
	{ 0xe402, CFSTR("=-j") },
	{ 0xe40a, CFSTR(":>") },
	{ 0xe40a, CFSTR(":->") },
	{ 0xe40a, CFSTR("=>") },
	{ 0xe40a, CFSTR("=->") },
	{ 0xe416, CFSTR("}:(") },
	{ 0xe416, CFSTR("}:-(") },
	{ 0xe416, CFSTR("}=(") },
	{ 0xe416, CFSTR("}=-(") },
	{ 0xe059, CFSTR(">:-(") },
	{ 0xe11a, CFSTR(">:-)") },
	{ 0xe059, CFSTR(">=-(") },
	{ 0xe11a, CFSTR(">=-)") },
	{ 0xe04e, CFSTR("O:-)") },
	{ 0xe04e, CFSTR("o:-)") },

// Rare
	{ 0xe05a, CFSTR("~<:)") },
	{ 0xe048, CFSTR(":^)") },
	{ 0xe048, CFSTR(";^)") },
	{ 0xe048, CFSTR("=^)") },
	{ 0xe032, CFSTR("@};-") },
	{ 0xe032, CFSTR("@>-") },
	{ 0xe032, CFSTR("-;{@") },
	{ 0xe032, CFSTR("-<@") },
	{ 0xe445, CFSTR("(~~)") },
	{ 0xe50c, CFSTR("**==") },
	{ 0xe00e, CFSTR("(Y)") },
	{ 0xe00e, CFSTR("(y)") },
	{ 0xe421, CFSTR("(N)") },
	{ 0xe421, CFSTR("(n)") },
	{ 0xe106, CFSTR("(<3") },
	{ 0xe409, CFSTR("d:") },
	{ 0xe409, CFSTR("d=") },
	{ 0xe409, CFSTR("d-:") },
	{ 0xe056, CFSTR("(-:") },
	{ 0xe056, CFSTR("(-=") },
	{ 0xe058, CFSTR(")-:") },
	{ 0xe058, CFSTR(")-=") },
	{ 0xe058, CFSTR("]-:") },
	{ 0xe058, CFSTR("]-=") },
	{ 0xe401, CFSTR(")':") },
	{ 0xe401, CFSTR(")'=") },
	{ 0xe404, CFSTR("!:") },
	{ 0xe404, CFSTR("!-:") },
	{ 0xe404, CFSTR("!-=") },
	{ 0xe40b, CFSTR("o:") },
	{ 0xe107, CFSTR("O:") },
	{ 0xe40b, CFSTR("o-:") },
	{ 0xe107, CFSTR("O-:") },
	{ 0xe40b, CFSTR("o=") },
	{ 0xe107, CFSTR("O=") },
	{ 0xe40b, CFSTR("o-=") },
	{ 0xe107, CFSTR("O-=") },
	{ 0xe107, CFSTR("0:") },
	{ 0xe107, CFSTR("0-:") },
	{ 0xe107, CFSTR("0=") },
	{ 0xe107, CFSTR("0-=") },
	{ 0xe418, CFSTR("*;") },
	{ 0xe418, CFSTR("*-;") },
	{ 0xe417, CFSTR("*:") },
	{ 0xe417, CFSTR("*-:") },
	{ 0xe417, CFSTR("*=") },
	{ 0xe417, CFSTR("*-=") },
	{ 0xe11a, CFSTR("(:<") },
	{ 0xe059, CFSTR("):<") },
	{ 0xe11a, CFSTR("(-:<") },
	{ 0xe059, CFSTR(")-:<") },
	{ 0xe11a, CFSTR("(=<") },
	{ 0xe059, CFSTR(")=<") },
	{ 0xe11a, CFSTR("(-=<") },
	{ 0xe059, CFSTR(")-=<") },
	{ 0xe0b4e, CFSTR("(:O") },
	{ 0xe04e, CFSTR("(:o") },
	{ 0xe04e, CFSTR("(-:O") },
	{ 0xe04e, CFSTR("(-:o") },
	{ 0xe04e, CFSTR("(=O") },
	{ 0xe04e, CFSTR("(=o") },
	{ 0xe04e, CFSTR("(-=O") },
	{ 0xe04e, CFSTR("(-=o") },

	{ 0, nil }
};

BOOL isValidUTF8( const char *s, NSUInteger len ) {
	BOOL only7bit = YES;

	for( NSUInteger i = 0; i < len; ++i ) {
		const unsigned char ch = s[i];

		if( is7Bit( ch ) )
			continue;

		if( only7bit )
			only7bit = NO;

		if( isUTF8Tupel( ch ) ) {
			if( len - i < 1 ) // too short
				return NO;
			if( isUTF8LongTupel( ch ) ) // not minimally encoded
				return NO;
			if( ! isUTF8Cont( s[i + 1] ) )
				return NO;
			i += 1;
		} else if( isUTF8Triple( ch ) ) {
			if( len - i < 2 ) // too short
				return NO;
			if( isUTF8LongTriple( ch, s[i + 1] ) ) // not minimally encoded
				return NO;
			if( ! isUTF8Cont( s[i + 1] ) || ! isUTF8Cont( s[i + 2] ) )
				return NO;
			i += 2;
		} else if( isUTF8Quartet( ch ) ) {
			if( len - i < 3 ) // too short
				return NO;
			if( isUTF8LongQuartet( ch, s[i + 1] ) ) // not minimally encoded
				return NO;
			if( ! isUTF8Cont( s[i + 1] ) || ! isUTF8Cont( s[i + 2] ) || ! isUTF8Cont( s[i + 3] ) )
				return NO;
			i += 3;
		} else if( isUTF8Quintet( ch ) ) {
			if( len - i < 4 ) // too short
				return NO;
			if( isUTF8LongQuintet( ch, s[i + 1] ) ) // not minimally encoded
				return NO;
			if( ! isUTF8Cont( s[i + 1] ) || ! isUTF8Cont( s[i + 2] ) || ! isUTF8Cont( s[i + 3] ) || ! isUTF8Cont( s[i + 4] ) )
				return NO;
			i += 4;
		} else if( isUTF8Sextet( ch ) ) {
			if( len - i < 5 ) // too short
				return NO;
			if( isUTF8LongSextet( ch, s[i + 1] ) ) // not minimally encoded
				return NO;
			if( ! isUTF8Cont( s[i + 1] ) || ! isUTF8Cont( s[i + 2] ) || ! isUTF8Cont( s[i + 3] ) || ! isUTF8Cont( s[i + 4] ) || ! isUTF8Cont( s[i + 5] ) )
				return NO;
			i += 5;
		} else return NO;
	}

	if( only7bit )
		return NO; // technically it can be UTF8, but it might be another 7-bit encoding
	return YES;
}

static const unsigned char mIRCColors[][3] = {
	{ 0xff, 0xff, 0xff },  /* 00) white */
	{ 0x00, 0x00, 0x00 },  /* 01) black */
	{ 0x00, 0x00, 0x7b },  /* 02) blue */
	{ 0x00, 0x94, 0x00 },  /* 03) green */
	{ 0xff, 0x00, 0x00 },  /* 04) red */
	{ 0x7b, 0x00, 0x00 },  /* 05) brown */
	{ 0x9c, 0x00, 0x9c },  /* 06) purple */
	{ 0xff, 0x7b, 0x00 },  /* 07) orange */
	{ 0xff, 0xff, 0x00 },  /* 08) yellow */
	{ 0x00, 0xff, 0x00 },  /* 09) bright green */
	{ 0x00, 0x94, 0x94 },  /* 10) cyan */
	{ 0x00, 0xff, 0xff },  /* 11) bright cyan */
	{ 0x00, 0x00, 0xff },  /* 12) bright blue */
	{ 0xff, 0x00, 0xff },  /* 13) bright purple */
	{ 0x7b, 0x7b, 0x7b },  /* 14) gray */
	{ 0xd6, 0xd6, 0xd6 }   /* 15) light gray */
};

static const unsigned char CTCPColors[][3] = {
	{ 0x00, 0x00, 0x00 },  /* 0) black */
	{ 0x00, 0x00, 0x7f },  /* 1) blue */
	{ 0x00, 0x7f, 0x00 },  /* 2) green */
	{ 0x00, 0x7f, 0x7f },  /* 3) cyan */
	{ 0x7f, 0x00, 0x00 },  /* 4) red */
	{ 0x7f, 0x00, 0x7f },  /* 5) purple */
	{ 0x7f, 0x7f, 0x00 },  /* 6) brown */
	{ 0xc0, 0xc0, 0xc0 },  /* 7) light gray */
	{ 0x7f, 0x7f, 0x7f },  /* 8) gray */
	{ 0x00, 0x00, 0xff },  /* 9) bright blue */
	{ 0x00, 0xff, 0x00 },  /* A) bright green */
	{ 0x00, 0xff, 0xff },  /* B) bright cyan */
	{ 0xff, 0x00, 0x00 },  /* C) bright red */
	{ 0xff, 0x00, 0xff },  /* D) bright magenta */
	{ 0xff, 0xff, 0x00 },  /* E) yellow */
	{ 0xff, 0xff, 0xff }   /* F) white */
};

static BOOL scanOneOrTwoDigits( NSScanner *scanner, NSUInteger *number ) {
	NSCharacterSet *characterSet = [NSCharacterSet decimalDigitCharacterSet];
	NSS*chars = nil;

	if( ! [scanner scanCharactersFromSet:characterSet maxLength:2 intoString:&chars] )
		return NO;

	*number = [chars intValue];
	return YES;
}

static NSS*colorForHTML( unsigned char red, unsigned char green, unsigned char blue ) {
	return [NSString stringWithFormat:@"#%02X%02X%02X", red, green, blue];
}

static NSUInteger levenshteinDistanceBetweenStrings(char *string, char *otherString) {
	NSUInteger stringLength = strlen(string);
	NSUInteger otherStringLength = strlen(otherString);
	NSUInteger distances[stringLength + 1][otherStringLength + 1];

	memset(distances, -1, sizeof(distances));

	for (NSUInteger i = 0; i <= stringLength; i++)
		distances[i][0] = i;

	for (NSUInteger i = 0; i <= otherStringLength; i++)
		distances[0][i] = i;

	for (NSUInteger i = 1; i <= stringLength; i++) {
		for (NSUInteger j = 1; j <= otherStringLength; j++) {
			if (string[(i - 1)] == otherString[(j - 1)])
				distances[i][j] = distances[(i - 1)][(j - 1)];
			else {
				NSUInteger minimum = MIN(distances[(i - 1)][j], distances[i][(j - 1)]);
				distances[i][j] = (MIN(minimum, distances[(i - 1)][(j - 1)]) + 1);
			}
		}
	}

	return distances[stringLength][otherStringLength];
}

@implementation NSString (NSStringAdditions)
+ (NSA*) emoji { return [NSA arrayWithArrays:self.emojiDictionary.allValues]; }
+ (NSD*) emojiDictionary {

  NSD* d = [NSD dictionaryWithContentsOfFile:[AZFWORKBUNDLE pathForResource:@"Emoji" ofType:@"plist"]];
  return [d map:^id(id key, id obj) {
    return [obj map:^id(id object) { return $(@"%@", object); }];
  }];
}
+ (NSS*) locallyUniqueString {
	struct timeval tv;
	gettimeofday( &tv, NULL );

	NSUInteger m = 36; // base (denominator)
	NSUInteger q = [[NSProcessInfo processInfo] processIdentifier] ^ tv.tv_usec; // input (quotient)
	NSUInteger r = 0; // remainder

	NSMutableString *uniqueId = [[NSMutableString alloc] initWithCapacity:10];
	[uniqueId appendFormat:@"%c", (char)('A' + ( arc4random() % 26 ))]; // always have a random letter first (more ambiguity)

	#define baseConvert	do { \
		r = q % m; \
		q = q / m; \
		if( r >= 10 ) r = 'A' + ( r - 10 ); \
		else r = '0' + r; \
		[uniqueId appendFormat:@"%c", (char)r]; \
	} while( q ) \

	baseConvert;

	q = ( tv.tv_sec - 1104555600 ); // subtract 35 years, we only care about post Jan 1 2005

	baseConvert;

	#undef baseConvert

	return uniqueId;
}
+ (NSA*) knownEmoticons {
	static NSMutableArray *knownEmoticons;
	if( ! knownEmoticons ) {
		knownEmoticons = [[NSMutableArray alloc] initWithCapacity:350];
		for (const struct EmojiEmoticonPair *entry = emoticonToEmojiList; entry && entry->emoticon; ++entry)
			[knownEmoticons addObject:objc_unretainedObject(entry->emoticon)];
	}

	return knownEmoticons;
}
+ (NSSet*) knownEmojiWithEmoticons {

	static NSMutableSet *knownEmoji;

  return knownEmoji = knownEmoji ?: ^{

		knownEmoji = [[NSMutableSet alloc] initWithCapacity:300];
		for (const struct EmojiEmoticonPair *entry = emojiToEmoticonList; entry && entry->emoticon; ++entry)
			[knownEmoji addObject:[[NSString alloc] initWithCharacters:&entry->emoji length:1]];
    return knownEmoji;
  }();
}
- (id) initWithChatData:(NSData *) data encoding:(NSStringEncoding) encoding {
	if( ! encoding ) encoding = NSISOLatin1StringEncoding;

	// Search for CTCP/2 encoding tags and act on them
	NSMutableData *newData = [NSMutableData dataWithCapacity:data.length];
	NSStringEncoding currentEncoding = encoding;

	const char *bytes = [data bytes];
	NSUInteger length = data.length;
	NSUInteger j = 0, start = 0, end = 0;
	for( NSUInteger i = 0; i < length; i++ ) {
		if( bytes[i] == '\006' ) {
			end = i;
			j = ++i;

			for( ; i < length && bytes[i] != '\006'; i++ );
			if( i >= length ) break;
			if( i == j ) continue;

			if( bytes[j++] == 'E' ) {
				NSS*encodingStr = [[NSString alloc] initWithBytes:( bytes + j ) length:( i - j ) encoding:NSASCIIStringEncoding];
				NSStringEncoding newEncoding = 0;
				if( ! encodingStr.length ) { // if no encoding is declared, go back to user default
					newEncoding = encoding;
				} else if( [encodingStr isEqualToString:@"U"] ) {
					newEncoding = NSUTF8StringEncoding;
				} else {
					NSUInteger enc = [encodingStr intValue];
					switch( enc ) {
						case 1:
							newEncoding = NSISOLatin1StringEncoding;
							break;
						case 2:
							newEncoding = NSISOLatin2StringEncoding;
							break;
						case 3:
							newEncoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingISOLatin3 );
							break;
						case 4:
							newEncoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingISOLatin4 );
							break;
						case 5:
							newEncoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingISOLatinCyrillic );
							break;
						case 6:
							newEncoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingISOLatinArabic );
							break;
						case 7:
							newEncoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingISOLatinGreek );
							break;
						case 8:
							newEncoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingISOLatinHebrew );
							break;
						case 9:
							newEncoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingISOLatin5 );
							break;
						case 10:
							newEncoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingISOLatin6 );
							break;
					}
				}
				if( newEncoding && newEncoding != currentEncoding ) {
					if( ( end - start ) > 0 ) {
						NSData *subData = nil;
						if( currentEncoding != NSUTF8StringEncoding ) {
							NSS*tempStr = [[NSString alloc] initWithBytes:( bytes + start ) length:( end - start ) encoding:currentEncoding];
							NSData *utf8Data = [tempStr dataUsingEncoding:NSUTF8StringEncoding];
							if( utf8Data ) subData = utf8Data;
						} else subData = [[NSData alloc] initWithBytesNoCopy:(void *)( bytes + start ) length:( end - start )];
						if( subData ) [newData appendData:subData];
					}
					currentEncoding = newEncoding;
					start = i + 1;
				}
			}
		}
	}

	if( newData.length > 0 || currentEncoding != encoding ) {
		if( start < length ) {
			NSData *subData = nil;
			if( currentEncoding != NSUTF8StringEncoding ) {
				NSS*tempStr = [[NSString alloc] initWithBytes:( bytes + start ) length:( length - start ) encoding:currentEncoding];
				NSData *utf8Data = [tempStr dataUsingEncoding:NSUTF8StringEncoding];
				if( utf8Data ) subData = utf8Data;
			} else {
				subData = [[NSData alloc] initWithBytesNoCopy:(void *)( bytes + start ) length:( length - start )];
			}

			if( subData ) [newData appendData:subData];
		}

		encoding = NSUTF8StringEncoding;
		data = newData;
	}

	if( encoding != NSUTF8StringEncoding && isValidUTF8( [data bytes], data.length ) )
		encoding = NSUTF8StringEncoding;

	NSS*message = [[NSString alloc] initWithData:data encoding:encoding];
	if( ! message )	return nil;

	NSCharacterSet *formatCharacters = [NSCharacterSet characterSetWithCharactersInString:@"\002\003\006\026\037\017"];

	// if the message dosen't have any formatting chars just init as a plain string and return quickly
	if( [message rangeOfCharacterFromSet:formatCharacters].location == NSNotFound ) {
		self = [self initWithString:[message stringByEncodingXMLSpecialCharactersAsEntities]];
		return self;
	}

	NSMutableString *ret = [NSMutableString string];
	NSScanner *scanner = [NSScanner scannerWithString:message];
	[scanner setCharactersToBeSkipped:nil]; // don't skip leading whitespace!

	NSUInteger boldStack = 0, italicStack = 0, underlineStack = 0, strikeStack = 0, colorStack = 0;

	while( ! [scanner isAtEnd] ) {
		NSS*cStr = nil;
		if( [scanner scanCharactersFromSet:formatCharacters maxLength:1 intoString:&cStr] ) {
			unichar c = [cStr characterAtIndex:0];
			switch( c ) {
			case '\017': // reset all
				if( boldStack )
					[ret appendString:@"</b>"];
				if( italicStack )
					[ret appendString:@"</i>"];
				if( underlineStack )
					[ret appendString:@"</u>"];
				if( strikeStack )
					[ret appendString:@"</strike>"];
				for( NSUInteger i = 0; i < colorStack; ++i )
					[ret appendString:@"</span>"];

				boldStack = italicStack = underlineStack = strikeStack = colorStack = 0;
				break;
			case '\002': // toggle bold
				boldStack = ! boldStack;

				if( boldStack ) [ret appendString:@"<b>"];
				else [ret appendString:@"</b>"];
				break;
			case '\026': // toggle italic
				italicStack = ! italicStack;

				if( italicStack ) [ret appendString:@"<i>"];
				else [ret appendString:@"</i>"];
				break;
			case '\037': // toggle underline
				underlineStack = ! underlineStack;

				if( underlineStack ) [ret appendString:@"<u>"];
				else [ret appendString:@"</u>"];
				break;
			case '\003': // color
			{
				NSUInteger fcolor = 0;
				if( scanOneOrTwoDigits( scanner, &fcolor ) ) {
					fcolor %= 16;

					NSS*foregroundColor = colorForHTML(mIRCColors[fcolor][0], mIRCColors[fcolor][1], mIRCColors[fcolor][2]);
					[ret appendFormat:@"<span style=\"color: %@;", foregroundColor];

					NSUInteger bcolor = 0;
					if( [scanner scanString:@"," intoString:NULL] && scanOneOrTwoDigits( scanner, &bcolor ) && bcolor != 99 ) {
						bcolor %= 16;

						NSS*backgroundColor = colorForHTML(mIRCColors[bcolor][0], mIRCColors[bcolor][1], mIRCColors[bcolor][2]);
						[ret appendFormat:@" background-color: %@;", backgroundColor];
					}

					[ret appendString:@"\">"];

					++colorStack;
				} else { // no color, reset both colors
					for( NSUInteger i = 0; i < colorStack; ++i )
						[ret appendString:@"</span>"];
					colorStack = 0;
				}
				break;
			}
			case '\006': // ctcp 2 formatting (http://www.lag.net/~robey/ctcp/ctcp2.2.txt)
				if( ! [scanner isAtEnd] ) {
					BOOL off = NO;

					unichar formatChar = [message characterAtIndex:[scanner scanLocation]];
					[scanner setScanLocation:[scanner scanLocation]+1];

					switch( formatChar ) {
					case 'B': // bold
						if( [scanner scanString:@"-" intoString:NULL] ) {
							if( boldStack >= 1 ) boldStack--;
							off = YES;
						} else { // on is the default
							[scanner scanString:@"+" intoString:NULL];
							boldStack++;
						}

						if( boldStack == 1 && ! off )
							[ret appendString:@"<b>"];
						else if( ! boldStack )
							[ret appendString:@"</b>"];
						break;
					case 'I': // italic
						if( [scanner scanString:@"-" intoString:NULL] ) {
							if( italicStack >= 1 ) italicStack--;
							off = YES;
						} else { // on is the default
							[scanner scanString:@"+" intoString:NULL];
							italicStack++;
						}

						if( italicStack == 1 && ! off )
							[ret appendString:@"<i>"];
						else if( ! italicStack )
							[ret appendString:@"</i>"];
						break;
					case 'U': // underline
						if( [scanner scanString:@"-" intoString:NULL] ) {
							if( underlineStack >= 1 ) underlineStack--;
							off = YES;
						} else { // on is the default
							[scanner scanString:@"+" intoString:NULL];
							underlineStack++;
						}

						if( underlineStack == 1 && ! off )
							[ret appendString:@"<u>"];
						else if( ! underlineStack )
							[ret appendString:@"</u>"];
						break;
					case 'S': // strikethrough
						if( [scanner scanString:@"-" intoString:NULL] ) {
							if( strikeStack >= 1 ) strikeStack--;
							off = YES;
						} else { // on is the default
							[scanner scanString:@"+" intoString:NULL];
							strikeStack++;
						}

						if( strikeStack == 1 && ! off )
							[ret appendString:@"<strike>"];
						else if( ! strikeStack )
							[ret appendString:@"</strike>"];
						break;
					case 'C': { // color
						if( [message characterAtIndex:[scanner scanLocation]] == '\006' ) { // reset colors
							for( NSUInteger i = 0; i < colorStack; ++i )
								[ret appendString:@"</span>"];
							colorStack = 0;
							break;
						}

						// scan for foreground color
						NSCharacterSet *hexSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"];
						NSS*colorStr = nil;
						BOOL foundForeground = YES;
						if( [scanner scanString:@"#" intoString:NULL] ) { // rgb hex color
							if( [scanner scanCharactersFromSet:hexSet maxLength:6 intoString:&colorStr] ) {
								[ret appendFormat:@"<span style=\"color: %@;", colorStr];
							} else foundForeground = NO;
						} else if( [scanner scanCharactersFromSet:hexSet maxLength:1 intoString:&colorStr] ) { // indexed color
							NSUInteger index = [colorStr characterAtIndex:0];
							if( index >= 'A' ) index -= ( 'A' - '9' - 1 );
							index -= '0';

							NSS*foregroundColor = colorForHTML(CTCPColors[index][0], CTCPColors[index][1], CTCPColors[index][2]);
							[ret appendFormat:@"<span style=\"color: %@;", foregroundColor];
						} else if( [scanner scanString:@"." intoString:NULL] ) { // reset the foreground color
							[ret appendString:@"<span style=\"color: initial;"];
						} else if( [scanner scanString:@"-" intoString:NULL] ) { // skip the foreground color
							// Do nothing - we're skipping
							// This is so we can have an else clause that doesn't fire for @"-"
						} else {
							// Ok, no foreground color
							foundForeground = NO;
						}

						if( foundForeground ) {
							// scan for background color
							if( [scanner scanString:@"#" intoString:NULL] ) { // rgb hex color
								if( [scanner scanCharactersFromSet:hexSet maxLength:6 intoString:&colorStr] )
									[ret appendFormat:@" background-color: %@;", colorStr];
							} else if( [scanner scanCharactersFromSet:hexSet maxLength:1 intoString:&colorStr] ) { // indexed color
								NSUInteger index = [colorStr characterAtIndex:0];
								if( index >= 'A' ) index -= ( 'A' - '9' - 1 );
								index -= '0';

								NSS*backgroundColor = colorForHTML(CTCPColors[index][0], CTCPColors[index][1], CTCPColors[index][2]);
								[ret appendFormat:@" background-color: %@;", backgroundColor];
							} else if( [scanner scanString:@"." intoString:NULL] ) { // reset the background color
								[ret appendString:@" background-color: initial;"];
							} else [scanner scanString:@"-" intoString:NULL]; // skip the background color

							[ret appendString:@"\">"];

							++colorStack;
						} else {
							// No colors - treat it like ..
							for( NSUInteger i = 0; i < colorStack; ++i )
								[ret appendString:@"</span>"];
							colorStack = 0;
						}
					} case 'F': // font size
					case 'E': // encoding
						// We actually handle this above, but there could be some encoding tags
						// left over. For instance, ^FEU^F^FEU^F will leave one of the two tags behind.
					case 'K': // blinking
					case 'P': // spacing
						// not supported yet
						break;
					case 'N': // normal (reset)
						if( boldStack )
							[ret appendString:@"</b>"];
						if( italicStack )
							[ret appendString:@"</i>"];
						if( underlineStack )
							[ret appendString:@"</u>"];
						if( strikeStack )
							[ret appendString:@"</strike>"];
						for( NSUInteger i = 0; i < colorStack; ++i )
							[ret appendString:@"</span>"];

						boldStack = italicStack = underlineStack = strikeStack = colorStack = 0;
					}

					[scanner scanUpToString:@"\006" intoString:NULL];
					[scanner scanString:@"\006" intoString:NULL];
				}
			}
		}
    NSS*text = nil;
 		[scanner scanUpToCharactersFromSet:formatCharacters intoString:&text];
    if( text.length )
			[ret appendString:[text stringByEncodingXMLSpecialCharactersAsEntities]];
	}

	return [self initWithString:ret];
}
- (BOOL) isCaseInsensitiveEqualToString:(NSS*) string {
	return [self compare:string options:NSCaseInsensitiveSearch range:NSMakeRange( 0, self.length )] == NSOrderedSame;
}
- (BOOL) hasCaseInsensitivePrefix:(NSS*) prefix {
	return [self rangeOfString:prefix options:( NSCaseInsensitiveSearch | NSAnchoredSearch ) range:NSMakeRange( 0, self.length )].location != NSNotFound;
}
- (BOOL) hasCaseInsensitiveSuffix:(NSS*) suffix {
	return [self rangeOfString:suffix options:( NSCaseInsensitiveSearch | NSBackwardsSearch | NSAnchoredSearch ) range:NSMakeRange( 0, self.length )].location != NSNotFound;
}
- (BOOL) hasCaseInsensitiveSubstring:(NSS*) substring {
	return [self rangeOfString:substring options:NSCaseInsensitiveSearch range:NSMakeRange( 0, self.length )].location != NSNotFound;
}
+ (NSS*) stringByReversingString:(NSS*) normalString {
	NSMutableString *reversedString = [[NSMutableString alloc] initWithCapacity:normalString.length];

	for (NSInteger index = normalString.length - 1; index >= 0; index--)
		[reversedString appendString:[normalString substringWithRange:NSMakeRange(index, 1)]];

	return reversedString;
}
- (NSS*) stringByEncodingXMLSpecialCharactersAsEntities {
	NSCharacterSet *special = [NSCharacterSet characterSetWithCharactersInString:@"&<>\"'"];
	NSRange range = [self rangeOfCharacterFromSet:special options:NSLiteralSearch];
	if( range.location == NSNotFound )
		return self;

	NSMutableString *result = [self mutableCopy];
	[result encodeXMLSpecialCharactersAsEntities];
	return result;
}
- (NSS*) stringByDecodingXMLSpecialCharacterEntities {
	NSRange range = [self rangeOfString:@"&" options:NSLiteralSearch];
	if( range.location == NSNotFound )
		return self;

	NSMutableString *result = [self mutableCopy];
	[result decodeXMLSpecialCharacterEntities];
	return result;
}
- (NSS*) stringByEscapingCharactersInSet:(NSCharacterSet *) set {
	NSRange range = [self rangeOfCharacterFromSet:set];
	if( range.location == NSNotFound )
		return self;

	NSMutableString *result = [self mutableCopy];
	[result escapeCharactersInSet:set];
	return result;
}
- (NSS*) stringByReplacingCharactersInSet:(NSCharacterSet *) set withString:(NSS*) string {
	NSRange range = [self rangeOfCharacterFromSet:set];
	if( range.location == NSNotFound )
		return self;

	NSMutableString *result = [self mutableCopy];
	[result replaceCharactersInSet:set withString:string];
	return result;
}
- (NSS*) stringByEncodingIllegalURLCharacters {
	return (__bridge NSS*)CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)self, NULL, CFSTR( ",;:/?@&$=|^~`\{}[]" ), kCFStringEncodingUTF8 );
}
- (NSS*) stringByDecodingIllegalURLCharacters {
	return (__bridge NSS*)CFURLCreateStringByReplacingPercentEscapes( NULL, (CFStringRef)self, CFSTR( "" ) );
}
- (NSS*) stringByStrippingIllegalXMLCharacters {

	NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet illegalXMLCharacterSet]];

	if( range.location == NSNotFound )
		return self;

	NSMutableString *result = [self mutableCopy];
	[result stripIllegalXMLCharacters];
	return result;
}
- (NSS*) stringByStrippingXMLTags {
	if( [self rangeOfString:@"<"].location == NSNotFound )
		return self;

	NSMutableString *result = [self mutableCopy];
	[result stripXMLTags];
	return result;
}
- (NSS*) stringWithDomainNameSegmentOfAddress {
	NSS*ret = self;
	unsigned ip = 0;
	BOOL ipAddress = ( sscanf( [self UTF8String], "%u.%u.%u.%u", &ip, &ip, &ip, &ip ) == 4 );

	if( ! ipAddress ) {
		NSArray *parts = [self componentsSeparatedByString:@"."];
		NSUInteger count = parts.count;
		if( count > 2 )
			ret = [NSString stringWithFormat:@"%@.%@", [parts objectAtIndex:(count - 2)], [parts objectAtIndex:(count - 1)]];
	}

	return ret;
}
- (NSS*) fileName {
	NSS*fileName = [self lastPathComponent];
	NSS*fileExtension = [NSString stringWithFormat:@".%@", [self pathExtension]];

	return [fileName stringByReplacingOccurrencesOfString:fileExtension withString:@""];
}
- (NSArray *) _IRCComponents {
	NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"!@ "]];

	// given "nickname!username@hostmask realname", we want to get "nickname", "username", "hostmask" and "realname" back
	if (components.count == 3 || components.count == 4)
		return components;
	return nil;
}
- (BOOL) isValidIRCMask {
	// if we have a nickname matched, we have a valid IRC mask
	return self.IRCNickname.length;
}
- (NSS*) IRCNickname {
	return [self._IRCComponents objectAtIndex:0];
}
- (NSS*) IRCUsername {
	return [self._IRCComponents objectAtIndex:1];
}
- (NSS*) IRCHostname {
	return [self._IRCComponents objectAtIndex:2];
}
- (NSS*) IRCRealname {
	NSArray *components = self._IRCComponents;
	if (components.count == 4)
		return [components objectAtIndex:3];
	return nil;
}

static NSCharacterSet *emojiCharacters, *typicalEmoticonCharacters;

- (BOOL) containsEmojiCharacters {
	return [self containsEmojiCharactersInRange:NSMakeRange(0, self.length)];
}
- (BOOL) containsEmojiCharactersInRange:(NSRange) range {
	return ([self rangeOfEmojiCharactersInRange:range].location != NSNotFound);
}
- (NSRange) rangeOfEmojiCharactersInRange:(NSRange) range {
	if (!emojiCharacters)
		emojiCharacters = [NSCharacterSet characterSetWithRange:NSMakeRange(0xe001, (0xe53e - 0xe001))];
	return [self rangeOfCharacterFromSet:emojiCharacters options:NSLiteralSearch range:range];
}
- (BOOL) containsTypicalEmoticonCharacters {
	if (!typicalEmoticonCharacters)
		typicalEmoticonCharacters = [NSCharacterSet characterSetWithCharactersInString:@";:=-()^><_."];
	return ([self rangeOfCharacterFromSet:typicalEmoticonCharacters options:NSLiteralSearch].location != NSNotFound || [self hasCaseInsensitiveSubstring:@"XD"]);
}
- (NSS*) stringBySubstitutingEmojiForEmoticons {
	if (![self containsEmojiCharacters])
		return self;
	NSMutableString *result = [self mutableCopy];
	[result substituteEmojiForEmoticons];
	return result;
}
- (NSS*) stringBySubstitutingEmoticonsForEmoji {
	if (![self containsTypicalEmoticonCharacters])
		return self;
	NSMutableString *result = [self mutableCopy];
	[result substituteEmoticonsForEmoji];
	return result;
}
- (BOOL) isMatchedByRegex:(NSS*) regex {
	return [self isMatchedByRegex:regex options:0 inRange:NSMakeRange(0, self.length) error:nil];
}
- (BOOL) isMatchedByRegex:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range error:(NSError **) error {
	NSRegularExpression *regularExpression = [NSRegularExpression cachedRegularExpressionWithPattern:regex options:options error:error];
	NSRange foundRange = [regularExpression rangeOfFirstMatchInString:self options:NSMatchingReportCompletion range:range];
	return foundRange.location != NSNotFound;
}
- (NSRange) rangeOfRegex:(NSS*) regex inRange:(NSRange) range {
	return [self rangeOfRegex:regex options:0 inRange:range capture:0 error:nil];
}
- (NSRange) rangeOfRegex:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range capture:(NSInteger) capture error:(NSError **) error {
	NSRegularExpression *regularExpression = [NSRegularExpression cachedRegularExpressionWithPattern:regex options:options error:error];	
	NSTextCheckingResult *result = [regularExpression firstMatchInString:self options:NSMatchingReportCompletion range:range];

	NSRange foundRange = [result rangeAtIndex:capture];
	if (!(foundRange.location + foundRange.length))
		return NSMakeRange(NSNotFound, 0); // work around iOS 5/NSRegularExpression bug where it doesn't return NSNotFound when not found
	return foundRange;
}
- (NSS*) stringByMatching:(NSS*) regex capture:(NSInteger) capture {
	return [self stringByMatching:regex options:0 inRange:NSMakeRange(0, self.length) capture:capture error:nil];
}
- (NSS*) stringByMatching:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range capture:(NSInteger) capture error:(NSError **) error {
	NSRegularExpression *regularExpression = [NSRegularExpression cachedRegularExpressionWithPattern:regex options:options error:error];
	NSTextCheckingResult *result = [regularExpression firstMatchInString:self options:NSMatchingReportCompletion range:range];

	NSRange resultRange = [result rangeAtIndex:capture];

	if (resultRange.location == NSNotFound)
		return nil;

	return [self substringWithRange:resultRange];
}
- (NSArray *) captureComponentsMatchedByRegex:(NSS*) regex options:(NSRegularExpressionOptions) options range:(NSRange) range error:(NSError **) error {
	NSRegularExpression *regularExpression = [NSRegularExpression cachedRegularExpressionWithPattern:regex options:options error:error];
	NSTextCheckingResult *result = [regularExpression firstMatchInString:self options:NSMatchingReportCompletion range:range];

	if (!result)
		return nil;

	NSMutableArray *results = [NSMutableArray array];

	for (NSUInteger i = 1; i < (result.numberOfRanges - 1); i++)
		[results addObject:[self substringWithRange:[result rangeAtIndex:i]]];

	return [results copy];
}
- (NSS*) stringByReplacingOccurrencesOfRegex:(NSS*) regex withString:(NSS*) replacement {
	return [self stringByReplacingOccurrencesOfRegex:regex withString:replacement options:0 range:NSMakeRange(0, self.length) error:nil];
}
- (NSS*) stringByReplacingOccurrencesOfRegex:(NSS*) regex withString:(NSS*) replacement options:(NSRegularExpressionOptions) options range:(NSRange) searchRange error:(NSError **) error {
	NSRegularExpression *regularExpression = [NSRegularExpression cachedRegularExpressionWithPattern:regex options:options error:error];
	NSMutableString *replacementString = [self mutableCopy];

	for (NSTextCheckingResult *result in [regularExpression matchesInString:self options:optind range:searchRange]) {
		if (result.range.location == NSNotFound)
			break; 

		[replacementString replaceCharactersInRange:result.range withString:replacement];
	}

	return replacementString;
}
- (NSUInteger) levenshteinDistanceFromString:(NSS*) string {
	return levenshteinDistanceBetweenStrings((char *)[[self lowercaseString] UTF8String], (char *)[[string lowercaseString] UTF8String]);
}
@end

@implementation NSMutableString (NSMutableStringAdditions)
- (void) encodeXMLSpecialCharactersAsEntities         {
	NSCharacterSet *special = [NSCharacterSet characterSetWithCharactersInString:@"&<>\"'"];
	NSRange range = [self rangeOfCharacterFromSet:special options:NSLiteralSearch];
	if( range.location == NSNotFound )
		return;

	[self replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
	[self replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
	[self replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
	[self replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
	[self replaceOccurrencesOfString:@"'" withString:@"&apos;" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
}
- (void) decodeXMLSpecialCharacterEntities            {
	NSRange range = [self rangeOfString:@"&" options:NSLiteralSearch];
	if( range.location == NSNotFound )
		return;

	[self replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
	[self replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
	[self replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
	[self replaceOccurrencesOfString:@"&apos;" withString:@"'" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
	[self replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange( 0, self.length )];
}
- (void) escapeCharactersInSet:(NSCharacterSet*)set   {
	NSRange range = [self rangeOfCharacterFromSet:set];
	if( range.location == NSNotFound )
		return;

	NSScanner *scanner = [[NSScanner alloc] initWithString:self];

	NSUInteger offset = 0;
	while( ! [scanner isAtEnd] ) {
		[scanner scanUpToCharactersFromSet:set intoString:nil];
		if( ! [scanner isAtEnd] ) {
			[self insertString:@"\\" atIndex:[scanner scanLocation] + offset++];
			[scanner setScanLocation:[scanner scanLocation] + 1];
		}
	}
}
- (void) replaceCharactersInSet:(NSCharacterSet*)set withString:(NSString*)string {
	NSRange range = NSMakeRange(0, self.length);
	NSUInteger stringLength = string.length;

	NSRange replaceRange;
	while( ( replaceRange = [self rangeOfCharacterFromSet:set options:NSLiteralSearch range:range] ).location != NSNotFound ) {
		[self replaceCharactersInRange:replaceRange withString:string];

		range.location = replaceRange.location + stringLength;
		range.length = self.length - replaceRange.location;
	}
}
- (void) encodeIllegalURLCharacters {
	[self setString:[self stringByEncodingIllegalURLCharacters]];
}
- (void) decodeIllegalURLCharacters {
	[self setString:[self stringByDecodingIllegalURLCharacters]];
}
- (void) stripIllegalXMLCharacters  {
	NSCharacterSet *illegalSet = [NSCharacterSet illegalXMLCharacterSet];
	NSRange range = [self rangeOfCharacterFromSet:illegalSet];
	while( range.location != NSNotFound ) {
		[self deleteCharactersInRange:range];
		range = [self rangeOfCharacterFromSet:illegalSet];
	}
}
- (void) stripXMLTags {
	NSRange searchRange = NSMakeRange(0, self.length);
	while (1) {
		NSRange tagStartRange = [self rangeOfString:@"<" options:NSLiteralSearch range:searchRange];
		if (tagStartRange.location == NSNotFound)
			break;

		NSRange tagEndRange = [self rangeOfString:@">" options:NSLiteralSearch range:NSMakeRange(tagStartRange.location, (self.length - tagStartRange.location))];
		if (tagEndRange.location == NSNotFound)
			break;

		[self deleteCharactersInRange:NSMakeRange(tagStartRange.location, (NSMaxRange(tagEndRange) - tagStartRange.location))];

		searchRange = NSMakeRange(tagStartRange.location, (self.length - tagStartRange.location));
	}
}
- (void) substituteEmoticonsForEmoji {
	NSRange range = NSMakeRange(0, self.length);
	[self substituteEmoticonsForEmojiInRange:&range];
}
- (void) substituteEmoticonsForEmojiInRange:(NSRangePointer) range {
	[self substituteEmoticonsForEmojiInRange:range withXMLSpecialCharactersEncodedAsEntities:NO];
}
- (void) substituteEmoticonsForEmojiInRange:(NSRangePointer) range withXMLSpecialCharactersEncodedAsEntities:(BOOL) encoded {
	if (![self containsTypicalEmoticonCharacters])
		return;

	NSCharacterSet *escapedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"^[]{}()\\.$*+?|"];
	for (const struct EmojiEmoticonPair *entry = emoticonToEmojiList; entry && entry->emoticon; ++entry) {
		NSS*searchEmoticon = objc_unretainedObject(entry->emoticon);
		if (encoded) searchEmoticon = [searchEmoticon stringByEncodingXMLSpecialCharactersAsEntities];
		if ([self rangeOfString:searchEmoticon options:NSLiteralSearch range:*range].location == NSNotFound)
			continue;

		NSMutableString *emoticon = [searchEmoticon mutableCopy];
		[emoticon escapeCharactersInSet:escapedCharacters];

		NSS*emojiString = [[NSString alloc] initWithCharacters:&entry->emoji length:1];
		NSS*searchRegex = [[NSString alloc] initWithFormat:@"(?<=\\s|^|[\ue001-\ue53e])%@(?=\\s|$|[\ue001-\ue53e])", emoticon];

		NSRange matchedRange = [self rangeOfRegex:searchRegex inRange:*range];
		while (matchedRange.location != NSNotFound) {
			[self replaceCharactersInRange:matchedRange withString:emojiString];
			range->length += (1 - matchedRange.length);

			NSRange matchRange = NSMakeRange(matchedRange.location + 1, (NSMaxRange(*range) - matchedRange.location - 1));
			if (!matchRange.length)
				break;

			matchedRange = [self rangeOfRegex:searchRegex inRange:matchRange];
		}

		// Check for the typical characters again, if none are found then there are no more emoticons to replace.
		if ([self rangeOfCharacterFromSet:typicalEmoticonCharacters].location == NSNotFound)
			break;
	}
}
- (void) substituteEmojiForEmoticons {
	NSRange range = NSMakeRange(0, self.length);
	[self substituteEmojiForEmoticonsInRange:&range encodeXMLSpecialCharactersAsEntities:NO];
}
- (void) substituteEmojiForEmoticonsInRange:(NSRangePointer) range {
	[self substituteEmojiForEmoticonsInRange:range encodeXMLSpecialCharactersAsEntities:NO];
}
- (void) substituteEmojiForEmoticonsInRange:(NSRangePointer) range encodeXMLSpecialCharactersAsEntities:(BOOL) encode {
	NSRange emojiRange = [self rangeOfEmojiCharactersInRange:*range];
	while (emojiRange.location != NSNotFound) {
		unichar currentCharacter = [self characterAtIndex:emojiRange.location];
		for (const struct EmojiEmoticonPair *entry = emojiToEmoticonList; entry && entry->emoji; ++entry) {
			if (entry->emoji == currentCharacter) {
				NSS*emoticon = objc_unretainedObject(entry->emoticon);
				if (encode) emoticon = [emoticon stringByEncodingXMLSpecialCharactersAsEntities];

				NSS*replacement = nil;
				if (emojiRange.location == 0 && (emojiRange.location + 1) == self.length)
					replacement = emoticon;
				else if (emojiRange.location > 0 && (emojiRange.location + 1) == self.length && [self characterAtIndex:(emojiRange.location - 1)] == ' ')
					replacement = emoticon;
				else if ([self characterAtIndex:(emojiRange.location - 1)] == ' ' || ((emojiRange.location + 1) < self.length && [self characterAtIndex:(emojiRange.location + 1)] == ' '))
					replacement = emoticon;
				else if (emojiRange.location == 0 || [self characterAtIndex:(emojiRange.location - 1)] == ' ')
					replacement = [[NSString alloc] initWithFormat:@"%@ ", emoticon];
				else if ((emojiRange.location + 1) == self.length || [self characterAtIndex:(emojiRange.location + 1)] == ' ')
					replacement = [[NSString alloc] initWithFormat:@" %@", emoticon];
				else replacement = [[NSString alloc] initWithFormat:@" %@ ", emoticon];

				[self replaceCharactersInRange:NSMakeRange(emojiRange.location, 1) withString:replacement];

				range->length += (replacement.length - 1);
				break;
			}
		}

		if (emojiRange.location >= NSMaxRange(*range))
			return;

		emojiRange = [self rangeOfEmojiCharactersInRange:NSMakeRange(emojiRange.location + 1, (NSMaxRange(*range) - emojiRange.location - 1))];
	}
}
@end

@implementation NSScanner (NSScannerAdditions)
- (BOOL) scanCharactersFromSet:(NSCharacterSet *) scanSet maxLength:(NSUInteger) maxLength intoString:(NSS**) stringValue {
	if( ! [self isAtEnd] ) {
		NSUInteger location = [self scanLocation];
		NSS*source = [self string];
		NSUInteger length = MIN( maxLength, source.length - location );
		if( length > 0 ) {
			unichar *chars = calloc( length, sizeof( unichar ) );
			[source getCharacters:chars range:NSMakeRange( location, length )];

			NSUInteger i = 0;
			for( i = 0; i < length && [scanSet characterIsMember:chars[i]]; i++ );

			free( chars );

			if( i > 0 ) {
				if( stringValue )
					*stringValue = [source substringWithRange:NSMakeRange( location, i )];
				[self setScanLocation:( location + i )];
				return YES;
			}
		}
	}

	return NO;
}
@end


//
//  IRFEmojiCheatSheet.m
//  IRFEmojiCheatSheet
//
//  Created by Fabio Pelosin on 08/11/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

@implementation Emoji

+ (NSArray*)groups {
    static NSArray *groups;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        groups = @[
             @"People",
             @"Nature",
             @"Objects",
             @"Places",
             @"Symbols",
             ];
    });
    return groups;
}

+ (NSDictionary*)byGroups {
    static NSDictionary *_emojiByGroups;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emojiByGroups = @{
                          @"People": @[
                                  @"bowtie",
                                  @"smile",
                                  @"laughing",
                                  @"blush",
                                  @"smiley",
                                  @"relaxed",
                                  @"smirk",
                                  @"heart_eyes",
                                  @"kissing_heart",
                                  @"kissing_closed_eyes",
                                  @"flushed",
                                  @"relieved",
                                  @"satisfied",
                                  @"grin",
                                  @"wink",
                                  @"stuck_out_tongue_winking_eye",
                                  @"stuck_out_tongue_closed_eyes",
                                  @"grinning",
                                  @"kissing",
                                  @"kissing_smiling_eyes",
                                  @"stuck_out_tongue",
                                  @"sleeping",
                                  @"worried",
                                  @"frowning",
                                  @"anguished",
                                  @"open_mouth",
                                  @"grimacing",
                                  @"confused",
                                  @"hushed",
                                  @"expressionless",
                                  @"unamused",
                                  @"sweat_smile",
                                  @"sweat",
                                  @"disappointed_relieved",
                                  @"weary",
                                  @"pensive",
                                  @"disappointed",
                                  @"confounded",
                                  @"fearful",
                                  @"cold_sweat",
                                  @"persevere",
                                  @"cry",
                                  @"sob",
                                  @"joy",
                                  @"astonished",
                                  @"scream",
                                  @"neckbeard",
                                  @"tired_face",
                                  @"angry",
                                  @"rage",
                                  @"triumph",
                                  @"sleepy",
                                  @"yum",
                                  @"mask",
                                  @"sunglasses",
                                  @"dizzy_face",
                                  @"imp",
                                  @"smiling_imp",
                                  @"neutral_face",
                                  @"no_mouth",
                                  @"innocent",
                                  @"alien",
                                  @"yellow_heart",
                                  @"blue_heart",
                                  @"purple_heart",
                                  @"heart",
                                  @"green_heart",
                                  @"broken_heart",
                                  @"heartbeat",
                                  @"heartpulse",
                                  @"two_hearts",
                                  @"revolving_hearts",
                                  @"cupid",
                                  @"sparkling_heart",
                                  @"sparkles",
                                  @"star",
                                  @"star2",
                                  @"dizzy",
                                  @"boom",
                                  @"collision",
                                  @"anger",
                                  @"exclamation",
                                  @"question",
                                  @"grey_exclamation",
                                  @"grey_question",
                                  @"zzz",
                                  @"dash",
                                  @"sweat_drops",
                                  @"notes",
                                  @"musical_note",
                                  @"fire",
                                  @"hankey",
                                  @"poop",
                                  @"shit",
                                  @"+1",
                                  @"thumbsup",
                                  @"-1",
                                  @"thumbsdown",
                                  @"ok_hand",
                                  @"punch",
                                  @"facepunch",
                                  @"fist",
                                  @"v",
                                  @"wave",
                                  @"hand",
                                  @"raised_hand",
                                  @"open_hands",
                                  @"point_up",
                                  @"point_down",
                                  @"point_left",
                                  @"point_right",
                                  @"raised_hands",
                                  @"pray",
                                  @"point_up_2",
                                  @"clap",
                                  @"muscle",
                                  @"metal",
                                  @"fu",
                                  @"walking",
                                  @"runner",
                                  @"running",
                                  @"couple",
                                  @"family",
                                  @"two_men_holding_hands",
                                  @"two_women_holding_hands",
                                  @"dancer",
                                  @"dancers",
                                  @"ok_woman",
                                  @"no_good",
                                  @"information_desk_person",
                                  @"raising_hand",
                                  @"bride_with_veil",
                                  @"person_with_pouting_face",
                                  @"person_frowning",
                                  @"bow",
                                  @"couplekiss",
                                  @"couple_with_heart",
                                  @"massage",
                                  @"haircut",
                                  @"nail_care",
                                  @"boy",
                                  @"girl",
                                  @"woman",
                                  @"man",
                                  @"baby",
                                  @"older_woman",
                                  @"older_man",
                                  @"person_with_blond_hair",
                                  @"man_with_gua_pi_mao",
                                  @"man_with_turban",
                                  @"construction_worker",
                                  @"cop",
                                  @"angel",
                                  @"princess",
                                  @"smiley_cat",
                                  @"smile_cat",
                                  @"heart_eyes_cat",
                                  @"kissing_cat",
                                  @"smirk_cat",
                                  @"scream_cat",
                                  @"crying_cat_face",
                                  @"joy_cat",
                                  @"pouting_cat",
                                  @"japanese_ogre",
                                  @"japanese_goblin",
                                  @"see_no_evil",
                                  @"hear_no_evil",
                                  @"speak_no_evil",
                                  @"guardsman",
                                  @"skull",
                                  @"feet",
                                  @"lips",
                                  @"kiss",
                                  @"droplet",
                                  @"ear",
                                  @"eyes",
                                  @"nose",
                                  @"tongue",
                                  @"love_letter",
                                  @"bust_in_silhouette",
                                  @"busts_in_silhouette",
                                  @"speech_balloon",
                                  @"thought_balloon",
                                  @"feelsgood",
                                  @"finnadie",
                                  @"goberserk",
                                  @"godmode",
                                  @"hurtrealbad",
                                  @"rage1",
                                  @"rage2",
                                  @"rage3",
                                  @"rage4",
                                  @"suspect",
                                  @"trollface",
                                  ],

                          @"Nature": @[
                                  @"sunny",
                                  @"umbrella",
                                  @"cloud",
                                  @"snowflake",
                                  @"snowman",
                                  @"zap",
                                  @"cyclone",
                                  @"foggy",
                                  @"ocean",
                                  @"cat",
                                  @"dog",
                                  @"mouse",
                                  @"hamster",
                                  @"rabbit",
                                  @"wolf",
                                  @"frog",
                                  @"tiger",
                                  @"koala",
                                  @"bear",
                                  @"pig",
                                  @"pig_nose",
                                  @"cow",
                                  @"boar",
                                  @"monkey_face",
                                  @"monkey",
                                  @"horse",
                                  @"racehorse",
                                  @"camel",
                                  @"sheep",
                                  @"elephant",
                                  @"panda_face",
                                  @"snake",
                                  @"bird",
                                  @"baby_chick",
                                  @"hatched_chick",
                                  @"hatching_chick",
                                  @"chicken",
                                  @"penguin",
                                  @"turtle",
                                  @"bug",
                                  @"honeybee",
                                  @"ant",
                                  @"beetle",
                                  @"snail",
                                  @"octopus",
                                  @"tropical_fish",
                                  @"fish",
                                  @"whale",
                                  @"whale2",
                                  @"dolphin",
                                  @"cow2",
                                  @"ram",
                                  @"rat",
                                  @"water_buffalo",
                                  @"tiger2",
                                  @"rabbit2",
                                  @"dragon",
                                  @"goat",
                                  @"rooster",
                                  @"dog2",
                                  @"pig2",
                                  @"mouse2",
                                  @"ox",
                                  @"dragon_face",
                                  @"blowfish",
                                  @"crocodile",
                                  @"dromedary_camel",
                                  @"leopard",
                                  @"cat2",
                                  @"poodle",
                                  @"paw_prints",
                                  @"bouquet",
                                  @"cherry_blossom",
                                  @"tulip",
                                  @"four_leaf_clover",
                                  @"rose",
                                  @"sunflower",
                                  @"hibiscus",
                                  @"maple_leaf",
                                  @"leaves",
                                  @"fallen_leaf",
                                  @"herb",
                                  @"mushroom",
                                  @"cactus",
                                  @"palm_tree",
                                  @"evergreen_tree",
                                  @"deciduous_tree",
                                  @"chestnut",
                                  @"seedling",
                                  @"blossom",
                                  @"ear_of_rice",
                                  @"shell",
                                  @"globe_with_meridians",
                                  @"sun_with_face",
                                  @"full_moon_with_face",
                                  @"new_moon_with_face",
                                  @"new_moon",
                                  @"waxing_crescent_moon",
                                  @"first_quarter_moon",
                                  @"waxing_gibbous_moon",
                                  @"full_moon",
                                  @"waning_gibbous_moon",
                                  @"last_quarter_moon",
                                  @"waning_crescent_moon",
                                  @"last_quarter_moon_with_face",
                                  @"first_quarter_moon_with_face",
                                  @"moon",
                                  @"earth_africa",
                                  @"earth_americas",
                                  @"earth_asia",
                                  @"volcano",
                                  @"milky_way",
                                  @"partly_sunny",
                                  @"octocat",
                                  @"squirrel",
                                  ],

                          @"Objects": @[
                                  @"bamboo",
                                  @"gift_heart",
                                  @"dolls",
                                  @"school_satchel",
                                  @"mortar_board",
                                  @"flags",
                                  @"fireworks",
                                  @"sparkler",
                                  @"wind_chime",
                                  @"rice_scene",
                                  @"jack_o_lantern",
                                  @"ghost",
                                  @"santa",
                                  @"christmas_tree",
                                  @"gift",
                                  @"bell",
                                  @"no_bell",
                                  @"tanabata_tree",
                                  @"tada",
                                  @"confetti_ball",
                                  @"balloon",
                                  @"crystal_ball",
                                  @"cd",
                                  @"dvd",
                                  @"floppy_disk",
                                  @"camera",
                                  @"video_camera",
                                  @"movie_camera",
                                  @"computer",
                                  @"tv",
                                  @"iphone",
                                  @"phone",
                                  @"telephone",
                                  @"telephone_receiver",
                                  @"pager",
                                  @"fax",
                                  @"minidisc",
                                  @"vhs",
                                  @"sound",
                                  @"speaker",
                                  @"mute",
                                  @"loudspeaker",
                                  @"mega",
                                  @"hourglass",
                                  @"hourglass_flowing_sand",
                                  @"alarm_clock",
                                  @"watch",
                                  @"radio",
                                  @"satellite",
                                  @"loop",
                                  @"mag",
                                  @"mag_right",
                                  @"unlock",
                                  @"lock",
                                  @"lock_with_ink_pen",
                                  @"closed_lock_with_key",
                                  @"key",
                                  @"bulb",
                                  @"flashlight",
                                  @"high_brightness",
                                  @"low_brightness",
                                  @"electric_plug",
                                  @"battery",
                                  @"calling",
                                  @"email",
                                  @"mailbox",
                                  @"postbox",
                                  @"bath",
                                  @"bathtub",
                                  @"shower",
                                  @"toilet",
                                  @"wrench",
                                  @"nut_and_bolt",
                                  @"hammer",
                                  @"seat",
                                  @"moneybag",
                                  @"yen",
                                  @"dollar",
                                  @"pound",
                                  @"euro",
                                  @"credit_card",
                                  @"money_with_wings",
                                  @"e-mail",
                                  @"inbox_tray",
                                  @"outbox_tray",
                                  @"envelope",
                                  @"incoming_envelope",
                                  @"postal_horn",
                                  @"mailbox_closed",
                                  @"mailbox_with_mail",
                                  @"mailbox_with_no_mail",
                                  @"door",
                                  @"smoking",
                                  @"bomb",
                                  @"gun",
                                  @"hocho",
                                  @"pill",
                                  @"syringe",
                                  @"page_facing_up",
                                  @"page_with_curl",
                                  @"bookmark_tabs",
                                  @"bar_chart",
                                  @"chart_with_upwards_trend",
                                  @"chart_with_downwards_trend",
                                  @"scroll",
                                  @"clipboard",
                                  @"calendar",
                                  @"date",
                                  @"card_index",
                                  @"file_folder",
                                  @"open_file_folder",
                                  @"scissors",
                                  @"pushpin",
                                  @"paperclip",
                                  @"black_nib",
                                  @"pencil2",
                                  @"straight_ruler",
                                  @"triangular_ruler",
                                  @"closed_book",
                                  @"green_book",
                                  @"blue_book",
                                  @"orange_book",
                                  @"notebook",
                                  @"notebook_with_decorative_cover",
                                  @"ledger",
                                  @"books",
                                  @"bookmark",
                                  @"name_badge",
                                  @"microscope",
                                  @"telescope",
                                  @"newspaper",
                                  @"football",
                                  @"basketball",
                                  @"soccer",
                                  @"baseball",
                                  @"tennis",
                                  @"8ball",
                                  @"rugby_football",
                                  @"bowling",
                                  @"golf",
                                  @"mountain_bicyclist",
                                  @"bicyclist",
                                  @"horse_racing",
                                  @"snowboarder",
                                  @"swimmer",
                                  @"surfer",
                                  @"ski",
                                  @"spades",
                                  @"hearts",
                                  @"clubs",
                                  @"diamonds",
                                  @"gem",
                                  @"ring",
                                  @"trophy",
                                  @"musical_score",
                                  @"musical_keyboard",
                                  @"violin",
                                  @"space_invader",
                                  @"video_game",
                                  @"black_joker",
                                  @"flower_playing_cards",
                                  @"game_die",
                                  @"dart",
                                  @"mahjong",
                                  @"clapper",
                                  @"memo",
                                  @"pencil",
                                  @"book",
                                  @"art",
                                  @"microphone",
                                  @"headphones",
                                  @"trumpet",
                                  @"saxophone",
                                  @"guitar",
                                  @"shoe",
                                  @"sandal",
                                  @"high_heel",
                                  @"lipstick",
                                  @"boot",
                                  @"shirt",
                                  @"tshirt",
                                  @"necktie",
                                  @"womans_clothes",
                                  @"dress",
                                  @"running_shirt_with_sash",
                                  @"jeans",
                                  @"kimono",
                                  @"bikini",
                                  @"ribbon",
                                  @"tophat",
                                  @"crown",
                                  @"womans_hat",
                                  @"mans_shoe",
                                  @"closed_umbrella",
                                  @"briefcase",
                                  @"handbag",
                                  @"pouch",
                                  @"purse",
                                  @"eyeglasses",
                                  @"fishing_pole_and_fish",
                                  @"coffee",
                                  @"tea",
                                  @"sake",
                                  @"baby_bottle",
                                  @"beer",
                                  @"beers",
                                  @"cocktail",
                                  @"tropical_drink",
                                  @"wine_glass",
                                  @"fork_and_knife",
                                  @"pizza",
                                  @"hamburger",
                                  @"fries",
                                  @"poultry_leg",
                                  @"meat_on_bone",
                                  @"spaghetti",
                                  @"curry",
                                  @"fried_shrimp",
                                  @"bento",
                                  @"sushi",
                                  @"fish_cake",
                                  @"rice_ball",
                                  @"rice_cracker",
                                  @"rice",
                                  @"ramen",
                                  @"stew",
                                  @"oden",
                                  @"dango",
                                  @"egg",
                                  @"bread",
                                  @"doughnut",
                                  @"custard",
                                  @"icecream",
                                  @"ice_cream",
                                  @"shaved_ice",
                                  @"birthday",
                                  @"cake",
                                  @"cookie",
                                  @"chocolate_bar",
                                  @"candy",
                                  @"lollipop",
                                  @"honey_pot",
                                  @"apple",
                                  @"green_apple",
                                  @"tangerine",
                                  @"lemon",
                                  @"cherries",
                                  @"grapes",
                                  @"watermelon",
                                  @"strawberry",
                                  @"peach",
                                  @"melon",
                                  @"banana",
                                  @"pear",
                                  @"pineapple",
                                  @"sweet_potato",
                                  @"eggplant",
                                  @"tomato",
                                  @"corn",
                                  ],
                          @"Places": @[
                                  @"house",
                                  @"house_with_garden",
                                  @"school",
                                  @"office",
                                  @"post_office",
                                  @"hospital",
                                  @"bank",
                                  @"convenience_store",
                                  @"love_hotel",
                                  @"hotel",
                                  @"wedding",
                                  @"church",
                                  @"department_store",
                                  @"european_post_office",
                                  @"city_sunrise",
                                  @"city_sunset",
                                  @"japanese_castle",
                                  @"european_castle",
                                  @"tent",
                                  @"factory",
                                  @"tokyo_tower",
                                  @"japan",
                                  @"mount_fuji",
                                  @"sunrise_over_mountains",
                                  @"sunrise",
                                  @"stars",
                                  @"statue_of_liberty",
                                  @"bridge_at_night",
                                  @"carousel_horse",
                                  @"rainbow",
                                  @"ferris_wheel",
                                  @"fountain",
                                  @"roller_coaster",
                                  @"ship",
                                  @"speedboat",
                                  @"boat",
                                  @"sailboat",
                                  @"rowboat",
                                  @"anchor",
                                  @"rocket",
                                  @"airplane",
                                  @"helicopter",
                                  @"steam_locomotive",
                                  @"tram",
                                  @"mountain_railway",
                                  @"bike",
                                  @"aerial_tramway",
                                  @"suspension_railway",
                                  @"mountain_cableway",
                                  @"tractor",
                                  @"blue_car",
                                  @"oncoming_automobile",
                                  @"car",
                                  @"red_car",
                                  @"taxi",
                                  @"oncoming_taxi",
                                  @"articulated_lorry",
                                  @"bus",
                                  @"oncoming_bus",
                                  @"rotating_light",
                                  @"police_car",
                                  @"oncoming_police_car",
                                  @"fire_engine",
                                  @"ambulance",
                                  @"minibus",
                                  @"truck",
                                  @"train",
                                  @"station",
                                  @"train2",
                                  @"bullettrain_front",
                                  @"bullettrain_side",
                                  @"light_rail",
                                  @"monorail",
                                  @"railway_car",
                                  @"trolleybus",
                                  @"ticket",
                                  @"fuelpump",
                                  @"vertical_traffic_light",
                                  @"traffic_light",
                                  @"warning",
                                  @"construction",
                                  @"beginner",
                                  @"atm",
                                  @"slot_machine",
                                  @"busstop",
                                  @"barber",
                                  @"hotsprings",
                                  @"checkered_flag",
                                  @"crossed_flags",
                                  @"izakaya_lantern",
                                  @"moyai",
                                  @"circus_tent",
                                  @"performing_arts",
                                  @"round_pushpin",
                                  @"triangular_flag_on_post",
                                  @"jp",
                                  @"kr",
                                  @"cn",
                                  @"us",
                                  @"fr",
                                  @"es",
                                  @"it",
                                  @"ru",
                                  @"gb",
                                  @"uk",
                                  @"de",
                                  ],

                          @"Symbols": @[
                                  @"one",
                                  @"two",
                                  @"three",
                                  @"four",
                                  @"five",
                                  @"six",
                                  @"seven",
                                  @"eight",
                                  @"nine",
                                  @"keycap_ten",
                                  @"1234",
                                  @"zero",
                                  @"hash",
                                  @"symbols",
                                  @"arrow_backward",
                                  @"arrow_down",
                                  @"arrow_forward",
                                  @"arrow_left",
                                  @"capital_abcd",
                                  @"abcd",
                                  @"abc",
                                  @"arrow_lower_left",
                                  @"arrow_lower_right",
                                  @"arrow_right",
                                  @"arrow_up",
                                  @"arrow_upper_left",
                                  @"arrow_upper_right",
                                  @"arrow_double_down",
                                  @"arrow_double_up",
                                  @"arrow_down_small",
                                  @"arrow_heading_down",
                                  @"arrow_heading_up",
                                  @"leftwards_arrow_with_hook",
                                  @"arrow_right_hook",
                                  @"left_right_arrow",
                                  @"arrow_up_down",
                                  @"arrow_up_small",
                                  @"arrows_clockwise",
                                  @"arrows_counterclockwise",
                                  @"rewind",
                                  @"fast_forward",
                                  @"information_source",
                                  @"ok",
                                  @"twisted_rightwards_arrows",
                                  @"repeat",
                                  @"repeat_one",
                                  @"new",
                                  @"top",
                                  @"up",
                                  @"cool",
                                  @"free",
                                  @"ng",
                                  @"cinema",
                                  @"koko",
                                  @"signal_strength",
                                  @"u5272",
                                  @"u5408",
                                  @"u55b6",
                                  @"u6307",
                                  @"u6708",
                                  @"u6709",
                                  @"u6e80",
                                  @"u7121",
                                  @"u7533",
                                  @"u7a7a",
                                  @"u7981",
                                  @"sa",
                                  @"restroom",
                                  @"mens",
                                  @"womens",
                                  @"baby_symbol",
                                  @"no_smoking",
                                  @"parking",
                                  @"wheelchair",
                                  @"metro",
                                  @"baggage_claim",
                                  @"accept",
                                  @"wc",
                                  @"potable_water",
                                  @"put_litter_in_its_place",
                                  @"secret",
                                  @"congratulations",
                                  @"m",
                                  @"passport_control",
                                  @"left_luggage",
                                  @"customs",
                                  @"ideograph_advantage",
                                  @"cl",
                                  @"sos",
                                  @"id",
                                  @"no_entry_sign",
                                  @"underage",
                                  @"no_mobile_phones",
                                  @"do_not_litter",
                                  @"non-potable_water",
                                  @"no_bicycles",
                                  @"no_pedestrians",
                                  @"children_crossing",
                                  @"no_entry",
                                  @"eight_spoked_asterisk",
                                  @"eight_pointed_black_star",
                                  @"heart_decoration",
                                  @"vs",
                                  @"vibration_mode",
                                  @"mobile_phone_off",
                                  @"chart",
                                  @"currency_exchange",
                                  @"aries",
                                  @"taurus",
                                  @"gemini",
                                  @"cancer",
                                  @"leo",
                                  @"virgo",
                                  @"libra",
                                  @"scorpius",
                                  @"sagittarius",
                                  @"capricorn",
                                  @"aquarius",
                                  @"pisces",
                                  @"ophiuchus",
                                  @"six_pointed_star",
                                  @"negative_squared_cross_mark",
                                  @"a",
                                  @"b",
                                  @"ab",
                                  @"o2",
                                  @"diamond_shape_with_a_dot_inside",
                                  @"recycle",
                                  @"end",
                                  @"on",
                                  @"soon",
                                  @"clock1",
                                  @"clock130",
                                  @"clock10",
                                  @"clock1030",
                                  @"clock11",
                                  @"clock1130",
                                  @"clock12",
                                  @"clock1230",
                                  @"clock2",
                                  @"clock230",
                                  @"clock3",
                                  @"clock330",
                                  @"clock4",
                                  @"clock430",
                                  @"clock5",
                                  @"clock530",
                                  @"clock6",
                                  @"clock630",
                                  @"clock7",
                                  @"clock730",
                                  @"clock8",
                                  @"clock830",
                                  @"clock9",
                                  @"clock930",
                                  @"heavy_dollar_sign",
                                  @"copyright",
                                  @"registered",
                                  @"tm",
                                  @"x",
                                  @"heavy_exclamation_mark",
                                  @"bangbang",
                                  @"interrobang",
                                  @"o",
                                  @"heavy_multiplication_x",
                                  @"heavy_plus_sign",
                                  @"heavy_minus_sign",
                                  @"heavy_division_sign",
                                  @"white_flower",
                                  @"100",
                                  @"heavy_check_mark",
                                  @"ballot_box_with_check",
                                  @"radio_button",
                                  @"link",
                                  @"curly_loop",
                                  @"wavy_dash",
                                  @"part_alternation_mark",
                                  @"trident",
                                  @"black_square",
                                  @"white_square",
                                  @"white_check_mark",
                                  @"black_square_button",
                                  @"white_square_button",
                                  @"black_circle",
                                  @"white_circle",
                                  @"red_circle",
                                  @"large_blue_circle",
                                  @"large_blue_diamond",
                                  @"large_orange_diamond",
                                  @"small_blue_diamond",
                                  @"small_orange_diamond",
                                  @"small_red_triangle",
                                  @"small_red_triangle_down",
                                  @"shipit",
                                  ],
                          };
    });
    return _emojiByGroups;
}

// List derived from [NSStringEmojize](https://github.com/diy/NSStringEmojize)
// Copyright 2012 DIY, Co. - Available under the Apache License, Version 2.0
//
+ (NSDictionary *)byAlias {
    static NSDictionary *_emojisByAlias;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emojisByAlias = @{@"+1"                                : @"\U0001F44D",
                          @"-1"                                : @"\U0001F44E",
                          @"100"                               : @"\U0001F4AF",
                          @"1234"                              : @"\U0001F522",
                          @"8ball"                             : @"\U0001F3B1",
                          @"a"                                 : @"\U0001F170",
                          @"ab"                                : @"\U0001F18E",
                          @"abc"                               : @"\U0001F524",
                          @"abcd"                              : @"\U0001F521",
                          @"accept"                            : @"\U0001F251",
                          @"aerial_tramway"                    : @"\U0001F6A1",
                          @"airplane"                          : @"\U00002708",
                          @"alarm_clock"                       : @"\U000023F0",
                          @"alien"                             : @"\U0001F47D",
                          @"ambulance"                         : @"\U0001F691",
                          @"anchor"                            : @"\U00002693",
                          @"angel"                             : @"\U0001F47C",
                          @"anger"                             : @"\U0001F4A2",
                          @"angry"                             : @"\U0001F620",
                          @"anguished"                         : @"\U0001F627",
                          @"ant"                               : @"\U0001F41C",
                          @"apple"                             : @"\U0001F34E",
                          @"aquarius"                          : @"\U00002652",
                          @"aries"                             : @"\U00002648",
                          @"arrow_backward"                    : @"\U000025C0",
                          @"arrow_double_down"                 : @"\U000023EC",
                          @"arrow_double_up"                   : @"\U000023EB",
                          @"arrow_down"                        : @"\U00002B07",
                          @"arrow_down_small"                  : @"\U0001F53D",
                          @"arrow_forward"                     : @"\U000025B6",
                          @"arrow_heading_down"                : @"\U00002935",
                          @"arrow_heading_up"                  : @"\U00002934",
                          @"arrow_left"                        : @"\U00002B05",
                          @"arrow_lower_left"                  : @"\U00002199",
                          @"arrow_lower_right"                 : @"\U00002198",
                          @"arrow_right"                       : @"\U000027A1",
                          @"arrow_right_hook"                  : @"\U000021AA",
                          @"arrow_up"                          : @"\U00002B06",
                          @"arrow_up_down"                     : @"\U00002195",
                          @"arrow_up_small"                    : @"\U0001F53C",
                          @"arrow_upper_left"                  : @"\U00002196",
                          @"arrow_upper_right"                 : @"\U00002197",
                          @"arrows_clockwise"                  : @"\U0001F503",
                          @"arrows_counterclockwise"           : @"\U0001F504",
                          @"art"                               : @"\U0001F3A8",
                          @"articulated_lorry"                 : @"\U0001F69B",
                          @"astonished"                        : @"\U0001F632",
                          @"athletic_shoe"                     : @"\U0001F45F",
                          @"atm"                               : @"\U0001F3E7",
                          @"b"                                 : @"\U0001F171",
                          @"baby"                              : @"\U0001F476",
                          @"baby_bottle"                       : @"\U0001F37C",
                          @"baby_chick"                        : @"\U0001F424",
                          @"baby_symbol"                       : @"\U0001F6BC",
                          @"back"                              : @"\U0001F519",
                          @"baggage_claim"                     : @"\U0001F6C4",
                          @"balloon"                           : @"\U0001F388",
                          @"ballot_box_with_check"             : @"\U00002611",
                          @"bamboo"                            : @"\U0001F38D",
                          @"banana"                            : @"\U0001F34C",
                          @"bangbang"                          : @"\U0000203C",
                          @"bank"                              : @"\U0001F3E6",
                          @"bar_chart"                         : @"\U0001F4CA",
                          @"barber"                            : @"\U0001F488",
                          @"baseball"                          : @"\U000026BE",
                          @"basketball"                        : @"\U0001F3C0",
                          @"bath"                              : @"\U0001F6C0",
                          @"bathtub"                           : @"\U0001F6C1",
                          @"battery"                           : @"\U0001F50B",
                          @"bear"                              : @"\U0001F43B",
                          @"bee"                               : @"\U0001F41D",
                          @"beer"                              : @"\U0001F37A",
                          @"beers"                             : @"\U0001F37B",
                          @"beetle"                            : @"\U0001F41E",
                          @"beginner"                          : @"\U0001F530",
                          @"bell"                              : @"\U0001F514",
                          @"bento"                             : @"\U0001F371",
                          @"bicyclist"                         : @"\U0001F6B4",
                          @"bike"                              : @"\U0001F6B2",
                          @"bikini"                            : @"\U0001F459",
                          @"bird"                              : @"\U0001F426",
                          @"birthday"                          : @"\U0001F382",
                          @"black_circle"                      : @"\U000026AB",
                          @"black_joker"                       : @"\U0001F0CF",
                          @"black_large_square"                : @"\U00002B1B",
                          @"black_medium_small_square"         : @"\U000025FE",
                          @"black_medium_square"               : @"\U000025FC",
                          @"black_nib"                         : @"\U00002712",
                          @"black_small_square"                : @"\U000025AA",
                          @"black_square_button"               : @"\U0001F532",
                          @"blossom"                           : @"\U0001F33C",
                          @"blowfish"                          : @"\U0001F421",
                          @"blue_book"                         : @"\U0001F4D8",
                          @"blue_car"                          : @"\U0001F699",
                          @"blue_heart"                        : @"\U0001F499",
                          @"blush"                             : @"\U0001F60A",
                          @"boar"                              : @"\U0001F417",
                          @"boat"                              : @"\U000026F5",
                          @"bomb"                              : @"\U0001F4A3",
                          @"book"                              : @"\U0001F4D6",
                          @"bookmark"                          : @"\U0001F516",
                          @"bookmark_tabs"                     : @"\U0001F4D1",
                          @"books"                             : @"\U0001F4DA",
                          @"boom"                              : @"\U0001F4A5",
                          @"boot"                              : @"\U0001F462",
                          @"bouquet"                           : @"\U0001F490",
                          @"bow"                               : @"\U0001F647",
                          @"bowling"                           : @"\U0001F3B3",
                          @"boy"                               : @"\U0001F466",
                          @"bread"                             : @"\U0001F35E",
                          @"bride_with_veil"                   : @"\U0001F470",
                          @"bridge_at_night"                   : @"\U0001F309",
                          @"briefcase"                         : @"\U0001F4BC",
                          @"broken_heart"                      : @"\U0001F494",
                          @"bug"                               : @"\U0001F41B",
                          @"bulb"                              : @"\U0001F4A1",
                          @"bullettrain_front"                 : @"\U0001F685",
                          @"bullettrain_side"                  : @"\U0001F684",
                          @"bus"                               : @"\U0001F68C",
                          @"busstop"                           : @"\U0001F68F",
                          @"bust_in_silhouette"                : @"\U0001F464",
                          @"busts_in_silhouette"               : @"\U0001F465",
                          @"cactus"                            : @"\U0001F335",
                          @"cake"                              : @"\U0001F370",
                          @"calendar"                          : @"\U0001F4C6",
                          @"calling"                           : @"\U0001F4F2",
                          @"camel"                             : @"\U0001F42B",
                          @"camera"                            : @"\U0001F4F7",
                          @"cancer"                            : @"\U0000264B",
                          @"candy"                             : @"\U0001F36C",
                          @"capital_abcd"                      : @"\U0001F520",
                          @"capricorn"                         : @"\U00002651",
                          @"car"                               : @"\U0001F697",
                          @"card_index"                        : @"\U0001F4C7",
                          @"carousel_horse"                    : @"\U0001F3A0",
                          @"cat"                               : @"\U0001F431",
                          @"cat2"                              : @"\U0001F408",
                          @"cd"                                : @"\U0001F4BF",
                          @"chart"                             : @"\U0001F4B9",
                          @"chart_with_downwards_trend"        : @"\U0001F4C9",
                          @"chart_with_upwards_trend"          : @"\U0001F4C8",
                          @"checkered_flag"                    : @"\U0001F3C1",
                          @"cherries"                          : @"\U0001F352",
                          @"cherry_blossom"                    : @"\U0001F338",
                          @"chestnut"                          : @"\U0001F330",
                          @"chicken"                           : @"\U0001F414",
                          @"children_crossing"                 : @"\U0001F6B8",
                          @"chocolate_bar"                     : @"\U0001F36B",
                          @"christmas_tree"                    : @"\U0001F384",
                          @"church"                            : @"\U000026EA",
                          @"cinema"                            : @"\U0001F3A6",
                          @"circus_tent"                       : @"\U0001F3AA",
                          @"city_sunrise"                      : @"\U0001F307",
                          @"city_sunset"                       : @"\U0001F306",
                          @"cl"                                : @"\U0001F191",
                          @"clap"                              : @"\U0001F44F",
                          @"clapper"                           : @"\U0001F3AC",
                          @"clipboard"                         : @"\U0001F4CB",
                          @"clock1"                            : @"\U0001F550",
                          @"clock10"                           : @"\U0001F559",
                          @"clock1030"                         : @"\U0001F565",
                          @"clock11"                           : @"\U0001F55A",
                          @"clock1130"                         : @"\U0001F566",
                          @"clock12"                           : @"\U0001F55B",
                          @"clock1230"                         : @"\U0001F567",
                          @"clock130"                          : @"\U0001F55C",
                          @"clock2"                            : @"\U0001F551",
                          @"clock230"                          : @"\U0001F55D",
                          @"clock3"                            : @"\U0001F552",
                          @"clock330"                          : @"\U0001F55E",
                          @"clock4"                            : @"\U0001F553",
                          @"clock430"                          : @"\U0001F55F",
                          @"clock5"                            : @"\U0001F554",
                          @"clock530"                          : @"\U0001F560",
                          @"clock6"                            : @"\U0001F555",
                          @"clock630"                          : @"\U0001F561",
                          @"clock7"                            : @"\U0001F556",
                          @"clock730"                          : @"\U0001F562",
                          @"clock8"                            : @"\U0001F557",
                          @"clock830"                          : @"\U0001F563",
                          @"clock9"                            : @"\U0001F558",
                          @"clock930"                          : @"\U0001F564",
                          @"closed_book"                       : @"\U0001F4D5",
                          @"closed_lock_with_key"              : @"\U0001F510",
                          @"closed_umbrella"                   : @"\U0001F302",
                          @"cloud"                             : @"\U00002601",
                          @"clubs"                             : @"\U00002663",
                          @"cocktail"                          : @"\U0001F378",
                          @"coffee"                            : @"\U00002615",
                          @"cold_sweat"                        : @"\U0001F630",
                          @"collision"                         : @"\U0001F4A5",
                          @"computer"                          : @"\U0001F4BB",
                          @"confetti_ball"                     : @"\U0001F38A",
                          @"confounded"                        : @"\U0001F616",
                          @"confused"                          : @"\U0001F615",
                          @"congratulations"                   : @"\U00003297",
                          @"construction"                      : @"\U0001F6A7",
                          @"construction_worker"               : @"\U0001F477",
                          @"convenience_store"                 : @"\U0001F3EA",
                          @"cookie"                            : @"\U0001F36A",
                          @"cool"                              : @"\U0001F192",
                          @"cop"                               : @"\U0001F46E",
                          @"copyright"                         : @"\U000000A9",
                          @"corn"                              : @"\U0001F33D",
                          @"couple"                            : @"\U0001F46B",
                          @"couple_with_heart"                 : @"\U0001F491",
                          @"couplekiss"                        : @"\U0001F48F",
                          @"cow"                               : @"\U0001F42E",
                          @"cow2"                              : @"\U0001F404",
                          @"credit_card"                       : @"\U0001F4B3",
                          @"crescent_moon"                     : @"\U0001F319",
                          @"crocodile"                         : @"\U0001F40A",
                          @"crossed_flags"                     : @"\U0001F38C",
                          @"crown"                             : @"\U0001F451",
                          @"cry"                               : @"\U0001F622",
                          @"crying_cat_face"                   : @"\U0001F63F",
                          @"crystal_ball"                      : @"\U0001F52E",
                          @"cupid"                             : @"\U0001F498",
                          @"curly_loop"                        : @"\U000027B0",
                          @"currency_exchange"                 : @"\U0001F4B1",
                          @"curry"                             : @"\U0001F35B",
                          @"custard"                           : @"\U0001F36E",
                          @"customs"                           : @"\U0001F6C3",
                          @"cyclone"                           : @"\U0001F300",
                          @"dancer"                            : @"\U0001F483",
                          @"dancers"                           : @"\U0001F46F",
                          @"dango"                             : @"\U0001F361",
                          @"dart"                              : @"\U0001F3AF",
                          @"dash"                              : @"\U0001F4A8",
                          @"date"                              : @"\U0001F4C5",
                          @"deciduous_tree"                    : @"\U0001F333",
                          @"department_store"                  : @"\U0001F3EC",
                          @"diamond_shape_with_a_dot_inside"   : @"\U0001F4A0",
                          @"diamonds"                          : @"\U00002666",
                          @"disappointed"                      : @"\U0001F61E",
                          @"disappointed_relieved"             : @"\U0001F625",
                          @"dizzy"                             : @"\U0001F4AB",
                          @"dizzy_face"                        : @"\U0001F635",
                          @"do_not_litter"                     : @"\U0001F6AF",
                          @"dog"                               : @"\U0001F436",
                          @"dog2"                              : @"\U0001F415",
                          @"dollar"                            : @"\U0001F4B5",
                          @"dolls"                             : @"\U0001F38E",
                          @"dolphin"                           : @"\U0001F42C",
                          @"door"                              : @"\U0001F6AA",
                          @"doughnut"                          : @"\U0001F369",
                          @"dragon"                            : @"\U0001F409",
                          @"dragon_face"                       : @"\U0001F432",
                          @"dress"                             : @"\U0001F457",
                          @"dromedary_camel"                   : @"\U0001F42A",
                          @"droplet"                           : @"\U0001F4A7",
                          @"dvd"                               : @"\U0001F4C0",
                          @"e-mail"                            : @"\U0001F4E7",
                          @"ear"                               : @"\U0001F442",
                          @"ear_of_rice"                       : @"\U0001F33E",
                          @"earth_africa"                      : @"\U0001F30D",
                          @"earth_americas"                    : @"\U0001F30E",
                          @"earth_asia"                        : @"\U0001F30F",
                          @"egg"                               : @"\U0001F373",
                          @"eggplant"                          : @"\U0001F346",
                          @"eight_pointed_black_star"          : @"\U00002734",
                          @"eight_spoked_asterisk"             : @"\U00002733",
                          @"electric_plug"                     : @"\U0001F50C",
                          @"elephant"                          : @"\U0001F418",
                          @"email"                             : @"\U00002709",
                          @"end"                               : @"\U0001F51A",
                          @"envelope"                          : @"\U00002709",
                          @"envelope_with_arrow"               : @"\U0001F4E9",
                          @"euro"                              : @"\U0001F4B6",
                          @"european_castle"                   : @"\U0001F3F0",
                          @"european_post_office"              : @"\U0001F3E4",
                          @"evergreen_tree"                    : @"\U0001F332",
                          @"exclamation"                       : @"\U00002757",
                          @"expressionless"                    : @"\U0001F611",
                          @"eyeglasses"                        : @"\U0001F453",
                          @"eyes"                              : @"\U0001F440",
                          @"facepunch"                         : @"\U0001F44A",
                          @"factory"                           : @"\U0001F3ED",
                          @"fallen_leaf"                       : @"\U0001F342",
                          @"family"                            : @"\U0001F46A",
                          @"fast_forward"                      : @"\U000023E9",
                          @"fax"                               : @"\U0001F4E0",
                          @"fearful"                           : @"\U0001F628",
                          @"feet"                              : @"\U0001F43E",
                          @"ferris_wheel"                      : @"\U0001F3A1",
                          @"file_folder"                       : @"\U0001F4C1",
                          @"fire"                              : @"\U0001F525",
                          @"fire_engine"                       : @"\U0001F692",
                          @"fireworks"                         : @"\U0001F386",
                          @"first_quarter_moon"                : @"\U0001F313",
                          @"first_quarter_moon_with_face"      : @"\U0001F31B",
                          @"fish"                              : @"\U0001F41F",
                          @"fish_cake"                         : @"\U0001F365",
                          @"fishing_pole_and_fish"             : @"\U0001F3A3",
                          @"fist"                              : @"\U0000270A",
                          @"flags"                             : @"\U0001F38F",
                          @"flashlight"                        : @"\U0001F526",
                          @"flipper"                           : @"\U0001F42C",
                          @"floppy_disk"                       : @"\U0001F4BE",
                          @"flower_playing_cards"              : @"\U0001F3B4",
                          @"flushed"                           : @"\U0001F633",
                          @"foggy"                             : @"\U0001F301",
                          @"football"                          : @"\U0001F3C8",
                          @"footprints"                        : @"\U0001F463",
                          @"fork_and_knife"                    : @"\U0001F374",
                          @"fountain"                          : @"\U000026F2",
                          @"four_leaf_clover"                  : @"\U0001F340",
                          @"free"                              : @"\U0001F193",
                          @"fried_shrimp"                      : @"\U0001F364",
                          @"fries"                             : @"\U0001F35F",
                          @"frog"                              : @"\U0001F438",
                          @"frowning"                          : @"\U0001F626",
                          @"fuelpump"                          : @"\U000026FD",
                          @"full_moon"                         : @"\U0001F315",
                          @"full_moon_with_face"               : @"\U0001F31D",
                          @"game_die"                          : @"\U0001F3B2",
                          @"gem"                               : @"\U0001F48E",
                          @"gemini"                            : @"\U0000264A",
                          @"ghost"                             : @"\U0001F47B",
                          @"gift"                              : @"\U0001F381",
                          @"gift_heart"                        : @"\U0001F49D",
                          @"girl"                              : @"\U0001F467",
                          @"globe_with_meridians"              : @"\U0001F310",
                          @"goat"                              : @"\U0001F410",
                          @"golf"                              : @"\U000026F3",
                          @"grapes"                            : @"\U0001F347",
                          @"green_apple"                       : @"\U0001F34F",
                          @"green_book"                        : @"\U0001F4D7",
                          @"green_heart"                       : @"\U0001F49A",
                          @"grey_exclamation"                  : @"\U00002755",
                          @"grey_question"                     : @"\U00002754",
                          @"grimacing"                         : @"\U0001F62C",
                          @"grin"                              : @"\U0001F601",
                          @"grinning"                          : @"\U0001F600",
                          @"guardsman"                         : @"\U0001F482",
                          @"guitar"                            : @"\U0001F3B8",
                          @"gun"                               : @"\U0001F52B",
                          @"haircut"                           : @"\U0001F487",
                          @"hamburger"                         : @"\U0001F354",
                          @"hammer"                            : @"\U0001F528",
                          @"hamster"                           : @"\U0001F439",
                          @"hand"                              : @"\U0000270B",
                          @"handbag"                           : @"\U0001F45C",
                          @"hankey"                            : @"\U0001F4A9",
                          @"hatched_chick"                     : @"\U0001F425",
                          @"hatching_chick"                    : @"\U0001F423",
                          @"headphones"                        : @"\U0001F3A7",
                          @"hear_no_evil"                      : @"\U0001F649",
                          @"heart"                             : @"\U00002764",
                          @"heart_decoration"                  : @"\U0001F49F",
                          @"heart_eyes"                        : @"\U0001F60D",
                          @"heart_eyes_cat"                    : @"\U0001F63B",
                          @"heartbeat"                         : @"\U0001F493",
                          @"heartpulse"                        : @"\U0001F497",
                          @"hearts"                            : @"\U00002665",
                          @"heavy_check_mark"                  : @"\U00002714",
                          @"heavy_division_sign"               : @"\U00002797",
                          @"heavy_dollar_sign"                 : @"\U0001F4B2",
                          @"heavy_exclamation_mark"            : @"\U00002757",
                          @"heavy_minus_sign"                  : @"\U00002796",
                          @"heavy_multiplication_x"            : @"\U00002716",
                          @"heavy_plus_sign"                   : @"\U00002795",
                          @"helicopter"                        : @"\U0001F681",
                          @"herb"                              : @"\U0001F33F",
                          @"hibiscus"                          : @"\U0001F33A",
                          @"high_brightness"                   : @"\U0001F506",
                          @"high_heel"                         : @"\U0001F460",
                          @"hocho"                             : @"\U0001F52A",
                          @"honey_pot"                         : @"\U0001F36F",
                          @"honeybee"                          : @"\U0001F41D",
                          @"horse"                             : @"\U0001F434",
                          @"horse_racing"                      : @"\U0001F3C7",
                          @"hospital"                          : @"\U0001F3E5",
                          @"hotel"                             : @"\U0001F3E8",
                          @"hotsprings"                        : @"\U00002668",
                          @"hourglass"                         : @"\U0000231B",
                          @"hourglass_flowing_sand"            : @"\U000023F3",
                          @"house"                             : @"\U0001F3E0",
                          @"house_with_garden"                 : @"\U0001F3E1",
                          @"hushed"                            : @"\U0001F62F",
                          @"ice_cream"                         : @"\U0001F368",
                          @"icecream"                          : @"\U0001F366",
                          @"id"                                : @"\U0001F194",
                          @"ideograph_advantage"               : @"\U0001F250",
                          @"imp"                               : @"\U0001F47F",
                          @"inbox_tray"                        : @"\U0001F4E5",
                          @"incoming_envelope"                 : @"\U0001F4E8",
                          @"information_desk_person"           : @"\U0001F481",
                          @"information_source"                : @"\U00002139",
                          @"innocent"                          : @"\U0001F607",
                          @"interrobang"                       : @"\U00002049",
                          @"iphone"                            : @"\U0001F4F1",
                          @"izakaya_lantern"                   : @"\U0001F3EE",
                          @"jack_o_lantern"                    : @"\U0001F383",
                          @"japan"                             : @"\U0001F5FE",
                          @"japanese_castle"                   : @"\U0001F3EF",
                          @"japanese_goblin"                   : @"\U0001F47A",
                          @"japanese_ogre"                     : @"\U0001F479",
                          @"jeans"                             : @"\U0001F456",
                          @"joy"                               : @"\U0001F602",
                          @"joy_cat"                           : @"\U0001F639",
                          @"key"                               : @"\U0001F511",
                          @"keycap_ten"                        : @"\U0001F51F",
                          @"kimono"                            : @"\U0001F458",
                          @"kiss"                              : @"\U0001F48B",
                          @"kissing"                           : @"\U0001F617",
                          @"kissing_cat"                       : @"\U0001F63D",
                          @"kissing_closed_eyes"               : @"\U0001F61A",
                          @"kissing_heart"                     : @"\U0001F618",
                          @"kissing_smiling_eyes"              : @"\U0001F619",
                          @"koala"                             : @"\U0001F428",
                          @"koko"                              : @"\U0001F201",
                          @"lantern"                           : @"\U0001F3EE",
                          @"large_blue_circle"                 : @"\U0001F535",
                          @"large_blue_diamond"                : @"\U0001F537",
                          @"large_orange_diamond"              : @"\U0001F536",
                          @"last_quarter_moon"                 : @"\U0001F317",
                          @"last_quarter_moon_with_face"       : @"\U0001F31C",
                          @"laughing"                          : @"\U0001F606",
                          @"leaves"                            : @"\U0001F343",
                          @"ledger"                            : @"\U0001F4D2",
                          @"left_luggage"                      : @"\U0001F6C5",
                          @"left_right_arrow"                  : @"\U00002194",
                          @"leftwards_arrow_with_hook"         : @"\U000021A9",
                          @"lemon"                             : @"\U0001F34B",
                          @"leo"                               : @"\U0000264C",
                          @"leopard"                           : @"\U0001F406",
                          @"libra"                             : @"\U0000264E",
                          @"light_rail"                        : @"\U0001F688",
                          @"link"                              : @"\U0001F517",
                          @"lips"                              : @"\U0001F444",
                          @"lipstick"                          : @"\U0001F484",
                          @"lock"                              : @"\U0001F512",
                          @"lock_with_ink_pen"                 : @"\U0001F50F",
                          @"lollipop"                          : @"\U0001F36D",
                          @"loop"                              : @"\U000027BF",
                          @"loudspeaker"                       : @"\U0001F4E2",
                          @"love_hotel"                        : @"\U0001F3E9",
                          @"love_letter"                       : @"\U0001F48C",
                          @"low_brightness"                    : @"\U0001F505",
                          @"m"                                 : @"\U000024C2",
                          @"mag"                               : @"\U0001F50D",
                          @"mag_right"                         : @"\U0001F50E",
                          @"mahjong"                           : @"\U0001F004",
                          @"mailbox"                           : @"\U0001F4EB",
                          @"mailbox_closed"                    : @"\U0001F4EA",
                          @"mailbox_with_mail"                 : @"\U0001F4EC",
                          @"mailbox_with_no_mail"              : @"\U0001F4ED",
                          @"man"                               : @"\U0001F468",
                          @"man_with_gua_pi_mao"               : @"\U0001F472",
                          @"man_with_turban"                   : @"\U0001F473",
                          @"mans_shoe"                         : @"\U0001F45E",
                          @"maple_leaf"                        : @"\U0001F341",
                          @"mask"                              : @"\U0001F637",
                          @"massage"                           : @"\U0001F486",
                          @"meat_on_bone"                      : @"\U0001F356",
                          @"mega"                              : @"\U0001F4E3",
                          @"melon"                             : @"\U0001F348",
                          @"memo"                              : @"\U0001F4DD",
                          @"mens"                              : @"\U0001F6B9",
                          @"metro"                             : @"\U0001F687",
                          @"microphone"                        : @"\U0001F3A4",
                          @"microscope"                        : @"\U0001F52C",
                          @"milky_way"                         : @"\U0001F30C",
                          @"minibus"                           : @"\U0001F690",
                          @"minidisc"                          : @"\U0001F4BD",
                          @"mobile_phone_off"                  : @"\U0001F4F4",
                          @"money_with_wings"                  : @"\U0001F4B8",
                          @"moneybag"                          : @"\U0001F4B0",
                          @"monkey"                            : @"\U0001F412",
                          @"monkey_face"                       : @"\U0001F435",
                          @"monorail"                          : @"\U0001F69D",
                          @"moon"                              : @"\U0001F314",
                          @"mortar_board"                      : @"\U0001F393",
                          @"mount_fuji"                        : @"\U0001F5FB",
                          @"mountain_bicyclist"                : @"\U0001F6B5",
                          @"mountain_cableway"                 : @"\U0001F6A0",
                          @"mountain_railway"                  : @"\U0001F69E",
                          @"mouse"                             : @"\U0001F42D",
                          @"mouse2"                            : @"\U0001F401",
                          @"movie_camera"                      : @"\U0001F3A5",
                          @"moyai"                             : @"\U0001F5FF",
                          @"muscle"                            : @"\U0001F4AA",
                          @"mushroom"                          : @"\U0001F344",
                          @"musical_keyboard"                  : @"\U0001F3B9",
                          @"musical_note"                      : @"\U0001F3B5",
                          @"musical_score"                     : @"\U0001F3BC",
                          @"mute"                              : @"\U0001F507",
                          @"nail_care"                         : @"\U0001F485",
                          @"name_badge"                        : @"\U0001F4DB",
                          @"necktie"                           : @"\U0001F454",
                          @"negative_squared_cross_mark"       : @"\U0000274E",
                          @"neutral_face"                      : @"\U0001F610",
                          @"new"                               : @"\U0001F195",
                          @"new_moon"                          : @"\U0001F311",
                          @"new_moon_with_face"                : @"\U0001F31A",
                          @"newspaper"                         : @"\U0001F4F0",
                          @"ng"                                : @"\U0001F196",
                          @"no_bell"                           : @"\U0001F515",
                          @"no_bicycles"                       : @"\U0001F6B3",
                          @"no_entry"                          : @"\U000026D4",
                          @"no_entry_sign"                     : @"\U0001F6AB",
                          @"no_good"                           : @"\U0001F645",
                          @"no_mobile_phones"                  : @"\U0001F4F5",
                          @"no_mouth"                          : @"\U0001F636",
                          @"no_pedestrians"                    : @"\U0001F6B7",
                          @"no_smoking"                        : @"\U0001F6AD",
                          @"non-potable_water"                 : @"\U0001F6B1",
                          @"nose"                              : @"\U0001F443",
                          @"notebook"                          : @"\U0001F4D3",
                          @"notebook_with_decorative_cover"    : @"\U0001F4D4",
                          @"notes"                             : @"\U0001F3B6",
                          @"nut_and_bolt"                      : @"\U0001F529",
                          @"o"                                 : @"\U00002B55",
                          @"o2"                                : @"\U0001F17E",
                          @"ocean"                             : @"\U0001F30A",
                          @"octopus"                           : @"\U0001F419",
                          @"oden"                              : @"\U0001F362",
                          @"office"                            : @"\U0001F3E2",
                          @"ok"                                : @"\U0001F197",
                          @"ok_hand"                           : @"\U0001F44C",
                          @"ok_woman"                          : @"\U0001F646",
                          @"older_man"                         : @"\U0001F474",
                          @"older_woman"                       : @"\U0001F475",
                          @"on"                                : @"\U0001F51B",
                          @"oncoming_automobile"               : @"\U0001F698",
                          @"oncoming_bus"                      : @"\U0001F68D",
                          @"oncoming_police_car"               : @"\U0001F694",
                          @"oncoming_taxi"                     : @"\U0001F696",
                          @"open_book"                         : @"\U0001F4D6",
                          @"open_file_folder"                  : @"\U0001F4C2",
                          @"open_hands"                        : @"\U0001F450",
                          @"open_mouth"                        : @"\U0001F62E",
                          @"ophiuchus"                         : @"\U000026CE",
                          @"orange_book"                       : @"\U0001F4D9",
                          @"outbox_tray"                       : @"\U0001F4E4",
                          @"ox"                                : @"\U0001F402",
                          @"package"                           : @"\U0001F4E6",
                          @"page_facing_up"                    : @"\U0001F4C4",
                          @"page_with_curl"                    : @"\U0001F4C3",
                          @"pager"                             : @"\U0001F4DF",
                          @"palm_tree"                         : @"\U0001F334",
                          @"panda_face"                        : @"\U0001F43C",
                          @"paperclip"                         : @"\U0001F4CE",
                          @"parking"                           : @"\U0001F17F",
                          @"part_alternation_mark"             : @"\U0000303D",
                          @"partly_sunny"                      : @"\U000026C5",
                          @"passport_control"                  : @"\U0001F6C2",
                          @"paw_prints"                        : @"\U0001F43E",
                          @"peach"                             : @"\U0001F351",
                          @"pear"                              : @"\U0001F350",
                          @"pencil"                            : @"\U0001F4DD",
                          @"pencil2"                           : @"\U0000270F",
                          @"penguin"                           : @"\U0001F427",
                          @"pensive"                           : @"\U0001F614",
                          @"performing_arts"                   : @"\U0001F3AD",
                          @"persevere"                         : @"\U0001F623",
                          @"person_frowning"                   : @"\U0001F64D",
                          @"person_with_blond_hair"            : @"\U0001F471",
                          @"person_with_pouting_face"          : @"\U0001F64E",
                          @"phone"                             : @"\U0000260E",
                          @"pig"                               : @"\U0001F437",
                          @"pig2"                              : @"\U0001F416",
                          @"pig_nose"                          : @"\U0001F43D",
                          @"pill"                              : @"\U0001F48A",
                          @"pineapple"                         : @"\U0001F34D",
                          @"pisces"                            : @"\U00002653",
                          @"pizza"                             : @"\U0001F355",
                          @"point_down"                        : @"\U0001F447",
                          @"point_left"                        : @"\U0001F448",
                          @"point_right"                       : @"\U0001F449",
                          @"point_up"                          : @"\U0000261D",
                          @"point_up_2"                        : @"\U0001F446",
                          @"police_car"                        : @"\U0001F693",
                          @"poodle"                            : @"\U0001F429",
                          @"poop"                              : @"\U0001F4A9",
                          @"post_office"                       : @"\U0001F3E3",
                          @"postal_horn"                       : @"\U0001F4EF",
                          @"postbox"                           : @"\U0001F4EE",
                          @"potable_water"                     : @"\U0001F6B0",
                          @"pouch"                             : @"\U0001F45D",
                          @"poultry_leg"                       : @"\U0001F357",
                          @"pound"                             : @"\U0001F4B7",
                          @"pouting_cat"                       : @"\U0001F63E",
                          @"pray"                              : @"\U0001F64F",
                          @"princess"                          : @"\U0001F478",
                          @"punch"                             : @"\U0001F44A",
                          @"purple_heart"                      : @"\U0001F49C",
                          @"purse"                             : @"\U0001F45B",
                          @"pushpin"                           : @"\U0001F4CC",
                          @"put_litter_in_its_place"           : @"\U0001F6AE",
                          @"question"                          : @"\U00002753",
                          @"rabbit"                            : @"\U0001F430",
                          @"rabbit2"                           : @"\U0001F407",
                          @"racehorse"                         : @"\U0001F40E",
                          @"radio"                             : @"\U0001F4FB",
                          @"radio_button"                      : @"\U0001F518",
                          @"rage"                              : @"\U0001F621",
                          @"railway_car"                       : @"\U0001F683",
                          @"rainbow"                           : @"\U0001F308",
                          @"raised_hand"                       : @"\U0000270B",
                          @"raised_hands"                      : @"\U0001F64C",
                          @"raising_hand"                      : @"\U0001F64B",
                          @"ram"                               : @"\U0001F40F",
                          @"ramen"                             : @"\U0001F35C",
                          @"rat"                               : @"\U0001F400",
                          @"recycle"                           : @"\U0000267B",
                          @"red_car"                           : @"\U0001F697",
                          @"red_circle"                        : @"\U0001F534",
                          @"registered"                        : @"\U000000AE",
                          @"relaxed"                           : @"\U0000263A",
                          @"relieved"                          : @"\U0001F60C",
                          @"repeat"                            : @"\U0001F501",
                          @"repeat_one"                        : @"\U0001F502",
                          @"restroom"                          : @"\U0001F6BB",
                          @"revolving_hearts"                  : @"\U0001F49E",
                          @"rewind"                            : @"\U000023EA",
                          @"ribbon"                            : @"\U0001F380",
                          @"rice"                              : @"\U0001F35A",
                          @"rice_ball"                         : @"\U0001F359",
                          @"rice_cracker"                      : @"\U0001F358",
                          @"rice_scene"                        : @"\U0001F391",
                          @"ring"                              : @"\U0001F48D",
                          @"rocket"                            : @"\U0001F680",
                          @"roller_coaster"                    : @"\U0001F3A2",
                          @"rooster"                           : @"\U0001F413",
                          @"rose"                              : @"\U0001F339",
                          @"rotating_light"                    : @"\U0001F6A8",
                          @"round_pushpin"                     : @"\U0001F4CD",
                          @"rowboat"                           : @"\U0001F6A3",
                          @"rugby_football"                    : @"\U0001F3C9",
                          @"runner"                            : @"\U0001F3C3",
                          @"running"                           : @"\U0001F3C3",
                          @"running_shirt_with_sash"           : @"\U0001F3BD",
                          @"sa"                                : @"\U0001F202",
                          @"sagittarius"                       : @"\U00002650",
                          @"sailboat"                          : @"\U000026F5",
                          @"sake"                              : @"\U0001F376",
                          @"sandal"                            : @"\U0001F461",
                          @"santa"                             : @"\U0001F385",
                          @"satellite"                         : @"\U0001F4E1",
                          @"satisfied"                         : @"\U0001F606",
                          @"saxophone"                         : @"\U0001F3B7",
                          @"school"                            : @"\U0001F3EB",
                          @"school_satchel"                    : @"\U0001F392",
                          @"scissors"                          : @"\U00002702",
                          @"scorpius"                          : @"\U0000264F",
                          @"scream"                            : @"\U0001F631",
                          @"scream_cat"                        : @"\U0001F640",
                          @"scroll"                            : @"\U0001F4DC",
                          @"seat"                              : @"\U0001F4BA",
                          @"secret"                            : @"\U00003299",
                          @"see_no_evil"                       : @"\U0001F648",
                          @"seedling"                          : @"\U0001F331",
                          @"shaved_ice"                        : @"\U0001F367",
                          @"sheep"                             : @"\U0001F411",
                          @"shell"                             : @"\U0001F41A",
                          @"ship"                              : @"\U0001F6A2",
                          @"shirt"                             : @"\U0001F455",
                          @"shit"                              : @"\U0001F4A9",
                          @"shoe"                              : @"\U0001F45E",
                          @"shower"                            : @"\U0001F6BF",
                          @"signal_strength"                   : @"\U0001F4F6",
                          @"six_pointed_star"                  : @"\U0001F52F",
                          @"ski"                               : @"\U0001F3BF",
                          @"skull"                             : @"\U0001F480",
                          @"sleeping"                          : @"\U0001F634",
                          @"sleepy"                            : @"\U0001F62A",
                          @"slot_machine"                      : @"\U0001F3B0",
                          @"small_blue_diamond"                : @"\U0001F539",
                          @"small_orange_diamond"              : @"\U0001F538",
                          @"small_red_triangle"                : @"\U0001F53A",
                          @"small_red_triangle_down"           : @"\U0001F53B",
                          @"smile"                             : @"\U0001F604",
                          @"smile_cat"                         : @"\U0001F638",
                          @"smiley"                            : @"\U0001F603",
                          @"smiley_cat"                        : @"\U0001F63A",
                          @"smiling_imp"                       : @"\U0001F608",
                          @"smirk"                             : @"\U0001F60F",
                          @"smirk_cat"                         : @"\U0001F63C",
                          @"smoking"                           : @"\U0001F6AC",
                          @"snail"                             : @"\U0001F40C",
                          @"snake"                             : @"\U0001F40D",
                          @"snowboarder"                       : @"\U0001F3C2",
                          @"snowflake"                         : @"\U00002744",
                          @"snowman"                           : @"\U000026C4",
                          @"sob"                               : @"\U0001F62D",
                          @"soccer"                            : @"\U000026BD",
                          @"soon"                              : @"\U0001F51C",
                          @"sos"                               : @"\U0001F198",
                          @"sound"                             : @"\U0001F509",
                          @"space_invader"                     : @"\U0001F47E",
                          @"spades"                            : @"\U00002660",
                          @"spaghetti"                         : @"\U0001F35D",
                          @"sparkle"                           : @"\U00002747",
                          @"sparkler"                          : @"\U0001F387",
                          @"sparkles"                          : @"\U00002728",
                          @"sparkling_heart"                   : @"\U0001F496",
                          @"speak_no_evil"                     : @"\U0001F64A",
                          @"speaker"                           : @"\U0001F50A",
                          @"speech_balloon"                    : @"\U0001F4AC",
                          @"speedboat"                         : @"\U0001F6A4",
                          @"star"                              : @"\U00002B50",
                          @"star2"                             : @"\U0001F31F",
                          @"stars"                             : @"\U0001F303",
                          @"station"                           : @"\U0001F689",
                          @"statue_of_liberty"                 : @"\U0001F5FD",
                          @"steam_locomotive"                  : @"\U0001F682",
                          @"stew"                              : @"\U0001F372",
                          @"straight_ruler"                    : @"\U0001F4CF",
                          @"strawberry"                        : @"\U0001F353",
                          @"stuck_out_tongue"                  : @"\U0001F61B",
                          @"stuck_out_tongue_closed_eyes"      : @"\U0001F61D",
                          @"stuck_out_tongue_winking_eye"      : @"\U0001F61C",
                          @"sun_with_face"                     : @"\U0001F31E",
                          @"sunflower"                         : @"\U0001F33B",
                          @"sunglasses"                        : @"\U0001F60E",
                          @"sunny"                             : @"\U00002600",
                          @"sunrise"                           : @"\U0001F305",
                          @"sunrise_over_mountains"            : @"\U0001F304",
                          @"surfer"                            : @"\U0001F3C4",
                          @"sushi"                             : @"\U0001F363",
                          @"suspension_railway"                : @"\U0001F69F",
                          @"sweat"                             : @"\U0001F613",
                          @"sweat_drops"                       : @"\U0001F4A6",
                          @"sweat_smile"                       : @"\U0001F605",
                          @"sweet_potato"                      : @"\U0001F360",
                          @"swimmer"                           : @"\U0001F3CA",
                          @"symbols"                           : @"\U0001F523",
                          @"syringe"                           : @"\U0001F489",
                          @"tada"                              : @"\U0001F389",
                          @"tanabata_tree"                     : @"\U0001F38B",
                          @"tangerine"                         : @"\U0001F34A",
                          @"taurus"                            : @"\U00002649",
                          @"taxi"                              : @"\U0001F695",
                          @"tea"                               : @"\U0001F375",
                          @"telephone"                         : @"\U0000260E",
                          @"telephone_receiver"                : @"\U0001F4DE",
                          @"telescope"                         : @"\U0001F52D",
                          @"tennis"                            : @"\U0001F3BE",
                          @"tent"                              : @"\U000026FA",
                          @"thought_balloon"                   : @"\U0001F4AD",
                          @"thumbsdown"                        : @"\U0001F44E",
                          @"thumbsup"                          : @"\U0001F44D",
                          @"ticket"                            : @"\U0001F3AB",
                          @"tiger"                             : @"\U0001F42F",
                          @"tiger2"                            : @"\U0001F405",
                          @"tired_face"                        : @"\U0001F62B",
                          @"tm"                                : @"\U00002122",
                          @"toilet"                            : @"\U0001F6BD",
                          @"tokyo_tower"                       : @"\U0001F5FC",
                          @"tomato"                            : @"\U0001F345",
                          @"tongue"                            : @"\U0001F445",
                          @"top"                               : @"\U0001F51D",
                          @"tophat"                            : @"\U0001F3A9",
                          @"tractor"                           : @"\U0001F69C",
                          @"traffic_light"                     : @"\U0001F6A5",
                          @"train"                             : @"\U0001F683",
                          @"train2"                            : @"\U0001F686",
                          @"tram"                              : @"\U0001F68A",
                          @"triangular_flag_on_post"           : @"\U0001F6A9",
                          @"triangular_ruler"                  : @"\U0001F4D0",
                          @"trident"                           : @"\U0001F531",
                          @"triumph"                           : @"\U0001F624",
                          @"trolleybus"                        : @"\U0001F68E",
                          @"trophy"                            : @"\U0001F3C6",
                          @"tropical_drink"                    : @"\U0001F379",
                          @"tropical_fish"                     : @"\U0001F420",
                          @"truck"                             : @"\U0001F69A",
                          @"trumpet"                           : @"\U0001F3BA",
                          @"tshirt"                            : @"\U0001F455",
                          @"tulip"                             : @"\U0001F337",
                          @"turtle"                            : @"\U0001F422",
                          @"tv"                                : @"\U0001F4FA",
                          @"twisted_rightwards_arrows"         : @"\U0001F500",
                          @"two_hearts"                        : @"\U0001F495",
                          @"two_men_holding_hands"             : @"\U0001F46C",
                          @"two_women_holding_hands"           : @"\U0001F46D",
                          @"u5272"                             : @"\U0001F239",
                          @"u5408"                             : @"\U0001F234",
                          @"u55b6"                             : @"\U0001F23A",
                          @"u6307"                             : @"\U0001F22F",
                          @"u6708"                             : @"\U0001F237",
                          @"u6709"                             : @"\U0001F236",
                          @"u6e80"                             : @"\U0001F235",
                          @"u7121"                             : @"\U0001F21A",
                          @"u7533"                             : @"\U0001F238",
                          @"u7981"                             : @"\U0001F232",
                          @"u7a7a"                             : @"\U0001F233",
                          @"umbrella"                          : @"\U00002614",
                          @"unamused"                          : @"\U0001F612",
                          @"underage"                          : @"\U0001F51E",
                          @"unlock"                            : @"\U0001F513",
                          @"up"                                : @"\U0001F199",
                          @"v"                                 : @"\U0000270C",
                          @"vertical_traffic_light"            : @"\U0001F6A6",
                          @"vhs"                               : @"\U0001F4FC",
                          @"vibration_mode"                    : @"\U0001F4F3",
                          @"video_camera"                      : @"\U0001F4F9",
                          @"video_game"                        : @"\U0001F3AE",
                          @"violin"                            : @"\U0001F3BB",
                          @"virgo"                             : @"\U0000264D",
                          @"volcano"                           : @"\U0001F30B",
                          @"vs"                                : @"\U0001F19A",
                          @"walking"                           : @"\U0001F6B6",
                          @"waning_crescent_moon"              : @"\U0001F318",
                          @"waning_gibbous_moon"               : @"\U0001F316",
                          @"warning"                           : @"\U000026A0",
                          @"watch"                             : @"\U0000231A",
                          @"water_buffalo"                     : @"\U0001F403",
                          @"watermelon"                        : @"\U0001F349",
                          @"wave"                              : @"\U0001F44B",
                          @"wavy_dash"                         : @"\U00003030",
                          @"waxing_crescent_moon"              : @"\U0001F312",
                          @"waxing_gibbous_moon"               : @"\U0001F314",
                          @"wc"                                : @"\U0001F6BE",
                          @"weary"                             : @"\U0001F629",
                          @"wedding"                           : @"\U0001F492",
                          @"whale"                             : @"\U0001F433",
                          @"whale2"                            : @"\U0001F40B",
                          @"wheelchair"                        : @"\U0000267F",
                          @"white_check_mark"                  : @"\U00002705",
                          @"white_circle"                      : @"\U000026AA",
                          @"white_flower"                      : @"\U0001F4AE",
                          @"white_large_square"                : @"\U00002B1C",
                          @"white_medium_small_square"         : @"\U000025FD",
                          @"white_medium_square"               : @"\U000025FB",
                          @"white_small_square"                : @"\U000025AB",
                          @"white_square_button"               : @"\U0001F533",
                          @"wind_chime"                        : @"\U0001F390",
                          @"wine_glass"                        : @"\U0001F377",
                          @"wink"                              : @"\U0001F609",
                          @"wolf"                              : @"\U0001F43A",
                          @"woman"                             : @"\U0001F469",
                          @"womans_clothes"                    : @"\U0001F45A",
                          @"womans_hat"                        : @"\U0001F452",
                          @"womens"                            : @"\U0001F6BA",
                          @"worried"                           : @"\U0001F61F",
                          @"wrench"                            : @"\U0001F527",
                          @"x"                                 : @"\U0000274C",
                          @"yellow_heart"                      : @"\U0001F49B",
                          @"yen"                               : @"\U0001F4B4",
                          @"yum"                               : @"\U0001F60B",
                          @"zap"                               : @"\U000026A1",
                          @"zzz"                               : @"\U0001F4A4"};
    });
    return _emojisByAlias;
}

+ (NSString*)stringByReplacingEmojiAliasesInString:(NSString*)string {
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(:[a-z0-9-+_]+:)" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSMutableString *result = [string mutableCopy];
    NSRange range = NSMakeRange(0, [string length]);
    [regex enumerateMatchesInString:string options:NSMatchingReportCompletion range:range usingBlock:^(NSTextCheckingResult *checkingResult, NSMatchingFlags flags, BOOL *stop) {
        NSString *match = [string substringWithRange:checkingResult.range];
        NSString *alias = [match stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *emojiCharacter = [self byAlias][alias];
        if (emojiCharacter) {
            NSRange resultRange = NSMakeRange(0, [result length]);
            [result replaceOccurrencesOfString:match withString:emojiCharacter options:0 range:resultRange];
        }
     }];
    return result;
}

+ (NSS*) random { return self.all.randomElement; }

+ (NSA*) all {  AZSTATIC_OBJ(NSArray, emojis, [[self byAlias] map:^id(id key, id obj) { return [self stringByReplacingEmojiAliasesInString:obj]; }].allValues);

  return emojis;
}

@end