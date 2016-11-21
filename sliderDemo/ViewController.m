//
//  ViewController.m
//  sliderDemo
//
//  Created by 刘小椿 on 16/11/21.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)leftAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)rightAction:(id)sender {
    [self.sideMenuViewController presentRightMenuViewController];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
