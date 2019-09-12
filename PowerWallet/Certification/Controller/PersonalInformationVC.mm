//
//  PersonalInformationVC.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/15.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "PersonalInformationVC.h"

#import <MGLivenessDetection/MGLivenessDetection.h>
#import <MGIDCard/MGIDCard.h>

#import "GDLocationVC.h"

#import "UserManager.h"

#import "IdentifyFaceIDCell.h"
#import "InputCell.h"
#import "SelectionCell.h"
#import "PickerCell.h"

#import "CertificationCenterRequest.h"

#import "KDKeyboardView.h"
#import "NSObject+InitWithDictionary.h"
#import "PersonalInformationModel.h"

#import "PictureBrowser.h"

#import "BankDataEncryptionView.h"
#import "GDLocationManager.h"

typedef NS_ENUM(NSInteger, kFaceVerifyType) {
    
    kFaceVerifyFace = 10,
    kFaceVerifyCardFront = 11,
    kFaceVerifyCardBack = 12
};

@interface PersonalInformationVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *navBtn;
///验证状态
@property (assign, nonatomic) NSInteger verifyState;
@property (strong, nonatomic) PersonalInformationModel *personModel;
/**
 源数据
 */
@property (strong, nonatomic) NSDictionary *sourceDic; /**< 原来的信息，用以区分信息是否修改 */
@property (assign, nonatomic) BOOL isUploadImage; /**< 是否上传过照片 */

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CertificationCenterRequest *networkAccess;
///人脸识别
@property (strong, nonatomic) IdentifyFaceIDCell *faceCell;
///身份证识别
@property (strong, nonatomic) IdentifyFaceIDCell *idCardCell;
///真实姓名
@property (strong, nonatomic) InputCell *realNameCell;
///身份证号
@property (strong, nonatomic) InputCell *idNumberCell;
///选择当前位置
@property (strong, nonatomic) SelectionCell *selectAddressCell;
///详细位置
@property (strong, nonatomic) InputCell *detailAddressCell;

///学历
@property (strong, nonatomic) PickerCell *educationCell;
///学历列表
@property (strong, nonatomic) NSArray *educationList;
///婚姻状态
@property (strong, nonatomic) PickerCell *maritalStatusCell;
@property (strong, nonatomic) NSArray *maritalList;
///居住时长
@property (strong, nonatomic) PickerCell *lengthOfStayCell;
@property (strong, nonatomic) NSArray *liveList;

//error info
@property (strong, nonatomic) NSArray<NSString *> *faceError;

@property (strong, nonatomic) BankDataEncryptionView *encryptionView;

@end

@implementation PersonalInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isUploadImage = NO;
    [self baseSetup:PageGobackTypePop];
    self.title = @"个人信息";
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
    
    [self loadData];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.tableView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }
}

- (void)popVC {//覆盖父类方法
    
    if (self.isUploadImage || [self infoDidChange]) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:@"有修改尚未保存，您确定退出" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personModel ? 9 : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return self.faceCell;
        case 1:
            return self.idCardCell;
        case 2:
            return self.realNameCell;
        case 3:
            return self.idNumberCell;
        case 4:
            return self.educationCell;
        case 5:
            return self.selectAddressCell;
        case 6:
            return self.detailAddressCell;
        case 7:
            return self.maritalStatusCell;
        case 8:
            return self.lengthOfStayCell;
            
        default:
            return [UITableViewCell new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (0 == indexPath.row || 1 == indexPath.row) ? 80 : 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (5 == indexPath.row) {
        GDLocationVC *vc = [[GDLocationVC alloc]init];
        [[GDLocationManager shareInstance]startLocation];
        vc.address = ^(AMapPOI * model, MAUserLocation* Usermodel){

            self.personModel.latitude = [NSNumber numberWithFloat: model.location.latitude];
            self.personModel.longitude = [NSNumber numberWithFloat: model.location.longitude];
            self.personModel.address_distinct = model.name;
            [self.selectAddressCell setSubTitleValue:model.name];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSString *)nameOfValue:(NSInteger)value array:(NSArray*)aArr keyInDictionary:(NSString *)key {
    NSString *result = @"选择";
    
    for (NSInteger i = 0; i < aArr.count; ++i) {
        if ([key isEqualToString:@"degrees"]) {
            DegreesModel *degrees = aArr[i];
            if (degrees.degrees.integerValue == value) {
                result = degrees.name;
                break;
            }
        }else if([key isEqualToString:@"marriage"]){
            MarriageModel *degrees = aArr[i];
            if (degrees.marriage.integerValue == value) {
                result = degrees.name;
                break;
            }
        }else{
            LiveTimeTypeModel *degrees = aArr[i];
            if (degrees.live_time_type.integerValue == value) {
                result = degrees.name;
                break;
            }
        }
    }
    return result;
}

#pragma mark - Private
- (void)loadData {
    
    [self showLoading:@""];
    [self.networkAccess fetchPersonalInformationWithDictionary:@{} success:^(NSDictionary *dictResult) {
        
        [self hideLoading];
        [self setPersonDic:dictResult[@"item"]];

    } failed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}
-(void)setPersonDic:(NSDictionary *)personalDic{
//    _personalDic = personalDic;
    
    self.personModel = [PersonalInformationModel personalInfoWithDict:personalDic];
    
    self.verifyState = [self.personModel.real_verify_status integerValue];
//    [personalDic[@"real_verify_status"] integerValue];
    
    self.sourceDic = [self getDictionaryData:self.personModel];
    
#define RemoveEmptyWithDefaultValue(value, default) 0 != [value length] ? (value) : (default)
    self.faceCell.images = @[RemoveEmptyWithDefaultValue(self.personModel.face_recognition_picture, @"face")];
    self.idCardCell.images = @[ RemoveEmptyWithDefaultValue(self.personModel.id_number_z_picture, @"card_front"), RemoveEmptyWithDefaultValue(self.personModel.id_number_f_picture,  @"card_back")];
    
    self.realNameCell.inputValue = self.personModel.name;
    self.idNumberCell.inputValue = self.personModel.id_number;
    [self.selectAddressCell setSubTitleValue:self.personModel.address_distinct];
    (self.detailAddressCell).inputValue = self.personModel.address;
    
    self.educationList = self.personModel.degrees_all;
    self.educationCell.selectDes = [self nameOfValue:(self.personModel.degrees).intValue array:self.educationList keyInDictionary:@"degrees"];
    [self.educationCell reloadPickerView];
    self.maritalList = self.personModel.marriage_all;
    self.maritalStatusCell.selectDes = [self nameOfValue:(self.personModel.marriage).intValue array:self.maritalList keyInDictionary:@"marriage"];
    [self.maritalStatusCell reloadPickerView];
    self.liveList = self.personModel.live_time_type_all;
    self.lengthOfStayCell.selectDes = [self nameOfValue:(self.personModel.live_time_type).intValue array:self.liveList keyInDictionary:@"live_time_type"];
    [self.lengthOfStayCell reloadPickerView];
    
    [self.tableView reloadData];
    self.tableView.tableHeaderView.hidden = NO;
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = self.navBtn;
    }
}
-(void)setVerifyState:(NSInteger)verifyState {
    _verifyState = verifyState;
    
    self.realNameCell.userInteractionEnabled = 1 != verifyState;
    self.idNumberCell.userInteractionEnabled = 1 != verifyState;
}
- (void)saveData {
    
    [self refreshPersonModel];
    if ([self.personModel informationIsComplete]) {
        
        [self showLoading:@""];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.networkAccess savePersonmalInfoWithSuburl:self.verifyState ? kCreditInfoSavePersonInfo : kCreditCardSavePersonInfo dictionary:[self getDictionaryData:self.personModel] success:^(NSDictionary *dictResult) {
            [self hideLoading];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            [UserManager sharedUserManager].userInfo.realname = self.personModel.name;
            self.verifyState = YES;
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:dictResult[@"message"] leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [alert show];
        } failed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self showMessage:errorMsg];
        }];
    } else {
        [[[DXAlertView alloc]initWithTitle:nil contentText:[self.personModel lackOfInformationDescription] leftButtonTitle:nil rightButtonTitle:@"确定"] show];
    }
}
- (void)refreshPersonModel {
    
    self.personModel.name = self.realNameCell.inputValue;
    self.personModel.id_number = self.idNumberCell.inputValue;
    self.personModel.address = self.detailAddressCell.inputValue;

}
- (BOOL)infoDidChange {
    
    [self refreshPersonModel];
    
    return ![self.sourceDic isEqual:[self getDictionaryData:self.personModel]];
}

- (void)startFaceVerify:(kFaceVerifyType)type {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted) {
                if (![MGLiveManager getLicense]) {
                    return;
                }
                //判断是否打开权限
                if (![self isOpenCamera]) {
                    //无权限 做一个友好的提示
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请您设置允许助力凭条访问您的相机\n设置>隐私>相机！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                        [[ApplicationUtil sharedApplicationUtil] gotoSettings];
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    
                    if (kFaceVerifyFace == type) {
                        [self verifyFace];
                    } else {
                        [self verifyCard:type];
                    }
                }
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请您设置允许助力凭条访问您的相机\n设置>隐私>相机！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                    [[ApplicationUtil sharedApplicationUtil] gotoSettings];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                //用户拒绝
                return;
            }
        }];
        
    }else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请您设置允许助力凭条访问您的相机\n设置>隐私>相机！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [[ApplicationUtil sharedApplicationUtil] gotoSettings];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else{
        if (![MGLiveManager getLicense]) {
            return;
        }
        //判断是否打开权限
        if (![self isOpenCamera]) {
            //无权限 做一个友好的提示
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请您设置允许助力凭条访问您的相机\n设置>隐私>相机！" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [[ApplicationUtil sharedApplicationUtil] gotoSettings];
            };
            [alert show];
        } else {
            if (kFaceVerifyFace == type) {
                [self verifyFace];
            } else {
                [self verifyCard:type];
            }
        }
    }
}

- (BOOL)isOpenCamera {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
}
- (void)showButtonImageWithButton:(UIButton *)button {
    
    button.hidden = YES;
    [PictureBrowser showImage:button.imageView.image originFrame:[button.superview convertRect:button.frame toView:[UIApplication sharedApplication].keyWindow] complete:^{
        button.hidden = NO;
    }];
}
#pragma mark -  人脸识别
- (void)verifyFace {
    
    MGLiveManager *manager = [[MGLiveManager alloc] init];
    manager.detectionWithMovier = NO;
    manager.actionCount = 3;
    
    [manager startFaceDecetionViewController:self finish:^(FaceIDData *finishDic, UIViewController *viewController) {
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
        NSData *data = [finishDic.images valueForKey:@"image_best"];
        [self uploadImageWithData:data type:kFaceVerifyFace success:^(NSDictionary *dictResult, UIImage *image) {
            self.faceCell.images = @[image];
        }];
    } error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
        NSString * str = (self.faceError.count - errorType < 1) ? @"检测失败，请重试" : self.faceError[errorType];
    
        [[[DXAlertView alloc] initWithTitle:nil contentText:str leftButtonTitle:nil rightButtonTitle:@"确定"] show];
    }];

}
#pragma mark - 身份证识别
- (void)verifyCard:(kFaceVerifyType)type {
    
    [[[MGIDCardManager alloc] init] IDCardStartDetection:self IdCardSide: kFaceVerifyCardFront == type ? IDCARD_SIDE_FRONT :IDCARD_SIDE_BACK finish:^(MGIDCardModel *model) {
        
        NSData *data = UIImagePNGRepresentation([model croppedImageOfIDCard]) ? : UIImageJPEGRepresentation([model croppedImageOfIDCard], 0.5);
        [self uploadImageWithData:data type:type success:^(NSDictionary *dictResult, UIImage *image) {
            if (type == kFaceVerifyCardFront) {
                
                (self.realNameCell).inputValue = dictResult[@"name"];
                (self.idNumberCell).inputValue = dictResult[@"id_card_number"];
                self.idCardCell.images = @[image, self.idCardCell.images[1]];
            } else {
                self.idCardCell.images = @[self.idCardCell.images[0], image];
            }
        }];
    } errr:nil];
}

- (void)uploadImageWithData:(NSData *)imageData type:(kFaceVerifyType)type success:( void(^)(NSDictionary *dictResult, UIImage *image) ) successBlock {
    
    [self showLoading:@""];
    [self.networkAccess uploadFaceVerifyImageWithDictionary:@{@"type":@(type)} imageData:imageData fileName:@"imageFile.jpg" key:@"attach" success:^(NSDictionary *dictResult) {
        [self hideLoading];
        
        self.isUploadImage = YES;
        if (successBlock) {
            successBlock(dictResult, [UIImage imageWithData:imageData]);
        }
    } failed:^(NSInteger code, NSString *errorMsg) {
        
        [self hideLoading];
        [self showMessage:errorMsg];
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
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.backgroundColor = Color_Background;
        _tableView.separatorColor = Color_LineColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        header.text = @"    身份认证信息保存后将无法修改，请务必保证正确";
        header.font = Font_SubTitle;
        header.textColor = Color_Title;
        _tableView.tableHeaderView = header;
        _tableView.tableHeaderView.hidden = YES;
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

- (CertificationCenterRequest *)networkAccess {
    
    if (!_networkAccess) {
        _networkAccess = [[CertificationCenterRequest alloc] init];
    }
    return _networkAccess;
}
- (IdentifyFaceIDCell *)faceCell {
    
    if (!_faceCell) {
        _faceCell = [[IdentifyFaceIDCell alloc] initWithTitle:@"人脸识别"];
        
        _faceCell.images = @[@"face"];
        
        @Weak(self)
        _faceCell.clickImageBlock = ^(NSInteger index, BOOL defaultImage, UIButton *imageButton){
            @Strong(self)
            
            if (self.verifyState) {
                [self showButtonImageWithButton:imageButton];
            } else {
                if (!defaultImage) {
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *identify = [UIAlertAction actionWithTitle:@"动态人脸识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
                        [self startFaceVerify:kFaceVerifyFace];
                    }];
                    UIAlertAction *switchUsers = [UIAlertAction actionWithTitle:@"查看大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
                        [self showButtonImageWithButton:imageButton];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
                    }];
                    [cancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
                    [alertVc addAction:identify];
                    [alertVc addAction:switchUsers];
                    [alertVc addAction:cancel];
                    [self presentViewController:alertVc animated:YES completion:nil];
                } else {
                    [self startFaceVerify:kFaceVerifyFace];
                }
            }
        };
    }
    return _faceCell;
}
- (IdentifyFaceIDCell *)idCardCell {
    
    if (!_idCardCell) {
        _idCardCell = [[IdentifyFaceIDCell alloc] initWithTitle:@"身份证识别"];
        
        _idCardCell.images = @[@"card_front", @"card_back"];
        
        @Weak(self)
        _idCardCell.clickImageBlock = ^(NSInteger index, BOOL defaultImage, UIButton *imageButton){
            @Strong(self)
            
            if (self.verifyState) {
                [self showButtonImageWithButton:imageButton];
            } else {
                if (!defaultImage) {
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *identify = [UIAlertAction actionWithTitle:0 == index ? @"身份证正面识别" : @"身份证反面识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
                        [self startFaceVerify:kFaceVerifyFace];
                    }];
                    UIAlertAction *switchUsers = [UIAlertAction actionWithTitle:@"查看大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
                        [self showButtonImageWithButton:imageButton];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
                    }];
                    [cancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
                    [alertVc addAction:identify];
                    [alertVc addAction:switchUsers];
                    [alertVc addAction:cancel];
                    [self presentViewController:alertVc animated:YES completion:nil];
                } else {
                    [self startFaceVerify:0 == index ? kFaceVerifyCardFront : kFaceVerifyCardBack];
                }
            }
        };
    }
    return _idCardCell;
}
- (SelectionCell *)selectAddressCell {
    
    if (!_selectAddressCell) {
        _selectAddressCell = [[SelectionCell alloc] initWithTitle:@"现居地址" subTitle:@""];
    }
    return _selectAddressCell;
}
- (PickerCell *)educationCell {
    
    if (!_educationCell) {
        _educationCell = [[PickerCell alloc] initWithTitle:@"学历" subTitle:@"" selectDes:@"选择"];
        
        @Weak(self)
        _educationCell.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.educationList.count;
        };
        _educationCell.stringOfRow = ^(NSInteger row){
            @Strong(self)
            DegreesModel *model = self.educationList[row];
            return model.name;
        };
        _educationCell.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            DegreesModel *model = self.educationList[selectedRow];
            self.personModel.degrees =  [NSString stringWithFormat:@"%@",model.degrees];
            self.educationCell.selectDes = model.name;
        };
    }
    return _educationCell;
}
- (InputCell *)realNameCell {
    
    if (!_realNameCell) {
        _realNameCell = [[InputCell alloc] initWithTitle:@"姓名" placeholder:@"请输入真实姓名"];
    }
    return _realNameCell;
}
- (InputCell *)idNumberCell {
    
    if (!_idNumberCell) {
        _idNumberCell = [[InputCell alloc] initWithTitle:@"身份证" placeholder:@"请输入身份证号码"];
        
        [KDKeyboardView KDKeyBoardWithKdKeyBoard:KDIDNUM target:self textfield:_idNumberCell.inputTextField delegate:nil valueChanged:nil];
    }
    return _idNumberCell;
}
- (InputCell *)detailAddressCell {
    
    if (!_detailAddressCell) {
        _detailAddressCell = [[InputCell alloc] initWithTitle:@"" placeholder:@"请输入详细地址"];
    }
    return _detailAddressCell;
}
- (PickerCell *)maritalStatusCell {
    
    if (!_maritalStatusCell) {
        _maritalStatusCell = [[PickerCell alloc] initWithTitle:@"婚姻状态" subTitle:@"(选填)" selectDes:@"选择"];
        
        @Weak(self)
        _maritalStatusCell.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.maritalList.count;
        };
        _maritalStatusCell.stringOfRow = ^(NSInteger row){
            @Strong(self)
            MarriageModel *model = self.maritalList[row];
            return model.name;
        };
        _maritalStatusCell.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            MarriageModel *model = self.maritalList[selectedRow];
            self.personModel.marriage =  [NSString stringWithFormat:@"%@",model.marriage];
            self.maritalStatusCell.selectDes = model.name;
        };
    }
    return _maritalStatusCell;
}
- (PickerCell *)lengthOfStayCell {
    
    if (!_lengthOfStayCell) {
        _lengthOfStayCell = [[PickerCell alloc] initWithTitle:@"居住时长" subTitle:@"(选填)" selectDes:@"选择"];
        
        @Weak(self)
        _lengthOfStayCell.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.liveList.count;
        };
        _lengthOfStayCell.stringOfRow = ^(NSInteger row){
            @Strong(self)
            LiveTimeTypeModel *model = self.liveList[row];
            return model.name;
        };
        _lengthOfStayCell.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            LiveTimeTypeModel *model = self.liveList[selectedRow];
            self.personModel.live_time_type =  [NSString stringWithFormat:@"%@",model.live_time_type];
            self.lengthOfStayCell.selectDes = model.name;
        };
    }
    return _lengthOfStayCell;
}

#pragma mark - Error
- (NSArray<NSString *> *)faceError {
    
    if (!_faceError) {
        _faceError = @[@"动作错误,请重新操作!", @"未知错误!", @"操作超时!", @"未检测到面孔!", @"检测出多张面孔!", @"动作重复!", @"请摘下面具,再操作!"];
    }
    return _faceError;
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
