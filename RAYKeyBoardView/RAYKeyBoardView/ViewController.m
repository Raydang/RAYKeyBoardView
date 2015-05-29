//
//  ViewController.m
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/21.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "ViewController.h"
#import "RAYKeyBoardView.h"
#import "RAYKeyBoardTopBar.h"
#import "RAYTestViewController.h"

@interface ViewController () <UITextFieldDelegate,RAYKeyBoardViewDelegate, RAYKeyBoardTopBarDelegate>{

    RAYKeyBoardView *boardView;
    RAYKeyBoardTopBar *topBar;
    
    int selectIndex;
    
    RAYTestViewController *test;
    UITapGestureRecognizer *oneFingerTwoTaps;
    
    CGFloat keyboardHeight;
    BOOL keyboardIsShowing;
}

@property (nonatomic, strong) UIView        *animationView;
@property (nonatomic, strong) UIButton      *button;
@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) UITextField   *otherTextField;

@end

@implementation ViewController

#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.animationView];
    [self.animationView addSubview:self.button];
    self.navigationItem.title= @"KeyBoard";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self initKeyboardNotification];
    
    keyboardIsShowing = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    self.animationView.bounds = CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.animationView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    self.button.bounds = CGRectMake(0 , 0, 80, 80);
    self.button.center = CGPointMake(self.animationView.bounds.size.width/2, self.animationView.bounds.size.height-40);
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 40;
    
    boardView = [[RAYKeyBoardView alloc]init];
    topBar    = [[RAYKeyBoardTopBar alloc]init];
    [topBar setTextFieldsArray:@[self.textField,self.otherTextField]];
    
    boardView.delegate = self;
    topBar.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAnimation];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.textField) {
        selectIndex = 0;
    }
    else {
        selectIndex = 1;
    }
    [topBar showBar:textField];
    textField.inputView = boardView;
    textField.inputAccessoryView = topBar;
    
    [boardView keyBoardViewUp];

    return YES;
}

- (void)okButtonSelected {
    if (selectIndex == 0) {
        [self.textField resignFirstResponder];
    }
    else {
        [self.otherTextField resignFirstResponder];
    }
    
    
    if ([self.otherTextField.text isEqualToString:@"0000"]) {
        test = [[RAYTestViewController alloc]init];
        test.view.frame = self.view.bounds;
        [self.navigationController pushViewController:test animated:YES];
    }
    else {
        [self showErrorAlertView];
    }
}

- (void)showErrorAlertView{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"错误❌"
                                                                              message:@"密码错误，正确密码是 0000"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction){
    }];
     [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)keySelected:(NSString *)text {
    
    NSString *outText ;
    if (selectIndex == 0) {
        outText= self.textField.text;
        
        if ([text isEqualToString:@"clear"]) {
            self.textField.text =  [outText substringToIndex:[outText length] -1];
        }
        
        else {
            self.textField.text = [NSString stringWithFormat:@"%@%@",outText,text];
        }
    }
    else {
        outText= self.otherTextField.text;
        
        if ([text isEqualToString:@"clear"]) {
            self.otherTextField.text =  [outText substringToIndex:[outText length] -1];
        }
        
        else {
            self.otherTextField.text = [NSString stringWithFormat:@"%@%@",outText,text];
        }
    }
}

- (void)hiddenKeyBoard {
    
    keyboardIsShowing = YES;
    
    if (selectIndex == 0) {
        [self.textField resignFirstResponder];
    }
    else {
        [self.otherTextField resignFirstResponder];
    }
}
#pragma mark -
#pragma mark Responding to keyboard events
- (void) keyboardWillChangeFrame:(NSNotification *)note {
    /*
     userInfo = {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";                       // 动画的持续时间
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 259}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 697.5}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 438.5}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 568}, {320, 259}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 309}, {320, 259}}";       // 键盘的frame
     }
     */
    
    NSDictionary *userInfo = note.userInfo;
// 动画的持续时间
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
// 动画类型
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
// 键盘最终的frame
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
// 识别横竖屏
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationUnknown:
            break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            keyboardHeight = keyboardFrame.size.height;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            keyboardHeight = keyboardFrame.size.width;
            break;
    }
    CGRect frame = self.animationView.frame;
    
    if (keyboardIsShowing){
        frame.origin.y += 60;
        keyboardIsShowing = NO;
    }
    else {
        keyboardIsShowing = YES;
        frame.origin.y -= 60;
    }


// 执行动画
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:(NSInteger)animationCurve //UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         self.animationView.frame = frame;
    }
                     completion:^(BOOL finished){
                         
    }];
}

#pragma mark -
#pragma mark KeyboardNotification
- (void)initKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark - event response
- (void) clickButton {
    [self.animationView addSubview:self.textField];
    self.textField.frame = CGRectMake(-280, 260, 280, 40);
    self.textField.delegate = self;
    
    [self.animationView addSubview:self.otherTextField];
    self.otherTextField.frame = CGRectMake(-280, 320, 280, 40);
    self.otherTextField.delegate = self;
    
    
    [UIView animateWithDuration:1
                          delay:2
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.button.layer.rasterizationScale = 3;
    }
                     completion:^(BOOL finish){
                                                  self.button.layer.rasterizationScale = 1;
    }];
    
    
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear //动画的时间曲线，线性比较合理
                     animations:^{
                         self.textField.frame = CGRectMake(20, 260, 280, 40);
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.5
                                               delay:0
                                             options:UIViewAnimationOptionCurveLinear //动画的时间曲线，线性比较合理
                                          animations:^{
                                              
                                              self.otherTextField.frame = CGRectMake(20, 320, 280, 40);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }
                          ];
                     }
     ];
}

- (void) oneFingerTwoTaps: (UITapGestureRecognizer*)gesture{
    
    CGPoint touchPoint = [gesture locationInView:self.animationView];
    
    NSLog(@"pt:%f %f",touchPoint.x,touchPoint.y);
    
    if ([ self.button.layer.presentationLayer hitTest:touchPoint]) {
        [self clickButton];
        NSLog(@"click");
    }
}

#pragma mark -
#pragma mark - private methods
-(void)startAnimation {
    [UIView animateWithDuration:8.0
                          delay:0
                        options:UIViewAnimationOptionRepeat //动画重复的主开关
          |UIViewAnimationOptionAutoreverse //动画重复自动反向，需要和上面这个一起用
     |UIViewAnimationOptionCurveLinear //动画的时间曲线，线性比较合理
                     animations:^{
                        self.button.center = CGPointMake(self.animationView.bounds.size.width/2, 40);
                        self.button.backgroundColor = [UIColor darkGrayColor];
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

#pragma mark -
#pragma mark - getters and setters
- (UIView   *)animationView {
    if (_animationView == nil) {
        _animationView = [[UIView alloc]initWithFrame:CGRectZero];
        _animationView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        // 创建一个手势识别器
        oneFingerTwoTaps =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTwoTaps:)] ;
        [oneFingerTwoTaps setNumberOfTapsRequired:2];
        [oneFingerTwoTaps setNumberOfTouchesRequired:1];
        
        // Add the gesture to the view
        [_animationView addGestureRecognizer:oneFingerTwoTaps];
    }
    return _animationView;
}

- (UIButton *)button {

    if(_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.backgroundColor = [UIColor lightGrayColor];
        [_button setTitle:@"点我啊" forState:UIControlStateNormal];
//        [_button setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:28];
        _button.titleLabel.lineBreakMode = 0;
        _button.userInteractionEnabled = NO;
        [_button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点我啊"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1,1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(2,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12.0] range:NSMakeRange(0, 1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:34.0] range:NSMakeRange(1, 1)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:16.0] range:NSMakeRange(2, 1)];
        _button.titleLabel.attributedText = str;

    }
    return _button;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc]init];
        _textField.text = @"    账号 ：";
        _textField.font = [UIFont systemFontOfSize: 18];
        _textField.layer.borderColor = [UIColor grayColor].CGColor;
        _textField.layer.borderWidth = 1;
        _textField.layer.cornerRadius= 6;
        
    }
    return _textField;
}

- (UITextField *)otherTextField {
    if (_otherTextField == nil) {
        _otherTextField = [[UITextField alloc]init];
        _otherTextField.text = @"    密码 ：";
        _otherTextField.font = [UIFont systemFontOfSize: 18];
        _otherTextField.layer.borderColor = [UIColor grayColor].CGColor;
        _otherTextField.layer.borderWidth = 1;
        _otherTextField.layer.cornerRadius= 6;
        
    }
    return _otherTextField;
}

@end
