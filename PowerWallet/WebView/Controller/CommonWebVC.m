//
//  CommonWebVC.m
//  Daidaibao
//
//  Created by Krisc.Zampono on 16/4/20.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "CommonWebVC.h"
#import "UserManager.h"
#import "DSUtils.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "DSUtils.h"
#import "NSString+Url.h"

#import "ShareEntity.h"
#import "ShareManager.h"
#import "MeRequest.h"
#import "MeModel.h"
#import <StoreKit/StoreKit.h>
#import "NSURLRequest+SSL.h"
@interface CommonWebVC()<UIWebViewDelegate, NJKWebViewProgressDelegate,SKStoreProductViewControllerDelegate
>

@property (nonatomic, strong) UIWebView     *wvMainWeb;
@property (nonatomic)UIBarButtonItem* closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic)NJKWebViewProgress* progressProxy;
@property (nonatomic)NJKWebViewProgressView* progressView;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
//是否可越界滑动（默认不可越界）
@property (assign, nonatomic) BOOL canScroll;
@property (nonatomic, strong) MeRequest     * request;
@property (nonatomic, strong) MeModel *meModel;
@property (nonatomic, strong) UIBarButtonItem * shareBtn;
@property (nonatomic, strong) NSMutableURLRequest *requestMessage;
@end

@implementation CommonWebVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openAppInfoView:) name:@"openAppInfoView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    _progressViewColor = Color_White;
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    //防止webview内存泄露
    if (_topWebView) {
        [_topWebView loadHTMLString:@"" baseURL:nil];
        [_topWebView stopLoading];
        _topWebView.delegate = nil;
        [_topWebView removeFromSuperview];
    }
    
    [self.wvMainWeb loadHTMLString:@"" baseURL:nil];
    [self.wvMainWeb stopLoading];
    self.wvMainWeb.delegate = nil;
    [self.wvMainWeb removeFromSuperview];
}
-(void)openAppInfoView:(NSNotification *)noti{
    NSDictionary *userInfo = noti.object;
    NSString *appId = userInfo[@"appId"];
    
    [self showLoading:@""];
    
    SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
    controller.delegate = self;
    NSDictionary *params = [NSDictionary dictionaryWithObject:appId // App id
                                                       forKey:SKStoreProductParameterITunesItemIdentifier];
    [controller loadProductWithParameters:params completionBlock:^(BOOL result, NSError *error) {
        if (result)
            [self hideLoading];
            [self presentViewController:controller animated:YES completion:nil];
    }];
}
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - View创建与设置
- (void)setUpView{
    self.navigationItem.title = self.strTitle;
    //    [self baseSetup:PageGobackTypePop];
    
    //创建视图等
    self.navigationItem.leftBarButtonItem = self.backItem;
    __weak __typeof(self)weakSelf = self;
    self.delegate.afterLoadFinish = ^(UIWebView * webView) {
        [weakSelf updateNavigationItems];
        NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (theTitle && ![theTitle isEqualToString:@""] && ![theTitle isEqualToString:APP_NAME]) {
            (weakSelf.navigationItem).title = theTitle;
            if ([theTitle isEqualToString:@"绑定银行卡"]){
                NSString *body = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
                if([body rangeOfString:@"绑卡成功"].location != NSNotFound){
                    [weakSelf showMessage:@"绑卡成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        if ([theTitle isEqualToString:@"页面找不到"]) {
            //清除UIWebView的缓存
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSURLCache * cache = [NSURLCache sharedURLCache];
            [cache removeAllCachedResponses];
            cache.diskCapacity = 0;
            cache.memoryCapacity = 0;
        }
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context[@"shareMethod"] = ^() {
            [weakSelf getShareData];
            weakSelf.navigationItem.rightBarButtonItem = weakSelf.shareBtn;
        };
        NSString * webUrl = webView.request.URL.absoluteString;
        if ([webUrl rangeOfString:@"awardCenter/drawAwardIndex"].location != NSNotFound || [webUrl rangeOfString:@"share"].location != NSNotFound || [webUrl rangeOfString:@"gotoJujiuSong"].location != NSNotFound) {
            [weakSelf getShareData];
            weakSelf.navigationItem.rightBarButtonItem = weakSelf.shareBtn;
        }
    };
    self.delegate.startLoadWithRequest = ^(UIWebView *webView,NSURLRequest *request,UIWebViewNavigationType type) {
        NSLog(@"%@",request.URL.absoluteString);
        
        if ([request.URL.absoluteString hasPrefix:@"www.mobileApprove.com&result=YES"]) {
            [weakSelf showMessage:@"认证成功"];
            if (weakSelf.blockChoose) {
                [weakSelf performSelector:@selector(delayPost) withObject:nil afterDelay:1];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            return NO;
        }else  if ([request.URL.absoluteString hasSuffix:@"www.mobileApprove.com&result=NO"]) {
            [weakSelf showMessage:@"认证失败"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return NO;
        }else if ([request.URL.absoluteString rangeOfString:@"www.moreInfo.com"].location != NSNotFound && request.URL.absoluteString.length>0) {
            //            [weakSelf showMessage:@"认证成功"];
            [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:1];
            return NO;
        }else if ([request.URL.absoluteString rangeOfString:@"www.bindcardinfo.com"].location != NSNotFound && request.URL.absoluteString.length>0) {
            //            [weakSelf showMessage:@"操作完成"];
            [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:1];
            !weakSelf.bindBankcardSuccess ? : weakSelf.bindBankcardSuccess();//绑定银行成功回调
            return NO;
        }else  if ([request.URL.absoluteString rangeOfString:@"www.mobileApprove.com&result=YES"].location !=NSNotFound){
            NSDictionary *dict = [weakSelf splitUrlStringToDictionary:request.URL.absoluteString];
            if ([dict.allKeys containsObject:@"message"]) {
                NSString *str = dict[@"message"];
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"?"];
                str = [[str componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString:@""];
                [weakSelf showMessage:str];
                if (weakSelf.blockChoose) {
                    [weakSelf performSelector:@selector(delayPost) withObject:nil afterDelay:1];
                }else{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [weakSelf showMessage:@"认证成功"];
                if (weakSelf.blockChoose) {
                    [weakSelf performSelector:@selector(delayPost) withObject:nil afterDelay:1];
                }
            }
            return NO;
        }else  if ([request.URL.absoluteString rangeOfString:@"www.iosMessage.com"].location !=NSNotFound){
            NSString *strUrl = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *urlComponents =[strUrl  componentsSeparatedByString:@"&"];
            if (urlComponents.count>=3) {
                NSString *strContent = urlComponents[1];
                strContent =   [strContent stringByReplacingOccurrencesOfString:@"?" withString:@""];
                NSString *strPhone = urlComponents[2];
                
                if (!weakSelf.requestMessage) {
                    weakSelf.requestMessage = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:weakSelf.strAbsoluteUrl]];
                }
                [weakSelf.wvMainWeb loadRequest:weakSelf.requestMessage];
                NSLog(@"%@",urlComponents);
            }
            //            NSDictionary *dict = [weakSelf splitUrlStringToDictionary:];
            
        } else  if ([request.URL.absoluteString rangeOfString:@"www.iosSobot.com"].location !=NSNotFound) {
            return NO;
        } else  if ([request.URL.absoluteString rangeOfString:@"www.iosPhone.com"].location !=NSNotFound) {
            NSString *strUrl = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *urlComponents =[strUrl  componentsSeparatedByString:@"&"];
            if (urlComponents.count>=2) {
                //                NSString *strContent = urlComponents[0];
                NSString *strPhone = urlComponents[1];
                NSString *phone = [strPhone stringByReplacingOccurrencesOfString:@"?" withString:@""];
                [weakSelf alert:phone];
            }
            return NO;
        }
        [weakSelf updateNavigationItems];
        return YES;
    };
    
    //进入支付宝爬数据
    if ([_strType isEqualToString:@"ZFB"]) {
        NWebView * webview = [[NWebView alloc] initWithFrame:self.view.bounds];
        webview.delegate = self.progressProxy;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_strAbsoluteUrl]]];
        webview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        webview.backgroundColor = [UIColor whiteColor];
        [webview setUserInteractionEnabled:YES];
        [webview setMultipleTouchEnabled:YES];
        [webview setScalesPageToFit:YES];     //yes:根据webview自适应，NO：根据内容自适应
        
        webview.scrollView.bounces = _canScroll;
        webview.uid = ([UserManager sharedUserManager].userInfo.uid).integerValue;
        webview.title = self.navTitle;
        //        webview.haveRightButtonItem = self.rightBarButtonItem || self.rightBarButtonItems;
        //        [self.webViewArray addObject:webview];
        
        self.topWebView = webview;
        [self.view addSubview:self.topWebView];
    }else{
        _wvMainWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.wvMainWeb.delegate = self.progressProxy;
        self.wvMainWeb.scalesPageToFit = YES;
        self.wvMainWeb.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.wvMainWeb];
        
    }
}

#pragma mark - 初始化数据源
- (void)setStrTitle:(NSString *)strTitle{
    _strTitle = strTitle;
    self.navigationItem.title = _strTitle;
}

- (void)setStrAbsoluteUrl:(NSString *)strAbsoluteUrl{
    if (!strAbsoluteUrl || [strAbsoluteUrl isEqualToString:@""]) {
        _strAbsoluteUrl = @"http://www.pettycash.cn";
    } else {
        _strAbsoluteUrl = strAbsoluteUrl;
        
    }
    
    if ([_strAbsoluteUrl  rangeOfString:@"gotoRepaymentType?type=1"].location == NSNotFound && ![_strType isEqualToString:@"LendDesc"]){
        _strAbsoluteUrl = [[NetworkSingleton sharedManager] handleUrlWithParamWithStr:_strAbsoluteUrl];
    }
    if ([_strAbsoluteUrl  rangeOfString:@"http://"].location == NSNotFound && [_strAbsoluteUrl  rangeOfString:@"https://"].location == NSNotFound){
        _strAbsoluteUrl = [[NSString alloc] initWithFormat:@"http://%@",_strAbsoluteUrl];
    }
    
    [self loadData];
}

- (void)setStrHtmlBody:(NSString *)strHtmlBody{
    _strHtmlBody = strHtmlBody;
    [self.wvMainWeb loadHTMLString:_strHtmlBody baseURL:nil];
}

-(void)setProgressViewColor:(UIColor *)progressViewColor{
    _progressViewColor = progressViewColor;
    self.progressView.progressColor = progressViewColor;
}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
}

#pragma mark - 点击事件

// 呼叫客服电话
- (void)alert:(NSString *)phone {
    
    NSString *phone1 = [NSString stringWithFormat:@"telprompt://%@", phone];
    NSURL *phoneU = [NSURL URLWithString:phone1];
    if (IOS_VERSION >= 10) {
        [[UIApplication sharedApplication] openURL:phoneU options:@{} completionHandler:nil];
    } else {
        
        [[UIApplication sharedApplication] openURL:phoneU];
    }
}


- (void)goShare {
    if ([[UserManager sharedUserManager] checkLogin:self]) {
        if (self.meModel == nil) {
            return;
        }
        [self share];
    }
}
- (void)share {
    NSDictionary *dic = @{
                          @"shareBtnTitle":@"分享",
                          @"isShare":@"1",
                          @"share_title":self.meModel.share_title ? self.meModel.share_title : @"",
                          @"share_body":self.meModel.share_body ? self.meModel.share_body :@"",
                          @"share_logo":self.meModel.share_logo ? self.meModel.share_logo :@"",
                          @"sharePlatform":@[@"wx",@"wechatf",@"qq",@"qqzone"],
                          @"share_url":self.meModel.share_url ? self.meModel.share_url : @""};
    ShareEntity *entitys = [ShareEntity shareWithDict:dic];
    [[ShareManager shareManager]showWithShareEntity:entitys];
}

#pragma mark - 请求数据
- (void)getShareData {
    [self.request getUserInfoWithDict:nil onSuccess:^(NSDictionary *dictResult) {
        self.meModel = [MeModel meModelWithDic:dictResult[@"share"]];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"您的登录态已失效，请重新登录" leftButtonTitle:nil rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [UserDefaults setObject:@"" forKey:@"sessionid"];
            [[UserManager sharedUserManager] checkLogin:self];
        };
        [alert show];
    }];
}

#pragma mark - Delegate


-(void)delayPost{
    [self.navigationController popViewControllerAnimated:YES];
    self.blockChoose();
}

- (NSDictionary*)splitUrlStringToDictionary:(NSString*)strUrl{
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSRange range = [strUrl rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return queryStringDictionary;
    }
    NSArray *urlComponents = [[strUrl substringFromIndex:(range.location + range.length)] componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents){
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"-"];
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        queryStringDictionary[key] = value;
    }
    return queryStringDictionary;
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:NO];
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    if (progress ==1.0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


#pragma mark - 请求数据
//加载网页
- (void)loadData{
    NSURL *url = [[NSURL alloc] initWithString:self.strAbsoluteUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLRequest allowsAnyHTTPSCertificateForHost:url.host];
    [self.wvMainWeb loadRequest:request];
}

#pragma mark - Other

- (void)updateNavigationItems {
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -5;
    if (self.wvMainWeb.canGoBack) {
        //        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.backItem,self.closeButtonItem] animated:NO];
    }else{
        //        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        (self.navigationItem).leftBarButtonItems = @[spaceButtonItem,self.backItem];
    }
}

//关闭H5页面，直接回到原生页面
- (void)popNactive {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popVC{
    if ([_strType isEqualToString:@"ZCXY"]||[_strType isEqualToString:@"XYXY"]) {
        [self dismissVC];
        return;
    }
    if ((self.wvMainWeb).canGoBack) {
        [self.wvMainWeb goBack];
    }else {
        [self popNactive];
    }
    
}

- (MeRequest *)request{
    if (!_request) {
        _request = [[MeRequest alloc] init];
    }
    return _request;
}

- (UIBarButtonItem *)shareBtn {
    if (!_shareBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"分享" forState:normal];
        [button addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.titleLabel.font = Font_Title;
        [button setTitleColor:Color_White forState:normal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _shareBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _shareBtn;
}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(popNactive)];
        [_closeButtonItem setTintColor:Color_White];
    }
    return _closeButtonItem;
}

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:ImageNamed(@"navigationBar_popBack") forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
        (btn.titleLabel).font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.frame = CGRectMake(-5, 0, 16, 16);
        _backItem.customView = btn;
    }
    return _backItem;
}

-(NJKWebViewProgressView*)progressView{
    if (!_progressView) {
        CGFloat progressBarHeight = 2.0f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.progressColor = self.progressViewColor;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _progressView;
}

-(NJKWebViewProgress*)progressProxy{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self.delegate;
        _progressProxy.progressDelegate = (id)self;
    }
    return _progressProxy;
}

- (NWebViewDelegate *)delegate
{
    if (!_delegate) {
        _delegate = [[NWebViewDelegate alloc] init];
        _delegate.viewController = self;
    }
    //    _delegate.shareData = _shareData;
    return _delegate;
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
