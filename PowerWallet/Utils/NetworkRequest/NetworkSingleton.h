//
//  NetworkSingleton.h
//  meituan
//
//  Created by jinzelu on 15/6/17.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import <AFNetworking/AFHTTPSessionManager.h>
//请求超时
#define TIMEOUT 30

typedef void(^SuccessBlock)(id responseObject,NSInteger statusCode);
typedef void(^FailureBlock)(NSError *e,NSInteger statusCode,NSString *errorMsg);

//上传文件
typedef void(^uploadingHandler)(double progressValue);      //上传进度实时回调
typedef void(^uploadCompleteHandler)(id responseObject);    //上传完成时回调
typedef void(^uploadErrorHandler)(NSError *errMessage);     //上传失败时回调

@interface NetworkSingleton : NSObject

+(NetworkSingleton *)sharedManager;
-(AFHTTPSessionManager *)baseHtppRequest;
-(void)reachabilityStatus:(void(^)(NSString *status))statusStr;
/**
 拼接安全URL

 @param str 原URL
 @return 拼接后的URL
 */
- (NSString *)handleUrlWithParamWithStr:(NSString *)str;
/**
 添加登录、安全需要的字段

 @param myDic 原字段
 @return 添加后的
 */
-(NSDictionary *)setParamsToDic:(NSMutableDictionary *)myDic;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/*!
 *  @brief 字典转Json字符串
 *  @param object 字典
 *  @return Json字符串
 */
-(NSString*)DataTOjsonString:(id)object;

#pragma mark - 获取网络信息

/**
 get请求

 @param url URL链接
 @param successBlock 访问成功返回值
 @param failureBlock 访问失败返回值
 */
-(void)getDataWithUrl:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 Post请求

 @param userInfo 上传数据
 @param url URL链接
 @param successBlock 访问成功返回值
 @param failureBlock 访问失败返回值
 */
-(void)getDataPost:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 post 请求 自动添加参数

 @param userInfo 必备参数
 @param url url地址
 @param successBlock 访问成功返回值
 @param failureBlock 访问失败返回值
 */
-(void)getDataPostWithAddParameters:(NSMutableDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 上传图片
 
 @param url                 接口地址
 @param params              参数
 @param fileDatas           文件
 @param key                 服务器接收的key
 @param fileName            文件名
 @param mimeType            文件类型
 @param uploadingHandler    上传进度
 @param completeHandler     上传成功
 @param errHandler          上传失败
 */
-(void)uploadImageWithURL:(NSString *)url params:(NSDictionary *)params fileDatas:(NSArray *)fileDatas key:(NSString*)key fileName:(NSString*)fileName mimeType:(NSString*)mimeType withPorcessingHandler:(uploadingHandler)uploadingHandler withCompleteHandler:(uploadCompleteHandler)completeHandler withErrorHandler:(uploadErrorHandler)errHandler;

/**
 上传单张图片

 @param url             url地址
 @param params          参数
 @param imageData       图片
 @param fileName        文件名
 @param key             文件类型
 @param successBlock    访问成功
 @param failureBlock    访问失败
 */
-(void)uploadImageWithURL:(NSString *)url params:(NSDictionary *)params image:(NSData *)imageData fileName:(NSString *)fileName key:(NSString *)key successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
