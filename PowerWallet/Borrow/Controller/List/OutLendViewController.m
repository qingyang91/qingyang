//
//  OutLendViewController.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/22.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "OutLendViewController.h"
#import "LendViewCell.h"
#import "LendListModel.h"
#import "JSONHTTPClient.h"
#import "DXAlertView.h"
#import "UserManager.h"
#import "BorrowLendRequest.h"
@interface OutLendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) BorrowLendRequest *request;
@property (nonatomic, strong) LendListModel *listModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView    *tableView;
@end

@implementation OutLendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.title = @"我的出借";
    _dataArray = [[NSMutableArray alloc]init];
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的出借";
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
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LendViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"LendViewCell" forIndexPath:indexPath];
    LendItemModel *model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lendID.text = model.lendID;
    cell.seeCount.text = [NSString stringWithFormat:@"%@",model.tags[0]];
    cell.moneycount.text = model.borrow_money;
    cell.lendDay.text = model.borrow_time;
    cell.yearRate.text = [NSString stringWithFormat:@"年利率 %@",model.year_rate];
    return cell;
}
#pragma mark 数据
- (BorrowLendRequest *)request{
    if (!_request) {
        _request = [[BorrowLendRequest alloc]init];
    }
    return _request;
}
- (LendListModel *)listModel{
    if (!_listModel) {
        _listModel = [[LendListModel alloc]init];
    }
    return _listModel;
}
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    [self.request getLendOutIndexWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        self.listModel = [LendListModel helpLendWithDict:dictResult];
        [self hideLoading];
        //刷新数据
        [self showData:self.listModel];
        [self.tableView.mj_header endRefreshing];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self.tableView.mj_header endRefreshing];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }];
}
-(void)showData:(LendListModel *)entity{
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
