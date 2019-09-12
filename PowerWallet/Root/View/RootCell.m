//
//  RootCell.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/8.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "RootCell.h"
#import "UIImageview+WebCaChe.h"
#import "NSString+Frame.h"
@interface RootCell()

@property (weak, nonatomic) IBOutlet UILabel *l0;
@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;
@property (weak, nonatomic) IBOutlet UIImageView *is_hotImage;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *businessmenLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation RootCell
+(RootCell *)rootCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"rootItem";
    RootCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RootCell" owner:nil options:nil] firstObject];
//        cell = [[RootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setNeedsUpdateConstraints];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCellWithDict:(PartnerInfoModel *)mode indexPath:(NSIndexPath*)indexPath{
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:mode.lend_icon] placeholderImage:[UIImage imageNamed:@"banner_loadding"] options:SDWebImageAllowInvalidSSLCertificates|SDWebImageRetryFailed];
    
    self.businessmenLabel.text = mode.lend_name;
    self.amountLabel.text = mode.lend_money;
    self.amountLabel.textColor = Color_Title_HighLighted;
    self.timeLabel.text = mode.lend_time;
    self.timeLabel.textColor = Color_Title_HighLighted;
    self.monthlyRateLabel.text = mode.lend_rate;
    self.monthlyRateLabel.textColor = Color_Title_HighLighted;
    self.descLabel.text = mode.lend_desc;
    if ([mode.is_hot intValue] == 0) {
        self.is_hotImage.hidden = YES;
    }
    
    if (iPhone5) {
        self.l0.font = [UIFont systemFontOfSize:11.0];
        self.l1.font = [UIFont systemFontOfSize:11.0];
        self.l2.font = [UIFont systemFontOfSize:11.0];
        
        self.amountLabel.font = [UIFont systemFontOfSize:11.0];
        self.timeLabel.font = [UIFont systemFontOfSize:11.0];
        self.monthlyRateLabel.font = [UIFont systemFontOfSize:11.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
