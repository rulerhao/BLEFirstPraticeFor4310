// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: sensor.proto

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

@class Sensor_BatteryProperty;
@class Sensor_BreathProperty;
@class Sensor_MotionProperty;
@class Sensor_TemperatureProperty;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SensorRoot

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
GPB_FINAL @interface SensorRoot : GPBRootObject
@end

#pragma mark - Sensor

typedef GPB_ENUM(Sensor_FieldNumber) {
  Sensor_FieldNumber_Index = 1,
  Sensor_FieldNumber_TemperatureProperty = 10,
  Sensor_FieldNumber_BatteryProperty = 11,
  Sensor_FieldNumber_BreathProperty = 12,
};

typedef GPB_ENUM(Sensor_Property_OneOfCase) {
  Sensor_Property_OneOfCase_GPBUnsetOneOfCase = 0,
  Sensor_Property_OneOfCase_TemperatureProperty = 10,
  Sensor_Property_OneOfCase_BatteryProperty = 11,
  Sensor_Property_OneOfCase_BreathProperty = 12,
};

/**
 * 感應器
 **/
GPB_FINAL @interface Sensor : GPBMessage

/**
 * 感應器的索引 , zero base , 若裝置中有不同的感應器類型，每一種不同的感應器都從 zero 開始算起
 * 例如 3溫度感應器 + 1電源感應器 分別是 0,1,2 及 0 去區分
 **/
@property(nonatomic, readwrite) int32_t index;

@property(nonatomic, readonly) Sensor_Property_OneOfCase propertyOneOfCase;

@property(nonatomic, readwrite, strong, null_resettable) Sensor_TemperatureProperty *temperatureProperty;

@property(nonatomic, readwrite, strong, null_resettable) Sensor_BatteryProperty *batteryProperty;

@property(nonatomic, readwrite, strong, null_resettable) Sensor_BreathProperty *breathProperty;

@end

/**
 * Clears whatever value was set for the oneof 'property'.
 **/
void Sensor_ClearPropertyOneOfCase(Sensor *message);

#pragma mark - Sensor_TemperatureProperty

typedef GPB_ENUM(Sensor_TemperatureProperty_FieldNumber) {
  Sensor_TemperatureProperty_FieldNumber_Value = 1,
};

/**
 * *
 * 溫度感應器
 **/
GPB_FINAL @interface Sensor_TemperatureProperty : GPBMessage

/** 溫度值 */
@property(nonatomic, readwrite) float value;

@end

#pragma mark - Sensor_BatteryProperty

typedef GPB_ENUM(Sensor_BatteryProperty_FieldNumber) {
  Sensor_BatteryProperty_FieldNumber_Value = 1,
};

/**
 * *
 * 電池屬性
 **/
GPB_FINAL @interface Sensor_BatteryProperty : GPBMessage

/** 電量 , 0~100 的值 */
@property(nonatomic, readwrite) int32_t value;

@end

#pragma mark - Sensor_BreathProperty

typedef GPB_ENUM(Sensor_BreathProperty_FieldNumber) {
  Sensor_BreathProperty_FieldNumber_Value = 1,
  Sensor_BreathProperty_FieldNumber_MotionProperty = 2,
};

/**
 * *
 * 呼吸感測器
 **/
GPB_FINAL @interface Sensor_BreathProperty : GPBMessage

/** 是否有呼吸 */
@property(nonatomic, readwrite) BOOL value;

@property(nonatomic, readwrite, strong, null_resettable) Sensor_MotionProperty *motionProperty;
/** Test to see if @c motionProperty has been set. */
@property(nonatomic, readwrite) BOOL hasMotionProperty;

@end

#pragma mark - Sensor_MotionProperty

typedef GPB_ENUM(Sensor_MotionProperty_FieldNumber) {
  Sensor_MotionProperty_FieldNumber_ValueX = 1,
  Sensor_MotionProperty_FieldNumber_ValueY = 2,
  Sensor_MotionProperty_FieldNumber_ValueZ = 3,
};

/**
 * 運動感應器
 **/
GPB_FINAL @interface Sensor_MotionProperty : GPBMessage

@property(nonatomic, readwrite) float valueX;

@property(nonatomic, readwrite) float valueY;

@property(nonatomic, readwrite) float valueZ;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
