//
//  TUICarouselNavigationController.h
//  TwUI
//
//  Created by Serhey Tkachenko on 3/24/13.
//
//
#import <Foundation/Foundation.h>
#import "TUIViewController.h"
@class TUICarouselNavigationController;
@protocol TUICarouselNavigationControllerDelegate  <NSObject>
- (void)navigationController:(TUICarouselNavigationController *)navigationController willShowViewController:(TUIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(TUICarouselNavigationController *)navigationController didShowViewController:(TUIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(TUICarouselNavigationController *)navigationController cancelShowViewController:(TUIViewController *)viewController animated:(BOOL)animated;
@end
@interface TUICarouselNavigationController : TUIViewController
@property (unsafe_unretained, nonatomic, readonly) TUIViewController *currentController;
@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, assign) id <TUICarouselNavigationControllerDelegate> delegate;
@property (nonatomic, assign) BOOL needsBlurWhenSlide;
@property (nonatomic, assign) BOOL couldUseSlideEvent;
- (id)initWithViewControllers:(NSArray *)viewControllers initialController:(id)initialController;
- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (TUIViewController *)nextViewController;
- (TUIViewController *)prevViewController;
- (void)slideToViewController:(TUIViewController *)viewController animated:(BOOL)animated;
- (void)slideToViewController:(TUIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)slideToNextViewControllerAnimated:(BOOL)animated;
- (void)slideToNextViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)slideToPrevViewControllerAnimated:(BOOL)animated;
- (void)slideToPrevViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
@end
