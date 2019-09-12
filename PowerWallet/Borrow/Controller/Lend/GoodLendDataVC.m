//
//  GoodLendDataVC.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/16.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "GoodLendDataVC.h"
#import "CommonWebVC.h"
#import "lendDataViewCell.h"
#import "MeLoanVC.h"
@interface GoodLendDataVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation GoodLendDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.title = APP_NAME;
    _dataArray = [[NSMutableArray alloc]init];
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    self.navigationItem.title = APP_NAME;
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark UI
- (void)creatUI{
    [self setUpTab];
    [self setUpBtn];
}
- (void)setUpTab{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 415) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tableView registerNib:[UINib nibWithNibName:@"lendDataViewCell" bundle:nil] forCellReuseIdentifier:@"lendDataViewCell"];
    [self.view addSubview:_tableView];
}
- (void)setUpBtn{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80-64, SCREEN_WIDTH, 80)];
    view.backgroundColor = Color_White;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 50)];
    [button setTitle:@"我也要借"forState:UIControlStateNormal];
    [button setTitleColor:Color_White forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(lendClcik) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
//    [self.view addSubview:view];
}
#pragma mark 数据
- (void)loadData{
    [super loadData];
}
#pragma mark tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    lendDataViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"lendDataViewCell" forIndexPath:indexPath];
    [cell.findBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 415;
}
#pragma mark 事件
- (void)btnClick{
    CommonWebVC *vc = [[CommonWebVC alloc]init];
    vc.strAbsoluteUrl = @"http://api.zhuliqianbao.com/lygj/creditpay/payContract";
    [self dsPushViewController:vc animated:YES];
}
- (void)lendClcik{
    MeLoanVC *vc = [[MeLoanVC alloc]init];
    [self dsPushViewController:vc animated:YES];
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
