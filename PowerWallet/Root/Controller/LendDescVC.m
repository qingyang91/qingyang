//
//  LendDescVC.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/10.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "LendDescVC.h"
#import "PartnerInfoModel.h"
#import "LendItemCell.h"
#import "DescCell.h"
#import "HomeRequest.h"
#import "UserManager.h"
#import "NSString+Frame.h"
#import "CommonWebVC.h"
@interface LendDescVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HomeRequest       *request;
@property (nonatomic, strong) PartnerInfoModel     *lendModel;
@property (nonatomic, strong) DXAlertView       *alertView;

@property (nonatomic, retain) NSMutableArray    *arrData;
@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, retain) UIView        *footerView;
@property (nonatomic, retain) UIButton      *nextBtn;

@property (nonatomic, assign) int  statisticsCount;
@end

@implementation LendDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportStatis:) name:@"ReportStatistics" object:nil];
    
    [self loadData];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)reportStatis:(NSNotification *)con{
    if(self.statisticsCount == 0){
        [self putReportStatistics:@"1"];
        self.statisticsCount++;
    }
}

#pragma mark - 加载网络数据
- (HomeRequest *)request{
    
    if (!_request) {
        _request = [[HomeRequest alloc] init];
    }
    
    return _request;
}
//加载数据
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    [self.request getLendDescWithDict:@{@"pid":self.pid} onSuccess:^(NSDictionary *dictResult) {
        self.lendModel = [PartnerInfoModel partnerInfoWithDict:dictResult];
        [self putReportStatistics:@"2"];
        [self hideLoading];
        //刷新数据
        [self showData:self.lendModel];
        self.navigationItem.title = self.lendModel.lend_name;
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
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

-(void)putReportStatistics:(NSString *)type{
    NSDictionary *dict = @{@"uid" : ([UserManager sharedUserManager].userInfo.uid.length == 0) ? @"0" : [UserManager sharedUserManager].userInfo.uid,
                           @"pid" : self.pid,
                           @"type": type};
    [self.request reportStatisticsWithDict:dict onSuccess:^(NSDictionary *dic){
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        
    }];
}

-(void)showData:(PartnerInfoModel *)entity{
    [_arrData removeAllObjects];
    NSArray *array;
    array = @[
              @" ",
              ];
    
    self.arrData = [NSMutableArray arrayWithArray:array];
    [self.arrData addObject:entity.apply_limit];
    [self.arrData addObject:entity.product_desc];
//    [self.arrData addObjectsFromArray:entity.desc];
    [self.tableView reloadData];
}

#pragma mark -- UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.footerView addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo([self switchNumberWithFloat:15.f*WIDTHRADIUS]);
        make.topMargin.equalTo([self switchNumberWithFloat:32.5*WIDTHRADIUS]);
        make.width.equalTo([self switchNumberWithFloat:SCREEN_WIDTH-30]);
        make.height.equalTo([self switchNumberWithFloat:46*WIDTHRADIUS]);
    }];
}
- (NSNumber *)switchNumberWithFloat:(float)floatValue {
    return [NSNumber numberWithFloat:floatValue];
}

#pragma mark - UI懒加载
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = Color_TABBG;
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (NSMutableArray *)arrData
{
    
    if (_arrData == nil) {
        _arrData = [[NSMutableArray alloc] init];
    }
    return _arrData;
}

-(PartnerInfoModel *)lendModel{
    if (!_lendModel) {
        _lendModel = [[PartnerInfoModel alloc] init];
    }
    return _lendModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.backgroundColor = Color_Btn_Background;
        [_nextBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius = 46*WIDTHRADIUS/2;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,180.5*WIDTHRADIUS)];
        _footerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _footerView;
}

-(void)clickBtn:(UIButton *)btn{
    if(![[UserManager sharedUserManager] isLogin])
    {
        [[UserManager sharedUserManager]showLoginPage:self];
        return;
    }
    self.statisticsCount = 0;
    NSString *url = @"";
    if ([self.lendModel.apply_type intValue] == 1) {
        if([self.lendModel.apply_ios_h5 rangeOfString:@"?"].location == NSNotFound){
            url = [[NSString alloc] initWithFormat:@"%@?banner_pid=%@",self.lendModel.apply_ios_h5,self.pid];
        }else{
            url = [[NSString alloc] initWithFormat:@"%@&banner_pid=%@",self.lendModel.apply_ios_h5,self.pid];
        }
    }else{
        if([self.lendModel.apply_ios_download rangeOfString:@"?"].location == NSNotFound){
            url = [[NSString alloc] initWithFormat:@"%@?banner_pid=%@",self.lendModel.apply_ios_download,self.pid];
        }else{
            url = [[NSString alloc] initWithFormat:@"%@&banner_pid=%@",self.lendModel.apply_ios_download,self.pid];
        }
    }
    CommonWebVC *com = [[CommonWebVC alloc] init];
    com.strType = @"LendDesc";
    com.strAbsoluteUrl = url;
    [self dsPushViewController:com animated:YES];
}
-(void)openAppStore{
    NSString *downloadStr = self.lendModel.apply_ios_download;
    if ([downloadStr  rangeOfString:@"http://"].location == NSNotFound && [downloadStr  rangeOfString:@"https://"].location == NSNotFound){
        downloadStr = [[NSString alloc] initWithFormat:@"http://%@",downloadStr];
    }
    if (IOS_VERSION >= 10) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:downloadStr]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr] options:@{} completionHandler:nil];
        }
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:downloadStr]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
        }
    }
}

#pragma mark --UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else if(section == 2){
        return 100;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return self.footerView;
    }else{
        return nil;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        NSString *str = self.lendModel.lend_desc;
        CGFloat height = [str heightWIthFontSize:14.0 maxWidth:SCREEN_WIDTH-49];
        return 80-16.7+height;
    }else if(indexPath.section == 1){
        NSString *str = self.lendModel.apply_limit;
        CGSize lblSize = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        return lblSize.height+45;
    }else{
        NSString *str = self.lendModel.product_desc;
        CGSize lblSize = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        return lblSize.height+45;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        LendItemCell *cell = [LendItemCell initCellWithTableView:tableView];
        cell.backgroundColor = Color_TABBG;
        [cell configCellWithDict:self.lendModel indexPath:indexPath];
        return cell;
    }else{
        DescCell *cell = [DescCell initCellWithTableView:tableView];
        [cell configCellWithDict:self.lendModel indexPath:indexPath];
        return cell;
    }
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
