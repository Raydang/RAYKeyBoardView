//
//  RAYKeyBoardBackgroundView.m
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/21.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYKeyBoardBackgroundView.h"
//#import "RAYKeyBoardView.m"

@interface RAYKeyBoardBackgroundView()

@property (nonatomic, strong) RAYKeyBoardView *keyBoardView;

@end

@implementation RAYKeyBoardBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -
#pragma mark - init and inherit
- (id)initWithFrame:(CGRect)frame keyboardView :(RAYKeyBoardView *)keyBoard {
    self= [super initWithFrame:frame];
    if (self) {
        self.keyBoardView = keyBoard;
//        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor grayColor] CGColor]);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 60, 320, 216));
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
    
}

#pragma mark - event response

#pragma mark - private methods

#pragma mark - getters and setters

@end
