//
//  MeLoanVC.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/21.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "MeLoanVC.h"
#import "BindCardViewController.h"
#import "InputCell.h"
#import "PickerCell.h"
#import "DXAlertView.h"
#import "CommonWebVC.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"
#import "MeLendModel.h"
#import "ErrorModel.h"
#import "JSONHTTPClient.h"
#import "UserManager.h"
#import "CheckBindRequest.h"
#import "SubmitLendRequest.h"
#import "CertificationCenterVC.h"
#import "SetPWDViewController.h"
#import "MainViewController.h"
#define RATE SCREEN_WIDTH/320.0
@interface MeLoanVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (strong, nonatomic) InputCell   *moneyCount;
@property (strong, nonatomic) PickerCell  *repayWay;
@property (strong, nonatomic) PickerCell  *repayRate;
@property (strong, nonatomic) PickerCell  *moneyUse;
@property (nonatomic, strong) BRTextField *repayDay;
@property (nonatomic, retain) NSMutableArray *repayWayArr;
@property (nonatomic, retain) NSMutableArray *repayRateArr;
@property (nonatomic, retain) NSMutableArray *moneyUseArr;
@property (nonatomic, retain) NSMutableArray *lendArray;
@property (nonatomic, retain) NSString *lendDayStr;
@property (assign, nonatomic) NSInteger   repayWayIndex;
@property (assign, nonatomic) NSInteger   repayRateIndex;
@property (assign, nonatomic) NSInteger   moneyUseIndex;
@property (assign, nonatomic) NSInteger   lendIndex;
@property (nonatomic,strong)  UITableViewCell *cell;
@property (strong, nonatomic) UITextView      *textView;
@property (nonatomic,strong)  UILabel         *header;
@property (nonatomic,strong)  UILabel         *tip;
@property (nonatomic,strong)  UIButton        *agree;
@property (nonatomic,copy)    NSString        *text;
@property (nonatomic,copy)    NSString        *urlProtocol;
@property (nonatomic,strong)  CheckBindRequest *chekRequest;
@property (nonatomic,strong)  SubmitLendRequest *subRequest;
@property (nonatomic,strong)  PickerCell      *lendDay;
@property (nonatomic, copy)   NSString *maxMoney;
@end

@implementation MeLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.title = @"我要借款";
    [self setUpView];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我要借款";
    [self loadData];
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
    _tableView.backgroundColor = [UIColor colorWithHex:0xeff3f5];
   _header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    _header.font = Font_SubTitle;
    _header.textColor = [UIColor orangeColor];
    
    _tableView.tableHeaderView = _header;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 5*45+94, SCREEN_WIDTH, SCREEN_HEIGHT-5*45-94)];
    footView.backgroundColor = Color_Tabbar_LineColor;
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*RATE, 0, SCREEN_HEIGHT, 30)];
    footLabel.text = @"补充说明(不超过300字)";
    footLabel.textColor = Color_Title;
    footLabel.textAlignment = NSTextAlignmentLeft;
    [footView addSubview:footLabel];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 150)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.text = @"  具体说明您的借款用途或者证明您的还款能力";
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
    _tip= [[UILabel alloc]initWithFrame:CGRectMake(10*RATE, 205, 300*RATE, 150)];
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
        vc.strAbsoluteUrl = _urlProtocol;
        [self dsPushViewController:vc animated:YES];
    }
    if (btn.tag == 200) {
         btn.selected = !btn.selected;
    }else if (btn.tag == 300){
        UIButton *button = (UIButton *)[self.view viewWithTag:200];
        if (button.selected == NO) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请勾选阅读并同意助力凭条借款协议" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
        }else{
            [self saveData];
        }
    }
}
#pragma mark textView 代理
- (void)textViewDidChange:(UITextView *)textView{
    //字数限制操作
    if (textView.text.length >= 300) {
        textView.text = [textView.text substringToIndex:300];
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
- (CheckBindRequest *)chekRequest{
    if (!_chekRequest) {
        _chekRequest = [[CheckBindRequest alloc]init];
    }
    return _chekRequest;
}
- (SubmitLendRequest *)subRequest{
    if (!_subRequest) {
        _subRequest = [[SubmitLendRequest alloc]init];
    }
    return _subRequest;
}
- (NSMutableArray *)repayWayArr{
    
    if (!_repayWayArr) {
        _repayWayArr = [NSMutableArray array];
    }
    return _repayWayArr;
}
- (NSMutableArray *)repayRateArr{
    if (!_repayRateArr) {
        _repayRateArr = [NSMutableArray array];
    }
    return _repayRateArr;
}
- (NSMutableArray *)moneyUseArr{
    if (!_moneyUseArr) {
        _moneyUseArr = [NSMutableArray array];
    }
    return _moneyUseArr;
}
- (NSMutableArray *)lendArray{
    if (!_lendArray) {
        _lendArray = [NSMutableArray array];
    }
    return _lendArray;
}

#pragma mark 存储数据
- (void)saveData{
    NSString *moneyCount = self.moneyCount.inputTextField.text;
    NSInteger lendMaxMoney = [_moneyCount.inputTextField.text integerValue];
    NSInteger maxMone = [_maxMoney integerValue]/4;
    if (!moneyCount || [moneyCount isEqualToString:@""]) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入借款金额" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if (lendMaxMoney > maxMone){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:[NSString stringWithFormat:@"借款金额不得大于%ld",maxMone] leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
    else if ([self.repayWay.selectDes isEqualToString:@"选择还款方式"]) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择还款方式" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if ([self.repayRate.selectDes isEqualToString:@"选择年化利率"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择年化利率" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if ([self.moneyUse.selectDes isEqualToString:@"选择借款用途"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择借款用途" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if ([self.lendDay.selectDes isEqualToString:@"选择借款时长"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请选择借款时长" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
    [self checkUseIsBindCard];
}
#pragma mark 判断是否绑卡认证
- (void)checkUseIsBindCard{
     __weak typeof(self) weakSelf = self;
    [weakSelf.chekRequest checkBindWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        int status = [dictResult[@"bind_card"] intValue];
        int isCertification = [dictResult[@"certification"] intValue];
        int payWord = [dictResult[@"check_paypwd"] intValue];
        int check_accountinfo = [dictResult[@"check_accountinfo"] intValue]; NSLog(@"status=======%d,isCertification==========%d,payWord=======%d",status,isCertification,payWord);
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
                    SetPWDViewController *setPwd = [[SetPWDViewController alloc]initWithType:KDSetPayPassword];
                    setPwd.controllIndex = 1;
                    [self dsPushViewController:setPwd animated:YES];
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
                    if (check_accountinfo == 0) {
                         [self submitLend];
                    }else{
                        DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"发布出借需要说明其他平台信息" leftButtonTitle:@"取消" rightButtonTitle:@"前往说明"];
                        alertView.rightBlock = ^{
                            CommonWebVC *vc = [[CommonWebVC alloc]init];
                            vc.strAbsoluteUrl = dictResult[@"account_info_url"];
                            [self dsPushViewController:vc animated:YES];
                        };
                        [alertView show];
                    }
                }
            }
        }
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }];
}
#pragma mark 提交求借
- (void)submitLend{
    [self showLoading:@""];
    NSString *borrow_money = self.moneyCount.inputTextField.text;
    NSString *repayment_type = [NSString stringWithFormat:@"%ld",self.repayWayIndex+1];
    NSString *borrow_use = [NSString stringWithFormat:@"%ld",self.moneyUseIndex+1];
    NSString *year_rate = [NSString stringWithFormat:@"%ld",self.repayRateIndex+1];
    if (self.lendIndex == 0) {
        _lendDayStr = @"7";
    }else{
        _lendDayStr = @"14";
    }
    __weak typeof(self) weakSelf = self;
    [weakSelf.subRequest saveLendInfoWithDict:@{@"borrow_money":borrow_money,
                                            @"repayment_type":repayment_type,
                                            @"repayment_date":@"",
                                            @"year_rate":year_rate,
                                            @"borrow_use":borrow_use,
                                            @"extra_info":self.textView.text,
                                                @"period":_lendDayStr
                                            }
   onSuccess:^(NSDictionary *dictResult) {
       [self hideLoading];
   DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"求借成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
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
#pragma mark 获取数据
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Base_URL1,KGetApplyBorrowOrder];
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
            MeLendModelResponse *response = [[MeLendModelResponse alloc]initWithDictionary:json error:&err];
            if( response != nil && response.data != nil){
                MeLendModel *model = response.data;
                _header.text = [NSString stringWithFormat:@"     您当前的可借额度是%@元",model.available_money];
                _maxMoney = model.available_money;
                _tip.text = model.tip;
               NSArray <YearRateMdoel *> *array = model.year_rate_all;
                for (YearRateMdoel *model in array) {
                    [self.repayRateArr addObject:model.name];
                }
                NSArray <BorrowUseMdoel *> *userArray = model.borrow_use_all;
                for (BorrowUseMdoel *model in userArray) {
                    [self.moneyUseArr addObject:model.name];
                }
                if (self.moneyUseArr.count == 9) {
                    _lendArray = [NSMutableArray arrayWithObjects:@"7天", nil];
                    
                }else if (self.moneyUseArr.count >9){
                    _lendArray = [NSMutableArray arrayWithObjects:@"7天",@"14天", nil];
                }
                NSArray <RepayTypeModel *> *typeArray = model.repayment_type_all;
                for (RepayTypeModel *model in typeArray) {
                    [self.repayWayArr addObject:model.name];
                }
                ProtocolLendMdoel *modelProtocol = model.borrow_protocol;
                _urlProtocol = modelProtocol.url;
               [_agree setTitle:modelProtocol.name forState:UIControlStateNormal];
            }
        }
    }];
}
#pragma mark  tableView代理
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
            return self.moneyUse;
            break;
        case 4:
            return self.lendDay;
            break;
        default:
            return [UITableViewCell new];
    }
}
- (UITableViewCell* )BuilderRepayDayCell:(NSIndexPath*)indexPath{
    static NSString *cellid = @"cell";
    _cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
    if (!_cell) {
        _cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    _cell.textLabel.text = @"还款日期";
    _cell.textLabel.textColor = [UIColor darkGrayColor];
    _cell.textLabel.font = [UIFont systemFontOfSize:14];
    [self setUpRepayDay:_cell];
    return _cell;
}
#pragma mark 懒加载
- (InputCell *)moneyCount{
    if (!_moneyCount) {
        _moneyCount = [[InputCell alloc]initWithTitle:@"借款金额" placeholder:@"请输入整数 元"];
        _moneyCount.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
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
- (PickerCell *)lendDay{
    if (!_lendDay) {
        _lendDay = [[PickerCell alloc]initWithTitle:@"借款时长" subTitle:@"" selectDes:@"选择借款时长"];
        @Weak(self)
        _lendDay.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.lendArray.count;
        };
        _lendDay.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.lendArray[row];
        };
        _lendDay.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.lendIndex = selectedRow;
            self.lendDay.selectDes = self.lendArray.count ? self.lendArray[selectedRow] : @"";
        };
    }
     return _lendDay;
}
- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 280*RATE, 0, 260*RATE, 45)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = [UIColor darkGrayColor];
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}
- (void)setUpRepayDay:(UITableViewCell *)cell {
    if (!_repayDay) {
        _repayDay = [self getTextField:cell];
        _repayDay.placeholder = @"请选择还款时间";
        __weak typeof(self) weakSelf = self;
        _repayDay.tapAcitonBlock = ^{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]];
            NSString *nextStr = [dateFormatter stringFromDate:nextDay];
            [BRDatePickerView showDatePickerWithTitle:@"选择还款时间" dateType:UIDatePickerModeDate defaultSelValue:weakSelf.repayDay.text minDateStr:nextStr maxDateStr:@"" isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                weakSelf.repayDay.text = selectValue;
            }];
        };
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
- (PickerCell *)moneyUse {
    if (!_moneyUse) {
        _moneyUse = [[PickerCell alloc] initWithTitle:@"借款用途" subTitle:@"" selectDes:@"选择借款用途"];
        @Weak(self)
        _moneyUse.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.moneyUseArr.count;
        };
        _moneyUse.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.moneyUseArr[row];
        };
        _moneyUse.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.moneyUseIndex = selectedRow;
            
            self.moneyUse.selectDes = self.moneyUseArr.count ? self.moneyUseArr[selectedRow] : @"";
        };
    }
    return _moneyUse;
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
