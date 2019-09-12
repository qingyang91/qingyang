//
//  ConfirmViewController.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/15.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "ConfirmViewController.h"
#import "MyLendListModel.h"
#import "AgreeListViewCell.h"
#import "BorrowLendRequest.h"
#import "LogOutLendVC.h"
#import "CommonWebVC.h"
#import "FeedBackVC.h"
@interface ConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BorrowLendRequest *request;
@property (nonatomic, strong) MyLendListModel *model;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView    *tableView;
@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.title = @"待确认签订借条";
    _dataArray = [[NSMutableArray alloc]init];
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    self.navigationItem.title = @"待确认签订借条";
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
    [_tableView registerNib:[UINib nibWithNibName:@"AgreeListViewCell" bundle:nil] forCellReuseIdentifier:@"AgreeListViewCell"];
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
    AgreeListViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"AgreeListViewCell" forIndexPath:indexPath];
    MyLendItemModel *model = self.dataArray[indexPath.row];
    cell.listID.text = model.lendID;
    cell.zhaiwuName.text = model.borrowUserName;
    cell.zhaiquanName.text = model.lendUserName;
    cell.lendTime.text = model.borrowTime;
    cell.yearRate.text = model.yearRate;
    cell.lendMoney.text = model.borrowMoney;
    cell.detailView.layer.cornerRadius = 5;
    cell.detailView.layer.masksToBounds = YES;
    cell.agreeBtn.layer.cornerRadius = 5;
    cell.agreeBtn.layer.masksToBounds = YES;
    [cell.agreeBtn addTarget:self action:@selector(xiaoClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.agreeBtn.tag = [model.lendID integerValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonWebVC *vc = [[CommonWebVC alloc]init];
    MyLendItemModel *model = self.dataArray[indexPath.row];
    vc.strAbsoluteUrl = model.borrowPageUrl;
    [self dsPushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)xiaoClickWithBtn:(UIButton *)button{
    [self agreeLendwithId:[NSString stringWithFormat:@"%ld",button.tag]];
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
//同意借条
- (void)agreeLendwithId:(NSString *)lendID{
    [self showLoading:@""];
    [self.request getAgreeListWithDict:@{@"id":lendID} onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
        [self showMessage:@"同意借条成功"];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
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

