//
//  AscendingUpLoadVC.m
//  Krisc.Zampono
//
//  Created by Krisc.Zampono on 16/5/7.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "AscendingUpLoadVC.h"
#import "CertificationCenterRequest.h"
#import "AscendingUpLoadEntity.h"
#import "UpLoadImgCV.h"
@interface AscendingUpLoadVC ()

@property (nonatomic, retain) UILabel *descLabel;
@property (nonatomic, retain) UpLoadImgCV *uploadImg;

@property (nonatomic, retain) CertificationCenterRequest *networkAccess;

@property (assign, nonatomic) uploadImgType type;
@property (nonatomic, retain) AscendingUpLoadEntity *pageEntity;

@property (nonatomic, retain) UIView *shapView;

@end

@implementation AscendingUpLoadVC

- (instancetype)initWithType:(uploadImgType)type
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithHex:0xeff3f5];
        self.type = type;
    }
    return self;
}

- (CertificationCenterRequest *)networkAccess
{
    if (!_networkAccess) {
        _networkAccess = [[CertificationCenterRequest alloc] init];
        
    }
    return _networkAccess;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:15];
    self.descLabel.textColor = Color_Title;
    self.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view.mas_left).with.offset(15.0);
        make.right.equalTo(self.view.mas_right).with.offset(-15.0);
        make.top.equalTo(self.view.mas_top).with.offset(15.0);
    }];

    self.descLabel.numberOfLines = 0;
    
    __weak typeof(self) weakSelf = self;
    _uploadImg = [UpLoadImgCV getcollection];
    _uploadImg.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_uploadImg];
    [self.uploadImg mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(weakSelf.descLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];

}

-(void)leftBtnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateView
{
    self.descLabel.text = self.pageEntity.notice;
    
    _uploadImg.dataArray = self.pageEntity.data;
    _uploadImg.maxNum = self.pageEntity.max_pictures;
    _uploadImg.type = self.type;
    [_uploadImg reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _uploadImg.uploadImgSuccss = [self.uploadImgSuccss copy];
    //	1:身份证,2:学历证明,3:工作证明,4:收入证明,5:财产证明,6、工牌照片、7、个人名片，8、银行卡 100:其它证明
    NSString *navTitle = @"";
    switch (_type) {
        case IdCard:
            navTitle = @"身份证";
            break;
        case Certificate:
            navTitle = @"学历证明";
            break;
        case Work:
            navTitle = @"工作证明";
            break;
        case Salary:
            navTitle = @"收入证明";
            break;
        case Property:
            navTitle = @"财产证明";
            break;
        case workCard:
            navTitle = @"工牌照片";
            break;
        case personCard:
            navTitle = @"个人名片";
            break;
        case bankCard:
            navTitle = @"信用卡信息";
            break;
        default:
            navTitle = @"其它证明";
            break;
    }
    self.navigationItem.title = navTitle;
    if (!self.pageEntity) {
        [self getPageData];
    }
    
    if (_type == IdCard) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"样照" style:UIBarButtonItemStylePlain target:self action:@selector(showShapeasdfadsf)];
    }
    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationBar_popBack"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    
}

- (void)showShapeasdfadsf
{
    if (!_shapView) {
        _shapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _shapView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
        _shapView.hidden = YES;
        [self.view addSubview:_shapView];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"ascending_shap"];
        imgView.contentMode = UIViewContentModeCenter;
        imgView.backgroundColor = [UIColor whiteColor];
        imgView.userInteractionEnabled = YES;
        [_shapView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.shapView.mas_centerY).with.offset(-30);
            make.centerX.equalTo(self.shapView.mas_centerX).with.offset(0);
            make.height.equalTo(@(SCREEN_WIDTH * 586.f / 750.f));
            make.width.equalTo(@(SCREEN_WIDTH * 522.f / 750.f));
        }];
        
        __weak typeof(self) weakSelf = self;
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:Color_BLACK forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"borrow_close"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn addTarget:weakSelf action:@selector(hideShapeadfadfa) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(imgView.mas_right).with.offset(0);
            make.top.equalTo(imgView.mas_top).with.offset(0);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];

    }
    _shapView.hidden = NO;
}

- (void)hideShapeadfadfa
{
    _shapView.hidden = YES;
}

- (void)getPageData
{
    __weak typeof(self) weakSelf = self;
    [self.networkAccess getImageInfoWithDict:@{@"type":@(_type)} onSuccess:^(NSDictionary *dictResult) {
        
        weakSelf.pageEntity = [AscendingUpLoadEntity ascendingWithDict:dictResult[@"item"]];
        [weakSelf updateView];
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        
    }];

    
}

- (void)back
{
    if (self.uploadImg.uploadArray && self.uploadImg.uploadArray.count > 0) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:@"您有图片未上传，是否继续返回！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
