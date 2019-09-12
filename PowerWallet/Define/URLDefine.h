//
//  URLDefine.h
//  Demo
//
//  Created by Krisc.Zampono on 15/5/27.
//  Copyright (c) 2015年 Krisc.Zampono. All rights reserved.
//

#ifndef Demo_URLDefine_h
#define Demo_URLDefine_h

#define BuglyID         @"0f7571efdc"
#define Base_URL        @"https://api.laijiudai.cn/ptapi/guanjia_api/"
#define Base_URL1       @"https://api.laijiudai.cn/ptapi/"
#define appstoreID          @"1329657656"
#define Base_Url2       @"http://api.laijiudai.cn/ptapi/isApproveVersion?clientType=ios&appVersion=%@"
#define KContrastVersion                        @"returnIosAppHao"
//判断AB版本
#define KJudgeVersion                           @"isApproveVersion"
/***************************注册登录**************************/
//注册验证码
#define KUserRegGetCode                         @"credit-user/reg-get-code"
//登录接口
#define kKDLoginKey                             @"credit-user/login"
//注册接口
#define kKDZhuceKey                             @"credit-user/register"
//退出登录接口
#define kKDLogoutKey                            @"credit-user/logout"
/***************************修改密码**************************/
#define KModifyLoginPassWord                    @"credit-user/change-pwd"
#define KResetPwdCode                           @"credit-user/reset-pwd-code"
#define KForgetPassWord                         @"credit-user/verify-reset-password"
#define KResetPassword                          @"credit-user/reset-password"
//找回交易密码设置新密码
#define kUserResetPayPassword                   @"credit-user/reset-pay-password"
//初次设置交易密码
#define kUserSetPaypassword                     @"credit-user/set-paypassword"
//修改交易密码
#define kUserChangePaypassword                  @"credit-user/change-paypassword"
//找回密码验证码
#define kUserVerifyResetPwdCode                 @"credit-user/reset-pwd-code"
//找回密码验证个人信息
#define kUserVerifyResetPassword                @"credit-user/verify-reset-password"
/***************************首页********************************/
///首页
#define KGetIndex                               @"partner/getPartnerList"
///商贷详情
#define KGetLendDesc                            @"partner/getPartnerInfo"
#define ReportStatistics                        @"partner/reportPartnerInfo"
/***************************帮你贷********************************/
///帮你贷首页
#define KGetHelpYouLendIndex                    @"help-loan/index"
///帮你贷验证是否可以申请
#define KCheckApply                             @"help-loan/checkApply"
///申请详情
#define KGetApplyDetail                         @"help-loan/applyDetail"
///提交申请
#define KSubmitApply                            @"help-loan/toApply"
///申请结果
#define KGetApplyResult                         @"help-loan/applyResult"
#define KGetApplyInfo                           @"help-loan/apply"
/***************************借条***********************************/
///借条首页
#define KGetLendIndex                           @"applyBorrowOrder/applyBorrowOrderIndex"
///检测是否绑卡认证
#define KCheckBindApply                         @"applyBorrowOrder/authenticationInfoIf"
///获取添加借款参数
#define KGetApplyBorrowOrder                    @"applyBorrowOrder/getApplyBorrowOrderParam"
///增加我要借款
#define KAddApplyBorrowOrder                    @"applyBorrowOrder/saveApplyBorrowOrder"
///获取求借列表
#define KGetBorrowOrderfindList                 @"applyBorrowOrder/applyBorrowOrderfindList"
///获取添加出借参数
#define KGetgetBorrowOutParam                   @"borrowOut/getBorrowOutParam"
///增加我要出借
#define KAddBorrowOut                           @"borrowOut/borrowOutInfoSave"
///获取出借列表
#define KGetgetBorrowOutList                    @"borrowOut/getBorrowOurFind"
///获取借条列表
#define KGetLendList                            @"myBorrowPaper/getBorrowPaperList"
///首页求借列表
#define KGetRootLendList                        @"applyBorrowOrder/IndexList"
///首页出借列表
#define KGetRootOutLendList                     @"borrowOut/IndexList"
///首页求借详情
#define KGetRootLendData                        @"applyBorrowOrder/getApplyBorrowOrderDetail"
///首页出借详情
#define KGetRootOutListData                     @"borrowOut/getBorrowOutDetail"
///同意借条
#define KAgreeLend                              @"myBorrowPaper/confirmBorrowPaper"
///注销借条
#define KDeleteLend                             @"myBorrowPaper/askForLogoutBorrowOrder"
///查询还款流程
#define KChaxunRepay                            @"myBorrowPaper/repaymentProcedureInfo"
///用户反馈
#define KFeedLend                               @"myBorrowPaper/feedback"
///查询银行卡
#define KGetCardInfo                            @"guanjia_api/lianlianBindCardTg/get_card_info"
/***************************认证中心********************************/
///认证列表
#define KGetCertificationList                   @"credit-card/get-verification-info"
//获取个人信息
#define kCreditCardGetPersonInfo                @"credit-card/get-person-info"
//保存个人信息
#define kCreditCardSavePersonInfo               @"credit-card/get-person-infos"
//
#define kCreditInfoSavePersonInfo               @"credit-info/save-person-info"

//获取工作信息
#define kCreditCardGetWorkInfo                  @"credit-card/get-work-info"
//保存工作信息
#define kCreditCardSaveWorkInfo                 @"credit-card/save-work-info"

#define KGetUserNameAndId                       @"credit-loan/returnUserName"
#define kCreditCardAddBankCard                  @"credit-card/add-bank-card"
//连连数据加密
#define KGetSignRSA1                            @"signAse/signKey"
//上传连连绑卡成功信息
#define KSaveBindResult                         @"lianlianBindCardTg/bindingCardController"
///绑卡失败上传信息
#define KBindingCardState                       @"lianlianBindCardTg/bindingCardState"

//获取紧急联系人信息
#define kCreditCardGetContacts                  @"credit-card/get-contacts"
//保存紧急联系人信息
#define kCreditCardSaveContacts                 @"credit-card/get-contactss"
//上传照片列表
#define kPictureUploadImage                     @"picture/upload-image"
//获取照片列表
#define kPictureGetPicList                      @"picture/get-pic-list"
/***************************个人中心********************************/
#define kGetShareInfo                            @"user/my"
//上报app信息
#define kReportKey                              @"user/credit-app/device-report"
///意见反馈
#define KFeedBack                               @"credit-info/feedback"


/***************************账户相关********************************/
//检查当前版本是否需要更新接口
#define kCheckVersion                           @"versionsManagers/getVersionsInfo"

/***************************上报用户位置信息**************************/
#define KUserLocation                           @"credit-info/upload-location"

//上传通讯录
#define kInfoUpLoadContacts                     @"credit-info/up-load-contacts"
#define KZFB                                    @"credit-alipay/get-user-info"




/***************************上报用户位置信息**************************/
#define KUserAppInfo                            @"credit-info/up-load-contents"



#endif
