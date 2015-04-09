
#import <AtoZ/AtoZ.h>

typedef  enum {
	AZOffsetFieldsCx,
	AZOffsetFieldsCy,
	AZOffsetFieldsVx,
	AZOffsetFieldsVy
}	AZOffsetFields;

@interface iCarouselViewController : NSObject
									<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, assign) iCarouselType type;
@property (nonatomic, retain) NSNumber *vScale;
@property (nonatomic, retain) NSNumber *cScale;

@property (nonatomic, retain) AZAttachedWindow *attache;
@property (weak) IBOutlet NSView *attacheView;

@property (nonatomic, assign) IBOutlet iCarousel *carousel;
@property (nonatomic, assign) NSUInteger iconStyle;
@property (nonatomic, assign) float size;
@property (nonatomic, assign) float multi;
@property (nonatomic, assign) float space;

- (IBAction)readFormAndReload _ R ___
                              
- (IBAction)setOffsets _ O ___
                              - (IBAction)switchCarouselType _ T ___
                              - (IBAction)toggleVertical _ V ___
                              - (IBAction)toggleWrap _ W ___
                              - (IBAction)insertItem _ I ___
                              - (IBAction)removeItem _ I ___
                              
@property (assign) IBOutlet NSForm *form;

@end

//{
////	__weak iCarousel *_carousel;
////	BOOL wrap;
////	NSMutableArray *_items;
////	__unsafe_unretained NSForm *form;
//}
