//
//  BindCardViewController.m
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "BindCardViewController.h"
#import "UserManager.h"
#import "DXAlertView.h"
#import "AsteriskTool.h"
#import "PJOrder.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"
#import "TimeHander.h"
#import "BindBankCell.h"
#import "BindBankFooterView.h"
#import "SubmitCardRequest.h"
#import "CertificationCenterRequest.h"
#define LLPayOid_partner                @"201708290000845767"
typedef enum LLPayResult LLPayResult;
const NSArray *___LLPayResult;
// 创建初始化函数，等于用宏创建一个getter函数
#define cLLPayResultGet (___LLPayResult == nil ? ___LLPayResult = [[NSArray alloc] initWithObjects:\
@"kLLPayResultSuccess",\
@"kLLPayResultFail",\
@"kLLPayResultCancel",\
@"kLLPayResultInitError",\
@"kLLPayResultInitParamError",\
@"kLLPayResultUnknow", nil]:___LLPayResult)

// 枚举 to 字串
#define cLLPayResultString(type) ([cLLPayResultGet objectAtIndex:type])
// 字串 to 枚举
#define cLLPayResultEnum(string) ([cLLPayResultGet indexOfObject:string])
@interface BindCardViewController ()<UITableViewDataSource,UITableViewDelegate,LLPaySdkDelegate>

@property (nonatomic, strong) UITableView           * tbvMain;
@property (nonatomic, strong) UIView                * tbvMainHeader;
@property (nonatomic, strong) NSMutableArray        * arrDataSource;
@property (nonatomic, strong) NSMutableDictionary   * dictParm;
@property (nonatomic, strong) PJOrder *order;
@property (nonatomic, retain) NSMutableDictionary *orderDic;
@property (nonatomic, strong) SubmitCardRequest *request;
@property (nonatomic, strong) CertificationCenterRequest *cerRequest;

@end

@implementation BindCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.navigationItem.title = @"添加银行卡";
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveData)];
    saveBtn.tintColor = Color_White;
//    self.navigationItem.rightBarButtonItem = saveBtn;
    [self.view addSubview:self.tbvMain];
    [self.view updateConstraintsIfNeeded];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark 数据
- (SubmitCardRequest *)request{
    if (!_request) {
        _request = [[SubmitCardRequest alloc]init];
    }
    return _request;
}
- (CertificationCenterRequest *)cerRequest{
    if (!_cerRequest) {
        _cerRequest = [[CertificationCenterRequest alloc]init];
    }
    return _cerRequest;
}
- (void)loadData{
    
}
- (void)saveData{
    if ([self checkInfoWithCode:YES]) {
        [self showLoading:@""];
        NSDictionary *dic = @{@"uid":[UserManager sharedUserManager].userInfo.uid,
                              @"name":self.dictParm[@"name"],
                              @"idNo":self.dictParm[@"card_no"],
                              @"cardNo":self.dictParm[@"bank_id"]
                              };
        __weak __typeof(self)weakSelf = self;
        NSLog(@"savedic=========%@",dic);
        [self.request submitCardInfoWithDict:dic onSuccess:^(NSDictionary *dictResult) {
            [weakSelf hideLoading];
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"保存成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [weakSelf popVC];
            };
            [alert show];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [weakSelf hideLoading];
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
        }];
    }
}
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDataSource.count+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == self.arrDataSource.count){
        return 100;
    }else{
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.arrDataSource.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
            cell.backgroundColor = [UIColor clearColor];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width-40, 50)];
            [btn setTitle:@"绑定银行卡" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor orangeColor];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 6.0;
            [btn addTarget:self action:@selector(bindCard:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        BindBankCell * cell = [BindBankCell bindBankCellWithTableView:tableView];
        [cell configCellWithDict:self.arrDataSource[indexPath.row] withIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        cell.changeBlock = ^(NSString * parmKey, NSString * parmValue) {
            [weakSelf.dictParm setObject:parmValue forKey:parmKey];
        };
        return cell;
    }
}
#pragma mark - Other
- (void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.tbvMain.translatesAutoresizingMaskIntoConstraints) {
        [self.tbvMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}
- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tbvMain.backgroundColor = [UIColor colorWithHex:0xeff3f5];
        _tbvMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvMain.dataSource = self;
        _tbvMain.delegate = self;
        _tbvMain.tableHeaderView = self.tbvMainHeader;
        _tbvMain.tableFooterView = [BindBankFooterView bindBankEncryptionView];;
    }
    return _tbvMain;
}
- (NSMutableArray *)arrDataSource {
    if (!_arrDataSource) {
        _arrDataSource = [NSMutableArray arrayWithObjects:@{@"title":@"持卡人",@"placeHolder":@"请输入真实姓名",@"hasArrow":@"0",@"textColor":@"",@"vcode":@"0"},
                          @{@"title":@"身份证号",@"placeHolder":@"请输入身份证号",@"hasArrow":@"0",@"textColor":@"",@"vcode":@"0"},
                          @{@"title":@"卡号",@"placeHolder":@"请输入银行卡号(仔细核对，否则打款失败)",@"hasArrow":@"0",@"textColor":@"red",@"vcode":@"0"},
                          nil];
    }
    return _arrDataSource;
}
- (NSMutableDictionary *)dictParm {
    if (!_dictParm) {
        _dictParm = [[NSMutableDictionary alloc] initWithDictionary:@{@"name":@"",@"card_no":@"",@"bank_id":@""}];
    }
    return _dictParm;
}
- (UIView *)tbvMainHeader {
    if (!_tbvMainHeader) {
        _tbvMainHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tbvMainHeader.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(15*WIDTHRADIUS, 0, SCREEN_WIDTH - 30*WIDTHRADIUS, 40)];
        lbl.text = @"添加您的银行卡用于收款";
        lbl.textColor = Color_Title;
        lbl.font = Font_SubTitle;
        [_tbvMainHeader addSubview:lbl];
    }
    return _tbvMainHeader;
}
- (BOOL)checkInfoWithCode:(BOOL)needCode {
    NSString * alertContent = @"";
    if ([_dictParm[@"name"] isEqualToString:@""] || _dictParm == nil) {
        alertContent = @"请输入姓名！";
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:alertContent leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return NO;
    }else if ([_dictParm[@"card_no"] isEqualToString:@""] || _dictParm == nil) {
        alertContent = @"请输入身份证号！";
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:alertContent leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return NO;
    }else if ([_dictParm[@"bank_id"] isEqualToString:@""] || _dictParm == nil){
        alertContent = @"请输入银行卡号！";
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:alertContent leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return NO;
    }
    return YES;
}
#pragma mark 绑卡
-(void)bindCard:(UIButton *)btn{
    if ([self checkInfoWithCode:YES]) {
        NSDictionary *dic = @{@"acct_name":self.dictParm[@"name"],
                              @"card_no":self.dictParm[@"bank_id"],
                              @"id_no":self.dictParm[@"card_no"],
                              @"oid_partner":LLPayOid_partner,
                              @"sign_type":@"RSA",
                              @"user_id":[UserManager sharedUserManager].userInfo.uid
                              };
         NSLog(@"bindic=========%@",dic);
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        }];
        NSArray *array3 = [[dic allKeys]
                           sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSMutableDictionary *dictNew = [[NSMutableDictionary alloc]init];
        [array3 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dictNew setObject:dic[obj] forKey:obj];
        }];
        [self showLoading:@""];
        [self.cerRequest signRSADict:dictNew onSuccess:^(NSDictionary *dictResult) {
            NSString *msg = dictResult[@"msg"];
            int code = [dictResult[@"code"] intValue];
            [self hideLoading];
            if (code == 0){
                NSDictionary *result = dictResult[@"result"];
                NSString *sign = result[@"sign"];
                [self sign:sign orderInfo:dictNew];
            }else{
                DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:msg leftButtonTitle:nil rightButtonTitle:@"确定"];
                alert.rightBlock = ^{
                    [self.navigationController popViewControllerAnimated:YES];
                };
                [alert show];
            }
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self showMessage:errorMsg];
            [self hideLoading];
        }];
    }
}
-(void)sign:(NSString *)sign orderInfo:(NSDictionary *)dic{
    self.orderDic = [[_order tradeInfoForSign] mutableCopy];
    LLPayUtil *payUtil = [[LLPayUtil alloc] init];
    payUtil.signKeyArray = @[
                             @"acct_name",
                             @"card_no",
                             @"id_no",
                             @"oid_partner",
                             @"risk_item",
                             @"sign_type",
                             @"user_id"
                             ];
    NSMutableDictionary *signedOrder = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [signedOrder setValue:sign forKey:@"sign"];
    [LLPaySdk sharedSdk].sdkDelegate = self;
    [[LLPaySdk sharedSdk] presentLLPaySignInViewController:self withPayType:LLPayTypeVerify andTraderInfo:signedOrder];
}
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *enumStr = cLLPayResultString(resultCode);
    NSString *msg = @"异常";
    if (resultCode == kLLPayResultSuccess) {
        msg = @"成功";
        [self showLoading:@""];
        [self.cerRequest saveBindBankWithDict:@{@"real_name":self.dictParm[@"name"],
                                                @"id_no":self.dictParm[@"card_no"],        
                                                @"card_no":self.dictParm[@"bank_id"],
                                                @"user_id":dic[@"user_id"],
                                                @"no_agree":dic[@"no_agree"]}
                                    onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            NSString *msg = dictResult[@"msg"];
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:msg leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [alert show];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self showMessage:errorMsg];
            [self hideLoading];
        }];
    }else{
        if (resultCode == kLLPayResultInitParamError) {
            msg = dic[@"ret_msg"];
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:msg leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            alert.rightBlock = ^(){
                [self bindingCard:msg userID:[UserManager sharedUserManager].userInfo.uid];
            };
        }else{
            [self bindingCard:enumStr userID:[UserManager sharedUserManager].userInfo.uid];
        }
    }
}
-(void)bindingCard:(NSString *)state userID:(NSString *)u_id{
    [self showLoading:@""];
    [self.cerRequest bindingCardStateWithDict:@{@"user_id":u_id,@"report_time":[TimeHander currentDateAndHoursTime],@"state":state} onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self showMessage:errorMsg];
        [self hideLoading];
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
