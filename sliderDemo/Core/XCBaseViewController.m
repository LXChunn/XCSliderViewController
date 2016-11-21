//
//  XCBaseViewController.m
//  MVVM-ViewModel-NetWork-Model
//
//  Created by 刘小椿 on 16/11/10.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "XCBaseViewController.h"

@interface XCBaseViewController ()

@property (nonatomic, strong, readwrite) XCRESideMenuViewController *sideMenuViewController; /** < 边栏 */

@end

@implementation XCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark --Set/Get
- (XCRESideMenuViewController *)sideMenuViewController
{
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController) {
        if ([parentViewController isKindOfClass:[XCRESideMenuViewController class]]) {
            return (XCRESideMenuViewController *)parentViewController;
        } else if (parentViewController.parentViewController && parentViewController.parentViewController != parentViewController) {
            parentViewController = parentViewController.parentViewController;
        } else {
            parentViewController = nil;
        }
    }
    return nil;
}

@end

