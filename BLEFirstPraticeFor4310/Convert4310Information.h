//
//  Convert4310Information.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/7.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Convert4310Information : ViewController

- (NSInteger) get_Location_X:(NSData *) data_Bytes;
- (NSInteger) get_Location_Y:(NSData *) data_Bytes;
- (NSInteger) get_Location_Z:(NSData *) data_Bytes;

- (float)getTemperature_1:(NSData *) data_Bytes;
- (float)getTemperature_2:(NSData *) data_Bytes;
- (float)getTemperature_3:(NSData *) data_Bytes;
- (float)getTemperature_4:(NSData *) data_Bytes;

- (NSUInteger)getBattery_Volume:(NSData *) data_Bytes;


@end

NS_ASSUME_NONNULL_END
