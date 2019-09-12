//
//  MeCell.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MeCell.h"
#import "UIImageView+Additions.h"
@interface MeCell()

@property(nonatomic, retain) UILabel        *lblTitle;
@property(nonatomic, retain) UIImageView    *imvIcon;
@property(nonatomic, retain) UIButton       *btnNext;
@property(nonatomic, retain) UILabel        *lblContent;
@property(nonatomic, retain) UIView        *lblLine;
@property(nonatomic, retain) UIImageView    *arrowShow;
@end

@implementation MeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}


-(void)configUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imvIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.imvIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.imvIcon];
    self.imvIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.imvIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView.mas_left).with.offset(15*WIDTHRADIUS);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
        make.height.equalTo(@(40.5*WIDTHRADIUS));
        make.height.equalTo(@(40.5*WIDTHRADIUS));
    }];
    
    self.lblTitle = [[UILabel alloc] init];
    self.lblTitle.font = [UIFont systemFontOfSize:16];
    self.lblTitle.textColor = Color_Title;
    self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.imvIcon.mas_right).with.offset(15.f*WIDTHRADIUS);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
    }];
    
    self.lblContent = [[UILabel alloc] init];
    self.lblContent.font = [UIFont systemFontOfSize:13];
    self.lblContent.textColor = Color_content;
    self.lblContent.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.lblContent];
    [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.contentView.mas_right).with.offset(-40.f*WIDTHRADIUS);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
    }];
    
    _lblLine = [[UIView alloc] init];
    _lblLine.backgroundColor = Color_LineColor;
    _lblLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_lblLine];
    
    [_lblLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.equalTo(@.5f);
    }];
    
    self.arrowShow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"borrow_arrowright.jpg"]];
    self.arrowShow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.arrowShow];
    [self.arrowShow mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.contentView.mas_right).with.offset(-15*WIDTHRADIUS);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
    }];
    
}

- (void)updateTableViewCellWithdata:(NSArray *)entity index:(NSIndexPath *)indexPath{
    
    _lblTitle.text = [entity[indexPath.row] objectForKey:@"strTitle"];
    _arrowShow.hidden = NO;
    [self.contentView viewWithTag:2001].hidden = YES;
    if (indexPath.row == 0 && indexPath.section == 0) {//空格行
        self.backgroundColor = Color_TABBG;
        self.imvIcon.hidden = YES;
        _lblContent.hidden = YES;
        _lblTitle.hidden = YES;
        _lblLine.hidden = YES;
        _arrowShow.hidden = YES;
    }else{
        self.backgroundColor = [UIColor whiteColor];
        //银行卡
        _imvIcon.image = [UIImage imageNamed:[entity[indexPath.row] objectForKey:@"strIcon"]];
        self.imvIcon.hidden = NO;
        _lblTitle.hidden = NO;
        _lblLine.hidden = NO;
        
        if (indexPath.row==1) {
            if ([[entity[indexPath.row] objectForKey:@"strIcon"] length]==0) {//银行卡没有绑定
                _lblContent.hidden = YES;
                _lblContent.text = @"";
                
            }else{
                _lblContent.hidden = NO;
                _lblContent.text = [entity[indexPath.row] objectForKey:@"strContent"];
                
            }
        }else{
            if (indexPath.row == 5) {
                _lblLine.hidden = NO;
                
            }else
            {
                _lblLine.hidden = NO;
            }
            _lblContent.hidden = NO;
            _lblContent.text = [entity[indexPath.row] objectForKey:@"strContent"];
        }
        
        if (indexPath.row == 6) {
            _lblContent.hidden = YES;
        }
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
