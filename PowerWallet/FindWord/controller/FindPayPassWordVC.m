//
//  FindPayPassWordVC.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/29.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "FindPayPassWordVC.h"
#import "UserManager.h"
#import "KDKeyboardView.h"
#import "KDCustomTextField.h"
#import "NSString+Frame.h"
#import "ValidatorUtil.h"
#import "NewPasswordVC.h"
#import "PayPassWordRequest.h"
@interface FindPayPassWordVC ()<UITextFieldDelegate,KDTextfieldDelegate>

@property(nonatomic,retain)UIScrollView *baseView;
@property(nonatomic,retain)UILabel* tipLabel;
@property(nonatomic,retain)UITextField* phoneNum;
@property(nonatomic,retain)UITextField* trueName;
@property(nonatomic,retain)UITextField* idCard;
@property(nonatomic,retain)UITextField* messageKey;
@property(nonatomic,retain)UIButton* getMessageKey;
@property(nonatomic,retain)UIButton* button;

@property(nonatomic,assign)int timeText;
@property(nonatomic,retain)NSTimer* timer;

@property(nonatomic,retain)NSArray* yArray;

@property(nonatomic,retain)UIView* lineView;
@property(nonatomic,retain)UIView* backView;
@property(nonatomic,retain)NSString* tempStr;

@property(nonatomic,assign)BOOL sendCode;
@property(nonatomic, strong) PayPassWordRequest *requestPayPassWord;

@end

@implementation FindPayPassWordVC

#pragma mark - VC生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"找回交易密码";
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - View创建与设置

- (void)setUpView{
    [self baseSetup:PageGobackTypePop];
    [self setUpDataSource];
    //创建视图等
    _sendCode = YES;
    self.view.backgroundColor = Color_White;
    _baseView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _baseView.backgroundColor = Color_White;
    [self.view addSubview:_baseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyBoards)];
    [self.view addGestureRecognizer:tap];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tipLabel.font = [UIFont systemFontOfSize:13.0f];
    _tipLabel.textColor = [UIColor orangeColor];
    [_baseView addSubview:_tipLabel];
    
    _phoneNum = [[KDCustomTextField alloc] initWithFrame:CGRectMake(15, 30, self.view.frame.size.width-30, 44) andGap:40];
    [_phoneNum.layer setMasksToBounds:YES];
    [_phoneNum.layer setCornerRadius:3.0f];
    [_phoneNum.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    [_phoneNum addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_phoneNum.layer setBorderWidth:0.5f];
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum.placeholder = @"请输入手机号";
    _phoneNum.delegate = self;
    [_baseView addSubview:_phoneNum];
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/2, 44)];
    UIImageView* imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
    imageview1.frame = CGRectMake(12, 13, 11.5, 20);
    [view1 addSubview:imageview1];
    _phoneNum.leftView = view1;
    _phoneNum.leftViewMode = UITextFieldViewModeAlways;
    _phoneNum.text = [UserManager sharedUserManager].userInfo.username;
    _phoneNumber = [UserManager sharedUserManager].userInfo.username;
    
    if (_phoneNum.text.length>0) {
        _phoneNum.text = [NSString stringWithFormat:@"%@****%@",[_phoneNum.text substringToIndex:3],[_phoneNum.text substringFromIndex:7]];
    }
    
    [_phoneNum setUserInteractionEnabled:NO];
    
    _trueName = [[KDCustomTextField alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8, self.view.frame.size.width-30, 44) andGap:40];
    [_trueName.layer setMasksToBounds:YES];
    [_trueName.layer setCornerRadius:3.0f];
    [_trueName.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    [_trueName addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_trueName.layer setBorderWidth:0.5f];
    _trueName.placeholder = @"请输入真实姓名";
    _trueName.clearButtonMode = UITextFieldViewModeWhileEditing | UITextFieldViewModeUnlessEditing;
    _trueName.delegate = self;
    [_baseView addSubview:_trueName];
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/2, 44)];
    UIImageView* imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userLogin"]];
    imageview2.frame = CGRectMake(11, 13.5, 13, 17);
    [view2 addSubview:imageview2];
    _trueName.leftView = view2;
    _trueName.leftViewMode = UITextFieldViewModeAlways;
    
    _idCard = [[KDCustomTextField alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8 + 44 + 8, self.view.frame.size.width-30, 44) andGap:40];
    [_idCard.layer setMasksToBounds:YES];
    [_idCard.layer setCornerRadius:3.0f];
    [_idCard.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    [_idCard addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_idCard.layer setBorderWidth:0.5f];
    _idCard.placeholder = @"请输入身份证号";
    _idCard.clearButtonMode = UITextFieldViewModeWhileEditing |UITextFieldViewModeUnlessEditing;
    _idCard.delegate = self;
    [_baseView addSubview:_idCard];
    
    [KDKeyboardView KDKeyBoardWithKdKeyBoard:KDIDNUM target:self textfield:_idCard delegate:self valueChanged:@selector(textFieldChanged:)];
    
    UIView* view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/2, 44)];
    UIImageView* imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"idcardgray"]];
    imageview3.frame = CGRectMake(7, 16, 19, 13.5);
    [view3 addSubview:imageview3];
    _idCard.leftView = view3;
    _idCard.leftViewMode = UITextFieldViewModeAlways;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8 + 44 + 8 + 44 + 8, self.view.frame.size.width-30, 44)];
    [_backView.layer setMasksToBounds:YES];
    [_backView.layer setBorderWidth:0.5f];
    [_backView.layer setCornerRadius:3.0f];
    [_backView.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    [_baseView addSubview:_backView];
    
    _messageKey = [[KDCustomTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30 - 70, 44) andGap:40];
    [_messageKey.layer setMasksToBounds:YES];
    [_messageKey.layer setCornerRadius:3.0f];
    [_messageKey addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _messageKey.keyboardType = UIKeyboardTypeNumberPad;
    _messageKey.placeholder = @"请输入短信验证码";
    _messageKey.clearButtonMode = UITextFieldViewModeWhileEditing |UITextFieldViewModeUnlessEditing;
    _messageKey.delegate = self;
    [_backView addSubview:_messageKey];
    [KDKeyboardView KDKeyBoardWithKdKeyBoard:PHONECODE target:self textfield:_messageKey delegate:self valueChanged:@selector(textFieldChanged:)];
    UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/2, 44)];
    UIImageView* imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messageregist"]];
    imageview4.frame = CGRectMake(7, 16, 19, 13.5);
    [view4 addSubview:imageview4];
    _messageKey.leftView = view4;
    _messageKey.leftViewMode = UITextFieldViewModeAlways;
    NSString *title = @"获取验证码";
    CGFloat twidth = [title widthWithFontSize:12.f];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40-twidth, 0, 0.5, _messageKey.frame.size.height)];
    _lineView.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
    [_backView addSubview:_lineView];
    _getMessageKey = [[UIButton alloc] initWithFrame:CGRectMake(_lineView.frame.origin.x+4, _messageKey.frame.origin.y, twidth, 44)];
    [_getMessageKey setTitle:title forState:UIControlStateNormal];
    [_getMessageKey setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _getMessageKey.titleLabel.font = [UIFont systemFontOfSize:12];
    [_getMessageKey addTarget:self action:@selector(getMessagekeyTouch) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_getMessageKey];
    _button = [[UIButton alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8 + 44 + 8 + 44 + 8 + 44 + 8, self.view.frame.size.width-30, 45)];
    [_button setTitle:@"下一步" forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor colorWithHex:0xb7b7b7]];
    _button.titleLabel.font = [UIFont systemFontOfSize:17];
    [_button.layer setCornerRadius:3.0];
    _button.userInteractionEnabled = NO;
    [_button addTarget:self action:@selector(nextTouch) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_button];
}

#pragma mark - 初始化数据源

- (void)setUpDataSource{
    
}
#pragma mark - 按钮事件

- (void)hideAllKeyBoards{
    NSMutableArray *subviews = [NSMutableArray arrayWithArray:[_baseView subviews]];
    [subviews addObjectsFromArray:[_backView subviews]];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
                [_baseView setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            }
        }
    }
}
- (void)getMessagekeyTouch{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
        _baseView.frame = self.view.bounds;
    }];
    
    [_getMessageKey setTitleColor:[UIColor colorWithHex:0xdddddd] forState:UIControlStateNormal];
    if ([ValidatorUtil isMobileNumber:_phoneNumber]) {
        NSDictionary *params;
//        params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber,@"find_pay_pwd",@"",@"0",nil];
        params = @{@"phone":_phoneNumber,@"type":@"find_pay_pwd",@"captcha":@"",@"type2":@"0"};
        [self showLoading:@""];
        [self.requestPayPassWord resetPwdCodeWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            _timeText = 60;
            [self showTime];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTime) userInfo:nil repeats:YES];
            _tempStr = @"短信验证码已发送";
            [self refreshUI];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
            _getMessageKey.userInteractionEnabled = YES;
            [_getMessageKey setTitle:@"重新获取" forState:UIControlStateNormal];
            [_getMessageKey setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }];
        _getMessageKey.userInteractionEnabled = NO;
    }else{
        [self hideAllKeyBoards];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"手机号码格式不正确" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }
}

- (void)showTime{
    if (_timeText <= 1) {
        _getMessageKey.userInteractionEnabled = YES;
        [_timer invalidate];
        [_getMessageKey setTitle:@"重新获取" forState:UIControlStateNormal];
        [_getMessageKey setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        [_getMessageKey setTitle:[NSString stringWithFormat:@"%d秒",--_timeText] forState:UIControlStateNormal];
    }
}

#pragma mark - Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField.layer setBorderColor:[UIColor orangeColor].CGColor];
    if (textField == _messageKey) {
        _lineView.backgroundColor = [UIColor orangeColor];
        _backView.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    if (SCREEN_HEIGHT <= 568) {
        if (textField == _trueName) {
            [_baseView setContentOffset:CGPointMake(0, _phoneNum.frame.origin.y + 50) animated:YES];
        } else if (textField == _idCard) {
            [_baseView setContentOffset:CGPointMake(0, _phoneNum.frame.origin.y + 50) animated:YES];
        } else {
            [_baseView setContentOffset:CGPointMake(0, _trueName.frame.origin.y) animated:YES];
        }
    }
    if (_phoneNum.text.length > 0 && _trueName.text.length > 0 &&_idCard.text.length > 0 &&_messageKey.text.length > 0 ) {
        [self buttonToRed];
    }else{
        [self buttonToGray];
    }
}

-(void)textFieldChanged:(UITextField*)textfield{
    if (_messageKey.text.length > 6) {
        _messageKey.text = [_messageKey.text substringToIndex:6];
    }
    if ([self.isRealName integerValue] == 0) {
        if (_phoneNum.text.length > 0 && _messageKey.text.length > 0 ) {
            [self buttonToRed];
        }else{
            [self buttonToGray];
        }
    }else{
        if (_phoneNum.text.length > 0 && _trueName.text.length > 0 &&_idCard.text.length > 0 &&_messageKey.text.length > 0 ) {
            [self buttonToRed];
        }else{
            [self buttonToGray];
        }
    }
    if (_idCard.text.length > 18) {
        _idCard.text = [_idCard.text substringToIndex:18];
    }
}
- (BOOL)commitBtnClick:(KDKeyboardView *)keyboardView{
    if ([self.isRealName integerValue] == 0) {
        if (_phoneNum.text.length > 0 && _messageKey.text.length > 0 ) {
            [self nextTouch];
            return YES;
        }
    }else{
        if (_phoneNum.text.length > 0 && _trueName.text.length > 0 &&_idCard.text.length > 0 &&_messageKey.text.length > 0 ) {
            [self nextTouch];
            return YES;
        }
    }
    return NO;
}
- (void)hideKeyBoard:(KDKeyboardView *)keyboardView{
    [self hideAllKeyBoards];
}

#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL basic = NO;
    if (textField == _trueName) {
        basic = YES;
    }
    if (textField == _idCard) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"Xx0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        basic = [string isEqualToString:filtered];
    }if (textField == _messageKey) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        basic = [string isEqualToString:filtered];
    }
    return basic;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    if (textField == _messageKey) {
        _lineView.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
        _backView.layer.borderColor = [UIColor colorWithHex:0xb7b7b7].CGColor;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 请求数据
- (void)nextTouch{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
        _baseView.frame = self.view.bounds;
    }];
    if (_messageKey.text.length == 6) {
        NSDictionary *params;
        params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",_messageKey.text,@"code",@"find_pay_pwd",@"type",_trueName.text,@"realname",_idCard.text,@"id_card",nil];
        [self showLoading:@""];
        [self.requestPayPassWord userVerifyResetPasswordWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            NewPasswordVC* newPasswordVC = [[NewPasswordVC alloc] init];
            newPasswordVC.forgetType = @"pay";
            newPasswordVC.phoneNumber = _phoneNumber;
            newPasswordVC.code = _messageKey.text;
            newPasswordVC.realName = _trueName.text;
            newPasswordVC.idCard = _idCard.text;
            [self dsPushViewController:newPasswordVC animated:YES];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
    }else{
        [self showMessage:@"验证码格式不正确，请重新输入"];
    }
}

#pragma mark - Other
-(PayPassWordRequest *)requestPayPassWord{
    if (!_requestPayPassWord) {
        _requestPayPassWord = [PayPassWordRequest new];
    }
    return _requestPayPassWord;
}
- (void)buttonToGray{
    _button.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
    _button.userInteractionEnabled = NO;
}

- (void)buttonToRed{
    _button.backgroundColor = [UIColor orangeColor];
    _button.userInteractionEnabled = YES;
}

- (void)refreshUI{
    CGFloat width = [_tempStr widthWithFontSize:13.f];
    _tipLabel.frame = CGRectMake(15, 10, width, 13);
    _tipLabel.text = _tempStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
