//
//  RAYKeyBoardView.m
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/21.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYKeyBoardView.h"
#import "RAYKeyBoardBackgroundView.h"
#import "RAYKeyBoardTopBar.h"

@interface RAYKeyBoardView(){

    int selectedMode;
    NSMutableArray *keys;
    
    BOOL isUppercase;
    
}

@property (nonatomic ,strong)UIButton *numberButton;
@property (nonatomic ,strong)UIButton *letterButton;
@property (nonatomic ,strong)UIButton *symbolButton;
@property (nonatomic ,strong)UIButton *okButton;

//@property (nonatomic) int selectedMode;

@property (nonatomic ,strong)RAYKeyBoardBackgroundView *keyBoardBackgroundView;

- (void)clickNumberButton;
- (void)clickLetterButton;
- (void)clickSymbolButton;
- (void)clickOkButton;


@end

@implementation RAYKeyBoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
#pragma mark - life cycle
- (instancetype) init {
    self = [super init];
    if (self) {
//
        keys = [NSMutableArray array];
        
        self.backgroundColor = [UIColor darkGrayColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260-45) ;
        
//        self.keyBoardBackgroundView.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.keyBoardBackgroundView];
        
        self.numberButton.frame = CGRectMake(3, 260 - 90, 78, 39);
        [self addSubview:self.numberButton];
        
        self.letterButton.frame = CGRectMake(81, 260 - 90, 78, 39);
        [self addSubview:self.letterButton];
        
        self.symbolButton.frame = CGRectMake(159, 260 - 90, 78, 39);
        [self addSubview:self.symbolButton];
        
        self.okButton.frame = CGRectMake(243, 260 - 90, 74, 39);
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

}

- (void)clickNumberKey:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberKeySelected:)]) {
        [self.delegate numberKeySelected:button.titleLabel.text];
    }

}

- (void)resetKeys {
    
    for (UIButton *button in keys) {
        [button removeFromSuperview];
    }
    [keys removeAllObjects];
}

- (void) playSound {
    
}

#pragma mark - public method
- (void)keyBoardViewUp {
    if (selectedMode == RAYKeyBoardModeNumber) {
        [self showNumberKeys];
    }
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
        int temp = nums[i];             //首先顺序赋值给  temp
        int tempIndex = arc4random()%9; //获取随即数字
        nums[i] = nums[tempIndex];      //随机数 赋值给 数组
        nums[tempIndex] = temp;         //
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
        
        [keyButton addTarget:self action:@selector(clickNumberKey:) forControlEvents:UIControlEventTouchUpInside];
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
    NSString *letters = @"qwertyuiop";
    for (int i = 0; i < [letters length]; i++) {
        
    }
}

- (void)showSymbolKeys {
    [self resetKeys];
//    NSArray *symbols = @[@"",@"",@""]
}


#pragma mark - getters and setters
- (RAYKeyBoardBackgroundView *)keyBoardBackgroundView {
    if (_keyBoardBackgroundView == nil) {
        _keyBoardBackgroundView = [[RAYKeyBoardBackgroundView alloc] initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, SCREEN_HEIGHT/3+60) keyboardView:self];
        
    }
    return _keyBoardBackgroundView;
}
    
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
