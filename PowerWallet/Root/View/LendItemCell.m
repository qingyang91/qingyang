//
//  LendItemCell.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/10.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "LendItemCell.h"
#import "UIImageview+WebCaChe.h"
#import "NSString+Frame.h"
@interface LendItemCell()
@property (weak, nonatomic) IBOutlet UILabel *shortdescLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendnumLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end

@implementation LendItemCell
+(LendItemCell *)initCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"LendItemCell";
    LendItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LendItemCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
    }
    return self;
}
-(void)configCellWithDict:(PartnerInfoModel *)mode indexPath:(NSIndexPath *)indexPath{
    int start = [mode.success_rate intValue];
    int start1 = start/2;
    int start2 = start%2;
    NSString *startStr = [[NSString alloc] init];
    for (int i = 0; i<start1; i++) {
        startStr = [startStr stringByAppendingString:@"★"];
    }
    NSString *kStartStr = [[NSString alloc] init];
    if (start2>0) {
        kStartStr = [kStartStr stringByAppendingString:@"☆"];
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",startStr,kStartStr]];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(startStr.length, kStartStr.length)];
    
    
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:mode.lend_icon] placeholderImage:[UIImage imageNamed:@"ascending_icon_normal"] options:SDWebImageAllowInvalidSSLCertificates|SDWebImageRetryFailed];
    self.shortdescLabel.text = mode.lend_desc;
    [self.shortdescLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@([mode.lend_desc heightWIthFontSize:14.0 maxWidth:SCREEN_WIDTH-49]));
    }];
    
//    self.startLabel.text = startStr;
    self.startLabel.attributedText = attri;
    self.startLabel.textColor = UIColorFromRGB(0xFF9402);
    
    self.lendnumLabel.text = [NSString stringWithFormat:@"%d人已经放款",[mode.lend_num intValue]];
//    self.lendnumLabel.adjustsFontSizeToFitWidth = YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
