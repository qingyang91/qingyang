//
//  UtilRequest.h
//  PowerWallet
//
//  Created by krisc.zampono on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//



@interface UtilRequest : NSObject

//上报app信息
- (void)appDeviceReportWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

//上传用户位置信息
- (void)uploadLocationWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *dictResult))successCb andFailed:(void (^)(NSInteger code, NSString *errorMsg))failCb;

- (void)contrastVersionWithDict:(NSString *)code onSuccess:(void (^)(NSDictionary *dictResult))successCb andFailed:(void (^)(NSInteger code, NSString *errorMsg))failCb;
@end
