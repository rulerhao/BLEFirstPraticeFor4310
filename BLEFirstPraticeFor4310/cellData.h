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
    CBCharacteristic *now_Charact;
    CBCharacteristic *previous_Charact;
    CBCharacteristic *now_Baby_Infor;
    CBCharacteristic *previous_Baby_Infor;
    
    NSString* First_Str;
    NSString* Second_Str;
    NSString* Third_Str;
}
/*!
 * @param Pheripheral : 用來儲存整個 device 的資訊
 * @param Now_Charact : 這次所 update 的 device 傳輸的資訊，包含 x,y,z 的位置以及四個溫度 senser 和電池以及 check sum
 * @param Previous_Charact : 上次的 characteristic
 * @param Now_Baby_Infor : 這次的嬰兒資訊，如儲存在裝置內的裝置名稱以及性別等等其他資訊
 * @param Previous_Baby_Infor : 上次的嬰兒資訊，先存看看，沒用再刪掉
 *  @discussion
 *      A back-pointer to the service this characteristic belongs to.
 *
 */
- (void)
addObj                  :(nullable CBPeripheral *)   Pheripheral
nowCharacteristic       :(nullable CBCharacteristic *)         Now_Charact
previousCharacteristic  :(nullable CBCharacteristic *)         Previous_Charact
nowBabyInformation      :(nullable CBCharacteristic *)         Now_Baby_Infor
previousBabyInformation :(nullable CBCharacteristic *)         Previous_Baby_Infor;

- (CBPeripheral *) getPheripheral;
- (CBCharacteristic *) getNowCharacteristic;
- (CBCharacteristic *) getPreviousCharacteristic;
- (CBCharacteristic *) getNowBabyInformation;
- (CBCharacteristic *) getPreviousBabyInformation;

@end

NS_ASSUME_NONNULL_END
