//
//  KDXieYiBtn.m
//  Krisc.Zampono
//
//  Created by haoran on 16/5/27.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//

#import "KDXieYiBtn.h"
#import "NSString+Frame.h"
@interface KDXieYiBtn()
@property (nonatomic, retain) NSString *xieyiName_1;
@property (nonatomic, retain) NSString *xieyiName_2;
@property (nonatomic, retain) NSString *xieyiName_3;

@property (nonatomic, retain) UILabel *xieyiLabel;
@property (nonatomic, retain) UILabel *xieyiLabel2;
@property (nonatomic, retain) UILabel *xieyiLabel3;
@end
@implementation KDXieYiBtn
- (instancetype)initWithXieyiName:(NSArray *)nameArr
{
    if (self = [super init]) {
        _xieyiName_1 = nameArr[0];
        if (nameArr.count == 2) {
            _xieyiName_2 = nameArr[1];
        }
        if (nameArr.count == 3) {
            _xieyiName_2 = nameArr[1];
            _xieyiName_3 = nameArr[2];
        }
        self.userInteractionEnabled = YES;
        self.frame = CGRectZero;
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.xieyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.xieyiBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    self.xieyiBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.xieyiBtn];
    self.xieyiBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.xieyiBtn setTitle:@"注册即同意" forState:UIControlStateNormal];
    [self.xieyiBtn setImage:[UIImage imageNamed:@"borrow_chose"] forState:UIControlStateNormal];
    self.xieyiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.xieyiBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.xieyiBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 0, 0);
    self.xieyiBtn.imageEdgeInsets = UIEdgeInsetsMake(4.5, 0, 0, 0);
    [self.xieyiBtn addTarget:self action:@selector(xieyiBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.xieyiBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0.0);
        make.left.equalTo(self).with.offset(15.0);
        make.height.equalTo(@25);
        make.width.equalTo(@120);
    }];
    
    self.xieyiLabel = [[UILabel alloc] init];
    self.xieyiLabel.font = [UIFont systemFontOfSize:13];
    self.xieyiLabel.textColor = [UIColor colorWithHex:0xFF5145];
    self.xieyiLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.xieyiLabel];
    self.xieyiLabel.text = _xieyiName_1;
    [_xieyiLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.xieyiBtn.mas_centerY).with.offset(1);
        make.left.equalTo(self.xieyiBtn.mas_right).with.offset(-30);
        make.height.equalTo(@30);
    }];
    
    self.xieyiLabel2 = [[UILabel alloc] init];
    self.xieyiLabel2.font = [UIFont systemFontOfSize:13];
    self.xieyiLabel2.textColor = [UIColor colorWithHex:0xFF5145];
    self.xieyiLabel2.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.xieyiLabel2];
    self.xieyiLabel2.text = _xieyiName_2;
    [self.xieyiLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.xieyiBtn.mas_centerY).with.offset(1);
        make.left.equalTo(self.xieyiLabel.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    self.xieyiLabel3 = [[UILabel alloc] init];
    self.xieyiLabel3.font = [UIFont systemFontOfSize:13];
    self.xieyiLabel3.textColor = [UIColor colorWithHex:0xFF5145];
    self.xieyiLabel3.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.xieyiLabel3];
    self.xieyiLabel3.text = _xieyiName_3;
    [self.xieyiLabel3 mas_makeConstraints:^(MASConstraintMaker *make){
        if ((90+[_xieyiName_1 widthWithFontSize:13.0]+[_xieyiName_2 widthWithFontSize:13.0]+[_xieyiName_3 widthWithFontSize:13.0]) > [UIScreen mainScreen].bounds.size.width) {
            make.top.equalTo(self.xieyiBtn.mas_bottom).with.offset(3);
            make.left.equalTo(self).with.offset(15.0);
            make.height.equalTo(@30);
        }else{
            make.centerY.equalTo(self.xieyiBtn.mas_centerY).with.offset(1);
            make.left.equalTo(self.xieyiLabel2.mas_right).with.offset(-10);
            make.height.equalTo(@30);
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xieyiTap)];
    self.xieyiLabel.userInteractionEnabled = YES;
    [self.xieyiLabel addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xieyiTap2)];
    self.xieyiLabel2.userInteractionEnabled = YES;
    [self.xieyiLabel2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xieyiTap3)];
    self.xieyiLabel3.userInteractionEnabled = YES;
    [self.xieyiLabel3 addGestureRecognizer:tap3];
}

-(void)chageFrame{
    [self frameAdd:_xieyiBtn];
    [self frameAdd:_xieyiLabel];
    [self frameAdd:_xieyiLabel2];
}

-(void)frameAdd:(UIView*)tf{
    CGRect rect = tf.frame;
    rect.origin.y = rect.origin.y+40;
    tf.frame = rect;
}

#pragma mark - 协议按钮点击
- (void)xieyiBtnSelected:(UIButton *)btn
{
    //    btn.selected = !btn.selected;
    if (self.xieyiBtnTapBlock) {
        self.xieyiBtnTapBlock();
    }
    if (self.xieyiBtn2TapBlock) {
        self.xieyiBtn2TapBlock();
    }
    
}
#pragma mark - 协议点击
- (void)xieyiTap3
{
    if (_xieyiLabel3TapBlock) {
        _xieyiLabel3TapBlock();
    }
}
- (void)xieyiTap2
{
    if (_xieyiLabel2TapBlock) {
        _xieyiLabel2TapBlock();
    }
}
- (void)xieyiTap
{
    if (_xieyiLabelTapBlock) {
        _xieyiLabelTapBlock();
    }
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
