//
//  RAYTestViewController.m
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/29.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYTestViewController.h"

@interface RAYTestViewController ()

@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation RAYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title= @"TEST";
    [self.view addSubview:self.imageView];;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    self.navigationController.navigationBarHidden = NO;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [self spin];
//    });
    
}
                   

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) spin {
    [UIView  animateWithDuration:1
                           delay:0
                         options:UIViewAnimationCurveLinear|UIViewAnimationOptionCurveLinear
                      animations:^{
//                          self.imageView.transform = CGAffineTransformMakeRotation(M_PI) ;
                          self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
                          
                      }
                      completion:^(BOOL finished ){
                          [self spin];
                          
                      }
     
     ];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
    return scaledImage;
                                
    }

- (UIImageView *)imageView {
    if (_imageView== nil) {
        UIImage *image = [[UIImage alloc]init];;
        image = [self scaleImage:[UIImage imageNamed:@"logo"] toScale:0.3];
        _imageView =[[UIImageView alloc]initWithImage:image];

    }
    return _imageView;
}

@end
