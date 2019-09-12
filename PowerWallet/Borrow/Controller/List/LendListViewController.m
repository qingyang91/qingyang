//
//  LendListViewController.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/15.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "LendListViewController.h"
#import "MyLendListModel.h"
#import "LendListViewCell.h"
#import "BorrowLendRequest.h"
#import "LogOutLendVC.h"
#import "CommonWebVC.h"
#import "FeedBackVC.h"
@interface LendListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BorrowLendRequest *request;
@property (nonatomic, strong) MyLendListModel *model;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) LendListViewCell *cell;
@end

@implementation LendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.title = @"已生效借条";
    _dataArray = [[NSMutableArray alloc]init];
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    self.navigationItem.title = @"已生效借条";
   [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)creatUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tableView registerNib:[UINib nibWithNibName:@"LendListViewCell" bundle:nil] forCellReuseIdentifier:@"LendListViewCell"];
    [self.view addSubview:_tableView];
}
#pragma mark tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell = [_tableView dequeueReusableCellWithIdentifier:@"LendListViewCell" forIndexPath:indexPath];
    MyLendItemModel *model = self.dataArray[indexPath.row];
    _cell.listID.text = model.lendID;
    _cell.zhaiwuName.text = model.borrowUserName;
    _cell.zhaiquanName.text = model.lendUserName;
    _cell.lendTime.text = model.borrowTime;
    _cell.yearRate.text = model.yearRate;
    _cell.lendMoney.text = model.borrowMoney;
    _cell.detailView.layer.cornerRadius = 5;
    _cell.detailView.layer.masksToBounds = YES;
    _cell.xiaoBtn.layer.cornerRadius = 5;
    _cell.xiaoBtn.layer.masksToBounds = YES;
    [_cell.xiaoBtn addTarget:self action:@selector(xiaoClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    _cell.xiaoBtn.tag = [model.lendID integerValue];
    if (model.logout_status == 1) {
        [_cell.xiaoBtn setTitle:@"已发起申请销借条" forState:UIControlStateNormal];
        _cell.xiaoBtn.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
        _cell.xiaoBtn.userInteractionEnabled = NO;
    }
    _cell.feedBtn.layer.cornerRadius = 5;
    _cell.feedBtn.layer.masksToBounds = YES;
    _cell.feedBtn.tag = [model.lendID integerValue]+1;
    [_cell.feedBtn addTarget:self action:@selector(feedClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonWebVC *vc = [[CommonWebVC alloc]init];
    MyLendItemModel *model = self.dataArray[indexPath.row];
    vc.strAbsoluteUrl = model.borrowPageUrl;
    [self dsPushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)xiaoClickWithBtn:(UIButton *)button{
    [self reworkLendWithLendID:[NSString stringWithFormat:@"%ld",button.tag]];
}
- (void)feedClickWithBtn:(UIButton *)button{
    FeedBackVC *vc = [[FeedBackVC alloc]init];
    vc.lendID = [NSString stringWithFormat:@"%ld",button.tag-1];
    [self dsPushViewController:vc animated:YES];
}
#pragma mark 数据
- (MyLendListModel *)model{
    if (!_model) {
        _model = [[MyLendListModel alloc]init];
    }
    return _model;
}
- (BorrowLendRequest *)request{
    if (!_request) {
        _request = [[BorrowLendRequest alloc]init];
    }
    return _request;
}
- (void)reworkLendWithLendID:(NSString *)orderNo{
    [self showLoading:@""];
    [self.request getLogOutListWithDict:@{@"orderNo":orderNo} onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
        [_cell.xiaoBtn setTitle:@"已发起申请销借条" forState:UIControlStateNormal];
        _cell.xiaoBtn.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
        _cell.xiaoBtn.userInteractionEnabled = NO;
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    [self.request getLendListWithDict:@{@"type":_type} onSuccess:^(NSDictionary *dictResult) {
        self.model = [MyLendListModel helpLendWithDict:dictResult];
        [self hideLoading];
        //刷新数据
        [self showData:self.model];
        [self.tableView.mj_header endRefreshing];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self.tableView.mj_header endRefreshing];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }];
}
-(void)showData:(MyLendListModel *)entity{
    [_dataArray removeAllObjects];
    self.dataArray = [NSMutableArray arrayWithArray:entity.items];
    [self.tableView reloadData];
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
