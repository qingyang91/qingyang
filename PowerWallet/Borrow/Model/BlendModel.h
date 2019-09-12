//
//  BlendModel.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"

@protocol BlendModel


@end

@protocol ImagesModel


@end

@interface ImagesModel : JSONModel
@property (nonatomic, copy) NSString <Optional>*img;
@property (nonatomic, copy) NSString <Optional>*link;
@end

@interface BlendModel : JSONModel

@property (nonatomic, strong) NSMutableArray <ImagesModel *>   *banners;
@property (nonatomic, strong) NSMutableArray                          *rolls;
@property (nonatomic, copy) NSString<Optional> *bind_card;
@property (nonatomic, copy) NSString<Optional> *certification;
+(instancetype)helpLendWithDict:(NSDictionary *)dict;

@end



