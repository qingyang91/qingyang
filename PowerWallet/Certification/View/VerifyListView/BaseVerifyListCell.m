//
//  BaseVerifyListCell.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/3/30.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseVerifyListCell.h"

#import "BaseVerifyItem.h"
#import "CycleProgressView.h"

@interface BaseVerifyListCell ()

@property (strong, nonatomic) NSArray<BaseVerifyItem *> *items;
@property (strong, nonatomic) BaseVerifyItem *personalItem;
@property (strong, nonatomic) BaseVerifyItem *contactsItem;
@property (strong, nonatomic) BaseVerifyItem *operatorItem;
@property (strong, nonatomic) BaseVerifyItem *zhimaItem;
@property (strong, nonatomic) CycleProgressView *progressItem;

@property (strong, nonatomic) UIView *lLine;
@property (strong, nonatomic) UIView *tLine;
@property (strong, nonatomic) UIView *rLine;
@property (strong, nonatomic) UIView *bLine;

@end

@implementation BaseVerifyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    self.items = @[self.personalItem, self.contactsItem, self.operatorItem, self.zhimaItem];
    [self.contentView addSubview:self.personalItem];
    [self.contentView addSubview:self.contactsItem];
    [self.contentView addSubview:self.operatorItem];
    [self.contentView addSubview:self.zhimaItem];
    [self.contentView addSubview:self.progressItem];
    
    [self.contentView addSubview:self.lLine];
    [self.contentView addSubview:self.tLine];
    [self.contentView addSubview:self.rLine];
    [self.contentView addSubview:self.bLine];
    
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.progressItem.translatesAutoresizingMaskIntoConstraints) {
        [self.progressItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@100);
            make.height.equalTo(@100);
        }];
        
        [self.personalItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top);
            make.width.equalTo(self.personalItem.mas_height).multipliedBy(375/270.0f);
        }];
        [self.contactsItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personalItem.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right).priorityMedium();
            make.width.equalTo(self.personalItem);
            make.height.equalTo(self.personalItem);
        }];
        [self.operatorItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.personalItem.mas_bottom);
            make.bottom.equalTo(self.contentView.mas_bottom).priorityMedium();
            make.width.equalTo(self.personalItem);
            make.height.equalTo(self.personalItem);
        }];
        [self.zhimaItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.operatorItem.mas_right);
            make.top.equalTo(self.contactsItem.mas_bottom);
            make.width.equalTo(self.personalItem);
            make.height.equalTo(self.personalItem);
        }];
        
        [self.lLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.progressItem.mas_left);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@0.5);
        }];
        [self.tLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.progressItem.mas_top);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@0.5);
        }];
        [self.rLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressItem.mas_right);
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@0.5);
        }];
        [self.bLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.progressItem.mas_bottom);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@0.5);
        }];
    }
}

#pragma mark - Private Method
- (void)selectItem:(UIView *)sender {
    
    !self.selectedIndex ? : self.selectedIndex(0 == sender.tag ? nil : self.dataArray[sender.tag - 1], self.dataArray[sender.tag]);
}

#pragma mark - Setter
- (void)setDataArray:(NSArray<VerifyListModel *> *)dataArray {
    _dataArray = dataArray;
    
    if (self.items.count <= dataArray.count) {
        for (NSInteger i = 0; i < self.items.count; ++i) {
            [self.items[i] configureBaseVerifyItemWithModel:dataArray[i]];
        }
    }
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    self.progressItem.progress = progress;
}

#pragma mark - Getter
- (BaseVerifyItem *)personalItem {
    
    if (!_personalItem) {
        _personalItem = [BaseVerifyItem baseVerifyItemWithTarget:self action:@selector(selectItem:)];
        _personalItem.tag = 0;
    }
    return _personalItem;
}
- (BaseVerifyItem *)contactsItem {
    
    if (!_contactsItem) {
        _contactsItem = [BaseVerifyItem baseVerifyItemWithTarget:self action:@selector(selectItem:)];
        _contactsItem.tag = 1;
    }
    return _contactsItem;
}
- (BaseVerifyItem *)operatorItem {
    
    if (!_operatorItem) {
        _operatorItem = [BaseVerifyItem baseVerifyItemWithTarget:self action:@selector(selectItem:)];
        _operatorItem.tag = 2;
    }
    return _operatorItem;
}
- (BaseVerifyItem *)zhimaItem {
    
    if (!_zhimaItem) {
        _zhimaItem = [BaseVerifyItem baseVerifyItemWithTarget:self action:@selector(selectItem:)];
        _zhimaItem.tag = 3;
    }
    return _zhimaItem;
}
- (CycleProgressView *)progressItem {
    
    if (!_progressItem) {
        _progressItem = [[CycleProgressView alloc] init];
    }
    return _progressItem;
}

- (UIView *)lLine {
    
    if (!_lLine) {
        _lLine = [[UIView alloc] init];
        _lLine.backgroundColor = Color_LineColor;
    }
    return _lLine;
}
- (UIView *)tLine {
    
    if (!_tLine) {
        _tLine = [[UIView alloc] init];
        _tLine.backgroundColor = Color_LineColor;
    }
    return _tLine;
}
- (UIView *)rLine {
    
    if (!_rLine) {
        _rLine = [[UIView alloc] init];
        _rLine.backgroundColor = Color_LineColor;
    }
    return _rLine;
}
- (UIView *)bLine {
    
    if (!_bLine) {
        _bLine = [[UIView alloc] init];
        _bLine.backgroundColor = Color_LineColor;
    }
    return _bLine;
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

