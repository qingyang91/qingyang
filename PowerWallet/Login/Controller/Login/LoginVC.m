//
//  LoginVC.m
//  PowerWallet
//
//  Created by lxw on 17/1/23.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LoginVC.h"
#import "KDKeyboardView.h"
#import "IQKeyboardManager.h"
#import "LoginOrRegistRequest.h"
#import "LoginSecVC.h"
#import "RegisterVC.h"
#import "DXAlertView.h"
#import "BaseTextField.h"

@interface LoginVC ()<KDTextfieldDelegate>

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) NSUndoManager *manager;
@property (nonatomic, strong) LoginOrRegistRequest *request;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self umengEvent:@"Login_First" attributes:nil number:@10];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"助力凭条";
    UIScrollView *scvMain = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scvMain;
    self.view.backgroundColor = Color_White;
    //隐藏IQkeyBoard键盘的Toolbar
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    self.navigationItem.hidesBackButton = YES;;
    UIBarButtonItem *cancelLeftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(doClickBackAction)];
//    self.navigationItem.leftBarButtonItem = cancelLeftBtn;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [self viewAddEndEditingGesture];
    [self createUI];
}

- (LoginOrRegistRequest *)request{
    
    if (!_request) {
        _request = [[LoginOrRegistRequest alloc] init];
    }
    
    return _request;
}



- (void)createUI{
    
    __weak typeof(self) weakSelf = self;
    //*****上面的圆角图片
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo_xhdpi"]];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(@0);
        make.top.equalTo(self.view.mas_top).with.offset(50);
        make.height.equalTo(@(SCREEN_WIDTH/4));
        make.width.equalTo(@(SCREEN_WIDTH/4));
    }];
    //设置圆角
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = SCREEN_WIDTH/4/4;
    
    //*****手机号输入框
    _textField = [[BaseTextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.textColor = [UIColor colorWithHex:0x333333];
    _textField.placeholder = @"请输入注册/登录手机号";
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.imageView.mas_bottom).with.offset(50);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@44);
    }];
    
    [KDKeyboardView KDKeyBoardWithKdKeyBoard:TELEPHONE target:self textfield:_textField delegate:self valueChanged:@selector(textFieldValueChanged:)];
    //左边的手机小图标
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(40, 13, 1, 18)];
    line1.backgroundColor = [UIColor colorWithHex:0xE4E5E6];
    [leftView addSubview:line1];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
    imgView.contentMode =  UIViewContentModeBottomRight;
    imgView.frame = CGRectMake(0, 0, 32, 44);
    imgView.contentMode = UIViewContentModeCenter;
    [leftView addSubview:imgView];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    //设置圆角
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHex:0xFED198];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(_textField.mas_bottom).with.offset(1);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@1);
    }];
    
    //*****下一步按钮
    self.button = [[UIButton alloc] init];
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.button setTitleColor:Color_White forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@40);
        make.top.equalTo(weakSelf.textField.mas_bottom).with.offset(40);
    }];
    [self.button setTitle:@"下一步" forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
    self.button.userInteractionEnabled = NO;
    [self.button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 20.0;
    //设置圆角
}


- (void)textFieldValueChanged:(UITextField *)textfield
{
    
    if (textfield.text.length > 11) {
        textfield.text = [textfield.text substringToIndex:11];
        [textfield.undoManager removeAllActions];
         self.button.userInteractionEnabled = NO;
    }
    if (textfield.text.length == 11) {
        self.button.backgroundColor = [UIColor blueColor];
        self.button.userInteractionEnabled = YES;
    } else {
        self.button.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
        self.button.userInteractionEnabled = NO;
    }
}

- (void)btnClick
{
    [self showLoading:@""];
    __weak typeof(self) weakSelf = self;
    [self.request checkPhoneNumberWithDict:@{@"phone":self.textField.text,@"type":@"0"} onSuccess:^(NSDictionary *dictResult) {
        [weakSelf hideLoading];
        //代表手机号为注册,并发送验证码
        RegisterVC *registerVC = [[RegisterVC alloc] initWithPageType:registerSec];
        registerVC.phoneNumber = self.textField.text;
        registerVC.captchaUrl = DSStringValue(dictResult[@"item"][@"captchaUrl"]);
        [weakSelf.navigationController pushViewController:registerVC animated:YES];
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [weakSelf hideLoading];
        //200 该手机号以注册
        if (code == 1000) {
            LoginSecVC *secVC = [LoginSecVC new];
            secVC.userName = self.textField.text;
            secVC.reLoginSetUserName = ^(NSString *userName){
                weakSelf.textField.text = userName;
            };
            secVC.tipStr = errorMsg;
            [weakSelf.navigationController  pushViewController:secVC animated:YES];
        }else{
            [self showMessage:errorMsg];
        }
    }];
}

-(void) doClickBackAction{
    [_textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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
