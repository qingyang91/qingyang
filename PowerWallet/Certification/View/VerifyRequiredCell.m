//
//  VerifyRequiredCell.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/31.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "VerifyRequiredCell.h"
#import "UIImageView+LoadImage.h"
@interface VerifyRequiredCell ()

@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *statueLabel;
@property (nonatomic, retain) UILabel *subTitleLabel;

@end
@implementation VerifyRequiredCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeCell];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeCell];
}

- (void)initializeCell {
    
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.statueLabel];
    [self.contentView addSubview:self.subTitleLabel];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.imgView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeft);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.mas_right).with.offset(kPaddingLeft);
            make.centerY.equalTo(@0);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.offset(5);
            make.bottom.equalTo(self.titleLabel.mas_bottom);
        }];
        [self.statueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
}

- (void)configureVerifyListCellWithModel:(VerifyListModel *)model {
    
    [self.imgView loadImageWithImagePath:model.logo];
    self.titleLabel.text = model.title;
    self.subTitleLabel.attributedText = model.title_mark;
    self.statueLabel.attributedText = model.operators;
}

- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.font = Font_Title;
        _titleLabel.textColor = Color_Title;
    }
    return _titleLabel;
}

- (UILabel *)statueLabel {
    
    if (!_statueLabel) {
        _statueLabel = [[UILabel alloc] init];
        
        _statueLabel.font = Font_SubTitle;
        _statueLabel.textColor = Color_Title;
    }
    return _statueLabel;
}
- (UILabel *)subTitleLabel {
    
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        
        _subTitleLabel.font = Font_SubTitle;
        _subTitleLabel.textColor = Color_content;
    }
    return _subTitleLabel;
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
