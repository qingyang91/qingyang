//
//  activityCell.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/10.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "ActivityCell.h"
#import "CCPScrollView.h"
#import "UIImageview+WebCaChe.h"
@interface ActivityCell()
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) CCPScrollView *descLabel;



@end
@implementation ActivityCell
+(ActivityCell *)activityCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ActivityCell";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] firstObject];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCellWithDict:(RollModel *)mode indexPath:(NSIndexPath*)indexPath{
    
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:mode.roll_img] placeholderImage:[UIImage imageNamed:@"banner_loadding"] options:SDWebImageAllowInvalidSSLCertificates|SDWebImageRetryFailed completed:^(UIImage *_Nullable image,NSError * _Nullable error,SDImageCacheType cacheType,NSURL * _Nullable imageURL){
        if ([[error localizedDescription] isEqualToString:@"Downloaded image has 0 pixels"]||[[error localizedDescription] isEqualToString:@"unsupported URL"]) {
            self.activityImage.image = [UIImage imageNamed:@"icon_h_roll_img"];
        }
    }];
    self.titleLabel.text = mode.roll_title ? @"" : mode.roll_title;
    
    if (self.titleLabel.text.length == 0) {
        self.titleLabel.text = @"贷款攻略 大盘点";
        mode.roll_title = @"贷款攻略 大盘点";
    }
    
    NSArray *strArr = [mode.roll_title componentsSeparatedByString:@" "];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:mode.roll_title];
    [attri addAttribute:NSForegroundColorAttributeName value:Color_Title_HighLighted range:NSMakeRange(0, ((NSString *)strArr[0]).length)];
    self.titleLabel.attributedText = attri;
    
    [self addSubview:self.descLabel];
    self.descLabel.titleArray = mode.roll_desc;
}

-(CCPScrollView *)descLabel{
    if(!_descLabel){
        _descLabel = [[CCPScrollView alloc] initWithFrame:CGRectMake(ViewX(self.activityImage)+ViewWidth(self.activityImage)+8, ViewY(self.titleLabel)+ViewHeight(self.titleLabel), SCREEN_WIDTH - 80, 30)];
        
        _descLabel.titleFont = 12;
        _descLabel.titleColor = Color_Title_Black;
    }
    return _descLabel;
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
