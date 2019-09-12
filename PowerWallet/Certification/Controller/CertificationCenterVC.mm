//
//  CertificationCenterVC.m
//  KDFDApp
//
//  Created by haoran on 16/9/19.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import "CertificationCenterVC.h"

#import "PersonalInformationVC.h"
#import "EmergencyContactVC.h"

#import "VerifyListCell.h"
#import "BankDataEncryptionView.h"
#import "CertificationCenterRequest.h"
#import "CommonWebVC.h"
#import "GDLocationManager.h"
#import "WorkInfoVC.h"
#import "EmergencyContactVC.h"

#import "VerifyListBottomView.h"
#import "VerifyRequiredCell.h"
#import "UserManager.h"
#import "APPList.h"
#import "BaseVerifyListCell.h"

#define Verify_Cell_Height 65

@interface CertificationCenterVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (strong, nonatomic) BaseVerifyListCell *baseVerifyCell;
@property (strong, nonatomic) VerifyListBottomView *bottomView;

@property (nonatomic, retain) CertificationCenterRequest *listNetworkAccess;
///备选项、选填项
@property (nonatomic, retain) NSArray<VerifyListModel *> *alternativeArray;
///必填项
@property (strong, nonatomic) NSArray<VerifyListModel *> *requiredArray;
@end

@implementation CertificationCenterVC

#pragma mark - Lify Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self umengEvent:@"Ver" attributes:nil number:@10];
    [self baseSetup:PageGobackTypePop];
    self.navigationItem.title = @"认证中心";
    if (self.isHidenBottomView) {
        self.navigationItem.title = @"确认资料";
    }
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.tableView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.requiredArray.count) {
//        return kPointToTheTop == self.bottomView.direction ? self.requiredArray.count+1 : self.requiredArray.count;
//    } else {
//        return 0;
//    }
    if (self.baseVerifyCell.dataArray.count) {
        return kPointToTheTop == self.bottomView.direction ? 2 : 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 == section ? 1 : self.alternativeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else{
        return 30;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30)];
        label.backgroundColor = Color_Background;
        label.font = FontSystem(13);
        label.textColor = [UIColor colorWithHex:0x9F9F9F];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = 0 == section ? @"认证越多，信用额度就越高哦" : @"加分认证有助于获得更高的额度哦";
        return label;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        return self.baseVerifyCell;
    } else {
        VerifyListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VerifyListCell class]) forIndexPath:indexPath];
        
        [cell configureVerifyListCellWithModel:self.alternativeArray[indexPath.row]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    if (1 == indexPath.section) {
        [self intoNextViewController:self.alternativeArray[indexPath.row]];
    }
}

#pragma mark - Private
- (void)loadData {
    [super loadData];
    self.vNoNet.hidden = YES;
    [self.listNetworkAccess fetchUserVerifyListWithDictionary:nil success:^(NSDictionary *dictResult) {

        [self.tableView.mj_header endRefreshing];
        self.baseVerifyCell.progress = [dictResult[@"item"][@"mustBeCount"] integerValue]/100.0;
        self.baseVerifyCell.dataArray = [self createModelData:dictResult[@"item"][@"isMustBeList"]];
        self.alternativeArray = [self createModelData:dictResult[@"item"][@"noMustBeList"]];
//        self.realName = [dictResult[@"item"][@"real_verify_status"] integerValue];
//        self.contactsStatus = [dictResult[@"item"][@"contacts_status"] integerValue];
        
        [self.tableView reloadData];
        self.tableView.tableFooterView.hidden = NO;
    
    } failed:^(NSInteger code, NSString *errorMsg) {
        
        [self.tableView.mj_header endRefreshing];
        if (code == -2) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"您的登录态已失效，请重新登录" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                
                [[UserManager sharedUserManager] checkLogin:self];
            };
            [alert show];
        }else{
            [self.view bringSubviewToFront:self.vNoNet];
            self.vNoNet.hidden = NO;
        }
    }];
}
- (NSArray *)createModelData:(NSArray *)aArr {
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSInteger  i = 0; i < [aArr count]; ++i) {
        
        [result addObject:[VerifyListModel verifyListModelWithDictionary:aArr[i]]];
    }
    
    return result;
}
- (void)intoNextViewController:(VerifyListModel *)model {
    
    //tag=1 个人信息 tag=2 工作信息 tag=3 紧急联系人 tag=4收款信息 tag=5 手机运营商 tag=6 卡片等级 tag＝7 更多信息 tag=8 芝麻授信
    switch ((model.tag).integerValue) {
        case 1: {
            [self umengEvent:@"Ver_PersonInfo" attributes:nil number:@10];
            if ([GDLocationManager shareInstance].isOpenLocationServices == YES) {
                [self.navigationController pushViewController:[[PersonalInformationVC alloc] init] animated:YES];
            } else {
                DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请先打开您的定位权限！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                alert.rightBlock = ^{
                    [[ApplicationUtil sharedApplicationUtil] gotoSettings];
                };
                [alert show];
            }
        } break;
        case 2: {
            [self umengEvent:@"Ver_WorkInfo" attributes:nil number:@10];
            if ([GDLocationManager shareInstance].isOpenLocationServices == YES) {
                WorkInfoVC *workInfoVC = [[WorkInfoVC alloc] init];
                [self dsPushViewController:workInfoVC animated:YES];
            } else {
                DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请先打开您的定位权限！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                alert.rightBlock = ^{
                    [[ApplicationUtil sharedApplicationUtil] gotoSettings];
                };
                [alert show];
            }
        } break;
        case 3:{
            [self umengEvent:@"Ver_Contacts" attributes:nil number:@10];
            [self dsPushViewController:[[EmergencyContactVC alloc] init] animated:YES];
        } break;
        case 4:{
        }break;
        case 5: {
            [self umengEvent:@"Ver_mobile" attributes:nil number:@10];
            CommonWebVC *vc = [[CommonWebVC alloc]init];
            if (1 == model.status.integerValue) {
                vc.strAbsoluteUrl = [NSString stringWithFormat:@"%@?recode=2",model.url];
            }else{
                vc.strAbsoluteUrl = model.url;
            }
            [self dsPushViewController:vc animated:YES];
        } break;
        case 7: {
            [self umengEvent:@"Ver_Other" attributes:nil number:@10];
            CommonWebVC * vc = [[CommonWebVC alloc] init];
            vc.strAbsoluteUrl = model.url;
            [self dsPushViewController:vc animated:YES];
        } break;
        case 9: {
            [self umengEvent:@"Ver_Zfb" attributes:nil number:@10];
            CommonWebVC * vc = [[CommonWebVC alloc] init];
            vc.strAbsoluteUrl = model.url;
            vc.strType = @"ZFB";
            [self dsPushViewController:vc animated:YES];
        } break;
        default: { // 7、8
            [self umengEvent:@"Ver_ZM" attributes:nil number:@10];
            CommonWebVC * vc = [[CommonWebVC alloc] init];
            vc.strAbsoluteUrl = model.url;
            [self dsPushViewController:vc animated:YES];
        } break;
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        [_tableView registerClass:[VerifyListCell class] forCellReuseIdentifier:NSStringFromClass([VerifyListCell class]) ];
        [_tableView registerClass:[VerifyRequiredCell class] forCellReuseIdentifier:NSStringFromClass([VerifyRequiredCell class])];
        _tableView.backgroundColor = Color_Background;
        _tableView.separatorColor = Color_LineColor;
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 65.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _tableView.tableFooterView = self.bottomView;
        
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableView;
}

- (BaseVerifyListCell *)baseVerifyCell {
    
    if (!_baseVerifyCell) {
        _baseVerifyCell = [[BaseVerifyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([BaseVerifyListCell class])];
        
        @Weak(self)
        _baseVerifyCell.selectedIndex = ^(VerifyListModel *preModel, VerifyListModel *model) {
            @Strong(self)
            //tag=1 个人信息 tag=2 工作信息 tag=3 紧急联系人 tag=4收款信息 tag=5 手机运营商 tag=6 卡片等级 tag＝7 更多信息 tag=8 芝麻授信
            if (preModel && !preModel.status.boolValue) {
                [[[DXAlertView alloc] initWithTitle:nil contentText:[NSString stringWithFormat:@"请先完善%@", preModel.title] leftButtonTitle:nil rightButtonTitle:@"确定"] show];
            } else {
                [self intoNextViewController:model];
            }
        };
    }
    return _baseVerifyCell;
}

- (CertificationCenterRequest *)listNetworkAccess {
    
    if (!_listNetworkAccess) {
        _listNetworkAccess = [[CertificationCenterRequest alloc] init];
    }
    return _listNetworkAccess;
}
- (VerifyListBottomView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [VerifyListBottomView verifyListBottomView];
        _bottomView.hidden = YES;
        
        @Weak(self)
        _bottomView.directionButtonClicked = ^(kPointToThe currentDirection) {
            @Strong(self)
            
            if (kPointToTheTop == currentDirection) {
                [self umengEvent:@"Ver_Less" attributes:nil number:@10];
                self.bottomView.direction = kPointToTheBottom;
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
            } else {
                [self umengEvent:@"Ver_More" attributes:nil number:@10];
                self.bottomView.direction = kPointToTheTop;
                [self.tableView reloadData];
            }
        };
    }
    return _bottomView;
}
//***************************************no use**************************************************
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
