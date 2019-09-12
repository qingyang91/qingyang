//
//  MultiselectTableViewCell.m
//  Multiselect
//
//  Created by 清阳 on 2017/12/22.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "MultiselectTableViewCell.h"

@implementation MultiselectTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
       self.lbName = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.contentView.frame.size.width - 50, self.contentView.frame.size.height - 10)];
        
        self.lbName.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:self.lbName];
        
        self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 20, 10, self.contentView.frame.size.height - 20, self.contentView.frame.size.height - 20)];
        
        [self.contentView addSubview:self.selectImage];
        
    }
    
    return self;
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
