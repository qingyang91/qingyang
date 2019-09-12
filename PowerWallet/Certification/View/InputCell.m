//
//  InputCell.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "InputCell.h"

@interface InputCell ()<UITextFieldDelegate>

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic, readwrite) UITextField *inputTextField;
@property (nonatomic, strong) UIView *tapView;

@end

@implementation InputCell
@synthesize inputValue = _inputValue;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])]) {
        
        self.title.text = title;
        self.inputTextField.placeholder = placeholder;
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.inputTextField];
        
        [self setNeedsUpdateConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}
- (void)setTapAcitonBlock:(BRTapAcitonBlock)tapAcitonBlock {
    _tapAcitonBlock = tapAcitonBlock;
    self.tapView.hidden = NO;
}

- (void)setEndEditBlock:(BREndEditBlock)endEditBlock {
    _endEditBlock = endEditBlock;
    [self.inputView addTarget:self action:@selector(didEndEditTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc]initWithFrame:self.bounds];
        _tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapView];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTextField)];
        [_tapView addGestureRecognizer:myTap];
    }
    return _tapView;
}

- (void)didTapTextField {
    // 响应点击事件时，隐藏键盘
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
    if (self.tapAcitonBlock) {
        self.tapAcitonBlock();
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didEndEditTextField:(UITextField *)textField {
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.title.translatesAutoresizingMaskIntoConstraints) {
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeft);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.title.mas_right).with.offset(20);
            make.left.equalTo(self.contentView.mas_left).with.offset(90);
            make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeft);
            make.top.equalTo(self.contentView.mas_top).with.offset(kPaddingTop);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-kPaddingTop);
        }];
        [self.inputTextField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (void)setInputValue:(NSString *)inputValue {
    self.inputTextField.text = inputValue;
}

- (NSString *)inputValue {
    return self.inputTextField.text;
}
- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] init];
        
        _title.font = Font_Text_Label;
        _title.textColor = Color_SubTitle;
    }
    return _title;
}
- (UITextField *)inputTextField {
    
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.delegate = self;
        _inputTextField.font = Font_Text_Label;
        _inputTextField.textColor = Color_SubTitle;
    }
    return _inputTextField;
}
//***************************************no use**************************************************
- (void)thisIsUselessForSure{
    UIView  *preview;
    UIView *iconView;
    UIView *toolBarView;
    UILabel *sizeLabel;
    if (preview ) {
        if (!iconView) {
            iconView = [[UIView alloc] init];
            iconView.backgroundColor = [UIColor blackColor];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            [preview addSubview:iconView];
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        if (!toolBarView) {
            toolBarView = [UIView new];
            toolBarView.backgroundColor = [UIColor whiteColor];
            [preview addSubview:toolBarView];
        }
        if (!sizeLabel) {
            sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            sizeLabel.textAlignment = NSTextAlignmentCenter;
            sizeLabel.textColor =  [UIColor whiteColor];
            sizeLabel.font = [UIFont systemFontOfSize:14];
            sizeLabel.text = @"正在下载中...";
            [toolBarView addSubview:sizeLabel];
        }
    }
}
//***************************************no use**************************************************
@end
