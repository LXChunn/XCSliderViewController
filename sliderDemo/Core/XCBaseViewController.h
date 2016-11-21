//
//  XCBaseViewController.h
//  MVVM-ViewModel-NetWork-Model
//
//  Created by 刘小椿 on 16/11/10.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCRESideMenuViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCBaseViewController : UIViewController

@property (nonatomic, strong, readonly) XCRESideMenuViewController *sideMenuViewController;

@end


NS_ASSUME_NONNULL_END