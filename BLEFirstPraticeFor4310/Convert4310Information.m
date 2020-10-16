//
//  Convert4310Information.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/7.
//

#import "Convert4310Information.h"

@interface Convert4310Information ()

@end

@implementation Convert4310Information

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*
 [0] : 0x00
 [1] : 0x00
 [2] : 0xF8
 [3] : 0xFA
 [4] : X1
 [5] : X2
 [6] : Y1
 [7] : Y2
 [8] : Z1
 [9] : Z2
 [10]: T1/256
 [11]: T1%256
 [12]: T2/256
 [13]: T2%256
 [14]: T3/256
 [15]: T3%256
 [16]: Battery Volume
 [17]: T4/256
 [18]: T4%256
 [19]: 0
 for(k2 = 0;k2 < 19; k2++) {
    [19] += [k2];
    [19] = ~[19] + 1;
 }
 0~18 之和的補數+1應為[19]
 */
- (NSInteger) get_Location_X:(NSData *) data_Bytes {
    NSString *HexString = [self getHEX:data_Bytes];
    

    NSInteger X1_Position = 4;
    NSInteger X2_Position = 5;
    
    NSRange X1_Range;
    X1_Range.location = X1_Position * 2;
    X1_Range.length = 2;
    
    NSRange X2_Range;
    X2_Range.location = X2_Position * 2;
    X2_Range.length = 2;
    
    NSString *X1_String = [HexString substringWithRange:(X1_Range)];
    NSInteger X1_Value = [self getIntegerFromHexString:X1_String];
    
    NSString *X2_String = [HexString substringWithRange:(X2_Range)];
    NSInteger X2_Value = [self getIntegerFromHexString:X2_String];
    
    NSInteger X_Location = X1_Value / 16 + X2_Value * 16;
     
    return X_Location;
}

- (NSInteger) get_Location_Y:(NSData *) data_Bytes {
    NSString *HexString = [self getHEX:data_Bytes];
    
    NSInteger Y1_Position = 6;
    NSInteger Y2_Position = 7;
    
    NSRange Y1_Range;
    Y1_Range.location = Y1_Position * 2;
    Y1_Range.length = 2;
    
    NSRange Y2_Range;
    Y2_Range.location = Y2_Position * 2;
    Y2_Range.length = 2;
    
    NSString *Y1_String = [HexString substringWithRange:(Y1_Range)];
    NSInteger Y1_Value = [self getIntegerFromHexString:Y1_String];
    
    NSString *Y2_String = [HexString substringWithRange:(Y2_Range)];
    NSInteger Y2_Value = [self getIntegerFromHexString:Y2_String];
    
    NSInteger Y_Location = Y1_Value / 16 + Y2_Value * 16;
     
    return Y_Location;
}

- (NSInteger) get_Location_Z:(NSData *) data_Bytes {
    NSString *HexString = [self getHEX:data_Bytes];
    
    
    NSInteger Z1_Position = 8;
    NSInteger Z2_Position = 9;
    
    NSRange Z1_Range;
    Z1_Range.location = Z1_Position * 2;
    Z1_Range.length = 2;
    
    NSRange Z2_Range;
    Z2_Range.location = Z2_Position * 2;
    Z2_Range.length = 2;
    
    NSString *Z1_String = [HexString substringWithRange:(Z1_Range)];
    NSInteger Z1_Value = [self getIntegerFromHexString:Z1_String];
    
    NSString *Z2_String = [HexString substringWithRange:(Z2_Range)];
    NSInteger Z2_Value = [self getIntegerFromHexString:Z2_String];
    
    NSInteger Z_Location = Z1_Value / 16 + Z2_Value * 16;
     
    return Z_Location;
}

- (float)getTemperature_1:(NSData *) data_Bytes {
    NSString *HexString = [self getHEX:data_Bytes];
    
    
    NSInteger T1_Position = 10;
    NSInteger T2_Position = 11;
    
    NSRange T1_Range;
    T1_Range.location = T1_Position * 2;
    T1_Range.length = 2;
    
    NSRange T2_Range;
    T2_Range.location = T2_Position * 2;
    T2_Range.length = 2;
    
    NSString *T1_String = [HexString substringWithRange:(T1_Range)];
    NSInteger T1_Value = [self getIntegerFromHexString:T1_String];
    
    NSString *T2_String = [HexString substringWithRange:(T2_Range)];
    NSInteger T2_Value = [self getIntegerFromHexString:T2_String];
    
    float Temperature_1 = (T1_Value * 256 + T2_Value) / 10.0f;
     
    return Temperature_1;
}

- (float)getTemperature_2:(NSData *) data_Bytes {
    NSString *HexString = [self getHEX:data_Bytes];
    
    
    NSInteger T1_Position = 12;
    NSInteger T2_Position = 13;
    
    NSRange T1_Range;
    T1_Range.location = T1_Position * 2;
    T1_Range.length = 2;
    
    NSRange T2_Range;
    T2_Range.location = T2_Position * 2;
    T2_Range.length = 2;
    
    NSString *T1_String = [HexString substringWithRange:(T1_Range)];
    NSInteger T1_Value = [self getIntegerFromHexString:T1_String];
    
    NSString *T2_String = [HexString substringWithRange:(T2_Range)];
    NSInteger T2_Value = [self getIntegerFromHexString:T2_String];
    
    float Temperature_2 = (T1_Value * 256 + T2_Value) / 10.0f;
     
    return Temperature_2;
}

- (float)getTemperature_3:(NSData *) data_Bytes {
    NSString *HexString = [self getHEX:data_Bytes];
    
    
    NSInteger T1_Position = 14;
    NSInteger T2_Position = 15;
    
    NSRange T1_Range;
    T1_Range.location = T1_Position * 2;
    T1_Range.length = 2;
    
    NSRange T2_Range;
    T2_Range.location = T2_Position * 2;
    T2_Range.length = 2;
    
    NSString *T1_String = [HexString substringWithRange:(T1_Range)];
    NSInteger T1_Value = [self getIntegerFromHexString:T1_String];
    
    NSString *T2_String = [HexString substringWithRange:(T2_Range)];
    NSInteger T2_Value = [self getIntegerFromHexString:T2_String];
    
    float Temperature_3 = (T1_Value * 256 + T2_Value) / 10.0f;
     
    return Temperature_3;
}

- (float)getTemperature_4:(NSData *) data_Bytes {
    NSString *HexString = [self getHEX:data_Bytes];
    
    
    NSInteger T1_Position = 17;
    NSInteger T2_Position = 18;
    
    NSRange T1_Range;
    T1_Range.location = T1_Position * 2;
    T1_Range.length = 2;
    
    NSRange T2_Range;
    T2_Range.location = T2_Position * 2;
    T2_Range.length = 2;
    
    NSString *T1_String = [HexString substringWithRange:(T1_Range)];
    NSInteger T1_Value = [self getIntegerFromHexString:T1_String];
    
    NSString *T2_String = [HexString substringWithRange:(T2_Range)];
    NSInteger T2_Value = [self getIntegerFromHexString:T2_String];
    
    float Temperature_4 = (T1_Value * 256 + T2_Value) / 10.0f;
     
    return Temperature_4;
}

- (NSUInteger)getBattery_Volume:(NSData *) data_Bytes {
    NSString *HexString = [self getHEX:data_Bytes];
    
    
    NSInteger Battery_Position = 16;
    
    NSRange Battery_Range;
    Battery_Range.location = Battery_Position * 2;
    Battery_Range.length = 2;
    
    NSString *Battery_String = [HexString substringWithRange:(Battery_Range)];
    NSInteger Battery_Value = [self getIntegerFromHexString:Battery_String];
    
    NSUInteger Battery_Volume = Battery_Value;
     
    return Battery_Volume;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 convert NSData to NSString
 */
- (NSString *)getHEX:(NSData *)data
{
    const unsigned char *dataBytes = [data bytes];
    NSMutableString *ret = [NSMutableString stringWithCapacity:[data length] * 2];
    for (int i=0; i<[data length]; ++i)
    [ret appendFormat:@"%02lX", (unsigned long)dataBytes[i]];
    return ret;
}

- (NSInteger)getIntegerFromHexString:(NSString *) str{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner scanHexInt:&outVal];
    NSInteger IntegerValue = outVal;
    return IntegerValue;
}

@end
