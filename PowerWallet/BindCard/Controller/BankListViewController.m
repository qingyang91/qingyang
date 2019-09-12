#import "BankListViewController.h"
#import "BankListRequest.h"
#import "BindModel.h"
#import "DXAlertView.h"
@interface BankListViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BankListRequest *request;
@property (nonatomic, strong) BindModel *model;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *bindLabel;
@property (nonatomic, strong) UILabel *idlabel;
@end

@implementation BankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.title = @"我的银行卡";
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的银行卡";
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (BankListRequest *)request{
    if (!_request) {
        _request = [[BankListRequest alloc]init];
    }
    return _request;
}

- (void)loadData{
    [super loadData];
    [self showLoading:@""];
    [self.request binkCardListWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        self.model = [BindModel BindWithDict:dictResult];
        _nameLabel.text = self.model.name;
        _bankLabel.text = self.model.bankName;
        if ([self.model.isBind isEqualToString:@"0"]) {
            _bindLabel.text = @"未绑卡";
        }else{
            _bindLabel.text = @"已绑卡";
        }
        _idlabel.text = [NSString stringWithFormat:@"卡号:%@",self.model.cardNo];
        [self hideLoading];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}
- (void)creatUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 130)];
    view.backgroundColor = [UIColor whiteColor];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH/3, 20)];
    _nameLabel.textColor = Color_Title;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:_nameLabel];
    _bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 15, SCREEN_WIDTH/3, 20)];
    _bankLabel.textColor = Color_Title;
    _bankLabel.textAlignment = NSTextAlignmentCenter;
    _bankLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:_bankLabel];
    _bindLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 15, SCREEN_WIDTH/3, 20)];
    _bindLabel.textColor = Color_Title;
    _bindLabel.textAlignment = NSTextAlignmentCenter;
    _bindLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:_bindLabel];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    _idlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 20)];
    _idlabel.textAlignment = NSTextAlignmentCenter;
    _idlabel.font = [UIFont systemFontOfSize:18];
    _idlabel.textColor = Color_Title;
    [view addSubview:_idlabel];
    [self.view addSubview:view];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (BindModel *)model{
    if (!_model) {
        _model = [[BindModel alloc]init];
    }
    return _model;
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
