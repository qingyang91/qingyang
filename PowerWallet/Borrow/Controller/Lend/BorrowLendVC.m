//
//  BorrowLendVC.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/21.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "BorrowLendVC.h"
#import "UserManager.h"
#import "DXAlertView.h"
#import "UIImageview+WebCaChe.h"
#import "CCPScrollView.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "CommonWebVC.h"
#import "MeLoanVC.h"
#import "MeOutLoanVC.h"
#import "HomeRequest.h"
#import "YJSliderView.h"
#import "SliderContentViewController.h"
#import "GoodLendViewCell.h"
#import "GoodeOutViewCell.h"
#import "BlendModel.h"
#import "BorrowLendRequest.h"
#import "GoodOutModel.h"
#import "GoodLendModel.h"
#import "GoodOutLendVC.h"
#import "GoodLendDataVC.h"
#import "LoginViewController.h"
#define RATE SCREEN_WIDTH/320.0
@interface BorrowLendVC ()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate,UIScrollViewDelegate,YJSliderViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  BorrowLendRequest *request;
@property (nonatomic, retain) UIView            *headerView;
@property (nonatomic, strong) DXAlertView       *alertView;
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *imageDatas;
@property (strong, nonatomic) CCPScrollView     *descLabel;
@property (nonatomic, strong) HomeRequest *homeRequest;
@property (nonatomic, assign) int  statisticsCount;
@property (nonatomic, strong) ImagesModel *imageModel;
@property (nonatomic, strong) YJSliderView *sliderView;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *goodLend;
@property (nonatomic, strong) UITableView *goodOut;
@property (nonatomic, strong) BlendModel *model;
@property (nonatomic, strong) GoodLendModel *goodLendModel;
@property (nonatomic, strong) GoodOutModel  *goodOutModel;
@property (nonatomic, strong) NSMutableArray *lendArray;
@property (nonatomic, strong) NSMutableArray *outLendArray;
@end

@implementation BorrowLendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self umengEvent:@"Me" attributes:nil number:@10];
    self.navigationItem.title = @"借条";
    [self creatUI];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    [self loadData];
    //    [self getLendData];
    //    [self getOutLendData];
    self.navigationItem.title = @"借条";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark - 加载网络数据
- (NSMutableArray *)lendArray{
    if (!_lendArray) {
        _lendArray = [NSMutableArray new];
    }
    return _lendArray;
}
- (NSMutableArray *)outLendArray{
    if (!_outLendArray) {
        _outLendArray = [NSMutableArray new];
    }
    return _outLendArray;
}
- (BorrowLendRequest *)request{
    if (!_request) {
        _request = [[BorrowLendRequest alloc]init];
    }
    return _request;
}
- (BlendModel *)model{
    if (!_model) {
        _model = [[BlendModel alloc]init];
    }
    return _model;
}
- (GoodLendModel *)goodLendModel{
    if (!_goodLendModel) {
        _goodLendModel = [[GoodLendModel alloc]init];
    }
    return _goodLendModel;
}
- (GoodOutModel *)goodOutModel{
    if (!_goodOutModel) {
        _goodOutModel = [[GoodOutModel alloc]init];
    }
    return _goodOutModel;
}
//加载数据
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    [self.request getBorrowYouLendIndexWithDict:@{} onSuccess:^(NSDictionary *dictResult){
        self.model = [BlendModel helpLendWithDict:dictResult];
        [self hideLoading];
        //刷新数据
        [self showData:self.model];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        if (code == -2) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"您的登录态已失效，请重新登录" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [[UserManager sharedUserManager] checkLogin:self];
            };
            [alert show];
        }
        else{
            [self.view bringSubviewToFront:self.vNoNet];
            self.vNoNet.hidden = NO;
        }
    }];
}
-(void)showData:(BlendModel *)entity{
    [_imageDatas removeAllObjects];
    self.imageDatas = [NSMutableArray arrayWithArray:entity.banners];
    if (self.imageDatas.count>1) {
        self.pagerView.isInfiniteLoop = YES;
    }else{
        self.pagerView.isInfiniteLoop = NO;
    }
    self.pageControl.numberOfPages = self.imageDatas.count;
    [self.pagerView reloadData];
   
    self.descLabel.titleArray = entity.rolls;
}
- (void)getLendData{
    [self.request getRootLendIndexWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        self.goodLendModel = [GoodLendModel helpLendWithDict:dictResult];
        [_lendArray removeAllObjects];
        _lendArray = [NSMutableArray arrayWithArray:_goodLendModel.items];
        [self.goodLend reloadData];
        [self.goodLend.mj_header endRefreshing];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self showMessage:errorMsg];
        [self.goodLend.mj_header endRefreshing];
    }];
}
- (void)getOutLendData{
    [self.request getRootLendOutIndexWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self showMessage:errorMsg];
        [self.goodOut.mj_header endRefreshing];
    }];
}
#pragma mark -- UI
- (void)creatUI{
    [self.view addSubview:self.headerView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sliderView = [[YJSliderView alloc] initWithFrame:CGRectMake(0, 280, SCREEN_WIDTH, SCREEN_HEIGHT-280)];
    self.sliderView.delegate = self;
    self.titleArray = @[@"优质|借款方", @"优质|出借方"];
    _goodLend = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, SCREEN_HEIGHT-280) style:UITableViewStylePlain];
    _goodLend.delegate = self;
    _goodLend.dataSource = self;
    _goodLend.backgroundColor = [UIColor whiteColor];
    _goodLend.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_goodLend registerNib:[UINib nibWithNibName:@"GoodLendViewCell" bundle:nil] forCellReuseIdentifier:@"GoodLendViewCell"];
    _goodOut = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, SCREEN_HEIGHT-280) style:UITableViewStylePlain];
    _goodOut.delegate = self;
    _goodOut.dataSource = self;
    _goodOut.backgroundColor = [UIColor whiteColor];
    _goodOut.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_goodOut registerNib:[UINib nibWithNibName:@"GoodeOutViewCell" bundle:nil] forCellReuseIdentifier:@"GoodeOutViewCell"];
    [self.view addSubview:self.sliderView];
}
#pragma slideViewd 代理
- (NSInteger)numberOfItemsInYJSliderView:(YJSliderView *)sliderView {
    return 2;
}
- (UIView *)yj_SliderView:(YJSliderView *)sliderView viewForItemAtIndex:(NSInteger)index {
    SliderContentViewController *vc = [[SliderContentViewController alloc]init];
    if (index == 0) {
        [vc.view addSubview:_goodLend];
        vc.view.backgroundColor = Color_Background;
    } else if (index == 1) {
        [vc.view addSubview:_goodOut];
        vc.view.backgroundColor = Color_Background;
    }
    return vc.view;
}

- (NSString *)yj_SliderView:(YJSliderView *)sliderView titleForItemAtIndex:(NSInteger)index {
    return self.titleArray[index];
}

- (NSInteger)initialzeIndexFoYJSliderView:(YJSliderView *)sliderView {
    return 0;
}
#pragma mark - UI懒加载
-(TYCyclePagerView *)pagerView{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc] init];
        _pagerView.isInfiniteLoop = YES;
        _pagerView.autoScrollInterval = 3.0;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        
        [_pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _pagerView;
}
-(TYPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[TYPageControl alloc]init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    }
    return _pageControl;
}
-(UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 320.5*WIDTHRADIUS)];
        _headerView.backgroundColor = Color_White;
        
        [_headerView addSubview:self.pagerView];
        [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_headerView.mas_top).with.offset(0);
            make.left.equalTo(_headerView.mas_left).with.offset(0);
            make.right.equalTo(_headerView.mas_right).with.offset(0);
            make.height.equalTo(@(175*WIDTHRADIUS));
        }];
        
        [_headerView addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(@0);
            make.bottom.equalTo(self.pagerView).with.offset(0);
            make.height.equalTo(@26);
        }];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"hl_inform"];
        [_headerView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView.mas_left).with.offset(kPaddingLeft);
            make.top.equalTo(self.pagerView.mas_bottom).with.offset(13);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
        
        [_headerView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).with.offset(10);
            make.height.equalTo(@30);
            make.top.equalTo(self.pagerView.mas_bottom).with.offset(5);
        }];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:Color_White forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.backgroundColor = [UIColor colorWithRed:255/255.0 green:158/255.0 blue:0 alpha:1.0];
        button.frame = CGRectMake(10*RATE, 230, SCREEN_WIDTH-20*RATE, 40);
        [_headerView addSubview:button];
        [button setTitle:@"求借款" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goLend) forControlEvents:UIControlEventTouchUpInside];
        UIButton *outbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [outbutton setTitleColor:Color_White forState:UIControlStateNormal];
        outbutton.layer.cornerRadius = 5;
        outbutton.layer.masksToBounds = YES;
        outbutton.titleLabel.font = [UIFont systemFontOfSize:16];
        outbutton.backgroundColor = [UIColor colorWithRed:255/255.0 green:158/255.0 blue:0 alpha:1.0];
        outbutton.frame = CGRectMake(10*RATE+120*RATE+60, 230, 120*RATE, 40);
        [outbutton setTitle:@"去出借" forState:UIControlStateNormal];
        [outbutton addTarget:self action:@selector(outLend) forControlEvents:UIControlEventTouchUpInside];
//        [_headerView addSubview:outbutton];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 270, SCREEN_WIDTH, 10)];
        view.backgroundColor = Color_Tabbar_LineColor;
        [_headerView addSubview:view];
    }
    return _headerView;
}
-(CCPScrollView *)descLabel{
    if(!_descLabel){
        _descLabel = [[CCPScrollView alloc] initWithFrame:CGRectMake(35, ViewHeight(self.pagerView), SCREEN_WIDTH - 80, 30)];
        _descLabel.textAlignment = YES;
        _descLabel.titleFont = 12;
        _descLabel.titleColor = Color_Title_Black;
    }
    return _descLabel;
}
- (void)goLend{
    if (![[UserManager sharedUserManager] isLogin]) {
        LoginViewController *vcLogin = [[LoginViewController alloc] init];
        UINavigationController *vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcLogin];
        [self presentViewController:vcNavigation animated:YES completion:nil];
    }else{
        MeLoanVC *vc = [[MeLoanVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)outLend{
    if (![[UserManager sharedUserManager] isLogin]) {
        LoginViewController *vcLogin = [[LoginViewController alloc] init];
        UINavigationController *vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcLogin];
        [self presentViewController:vcNavigation animated:YES completion:nil];
    }else{
        MeOutLoanVC *vc = [[MeOutLoanVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (tableView == _goodLend) {
    //        return _lendArray.count;
    //    }else{
    //        return _outLendArray.count;
    //    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _goodLend) {
        return 120;
    }else {
        return 180;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _goodLend) {
        GoodLendViewCell *cell = [_goodLend dequeueReusableCellWithIdentifier:@"GoodLendViewCell" forIndexPath:indexPath];
        cell.findView.layer.cornerRadius = 5;
        cell.findView.layer.masksToBounds = YES;
        //        GoodItemModel *model =_lendArray[indexPath.row];
        //        cell.moneyCount.text = model.borrow_money;
        //        cell.lendDay.text = model.borrow_time;
        //        cell.yearRateService.text = model.year_rate;
        //        cell.userName.text = model.borrow_user.username;
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        GoodeOutViewCell *cell = [_goodOut dequeueReusableCellWithIdentifier:@"GoodeOutViewCell" forIndexPath:indexPath];
        cell.findView.layer.cornerRadius = 5;
        cell.findView.layer.masksToBounds = YES;
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _goodLend) {
        if (![[UserManager sharedUserManager] isLogin]) {
            LoginViewController *vcLogin = [[LoginViewController alloc] init];
            UINavigationController *vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcLogin];
            [self presentViewController:vcNavigation animated:YES completion:nil];
        }else{
            GoodLendDataVC *vc = [[GoodLendDataVC alloc]init];
            [self dsPushViewController:vc animated:YES];
        }
    }else{
        if (![[UserManager sharedUserManager] isLogin]) {
            LoginViewController *vcLogin = [[LoginViewController alloc] init];
            UINavigationController *vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcLogin];
            [self presentViewController:vcNavigation animated:YES completion:nil];
        }else{
            GoodOutLendVC *vc = [[GoodOutLendVC alloc]init];
            [self dsPushViewController:vc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    if (_imageDatas.count == 0) {
        return 1;
    }else{
        return _imageDatas.count;
    }
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    if (_imageDatas.count == 0) {
        cell.imageView.image = [UIImage imageNamed:@"banner1"];
    }else {
        ImagesModel *banner = self.imageDatas[index];
        if (banner.img.length != 0) {
            NSURL *url = [[NSURL alloc] initWithString:banner.img];
            [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner_loadding"] options:SDWebImageAllowInvalidSSLCertificates|SDWebImageRetryFailed completed:^(UIImage *_Nullable image,NSError * _Nullable error,SDImageCacheType cacheType,NSURL * _Nullable imageURL){
                if (error != nil) {
                    //            cell.imageView.image = [UIImage imageNamed:@"banner_load_failure"];
                    if (index%2 == 0) {
                        cell.imageView.image = [UIImage imageNamed:@"banner"];
                    }else{
                        cell.imageView.image = [UIImage imageNamed:@"banner1"];
                    }
                }
            }];
        }
    }
    return cell;
}
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 15;
    layout.itemHorizontalCenter = YES;
    return layout;
}
- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    
}
-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    if(![[UserManager sharedUserManager] isLogin])
    {
        [[UserManager sharedUserManager]showLoginPage:self];
        return;
    }
    if (_imageDatas.count != 0) {
        ImagesModel *banner = self.imageDatas[index];
        if (banner.link.length != 0) {
            CommonWebVC *vc = [[CommonWebVC alloc]init];
            vc.strAbsoluteUrl = banner.link;
            [self dsPushViewController:vc animated:YES];
        }
    }
}
-(void)downloadWithUrl:(NSString *)url{
    if (IOS_VERSION >= 10) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        }
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
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

