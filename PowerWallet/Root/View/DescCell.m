//
//  DescCell.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/10.
//  Copyright © 2017年 Jueling. All rights reserved.
//

#import "DescCell.h"
@interface DescCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
@implementation DescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(DescCell *)initCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"DescCell";
    DescCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DescCell" owner:nil options:nil] firstObject];
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
//    self.titleLabel.text = mode.title;
//    self.contentLabel.text = mode.content;
    if (indexPath.section == 1) {
        self.icon.image = [UIImage imageNamed:@"icon_h_eligibility"];
        self.titleLabel.text = @"申请资格";
        self.contentLabel.text = mode.apply_limit;
    }else{
        self.icon.image = [UIImage imageNamed:@"icon_h_productDescription"];
        self.titleLabel.text = @"产品介绍";
        self.contentLabel.text = mode.product_desc;
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
