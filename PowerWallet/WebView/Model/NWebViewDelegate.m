//
//  NWebViewDelegate.m
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/20.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "NWebViewDelegate.h"
#import "NWebView.h"
#import "CommonWebVC.h"
#import "UserManager.h"
#import "NSString+Url.h"
#import "NSString+Additions.h"
#import "GToolUtil.h"

static NSString * const AppNAME = @"助力凭条";
@interface NWebViewDelegate ()

@property (nonatomic, retain) JSContext *context;
@property (nonatomic, strong) UIBarButtonItem   *closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem   *backItem;

@end

@implementation NWebViewDelegate

//代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSDictionary *dicURLParam = [request.URL.absoluteString urlParam];
    if ([[GToolUtil getNetworkType] isEqualToString:@""] && dicURLParam[@"_bid"]) {
        //        [[iToast makeText:@"当前网络断开啦，请检查网络连接"] show];
        [self showMessage:@"当前网络断开啦，请检查网络连接"];
    }
    
    BOOL isShortUrl = [self shortUrlAction:webView request:request];
    if (!isShortUrl) {
        return NO;
    }
    
    BOOL startBlock = YES;
    if (self.startLoadWithRequest) {
        startBlock = self.startLoadWithRequest(webView,request,navigationType);
    }
    if (!startBlock) {
        return NO;
    }
    
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked && [request.URL.absoluteString rangeOfString:@".pdf"].location != NSNotFound) {
        CommonWebVC *webViewVC = [[CommonWebVC alloc] init];
        webViewVC.strAbsoluteUrl = request.URL.absoluteString;
        [self.viewController.navigationController pushViewController:webViewVC animated:YES];
        return NO;
    }
    
    //写cookie  写入参数交给KDURLProtocol处理
    //    [[UserManager sharedUserManager] writeCookie:[request URL].absoluteString];
    
    NSString *weburl = request.URL.absoluteString;
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:weburl]];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject]) {
        NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
        if([cookie.name isEqualToString:@"ALIPAYJSESSIONID"]){
            
            NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
        }
    }

    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"nativeMethod"] = webView;
    if ([[webView class] isSubclassOfClass:[NWebView class]]) {
        ((NWebView * )webView).js_Context  = _context ;
    }
    _context[@"shareMethod"] = ^() {
        NSArray * arr = [JSContext currentArguments];
        for (id obj in arr) {
            NSLog(@"%@",obj);
        }
    };
    
    if ([request.URL.absoluteString rangeOfString:@"https://itunes.apple.com/"].location != NSNotFound) {
        NSArray *array = [request.URL.absoluteString componentsSeparatedByString:@"https://itunes.apple.com/"];
        NSArray *newArray = [array[1] componentsSeparatedByString:@"/id"];
        NSString *appleId = [newArray[1] componentsSeparatedByString:@"?"].firstObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAppInfoView" object:@{@"appId":appleId}];
        return NO;
    }
    
    NSString *htmlStr = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    if ([htmlStr rangeOfString:@"https://itunes.apple.com/"].location != NSNotFound) {
        NSArray *array = [htmlStr componentsSeparatedByString:@"https://itunes.apple.com/"];
        NSArray *newArray = [array[1] componentsSeparatedByString:@"/id"];
        NSString *appleId = [newArray[1] componentsSeparatedByString:@"?"].firstObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAppInfoView" object:@{@"appId":appleId}];
        return NO;
    }
    
    NSLog(@"%@",request.URL);
    return YES;
}
- (void)showMessage:(NSString *)msg{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeText;
    //    hud.label.text = [TipMessage shared].tipMessage.tipTitle;
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = FONT(18);
    hud.margin = 25;
    hud.backgroundView.alpha = 0.8;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.didStartLoadWithRequest) {
        self.didStartLoadWithRequest(webView);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.afterLoadFinish) {
        self.afterLoadFinish(webView);
    }
    
    NSNotification *noti = [[NSNotification alloc] initWithName:@"bid_notification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    //添加js交互context
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"nativeMethod"] = webView;
    if ([[webView class] isSubclassOfClass:[NWebView class]]) {
        ((NWebView * )webView).js_Context  = _context ;
    }
    
    if([webView.request.URL.absoluteString rangeOfString:@"pid="].location != NSNotFound){
        NSNotification *noti = [[NSNotification alloc] initWithName:@"ReportStatistics" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    
    if([webView.request.URL.absoluteString rangeOfString:@"banner_pid="].location != NSNotFound){
        NSNotification *noti = [[NSNotification alloc] initWithName:@"BannerReportStatistics" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    
    if([webView.request.URL.absoluteString rangeOfString:@"HelpMe_pid="].location != NSNotFound){
        NSNotification *noti = [[NSNotification alloc] initWithName:@"HelpMeReportStatistics" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }

    NSString * jsUrl_f =@"resources/js/alipay.js";// [[ConfigManage shareConfigManage] configForKey:@"info_capture_script"];
    NSString * jsUrl = [NSString stringWithFormat:@"%@%@",Base_URL1,jsUrl_f];

    NSArray *  strArr= @[@"alipay",@"taobao"];//[[ConfigManage shareConfigManage]configForKey:@"infoCaptureDomain"];
    [strArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([webView.request.URL.absoluteString containsString:obj]) {
            NSString *jsStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:jsUrl?jsUrl:@""] encoding:NSUTF8StringEncoding error:nil];
            
            [webView stringByEvaluatingJavaScriptFromString:jsStr];
            
            *stop = YES;
        }
    }];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.afterLoadFaild) {
        self.afterLoadFaild(webView);
    }
}

//url拼接参数
- (NSString *)urlAddParam:(NSURL *)url
{
    __block NSString *str = url.absoluteString;
    str = [NSString addQueryStringToUrl:str params:@{@"fromapp": @1,@"clientType":@"ios"}];
    str = [NSString stringWithFormat:@"%@&%@",str,[GToolUtil getCurrentAppVersionCode]];
    NSArray *forbiddenArray = @[@" ",@"\r",@"\n"];
    [forbiddenArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        
        str = [str stringByReplacingOccurrencesOfString:obj withString:@""];
    }];
    return str;
}


#pragma mark 短链接事件处理
- (BOOL)shortUrlAction:(UIWebView *)webView request:(NSURLRequest *)request
{
    //    __weak typeof(self) weakSelf = self;
    if ([request.URL.absoluteString hasPrefix:@"koudaikj://app.launch/login/applogin"]) {
        [[UserManager sharedUserManager]checkLogin:self.viewController];
        //        [GToolUtil checkLogin:nil target:self];
        return NO;
    }
    return YES;
}

#pragma mark 支付宝，淘宝上传
- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
