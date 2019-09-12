//
//  KDXieYiBtn.h
//  Krisc.Zampono
//
//  Created by haoran on 16/5/27.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDXieYiBtn : UIView
@property (nonatomic, retain) UIButton *xieyiBtn;
/**
 *  协议按钮初始化
 *
 *
 *
 *  @return button实例
 */
- (instancetype)initWithXieyiName:(NSArray *)nameArr;
-(void)chageFrame;
//协议block
@property (nonatomic, copy) dispatch_block_t xieyiLabelTapBlock;
@property (nonatomic, copy) dispatch_block_t xieyiLabel2TapBlock;
@property (nonatomic, copy) dispatch_block_t xieyiLabel3TapBlock;
@property (nonatomic, copy) dispatch_block_t xieyiBtnTapBlock;
@property (nonatomic, copy) dispatch_block_t xieyiBtn2TapBlock;
@end
