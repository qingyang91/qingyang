//
//  RegisterVC.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "RegisterVC.h"
#import "KDXieYiBtn.h"
#import "CommonWebVC.h"
#import "LoginOrRegistRequest.h"
#import "UserModel.h"
#import "UserManager.h"
#import "YBBKeychain.h"
#import "DXAlertView.h"
#import <UIImageView+WebCache.h>
#import "MD5Tool.h"
#import "RegularMethod.h"
#import "ReportInterface.h"
#import "GDLocationManager.h"
#import "MainTabBarVC.h"
@interface RegisterVC ()
@property (nonatomic, retain) UITextField *codeTextfield;
@property (nonatomic, retain) UIButton *getCodeBtn;
@property (nonatomic, retain) UITextField *pwdTextfield;
@property (nonatomic, retain) UITextField *inviteTextfield;//邀请框
@property (nonatomic, retain) UIButton *commitBtn;
@property (nonatomic, retain) UIButton *hiddenBtn;
@property (nonatomic, retain) KDXieYiBtn *btn;
@property (assign, nonatomic) registerOrForgetPwd type;

@property (nonatomic,strong) LoginOrRegistRequest *request; //获取验证码
@property (nonatomic, retain) UIView *inviteLine;
@property (nonatomic, strong) UIButton *lpSeePw;
@end

@implementation RegisterVC

- (instancetype)initWithPageType:(registerOrForgetPwd)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (LoginOrRegistRequest *)request{
    
    if (!_request) {
        _request = [[LoginOrRegistRequest alloc] init];
    }
    return _request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backArrowSet];
    [self umengEvent:@"Register" attributes:nil number:@10];
    self.navigationItem.title = @"注册";
    UIScrollView *scvMain = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scvMain;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUIView];
    [self viewAddEndEditingGesture];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoadAddressSuccess:) name:@"upLoadAddressSuccess" object:nil];
}
//-(void)upLoadAddressSuccess:(NSNotification *)not{
//    [self hideLoading];
//    //页面跳转到我的
//    [self showMessage:@"注册成功"];
//
////    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    MainTabBarVC *tab = [[MainTabBarVC alloc]init];
//    [[UIApplication sharedApplication] delegate].window.rootViewController = tab;
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterSuccess" object:nil];
//}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_commitBtn setTitle:self.type == forgetPwd ? @"确定" : @"注册" forState:UIControlStateNormal];
    if (self.type == registerSec) {
        __weak typeof(self) weakSelf = self;
        if ([weakSelf.getCodeBtn.titleLabel.text isEqualToString:@"重新发送"]||[weakSelf.getCodeBtn.titleLabel.text isEqualToString:@"发送验证码"]) {
            [UIButton startRunSecond:_getCodeBtn stringFormat:@"%@秒后重试" finishBlock:^{
                weakSelf.getCodeBtn.userInteractionEnabled = YES;
                [weakSelf.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [weakSelf.getCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }];
        }
        
    } else {
        [self.getCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
}

- (void)createUIView
{
    __weak typeof(self) weakSelf = self;
    
    self.codeTextfield = [[UITextField alloc] init];
    self.codeTextfield.font = [UIFont systemFontOfSize:15.0];
    self.codeTextfield.textColor = [UIColor colorWithHex:0x333333];
    self.codeTextfield.placeholder = @"请输入验证码";
    self.codeTextfield.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.codeTextfield];
    [self.codeTextfield mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.equalTo(weakSelf.view).offset(15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 30]);
        make.top.equalTo(weakSelf.view).offset(50);
        make.height.mas_equalTo(45);
    }];
    
    _codeTextfield.leftView = [self leftView:@"icon_data_safefy" superView:_codeTextfield];
    _codeTextfield.leftViewMode = UITextFieldViewModeAlways;
    [_codeTextfield addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _codeTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTextfield.keyboardType =UIKeyboardTypeASCIICapable;
    
    _getCodeBtn = [UIButton new];
    _getCodeBtn.frame = CGRectMake(0, 0, 80, 45);
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_getCodeBtn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateNormal];
    [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_getCodeBtn addTarget:self action:@selector(getRegisCode) forControlEvents:UIControlEventTouchUpInside];
    _codeTextfield.rightView = _getCodeBtn;
    _codeTextfield.rightViewMode = UITextFieldViewModeAlways;
    
    self.pwdTextfield = [[UITextField alloc] init];
    self.pwdTextfield.font = [UIFont systemFontOfSize:15];
    self.pwdTextfield.textColor = [UIColor colorWithHex:0x333333];
    self.pwdTextfield.placeholder = @"请设置新的6-16位登录密码";
    self.pwdTextfield.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pwdTextfield];
    [self.pwdTextfield mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 70]);
        make.top.equalTo(_codeTextfield.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    _pwdTextfield.leftView = [self leftView:@"login_password" superView:_pwdTextfield];
    _pwdTextfield.leftViewMode = UITextFieldViewModeAlways;
    _pwdTextfield.secureTextEntry = YES;
    [_pwdTextfield addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _pwdTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //邀请码按钮
    _hiddenBtn = [UIButton new];
    if (_captchaUrl.length!=0) {
        _hiddenBtn.frame = CGRectMake(15, 173+65, SCREEN_WIDTH, 16);
    }else{
        _hiddenBtn.frame = CGRectMake(15, 173, SCREEN_WIDTH, 16);
    }
    _hiddenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _hiddenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_hiddenBtn setTitleColor:[UIColor colorWithHex:0x3FEFA4] forState:UIControlStateNormal];
    [_hiddenBtn setTitle:@"我有邀请码>>" forState:UIControlStateNormal];
    _hiddenBtn.hidden = YES;
    [_hiddenBtn addTarget:self action:@selector(hiddenClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hiddenBtn];
    
    self.inviteTextfield = [[UITextField alloc] init];
    self.inviteTextfield.font = [UIFont systemFontOfSize:15];
    self.inviteTextfield.textColor = [UIColor colorWithHex:0x333333];
    self.inviteTextfield.placeholder = @"请输入邀请码（可选）";
    self.inviteTextfield.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.inviteTextfield];
    [self.inviteTextfield mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(weakSelf.view).offset(15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 30]);
        make.top.equalTo(_pwdTextfield.mas_bottom).offset(20);
        make.height.mas_equalTo(0);
    }];
    
    self.inviteLine = [[UIView alloc] init];
    self.inviteLine.backgroundColor = [UIColor colorWithHex:0xFED198];
    [self.view addSubview:self.inviteLine];
    [self.inviteLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(self.inviteTextfield.mas_bottom).with.offset(1);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@1);
    }];
    
    UIView *zhan = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    zhan.contentMode = UIViewContentModeCenter;
    _inviteTextfield.leftView = zhan;
    _inviteTextfield.leftViewMode = UITextFieldViewModeAlways;
    [_inviteTextfield addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _inviteTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.commitBtn = [[UIButton alloc] init];
    self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.commitBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    self.commitBtn.backgroundColor = [UIColor colorWithHex:0xd9d9d9];
    [self.view addSubview:self.commitBtn];
    self.commitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(weakSelf.view).offset(15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 30]);
        make.top.equalTo(_inviteTextfield.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
    
    _commitBtn.userInteractionEnabled = NO;
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.layer.cornerRadius = 20.0f;
    [_commitBtn addTarget:self action:@selector(commitRegister) forControlEvents:UIControlEventTouchUpInside];
    
    _btn = [[KDXieYiBtn alloc] initWithXieyiName:@[@"《注册协议》",@"《信用授权协议》",@"《数据使用授权协议》"]];
    [self.view addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_commitBtn.mas_bottom).with.offset(11.0);
        make.height.equalTo(@60);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    _btn.xieyiLabelTapBlock = ^{
        CommonWebVC *web = [[CommonWebVC alloc]init];
        web.strTitle = @"《注册协议》";
        web.strType = @"ZCXY";
        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Base_URL1,@"act/light-loan-lyb/agreement"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:web];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    _btn.xieyiLabel2TapBlock = ^{
        CommonWebVC *web = [[CommonWebVC alloc]init];
        web.strTitle = @"《信用授权协议》";
        web.strType = @"XYXY";
        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Base_URL1,@"agreement/creditExtension"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:web];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    _btn.xieyiLabel3TapBlock = ^{
        CommonWebVC *web = [[CommonWebVC alloc]init];
        web.strTitle = @"《数据使用授权协议》";
        web.strType = @"XYXY";
        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Base_URL1,@"agreement/shiYongShouQuan"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:web];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    if (_captchaUrl.length!=0) {
    }else{
        [_codeTextfield becomeFirstResponder];
    }
    
    [self.view addSubview:self.lpSeePw];
    [self.lpSeePw mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_pwdTextfield.mas_right).with.offset(0);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
        make.centerY.equalTo(_pwdTextfield.mas_centerY).with.offset(0);
    }];
    
    _inviteTextfield.hidden = YES;
    self.inviteLine.hidden = YES;
}

-(UIButton *)lpSeePw{
    if (!_lpSeePw) {
        _lpSeePw = [[UIButton alloc] init];
        [_lpSeePw setImage:[UIImage imageNamed:@"unvisible"] forState:UIControlStateNormal];
        [_lpSeePw setImage:[UIImage imageNamed:@"visible"] forState:UIControlStateSelected];
        _lpSeePw.imageEdgeInsets = UIEdgeInsetsMake(8,8,8,8);
        [_lpSeePw addTarget:self action:@selector(toSeePassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lpSeePw;
}

-(void)toSeePassword:(UIButton *)sender{
    if (sender.isSelected){
        NSString *tempPwdStr = self.pwdTextfield.text;
        sender.selected = NO;
        self.pwdTextfield.text = tempPwdStr;
        self.pwdTextfield.secureTextEntry = YES;
    }else{
        NSString *tempPwdStr = self.pwdTextfield.text;
        sender.selected = YES;
        self.pwdTextfield.text = tempPwdStr;
        self.pwdTextfield.secureTextEntry = NO;
    }
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

- (void)commitRegister{
    __weak typeof(self) weakSelf = self;
    NSString *strCaptcha = @"";
    NSDictionary *dic =@{@"phone":self.phoneNumber,
                         @"code":self.codeTextfield.text,
                         @"password":[MD5Tool MD5ForUpper32Bate:self.pwdTextfield.text],
                         @"source":@"37",
                         @"invite_code":self.inviteTextfield.text};
    [self.request commitRegisterWithDict:dic onSuccess:^(NSDictionary *dictResult) {                              
        [[UserManager sharedUserManager] updateUserInfo:dictResult[@"item"]];
        //存储用户信息
        //如果没设置密码则 设定密码 并存储
        [YBBKeychain setPassword:self.pwdTextfield.text forService:kYBBKeychainErrorDomain account:self.phoneNumber];
        [[ReportInterface shareMasterReport] responceContent:YES];
//        [[ReportInterface shareMasterReport] upLoadAddressBook];
//        [[GDLocationManager shareInstance] startLocation];
        MainTabBarVC *tab = [[MainTabBarVC alloc]init];
        [[UIApplication sharedApplication] delegate].window.rootViewController = tab;
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        [self showMessage:errorMsg];
    }];
}

- (void)textFieldValueChanged:(UITextField *)textfield
{
    if (_codeTextfield.text.length > 6) {
        _codeTextfield.text = [_codeTextfield.text substringToIndex:6];
    }
    if (_pwdTextfield.text.length > 16) {
        [_pwdTextfield.undoManager removeAllActions];
        _pwdTextfield.text = [_pwdTextfield.text substringToIndex:16];
    }
    if ( _pwdTextfield.text.length >= 6 && _pwdTextfield.text.length <= 16) {
        self.commitBtn.backgroundColor = [UIColor blueColor];
        self.commitBtn.userInteractionEnabled = YES;
    } else {
        [self.commitBtn setBackgroundColor:Color_GRAY];
        self.commitBtn.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
        self.commitBtn.userInteractionEnabled = NO;
    }
}

-(void)hiddenClick{
    _inviteTextfield.hidden = NO;
    self.inviteLine.hidden = NO;
    _hiddenBtn.hidden = YES;
    
    
    CGRect rect = _inviteTextfield.frame;
    rect.size.height = rect.size.height+44;
    _inviteTextfield.frame = rect;
    
    CGRect rect1 = _commitBtn.frame;
    rect1.origin.y = rect1.origin.y+44;
    _commitBtn.frame = rect1;
    
    self.inviteLine.frame = CGRectMake(_inviteTextfield.frame.origin.x, _inviteTextfield.frame.origin.y+_inviteTextfield.frame.size.height+1, _inviteTextfield.frame.size.width, 1);
    
    [_btn chageFrame];
    
}

-(void)frameChange:(UITextField*)tf{
    
}

-(void)frameAdd:(UIButton*)btn{
    
}

//获取验证码
- (void)getRegisCode
{
    [self.getCodeBtn setTitleColor:Color_Response forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    NSString *strCaptcha = @"";
    NSDictionary *dict = self.type == forgetPwd ? @{@"phone":self.phoneNumber,@"type":@"find_pwd"} : @{@"phone":self.phoneNumber,@"type":@"1",@"captcha":strCaptcha};
    
    [self.request getRegisterWithDict:dict onSuccess:^(NSDictionary *dictResult) {
        [UIButton startRunSecond:_getCodeBtn stringFormat:@"%@秒后重试" finishBlock:^{
            weakSelf.getCodeBtn.userInteractionEnabled = YES;
            [weakSelf.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            [weakSelf.getCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self showMessage:errorMsg];
    }];
}


- (NSNumber *)swithNumberWithFloat:(CGFloat)fValue {
    return [NSNumber numberWithFloat:fValue];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
