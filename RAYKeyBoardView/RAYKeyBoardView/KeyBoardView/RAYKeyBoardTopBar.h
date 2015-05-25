//
//  RAYKeyBoardTopBar.h
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/21.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol RAYKeyBoardTopBarDelegate <NSObject>

- (void)hiddenKeyBoard;

@end



@interface RAYKeyBoardTopBar : UIView

@property (nonatomic, assign) id <RAYKeyBoardTopBarDelegate> delegate;

- (void) setTextFieldsArray:(NSArray *)array ;
- (void) showBar:(id)textField;


@end
