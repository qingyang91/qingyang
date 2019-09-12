//
//  FeedBackVC.m
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "FeedBackVC.h"
#import "DXAlertView.h"
#import "MeRequest.h"


@interface FeedBackVC ()<UITextViewDelegate>

@property (nonatomic, retain) UITextView *fbTV;
@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) UILabel *textLimit;
@property (nonatomic, retain) UIButton *commitBtn;
@property (nonatomic, strong) MeRequest *feedBackNetworkAccess;

@end

@implementation FeedBackVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

#pragma mark - View创建与设置

- (void)setUpView{
    
    self.navigationItem.title = @"意见反馈";
    [self baseSetup:PageGobackTypePop];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyBoards)];
    [self.view addGestureRecognizer:tap1];
    
    //创建视图等
    __block UIView *topBackView = [[UIView alloc] init];
    topBackView.backgroundColor = [UIColor whiteColor];
    topBackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@(225 * WIDTHRADIUS));
    }];
    
    self.fbTV = [[UITextView alloc] initWithFrame:CGRectMake(17, 17 * WIDTHRADIUS, SCREEN_WIDTH - 34, (225 - 17) * WIDTHRADIUS)];
    self.fbTV.delegate = self;
    self.fbTV.backgroundColor = [UIColor whiteColor];
    self.fbTV.font = [UIFont systemFontOfSize:iPhone6p ? 15 : 13];
    self.fbTV.textColor = UIColorFromRGB(0x333333);
    [topBackView addSubview:self.fbTV];
    
    _placeHolderLabel = [[UILabel alloc] init];
    _placeHolderLabel.font = [UIFont systemFontOfSize:iPhone6p ? 15 : 13];
    _placeHolderLabel.textColor = [UIColor grayColor];
    _placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fbTV addSubview:_placeHolderLabel];
    if (_lendID.length != 0) {
        _placeHolderLabel.text = @"请输入您对此借条的意见反馈，我们会及时处理谢谢。";
    }else{
        _placeHolderLabel.text = @"请输入您的反馈意见，我们会为您不断进步。";
    }
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.mas_equalTo(@0);
        make.height.mas_equalTo(@32);
    }];
    
    __weak typeof(self) weakSelf = self;
    _textLimit = [[UILabel alloc] init];
    _textLimit.font = [UIFont systemFontOfSize:iPhone6p ? 15 : 13];
    _textLimit.textColor = [UIColor grayColor];
    _textLimit.translatesAutoresizingMaskIntoConstraints = NO;
    [topBackView addSubview:_textLimit];
    _textLimit.text = @"160/160";
    [_textLimit mas_makeConstraints:^(MASConstraintMaker *make){
        __strong typeof(self) strongSelf = weakSelf;
        make.right.equalTo(strongSelf.fbTV.mas_right);
        make.bottom.equalTo(strongSelf.fbTV.mas_bottom).offset(-(17 * WIDTHRADIUS));
    }];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_commitBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    _commitBtn.backgroundColor = UIColorFromRGB(0xb7b7b7);
    [self.view addSubview:_commitBtn];
    _commitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(@15);
        make.right.mas_equalTo(@-15);
        make.height.mas_equalTo(@44);
        make.top.equalTo(topBackView.mas_bottom).offset(42.5 * WIDTHRADIUS);
    }];
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.layer.cornerRadius = 22;
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 点击外面隐藏键盘

-(void) hideAllKeyBoards{
    [_fbTV resignFirstResponder];
}

#pragma mark 提交反馈



- (void)pop
{
    [self popVC];
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _placeHolderLabel.hidden = YES;
    [textView.layer setBorderColor:UIColorFromRGB(0xfc8d1f).CGColor];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.fbTV.text length] > 160) {
        [self showMessage:@"不能超过160个字哦"];
        _fbTV.text = [_fbTV.text substringToIndex:160];
        self.textLimit.text = @"0/160";
        return;
    }
    if ([self isBlankString:textView.textInputMode.primaryLanguage]) {
        return;
    }
    NSInteger a = 160 - [textView.text length];
    NSString *str = [NSString stringWithFormat:@"%ld/160",(long)a];
    self.textLimit.text = str;
    if (_fbTV.text.length > 0) {
        if (_lendID.length != 0) {
            _commitBtn.userInteractionEnabled = YES;
            _commitBtn.backgroundColor = [UIColor orangeColor];
        }else{
            _commitBtn.userInteractionEnabled = YES;
            _commitBtn.backgroundColor = [UIColor blueColor];
        }
    }else{
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = UIColorFromRGB(0xb7b7b7);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self isBlankString:textView.textInputMode.primaryLanguage]) {
        return NO;
    };
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _placeHolderLabel.hidden = NO;
    }
    [textView.layer setBorderColor:UIColorFromRGB(0xb7b7b7).CGColor];
    return YES;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


#pragma mark - 请求数据

-(void)confirm
{
    [_fbTV resignFirstResponder];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self.fbTV.text
                                                               options:0
                                                                 range:NSMakeRange(0, [self.fbTV.text length])
                                                          withTemplate:@""];
    
    
    if([modifiedString isEqualToString:@""]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请输入反馈内容" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [self hideAllKeyBoards];
        [alert show];
        return;
    }
    NSDictionary *param = @{@"content" : modifiedString};
    [self showLoading:@""];
    if (_lendID.length != 0) {
        [self.feedBackNetworkAccess feedLendBackWithDict:@{@"id":_lendID,
                                                           @"content":modifiedString
                                                           } onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            [self showMessage:@"此借条反馈提交成功"];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pop) userInfo:nil repeats:NO];
         } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
    }else{
        [self.feedBackNetworkAccess feedBackWithDict:param onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            [self showMessage:@"提交反馈成功"];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pop) userInfo:nil repeats:NO];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
    }
}

#pragma mark - Other

-(MeRequest *)feedBackNetworkAccess{
    if (!_feedBackNetworkAccess) {
        _feedBackNetworkAccess = [MeRequest new];
    }
    return _feedBackNetworkAccess;
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
