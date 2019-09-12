//
//  AscendingUpLoadEntity.h
//  
//
//  Created by Krisc.Zampono on 16/5/11.
//  Copyright © 2016年 Krisc.Zampono. All rights reserved.
//



@interface KDAscendingUpLoadImgEntity : NSObject

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *pic_name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *url;

@property (nonatomic, retain) UIImage *image;

+ (instancetype)ascendingWithDict:(NSDictionary *)dict;
@end

@interface AscendingUpLoadEntity : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *notice;
@property (nonatomic, assign) int max_pictures;
@property (nonatomic, retain) NSMutableArray<KDAscendingUpLoadImgEntity *> *data;

+ (instancetype)ascendingWithDict:(NSDictionary *)dict;

@end
