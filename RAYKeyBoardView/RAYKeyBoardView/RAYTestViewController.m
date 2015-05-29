//
//  RAYTestViewController.m
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/29.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYTestViewController.h"

@interface RAYTestViewController ()

@end

@implementation RAYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.navigationItem.title= @"TEST";

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor redColor];
        self.navigationController.navigationBarHidden = NO;
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
