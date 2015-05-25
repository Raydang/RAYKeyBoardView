//
//  RAYKeyBoardView.h
//  RAYKeyBoardView
//
//  Created by richerpay on 15/5/21.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

typedef  NS_ENUM(NSInteger, RAYKeyBoardMode) {
    
    RAYKeyBoardModeNumber,
    RAYKeyBoardModeLetter,
    RAYKeyBoardModeSymbol,
};

@protocol RAYKeyBoardViewDelegate<NSObject>

- (void)okButtonSelected;
- (void)keySelected:(NSString *)text;

@end




@interface RAYKeyBoardView : UIView

@property (nonatomic, assign) id <RAYKeyBoardViewDelegate> delegate;

- (void)keyBoardViewUp;

@end
