//
//  ReloadView.m
//  Jdmobile
//
//  Created by steven sun on 12/23/11.
//  Copyright 2011 360buy. All rights reserved.
//

#import "NoNetReloadView.h"

@interface NoNetReloadView()


@end

@implementation NoNetReloadView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self configUI];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    __weak typeof(self) weakSelf = self;
    
    self.nonetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_nonet"]];
    
    self.nonetView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.nonetView];
    [self.nonetView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(162 * WIDTHRADIUS);
        make.width.equalTo(@(108 * WIDTHRADIUS));
        make.height.equalTo(@(87 * WIDTHRADIUS));
    }];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = Color_Title;
    self.tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.top.equalTo(self.nonetView.mas_bottom).with.offset(19 * WIDTHRADIUS);
    }];
    _tipLabel.text = @"无网络信号";
    
    self.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    
    self.reloadBtn = [[UILabel alloc] init];
    self.reloadBtn.font = [UIFont systemFontOfSize:15];
    self.reloadBtn.textColor = Color_content;
    self.reloadBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.reloadBtn];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(22 * WIDTHRADIUS);
    }];
    _reloadBtn.text = @"请检查网络是否正常后，点屏幕重试";
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadAction)];
    [self addGestureRecognizer:gesture];
}

- (void) reloadAction
{
    if (_btnClick) {
        _btnClick();
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
