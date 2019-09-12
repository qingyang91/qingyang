//
//  MeViewController.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/17.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "MeViewController.h"
#import "CertificationCenterVC.h"
#import "MeCell.h"
#import "SettingVC.h"
#import "UserManager.h"
#import "MeRequest.h"
#import "MeModel.h"
#import "CommonWebVC.h"
#import "ShareManager.h"
#import "DXAlertView.h"
#import "AsteriskTool.h"
#import "NSString+Frame.h"
#import "BorrowViewController.h"
#import "OutLendViewController.h"
#import "CheckBindRequest.h"
#import "BindCardViewController.h"
#import "BankListViewController.h"
#import "SetPWDViewController.h"
#import "LendListViewController.h"
#import "ConfirmViewController.h"
#import "AgreeViewController.h"
#import "SetViewController.h"
#import "BorrowViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, retain) UIView            *headerView;
@property (nonatomic, retain) UIView            *footerView;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, retain) NSMutableArray    *arrData;
@property (nonatomic,strong)  MeRequest         *request;
@property (nonatomic,strong)  MeModel           *meModel;
@property (nonatomic, strong) DXAlertView       *alertView;
@property (nonatomic, retain) UIButton          *avatarBtn;
@property (nonatomic, retain) UILabel           *userPhoneLabel;
@property (nonatomic, strong) CheckBindRequest  *checkRequest;
@property (nonatomic, assign) NSInteger payWord;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger isCertification;
@property (nonatomic, copy)   NSString *strUrl;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加rightBarButtonItem
    [self umengEvent:@"Me" attributes:nil number:@10];
    self.navigationItem.title = @"个人中心";
    //布局UI
    [self  createAvatarView];
}

- (MeRequest *)request{
    if (!_request) {
        _request = [[MeRequest alloc] init];
    }
    return _request;
}
- (CheckBindRequest *)checkRequest{
    if (!_checkRequest) {
        _checkRequest = [[CheckBindRequest alloc]init];
    }
    return _checkRequest;
}
- (MeModel *)meModel{
    if (!_meModel) {
        _meModel = [[MeModel alloc] init];
    }
    return _meModel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    [self loadData];
    [self checkBind];
    self.navigationItem.title = @"个人中心";
    //    self.userPhoneLabel.text = [AsteriskTool phoneNumToAsterisk:[[UserManager sharedUserManager].userInfo username]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)loadData{
    [super loadData];
    self.vNoNet.hidden = YES;
    [self showLoading:@""];
    
    [self.request getUserInfoWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        self.meModel = [MeModel meModelWithDic:dictResult[@"share"]];
        self.userPhoneLabel.text = [AsteriskTool phoneNumToAsterisk:[[UserManager sharedUserManager].userInfo username]];
        [self hideLoading];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        if (code == -2) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"您的登录态已失效，请重新登录" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                
                [[UserManager sharedUserManager] checkLogin:self];
            };
            [alert show];
        }else{
            //            [self.view bringSubviewToFront:self.vNoNet];
            //            self.vNoNet.hidden = NO;
        }
    }];
}

#pragma mark -- 跳转到设置页面
- (void)gotoSetting{
    [self umengEvent:@"Me_Setting" attributes:nil number:@10];
    SetViewController *vcSetting = [[SetViewController alloc]init];
    vcSetting.real_verify_status = [self.meModel.verify_info.real_verify_status integerValue];
    vcSetting.meModel = _meModel;
    vcSetting.payWord = _payWord;
    [self dsPushViewController:vcSetting animated:YES];
}

-(void)createAvatarView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.5)];
    _headerView.backgroundColor = Color_GRAY;
    
    UIImageView *bgImg = [[UIImageView alloc] init];
    bgImg.image = [UIImage imageNamed:@"icon_me_heardimg"];
    [self.headerView addSubview:bgImg];
    bgImg.contentMode = UIViewContentModeScaleToFill;
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_headerView.mas_left).with.offset(0);
        make.right.equalTo(_headerView.mas_right).with.offset(0);
        make.top.equalTo(_headerView.mas_top).with.offset(0);
        make.bottom.equalTo(_headerView.mas_bottom).with.offset(0);
    }];
    UIView *moneyView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/2.5+10, SCREEN_WIDTH, 50)];
    moneyView.backgroundColor = [UIColor whiteColor];
    NSArray *nameArray = @[@"求借列表",@"出借列表"];
    for (NSInteger i =0; i<nameArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0+SCREEN_WIDTH/2.0*i, 0, SCREEN_WIDTH/2.0, 50)];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = 100+i;
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goPush:) forControlEvents:UIControlEventTouchUpInside];
        [moneyView addSubview:button];
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-1, 0, 1, 50)];
    line.backgroundColor = Color_LineColor;
    [moneyView addSubview:line];
//    [self.headerView addSubview:moneyView];
    NSString *userNameStr = [AsteriskTool phoneNumToAsterisk:[[UserManager sharedUserManager].userInfo username]];
    
    self.avatarBtn = [[UIButton alloc] init];
    [self.headerView addSubview:self.avatarBtn];
    self.avatarBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.avatarBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(@((SCREEN_WIDTH-self.headerView.frame.size.height/2-[userNameStr widthWithFontSize:25.0f]-10)/2));
        
        make.centerY.equalTo(self.headerView.mas_centerY).with.offset(0);
        
        make.width.equalTo(@(self.headerView.frame.size.height/2));
        make.height.equalTo(@(self.headerView.frame.size.height/2));
    }];
    [self.avatarBtn setImage:[UIImage imageNamed:@"icon_user_image_default"] forState:normal];
    
    self.userPhoneLabel = [[UILabel alloc] init];
    self.userPhoneLabel.font = [UIFont systemFontOfSize:25.0f];
    self.userPhoneLabel.textColor = Color_White;
    [self.headerView addSubview:self.userPhoneLabel];
    self.userPhoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.userPhoneLabel.textAlignment = NSTextAlignmentLeft;
    //    self.userPhoneLabel.text = @"185****3362";
    self.userPhoneLabel.text = [AsteriskTool phoneNumToAsterisk:[[UserManager sharedUserManager].userInfo username]];
    [self.userPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.avatarBtn.mas_right).with.offset(10.f);
        make.centerY.equalTo(self.headerView.mas_centerY).with.offset(0);
        make.width.equalTo(@(SCREEN_WIDTH-15.f*WIDTHRADIUS-115));
        make.height.equalTo(@20);
    }];
    
    [self showData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = _headerView;
    _tableView.backgroundColor = Color_TABBG;
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}
- (void)goPush:(UIButton *)btn{
    if (btn.tag == 100) {
        BorrowViewController *vc = [[BorrowViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 101) {
        OutLendViewController *vc = [[OutLendViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)showData{
    [self.arrData removeAllObjects];
    NSArray *array = @[
                       @[@{@"strIcon":@"my_bank",@"strTitle":@"银行卡",@"strContent":@""},
                         @{@"strIcon":@"my_bank",@"strTitle":@"银行卡",@"strContent":@""}],
                       @[@{@"strIcon":@"icon_me_improveInformation",@"strTitle":@"信用",@"strContent":@""}],
                       @[@{@"strIcon":@"icon_menu_helpulend_pressed",@"strTitle":@"我的求借",@"strContent":@""}],
                       @[@{@"strIcon":@"icon_menu_helpulend_pressed",@"strTitle":@"已生效借条",@"strContent":@""}],
                       @[@{@"strIcon":@"icon_me_setting",@"strTitle":@"设置",@"strContent":@""}]
                       ];
    
    self.arrData = [NSMutableArray arrayWithArray:array];
    
    [self.tableView reloadData];
}

#pragma mark -- 提额

- (void)goToLogin:(UIButton *)btn{
}

#pragma mark --  完善资料和借款记录跳转

-(void)toVerifyVC{
    CertificationCenterVC *loanRe = [[CertificationCenterVC alloc] init];
    [self dsPushViewController:loanRe animated:YES];
}
-(void)toShare{
    [self umengEvent:@"Me_Share" attributes:nil number:@10];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic =@{
                         @"shareBtnTitle":@"分享",
                         @"isShare":@"1",
                         @"share_title":weakSelf.meModel.share_title ? weakSelf.meModel.share_title : @"助力凭条",
                         @"share_body":weakSelf.meModel.share_body ? weakSelf.meModel.share_body :@"这是分享",
                         @"share_logo":weakSelf.meModel.share_logo ? weakSelf.meModel.share_logo :@"",
                         @"sharePlatform":@[@"wx",@"wechatf",@"qq",@"qqzone"],
                         @"share_url":weakSelf.meModel.share_url ? weakSelf.meModel.share_url : @"http://www.pettycash.cn"};
    ShareEntity *entitys = [ShareEntity shareWithDict:dic];
    
    [[ShareManager shareManager]showWithShareEntity:entitys];
}

#pragma mark --UITableView代理


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *array = [self.arrData objectAtIndex:section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 15;
    }else{
        return 55*WIDTHRADIUS;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 4) {
        UIView *view = [[UIView alloc] init];
        UIImageView *qianbao = [[UIImageView alloc] init];
        qianbao.image = [UIImage imageNamed:@"icon_me_qianbao"];
        qianbao.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:qianbao];
        [qianbao mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(view.mas_top).with.offset(30);
            make.left.equalTo(@((SCREEN_WIDTH-20-[@"完善更多信息更有利于借入借出哦！" widthWithFontSize:13.0f]-5)/2));
            make.centerY.equalTo(view.mas_centerY).with.offset(0);
            make.width.equalTo(@(25));
            make.height.equalTo(@(25));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"完善更多信息更有利于借入借出哦！";
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor darkGrayColor];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(qianbao.mas_right).with.offset(5.f);
            make.centerY.equalTo(qianbao.mas_centerY).with.offset(0);
        }];
        return view;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *array = [self.arrData objectAtIndex:indexPath.section];
    
    [cell updateTableViewCellWithdata:array index:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_status == 0) {
            DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"未绑定银行卡" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alertView.rightBlock = ^{
                BindCardViewController *vc = [[BindCardViewController alloc]init];
                [self dsPushViewController:vc animated:YES];
            };
            [alertView show];
        }else{
            BankListViewController *vc = [[BankListViewController alloc]init];
            [self dsPushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (_status == 0) {
            DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"未绑定银行卡" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alertView.rightBlock = ^{
                BindCardViewController *vc = [[BindCardViewController alloc]init];
                [self dsPushViewController:vc animated:YES];
            };
            [alertView show];
        }else{
            if (_payWord == 0) {
                DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"未设置交易密码" leftButtonTitle:nil rightButtonTitle:@"确定"];
                alertView.rightBlock = ^{
                    SetPWDViewController *setPwd = [[SetPWDViewController alloc]initWithType:KDSetPayPassword];
                    setPwd.controllIndex = 1;
                    [self dsPushViewController:setPwd animated:YES];
                };
                [alertView show];
            }else{
                if (_isCertification == 0) {
                    DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"未支付认证费用" leftButtonTitle:nil rightButtonTitle:@"确定"];
                    alertView.rightBlock = ^{
                        CommonWebVC *vc = [[CommonWebVC alloc]init];
                        vc.strAbsoluteUrl = _strUrl;
                        [self dsPushViewController:vc animated:YES];
                    };
                    [alertView show];
                }else{
                    [self toVerifyVC];
                }
            }
        }
    }else if (indexPath.section == 2){
        BorrowViewController *vc = [[BorrowViewController alloc]init];
        [self dsPushViewController:vc animated:YES];
    }else if (indexPath.section == 3){
        LendListViewController *vc = [[LendListViewController alloc]init];
        vc.type = @"2";
        [self dsPushViewController:vc animated:YES];
    }
    else{
        [self gotoSetting];
    }
}
- (void)checkBind{
    [self.checkRequest checkBindWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        _status = [dictResult[@"bind_card"] intValue];
        _isCertification = [dictResult[@"certification"] intValue];
        _payWord = [dictResult[@"check_paypwd"] intValue];
        _strUrl = dictResult[@"pay_url"];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }];
}

// Do any additional setup after loading the view.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uploadAvatar{
    UIAlertController *myAction = [UIAlertController alertControllerWithTitle:@"选择头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    [myAction addAction:photoAction];
    [myAction addAction:cameraAction];
    [myAction addAction:cancelAction];
    [self presentViewController:myAction animated:YES completion:nil];
}

#pragma - imagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    __weak typeof(self) weakSelf = self;
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    [self.uploadArray addObject:image];
    //    [self.viewController dismissViewControllerAnimated:YES completion:^{
    //        [weakSelf.pageDataArray removeAllObjects];
    //        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.dataArray];
    //        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.uploadArray];
    //        [weakSelf reloadData];
    //    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
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
