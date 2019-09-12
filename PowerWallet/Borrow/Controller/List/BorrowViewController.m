//
//  BorrowViewController.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/22.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "BorrowViewController.h"
#import "LendViewCell.h"
#import "LendListModel.h"
#import "JSONHTTPClient.h"
#import "DXAlertView.h"
#import "UserManager.h"
#import "BorrowLendRequest.h"
#import "FeedBackVC.h"
@interface BorrowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BorrowLendRequest *request;
@property (nonatomic, strong) LendListModel *model;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView    *tableView;
@end

@implementation BorrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.title = @"我的求借";
    _dataArray = [[NSMutableArray alloc]init];
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的求借";
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark 创建UI
- (void)creatUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tableView registerNib:[UINib nibWithNibName:@"LendViewCell" bundle:nil] forCellReuseIdentifier:@"LendViewCell"];
    [self.view addSubview:_tableView];
}
#pragma mark tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LendViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"LendViewCell" forIndexPath:indexPath];
    LendItemModel *model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lendID.text = model.lendID;
    cell.seeCount.text = [NSString stringWithFormat:@"%@",model.tags[0]];
    if ([model.active_borrow_money hasPrefix:@"0"]) {
        cell.moneycount.text = model.borrow_money;
    }else{
        cell.moneycount.text = model.active_borrow_money;
    }
    cell.lendDay.text = model.borrow_time;
    cell.yearRate.text = [NSString stringWithFormat:@"年利率 %@",model.year_rate];
    cell.fankuiBtn.layer.cornerRadius = 5;
    cell.fankuiBtn.layer.masksToBounds = YES;
    cell.fankuiBtn.tag = [model.lendID integerValue]+1;
    [cell.fankuiBtn addTarget:self action:@selector(feedClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.confirmBtn.layer.cornerRadius = 5;
    cell.confirmBtn.layer.masksToBounds = YES;
    if (model.to_confirm == 0) {
        cell.confirmBtn.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
        cell.confirmBtn.userInteractionEnabled = NO;
    }
    [cell.confirmBtn addTarget:self action:@selector(xiaoClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.confirmBtn.tag = [model.lendID integerValue];
    return cell;
}
#pragma mark 数据
- (LendListModel *)model {
    if (!_model) {
        _model = [[LendListModel alloc]init];
    }
    return _model;
}
- (BorrowLendRequest *)request{
    if (!_request) {
        _request = [[BorrowLendRequest alloc]init];
    }
    return _request;
}
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    [self.request getLendIndexWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        self.model = [LendListModel helpLendWithDict:dictResult];
        [self hideLoading];
        //刷新数据
        [self showData:self.model];
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
- (void)showData:(LendListModel *)entiy{
    [_dataArray removeAllObjects];
    self.dataArray = [NSMutableArray arrayWithArray:entiy.items];
    [self.tableView reloadData];
}
- (void)feedClickWithBtn:(UIButton *)button{
    FeedBackVC *vc = [[FeedBackVC alloc]init];
    vc.lendID = [NSString stringWithFormat:@"%ld",button.tag-1];
    [self dsPushViewController:vc animated:YES];
}
- (void)xiaoClickWithBtn:(UIButton *)button{
    DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"温馨提示" contentText:@"1.请核对收到的打款是否与双方约定金额一致再确定\n2.有任何问题，请在借条中反馈" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alertView.rightBlock = ^{
        [self confirmLendwithId:[NSString stringWithFormat:@"%ld",button.tag]];
    };
    [alertView show];
}
//确认收钱
- (void)confirmLendwithId:(NSString *)lendID{
    [self showLoading:@""];
    [self.request getAgreeListWithDict:@{@"id":lendID,@"type":@"3"} onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
        DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"确认收钱成功" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alertView.rightBlock = ^{
            [self loadData];
        };
        [alertView show];
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
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
