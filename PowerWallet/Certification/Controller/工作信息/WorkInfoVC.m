//
//  WorkInfoVC.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "WorkInfoVC.h"
#import "CertificationCenterRequest.h"
#import "WorkInfoModel.h"
#import "InputCell.h"
#import "SelectionCell.h"
#import "PickerCell.h"
#import "AscendingUpLoadVC.h"
#import "GDLocationVC.h"
#import "GDLocationManager.h"
#import "BankDataEncryptionView.h"

@interface WorkInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) CertificationCenterRequest *workInfoNetworkAccess;
@property (nonatomic,strong) WorkInfoModel *workInfoModel;
@property (nonatomic,strong) WorkTimeModel *workTimeModel;
@property (nonatomic, retain) NSMutableArray *workingHoursArr;

///公司名称
@property (strong, nonatomic) InputCell *companyNameCell;
///公司联系方式
@property (strong, nonatomic) InputCell *companyPhoneCell;
///所在地
@property (strong, nonatomic) SelectionCell *addressCell;
///详细地址
@property (strong, nonatomic) InputCell *detailAddressCell;
///工作照
@property (strong, nonatomic) SelectionCell *workingPictureCell;
///工作时长
@property (strong, nonatomic) PickerCell *workingHoursCell;
@property (nonatomic, strong) UIBarButtonItem *navBtn;
@property (assign, nonatomic) NSInteger pickerMaritalIndex;

@property (strong, nonatomic) BankDataEncryptionView *encryptionView;
@end

@implementation WorkInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
     [self getData];
}

- (CertificationCenterRequest *)workInfoNetworkAccess{
    
    if (!_workInfoNetworkAccess) {
        _workInfoNetworkAccess = [CertificationCenterRequest new];
    }
    return _workInfoNetworkAccess;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xeff3f5];


    self.navigationItem.title = @"工作信息";
    
   
}
- (void)createUI{
    [self baseSetup:PageGobackTypePop];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xeff3f5];
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    header.text = @"    为保证借款申请顺利通过，请务必填写真实信息";
    header.font = Font_SubTitle;
    header.textColor = Color_Title;
    
    _tableView.tableHeaderView = header;
    [_tableView setSeparatorColor:Color_LineColor];
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:self.encryptionView];
    _tableView.tableFooterView = view;
    
    [self.encryptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top).with.offset(10);
        make.right.equalTo(view.mas_right);
        make.height.equalTo(@40);
    }];
    
    [self.view addSubview:_tableView];
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = self.navBtn;
    }
}

- (BankDataEncryptionView *)encryptionView {
    
    if (!_encryptionView) {
        _encryptionView = [BankDataEncryptionView bankDataEncryptionView];
    }
    return _encryptionView;
}

- (void)saveData
{
   
    
    NSString *name = self.companyNameCell.inputTextField.text;
    NSString *address = self.addressCell.subTitle.text == nil?NULL:self.addressCell.subTitle.text;
    NSString *addressDetail = self.detailAddressCell.inputTextField.text;
    NSString *phone = self.companyPhoneCell.inputTextField.text;
    NSString *longitude = @"0.000000";
    NSString *latitude = @"0.000000";
    if (!name || [name isEqualToString:@""]) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入单位名称" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if(!phone||[phone isEqualToString:@""]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入单位电话" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if (!address || [address isEqualToString:@""]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入单位地址" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if(!addressDetail || [addressDetail isEqualToString:@""]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入详细地址" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if([self.workingHoursCell.selectDes isEqualToString:@"选择"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入工作时长" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
     [self showLoading:@""];
    NSString *company_period = [NSString stringWithFormat:@"%ld",self.pickerMaritalIndex+1] ;
    __weak typeof(self) weakSelf = self;
    
    [self.workInfoNetworkAccess saveWorkInfoWithDict: @{@"company_name":name,
                                          @"company_address_distinct":address == nil?@"":address,
                                          @"company_address":addressDetail,
                                          @"company_phone":phone,
                                          @"company_period":company_period,
                                          @"longitude":longitude,
                                          @"latitude":latitude
                                          } onSuccess:^(NSDictionary *dictResult) {
                                              [self hideLoading];
        DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"信息保存成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
        alertView.rightBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [alertView show];
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}

- (NSMutableArray *)workingHoursArr{
    
    if (!_workingHoursArr) {
        _workingHoursArr = [NSMutableArray array];
    }
    return _workingHoursArr;
}

- (void)getData
{
    __weak typeof(self) weakSelf = self;
    [self showLoading:@""];
    [self.workInfoNetworkAccess getWorkInfoWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
        weakSelf.workInfoModel = [WorkInfoModel workInfoWithDictionary:dictResult[@"item"]];
        /**********入司时长数据**********/
        [weakSelf.workingHoursArr removeAllObjects];
        NSArray <WorkTimeModel *> *array = weakSelf.workInfoModel.company_period_list;
        for (WorkTimeModel *model in array ) {
            
            [weakSelf.workingHoursArr addObject:model.name];
        }
        
        weakSelf.workTimeModel.entry_time_type = weakSelf.workInfoModel.company_period;
        [_tableView reloadData];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        
    }];
    
    
}
#pragma mark - Getter
- (UIBarButtonItem *)navBtn {
    
    if (!_navBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"保存" forState:normal];
        [button setTitleColor:[UIColor whiteColor] forState:normal];
        button.titleLabel.font = Font_Title;
        [button addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _navBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _navBtn;
}

#pragma mark --UITableView代理


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            if (![self.workInfoModel.company_name isEqualToString:@""]) {
                self.companyNameCell.inputTextField.text = self.workInfoModel.company_name;
            }
            
            return self.companyNameCell;
        }
            break;
        case 1:{
            if (![self.workInfoModel.company_phone isEqualToString:@""]) {
                self.companyPhoneCell.inputTextField.text = self.workInfoModel.company_phone;
            }
            return self.companyPhoneCell;
        }
            break;
        case 2:{
            if (![self.workInfoModel.company_address_distinct isEqualToString:@""]) {
                self.addressCell.subTitle.text = self.workInfoModel.company_address_distinct;
            }
            return self.addressCell;
        }
            break;
        case 3:{
            if (![self.workInfoModel.company_address isEqualToString:@""]) {
                self.detailAddressCell.inputTextField.text = self.workInfoModel.company_address;
            }
            return self.detailAddressCell;
        }
            break;
        case 4:{
            if([self.workInfoModel.company_picture isEqualToString:@"1"]){
                self.workingPictureCell.subTitle.text = @"已上传";
            }
            return self.workingPictureCell;
        }
            break;
        case 5:{
            if (![self.workInfoModel.company_period isEqualToString:@""]) {
                for (WorkTimeModel *model in self.workInfoModel.company_period_list) {
                    if([model.entry_time_type isEqualToString:self.workInfoModel.company_period]){
                        self.workingHoursCell.selectDes = model.name;
                    };
                    
                }
            }
            return self.workingHoursCell;
        }
        default:
            return [UITableViewCell new];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 2:
        {
            GDLocationVC *vc = [[GDLocationVC alloc]init];
            [[GDLocationManager shareInstance]startLocation];
            vc.address = ^(AMapPOI * model, MAUserLocation* Usermodel){
                self.addressCell.subTitle.text = model.address;
                [self.addressCell setSubTitleValue:model.name];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
        
            AscendingUpLoadVC *vc = [[AscendingUpLoadVC alloc]initWithType:workCard];
            vc.uploadImgSuccss = ^{
                self.workingPictureCell.subTitle.text = @"已上传";
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SelectionCell *)addressCell {
    
    if (!_addressCell) {
        _addressCell = [[SelectionCell alloc] initWithTitle:@"单位所在地" subTitle:@""];
    }
    return _addressCell;
}
- (SelectionCell *)workingPictureCell {
    
    if (!_workingPictureCell) {
        _workingPictureCell = [[SelectionCell alloc] initWithTitle:@"工作照片" subTitle:@"(选填,可提高通过率)"];
        
    }
    return _workingPictureCell;
}
- (InputCell *)companyNameCell {
    
    if (!_companyNameCell) {
        _companyNameCell = [[InputCell alloc] initWithTitle:@"单位名称" placeholder:@"请输入单位名称"];
    }
    return _companyNameCell;
}
- (InputCell *)companyPhoneCell {
    
    if (!_companyPhoneCell) {
        _companyPhoneCell = [[InputCell alloc] initWithTitle:@"单位电话" placeholder:@"请输入单位电话"];
    }
    return _companyPhoneCell;
}
- (InputCell *)detailAddressCell {
    
    if (!_detailAddressCell) {
        _detailAddressCell = [[InputCell alloc] initWithTitle:@"" placeholder:@"请填写具体街道门牌号"];
    }
    return _detailAddressCell;
}

- (PickerCell *)workingHoursCell {
    
    if (!_workingHoursCell) {
        _workingHoursCell = [[PickerCell alloc] initWithTitle:@"工作时长" subTitle:@"" selectDes:@"选择"];
        
        @Weak(self)
        _workingHoursCell.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.workingHoursArr.count;
        };
        _workingHoursCell.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.workingHoursArr[row];
        };
        _workingHoursCell.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.pickerMaritalIndex = selectedRow;
            
            self.workingHoursCell.selectDes = self.workingHoursArr.count ? self.workingHoursArr[selectedRow] : @"";
        };
    }
    return _workingHoursCell;
}
//***************************************no use**************************************************
- (void)thisIsUselessForSure{
    UIView  *preview;
    UIView *iconView;
    UIView *toolBarView;
    UILabel *sizeLabel;
    if (preview ) {
        if (!iconView) {
            iconView = [[UIView alloc] init];
            iconView.backgroundColor = [UIColor blackColor];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            [preview addSubview:iconView];
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        if (!toolBarView) {
            toolBarView = [UIView new];
            toolBarView.backgroundColor = [UIColor whiteColor];
            [preview addSubview:toolBarView];
        }
        if (!sizeLabel) {
            sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            sizeLabel.textAlignment = NSTextAlignmentCenter;
            sizeLabel.textColor =  [UIColor whiteColor];
            sizeLabel.font = [UIFont systemFontOfSize:14];
            sizeLabel.text = @"正在下载中...";
            [toolBarView addSubview:sizeLabel];
        }
    }
}
//***************************************no use**************************************************

@end
