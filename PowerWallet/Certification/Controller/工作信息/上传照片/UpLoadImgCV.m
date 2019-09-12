//
//  UpLoadImgCV.m
//  Krisc.Zampono
//
//  Created by Krisc.Zampono on 16/5/11.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "UpLoadImgCV.h"
#import <ELCImagePickerController/ELCImagePickerController.h>
#import "CertificationCenterRequest.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "AscendingUpLoadVC.h"
#import "YLProgressBar.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImageView+WebCache.h"
#define KEYWINDOW       ([UIApplication sharedApplication].keyWindow)
@interface UpLoadImgCV ()<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate>

@property (nonatomic, retain) CertificationCenterRequest *networkAccess;
@property (nonatomic, retain) NSMutableArray *pageDataArray;

@property (nonatomic, retain) NSMutableArray *uploadIndexPathArray;

@property (nonatomic, retain) UIImageView *bigImgView;
@property (assign, nonatomic) CGRect lastSelectedImgFrame;

@end

@implementation UpLoadImgCV

+ (id)getcollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 5 * 15) / 4,(SCREEN_WIDTH - 5 * 15) / 4);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 80);
    
    UpLoadImgCV *collectionView = [[UpLoadImgCV alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.showsHorizontalScrollIndicator = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    return collectionView;
}

- (CertificationCenterRequest *)networkAccess
{
    if (!_networkAccess) {
        _networkAccess = [[CertificationCenterRequest alloc] init];
    }
    return _networkAccess;
}

- (void)setDataArray:(NSArray<KDAscendingUpLoadImgEntity *> *)dataArray
{
    _dataArray = dataArray;
    if (!_pageDataArray) {
        _pageDataArray = [@[] mutableCopy];
    }
    [_pageDataArray removeAllObjects];
    [_pageDataArray addObjectsFromArray:dataArray];
    
    if (!_uploadArray) {
        _uploadArray = [@[] mutableCopy];
    }
    
    if (!_uploadIndexPathArray) {
        _uploadIndexPathArray = [@[] mutableCopy];
    }
    
}

- (void)uploadImages
{
    if (self.uploadArray.count == 0) {
        [[[DXAlertView alloc] initWithTitle:@"" contentText:@"您还未选择照片" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        return;
    }
    
    NSIndexPath *indexPath = [self.uploadIndexPathArray objectAtIndex:0];
    UICollectionViewCell * cell;
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    if (CGRectIntersectsRect(self.bounds, attributes.frame)) {
        cell = [self cellForItemAtIndexPath:indexPath];
    }
    UIButton *deleteBtn = [cell.contentView viewWithTag:1003];
    deleteBtn.hidden = YES;
    YLProgressBar *progressBarRoundedFat = (YLProgressBar *)[cell.contentView viewWithTag:1002];
    progressBarRoundedFat.hidden = NO;
    __weak typeof(self) weakSelf = self;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Base_URL,kPictureUploadImage];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (KDAscendingUpLoadImgEntity *model in self.uploadArray) {
        [array addObject:model.image];
    }
    
    [[NetworkSingleton sharedManager] uploadImageWithURL:strUrl params:@{@"type":@(_type)} fileDatas:array key:@"attach" fileName:@"imageFile.jpg" mimeType:@"image/jpeg" withPorcessingHandler:^(double progressValue) {
        if (cell) {
            [progressBarRoundedFat setProgress:progressValue animated:YES];
        }
    } withCompleteHandler:^(id responseObject) {
        progressBarRoundedFat.hidden = YES;
        
        if (weakSelf.uploadArray.count > 0 && weakSelf.uploadIndexPathArray.count > 0) {
            [weakSelf.uploadArray removeObjectAtIndex:0];
            [weakSelf.uploadIndexPathArray removeObjectAtIndex:0];
        }
        
        if (weakSelf.uploadArray.count > 0) {
            [weakSelf uploadImages];
        } else {
            [(AscendingUpLoadVC *)weakSelf.viewController getPageData];
            if (weakSelf.uploadImgSuccss) {
                weakSelf.uploadImgSuccss();
            }
        }
    } withErrorHandler:^(NSError *errMessage) {
        progressBarRoundedFat.hidden = YES;
        deleteBtn.hidden = NO;
        
    }];
}

- (void)deleteImg:(UIButton *)btn
{
    UIImageView *imgView = [btn.superview viewWithTag:1001];
    if (self.pageDataArray.count>0&&self.uploadArray.count>0) {
        for (int i = 0; i<self.pageDataArray.count; i++) {
            KDAscendingUpLoadImgEntity *mode = self.pageDataArray[i];
            if ([mode.image isEqual:imgView.image]) {
                [self.pageDataArray removeObject:mode];
            }
        }
        for (int i = 0; i<self.uploadArray.count; i++) {
            KDAscendingUpLoadImgEntity *mode = self.uploadArray[i];
            if ([mode.image isEqual:imgView.image]) {
                [self.uploadArray removeObject:mode];
            }
        }
//        [self.pageDataArray removeObject:imgView.image];
//        [self.uploadArray removeObject:imgView.image];
        [self reloadData];
    }
}

//显示大图
- (void)showBigImgWithIndex:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    _lastSelectedImgFrame = [self convertRect:attributes.frame toView:KEYWINDOW];
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
    KDAscendingUpLoadImgEntity *imageData = self.pageDataArray[indexPath.row];
    if ([self.dataArray indexOfObject:[self.pageDataArray objectAtIndex:indexPath.row]] <= self.dataArray.count) {
        [_bigImgView sd_setImageWithURL:[NSURL URLWithString:imageData.url] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:nil];
    } else {
        _bigImgView.image = imageData.image;
    }
    [self showImg];
}

- (void)showImg
{
    __weak typeof(self) weakSelf = self;
    _bigImgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bigImgView.frame = KEYWINDOW.bounds;
    }];
}

- (void)hideImg
{
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

#pragma mark collectionDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pageDataArray.count) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet showInView:self];
    } else {
        //看大图
        [self showBigImgWithIndex:indexPath];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _pageDataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (![cell.contentView viewWithTag:1001]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 5 * 15) / 4, (SCREEN_WIDTH - 5 * 15) / 4)];
        imageView.tag = 1001;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = Color_Red.CGColor;
        imageView.layer.borderWidth = 0.5f;
        [cell.contentView addSubview:imageView];
        
        YLProgressBar *progressBarRoundedFat = [[YLProgressBar alloc] initWithFrame:CGRectMake(0, (SCREEN_WIDTH - 5 * 15) / 4 - 8, (SCREEN_WIDTH - 5 * 15) / 4, 8)];
        NSArray *tintColors = @[Color_Red];
        progressBarRoundedFat.tag = 1002;
        progressBarRoundedFat.progressTintColors       = tintColors;
        progressBarRoundedFat.stripesOrientation       = YLProgressBarStripesOrientationLeft;
        progressBarRoundedFat.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
        progressBarRoundedFat.indicatorTextLabel.font  = [UIFont systemFontOfSize:13];
        progressBarRoundedFat.progressStretch          = NO;
        progressBarRoundedFat.backgroundColor = [UIColor whiteColor];
        progressBarRoundedFat.alpha = 0.6f;
        progressBarRoundedFat.hidden = YES;
        [cell.contentView addSubview:progressBarRoundedFat];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = [UIFont systemFontOfSize:0];
        [btn setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3f];
        [cell.contentView addSubview:btn];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn setImage:[UIImage imageNamed:@"ascending_dustbin"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentMode = UIViewContentModeCenter;
        btn.tag = 1003;
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(cell.contentView.mas_right).with.offset(0);
            make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(0);
            make.height.equalTo(@20);
            make.width.equalTo(@20);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = Color_White;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:label];
        label.tag = 1004;
        label.text = @"已上传";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithHex:0x000000 alpha:.3f];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(cell.contentView.mas_left).with.offset(0);
            make.right.equalTo(cell.contentView.mas_right).with.offset(0);
            make.centerY.equalTo(cell.contentView.mas_centerY).with.offset(0);
            make.height.equalTo(@24.0);
        }];

    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1001];
    UIButton *btn = [cell.contentView viewWithTag:1003];
    UILabel *label = [cell.contentView viewWithTag:1004];

    if (indexPath.row == self.pageDataArray.count) {
        //上传图片的图标
        imageView.image = [UIImage imageNamed:0 == self.pageDataArray.count ? @"ascending_photo" : @"ascending_add_img"];
        btn.hidden = YES;
        label.hidden = YES;
    } else {
        KDAscendingUpLoadImgEntity *imageData = self.pageDataArray[indexPath.row];
        if ([self.dataArray indexOfObject:imageData] <= self.dataArray.count) {
            //已上传过的图片
            
             [imageView sd_setImageWithURL:[NSURL URLWithString:imageData.url] placeholderImage:[UIImage imageNamed:@"ascending_upload_normal"] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:nil];
            btn.hidden = YES;
            label.hidden = NO;
        } else {
            //未上传的图片
            imageView.image = imageData.image;
            btn.hidden = NO;
            label.hidden = YES;
            [_uploadIndexPathArray addObject:indexPath];
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
       reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        if (![reusableview viewWithTag:1001]) {
            UIView *collectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 80)];
            collectionFooterView.tag = 1001;
            [reusableview addSubview:collectionFooterView];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:Color_White forState:UIControlStateNormal];
            btn.backgroundColor = Color_Red;
            [collectionFooterView addSubview:btn];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            [btn mas_makeConstraints:^(MASConstraintMaker *make){
                make.center.equalTo(collectionFooterView).with.offset(0);
                make.width.equalTo(@(SCREEN_WIDTH - 30));
                make.height.equalTo(@44);
            }];
            
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5.0f;
            [btn setTitle:@"上传" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(uploadImages) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return reusableview;
}


//actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.maxNum - self.pageDataArray.count <= 0) {
        [self performSelector:@selector(showAlert:) withObject:@"图片数量已达上限" afterDelay:0.5f];
        return;
    }
    if (buttonIndex != 0 && buttonIndex != 1) {
        return;
    }
    if (buttonIndex == 0) {
        [self showCamera];
    }
    if(buttonIndex == 1){
        [self showPhoto];
    }
}

- (void)showCamera
{
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
                [self.viewController presentViewController:imageVC animated:YES completion:nil];
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
        [self.viewController presentViewController:imageVC animated:YES completion:nil];
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
    [self.viewController presentViewController:imageVC animated:YES completion:nil];
}

- (void)showPhotoAlbum
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
    elcPicker.maximumImagesCount = self.maxNum - self.pageDataArray.count;
    elcPicker.imagePickerDelegate = self;
    [self.viewController presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark camare
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    
    KDAscendingUpLoadImgEntity *entity = [[KDAscendingUpLoadImgEntity alloc] init];
    entity.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.uploadArray addObject:entity];
    
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf.pageDataArray removeAllObjects];
        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.dataArray];
        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.uploadArray];
        [weakSelf reloadData];
    }];
}


#pragma mark ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    __weak typeof(self) weakSelf = self;
    [info enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                
                KDAscendingUpLoadImgEntity *entity = [[KDAscendingUpLoadImgEntity alloc] init];
                entity.image = [dict objectForKey:UIImagePickerControllerOriginalImage];
                [self.uploadArray addObject:entity];
                
//                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
//                [weakSelf.uploadArray addObject:image];
                [weakSelf.uploadIndexPathArray removeAllObjects];
            }
        }
    }];
    
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf.pageDataArray removeAllObjects];
        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.dataArray];
        [weakSelf.pageDataArray addObjectsFromArray:weakSelf.uploadArray];
        [weakSelf reloadData];
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlert:(NSString *)alertText
{
    [[[DXAlertView alloc] initWithTitle:@"" contentText:alertText leftButtonTitle:nil rightButtonTitle:@"确定"] show];
}

-(void)toCamer{
    if (self.maxNum - self.pageDataArray.count <= 0) {
        [self performSelector:@selector(showAlert:) withObject:@"图片数量已达上限" afterDelay:0.5f];
        return;
    }
    [self showCamera];
}
-(void)toPhoto{
    if (self.maxNum - self.pageDataArray.count <= 0) {
        [self performSelector:@selector(showAlert:) withObject:@"图片数量已达上限" afterDelay:0.5f];
        return;
    }
    [self showPhoto];
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
