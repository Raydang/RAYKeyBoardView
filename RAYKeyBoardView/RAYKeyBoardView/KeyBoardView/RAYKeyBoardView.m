//
//  RAYKeyBoardView.m
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/21.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYKeyBoardView.h"


@interface RAYKeyBoardView(){

    int selectedMode;
    
    NSMutableArray *keys;

    BOOL isUppercase;
    BOOL isFirstPage;
}

@property (nonatomic ,strong)UIButton *numberButton;
@property (nonatomic ,strong)UIButton *letterButton;
@property (nonatomic ,strong)UIButton *symbolButton;
@property (nonatomic ,strong)UIButton *okButton;

- (void)clickNumberButton;
- (void)clickLetterButton;
- (void)clickSymbolButton;
- (void)clickOkButton;

@end

@implementation RAYKeyBoardView

#pragma mark -
#pragma mark - life cycle
- (instancetype) init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 215) ;
        self.backgroundColor = [UIColor clearColor];
        self.hidden =YES;

        keys = [NSMutableArray array];
        
        self.numberButton.frame = CGRectMake(3, 170, 78, 39);
        [self addSubview:self.numberButton];
        
        self.letterButton.frame = CGRectMake(81, 170, 78, 39);
        [self addSubview:self.letterButton];
        
        self.symbolButton.frame = CGRectMake(159, 170, 78, 39);
        [self addSubview:self.symbolButton];
        
        self.okButton.frame = CGRectMake(243, 170, 74, 39);
        [self addSubview:self.okButton];
        
    }
    return self;
}

#pragma mark - Delegate

#pragma mark - event response

- (void)clickNumberButton {
    if (!self.numberButton.isSelected) {
        [self changeMode:RAYKeyBoardModeNumber];
    }
}

- (void)clickLetterButton {
    if (!self.letterButton.isSelected) {
        [self changeMode:RAYKeyBoardModeLetter];
    }
}

- (void)clickSymbolButton {
    if (!self.symbolButton.isSelected) {
        [self changeMode:RAYKeyBoardModeSymbol];
    }
}

- (void)clickOkButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonSelected)]) {
        [self.delegate okButtonSelected];
    }
}

- (void)clickClearButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keySelected:)]) {
        [self.delegate keySelected:@"clear"];
    }
}

- (void)clickSwitchButton:(UIButton *)button {
    
    NSArray *symbolArray ;
    if (isFirstPage) {
        isFirstPage = NO;
        symbolArray = @[@"\"",@"`",@".",@"!",@";",@":",@"*",@"@",@"$",@"%",@"&",@"#",@"<",@">",@"[",@"]"];
        
        [button setTitle:@"1/2" forState:UIControlStateNormal];
    }
    else {
        isFirstPage = YES;
        
        symbolArray = @[@"'",@"^",@",",@"?",@"\\",@"/",@"~",@"_",@"-",@"+",@"=",@"#|",@"(",@")",@"{",@"}"];
        [button setTitle:@"2/2" forState:UIControlStateNormal];
    }
    for (int i = 0; i <16; i++) {
        UIButton *tempButton = [keys objectAtIndex:i];
        [tempButton setTitle:[symbolArray objectAtIndex:i] forState:UIControlStateNormal];
    }
}

- (void)clickUppercaseButtonButton:(UIButton *)button {
    if (isUppercase) {
        isUppercase = NO;
        [button setImage:IMAGE(@"kb_zm_icon1.png") forState:UIControlStateNormal];
    }
    else {
        isUppercase = YES;
        [button setImage:IMAGE(@"kb_zm_icon2.png") forState:UIControlStateNormal];
    }
    for (int i = 0; i <26; i++) {
        UIButton *tempButton = [keys objectAtIndex:i];
        if (isUppercase) {
            NSString *string =  [tempButton.titleLabel.text uppercaseString];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 1)];

            [tempButton setAttributedTitle:str forState:UIControlStateNormal];
        }
        else {
            NSString *string =  [tempButton.titleLabel.text lowercaseString];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23] range:NSMakeRange(0, 1)];
            [tempButton setAttributedTitle:str forState:UIControlStateNormal];
        }
    }
}

- (void)clickKey:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keySelected:)]) {
        [self.delegate keySelected:button.titleLabel.text];
    }
}

- (void)resetKeys {
    
    for (UIButton *button in keys) {
        [button removeFromSuperview];
    }
    [keys removeAllObjects];
}

- (void) playSound {
    AudioServicesPlaySystemSound(1004);
}

#pragma mark - public method
- (void)keyBoardViewUp {
    if (selectedMode == RAYKeyBoardModeNumber) {
        [self showNumberKeys];
    }
    self.hidden = NO;
}

#pragma mark - private method
- (void)changeMode:(RAYKeyBoardMode) mode {
    
    switch (selectedMode) {
        case RAYKeyBoardModeNumber:
            [self.numberButton setSelected:NO];
            break;
            
        case RAYKeyBoardModeLetter:
            [self.letterButton setSelected:NO];
            break;
            
        case RAYKeyBoardModeSymbol:
            [self.symbolButton setSelected:NO];
            break;
            
        default:
            break;
    }
    selectedMode = mode;

    switch (selectedMode) {
        case RAYKeyBoardModeNumber:
            [self.numberButton setSelected:YES];
            [self showNumberKeys];
            break;
            
        case RAYKeyBoardModeLetter:
            [self.letterButton setSelected:YES];
            [self showLetterKeys];
            break;
            
        case RAYKeyBoardModeSymbol:
            [self.symbolButton setSelected:YES];
            [self showSymbolKeys];
            break;
            
        default:
            break;
    }
}

- (void) showNumberKeys {
    
    [self resetKeys];
//    处理随机数
    int nums[] = {0,1,2,3,4,5,6,7,8,9};
//    键的坐标
    int numsKeyX[] = {3, 83,163,243,
        3,83,163,
        3,83,163 };
    int numsKeyY[] = {70,70,70,70,
        124,124,124,
        178,178,178 };

    for (int i= 0; i< 10; i++) {
        int temp = nums[i];             //首先顺序赋值给  中间变量temp  0
        int tempIndex = arc4random()%9; //获取随即数字    tempIndex
        nums[i] = nums[tempIndex];      //以随机数为序数的值 赋值给 数组
        nums[tempIndex] = temp;         //将中间变量的值 赋值给 以随机数位序数的
    }
    
    UIImage *image   = IMAGE(@"kb_sz_bg.png");
    UIImage *imageOn = IMAGE(@"kb_sz_bg_on.png");
    
    for (int i= 0; i< 10; i++) {
        UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyButton.frame = CGRectMake(numsKeyX[i], numsKeyY[i]-16 -45, 74, 47);
        keyButton.titleLabel.font = [UIFont systemFontOfSize:23];
        [keyButton setTitle:[NSString stringWithFormat:@"%d",nums[i]] forState:UIControlStateNormal];
        [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [keyButton setBackgroundImage:image forState:UIControlStateNormal];
        [keyButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [keyButton addTarget:self action:@selector(clickKey:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyButton];
        
        [keys addObject:keyButton];
    }
    
    image   = IMAGE(@"kb_sz_back.png");
    imageOn = IMAGE(@"kb_sz_back_on.png");
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(243, 108-45, 74, 101);
    
    [clearButton setBackgroundImage:image forState:UIControlStateNormal];
    [clearButton setBackgroundImage:imageOn forState:UIControlStateSelected];
    
    [clearButton addTarget:self action:@selector(clickClearButton) forControlEvents:UIControlEventTouchUpInside];
    [clearButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:clearButton];
    [keys addObject:clearButton];
    
}
- (void)showLetterKeys {
    
    [self resetKeys];

    UIImage *image   = IMAGE(@"kb_zm_bg.png");
    UIImage *imageOn = IMAGE(@"kb_zm_bg_on.png");

    
    NSString *letters = @"qwertyuiop";
    
    for (int i = 0; i < [letters length]; i++) {
        
        UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyButton.titleLabel.font = [UIFont systemFontOfSize:23];
        [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [keyButton setBackgroundImage:image forState:UIControlStateNormal];
        [keyButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [keyButton addTarget:self action:@selector(clickKey:) forControlEvents:UIControlEventTouchUpInside];
        [keyButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
        keyButton.frame = CGRectMake(3+32*i, 70-61, 26, 39);

        [keyButton setTitle:[NSString stringWithFormat:@"%@",[letters substringWithRange:NSMakeRange(i, 1)]] forState:UIControlStateNormal];
        
        [self addSubview:keyButton];
        [keys addObject:keyButton];

    }

    letters = @"asdfghjkl";
    for (int i = 0; i < [letters length]; i++) {

        UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyButton.titleLabel.font = [UIFont systemFontOfSize:23];
        [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [keyButton setBackgroundImage:image forState:UIControlStateNormal];
        [keyButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [keyButton addTarget:self action:@selector(clickKey:) forControlEvents:UIControlEventTouchUpInside];
        [keyButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
        keyButton.frame = CGRectMake(16+32*i, 124-61, 26, 39);
        
        [keyButton setTitle:[NSString stringWithFormat:@"%@",[letters substringWithRange:NSMakeRange(i, 1)]] forState:UIControlStateNormal];
        
        [self addSubview:keyButton];
        [keys addObject:keyButton];
        
    }
    letters = @"zxcvbnm";
    for (int i = 0; i < [letters length]; i++) {
        
        
        UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyButton.titleLabel.font = [UIFont systemFontOfSize:23];
        [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [keyButton setBackgroundImage:image forState:UIControlStateNormal];
        [keyButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [keyButton addTarget:self action:@selector(clickKey:) forControlEvents:UIControlEventTouchUpInside];
        [keyButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
        keyButton.frame = CGRectMake(51+32*i, 178-61, 26, 39);
        
        [keyButton setTitle:[NSString stringWithFormat:@"%@",[letters substringWithRange:NSMakeRange(i, 1)]] forState:UIControlStateNormal];
        
        [self addSubview:keyButton];
        [keys addObject:keyButton];
        
    }
    
    //切换
    image   = IMAGE(@"kb_zm_back_bg.png");
    imageOn = IMAGE(@"kb_zm_back_bg_on.png");
    UIButton *uppercaseButton = [[UIButton alloc]initWithFrame:CGRectMake(3, 178 -61, 42, 39)];
    [uppercaseButton setImage:IMAGE(@"kb_zm_icon1.png") forState:UIControlStateNormal];
    [uppercaseButton setBackgroundImage:image forState:UIControlStateNormal];
    [uppercaseButton setBackgroundImage:imageOn forState:UIControlStateHighlighted];
    
    [uppercaseButton addTarget:self action:@selector(clickUppercaseButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    [uppercaseButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:uppercaseButton];
    [keys addObject:uppercaseButton];
// 清除
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(275, 178-61, 42, 39);
    [clearButton setImage:IMAGE(@"kb_zm_icon3.png") forState:UIControlStateNormal];
    [clearButton setBackgroundImage:image forState:UIControlStateNormal];
    [clearButton setBackgroundImage:imageOn forState:UIControlStateSelected];
    
    [clearButton addTarget:self action:@selector(clickClearButton) forControlEvents:UIControlEventTouchUpInside];
    [clearButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:clearButton];
    [keys addObject:clearButton];


}

- (void)showSymbolKeys {
    [self resetKeys];
    NSArray *symbols = @[@"\"",@"`",@".",@"!",@";",@":",@"*",@"@",@"$",@"%",@"&",@"#",@"<",@">",@"[",@"]"];
    int symbolKeysX[] = {3,56,109,162,215,268,
                  3,56,109,162,215,268,
                  56,109,162,215};
    int symbolsKeyY[] = {70,70,70,70,70,70,
                124,124,124,124,124,124,
                178,178,178,178};
    UIImage *image   = IMAGE(@"kb_fh_bg.png");
    UIImage *imageOn = IMAGE(@"kb_fh_bg_on.png");
    
    for (int i = 0; i < 16; i++) {
        UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyButton.frame = CGRectMake(symbolKeysX[i], symbolsKeyY[i]-61, 47, 41);
        keyButton.titleLabel.font = [UIFont systemFontOfSize:23];
        [keyButton setTitle:[NSString stringWithFormat:@"%@",symbols[i]] forState:UIControlStateNormal];
        [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [keyButton setBackgroundImage:image forState:UIControlStateNormal];
        [keyButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [keyButton addTarget:self action:@selector(clickKey:) forControlEvents:UIControlEventTouchUpInside];
        [keyButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:keyButton];
        [keys addObject:keyButton];
    }
    //切换模式
    image   = IMAGE(@"kb_fh_back_bg.png");
    imageOn = IMAGE(@"kb_fh_back_bg_on.png");
    UIButton *switchButton = [[UIButton alloc]initWithFrame:CGRectMake(3, 117, 47, 41)];
    switchButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [switchButton setTitle:@"1/2" forState:UIControlStateNormal];
    [switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [switchButton setBackgroundImage:image forState:UIControlStateNormal];
    [switchButton setBackgroundImage:imageOn forState:UIControlStateHighlighted];
    [switchButton addTarget:self action:@selector(clickSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    [switchButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:switchButton];
    [keys addObject:switchButton];
    
    //清除按钮
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(270, 117 , 47, 41)];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:18];

    [clearButton setImage:IMAGE(@"kb_zm_icon3.png")  forState:UIControlStateNormal];
    [clearButton setBackgroundImage:image forState:UIControlStateNormal];
    [clearButton setBackgroundImage:imageOn forState:UIControlStateHighlighted];
    [clearButton addTarget:self action:@selector(clickClearButton) forControlEvents:UIControlEventTouchUpInside];
    [clearButton addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:clearButton];
    [keys addObject:clearButton];
}

#pragma mark - getters and setters
- (UIButton *)numberButton {
    
    if (_numberButton == nil) {
        _numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_numberButton setTitle:@"数字" forState:UIControlStateNormal];
        _numberButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_numberButton addTarget:self action:@selector(clickNumberButton) forControlEvents:UIControlEventTouchUpInside];
        _numberButton.adjustsImageWhenHighlighted = NO;
        
        UIImage *image   = IMAGE(@"kb_nav_bg1.png");
        UIImage *imageOn = IMAGE(@"kb_nav_bg1_on.png");
        
        [_numberButton setBackgroundImage:image forState:UIControlStateNormal];
        [_numberButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [_numberButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_numberButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        _numberButton.selected = YES;

        
    }
    return _numberButton;
}
    
- (UIButton *)letterButton {
    
    if (_letterButton == nil) {
        _letterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_letterButton setTitle:@"字母" forState:UIControlStateNormal];
        _letterButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [_letterButton addTarget:self action:@selector(clickLetterButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image   = IMAGE(@"kb_nav_bg2.png");
        UIImage *imageOn = IMAGE(@"kb_nav_bg2_on.png");
        
        [_letterButton setBackgroundImage:image forState:UIControlStateNormal];
        [_letterButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [_letterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_letterButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return _letterButton;
}
    
- (UIButton *)symbolButton {
    
    if (_symbolButton == nil) {
        _symbolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_symbolButton setTitle:@"符号" forState:UIControlStateNormal];
        _symbolButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_symbolButton addTarget:self action:@selector(clickSymbolButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image   = IMAGE(@"kb_nav_bg3.png");
        UIImage *imageOn = IMAGE(@"kb_nav_bg3_on.png");
        
        [_symbolButton setBackgroundImage:image forState:UIControlStateNormal];
        [_symbolButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [_symbolButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_symbolButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    
    return _symbolButton;
}

- (UIButton *)okButton {

    if (_okButton == nil) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_okButton addTarget:self action:@selector(clickOkButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image   = IMAGE(@"kb_enter.png");
        UIImage *imageOn = IMAGE(@"kb_enter_on.png");
        
        [_okButton setBackgroundImage:image forState:UIControlStateNormal];
        [_okButton setBackgroundImage:imageOn forState:UIControlStateSelected];
        
        [_okButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
    }
    return _okButton;
}

@end
