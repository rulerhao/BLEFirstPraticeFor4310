// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: message.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30004
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30004 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class NotifyStatusRequest;
@class PostMeasureRequest;
@class RepostMeasureRequest;
@class Response;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum Response_ResponseCode

typedef GPB_ENUM(Response_ResponseCode) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  Response_ResponseCode_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  Response_ResponseCode_UnknowErrorCode = 0,
  Response_ResponseCode_Ok = 200,
  Response_ResponseCode_BadRequest = 400,
  Response_ResponseCode_Forbidden = 403,
  Response_ResponseCode_NotFound = 404,
  Response_ResponseCode_ServerError = 500,
};

GPBEnumDescriptor *Response_ResponseCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL Response_ResponseCode_IsValidValue(int32_t value);

#pragma mark - MessageRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
GPB_FINAL @interface MessageRoot : GPBRootObject
@end

#pragma mark - Message

typedef GPB_ENUM(Message_FieldNumber) {
  Message_FieldNumber_MessageId = 1,
  Message_FieldNumber_ClientId = 2,
  Message_FieldNumber_Response = 10,
  Message_FieldNumber_NotifyStatusRequest = 11,
  Message_FieldNumber_PostMeasureRequest = 12,
  Message_FieldNumber_RepostMeasureRequest = 13,
};

typedef GPB_ENUM(Message_Body_OneOfCase) {
  Message_Body_OneOfCase_GPBUnsetOneOfCase = 0,
  Message_Body_OneOfCase_Response = 10,
  Message_Body_OneOfCase_NotifyStatusRequest = 11,
  Message_Body_OneOfCase_PostMeasureRequest = 12,
  Message_Body_OneOfCase_RepostMeasureRequest = 13,
};

/**
 * *
 * 訊息
 **/
GPB_FINAL @interface Message : GPBMessage

/**
 * *
 * [[ 訊息代碼 ]]
 *
 * 編碼建議 :
 *
 * 1. 取得目前時間精確到小數點 3 位
 *    例如 2020-09-26 09:46:28.472 , 轉成 `1601113588472` 為整數
 * 2. 將訊息再轉為 16 進位 格式，可以縮小長度為 `174c9ce82f8`
 * 3. 如果使用 36 進位，則會更進一步縮成 `kfjhovlk` , 基本上 Server 不管編碼方式，只要確定 message_id 不會重複即可
 *
 * 若真的很頻繁發送訊息，建議保留最後一筆 message_id 比對是否重複，若重複，則自己 + 1
 **/
@property(nonatomic, readwrite, copy, null_resettable) NSString *messageId;

/**
 * *
 * 此值與 MQTT 登入使用的 CLIENT ID 是相同的
 *
 * 一定要填對 , 否則 Response 無法回應到正確的連接者
 **/
@property(nonatomic, readwrite, copy, null_resettable) NSString *clientId;

/** 資料主體 */
@property(nonatomic, readonly) Message_Body_OneOfCase bodyOneOfCase;

/** 訊息處理結果回應要求 */
@property(nonatomic, readwrite, strong, null_resettable) Response *response;

/** 裝置狀態通知 */
@property(nonatomic, readwrite, strong, null_resettable) NotifyStatusRequest *notifyStatusRequest;

/** 量測資料上傳要求 , 即時，會另外轉傳封包給相關 ClientID/UserUUID/OrgUUID */
@property(nonatomic, readwrite, strong, null_resettable) PostMeasureRequest *postMeasureRequest;

/** 回補量測資料，不會另外轉傳封包給相關 ClientID/UserUUID/OrgUUID */
@property(nonatomic, readwrite, strong, null_resettable) RepostMeasureRequest *repostMeasureRequest;

@end

/**
 * Clears whatever value was set for the oneof 'body'.
 **/
void Message_ClearBodyOneOfCase(Message *message);

#pragma mark - Response

typedef GPB_ENUM(Response_FieldNumber) {
  Response_FieldNumber_RequestMessageId = 1,
  Response_FieldNumber_Code = 2,
  Response_FieldNumber_Message = 3,
};

GPB_FINAL @interface Response : GPBMessage

/** 要求的訊息代碼，讓發送端比對的 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *requestMessageId;

@property(nonatomic, readwrite) Response_ResponseCode code;

@property(nonatomic, readwrite, copy, null_resettable) NSString *message;

@end

/**
 * Fetches the raw value of a @c Response's @c code property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t Response_Code_RawValue(Response *message);
/**
 * Sets the raw value of an @c Response's @c code property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetResponse_Code_RawValue(Response *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)