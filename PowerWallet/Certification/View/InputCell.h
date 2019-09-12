//
//  InputCell.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BRTapAcitonBlock)();
typedef void(^BREndEditBlock)(NSString *text);

@interface InputCell : UITableViewCell

@property (strong, nonatomic) NSString *inputValue;
@property (strong, nonatomic, readonly) UITextField *inputTextField;
/** textField 的点击回调 */
@property (nonatomic, copy) BRTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) BREndEditBlock endEditBlock;
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
