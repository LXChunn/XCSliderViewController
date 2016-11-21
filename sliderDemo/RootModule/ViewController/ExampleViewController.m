//
//  ExampleViewController.m
//  MVVM-ViewModel-NetWork-Model
//
//  Created by 刘小椿 on 16/11/19.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
}
- (IBAction)leftAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
