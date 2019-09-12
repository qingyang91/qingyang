//
//  EmergencyContactVC.m
//  PowerWallet
//
//  Created by PowerWallet on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "EmergencyContactVC.h"
#import "ContactsModel.h"
#import "CertificationCenterRequest.h"
#import "PickerCell.h"
#import "SelectionCell.h"
#import "SelectContactsVC.h"
#import <AFNetworkReachabilityManager.h>
#import "GetContactsBook.h"
#import "UserManager.h"
#import "CertificationCenterRequest.h"
#import "GetContactsBook.h"

#import "BankDataEncryptionView.h"
#import "JQFMDB.h"

@interface EmergencyContactVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIBarButtonItem       *navBtn;
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSMutableArray        *contactPersonArr;
@property (nonatomic, strong) ContactsModel       *model;
@property (nonatomic, strong) CertificationCenterRequest   *request;
@property (nonatomic, strong) NSMutableDictionary   *dictParm;
@property (nonatomic, assign) NSInteger             isContact;//1成功2失败
@property (nonatomic, assign) NSInteger             isContacts;

@property (strong, nonatomic) BankDataEncryptionView *encryptionView;
@end

@implementation EmergencyContactVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    [self getDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    //delegate 置为nil
    //删除通知
}

#pragma mark - View创建与设置

- (void)setUpView {
    self.navigationItem.title = @"紧急联系人";
    [self baseSetup:PageGobackTypePop];
    
    //创建视图等
    self.navigationItem.rightBarButtonItem = self.navBtn;
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - 初始化数据源
- (void)setUpDataSource {
    _isContact = 0;
    _isContacts = 0;
}

#pragma mark - 按钮事件
- (void)saveData {
    if ([self checkInfo]) {
        
        if ([self.dictParm[@"mobile"] isEqualToString:self.dictParm[@"mobile_spare"]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"直系联系人与其他联系人不能重复！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [self showLoading:@""];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self upLoadAddressBook];
        });
        
        __weak __typeof(self)weakSelf = self;
        [self.request SaveContactsWithDictionary:self.dictParm success:^(NSDictionary *dictResult) {
            _isContact = 1;
            [weakSelf updateLoading];
        } failed:^(NSInteger code, NSString *errorMsg) {
            _isContact = 2;
            [weakSelf updateLoading];
            [weakSelf showMessage:errorMsg];
            //            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
            //            [alert show];
        }];
    }
}

- (void)updateLoading {
    if (_isContacts && _isContact) {
        [self hideLoading];
        if (_isContacts == 1 && _isContact == 1) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"信息保存成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [self popVC];
            };
            [alert show];
        }
        _isContact = _isContacts = 0;
    }
}

- (void)upLoadAddressBook {
    NSMutableArray *addressBook = [[UserDefaults objectForKey:@"contacts"] mutableCopy];
    if (addressBook.count == 0) {
        addressBook = [self uploadAddress];
        if (addressBook.count == 0) {
            _isContacts = 2;
            [self updateLoading];
            return;
        }
    }else {
        [addressBook removeAllObjects];
        addressBook =  [self uploadAddress];
    }
    NSArray *package = [self deleteduplicateWith:addressBook];
    package = [self saveAddressBook:package];
    if (package != nil && package.count>0) {
        NSString *jsonString = [[NetworkSingleton sharedManager] DataTOjsonString:package];
        __weak __typeof(self)weakSelf = self;
        [self.request updateContactsWithDictionary:@{@"data":jsonString,@"type":@"3"} success:^(NSDictionary *dictResult) {
            _isContacts = 1;
            
            printf("通讯录上传成功");
            JQFMDB *db = [JQFMDB shareDatabase:@"ContactsBook.sqlite"];
            for (NSDictionary *tDict in package) {
                NSString *phoneStr = tDict[@"mobile"];
                [db jq_insertTable:@"contacts" dicOrModel:@{@"name":tDict[@"name"],@"user_id":tDict[@"user_id"]}];
                NSString *whereStr = [NSString stringWithFormat:@"where name = '%@'",tDict[@"name"]];
                [db jq_updateTable:@"contacts" dicOrModel:@{@"mobile":phoneStr} whereFormat:whereStr];
            }
            [weakSelf updateLoading];
        } failed:^(NSInteger code, NSString *errorMsg) {
            printf("通讯录上传失败");
            _isContacts = 1;
            [weakSelf updateLoading];
        }];
    }else{
        _isContacts = 1;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateLoading];
        });
    }
}

///获取数据库通讯录
-(NSMutableArray *)saveAddressBook:(NSArray *)addressBook{
    NSString *tableName = [NSString stringWithFormat:@"contacts"];
    JQFMDB *db = [JQFMDB shareDatabase:@"ContactsBook.sqlite"];
    [db jq_createTable:tableName dicOrModel:@{@"name":@"TEXT",@"user_id":@"TEXT",@"mobile":@"TEXT"}];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *selectStr = [NSString stringWithFormat:@"where user_id = '%@'",[UserManager sharedUserManager].userInfo.uid];
    NSMutableArray *personArr = [[db jq_lookupTable:tableName dicOrModel:@{@"name":@"TEXT",@"user_id":@"TEXT",@"mobile":@"TEXT"} whereFormat:selectStr] mutableCopy];
    
    if (![personArr isEqualToArray:addressBook]) {
        //数据库中多余的
        for (NSDictionary *tDict in personArr) {
            if (![addressBook containsObject:tDict]) {
                NSString *whereStr = [NSString stringWithFormat:@"where name = '%@' AND user_id = '%@'",tDict[@"name"],tDict[@"user_id"]];
                [db jq_deleteTable:tableName whereFormat:whereStr];
            }
        }
        personArr = [[db jq_lookupTable:tableName dicOrModel:@{@"name":@"TEXT",@"user_id":@"TEXT",@"mobile":@"TEXT"} whereFormat:nil] mutableCopy];
        
        
        if (![personArr isEqualToArray:addressBook]) {
            for (NSDictionary * tDict in addressBook){
                if (![personArr containsObject:tDict]) {
                    [array addObject:tDict];
                }
            }
        }
        return array;
    }else{
        return nil;
    }
}

//去重
- (NSMutableArray *)deleteduplicateWith:(NSMutableArray *)addressBook {
    NSMutableArray * contact = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrContent = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * tDict in addressBook.lastObject) {
        if (![contact containsObject:tDict[@"mobile"]]) {
            [contact addObject:tDict[@"mobile"]];
            [arrContent addObject:tDict];
        }
    }
    return arrContent;
}

-(NSMutableArray *)uploadAddress {
    NSMutableArray *addressBook;
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray * titleArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrData = [NSMutableArray arrayWithCapacity:0];
    if ([[GetContactsBook shareControl]getPersonInfo]&&[[GetContactsBook shareControl] sortMethod]) {
        dataDic = [[GetContactsBook shareControl]getPersonInfo];
        titleArr = [[[GetContactsBook shareControl]sortMethod] mutableCopy];
        arrData = [NSMutableArray arrayWithCapacity:0];
        
        [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *indexString = obj;
            NSInteger index = idx;
            [arrData addObject:[@[] mutableCopy]];
            NSArray *tempArr = dataDic[indexString];
            [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrData[index] addObject:obj];
            }];
        }];
    }
    if (arrData.count>0) {
        NSMutableArray *packageArray = [@[] mutableCopy];
        [packageArray addObject:[@[] mutableCopy]];
        __weak __typeof(self)weskSelf = self;
        [arrData enumerateObjectsUsingBlock:^(NSArray  *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj1 enumerateObjectsUsingBlock:^(NSDictionary *obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                [[packageArray lastObject] addObject:[NSDictionary dictionaryWithObjects:@[obj2[@"name"],[weskSelf phoneNumClear:obj2[@"mobile"]],[UserManager sharedUserManager].userInfo.uid] forKeys:@[@"name",@"mobile",@"user_id"]]];
            }];
        }];
        [UserDefaults setObject:packageArray forKey:@"contacts"];
        addressBook = packageArray;
    }
    return addressBook;
}

- (BOOL)checkInfo {
    NSString * alertContent = @"";
    if (!self.contactPersonArr.count) {
        return NO;
    }
    if ([self.contactPersonArr[0][0][@"subTitle"] isEqualToString:@"请选择"]) {
        alertContent = @"请选择与直属亲属联系人关系！";
    }else if ([self.contactPersonArr[0][1][@"subTitle"] isEqualToString:@"请选择"]) {
        alertContent = @"请选择直属亲属紧急联系人！";
    }else if ([self.contactPersonArr[1][0][@"subTitle"]  isEqualToString:@"请选择"]) {
        alertContent = @"请选择与其他联系人关系！";
    }else if ([self.contactPersonArr[1][1][@"subTitle"] isEqualToString:@"请选择"]) {
        alertContent = @"请选择其他联系人！";
    }
    if ([alertContent isEqualToString:@""]) {
        return YES;
    }else {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:alertContent leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return NO;
    }
}

#pragma mark - Delegate
#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactPersonArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactPersonArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        SelectionCell * cell = [[SelectionCell alloc] initWithTitle:self.contactPersonArr[indexPath.section][indexPath.row][@"title"] subTitle:self.contactPersonArr[indexPath.section][indexPath.row][@"subTitle"]];
        [cell setSubTitleTextAlignment:NSTextAlignmentRight];
        return cell;
    }
    PickerCell * cell = [[PickerCell alloc] initWithTitle:self.contactPersonArr[indexPath.section][indexPath.row][@"title"] subTitle:@"" selectDes:self.contactPersonArr[indexPath.section][indexPath.row][@"subTitle"]];
    @Weak(self)
    cell.numberOfRow = ^NSInteger(){
        @Strong(self)
        return indexPath.section ? self.model.other_list.count : self.model.lineal_list.count;
    };
    cell.stringOfRow = ^(NSInteger row){
        @Strong(self)
        return indexPath.section ? [self.model.other_list[row] name] : [self.model.lineal_list[row] name];
    };
    cell.didSelectBlock = ^(NSInteger row) {
        @Strong(self)
        [self reloadCellWithIndexPath:indexPath withRow:row];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        SelectContactsVC * vc = [[SelectContactsVC alloc] init];
        
        __weak __typeof(self)weakSelf = self;
        [GetContactsBook CheckAddressBookAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {
                vc.selectBlock = ^(SelectContactsModel * model) {
                    if (indexPath.section == 0) {
                        [weakSelf.dictParm setObject:model.name forKey:@"name"];
                        [weakSelf.dictParm setObject:model.phone forKey:@"mobile"];
                    }else {
                        [weakSelf.dictParm setObject:model.name forKey:@"name_spare"];
                        [weakSelf.dictParm setObject:model.phone forKey:@"mobile_spare"];
                    }
                    [weakSelf reploadNameCellWithIndexPath:indexPath withName:model.name];
                };
                [weakSelf dsPushViewController:vc animated:YES];
            }else {
                DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请检查是否在设置-隐私-通讯录授权给助力凭条" leftButtonTitle:nil rightButtonTitle:@"确定"];
                alert.rightBlock = ^{
                    [[ApplicationUtil sharedApplicationUtil] gotoSettings];
                };
                [alert show];
            }
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    [view addSubview:[self getLabelWithSection:section]];
    return view;
}

//更新与本人关系
- (void)reloadCellWithIndexPath:(NSIndexPath *)indexPath withRow:(NSInteger)row {
    indexPath.section == 0 ? [self.dictParm setObject:[self.model.lineal_list[row] type] forKey:@"type"] : [self.dictParm setObject:[self.model.other_list[row] type] forKey:@"relation_spare"];
    NSDictionary * dict = @{@"title":@"与本人关系",@"subTitle":indexPath.section ? [self.model.other_list[row] name] : [self.model.lineal_list[row] name]};
    NSMutableArray * arr = [_contactPersonArr[indexPath.section] mutableCopy];
    [arr replaceObjectAtIndex:indexPath.row withObject:dict];
    [_contactPersonArr replaceObjectAtIndex:indexPath.section withObject:arr];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

//更新紧急联系人
- (void)reploadNameCellWithIndexPath:(NSIndexPath *)indexPath withName:(NSString *)name {
    NSDictionary * dict = @{@"title":@"紧急联系人",@"subTitle":name};
    NSMutableArray * arr = [_contactPersonArr[indexPath.section] mutableCopy];
    [arr replaceObjectAtIndex:indexPath.row withObject:dict];
    [_contactPersonArr replaceObjectAtIndex:indexPath.section withObject:arr];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 请求数据
- (void)getDataSource {
    [self showLoading:@""];
    __weak __typeof(self)weakSelf = self;
    [self.request getContactsListWithDictionary:nil success:^(NSDictionary *dictResult) {
        [weakSelf hideLoading];
        weakSelf.model = [ContactsModel contactsWithDict:dictResult[@"item"]];
        [weakSelf configDataWithModel];
        [weakSelf.tableView reloadData];
    } failed:^(NSInteger code, NSString *errorMsg) {
        [weakSelf showMessage:errorMsg];
        [weakSelf hideLoading];
    }];
}

- (void)configDataWithModel {
    NSInteger linealStatus = [self.model.lineal_relation integerValue];
    NSInteger otherStatus = [self.model.other_relation integerValue];
    _contactPersonArr = [NSMutableArray arrayWithArray:@[@[@{@"title":@"与本人关系",@"subTitle":linealStatus >= 1 ? [self.model.lineal_list[linealStatus - 1] name] : @"请选择"},
                                                           @{@"title":@"紧急联系人",@"subTitle":linealStatus >= 1 ? self.model.lineal_name : @"请选择"}],
                                                         @[@{@"title":@"与本人关系",@"subTitle":otherStatus >= 1 ? [self.model.other_list[otherStatus - 1] name] : @"请选择"},
                                                           @{@"title":@"紧急联系人",@"subTitle":otherStatus >= 1 ? self.model.other_name : @"请选择"}]]];
    [self.dictParm setObject:self.model.lineal_name ? : @"" forKey:@"name"];
    [self.dictParm setObject:self.model.lineal_mobile ? : @"" forKey:@"mobile"];
    [self.dictParm setObject:self.model.lineal_relation ? : @"" forKey:@"type"];
    [self.dictParm setObject:self.model.other_name ? : @"" forKey:@"name_spare"];
    [self.dictParm setObject:self.model.other_mobile ? : @"" forKey:@"mobile_spare"];
    [self.dictParm setObject:self.model.other_relation ? : @"" forKey:@"relation_spare"];
}

#pragma mark - Other
- (void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.tableView.translatesAutoresizingMaskIntoConstraints) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = Color_Background;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = Color_LineColor;
        //        _tableView.sectionFooterHeight = 0;
        
        UIView *view = [[UIView alloc] init];
        [view addSubview:self.encryptionView];
        _tableView.tableFooterView = view;
        
        [self.encryptionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.top.equalTo(view.mas_top).with.offset(10);
            make.right.equalTo(view.mas_right);
            make.height.equalTo(@40);
        }];
    }
    return _tableView;
}

- (BankDataEncryptionView *)encryptionView {
    
    if (!_encryptionView) {
        _encryptionView = [BankDataEncryptionView bankDataEncryptionView];
    }
    return _encryptionView;
}

- (NSMutableArray *)contactPersonArr {
    if (!_contactPersonArr) {
        _contactPersonArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _contactPersonArr;
}

- (CertificationCenterRequest *)request {
    if (!_request) {
        _request = [[CertificationCenterRequest alloc] init];
    }
    return _request;
}

- (NSMutableDictionary *)dictParm {
    if (!_dictParm) {
        _dictParm = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dictParm;
}

- (UILabel *)getLabelWithSection:(NSInteger)section {
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 45)];
    lbl.text = section ? @"其他联系人" : @"直属亲属联系人";
    lbl.textColor = Color_Title;
    lbl.font = Font_SubTitle;
    return lbl;
}

//过滤手机号
- (NSString *)phoneNumClear:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
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

