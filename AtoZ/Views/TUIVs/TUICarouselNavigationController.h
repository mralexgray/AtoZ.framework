//
//  TUICarouselNavigationController.h
//  TwUI
//
//  Created by Serhey Tkachenko on 3/24/13.
//
//
#import <Foundation/Foundation.h>
//#import "TUIViewController.h"
#import <TwUI/TUIKit.h>

@class TUICarouselNavigationController;
@protocol TUICarouselNavigationControllerDelegate  <NSObject>
- (void) avigationController:(TUICarouselNavigationController *)navigationController willShowViewController:(TUIViewController *)viewController animated:(BOOL)animated;
- (void) avigationController:(TUICarouselNavigationController *)navigationController didShowViewController:(TUIViewController *)viewController animated:(BOOL)animated;
- (void) avigationController:(TUICarouselNavigationController *)navigationController cancelShowViewController:(TUIViewController *)viewController animated:(BOOL)animated;
@end
@interface TUICarouselNavigationController : TUIViewController
@property (unsafe_unretained, nonatomic, readonly) TUIViewController *currentController;
@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, assign) id <TUICarouselNavigationControllerDelegate> delegate;
@property (nonatomic, assign) BOOL needsBlurWhenSlide;
@property (nonatomic, assign) BOOL couldUseSlideEvent;
- (id)initWithViewControllers:(NSArray *)viewControllers initialController:(id)initialController;
- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void) setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
- (void) setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (TUIViewController *)nextViewController;
- (TUIViewController *)prevViewController;
- (void) lideToViewController:(TUIViewController *)viewController animated:(BOOL)animated;
- (void) lideToViewController:(TUIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void) lideToNextViewControllerAnimated:(BOOL)animated;
- (void) lideToNextViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void) lideToPrevViewControllerAnimated:(BOOL)animated;
- (void) lideToPrevViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
@end
