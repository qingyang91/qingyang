//
//  RootVC.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/8.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "RootVC.h"
#import "UserManager.h"
#import "HomeRequest.h"
#import "DXAlertView.h"
#import "RootCell.h"
#import "ActivityCell.h"
#import "HomeModel.h"
#import "UIImageview+WebCaChe.h"
#import "ActivityHeaderView.h"
#import "LendDescVC.h"
#import "CommonWebVC.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "BannerModel.h"

//#import <StoreKit/StoreKit.h>

@interface RootVC ()<UITableViewDelegate,UITableViewDataSource,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate
//,SKStoreProductViewControllerDelegate
>
@property (nonatomic, retain) UIView            *headerView;
@property (nonatomic, retain) UIView            *footerView;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, retain) NSMutableArray    *arrData;
@property (nonatomic, strong) HomeRequest       *request;
@property (nonatomic, strong) HomeModel          *homeModel;
@property (nonatomic, strong) DXAlertView       *alertView;

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *imageDatas;


@property (nonatomic, strong) ActivityHeaderView * activityHeaderView;

@property (nonatomic, retain) NSMutableArray <UIButton *> *dateButtuns;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) int pagesize;
@property (nonatomic, strong) UIButton *redEnvelopesBtn;

@property (nonatomic, assign) int  statisticsCount;

@property (nonatomic, strong) BannerModel *banner;
@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.pagesize = 10;
    //添加rightBarButtonItem
    [self umengEvent:@"Me" attributes:nil number:@10];
    self.navigationItem.title = APP_NAME;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportStatis:) name:@"BannerReportStatistics" object:nil];
    //新UI
    //    [self addRightTabbarBar];
    [self createUI];
}

-(void)reportStatis:(NSNotification *)con{
    if(self.statisticsCount == 0){
        NSDictionary *dict = @{@"uid" : ([UserManager sharedUserManager].userInfo.uid.length == 0) ? @"0" : [UserManager sharedUserManager].userInfo.uid,
                               @"pid" : self.banner.pid,
                               @"type": @"1"};
        [self.request reportStatisticsWithDict:dict onSuccess:^(NSDictionary *dic){
            
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            
        }];
        self.statisticsCount++;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    [self loadData];
    
    self.navigationItem.title = @"助力凭条";
    [self redEnvelopesAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark - 加载网络数据
- (HomeRequest *)request{
    
    if (!_request) {
        _request = [[HomeRequest alloc] init];
    }
    
    return _request;
}
//加载数据、刷新数据
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    self.page = 1;
    [self.request getHomeDataWithDict:@{@"page":@"1",@"pagesize":@"10"} onSuccess:^(NSDictionary *dictResult) {
        self.homeModel = [HomeModel homeWithDict:dictResult];
        [self hideLoading];
        //刷新数据
        [self showData:self.homeModel];
        [self.tableView.mj_header endRefreshing];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self.tableView.mj_header endRefreshing];
        if (code == -2) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"您的登录态已失效，请重新登录" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                
                [[UserManager sharedUserManager] checkLogin:self];
            };
            [alert show];
        }else{
            [self.view bringSubviewToFront:self.vNoNet];
            self.vNoNet.hidden = NO;
        }
        
    }];
}
///上拉加载更多数据
-(void)loadMoreData{
    [self showLoading:@""];
    self.page++;
    [self.request getHomeDataWithDict:@{@"page":[NSString stringWithFormat:@"%d",self.page],@"pagesize":@"10"} onSuccess:^(NSDictionary *dictResult) {
        HomeModel *model = [HomeModel homeWithDict:dictResult];
        
        [self hideLoading];
        //刷新数据
        NSMutableArray *list = self.arrData[1];
        
        [list addObjectsFromArray:model.list];
        [self.tableView.mj_footer endRefreshing];
        self.arrData[1] = list;
        
        [self.tableView reloadData];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self.tableView.mj_footer endRefreshing];
        if (code == -2) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"您的登录态已失效，请重新登录" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                
                [[UserManager sharedUserManager] checkLogin:self];
            };
            [alert show];
        }else{
            [self.view bringSubviewToFront:self.vNoNet];
            self.vNoNet.hidden = NO;
        }
        
    }];
}

-(void)showData:(HomeModel *)entity{
    [_imageDatas removeAllObjects];
    
    self.imageDatas = [NSMutableArray arrayWithArray:entity.banner];
    if (self.imageDatas.count>1) {
        self.pagerView.isInfiniteLoop = YES;
    }else{
        self.pagerView.isInfiniteLoop = NO;
        BannerModel *banner = [[BannerModel alloc] init];
        banner.img = @"hl_banner";
        banner.banner_type = 0;
        [self.imageDatas addObject:banner];
    }
    self.pageControl.numberOfPages = self.imageDatas.count;
    [self.pagerView reloadData];
    
    NSArray *array;
    array = @[
              @[entity.roll],
              entity.list
              ];
    
    self.arrData = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}

#pragma mark -- UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.redEnvelopesBtn];
    //新UI
    [self.redEnvelopesBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
}
-(void)redEnvelopesAnimation{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shake.fromValue = [NSNumber numberWithFloat:0];
    shake.toValue = [NSNumber numberWithFloat:20];
    shake.duration = 0.4;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 3;//次数
    [self.redEnvelopesBtn.layer addAnimation:shake forKey:@"shakeAnimation"];
}
#pragma mark - UI懒加载
-(UIButton *)redEnvelopesBtn{
    if (!_redEnvelopesBtn) {
        _redEnvelopesBtn = [[UIButton alloc] init];
        [_redEnvelopesBtn setImage:[UIImage imageNamed:@"root_redEnvelopes"] forState:UIControlStateNormal];
        [_redEnvelopesBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redEnvelopesBtn;
}

-(void)clickBtn:(UIButton *)btn{
    if(![[UserManager sharedUserManager] isLogin])
    {
        [[UserManager sharedUserManager]showLoginPage:self];
        return;
    }

    CommonWebVC *com = [[CommonWebVC alloc] init];
    com.strType = @"LendDesc";
    com.strAbsoluteUrl = @"http://www.pettycash.cn/login?user_from=14";
    [self dsPushViewController:com animated:YES];
}

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

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = Color_TABBG;
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175*WIDTHRADIUS)];
        _headerView.backgroundColor = Color_TABBG;
        [_headerView addSubview:self.pagerView];
        [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_headerView.mas_top).with.offset(0);
            make.left.equalTo(_headerView.mas_left).with.offset(0);
            make.right.equalTo(_headerView.mas_right).with.offset(0);
            make.bottom.equalTo(_headerView.mas_bottom).with.offset(0);
        }];
        
        [_headerView addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(@0);
            make.bottom.equalTo(self.headerView).with.offset(0);
            make.height.equalTo(@26);
        }];
        
    }
    return _headerView;
}

- (ActivityHeaderView *)activityHeaderView {
    if (!_activityHeaderView) {
        _activityHeaderView = [[ActivityHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    }
    return _activityHeaderView;
}

- (NSMutableArray *)arrData
{
    
    if (_arrData == nil) {
        _arrData = [[NSMutableArray alloc] init];
    }
    return _arrData;
}

- (NSMutableArray<UIButton *> *)dateButtuns {
    
    if (!_dateButtuns) {
        _dateButtuns = [NSMutableArray array];
    }
    return _dateButtuns;
}

- (HomeModel *)homeModel{
    
    if (!_homeModel) {
        _homeModel = [[HomeModel alloc] init];
    }
    return _homeModel;
}

#pragma mark --UITableView代理


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrData.count == 0){
        return 0;
    }
    NSArray *array = self.arrData[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 75;
    }
    return 116;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 10;
    }else{
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return nil;
    }else{
        [self.activityHeaderView updateConstraints];
        return self.activityHeaderView;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        ActivityCell *cell = [ActivityCell activityCellWithTableView:tableView];
        NSArray *array = self.arrData[indexPath.section];
        [cell configCellWithDict:array[indexPath.row] indexPath:indexPath];
        return cell;
    }else{
        RootCell *cell = [RootCell rootCellWithTableView:tableView];
        NSArray *array = self.arrData[indexPath.section];
        PartnerInfoModel *model = array[indexPath.row];
        [cell configCellWithDict:model indexPath:indexPath];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSArray *array = self.arrData[indexPath.section];
        PartnerInfoModel *model = array[indexPath.row];
        
        LendDescVC *spLVc = [[LendDescVC alloc] init];
        spLVc.pid = model.pid;
        [self dsPushViewController:spLVc animated:YES];
    }
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _imageDatas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    BannerModel *banner = self.imageDatas[index];
    
    if ([banner.img rangeOfString:@"http"].location == NSNotFound) {
        cell.imageView.image = [UIImage imageNamed:banner.img];
    }else{
        NSURL *url = [[NSURL alloc] initWithString:banner.img];
        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hl_banner"] options:SDWebImageAllowInvalidSSLCertificates|SDWebImageRetryFailed completed:^(UIImage *_Nullable image,NSError * _Nullable error,SDImageCacheType cacheType,NSURL * _Nullable imageURL){
            if (error!=nil) {
                if (index%2 == 0) {
                    cell.imageView.image = [UIImage imageNamed:@"hl_banner"];
                }else{
                    cell.imageView.image = [UIImage imageNamed:@"hl_banner"];
                }
            }
        }];
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
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    BannerModel *banner = self.imageDatas[index];
    self.banner = banner;
    if(![[UserManager sharedUserManager] isLogin])
    {
        [[UserManager sharedUserManager]showLoginPage:self];
        return;
    }
    if (banner.banner_type == 0) {
        
    }else if (banner.banner_type == 1){
        self.statisticsCount = 0;
        NSString *url = @"";
        if([banner.banner_ios_h5 rangeOfString:@"?"].location == NSNotFound){
            url = [[NSString alloc] initWithFormat:@"%@?banner_pid=%@",banner.banner_ios_h5,banner.pid];
        }else{
            url = [[NSString alloc] initWithFormat:@"%@&banner_pid=%@",banner.banner_ios_h5,banner.pid];
        }
        CommonWebVC *com = [[CommonWebVC alloc] init];
        com.strAbsoluteUrl = url;
        [self dsPushViewController:com animated:YES];
    }else if (banner.banner_type == 2){
        self.statisticsCount = 0;
        NSString *url = @"";
        if([banner.banner_ios_download rangeOfString:@"?"].location == NSNotFound){
            url = [[NSString alloc] initWithFormat:@"%@?banner_pid=%@",banner.banner_ios_download,banner.pid];
        }else{
            url = [[NSString alloc] initWithFormat:@"%@&banner_pid=%@",banner.banner_ios_download,banner.pid];
        }

        CommonWebVC *com = [[CommonWebVC alloc] init];
        com.strAbsoluteUrl = url;
        [self dsPushViewController:com animated:YES];
//        NSString *downloadStr = banner.banner_download;
//        if ([downloadStr  rangeOfString:@"http://"].location == NSNotFound && [downloadStr  rangeOfString:@"https://"].location == NSNotFound){
//            downloadStr = [[NSString alloc] initWithFormat:@"http://%@",downloadStr];
//        }
//        [self downloadWithUrl:downloadStr];
    }else{
        LendDescVC *spLVc = [[LendDescVC alloc] init];
        spLVc.pid = banner.pid;
        [self dsPushViewController:spLVc animated:YES];
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

//-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
//{
//    [viewController dismissViewControllerAnimated:YES completion:nil];
//}


// Do any additional setup after loading the view.

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

