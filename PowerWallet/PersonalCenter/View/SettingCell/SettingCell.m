//
//  SettingCell.m
//  PowerWallet
//
//  Created by liu xiwang on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SettingCell.h"
@interface SettingCell()
@property (nonatomic, strong) UILabel       *lblTitle;
@property (nonatomic, strong) UILabel       *lblContent;
@property (nonatomic, strong) UILabel       *lblLine;

@end

@implementation SettingCell

+ (SettingCell *)homeCellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SettingCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubViews {
    __weak typeof(self) weakSelf = self;
    [self.contentView addSubview:self.lblTitle];
    [self.contentView addSubview:self.lblContent];
    [self.contentView addSubview:self.lblLine];

    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.height.equalTo(@17);
    }];
    _lblTitle.textColor = UIColorFromRGB(0x333333);
    
    [_lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo([self switchNumberWithFloat:15.f*WIDTHRADIUS]);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    _lblContent.textColor = UIColorFromRGB(0x999999);
    
    [_lblLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo([self switchNumberWithFloat:54.5f*WIDTHRADIUS]);
        make.width.equalTo([self switchNumberWithFloat:SCREEN_WIDTH]);
        make.height.equalTo([self switchNumberWithFloat:0.5f*WIDTHRADIUS]);
    }];
    _lblLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    _lblLine.textColor = [UIColor clearColor];
    
}

- (void)configCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath*)indexPath{
    _lblTitle.text = dict[@"strTitle"];
    self.detailTextLabel.text = dict[@"strContent"];
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

-  (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [self getLabelWithFontSize:FontSystem(16.0f) textColor:Color_Title withText:@""];
    }
    return _lblTitle;
}

-  (UILabel *)lblContent {
    if (!_lblContent) {
        _lblContent = [self getLabelWithFontSize:FontSystem(13.0f) textColor:Color_content withText:@""];
    }
    return _lblContent;
}

-  (UILabel *)lblLine {
    if (!_lblLine) {
        _lblLine = [self getLabelWithFontSize:FontSystem(13.0f) textColor:[UIColor clearColor] withText:@""];
    }
    return _lblLine;
}

- (UILabel *)getLabelWithFontSize:(UIFont *)font textColor:(UIColor *)textColor withText:(NSString *)title {
    UILabel * lbl = [[UILabel alloc] init];
    lbl.font = font;
    lbl.textColor = textColor;
    lbl.text = title;
    return lbl;
}

- (NSNumber *)switchNumberWithFloat:(float)floatValue {
    return [NSNumber numberWithFloat:floatValue];
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
