//
//  FindPasswordVC.m
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "FindPasswordVC.h"
#import "UserManager.h"
#import "NSString+Frame.h"
#import "KDKeyboardView.h"
#import "DXAlertView.h"
#import "NewPasswordVC.h"
#import "IQKeyboardManager.h"
#import "ForgetPassWordRequest.h"
#import <UIImageView+WebCache.h>

@interface FindPasswordVC ()<KDTextfieldDelegate,UITextFieldDelegate>

@property(nonatomic,retain)UIScrollView *baseView;
@property(nonatomic,retain)UITextField* phoneNum;

@property(nonatomic,retain)UITextField* messageKey;
@property(nonatomic,retain)UIButton* getMessageKey;
@property(nonatomic,retain)UIButton* button;

@property (nonatomic, strong)ForgetPassWordRequest *requestForgetPassWord;

@end

@implementation FindPasswordVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.phoneNum.text = self.phoneNumber;
    self.navigationItem.title = @"找回登录密码";
    if (self.accessNetwork) {
        __weak typeof(self) weakSelf = self;
        [_getMessageKey setTitleColor:[UIColor colorWithHex:0xdddddd] forState:UIControlStateNormal];
        [UIButton startRunSecond:_getMessageKey stringFormat:@"%@秒后重试" finishBlock:^{
            weakSelf.getMessageKey.userInteractionEnabled = YES;
            [weakSelf.getMessageKey setTitle:@"重新发送" forState:UIControlStateNormal];
            [_getMessageKey setTitleColor:Color_Red forState:UIControlStateNormal];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    //delegate 置为nil
    
    //删除通知
    
}

#pragma mark - View创建与设置

- (void)setUpView{
    [self baseSetup:PageGobackTypePop];
    //创建视图等
    self.view.backgroundColor = [UIColor whiteColor];
    _baseView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyBoards)];
    [self.view addGestureRecognizer:tap];
    
    _phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(15, 30, self.view.frame.size.width-30, 44)];

    [_phoneNum addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum.placeholder = @"请输入手机号";
    _phoneNum.delegate = self;
    [self.view addSubview:_phoneNum];

    _phoneNum.leftView = [self leftView:@"phone" superView:_phoneNum];
    _phoneNum.leftViewMode = UITextFieldViewModeAlways;
    
    _phoneNum.text = _phoneNumber;
    if (_phoneNum.text.length>0) {
        _phoneNum.text = [NSString stringWithFormat:@"%@****%@",[_phoneNum.text substringToIndex:3],[_phoneNum.text substringFromIndex:7]];
    }
    
    [_phoneNum setUserInteractionEnabled:NO];
    
    
    _messageKey = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, 44)];
    [_messageKey addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _messageKey.keyboardType = UIKeyboardTypeNumberPad;
    _messageKey.placeholder = @"请输入短信验证码";
    _messageKey.clearButtonMode = UITextFieldViewModeWhileEditing |UITextFieldViewModeUnlessEditing;
    _messageKey.delegate = self;
    [self.view addSubview:_messageKey];
    [_messageKey mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_phoneNum.mas_bottom).with.offset(10);
        make.height.equalTo(@44);
        make.width.equalTo(@(self.view.frame.size.width-30));
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
    }];
    
    [KDKeyboardView KDKeyBoardWithKdKeyBoard:PHONECODE target:self textfield:_messageKey delegate:self valueChanged:@selector(textFieldChanged:)];
    
    _messageKey.leftView = [self leftView:@"icon_data_safefy" superView:_messageKey];
    _messageKey.leftViewMode = UITextFieldViewModeAlways;
    
    NSString *title = @"发送验证码";
    
    _getMessageKey = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    [_getMessageKey setTitle:title forState:UIControlStateNormal];
    [_getMessageKey setTitleColor:Color_Red forState:UIControlStateNormal];
    _getMessageKey.titleLabel.font = [UIFont systemFontOfSize:13];
    [_getMessageKey addTarget:self action:@selector(getMessagekeyTouch) forControlEvents:UIControlEventTouchUpInside];
    _messageKey.rightView = _getMessageKey;
    _messageKey.rightViewMode = UITextFieldViewModeAlways;
    
    
    _button = [[UIButton alloc] init];
    [_button setTitle:@"下一步" forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor blueColor]];
    _button.titleLabel.font = [UIFont systemFontOfSize:17];
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = 22.0f;
    _button.userInteractionEnabled = NO;
    [_button addTarget:self action:@selector(nextTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_messageKey.mas_bottom).with.offset(30);
        make.height.equalTo(@44);
        make.width.equalTo(@(self.view.frame.size.width-30));
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
    }];
}

-(UIView *)leftView:(NSString *)imgStr superView:(UITextField *)textField{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(40, 13, 1, 18)];
    line1.backgroundColor = [UIColor colorWithHex:0xE4E5E6];
    [leftView addSubview:line1];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
    imgView.contentMode =  UIViewContentModeBottomRight;
    imgView.frame = CGRectMake(0, 0, 32, 44);
    imgView.contentMode = UIViewContentModeCenter;
    [leftView addSubview:imgView];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHex:0xFED198];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(textField.mas_bottom).with.offset(1);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@1);
    }];
    return leftView;
}


#pragma mark - 按钮事件

-(void) hideAllKeyBoards{
    [self.phoneNum resignFirstResponder];
    [self.messageKey resignFirstResponder];
}

-(void)nextTouch
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
        _baseView.frame = self.view.bounds;
    }];
    
    if (_messageKey.text.length == 6) {
        NSDictionary *params;
        NSString *strCaptcha = @"";

        params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",_messageKey.text,@"code",@"find_pwd",@"type",strCaptcha,@"captcha",nil];
        
        [self showLoading:@""];
        [self.requestForgetPassWord forgetPassWordWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            NewPasswordVC *newPasswordVC = [[NewPasswordVC alloc] init];
            newPasswordVC.forgetType = @"login";

            newPasswordVC.phoneNumber = _phoneNumber;
            newPasswordVC.code = _messageKey.text;
            [self dsPushViewController:newPasswordVC animated:YES];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
        
    }else{
        [self showMessage:@"验证码格式不正确，请重新输入"];
    }
}

-(void)getMessagekeyTouch
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
        _baseView.frame = self.view.bounds;
    }];
    
    [_getMessageKey setTitleColor:[UIColor colorWithHex:0xdddddd] forState:UIControlStateNormal];
    if (_phoneNumber.length == 11) {
        NSDictionary *params;
        NSString *strCaptcha = @"";
        params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",@"find_pwd",@"type",@"1",@"type2",strCaptcha,@"captcha",nil];
        
        [self showLoading:@""];
        [self.requestForgetPassWord resetPwdCodeWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            [UIButton startRunSecond:_getMessageKey stringFormat:@"%@秒后重试" finishBlock:^{
                weakSelf.getMessageKey.userInteractionEnabled = YES;
                [weakSelf.getMessageKey setTitle:@"重新发送" forState:UIControlStateNormal];
                [weakSelf.getMessageKey setTitleColor:Color_Red forState:UIControlStateNormal];
            }];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
            _getMessageKey.userInteractionEnabled = YES;
            [_getMessageKey setTitle:@"重新发送" forState:UIControlStateNormal];
            [_getMessageKey setTitleColor:Color_Red forState:UIControlStateNormal];
        }];
        _getMessageKey.userInteractionEnabled = NO;
    }else{
        DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"手机号码格式不正确"  leftButtonTitle:nil rightButtonTitle:@"确定"];
        [self hideAllKeyBoards];
        [alertView show];
    }
}

-(void)textFieldChanged:(UITextField*)textfield
{
    if (_messageKey.text.length > 6) {
        _messageKey.text = [_messageKey.text substringToIndex:6];
        [_messageKey.undoManager removeAllActions];
    }
    
    if (_phoneNum.text.length > 0 && _messageKey.text.length > 0 ) {
        [self buttonToRed];
    }else{
        [self buttonToGray];
    }
    
}

#pragma mark - textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (_phoneNum.text.length > 0&&_messageKey.text.length > 0 ) {
        [self buttonToRed];
    }else{
        [self buttonToGray];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL basic = NO;

    if (textField == _messageKey) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        basic = [string isEqualToString:filtered];
    }
    return basic;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _messageKey) {
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)commitBtnClick:(KDKeyboardView *)keyboardView
{
    if (_phoneNum.text.length > 0 && _messageKey.text.length > 0 ) {
        [self nextTouch];
        return YES;
    }
    
    return NO;
}

- (void)hideKeyBoard:(KDKeyboardView *)keyboardView
{
    [self hideAllKeyBoards];
}

#pragma mark - 请求数据

#pragma mark - Other

-(ForgetPassWordRequest *)requestForgetPassWord{
    if (!_requestForgetPassWord) {
        _requestForgetPassWord = [ForgetPassWordRequest new];
    }
    return _requestForgetPassWord;
}

-(void)buttonToGray
{
    _button.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
    _button.userInteractionEnabled = NO;
}

-(void)buttonToRed
{
    _button.backgroundColor = Color_Red;
    _button.userInteractionEnabled = YES;
}
//***************************************no use**************************************************
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
