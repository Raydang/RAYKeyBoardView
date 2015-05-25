//
//  RAYKeyBoardTopBar.m
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/21.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYKeyBoardTopBar.h"

@interface RAYKeyBoardTopBar (){
    NSArray *textFields;
    UITextField *currentTextField;

}

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;
@property (nonatomic, strong) UIBarButtonItem *hiddenItem;
@property (nonatomic, strong) UIBarButtonItem *spaceItem;


@end

@implementation RAYKeyBoardTopBar

#pragma mark -   ！！！！！！！！！！！！！！切记
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
        
        currentTextField = nil;
    }
    return self;
}

#pragma mark - Delegate

#pragma mark - event response
- (void) showPrevious {
    if (textFields == nil) {
        return;
    }
    
    
    NSInteger num = -1;

    for (id txt in textFields) {
        if(txt == currentTextField) {
            num = [textFields indexOfObject:txt];
        }
    }
    
    if (num >0) {
        [[textFields objectAtIndex:num] resignFirstResponder];
        [[textFields objectAtIndex:num-1] becomeFirstResponder];
    }
}

- (void) showNext {

    if (textFields == nil) {
        return;
    }
    
    NSInteger num = -1;

    for (id txt in textFields) {
        if(txt == currentTextField) {
            num = [textFields indexOfObject:txt];
        }
    }
    if (num <[textFields count] -1) {
        [[textFields objectAtIndex:num] resignFirstResponder];
        [[textFields objectAtIndex:num+1] becomeFirstResponder];
    }
    
}

- (void) hiddenKeyBoard {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenKeyBoard)]) {
        [self.delegate hiddenKeyBoard];
    }
}

#pragma mark - private methods

- (void) setTextFieldsArray:(NSArray *)array  {
    
    textFields = array;
}

- (void) showBar:(id)textField {
    currentTextField = textField;
    
    NSInteger num = -1;

    for (id txt in textFields) {
        if(txt == currentTextField) {
            num = [textFields indexOfObject:txt];
        }
    }
    
    if (num >0) {
        self.previousItem.enabled = YES;
    }
    else {
        self.previousItem.enabled = NO;
    }
    
    if (num <[textFields count]-1) {
        
        self.nextItem.enabled = YES;
    }
    else {
        self.nextItem.enabled = NO;
    }
}

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
