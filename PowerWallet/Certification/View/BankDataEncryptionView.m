//
//  BankDataEncryptionView.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 10/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "BankDataEncryptionView.h"

@interface BankDataEncryptionView ()

@property (strong, nonatomic) UIImageView *verifyImage;
@property (strong, nonatomic) UILabel *verifyLabel;
@end

@implementation BankDataEncryptionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.verifyImage];
        [self addSubview:self.verifyLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

+ (instancetype)bankDataEncryptionView {
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.verifyLabel.translatesAutoresizingMaskIntoConstraints) {
        
        [self.verifyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verifyImage.mas_right).with.offset(5);
            make.centerY.equalTo(self.mas_centerY).with.offset(0);
            make.centerX.equalTo(self.mas_centerX).with.offset(self.verifyImage.bounds.size.width/2);
        }];
    }
}

- (UIImageView *)verifyImage {
    
    if (!_verifyImage) {
        _verifyImage = [[UIImageView alloc] initWithImage:ImageNamed(@"KDVerify")];
    }
    return _verifyImage;
}
- (UILabel *)verifyLabel {
    
    if (!_verifyLabel) {
        _verifyLabel = [[UILabel alloc] init];
        
        _verifyLabel.textColor = [UIColor blueColor];
        _verifyLabel.text = @"银行级数据加密保护";
        _verifyLabel.font = FontSystem(12);
    }
    return _verifyLabel;
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
