//
//  PJLoginSecVC.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LoginSecVC.h"
#import "UserManager.h"
#import "LoginOrRegistRequest.h"
#import "UserModel.h"
#import "YBBKeychain.h"
#import "YBBKeychainQuery.h"
#import "DXAlertView.h"
#import "FindPasswordVC.h"
#import "GetContactsBook.h"
#import "ForgetPassWordRequest.h"
#import "MD5Tool.h"
#import "RegularMethod.h"
#import "ReportInterface.h"
#import "GDLocationManager.h"
#import "BaseTextField.h"
#import "MainTabBarVC.h"
@interface LoginSecVC ()<UITextFieldDelegate>
@property (nonatomic, retain) UIImageView *photoImg;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UITextField *pwdTf;
@property (nonatomic, retain) UIButton *nextBtn;
@property (nonatomic, retain) UIButton *forgetPwdBtn;
@property (nonatomic, retain) UIButton *moreBtn;
@property (nonatomic, strong) LoginOrRegistRequest *commitRequest;
@property (nonatomic, strong) ForgetPassWordRequest *requestForgetPassWord;
@property (nonatomic, strong) UIButton *lpSeePw;
@end

@implementation LoginSecVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self umengEvent:@"Login_Sec" attributes:nil number:@10];
    UIScrollView *scvMain = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scvMain;
    self.view.backgroundColor = Color_White;
    self.title = @"助力凭条";
    [self backArrowSet];
    
    [self createUI];
    
    [self viewAddEndEditingGesture];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoadAddressSuccess:) name:@"upLoadAddressSuccess" object:nil];
}
//-(void)upLoadAddressSuccess:(NSNotification *)not{
//    //页面跳转到我的
////    [self showMessage:@"注册成功"];
//    [self hideLoading];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_userName && ![_userName isEqualToString:@""]) {
        _userNameLabel.text = _userName.length > 7 ? [_userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] : _userName;
    } else if([UserManager sharedUserManager].userInfo.username && ![[UserManager sharedUserManager].userInfo.username isEqualToString:@""]) {
        _userNameLabel.text =  [UserManager sharedUserManager].userInfo.username.length > 7 ? [[UserManager sharedUserManager].userInfo.username stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] : [UserManager sharedUserManager].userInfo.username;
        _userName = [UserManager sharedUserManager].userInfo.username;
    }
    
    
    _pwdTf.placeholder = (_tipStr&&![_tipStr isEqualToString:@""]) ? _tipStr : @"请输入登录密码";
}

- (LoginOrRegistRequest *)commitRequest{
    
    if (!_commitRequest) {
        _commitRequest = [[LoginOrRegistRequest alloc] init];
    }
    return _commitRequest;
}


- (void)createUI{
    
    _photoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user_image_default"]];
    [self.view addSubview:_photoImg];
    [_photoImg mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(50);
        make.centerX.equalTo(@0);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.font = [UIFont systemFontOfSize:15];
    _userNameLabel.textColor = Color_BLACK;
    _userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.photoImg.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
    }];
    
    _pwdTf = [[BaseTextField alloc]  init];
    _pwdTf.font = [UIFont systemFontOfSize:17];
    _pwdTf.textColor = [UIColor colorWithHex:0x333333];
    _pwdTf.placeholder = @"请输入登录密码";
    _pwdTf.delegate = self;
    _pwdTf.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_pwdTf];
    [_pwdTf mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.userNameLabel.mas_bottom).with.offset(20);
        //        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.equalTo(@(SCREEN_WIDTH - 70));
        make.height.equalTo(@44);
    }];
    //    [_pwdTf addTarget:self action:@selector(textfieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    //左边的锁
    
    _pwdTf.leftView = [self leftView:@"login_password" superView:_pwdTf];
    _pwdTf.leftViewMode = UITextFieldViewModeAlways;
    _pwdTf.secureTextEntry = YES;
    _pwdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _nextBtn = [[UIButton alloc] init];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _nextBtn.backgroundColor = Color_GRAY;
    _nextBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_nextBtn setTitleColor:Color_White forState:UIControlStateNormal];
    [self.view addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.top.equalTo(_pwdTf.mas_bottom).with.offset(40);
        make.height.equalTo(@40);
    }];
    _nextBtn.userInteractionEnabled = NO;
    _nextBtn.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
    [_nextBtn setTitle:@"登录" forState:UIControlStateNormal];
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 20.0f;
    [_nextBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _forgetPwdBtn = [[UIButton alloc] init];
    [self.view addSubview:_forgetPwdBtn];
    _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _forgetPwdBtn.backgroundColor = Color_White;
    _forgetPwdBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_forgetPwdBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _forgetPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_nextBtn.mas_bottom).with.offset(iPhone4 ? 5 : 10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.width.equalTo(@150);
        make.height.equalTo(@35);
    }];
    [_forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetPwdBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _moreBtn = [[UIButton alloc] init];
    [self.view addSubview:_moreBtn];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _moreBtn.backgroundColor = Color_White;
    _moreBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_moreBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.forgetPwdBtn.mas_bottom).with.offset(150);
        if (iPhone5) {
            make.top.equalTo(self.forgetPwdBtn.mas_bottom).with.offset(80);
        }
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@35);
    }];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.lpSeePw];
    [self.lpSeePw mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_pwdTf.mas_right).with.offset(0);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
        make.centerY.equalTo(_pwdTf.mas_centerY).with.offset(0);
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
        NSString *tempPwdStr = self.pwdTf.text;
        sender.selected = NO;
        self.pwdTf.text = tempPwdStr;
        self.pwdTf.keyboardType = UIKeyboardTypeASCIICapable;
        self.pwdTf.secureTextEntry = YES;
    }else{
        NSString *tempPwdStr = self.pwdTf.text;
        sender.selected = YES;
        self.pwdTf.text = tempPwdStr;
        self.pwdTf.keyboardType = UIKeyboardTypeASCIICapable;
        self.pwdTf.secureTextEntry = NO;
    }
}

- (void)moreBtnClick
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *new = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        if (self.reLoginSetUserName) {
            self.reLoginSetUserName(@"");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    UIAlertAction *switchUsers = [UIAlertAction actionWithTitle:@"切换用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        if (self.reLoginSetUserName) {
            self.reLoginSetUserName(@"");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
    }];
    [cancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alertVc addAction:new];
    [alertVc addAction:switchUsers];
    [alertVc addAction:cancel];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark -- 忘记密码
- (void)forgetBtnClick
{
    //先发送短信
    if (_userName.length == 11) {
        NSDictionary *params = @{@"phone": _userName,@"type": @"find_pwd",@"type2": @"0"};
        [self showLoading:@""];
        [self.requestForgetPassWord resetPwdCodeWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            [self umengEvent:@"ForgetPwd" attributes:nil number:@10];
            FindPasswordVC *vcFindPassword = [[FindPasswordVC alloc]init];
            vcFindPassword.forgetType = login;
            vcFindPassword.phoneNumber = _userName;
            vcFindPassword.accessNetwork = YES;

            [self dsPushViewController:vcFindPassword animated:YES];
            
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
    }else{
        DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"手机号码格式不正确"  leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alertView show];
    }
}

-(ForgetPassWordRequest *)requestForgetPassWord{
    if (!_requestForgetPassWord) {
        _requestForgetPassWord = [ForgetPassWordRequest new];
    }
    return _requestForgetPassWord;
}

#pragma mark -- 提交
- (void)commitBtnClick
{
    //隐藏键盘
    [_pwdTf resignFirstResponder];
    
    [self showLoading:@""];
    __weak typeof(self) weakSelf = self;
    [self.commitRequest LoginWithDict:@{@"username":_userName ? _userName : @"",@"password":[MD5Tool MD5ForUpper32Bate:_pwdTf.text]} onSuccess:^(NSDictionary *dictResult) {
        //存储用户信息
        if (![YBBKeychain passwordForService:kYBBKeychainErrorDomain account:_userName]) {//查看本地是否存储指定 serviceName 和 account 的密码
            //如果没设置密码则 设定密码 并存储
            [YBBKeychain setPassword:_pwdTf.text forService:kYBBKeychainErrorDomain account:_userName];
            //打印密码信息
            NSString *retrieveuuid = [YBBKeychain passwordForService:kYBBKeychainErrorDomain account:_userName];
            NSLog(@"存储显示: 未安装过:%@", retrieveuuid);
            
        }else{
            //曾经安装过 则直接能打印出密码信息(即使删除了程序 再次安装也会打印密码信息) 区别于 NSUSerDefault
            NSString *retrieveuuid = [YBBKeychain passwordForService:kYBBKeychainErrorDomain account:_userName];
            NSLog(@"存储显示 :已安装过:%@", retrieveuuid);
        }
        
        [[UserManager sharedUserManager] updateUserInfo:dictResult[@"item"]];
        
        ///上传用户信息
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[ReportInterface shareMasterReport] responceContent:YES];
//            [[ReportInterface shareMasterReport] upLoadAddressBook];

//            dispatch_sync(dispatch_get_main_queue(), ^{
//                页面跳转到我的
            [self hideLoading];
            MainTabBarVC *tab = [[MainTabBarVC alloc]init];
            [[UIApplication sharedApplication] delegate].window.rootViewController = tab;
//                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        
//            });
//        });
     
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [[[DXAlertView alloc] initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        [self hideLoading];
    }];
    
    
}

#pragma mark -- 监听textField

- (NSNumber *)swithNumberWithFloat:(CGFloat)fValue {
    return [NSNumber numberWithFloat:fValue];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 16) {
        [textField.undoManager removeAllActions];
        textField.text = [textField.text substringToIndex:16];
        return NO;
    }
    
    if (toBeString.length >= 6) {
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [UIColor blueColor];
    } else {
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
    }
    
    if (textField == self.pwdTf && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    return YES;
}

//-(void) doClickBackAction{
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

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
