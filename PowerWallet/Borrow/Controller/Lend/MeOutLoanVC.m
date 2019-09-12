//
//  MeOutLoanVC.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/21.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "MeOutLoanVC.h"
#import "PickerCell.h"
#import "DXAlertView.h"
#import "CommonWebVC.h"
#import "CreditDataCell.h"
#import "MultiselectView.h"
#import "MeOutModel.h"
#import "ErrorModel.h"
#import "JSONHTTPClient.h"
#import "CheckBindRequest.h"
#import "CertificationCenterVC.h"
#import "BindCardViewController.h"
#import "OutLendRequest.h"
#import "SetPWDViewController.h"
#import "MainViewController.h"
#define RATE SCREEN_WIDTH/320.0
@interface MeOutLoanVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (strong, nonatomic) PickerCell  *moneyCount;
@property (strong, nonatomic) PickerCell *repayWay;
@property (strong, nonatomic) PickerCell *repayRate;
@property (strong, nonatomic) PickerCell *repayDay;
@property (nonatomic, retain) NSMutableArray *repayWayArr;
@property (nonatomic, retain) NSMutableArray *repayRateArr;
@property (nonatomic, retain) NSMutableArray *repayDayArr;
@property (nonatomic, retain) NSMutableArray *dataUseArr;
@property (nonatomic, retain) NSMutableArray *moneyCountArr;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy)   NSString *text;
@property (assign, nonatomic) BOOL isBool;
@property (nonatomic,strong)  UILabel *tip;
@property (nonatomic,strong)  UIButton *agree;
@property (nonatomic,copy)    NSString *urlstr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *resultArr;
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong ,nonatomic) NSMutableArray *indexResult;
@property (assign, nonatomic) NSInteger repayWayIndex;
@property (assign, nonatomic) NSInteger repayRateIndex;
@property (assign,nonatomic)  NSInteger repayDayIndex;
@property (assign,nonatomic)  NSInteger moneyCountIndex;
@property (copy, nonatomic)   NSString *string;
@property (nonatomic, strong) CreditDataCell *cell;
@property (nonatomic, strong) CheckBindRequest *request;
@property (nonatomic, strong) OutLendRequest *outRequest;
@end

@implementation MeOutLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.isBool = YES;
    self.title = @"我要出借";
    [self setUpView];
    self.dataArr = [NSMutableArray array];
    
    self.resultArr = [NSMutableArray array];
    self.arr = [NSMutableArray array];
    self.indexResult = [NSMutableArray array];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
     [self loadData];
    self.navigationItem.title = @"我要出借";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark UI
- (void)setUpView{
    UIButton *commit = [[UIButton alloc]initWithFrame:CGRectMake(10*RATE, SCREEN_HEIGHT-50-64, 300*RATE, 40)];
    commit.backgroundColor = [UIColor orangeColor];
    commit.tag = 300;
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [commit setTitleColor:Color_White forState:UIControlStateNormal];
    [self.view addSubview:commit];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-60)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CreditDataCell" bundle:nil] forCellReuseIdentifier:@"CreditDataCell"];
    _tableView.backgroundColor = [UIColor colorWithHex:0xeff3f5];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 5*45+94, SCREEN_WIDTH, SCREEN_HEIGHT-5*45-94)];
    footView.backgroundColor = Color_Tabbar_LineColor;
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*RATE, 0, SCREEN_HEIGHT, 30)];
    footLabel.text = @"补充说明";
    footLabel.textColor = Color_Title;
    footLabel.textAlignment = NSTextAlignmentLeft;
    [footView addSubview:footLabel];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 150)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.text = @" 不超过40字";
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.delegate = self;
    [footView addSubview:_textView];
    UIView *readview = [[UIView alloc]initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 30)];
    readview.backgroundColor = [UIColor whiteColor];
    readview.layer.borderColor = Color_LineColor.CGColor;
    readview.layer.borderWidth = 1;
    readview.layer.masksToBounds = YES;
    UIButton *readBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*RATE, 5, 20, 20)];
    [readBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
    [readBtn setImage:[UIImage imageNamed:@"check_ok"] forState:UIControlStateSelected];
    readBtn.showsTouchWhenHighlighted = YES;
    readBtn.tag = 200;
    [readBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [readview addSubview:readBtn];
    UILabel *readlabel = [[UILabel alloc]initWithFrame:CGRectMake(40*RATE, 5, 95, 20)];
    readlabel.font = [UIFont systemFontOfSize:15];
    readlabel.textColor = Color_Title;
    readlabel.text = @"已阅读并同意";
    [readview addSubview:readlabel];
    _agree = [[UIButton alloc]initWithFrame:CGRectMake(115*RATE, 5, 190, 20)];
    _agree.titleLabel.font = [UIFont systemFontOfSize:15];
    [_agree setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _agree.tag = 400;
    _agree.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_agree addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [readview addSubview:_agree];
    [footView addSubview:readview];
    _tip = [[UILabel alloc]initWithFrame:CGRectMake(10*RATE, 205, 300*RATE, 150)];
    _tip.textColor = [UIColor lightGrayColor];
    _tip.font = [UIFont systemFontOfSize:15];
    _tip.textAlignment = NSTextAlignmentLeft;
    _tip.numberOfLines = 0;
    [footView addSubview:_tip];
    _tableView.tableFooterView = footView;
    [_tableView setSeparatorColor:Color_LineColor];
    [self.view addSubview:_tableView];
}
#pragma mark 事件
- (void)click:(UIButton *)btn{
    if (btn.tag == 400) {
        CommonWebVC *vc = [[CommonWebVC alloc]init];
        vc.strAbsoluteUrl = _urlstr;
        [self dsPushViewController:vc animated:YES];
    }
    if (btn.tag == 200) {
        btn.selected = !btn.selected;
    }else if (btn.tag == 300){
        UIButton *button = (UIButton *)[self.view viewWithTag:200];
        if (button.selected == NO) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请勾选阅读并同意助力凭条借款协议" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
        }
        [self saveData];
    }
}
#pragma mark textView 代理
//正在改变
- (void)textViewDidChange:(UITextView *)textView
{//字数限制操作
    if (textView.text.length >= 40) {
        textView.text = [textView.text substringToIndex:40];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _text = textView.text;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark 数据
- (NSMutableArray *)moneyCountArr{
    if (!_moneyCountArr) {
        _moneyCountArr = [NSMutableArray array];
    }
    return _moneyCountArr;
}
- (NSMutableArray *)repayWayArr{
    
    if (!_repayWayArr) {
        _repayWayArr = [NSMutableArray array];
    }
    return _repayWayArr;
}
- (NSMutableArray *)repayDayArr{
    if (!_repayDayArr) {
        _repayDayArr = [NSMutableArray array];
    }
    return _repayDayArr;
}
- (NSMutableArray *)repayRateArr{
    if (!_repayRateArr) {
        _repayRateArr = [NSMutableArray array];
    }
    return _repayRateArr;
}

- (NSMutableArray *)dataUseArr{
    if (!_dataUseArr) {
        _dataUseArr = [NSMutableArray array];
    }
    return _dataUseArr;
}
- (CheckBindRequest *)request{
    if (!_request) {
        _request = [[CheckBindRequest alloc]init];
    }
    return _request;
}
- (OutLendRequest *)outRequest{
    if (!_outRequest) {
        _outRequest = [[OutLendRequest alloc]init];
    }
    return _outRequest;
}
#pragma mark 获取数据
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetgetBorrowOutParam];
    [JSONHTTPClient getJSONFromURLWithString:urlStr completion:^(NSDictionary *json, JSONModelError *err) {
        [self hideLoading];
        ErrorModel *errResonse = [[ErrorModel alloc]initWithDictionary:json error:&err];
        NSLog(@"%@",errResonse);
        if( ![errResonse.code isEqualToString:@"0"] ){//错误处理
            [self hideLoading];
            NSString* strErr = errResonse.message;
            NSLog(@"%@",strErr);
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:strErr leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
        }else{
            MeOutModelResponse *response = [[MeOutModelResponse alloc]initWithDictionary:json error:&err];
            if( response != nil && response.data != nil){
                MeOutModel *model = response.data;
                _tip.text = model.tip;
                ProtocolModel *protocolMdoel = model.borrow_protocol;
                _urlstr = protocolMdoel.url;
                [_agree setTitle:protocolMdoel.name forState:UIControlStateNormal];
                NSArray <LendMoneyCountModel *> *countArr = model.borrow_money_all;
                for (LendMoneyCountModel *model in countArr) {
                    [self.moneyCountArr addObject:model.name];
                }
                NSArray <TypeModel *> *typeArr = model.repayment_type_all;
                for (TypeModel *model in typeArr) {
                    [self.repayWayArr addObject:model.name];
                }
                NSArray <LendDayModel *> *lendArr = model.borrow_time_all;
                for (LendDayModel *model in lendArr) {
                    [self.repayDayArr addObject:model.name];
                }
                NSArray <RateModel *> *rateArr = model.year_rate_all;
                for (RateModel *model in rateArr) {
                    [self.repayRateArr addObject:model.name];
                }
                NSArray <MustInfoModel *> *infoArr = model.must_info_all;
                for (MustInfoModel *model in infoArr) {
                    [self.dataArr addObject:model.name];
                }
            }
        }
    }];
}
- (void)saveData{
    if ([self.moneyCount.selectDes isEqualToString:@"选择金额范围"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择金额范围" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if ([self.repayWay.selectDes isEqualToString:@"选择还款方式"]) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择还款方式" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if ([self.repayRate.selectDes isEqualToString:@"选择年化利率"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择年化利率" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if ([self.repayDay.selectDes isEqualToString:@"选择借款时长"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择借款时长" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if ([self.cell.choose.text isEqualToString:@"选择必备信用材料"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择必备信用材料" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
    [self checkUseIsBindCard];
}
#pragma mark 判断是否绑卡认证
- (void)checkUseIsBindCard{
     __weak typeof(self) weakSelf = self;
    [weakSelf.request checkBindWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        int status = [dictResult[@"bind_card"] intValue];
        int isCertification = [dictResult[@"certification"] intValue];
        int payWord = [dictResult[@"check_paypwd"] intValue];
        NSLog(@"status=======%d,isCertification======%d,payWord=======%d",status,isCertification,payWord);
        if (status == 0) {
            DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"未绑定银行卡" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alertView.rightBlock = ^{
                BindCardViewController *vc = [[BindCardViewController alloc]init];
                [self dsPushViewController:vc animated:YES];
            };
            [alertView show];
        }else{
            if (payWord == 0) {
                DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"未设置交易密码" leftButtonTitle:nil rightButtonTitle:@"确定"];
                alertView.rightBlock = ^{
                    SetPWDViewController *set = [[SetPWDViewController alloc]initWithType:KDSetPayPassword];
                    set.controllIndex = 1;
                    [self dsPushViewController:set animated:YES];
                };
                [alertView show];
            }else{
                if (isCertification == 0) {
                    DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"未支付认证费用" leftButtonTitle:nil rightButtonTitle:@"确定"];
                    alertView.rightBlock = ^{
                        CommonWebVC *vc = [[CommonWebVC alloc]init];
                        vc.strAbsoluteUrl = dictResult[@"pay_url"];
                        [self dsPushViewController:vc animated:YES];
                    };
                    [alertView show];
                }else if (isCertification == 1){
                    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"未认证" leftButtonTitle:nil rightButtonTitle:@"确定"];
                    alertView.rightBlock = ^{
                        CertificationCenterVC *verifyList = [[CertificationCenterVC alloc] init];
                        [self dsPushViewController:verifyList animated:YES];
                    };
                    [alertView show];
                }else{
                    [self submitLend];
                }
            }
        }
    }andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }];
}
#pragma mark 提交出借
- (void)submitLend{
    [self showLoading:@""];
    NSString *borrow_money = [NSString stringWithFormat:@"%ld",self.moneyCountIndex+1];
    NSString *repayment_type = [NSString stringWithFormat:@"%ld",self.repayWayIndex+1];
    NSString *borrow_time = [NSString stringWithFormat:@"%ld",self.repayDayIndex+1];
    NSString *year_rate = [NSString stringWithFormat:@"%ld",self.repayRateIndex+1];
    __weak typeof(self) weakSelf = self;
    [weakSelf.outRequest saveOutLendInfoWithDict:@{@"borrow_money":borrow_money,
                                               @"repayment_type":repayment_type,
                                               @"borrow_time":borrow_time,
                                               @"year_rate":year_rate,
                                               @"must_info":self.string,
                                               @"extra_info":self.textView.text
                                               }
    onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"出借成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
        alertView.rightBlock = ^{
            MainViewController *tab = [[MainViewController alloc]init];
            tab.selectedIndex = 0;
            [[UIApplication sharedApplication] delegate].window.rootViewController = tab;
        };
        [alertView show];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}
#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        switch (indexPath.row) {
            case 0:
                return self.moneyCount;
                break;
            case 1:
                return self.repayWay;
                break;
            case 2:
                return self.repayRate;
                break;
            case 3:
                return self.repayDay;
                break;
            case 4:
                return [self BuilderProductCreditDataCell:indexPath];
                break;
            default:
                return [UITableViewCell new];
        }
}
- (UITableViewCell* )BuilderProductCreditDataCell:(NSIndexPath*)indexPath{
    _cell = (CreditDataCell *)[_tableView dequeueReusableCellWithIdentifier:@"CreditDataCell" forIndexPath:indexPath];
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [_cell setCreditDataCell:indexPath];
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        if (self.isBool) {
            self.isBool = NO;
            MultiselectView *musView = [[MultiselectView alloc] initWithFrame:CGRectMake(20*RATE,60, SCREEN_WIDTH - 40*RATE, SCREEN_HEIGHT - 200)];
            musView.dataArr = self.dataArr;
            if (self.arr.count != 0) {
                [musView.resultArr addObjectsFromArray:self.arr];
            }
            [UIView animateWithDuration:2.0 animations:^{
                 [self.view addSubview:musView];
            }];
            __weak __typeof(self) weakself = self;
            musView.SelectBlock = ^(NSMutableArray *selectArr){
                if (selectArr != nil) {
                    [self.arr removeAllObjects];
                    [self.resultArr removeAllObjects];
                    [self.indexResult removeAllObjects];
                    [self.arr addObjectsFromArray:selectArr];
                    for (int i = 0; i < selectArr.count; i ++) {
                        int row = [selectArr[i] intValue];
                        [self.resultArr addObject:weakself.dataArr[row]];
                        [self.indexResult addObject:[NSString stringWithFormat:@"%d",row+1]];
                    }
                    NSString *str = [self.resultArr componentsJoinedByString:@","];
                    self.string = [self.indexResult componentsJoinedByString:@";"];
                    if (str.length != 0) {
                        self.cell.choose.text = str;
                    }else{
                        self.cell.choose.text = @"选择必备信用材料";
                    }
                    }else{
            }
            weakself.isBool = YES;
          };
       }
    }
}
#pragma mark 懒加载
- (PickerCell *)moneyCount{
    if (!_moneyCount) {
        _moneyCount = [[PickerCell alloc] initWithTitle:@"借款金额" subTitle:@"" selectDes:@"选择金额范围"];
        @Weak(self)
        _moneyCount.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.moneyCountArr.count;
        };
        _moneyCount.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.moneyCountArr[row];
        };
        _moneyCount.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.moneyCountIndex = selectedRow;
            self.moneyCount.selectDes = self.moneyCountArr.count ? self.moneyCountArr[selectedRow] : @"";
        };
    }
    return _moneyCount;
}
- (PickerCell *)repayWay {
    if (!_repayWay) {
        _repayWay = [[PickerCell alloc] initWithTitle:@"还款方式" subTitle:@"" selectDes:@"选择还款方式"];
        @Weak(self)
        _repayWay.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.repayWayArr.count;
        };
        _repayWay.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.repayWayArr[row];
        };
        _repayWay.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.repayWayIndex = selectedRow;
            
            self.repayWay.selectDes = self.repayWayArr.count ? self.repayWayArr[selectedRow] : @"";
        };
    }
    return _repayWay;
}
- (PickerCell *)repayDay {
    
    if (!_repayDay) {
        _repayDay = [[PickerCell alloc] initWithTitle:@"借款时长" subTitle:@"" selectDes:@"选择借款时长"];
        
        @Weak(self)
        _repayDay.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.repayDayArr.count;
        };
        _repayDay.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.repayDayArr[row];
        };
        _repayDay.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.repayDayIndex = selectedRow;
            
            self.repayDay.selectDes = self.repayDayArr.count ? self.repayDayArr[selectedRow] : @"";
        };
    }
    return _repayDay;
}
- (PickerCell *)repayRate {
    
    if (!_repayRate) {
        _repayRate = [[PickerCell alloc] initWithTitle:@"还款利率" subTitle:@"" selectDes:@"选择年化利率"];
        
        @Weak(self)
        _repayRate.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.repayRateArr.count;
        };
        _repayRate.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.repayRateArr[row];
        };
        _repayRate.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.repayRateIndex = selectedRow;
            
            self.repayRate.selectDes = self.repayRateArr.count ? self.repayRateArr[selectedRow] : @"";
        };
    }
    return _repayRate;
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
