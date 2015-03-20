
#import <AtoZUniversal/AtoZUniversal.h>


@implementation NSFont (AtoZ)

- _Flot_ size { return self.pointSize; } // [[self.fontDescriptor objectForKey:NSFontSizeAttribute] floatValue]; }

//- (void) setSize:(CGF) size {  [

- _Font_ fontWithSize:_Flot_ z { return [Font fontWithName:self.fontName size:z]; }


#pragma mark - AMFixes

- _Flot_ fixed_xHeight
{
	_Flot result = [self xHeight];
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

- _Flot_ fixed_capHeight
{
	_Flot result = [self capHeight];
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




