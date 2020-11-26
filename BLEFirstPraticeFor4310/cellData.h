//
//  cellData.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/8.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface cellData : UIViewController
{
    CBPeripheral *peripheral;
    NSData *now_Charact;
    NSData *previous_Charact;
    NSData *now_Baby_Infor;
    NSData *current_Characteristic;
    NSMutableArray *stored_Movemebt_State;
    NSString *device_Name;
    NSString *device_ID;
    NSString *device_Sex;
    
    NSString* First_Str;
    NSString* Second_Str;
    NSString* Third_Str;
}
/*!
 * @param Pheripheral : 用來儲存整個 device 的資訊
 * @param Now_Charact : 這次所 update 的 device 傳輸的資訊，包含 x,y,z 的位置以及四個溫度 senser 和電池以及 check sum
 * @param Previous_Charact : 上次的 characteristic
 * @param Now_Baby_Infor : 這次的嬰兒資訊，如儲存在裝置內的裝置名稱以及性別等等其他資訊
 * @param Current_Characteristic : 每次所獲得的 characteristic，目的是為了讓每次 UI 都能做繪圖
 *  @discussion
 *      A back-pointer to the service this characteristic belongs to.
 *
 */
- (void)
addObj                  :(nullable CBPeripheral *)   Pheripheral
nowDeviceInformationCharacteristic       :(nullable NSData *)         Now_Charact
previousCharacteristic  :(nullable NSData *)         Previous_Charact
nowBabyInformationCharacteristic      :(nullable NSData *)         Now_Baby_Infor
CurrentCharacteristic   :(nullable NSData *)         Current_Characteristic
storedMovementState     :(nullable NSMutableArray *) Stored_Movement_State
deviceName              :(nullable NSString *)       Device_Name
deviceID                :(nullable NSString *)       Device_ID
deviceSex               :(nullable NSString *)       Device_Sex;

- (CBPeripheral *) getPheripheral;
- (NSData *) getNowDeviceInformationCharacteristic;
- (NSData *) getPreviousCharacteristic;
- (NSData *) getNowBabyInformationCharacteristic;
- (NSData *) getCurrentCharacteristic;
- (NSMutableArray *) getStoredMovementState;
- (NSString *) getDeviceName;
- (NSString *) getDeviceID;
- (NSString *) getDeviceSex;

@end

NS_ASSUME_NONNULL_END
