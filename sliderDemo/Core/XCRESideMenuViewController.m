//
//  RESideMenu.m
//  RESideMenuPractice
//  参考简书:http://www.jianshu.com/p/3dbc2786e0be
//  Created by ssj on 2016/7/24.
//  Copyright © 2016年 ease. All rights reserved.
//

#import "XCRESideMenuViewController.h"

@interface XCRESideMenuViewController()

@property (strong, nonatomic) UIImageView *backgroundImageView;         /** < 第一层背景图片  */

@property (strong, nonatomic) UIView *menuViewContainer;                /** <左右边栏视图容器下的view */

@property (strong, nonatomic) UIView *contentViewContainer;             /** <主视图容器下的view */

@property (strong, nonatomic) UIButton *contentButton;

@property (nonatomic) CGFloat animationDuration;                        /** < 侧滑的动画时间 */

@property (nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;      /** < 横屏下距离试图中轴的便宜距离 */

@property (nonatomic) CGFloat contentViewInPortraitOffsetCenterX;       /** < 竖屏下距离试图中轴的便宜距离 */

@property (nonatomic) CGFloat contentViewFadeOutAlpha;                  /** < 侧滑之后 主试图的透明度 */

@property (nonatomic) BOOL leftMenuVisible;                             /** < 左边栏是否出现 */

@property (nonatomic) BOOL rightMenuVisible;                            /** < 右边栏是否出现 */

@property (nonatomic) BOOL isShowRghtMenu;

@property (nonatomic) CGPoint originalPoint;                            /** < 当前中心点距离原来中心点的x,y轴距离*/

@property (nonatomic) CGFloat panMinimumOpenThreshold;

@property (nonatomic) CGFloat contentViewScaleValue;                    /** < 侧滑之后设置的主视图缩放比例 */

@property (nonatomic) CGFloat backgroundImageViewScaleValue;            /** < 背景图片的缩放比例 */

@property (nonatomic) CGFloat menuViewScaleValue;                       /** < 边栏视图的缩放比例 */

@property (nonatomic) CGAffineTransform backgroundImageViewTransformation; /** < 背景图片的转变 */

@property (nonatomic) CGAffineTransform menuViewControllerTransformation;  /** < 侧边栏视图的转变 */

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation XCRESideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    UIStoryboard* contentStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Root" bundle:[NSBundle mainBundle]];
    self.contentViewController = [contentStoryboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.rightMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageNamed:@"MenuBackground"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView;
    });
    self.menuViewContainer = ({
        UIView *menuViewContainer = [[UIView alloc] init];
        menuViewContainer.frame = self.view.bounds;
        menuViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        menuViewContainer;
    });
    self.contentViewContainer = ({
        UIView *contentViewContainer = [[UIView alloc] init];
        contentViewContainer.frame = self.view.bounds;
        contentViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentViewContainer;
    });
    
    self.contentButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectNull];
        [button addTarget:self action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.menuViewContainer];
    [self.view addSubview:self.contentViewContainer];
    
    if (self.leftMenuViewController) {
        [self addChildViewController:self.menuViewContainer childViewController:self.leftMenuViewController];
    }
    if (self.rightMenuViewController) {
        [self addChildViewController:self.menuViewContainer childViewController:self.rightMenuViewController];
    }
    [self addChildViewController:self.contentViewContainer childViewController:self.contentViewController];
    [self addPanGesture];
}

#pragma mark --delegate
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer translationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        self.originalPoint = CGPointMake(self.contentViewContainer.center.x - CGRectGetWidth(self.contentViewContainer.bounds) / 2.0,
                                         self.contentViewContainer.center.y - CGRectGetHeight(self.contentViewContainer.bounds) / 2.0);
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.backgroundImageView.frame = self.view.bounds;
        
        self.menuViewContainer.transform = CGAffineTransformIdentity;
        self.menuViewContainer.frame = self.view.bounds;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat delta;
        if (self.leftMenuVisible || self.rightMenuVisible) {
            if (point.x < 0) {
                delta = fabs(self.originalPoint.x != 0 ? (point.x + self.originalPoint.x) / self.originalPoint.x : 0);
            }else{
                return;
            }
        } else {
            if (!self.isShowRghtMenu) {
                if (point.x < 0) {
                    return;
                }
            }
            delta = fabs(point.x / self.view.frame.size.width);
        }
        
        CGFloat backgroundViewScale = self.backgroundImageViewScaleValue - ((self.backgroundImageViewScaleValue-1) * delta);
        CGFloat menuViewScale = self.menuViewScaleValue - ((self.menuViewScaleValue-1) * delta);
        
        //为了向右拖动的时候背景图的缩放比例不小于1，否则背景不能充满屏幕看起来不美观。
        if (backgroundViewScale < 1) {
            self.backgroundImageView.transform = CGAffineTransformIdentity;
        } else {
            self.backgroundImageView.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
        }
        
        self.menuViewContainer.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale);
        self.menuViewContainer.alpha = delta;
        
        self.contentViewContainer.alpha = 1 - (1 - self.contentViewFadeOutAlpha) * delta;
        
        //如果缩放比例大于1，则设置为相反的值。比如放大1.2倍则设置成缩小为0.8倍。
        CGFloat contentViewScale = 1 - ((1 - self.contentViewScaleValue) * delta);
        if (contentViewScale > 1) {
            contentViewScale = (1 - (contentViewScale - 1));
        }
        self.contentViewContainer.transform = CGAffineTransformMakeScale(contentViewScale, contentViewScale);
        self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x, 0);
        
        //注意这里左右view的可见设置，不设置则在拖动的时候会在某个时刻同时出现左右侧边栏的。
        self.leftMenuViewController.view.hidden = self.contentViewContainer.frame.origin.x < 0;
        self.rightMenuViewController.view.hidden = self.contentViewContainer.frame.origin.x > 0;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.panMinimumOpenThreshold > 0 && (
                                                 (self.contentViewContainer.frame.origin.x < 0 && self.contentViewContainer.frame.origin.x > -((NSInteger)self.panMinimumOpenThreshold)) ||
                                                 (self.contentViewContainer.frame.origin.x > 0 && self.contentViewContainer.frame.origin.x < self.panMinimumOpenThreshold))) {
            [self hideMenuViewController];
        }
        else if (self.contentViewContainer.frame.origin.x == 0) {
            [self hideMenuViewController:NO];
        }
        else {
            if ([recognizer velocityInView:self.view].x > 0) {
                if (self.contentViewContainer.frame.origin.x < self.view.frame.size.width / 2 - 50) {
                    [self hideMenuViewController];
                } else {
                    if (self.leftMenuViewController) {
                        [self showLeftMenuViewController];
                    }
                }
            } else {
                if (self.contentViewContainer.frame.origin.x < 20) {
                    if (self.rightMenuViewController) {
                        [self showRightMenuViewController];
                    }
                } else {
                    [self hideMenuViewController];
                }
            }
        }
    }
}

#pragma mark --Private Method
- (void)commonInit {
    
    self.isShowRghtMenu = YES;
    self.animationDuration = 0.5f;
    self.contentViewScaleValue = 0.8;
    self.backgroundImageViewScaleValue = 1.7;
    self.menuViewScaleValue = 1;
    self.contentViewInLandscapeOffsetCenterX = 40.0f;
    self.contentViewInPortraitOffsetCenterX = 40.0f;
    self.contentViewFadeOutAlpha = 1;
    self.backgroundImageViewTransformation = CGAffineTransformMakeScale(self.backgroundImageViewScaleValue, self.backgroundImageViewScaleValue);
    self.menuViewControllerTransformation = CGAffineTransformMakeScale(self.menuViewScaleValue, self.menuViewScaleValue);
    self.panMinimumOpenThreshold = 0.0f;
}

- (void)addChildViewController:(UIView *)container childViewController:(UIViewController *)childViewController {
    [self addChildViewController:childViewController];
    childViewController.view.frame = self.view.bounds;
    [container addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

- (void)addContentButton
{
    if (self.contentButton.superview)
        return;
    self.contentButton.autoresizingMask = UIViewAutoresizingNone;
    self.contentButton.frame = self.contentViewContainer.bounds;
    self.contentButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentViewContainer addSubview:self.contentButton];
}

- (void)presentMenuViewContainerWithMenuViewController:(UIViewController *)menuViewController {
    self.backgroundImageView.transform = CGAffineTransformIdentity; //1
    self.backgroundImageView.frame = self.view.bounds; //2
    self.backgroundImageView.transform = self.backgroundImageViewTransformation;
    
    self.menuViewContainer.transform = CGAffineTransformIdentity; //3
    self.menuViewContainer.frame = self.view.bounds; //4
    self.menuViewContainer.transform = self.menuViewControllerTransformation;
    self.menuViewContainer.alpha = 1;
}

- (void)hideMenuViewController {
    [self hideMenuViewController:YES];
}

- (void)hideMenuViewController:(BOOL)animated {
    UIViewController *visibleMenuViewController = self.rightMenuVisible ? self.rightMenuViewController : self.leftMenuViewController;
    [visibleMenuViewController beginAppearanceTransition:NO animated:animated];
    
    self.leftMenuVisible = NO;
    self.rightMenuVisible = NO;
    
    //移除按钮，否则会影响原来的内容视图响应事件
    [self.contentButton removeFromSuperview];
    
    __typeof (self) __weak weakSelf = self;
    void (^animationBlock)(void) = ^{
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        //恢复内容视图的缩放比例为1，重置frame。
        strongSelf.contentViewContainer.transform = CGAffineTransformIdentity;
        strongSelf.contentViewContainer.frame = strongSelf.view.bounds;
        
        //设置背景图和侧边栏的缩放比例
        strongSelf.backgroundImageView.transform = self.backgroundImageViewTransformation;
        strongSelf.menuViewContainer.transform = self.menuViewControllerTransformation;
        
        //设置侧边栏和内容视图的透明度值
        strongSelf.menuViewContainer.alpha = 0;
        strongSelf.contentViewContainer.alpha = 1;
    };
    void (^completionBlock)(void) = ^{
        [visibleMenuViewController endAppearanceTransition];
    };
    
    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:self.animationDuration animations:^{
            animationBlock();
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            completionBlock();
        }];
    } else {
        animationBlock();
        completionBlock();
    }
}

- (void)showLeftMenuViewController {
    if (!self.leftMenuViewController) {
        return;
    }
    //添加一个按钮，这样点击的时候可以显示内容视图，在隐藏侧边栏的时候需要移除这个按钮。
    [self addContentButton];
    
    [self.leftMenuViewController beginAppearanceTransition:YES animated:YES];
    self.leftMenuViewController.view.hidden = NO;
    self.rightMenuViewController.view.hidden = YES;
    [self resetContentViewScale];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        //设置内容视图的缩放比例为0.7
        self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        
        //修改内容视图的center，这样内容视图会右移，左侧留出空间显示侧栏。
        self.contentViewContainer.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetWidth(self.view.frame) : self.contentViewInPortraitOffsetCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y);
        
        //设置menuViewContainer和contentViewContainer的透明度。
        self.menuViewContainer.alpha = 1.0f;
        self.contentViewContainer.alpha = self.contentViewFadeOutAlpha;
        
        //复位背景图和菜单栏的缩放比例。在隐藏左侧栏的方法中，我们会放大背景图和左侧栏。
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.menuViewContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.leftMenuViewController endAppearanceTransition];
        self.leftMenuVisible = YES;
        self.rightMenuVisible = NO;
    }];
}

- (void)showRightMenuViewController
{
    if (!self.rightMenuViewController) {
        return;
    }
    [self.rightMenuViewController beginAppearanceTransition:YES animated:YES];
    self.leftMenuViewController.view.hidden = YES;
    self.rightMenuViewController.view.hidden = NO;
    [self addContentButton];
    [self resetContentViewScale];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        self.contentViewContainer.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetCenterX), self.contentViewContainer.center.y);
        
        self.menuViewContainer.alpha = 1;
        self.contentViewContainer.alpha = self.contentViewFadeOutAlpha;
        self.menuViewContainer.transform = CGAffineTransformIdentity;
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [self.rightMenuViewController endAppearanceTransition];
        self.rightMenuVisible = YES;
        self.leftMenuVisible = NO;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

//防止侧滑过程中出现抖动现象
- (void)resetContentViewScale
{
    CGAffineTransform t = self.contentViewContainer.transform;
    CGFloat scale = sqrt(t.a * t.a + t.c * t.c);//放射变换 涉及到矩阵 水平变换 （b,d垂直变换）
    CGRect frame = self.contentViewContainer.frame;
    self.contentViewContainer.transform = CGAffineTransformIdentity;
    self.contentViewContainer.transform = CGAffineTransformMakeScale(scale, scale);
    self.contentViewContainer.frame = frame;
}

- (void)hideViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

#pragma mark --Public Method
- (void)cancleGesture
{
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
}

- (void)addPanGesture
{
    self.view.multipleTouchEnabled = NO;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)presentLeftMenuViewController {
    [self presentMenuViewContainerWithMenuViewController:self.leftMenuViewController];
    [self showLeftMenuViewController];
}

- (void)presentRightMenuViewController {
    [self presentMenuViewContainerWithMenuViewController:self.rightMenuViewController];
    [self showRightMenuViewController];
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated {
    if (self.contentViewController == contentViewController) {
        return;
    }
    if (!animated) {
        self.contentViewController = contentViewController;
    } else {
        [self addChildViewController:contentViewController];
        contentViewController.view.alpha = 0;
        contentViewController.view.frame = self.contentViewContainer.bounds;
        [self.contentViewContainer addSubview:contentViewController.view];
        [UIView animateWithDuration:self.animationDuration animations:^{
            contentViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [self hideViewController:self.contentViewController];
            self.contentViewController = contentViewController;
            [contentViewController didMoveToParentViewController:self];
        }];
    }
}

#pragma mark --setter/getter
- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

#pragma mark --是否支持横竖屏
- (BOOL)shouldAutorotate
{
    return self.contentViewController.shouldAutorotate; //contentViewController支持旋转，如果不想支持，返回NO即可。
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //只有当侧边栏显示的情况下才需要修改内容视图，这个时候侧边栏缩放是1，只需要设置bounds即可。
    if (self.leftMenuVisible || self.rightMenuVisible) {
        self.menuViewContainer.bounds = self.view.bounds;
        
        //设置新的frame。注意重新设置frame之前需要先将transform置为CGAffineTransformIdentity，否则无效。
        //文档中设置frame属性时有提到: If the transform property is not the identity transform, the value of this property is undefined and therefore should be ignored.
        self.contentViewContainer.transform = CGAffineTransformIdentity;
        self.contentViewContainer.frame = self.view.bounds;
        
        //根据新的frame重新缩放和重新设置center
        self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        
        CGPoint center;
        if (self.leftMenuVisible) {
            center = CGPointMake((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetWidth(self.view.frame) : self.contentViewInPortraitOffsetCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y);
        } else {
            center = CGPointMake((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetCenterX), self.contentViewContainer.center.y);
        }
        self.contentViewContainer.center = center;
    }
}

@end
