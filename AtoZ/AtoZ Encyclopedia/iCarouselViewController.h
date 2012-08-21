
#import <AtoZ/AtoZ.h>

typedef  enum {
	AZOffsetFieldsCx,
	AZOffsetFieldsCy,
	AZOffsetFieldsVx,
	AZOffsetFieldsVy
}	AZOffsetFields;

@interface iCarouselViewController : NSViewController
									<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, assign) IBOutlet iCarousel *carousel;
@property (nonatomic, assign) NSUInteger iconStyle;
- (IBAction)readFormAndReload:(id)sender;

- (IBAction)setOffsets:(id)sender;
- (IBAction)switchCarouselType:(id)sender;
- (IBAction)toggleVertical:(id)sender;
- (IBAction)toggleWrap:(id)sender;
- (IBAction)insertItem:(id)sender;
- (IBAction)removeItem:(id)sender;

@property (assign) IBOutlet NSForm *form;

@end

//{
////    __weak iCarousel *_carousel;
////    BOOL wrap;
////    NSMutableArray *_items;
////	__unsafe_unretained NSForm *form;
//}
