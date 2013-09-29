

// USAGE  	self.navigationController =
//				[AZProportionalSegmentController.alloc initInView:self.window.contentView];

// self-refulating, show up to n views, proportanetly. then arrow through.

#define AZPSV AZProportionalSegmentView
typedef void (^AZTUICompletionBlock)(BOOL done);
typedef void(^AZTUIDrawBlock)(TUIV*blkV,CGR dRect);

@class AZProportionalSegmentController, AZProportionalSegmentView;
@protocol  AZProportionalSegmentViewDatasource <NSObject>
@optional
- (TUIViewDrawRect) drawBlockForView:(AZProportionalSegmentView*)v;
- (NSM*) menuForRightClick;
@end

@interface AZSegment : TUIV
@end

@interface AZProportionalSegmentView : TUIVC
@property (assign) id <AZProportionalSegmentViewDatasource> datasource;
@property (nonatomic, strong) TUITextRenderer *textRenderer;
@property (strong) 				NSC* color;
@property (strong) 				NSS *uid;
@property (nonatomic, assign) NSI index;

@end


@interface AZProportionalSegmentController : TUIVC
@property (readonly) id  <AZProportionalSegmentViewDatasource> datasource;
@property (strong, nonatomic) AZProportionalSegmentView *banner;
@property (assign, nonatomic) CGF maxHeight, bannerHeight;


@property (nonatomic,strong)			NSMA 	*controllers, *cache;
@property (nonatomic,assign)			NSUI 	maxVisible;
- (void) pushViewController:	(TUIVC*)viewController animated:(BOOL)animated;
- (void) popViewControllerAnimated:									  (BOOL)animated;
- (void) toggleBannerWithText:(NSS*)string;
-   (id) initInView: (TUINSV*)view withDataSource:(id<AZProportionalSegmentViewDatasource>)ds;
@end

//- (id) initWithRootViewController:(TUIVC*)rootViewController;
