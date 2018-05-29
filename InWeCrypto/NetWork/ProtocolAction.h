//
//  ProtocolAction.h
//  InWeCrypto
//
//  Created by yy on 2018/5/25.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#ifndef ProtocolAction_h
#define ProtocolAction_h

#pragma mark - 请求参数名
#ifndef __PARAMETER_NAME
#define __PARAMETER_NAME
#define CODE                    @"code"
#define MSG                     @"msg"
#define MIN_BLOCK_NUM           @"min_block_num"
#define BPS                     @"bps"
#define VALUE                   @"value"
#define LIST                    @"list"
#define NAME                    @"name"
#define GNT_CATEGORY            @"gnt_category"
#define CAP                     @"cap"
#define PRICE_CNY               @"price_cny"
#define PRICE_USD               @"price_usd"
#define BALANCE                 @"balance"
#define RECORD                  @"record"
#define GNT                     @"gnt"
#define DECIMALS                @"decimals"
#define WALLET_ID               @"wallet_id"
#define FLAG                    @"flag"
#define PAGE                    @"page"
#define ASSET_ID                @"asset_id"

#define CONFIRM_AT              @"confirm_at"
#define CREATED_AT              @"created_at"
#define FEE                     @"fee"
#define HANDLE_FEE              @"handle_fee"
#define PAY_ADDRESS             @"pay_address"
#define RECEIVE_ADDRESS         @"receive_address"
#define REMARK                  @"remark"
#define TRADE_NO                @"trade_no"
#define BLOCK_NUMBER            @"block_number"
#define CATEGORY_ID             @"category_id"
#define CATEGORY                @"category"
#define AUTH_TX_ID              @"auth_tx_id"
#define AUTH_BLOCK              @"auth_block"
#define REDBAG                  @"redbag"
#define REDBAG_NUMBER           @"redbag_number"
#define REDBAG_ADDR             @"redbag_addr"
#define REDBAG_SYMBOL           @"redbag_symbol"
#define TRANSACTION_PARAM       @"transaction_param"
#define DATA                    @"data"
#define FEE_ADDR                @"fee_addr"
#define REDBAG_ID               @"redbag_id"
#define REDBAG_TX_NONCE         @"redbag_tx_nonce"
#define AUTH_TX_NONCE           @"auth_tx_nonce"
#define REPEAT_ID               @"repeat_id"
#define AUTH_GAS                @"auth_gas"

#endif

#pragma mark - 响应码
typedef enum _response_code{
    ResponseCodeSuccess = 4000, // 请求执行成功
    ResponseCodeUnLogin,         //未登陆
    ResponseCodeNoPermission, //无权限
    ResponseCodeNotFoundRoute,  //路由不存在
    ResponseCodeInvalidate,      // 验证不通过
    ResponseCodeNoFoundRecordData = 4005, // 查询数据不存在
    ResponseCodeFailed,          //请求执行失败
    ResponseCodeSuccessAndPush, //请求执行成功,即将跳转
    ResponseCodeUnRegister, // 未注册
    ResponseCodeTokenInvalidate, // token无效
    ResponseCodeTokenExpired = 4010, // token过期
    ResponseCodeAcountFrozen = 4011, // 用户账户被冻结
    ResponseCodeSendVerifySuccess = 5000, // 验证码发送成功
    ResponseCodeSendVerifyFailed, // 发送验证码失败，重试！
    ResponseCodeSendVerifyFailedAndRetry, //5002 发送验证码失败, N 秒后重试！(重复获取验证码)
    ResponseCodeVerityExpired, // 5003 验证码已失效！
    ResponseCodeVerityError, //  5004 验证码错误！
    ResponseCodeVerityUserDiff = 5005, // 与上次手机号不一致，请在 {$diff} 秒后重试！
    ResponseCodeVerityFailedNotAuthorizedUser, // 获取验证码失败, 不是授权用户！
    ResponseCodeSendVerityEmailFailed,  // 发送邮箱失败
    ResponseCodeSendVerityEmailSuccess = 5008, // 发送邮箱成功
    ResponseCodeWriteUserFailed = 5101, // 注册用户的时候写入User表失败
    ResponseCodeResetPasswordFailed = 5102, // 重置密码失败
    ResponseCodeCreateUserTokenFailed = 5201, // 创建用户token失败, 即登录失败
    ResponseCodeTokenToUserFailed = 5202,
    ResponseCodeCommentByOwn = 5301, // 用户自己评论自己
    ResponseCodeMessageCreateFailed = 5401, // 用户消息 写入消息表错误
    ResponseCodeAPIGetDataFailed = 5501, // 获取数据为空
    ResponseCodeAPIAddGroupUserFailed, // 添加组成员失败
    ResponseCodeAPIResetPasswordFailed = 5503, // 修改API用户密码失败
    ResponseCodeAPISendMsgFailed = 5505 // 发送API消息失败
}ResponseCode;
#define RESPONSE_CODE_TYPE(type) [NSString stringWithFormat:@"%d", type]

#endif /* ProtocolAction_h */
