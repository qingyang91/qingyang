//
//  PersonalInformationModel.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/2/17.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

@interface DegreesModel : NSObject
@property (strong, nonatomic) NSNumber *degrees;
@property (strong, nonatomic) NSString *name;
+(instancetype)degressWithDict:(NSDictionary *)dict;
@end

@interface LiveTimeTypeModel : NSObject
@property (strong, nonatomic) NSNumber *live_time_type;
@property (strong, nonatomic) NSString *name;
+(instancetype)liveTimeTypeWithDict:(NSDictionary *)dict;
@end

@interface MarriageModel : NSObject
@property (strong, nonatomic) NSNumber *marriage;
@property (strong, nonatomic) NSString *name;
+(instancetype)marriageWithDict:(NSDictionary *)dict;
@end

@interface PersonalInformationModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *id_number;
@property (strong, nonatomic) NSString *marriage;
@property (strong, nonatomic) NSString *degrees;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *address_distinct;
@property (strong, nonatomic) NSString *live_time_type;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *real_verify_status;
@property (strong, nonatomic) NSNumber *live_period;

@property (strong, nonatomic) NSString *id_number_z_picture;
@property (strong, nonatomic) NSString *id_number_f_picture;
@property (strong, nonatomic) NSNumber *Id;
@property (strong, nonatomic) NSString *face_recognition_picture;

@property (nonatomic, strong) NSMutableArray  <DegreesModel *> *degrees_all;
@property (nonatomic, strong) NSMutableArray  <LiveTimeTypeModel *> *live_time_type_all;
@property (nonatomic, strong) NSMutableArray  <MarriageModel *> *marriage_all;


@property (NS_NONATOMIC_IOSONLY, readonly) BOOL informationIsComplete;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *lackOfInformationDescription;

+ (instancetype)personalInfoWithDict:(NSDictionary *)dict;
@end
