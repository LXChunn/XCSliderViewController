//
//  LeftMenuViewController.m
//  MVVM-ViewModel-NetWork-Model
//
//  Created by 刘小椿 on 16/11/19.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
- (IBAction)goToMainViewController:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [self.sideMenuViewController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)goToNewViewController:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Root" bundle:[NSBundle mainBundle]];
    [self.sideMenuViewController setContentViewController:[storyboard instantiateViewControllerWithIdentifier:@"ExampleViewController"] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
