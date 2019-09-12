//
//  LogOutLendVC.m
//  PowerWallet
//
//  Created by 清阳 on 2018/1/15.
//  Copyright © 2018年 peijunjinrong. All rights reserved.
//

#import "LogOutLendVC.h"
#import "AboutViewCell.h"
#import "AscendingUpLoadEntity.h"
#import "CertificationCenterRequest.h"
#import "BorrowLendRequest.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "YLProgressBar.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImageView+WebCache.h"
#define KEYWINDOW       ([UIApplication sharedApplication].keyWindow)
@interface LogOutLendVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic, retain) UIImageView *bigImgView;
@property (nonatomic, retain) NSMutableArray *uploadArray;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic,copy)    NSString *filePath;
@property (nonatomic, retain) CertificationCenterRequest *networkAccess;
@property (nonatomic, retain) BorrowLendRequest *request;
@property (nonatomic, retain) AscendingUpLoadEntity *pageEntity;
@property (nonatomic, retain) UIButton *btn;
@property (nonatomic, assign) NSInteger uploadIma;
@property (nonatomic, assign) NSInteger logout_apply;
@property (nonatomic, copy)   NSString *imageUrl;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, retain) NSMutableArray *uploadIndexPathArray;
@property (assign, nonatomic) CGRect lastSelectedImgFrame;
@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic, strong) NSData   *imageData;
@end

@implementation LogOutLendVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetup:PageGobackTypePop];
    self.title = @"销借条";
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
    self.navigationItem.title = @"销借条";
    [self getPageData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)creatUI{
    [self setupTab];
}
- (void)setupTab{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 155)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = Color_White;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"AboutViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 160, SCREEN_WIDTH, 20)];
    label.text = @"还款凭证";
    label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label];
}
- (void)setUPBtn{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, 200, 160, 200)];
    _imageView.userInteractionEnabled = YES;
    if (_imageUrl.length == 0) {
         _imageView.image = [UIImage imageNamed:@"ascending_photo"];
    }else if (_imageUrl.length !=0 &&_filePath.length == 0){
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    }else if (_imageUrl.length !=0 &&_filePath.length != 0){
        _imageView.image = [UIImage imageWithContentsOfFile:_filePath];
    }
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    PrivateLetterTap.numberOfTouchesRequired = 1;
    PrivateLetterTap.numberOfTapsRequired = 1;
    PrivateLetterTap.delegate= self;
    [_imageView addGestureRecognizer:PrivateLetterTap];
    [self.view addSubview:_imageView];
    _uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-64*3, SCREEN_WIDTH-30, 44)];
    [_uploadBtn setTitleColor:Color_White forState:UIControlStateNormal];
    _uploadBtn.backgroundColor = Color_Red;
    _uploadBtn.layer.masksToBounds = YES;
    _uploadBtn.layer.cornerRadius = 5.0f;
    _uploadBtn.tag = 100;
    _uploadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (_uploadIma == 1) {
        [_uploadBtn setTitle:@"修改还款凭证图片" forState:UIControlStateNormal];
    }else{
        [_uploadBtn setTitle:@"上传还款凭证图片" forState:UIControlStateNormal];
    }
    [_uploadBtn addTarget:self action:@selector(uploadclick:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_uploadBtn];
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-64*2, SCREEN_WIDTH-30, 44)];
    [_btn setTitleColor:Color_White forState:UIControlStateNormal];
    _btn.backgroundColor = Color_Red;
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 5.0f;
    _btn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (_logout_apply == 0) {
          [_btn setTitle:@"申请销借条" forState:UIControlStateNormal];
    }else{
        [_btn setTitle:@"已发出销借条申请" forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
        _btn.userInteractionEnabled = NO;
    }
    [_btn addTarget:self action:@selector(btnclick)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
}
#pragma mark 事件
- (void)btnclick{
    if (_uploadIma == 0) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请先上传还款凭证相关图片" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }else{
        [self showLoading:@""];
        [self.request getLogOutListWithDict:@{@"orderNo":_orderNo} onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            [_btn setTitle:@"已发出销借条申请" forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
            _btn.userInteractionEnabled = NO;
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
    }
}
- (void)uploadclick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"上传还款凭证图片"]) {
        if (_filePath.length == 0) {
            [self performSelector:@selector(showAlert:) withObject:@"您暂未选择图片" afterDelay:0.5f];
            return;
        }
        [self showLoading:@""];
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,kPictureUploadImage];
        [[NetworkSingleton sharedManager]uploadImageWithURL:strUrl params:@{@"orderNo":_orderNo,@"type":@"13"} image:_imageData fileName:@"imageFile.png" key:@"attach" successBlock:^(id responseObject, NSInteger statusCode) {
            [self hideLoading];
            _uploadIma = 1;
            [self performSelector:@selector(showAlert:) withObject:@"上传成功" afterDelay:0.5f];
        } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
            [self performSelector:@selector(showAlert:) withObject:errorMsg afterDelay:0.5f];
        }];
    }else{
        if (_filePath.length == 0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
            [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionSheet showInView:self.view];
        }else{
            [self showLoading:@""];
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,kPictureUploadImage];
            [[NetworkSingleton sharedManager]uploadImageWithURL:strUrl params:@{@"orderNo":_orderNo,@"type":@"13"} image:_imageData fileName:@"imageFile.png" key:@"attach" successBlock:^(id responseObject, NSInteger statusCode) {
                [self hideLoading];
                [self performSelector:@selector(showAlert:) withObject:@"修改成功" afterDelay:0.5f];
            } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
                [self performSelector:@selector(showAlert:) withObject:errorMsg afterDelay:0.5f];
            }];
        }
    }
}
- (void)tapAvatarView:(UITapGestureRecognizer *)tap{
    if (_filePath.length == 0 && _imageUrl.length == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet showInView:self.view];
    } else  {
        //看大图
        [self showBigImg];
    }
}
#pragma mark tableview 代理
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 155;//预估值
    return _tableView.estimatedRowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    AboutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.jushouText.numberOfLines = 0;
    cell.jushouText.text  = @"销借条步骤:\n1、根据双方签订的借条，债务人将应还金额转入出借人银行卡\n2、债务人将打款凭证截图上传至系统\n3、债务人申请销借条\n4、出借人确认款项和凭证后销毁借条\n5、如有问题，请反馈给系统，居间平台会负责协调";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentLeft;
    NSAttributedString *text = [[NSAttributedString alloc]initWithString:cell.jushouText.text attributes:@{NSParagraphStyleAttributeName:style}];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jushouText.attributedText = text;
    return cell;
}
#pragma mark 数据
- (BorrowLendRequest *)request{
    if (!_request) {
        _request = [[BorrowLendRequest alloc]init];
    }
    return _request;
}
- (NSMutableArray *)uploadArray{
    if (!_uploadArray) {
        _uploadArray = [NSMutableArray new];
    }
    return _uploadArray;
}
- (void)getPageData{
    __weak typeof(self) weakSelf = self;
    [self showLoading:@""];
    [weakSelf.request inquiryRepayProcessWithDict:@{@"orderNo":_orderNo} onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
        _uploadIma = [dictResult[@"upload_img"] integerValue];
        _logout_apply = [dictResult[@"logout_apply"] integerValue];
        _imageUrl = dictResult[@"img_url"];
        [weakSelf setUPBtn];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        
    }];
}
#pragma mark---UIActionSheetDelegate
/* 选择器点击事件 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self showCamera];
    }
    else if (buttonIndex == 1){
        [self showPhoto];
    }
}
//显示大图
- (void)showBigImg{
    _lastSelectedImgFrame = [self.view convertRect:_imageView.frame toView:KEYWINDOW];
    if (!_bigImgView) {
        _bigImgView = [[UIImageView alloc] init];
        [KEYWINDOW addSubview:_bigImgView];
        _bigImgView.hidden = YES;
        _bigImgView.backgroundColor = [UIColor blackColor];
        _bigImgView.userInteractionEnabled = YES;
        _bigImgView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImg)];
        [_bigImgView addGestureRecognizer:gesture];
    }
    _bigImgView.frame = _lastSelectedImgFrame;
    if (_imageUrl.length != 0 && _filePath.length != 0) {
        _bigImgView.image = [UIImage imageWithContentsOfFile:_filePath];
    }else if (_imageUrl.length != 0 && _filePath.length == 0){
         [_bigImgView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:nil];
    }
    else{
        _bigImgView.image = [UIImage imageWithContentsOfFile:_filePath];
    }
    [self showImg];
}

- (void)showImg{
    __weak typeof(self) weakSelf = self;
    _bigImgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bigImgView.frame = KEYWINDOW.bounds;
    }];
}
- (void)hideImg{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bigImgView.alpha = 0.0f;
        weakSelf.bigImgView.frame = weakSelf.lastSelectedImgFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.bigImgView.hidden = YES;
            weakSelf.bigImgView.alpha = 1.0f;
        }
    }];
}
- (void)showAlert:(NSString *)alertText{
    [[[DXAlertView alloc] initWithTitle:@"" contentText:alertText leftButtonTitle:nil rightButtonTitle:@"确定"] show];
}
- (void)showCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self performSelector:@selector(showAlert:) withObject:@"相机打开失败" afterDelay:0.5f];
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == ALAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
                imageVC.allowsEditing = NO;
                imageVC.delegate = self;
                imageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imageVC animated:YES completion:nil];
            }else{
                [self performSelector:@selector(showAlert:) withObject:@"请在设置-->隐私-->相机-->助力凭条中打开相机使用权限" afterDelay:0.5f];
                //用户拒绝
                return;
            }
        }];
    }else if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied) {
        [self performSelector:@selector(showAlert:) withObject:@"请在设置-->隐私-->相机-->助力凭条中打开相机使用权限" afterDelay:0.5f];
        return;
    }else{
        UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
        imageVC.allowsEditing = NO;
        imageVC.delegate = self;
        imageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imageVC animated:YES completion:nil];
    }
}

-(void)showPhoto{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [self performSelector:@selector(showAlert:) withObject:@"相册打开失败" afterDelay:0.5f];
        return;
    }
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
        [self performSelector:@selector(showAlert:) withObject:@"请在设置-->隐私-->相机-->助力凭条中打开相册使用权限" afterDelay:0.5f];
        return;
    }
    UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
    imageVC.allowsEditing = NO;
    imageVC.delegate = self;
    imageVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imageVC animated:YES completion:nil];
}
#pragma mark camare
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    _imageData = UIImageJPEGRepresentation(image,0.3);
    __weak typeof(self) weakSelf = self;
    [weakSelf dismissViewControllerAnimated:YES completion:^{
        _filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/imageFile.png"];
        // 将图片写入文件
        [_imageData writeToFile:_filePath atomically:NO];
        _imageView.image = [UIImage imageWithContentsOfFile:_filePath];
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
