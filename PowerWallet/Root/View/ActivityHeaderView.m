//
//  ActivityHeaderView.m
//  PowerWallet
//
//  Created by krisc.zampono on 17/7/17.
//  Copyright © 2017年 krisc.zampono. All rights reserved.
//

#import "ActivityHeaderView.h"

@interface ActivityHeaderView ()

@property (strong, nonatomic) UIImageView *centerShadow;

@property (strong, nonatomic) UIView *downView;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *hotActivity;
@end

@implementation ActivityHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupInterface];
    }
    return self;
}

- (void)setupInterface {
    
    self.contentView.backgroundColor= [UIColor clearColor];
    self.contentView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.downView];
    [self.downView addSubview:self.hotActivity];
    [self.downView addSubview:self.centerShadow];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.downView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.top.equalTo(self.contentView.mas_top).with.offset(8);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            //            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.height.equalTo(@37);
        }];
        
        [self.centerShadow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.downView.mas_left).with.offset(5);
            make.height.equalTo(@20);
            //            make.width.equalTo(@20);
            make.centerY.equalTo(self.downView.mas_centerY).with.offset(0);
        }];
        
        [self.hotActivity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerShadow.mas_right).with.offset(5);
            make.centerY.equalTo(self.downView.mas_centerY).with.offset(0);
        }];
        
        self.hotActivity.text = @"为您推荐";
        self.hotActivity.hidden = YES;
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.height.equalTo(@1);
        }];
    }
}

- (UIImageView *)centerShadow {
    
    if (!_centerShadow) {
        _centerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_trophy"]];
    }
    return _centerShadow;
}
- (UIView *)downView {
    
    if (!_downView) {
        _downView = [[UIView alloc] initWithFrame:self.bounds];
        _downView.backgroundColor = [UIColor whiteColor];
    }
    return _downView;
}
- (UIView *)line {
    
    if (!_line) {
        _line = [[UIView alloc] init];
        
        _line.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
    }
    return _line;
}
- (UILabel *)hotActivity {
    
    if (!_hotActivity) {
        _hotActivity = [[UILabel alloc] init];
        
        _hotActivity.text = @"为您推荐";
        _hotActivity.font = [UIFont systemFontOfSize:12];
        _hotActivity.textColor = Color_Title_HighLighted;
    }
    return _hotActivity;
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

