//
//  RESideMenu.h
//  RESideMenuPractice
//
//  Created by ssj on 2016/7/24.
//  Copyright © 2016年 ease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCRESideMenuViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIViewController *leftMenuViewController;
@property (strong, nonatomic) UIViewController *rightMenuViewController;

/**
 *  推出左边栏
 */
- (void)presentLeftMenuViewController;

/**
 *  推出右边栏 需要设置BOOL isShowRghtMenu ＝ YES (默认是NO)
 */
- (void)presentRightMenuViewController;

/**
 *  添加手势
 */
- (void)addPanGesture;

/**
 *  移除手势
 */
- (void)cancleGesture;

/**
 *  隐藏侧边栏
 */
- (void)hideMenuViewController;

/**
 *  更换主视图内容
 *
 *  @param contentViewController 主控制器
 *  @param animated              动画
 */
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

@end
