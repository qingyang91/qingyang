//
//  SettingVC.m
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SettingVC.h"
#import "SettingCell.h"
#import "UserManager.h"
#import "CommonWebVC.h"
#import "FeedBackVC.h"
#import "DXAlertView.h"
#import "CertificationCenterVC.h"
#import "LoginOrRegistRequest.h"
#import "ChangePasswordVC.h"
#import "LoginVC.h"
#import "AboutTeamVC.h"
@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray            *arrayData;
@property (nonatomic, strong) UITableView               *tbvSetting;
@property (nonatomic, retain) UIView                    *footerView;
@property (nonatomic, retain) UIView                    *headerView;
@property (nonatomic, retain) UIButton                  *btnLoginOut;
@property (nonatomic,strong) LoginOrRegistRequest       *request;

@end

@implementation SettingVC
#pragma mark - VC生命周期
{
    BOOL userOut;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpDataSource];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(userOut){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
    }
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
    self.navigationItem.title = @"更多";
    [self baseSetup:PageGobackTypePop];

    //创建视图等
    //创建tableview
    _tbvSetting = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tbvSetting.delegate = self;
    _tbvSetting.dataSource = self;
    _tbvSetting.backgroundColor = [UIColor clearColor];
    _tbvSetting.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbvSetting.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tbvSetting];
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180.5*WIDTHRADIUS)];
    _tbvSetting.tableHeaderView = _headerView;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo_xhdpi"]];
    [self.headerView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make){
        if (iPhone5) {
            make.height.equalTo(@70);
            make.width.equalTo(@70);
        }else{
            make.height.equalTo(@90);
            make.width.equalTo(@90);
        }
        make.top.equalTo(self.headerView.mas_top).with.offset(30);
        make.centerX.equalTo(@0);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    if (iPhone5) {
        title.font = [UIFont systemFontOfSize:20.0f];
    }else{
        title.font = [UIFont systemFontOfSize:25.0f];
    }
    title.textColor = [UIColor blackColor];
    [self.headerView addSubview:title];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"助力凭条";
    [title mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(logoImageView.mas_bottom).with.offset(5);
        make.centerX.equalTo(@0);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,180.5*WIDTHRADIUS)];
    _footerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    //创建退出按钮
    [_footerView addSubview:self.btnLoginOut];
    [self.btnLoginOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo([self switchNumberWithFloat:15.f*WIDTHRADIUS]);
        make.topMargin.equalTo([self switchNumberWithFloat:32.5*WIDTHRADIUS]);
        make.width.equalTo([self switchNumberWithFloat:SCREEN_WIDTH-30]);
        make.height.equalTo([self switchNumberWithFloat:46*WIDTHRADIUS]);
    }];
    [_btnLoginOut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnLoginOut.backgroundColor = UIColorFromRGB(0xffffff);
    [self.btnLoginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    self.btnLoginOut.layer.cornerRadius = 46*WIDTHRADIUS/2;
    self.btnLoginOut.layer.masksToBounds = YES;
    [self.btnLoginOut addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    _tbvSetting.tableFooterView = _footerView;
    
    //    _tbvSetting.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
}

#pragma mark - 初始化数据源

- (void)setUpDataSource{
    [_arrayData removeAllObjects];
    _arrayData = [[NSMutableArray alloc]init];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSArray *verArray = [app_Version componentsSeparatedByString:@"."];
    if (verArray.count<3) {
        app_Version = [app_Version stringByAppendingString:@".0"];
    }
    NSString *vString = [[NSString alloc] initWithFormat:@"v%@",app_Version, nil];
    NSArray *array = @[@[@{@"strIcon":@"more_AboutUs",@"strTitle":@"意见反馈",@"strContent":@""},@{@"strIcon":@"more_AboutUs",@"strTitle":@"修改登录密码",@"strContent":@""}],
                       @[@{@"strIcon":@"more_Opinion",@"strTitle":@"关于我们",@"strContent":vString}]
                       ];
    [_arrayData addObjectsFromArray:array];
    [_tbvSetting reloadData];
}



#pragma mark - 按钮事件

- (void)login{
    
    __weak typeof(self) weakSelf = self;
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"您确定要退出登录吗？" leftButtonTitle:@"取消" rightButtonTitle:@"确定" buttonType:LeftGray];
    alert.rightBlock = ^{
        
        [weakSelf.request LoginOutWihtDict:@{} onSuccess:^(NSDictionary *dictResult) {
            [[UserManager sharedUserManager] logout];
            userOut = YES;
            LoginVC *vc = [[LoginVC alloc]init];
            [self dsPushViewController:vc animated:YES];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            
        }];
        
    };
    [alert show];
}



#pragma mark - Delegate

#pragma --mark tableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrayData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [_arrayData  objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *cell = [SettingCell homeCellWithTableView:tableView];
    if (indexPath.row < _arrayData.count) {
        NSArray *array = [_arrayData  objectAtIndex:indexPath.section];
        [cell configCellWithDict:array[indexPath.row] indexPath:indexPath];
    }
    return cell;
    
}

#pragma --mark tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 55*WIDTHRADIUS;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.10;
    }else{
        return 15;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            FeedBackVC *vcFeedBack = [[FeedBackVC alloc]init];
            vcFeedBack.meModel = _meModel;
            [self dsPushViewController:vcFeedBack animated:YES];
        }else{
            ChangePasswordVC *cpVc = [[ChangePasswordVC alloc] init];
            cpVc.passwordType = loginChange;
            [self dsPushViewController:cpVc animated:YES];
        }
        
    }else if(indexPath.section == 1){
        AboutTeamVC *vc = [[AboutTeamVC alloc]init];
        [self dsPushViewController:vc animated:YES];
    }
}

#pragma mark - Other

-  (UIButton *)btnLoginOut {
    if (!_btnLoginOut) {
        _btnLoginOut = [[UIButton alloc]init];
    }
    return _btnLoginOut;
}

- (NSNumber *)switchNumberWithFloat:(float)floatValue {
    return [NSNumber numberWithFloat:floatValue];
}

- (LoginOrRegistRequest *)request{
    
    if (!_request) {
        _request = [[LoginOrRegistRequest alloc] init];
    }
    return _request;
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
