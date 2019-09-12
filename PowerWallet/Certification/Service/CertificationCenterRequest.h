//
//  CertificationCenterRequest.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 10/02/2017.
//  Copyright © 2017 Krisc.Zampono. All rights reserved.
//


@interface CertificationCenterRequest : NSObject

#pragma mark - 认证列表

/**
 获取认证列表信息

 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)fetchUserVerifyListWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

#pragma mark - 紧急联系人
/**
 * 紧急联系人获取
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)getContactsListWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 保存紧急联系人
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)SaveContactsWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 上传手机通讯录
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)updateContactsWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

#pragma mark - 个人信息

/**
 获取个人信息列表

 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb    失败回调
 */
- (void)fetchPersonalInformationWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 上传Face++图片
 *
 *  @param paramDict 参数字典
 *  @param imageData 文件内容
 *  @param fileName 文件名称
 *  @param key 文件对应key
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)uploadFaceVerifyImageWithDictionary:(NSDictionary *)paramDict imageData:(NSData *)imageData fileName:(NSString *)fileName key:(NSString *)key success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 保存个人信息
 *
 *  @param suburl 服务器的相对地址
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)savePersonmalInfoWithSuburl:(NSString *)suburl dictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

#pragma mark - 工作信息
/**
 获取工作信息
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)getWorkInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 保存工作信息

 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)saveWorkInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

#pragma mark 工作照
/**
 上传工作照列表

 @param paramDict 参数
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)upImageInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 获取工作照列表

 @param paramDict 参数
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)getImageInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

#pragma mark - 绑定银行卡
/**
 获取姓名、身份证
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
-(void)getUserNameAndIdWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 收款银行卡-保存信息
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)SaveBankDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 连连绑卡RSA签名
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
-(void)signRSADict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 保存绑卡成功信息
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
-(void)saveBindBankWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 绑卡失败上传信息
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
-(void)bindingCardStateWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
@end
