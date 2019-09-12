//
//  ErrorModel.h
//  PowerWallet
//
//  Created by 清阳 on 2017/12/25.
//  Copyright © 2017年 peijunjinrong. All rights reserved.
//

#import "JSONModel.h"

@interface ErrorModel : JSONModel


@property (nonatomic,copy) NSString<Optional>* code;

@property (nonatomic,copy) NSString<Optional>* message;

@end
