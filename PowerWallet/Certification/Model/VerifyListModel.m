//
//  VerifyListModel.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 10/02/2017.
//  Copyright © 2017 Krisc.Zampono. All rights reserved.
//

#import "VerifyListModel.h"

@implementation VerifyListModel


/**
 Description

 @param dict dict description
 @return return value description
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.operators  = [self convertToAttributedString:dict[@"operator"]];
        self.title_mark = [self convertToAttributedString:dict[@"title_mark"]];
        self.type       = dict[@"type"];
        self.title      = dict[@"title"];
        self.subtitle   = dict[@"subtitle"];
        self.tag        = dict[@"tag"];
        self.logo       = dict[@"logo"];
        self.url        = dict[@"url"];
        self.status     = dict[@"status"];
    }
    return self;
}

/**
 Description

 @param dict dict description
 @return return value description
 */
+ (instancetype)verifyListModelWithDictionary:(NSDictionary *)dict {
    
    return [[[self class] alloc] initWithDictionary:dict];
//    VerifyListModel *model = [VerifyListModel mj_objectWithKeyValues:dict];
//    return model;
}


/**
 Description

 @param string string description
 @return return value description
 */
- (NSAttributedString *)convertToAttributedString:(NSString *)string {
    
    return [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}


@end
