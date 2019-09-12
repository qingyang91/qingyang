//
//  NetworkSingleton.m
//  meituan
//
//  Created by jinzelu on 15/6/17.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "NetworkSingleton.h"
#import "DSUtils.h"
#import "UserManager.h"
#import "NSString+Url.h"
#import <Bugly/Bugly.h>
#import "DSNetWorkStatus.h"
@implementation NetworkSingleton

+(NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}
-(AFHTTPSessionManager *)baseHtppRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/octet-stream" ,@"text/json", @"text/javascript", @"text/html",@"text/plain",@"image/jpeg",@"image/png", nil];
    return manager;
}

- (NSString *)handleUrlWithParamWithStr:(NSString *)str {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:@"ios" forKey:@"clientType"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSArray *verArray = [app_Version componentsSeparatedByString:@"."];
    if (verArray.count<3) {
        app_Version = [app_Version stringByAppendingString:@".0"];
    }
    [dataDic setObject:[NSString stringWithFormat:@"%@",app_Version] forKey:@"appVersion"];
    [dataDic setObject:[DSUtils getUUIDString] forKey:@"deviceId"];
    [dataDic setObject:[[UIDevice alloc]init].name forKey:@"deviceName"];
    [dataDic setObject:[NSString stringWithFormat:@"%.2f",IOSVERSION] forKey:@"osVersion"];
    [dataDic setObject:@"lygj" forKey:@"appName"];
    [dataDic setObject:@"AppStore" forKey:@"appMarket"];
    [dataDic setValue:DSStringValue([UserManager sharedUserManager].userInfo.username) forKey:@"mobilePhone"];
    return [NSString addQueryStringToUrl:str params:dataDic];
}

-(NSDictionary *)setParamsToDic:(NSMutableDictionary *)myDic{
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:myDic];
    [dataDic setObject:@"ios" forKey:@"clientType"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSArray *verArray = [app_Version componentsSeparatedByString:@"."];
    if (verArray.count<3) {
        app_Version = [app_Version stringByAppendingString:@".0"];
    }
    [dataDic setObject:[NSString stringWithFormat:@"%@",app_Version] forKey:@"appVersion"];
    [dataDic setObject:[DSUtils getUUIDString] forKey:@"deviceId"];
    [dataDic setObject:[[UIDevice alloc]init].name forKey:@"deviceName"];
    [dataDic setObject:[NSString stringWithFormat:@"%.2f",IOSVERSION] forKey:@"osVersion"];
    [dataDic setObject:@"lygj" forKey:@"appName"];
    [dataDic setObject:@"AppStore" forKey:@"appMarket"];
//    [dataDic setValue:DSStringValue([UserManager sharedUserManager].userInfo.username) forKey:@"mobilePhone"];
    [dataDic setValue:[UserManager sharedUserManager].userInfo.username == nil ? @"" : [UserManager sharedUserManager].userInfo.username forKey:@"mobilePhone"];
    return [NSDictionary dictionaryWithDictionary:dataDic];
}

-(void)reachabilityStatus:(void(^)(NSString *status))statusStr{
    //1.初始化
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.开始监听网络的状态
    [manager startMonitoring];
    
    //3.设置网络状态改变的回调
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                statusStr(@"Unknown");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                statusStr(@"notReachable");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                statusStr(@"2G\3G\4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                statusStr(@"WiFi");
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 获取网络信息
-(void)getDataWithUrl:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
        @try {
            url = [self handleUrlWithParamWithStr:url];
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
                failureBlock(nil,-200,[TipMessage shared].tipMessage.errorMsgNetworkUnavailable);
                return;
            }
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            (manager.requestSerializer).timeoutInterval = 10;
            [manager setSecurityPolicy:[self customSecurityPolicy]];
            
            [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary * dict = [self dictionaryWithJsonString:str];
                if ([[dict[@"code"] description] isEqualToString:@"-3"]) {
                    DXAlertView * alertV = [[DXAlertView alloc] initTitleTime:[dict[@"time"] description]];
                    [alertV show];
                    successBlock(@{@"data":@"",@"message":@""}, response.statusCode);
                }else{
                    if ([[dict[@"code"] description] isEqualToString:@"-2"]) {
                    }
                    successBlock(dict,response.statusCode);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSString *strErrorMsg;
                if (response.statusCode == 401) {
                    strErrorMsg = [TipMessage shared].tipMessage.errorMsg401;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedLogin object:nil];
                } else if (response.statusCode/100 == 5) {
                    strErrorMsg = [TipMessage shared].tipMessage.errorMsg50x;
                } else if (response.statusCode/100 == 3) {
                    strErrorMsg = [TipMessage shared].tipMessage.errorMsg30x;
                } else {
                    strErrorMsg = [error localizedDescription];
                }
                [Bugly reportError:error];
                failureBlock(error,response.statusCode,strErrorMsg);
            }];
            
            
        }
        @catch (NSException *exception) {
            
        }

}

-(void)getDataPost:(NSMutableDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
        @try {
            if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
                failureBlock(nil,-200,[TipMessage shared].tipMessage.errorMsgNetworkUnavailable);
                return;
            }
            AFHTTPSessionManager *manager = [self baseHtppRequest];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            (manager.requestSerializer).timeoutInterval = 10;
            [manager setSecurityPolicy:[self customSecurityPolicy]];
            
            [manager POST:url parameters:userInfo constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                //responseObject：服务器返回的数据
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSDictionary * dict = responseObject;
                if ([[dict[@"code"] description] isEqualToString:@"-3"]) {
                    DXAlertView * alertV = [[DXAlertView alloc] initTitleTime:[dict[@"time"] description]];
                    [alertV show];
                    successBlock(@{@"data":@"",@"message":@""}, response.statusCode);
                }else{
                    if ([[dict[@"code"] description] isEqualToString:@"-2"]) {
                        [[UserManager sharedUserManager] logout];
                    }
                    successBlock(responseObject,response.statusCode);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSString *strErrorMsg;
                if (response.statusCode == 401) {
                    [[UserManager sharedUserManager] logout];
                    strErrorMsg = [TipMessage shared].tipMessage.errorMsg401;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedLogin object:nil];
                } else if (response.statusCode/100 == 5) {
                    strErrorMsg = [TipMessage shared].tipMessage.errorMsg50x;
                } else if (response.statusCode/100 == 3) {
                    strErrorMsg = [TipMessage shared].tipMessage.errorMsg30x;
                } else {
                    strErrorMsg = [error localizedDescription];
                }
                [Bugly reportError:error];
                failureBlock(error,response.statusCode,strErrorMsg);
            }];
        }
        @catch (NSException *exception) {
        }
}

-(void)getDataPostWithAddParameters:(NSMutableDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    userInfo = [[NSMutableDictionary alloc] initWithDictionary:[self setParamsToDic:userInfo]];
    [self getDataPost:userInfo url:url successBlock:successBlock failureBlock:failureBlock];
}


/**
 上传图片

 @param url 接口地址
 @param params 参数
 @param fileDatas 文件
 @param key 服务器接收的key
 @param fileName 文件名
 @param mimeType 文件类型
 @param uploadingHandler 上传进度
 @param completeHandler 上传成功
 @param errHandler 上传失败
 */
-(void)uploadImageWithURL:(NSString *)url params:(NSDictionary *)params fileDatas:(NSArray *)fileDatas key:(NSString*)key fileName:(NSString*)fileName mimeType:(NSString*)mimeType withPorcessingHandler:(uploadingHandler)uploadingHandler withCompleteHandler:(uploadCompleteHandler)completeHandler withErrorHandler:(uploadErrorHandler)errHandler{
        @try {
            if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
                errHandler([NSError errorWithDomain:[TipMessage shared].tipMessage.errorMsgNetworkUnavailable code:-200 userInfo:nil]);
                return;
            }
            NSString *strUrl = [self handleUrlWithParamWithStr:url];
            strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:strUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                int i = 0;
                for (UIImage *imvPhoto in fileDatas) {
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(imvPhoto, 0.01) name:key fileName:fileName mimeType:mimeType];
                    i ++;
                }
            } error:nil];
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.securityPolicy = [self customSecurityPolicy];
            NSURLSessionUploadTask *uploadTask;
            uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                       progress:^(NSProgress * _Nullable uploadProgress){
                dispatch_async(dispatch_get_main_queue(), ^{uploadingHandler(uploadProgress.fractionCompleted);});
            }
                                              completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                  if (error) {
                                                      [Bugly reportError:error];
                                                      errHandler(error);
                                                  } else {
                                                      completeHandler(responseObject);
                                                  }
                                              }];
            [uploadTask resume];
            
        } @catch (NSException *exception) {
            
        }
}

/**
 上传单张图片

 @param url url地址
 @param params 参数
 @param imageData 图片
 @param fileName 文件名
 @param key 文件类型
 @param successBlock 访问成功
 @param failureBlock 访问失败
 */
-(void)uploadImageWithURL:(NSString *)url params:(NSDictionary *)params image:(NSData *)imageData fileName:(NSString *)fileName key:(NSString *)key successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
        @try {
            
            url = [self handleUrlWithParamWithStr:url];
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            if ([DSNetWorkStatus sharedNetWorkStatus].netWorkStatus == NotReachable) {
                failureBlock(nil,-200,[TipMessage shared].tipMessage.errorMsgNetworkUnavailable);
                return;
            }
            
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            manager.responseSerializer = responseSerializer;
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            NSString *userJsessionid = [UserDefaults objectForKey:@"sessionid"];
            NSString *userToken = [UserDefaults objectForKey:@"token"];
            if (userJsessionid.length!=0) {
                [manager.requestSerializer setValue:userJsessionid forHTTPHeaderField:@"sessionid"];
            }
            if (userToken.length!=0) {
                [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"token"];
            }
            
            [manager.requestSerializer setValue:[DSUtils getUUIDString] forHTTPHeaderField:@"deviceId"];
            [manager.requestSerializer setValue:[DSUtils generateRandomStringWithLength:10] forHTTPHeaderField:@"randomCode"];
            [manager.requestSerializer setValue:@"iOSApp" forHTTPHeaderField:@"Request-From"];
            [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:params error:nil];
            manager.securityPolicy = [self customSecurityPolicy];
            
            [manager POST:url parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                NSData *data = [self imageData:image];
                [formData appendPartWithFileData:imageData
                                            name:key          //服务器接收的key
                                        fileName:fileName           //文件名称
                                        mimeType:@"image/jpeg"];     //文件类型(根据不同情况自行修改)
            }
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      
                      NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                      successBlock(responseObject,response.statusCode);
            }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      
                      NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                      NSString *strErrorMsg;
                      if (response.statusCode == 401) {
                          //                    [[UserManager sharedUserManager] logout];
                          strErrorMsg = [TipMessage shared].tipMessage.errorMsg401;
                          [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedLogin object:nil];
                      } else if (response.statusCode/100 == 5) {
                          strErrorMsg = [TipMessage shared].tipMessage.errorMsg50x;
                      } else if (response.statusCode/100 == 3) {
                          strErrorMsg = [TipMessage shared].tipMessage.errorMsg30x;
                      } else {
                          strErrorMsg = [error localizedDescription];
                      }
                      [Bugly reportError:error];
                      failureBlock(error,response.statusCode,strErrorMsg);
                
            }];
        } @catch (NSException *exception) {
            
        }
}

/*!
 *  @brief 字典转Json字符串
 *
 *  @param object 字典
 *
 *  @return Json字符串
 */
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData;
    if (object != nil) {
        jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                   options:NSJSONWritingPrettyPrinted
                    // Pass 0 if you don't care about the readability of the generated string
                                                     error:&error];
    }
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if(jsonString == nil){
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


-(NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024)
        {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}
// 把传入的参数按照get的方式打包到url后面。
+ (NSString *)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params
{
    if (nil == url) {
        return @"";
    }
    
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:url];
    // Convert the params into a query string
    if (params) {
        for(id key in params) {
            NSString *sKey = [key description];
            NSString *sVal = [[params objectForKey:key] description];
            //是否有？，必须处理这个
            if ([urlWithQuerystring rangeOfString:@"?"].location==NSNotFound) {
                [urlWithQuerystring appendFormat:@"?%@=%@", [NSString urlEscape:sKey], [NSString urlEscape:sVal]];
            } else {
                [urlWithQuerystring appendFormat:@"&%@=%@", [NSString urlEscape:sKey], [NSString urlEscape:sVal]];
            }
        }
    }
    return urlWithQuerystring;
}


/**
 *  先调整分辨率，分辨率可以自己设定一个值，大于的就缩小到这分辨率，小余的就保持原本分辨率。然后在判断图片数据大小，传入范围maxSize = 100 ，大于的再压缩，小的就保持原样
 */
-(NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize {
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);      CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();     UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    // 判断是否大于传入的值
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);         return finallImageData;
    }
    
    return imageData;
}

- (AFSecurityPolicy*)customSecurityPolicy {
    ///先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ljdnginx" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = @[certData];
    return securityPolicy;
}
@end
