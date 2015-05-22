//
//  RAYKeyBoardTopBar.m
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/21.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYKeyBoardTopBar.h"

@interface RAYKeyBoardTopBar (){
//    UIBarButtonItem *_previousItem;
//    UIBarButtonItem *nextItem;
//    UIBarButtonItem *hiddenItem;
//    UIBarButtonItem *spaceItem;
}

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;
@property (nonatomic, strong) UIBarButtonItem *hiddenItem;
@property (nonatomic, strong) UIBarButtonItem *spaceItem;


@end

@implementation RAYKeyBoardTopBar

#pragma mark -   ！！！！！！！！！！！！！！切忌
#pragma mark - life cycle
- (id)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, 320, 44);
        
        self.toolBar.frame = CGRectMake(0, 0, 320, 44);
        
        [self addSubview:self.toolBar];
        
//        self.previousItem.frame = CGRectMake(10, 10, 54, 30);
//        [self.previousItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        UIBarButtonItem *previous = [[UIBarButtonItem alloc]initWithCustomView:self.previousItem];
        self.toolBar.items = @[self.previousItem ,self.nextItem ,self.spaceItem, self.hiddenItem];
    }
    return self;
}

#pragma mark - Delegate

#pragma mark - event response
- (void) showPrevious {

}
- (void) showNext {

}

- (void) hiddenKeyBoard {

}

- (void) oneFingerTaps {

}

#pragma mark - private methods

#pragma mark - getters and setters
- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc]init];
    }
    return _toolBar;
}

- (UIBarButtonItem *)previousItem{

    if (_previousItem == nil) {
        _previousItem = [[UIBarButtonItem alloc]initWithTitle:@"上一项" style:UIBarButtonItemStylePlain target:self action:@selector(showPrevious)];
//        _previousItem = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_previousItem addTarget:self action:@selector(showPrevious) forControlEvents:UIControlEventTouchUpInside];
//        [_previousItem setTitle:@"上一项" forState:UIControlStateNormal];
        
    }
    return _previousItem;
}

- (UIBarButtonItem *)nextItem{
    if (_nextItem== nil) {
        _nextItem = [[UIBarButtonItem alloc]initWithTitle:@"下一项" style:UIBarButtonItemStyleDone target:self action:@selector(showNext)];
    }
    
    return _nextItem;
}

- (UIBarButtonItem *)hiddenItem{
    if (_hiddenItem == nil) {
        _hiddenItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenKeyBoard)];
    }
    
    return _hiddenItem;
}

- (UIBarButtonItem *)spaceItem{
    if (_spaceItem == nil) {
        _spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    
    return _spaceItem;
}

@end
