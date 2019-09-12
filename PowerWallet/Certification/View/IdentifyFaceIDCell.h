//
//  IdentifyFaceIDCell.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentifyFaceIDCell : UITableViewCell

- (instancetype)initWithTitle:(NSString *)title;

@property (strong, nonatomic) NSArray *images;

@property (copy, nonatomic) void(^clickImageBlock)(NSInteger index, BOOL defaultImage, UIButton *imageButton);

@end
