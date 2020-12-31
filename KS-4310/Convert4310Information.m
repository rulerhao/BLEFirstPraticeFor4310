//
//  Convert4310Information.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/7.
//

#import "Convert4310Information.h"
#import "StringProcessFunc.h"

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
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    

    NSInteger X1_Position = 4;
    NSInteger X2_Position = 5;
    
    NSRange X1_Range;
    X1_Range.location = X1_Position * 2;
    X1_Range.length = 2;
    
    NSRange X2_Range;
    X2_Range.location = X2_Position * 2;
    X2_Range.length = 2;
    
    
    NSString *X1_String = [HexString substringWithRange:(X1_Range)];
    NSInteger X1_Value = [CalculateFunc getIntegerFromHexString:X1_String];
    
    NSString *X2_String = [HexString substringWithRange:(X2_Range)];
    NSInteger X2_Value = [CalculateFunc getIntegerFromHexString:X2_String];
    
    NSInteger X_Location = X1_Value / 16 + X2_Value * 16;
     
    return X_Location;
}

- (NSInteger) get_Location_Y:(NSData *) data_Bytes {
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    NSInteger Y1_Position = 6;
    NSInteger Y2_Position = 7;
    
    NSRange Y1_Range;
    Y1_Range.location = Y1_Position * 2;
    Y1_Range.length = 2;
    
    NSRange Y2_Range;
    Y2_Range.location = Y2_Position * 2;
    Y2_Range.length = 2;
    
    NSString *Y1_String = [HexString substringWithRange:(Y1_Range)];
    NSInteger Y1_Value = [CalculateFunc getIntegerFromHexString:Y1_String];
    
    NSString *Y2_String = [HexString substringWithRange:(Y2_Range)];
    NSInteger Y2_Value = [CalculateFunc getIntegerFromHexString:Y2_String];
    
    NSInteger Y_Location = Y1_Value / 16 + Y2_Value * 16;
     
    return Y_Location;
}

- (NSInteger) get_Location_Z:(NSData *) data_Bytes {
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    
    NSInteger Z1_Position = 8;
    NSInteger Z2_Position = 9;
    
    NSRange Z1_Range;
    Z1_Range.location = Z1_Position * 2;
    Z1_Range.length = 2;
    
    NSRange Z2_Range;
    Z2_Range.location = Z2_Position * 2;
    Z2_Range.length = 2;
    
    NSString *Z1_String = [HexString substringWithRange:(Z1_Range)];
    NSInteger Z1_Value = [CalculateFunc getIntegerFromHexString:Z1_String];
    
    NSString *Z2_String = [HexString substringWithRange:(Z2_Range)];
    NSInteger Z2_Value = [CalculateFunc getIntegerFromHexString:Z2_String];
    
    NSInteger Z_Location = Z1_Value / 16 + Z2_Value * 16;
     
    return Z_Location;
}

- (Boolean)
get_Movement_Status :(NSInteger) X
y                   :(NSInteger) Y
z                   :(NSInteger) Z
previous_x          :(NSInteger) previous_X
previous_y          :(NSInteger) previous_Y
previous_z          :(NSInteger) previous_Z {
    NSInteger Movement_Mode = 1;
    NSInteger Diff_X = ABS(X - previous_X);
    NSInteger Diff_Y = ABS(Y - previous_Y);
    NSInteger Diff_Z = ABS(Z - previous_Z);
    
    NSInteger range1, range2, range3;
    switch (Movement_Mode) {
        case 0:
            range1 = 2;
            range2 = 1;
            range3 = 3;
            break;
        case 1:
            range1 = 4;
            range2 = 3;
            range3 = 7;
            break;
        case 2:
            range1 = 4 * 100;
            range2 = 3 * 100;
            range3 = 7 * 100;
            break;
        default:
            range1 = 4;
            range2 = 3;
            range3 = 7;
            break;
    }
    
    Boolean Movement_Boolean;
    if((Diff_X + Diff_Y > range1 || Diff_Y + Diff_Z > range1 || Diff_X + Diff_Z > range1) ||
       (Diff_X > range2 || Diff_Y > range2 || Diff_Z > range2) ||
       (Diff_X + Diff_Y + Diff_Z >= range3)) {
        Movement_Boolean = true;
    }
    else {
        Movement_Boolean = false;
    }
    return Movement_Boolean;
}

- (float)getTemperature_1:(NSData *) data_Bytes {
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    
    NSInteger T1_Position = 10;
    NSInteger T2_Position = 11;
    
    NSRange T1_Range;
    T1_Range.location = T1_Position * 2;
    T1_Range.length = 2;
    
    NSRange T2_Range;
    T2_Range.location = T2_Position * 2;
    T2_Range.length = 2;
    
    NSString *T1_String = [HexString substringWithRange:(T1_Range)];
    NSInteger T1_Value = [CalculateFunc getIntegerFromHexString:T1_String];
    
    NSString *T2_String = [HexString substringWithRange:(T2_Range)];
    NSInteger T2_Value = [CalculateFunc getIntegerFromHexString:T2_String];
    
    float Temperature_1 = (T1_Value * 256 + T2_Value) / 10.0f;
     
    return Temperature_1;
}

- (float)getTemperature_2:(NSData *) data_Bytes {
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    
    NSInteger T1_Position = 12;
    NSInteger T2_Position = 13;
    
    NSRange T1_Range;
    T1_Range.location = T1_Position * 2;
    T1_Range.length = 2;
    
    NSRange T2_Range;
    T2_Range.location = T2_Position * 2;
    T2_Range.length = 2;
    
    NSString *T1_String = [HexString substringWithRange:(T1_Range)];
    NSInteger T1_Value = [CalculateFunc getIntegerFromHexString:T1_String];
    
    NSString *T2_String = [HexString substringWithRange:(T2_Range)];
    NSInteger T2_Value = [CalculateFunc getIntegerFromHexString:T2_String];
    
    float Temperature_2 = (T1_Value * 256 + T2_Value) / 10.0f;
     
    return Temperature_2;
}

- (float)getTemperature_3:(NSData *) data_Bytes {
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    
    NSInteger T1_Position = 14;
    NSInteger T2_Position = 15;
    
    NSRange T1_Range;
    T1_Range.location = T1_Position * 2;
    T1_Range.length = 2;
    
    NSRange T2_Range;
    T2_Range.location = T2_Position * 2;
    T2_Range.length = 2;
    
    NSString *T1_String = [HexString substringWithRange:(T1_Range)];
    NSInteger T1_Value = [CalculateFunc getIntegerFromHexString:T1_String];
    
    NSString *T2_String = [HexString substringWithRange:(T2_Range)];
    NSInteger T2_Value = [CalculateFunc getIntegerFromHexString:T2_String];
    
    float Temperature_3 = (T1_Value * 256 + T2_Value) / 10.0f;
     
    return Temperature_3;
}

- (float)getTemperature_4:(NSData *) data_Bytes {
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    
    NSInteger T1_Position = 17;
    NSInteger T2_Position = 18;
    
    NSRange T1_Range;
    T1_Range.location = T1_Position * 2;
    T1_Range.length = 2;
    
    NSRange T2_Range;
    T2_Range.location = T2_Position * 2;
    T2_Range.length = 2;
    
    NSString *T1_String = [HexString substringWithRange:(T1_Range)];
    NSInteger T1_Value = [CalculateFunc getIntegerFromHexString:T1_String];
    
    NSString *T2_String = [HexString substringWithRange:(T2_Range)];
    NSInteger T2_Value = [CalculateFunc getIntegerFromHexString:T2_String];
    
    float Temperature_4 = (T1_Value * 256 + T2_Value) / 10.0f;
     
    return Temperature_4;
}

- (NSUInteger)getBattery_Volume:(NSData *) data_Bytes {
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    
    NSInteger Battery_Position = 16;
    
    NSRange Battery_Range;
    Battery_Range.location = Battery_Position * 2;
    Battery_Range.length = 2;
    
    NSString *Battery_String = [HexString substringWithRange:(Battery_Range)];
    NSInteger Battery_Value = [CalculateFunc getIntegerFromHexString:Battery_String];
    
    NSUInteger Battery_Volume = Battery_Value;
     
    return Battery_Volume;
}

- (NSString *) getDeviceName:(NSData *) data_Bytes {
    StringProcessFunc *str_Process_Func = [[StringProcessFunc alloc] init];
    
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    NSUInteger Position = 1;
    NSUInteger Length = 8;
    NSLog(@"Merged_InformationsAgain:%@", HexString);
    NSString *Split_String = [str_Process_Func getSubString:HexString
                                    length      :Length * 2
                                    location    :Position * 2];
    
    NSString *ASCIIString = [CalculateFunc HexStringToASCIIString:Split_String];
    
    return ASCIIString;
}

- (NSString *) getDeviceID : (NSData *) data_Bytes {
    StringProcessFunc *str_Process_Func = [[StringProcessFunc alloc] init];
    
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    NSUInteger Position = 9;
    NSUInteger Length = 2;
    
    NSString *Split_String = [str_Process_Func getSubString:HexString
                                    length      :Length * 2
                                    location    :Position * 2];
    
    NSString *First_String = [str_Process_Func getSubString:Split_String
                                    length      :1 * 2
                                    location    :0 * 2];
    
    NSString *Second_String = [str_Process_Func getSubString:Split_String
                                    length      :1 * 2
                                    location    :1 * 2];
    
    if([First_String  isEqual: @"00"]) {
        First_String = @"30";
    }
    
    if([Second_String  isEqual: @"00"]) {
        Second_String = @"30";
    }
    
    NSString *Merged_String = [str_Process_Func MergeTwoString :   First_String
                                             SecondStr      :   Second_String];
    
    NSString *ASCIIString = [CalculateFunc HexStringToASCIIString:Merged_String];
    
    
    return ASCIIString;
}

- (NSString *) getDeviceSex : (NSData *) data_Bytes {
    StringProcessFunc *str_Process_Func = [[StringProcessFunc alloc] init];
    
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    NSString *HexString = [CalculateFunc getHEX:data_Bytes];
    
    NSUInteger Position = 11;
    NSUInteger Length = 1;
    
    NSString *Split_String = [str_Process_Func getSubString:HexString
                                               length      :Length * 2
                                               location    :Position * 2];
    
    if(![Split_String  isEqual: @"30"] && ![Split_String  isEqual: @"31"]) {
        Split_String = @"30";
    }
    
    if([Split_String isEqual:@"30"]) {
        return @"0";
    }
    else {
        return @"1";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*!
 * @param data : 要被轉換為 Hex String 的 NSData
 *  @discussion
 *      將 NSData 轉換為 HexString
 *
 */

- (NSMutableArray *)
refreshMovementState       : (CBCharacteristic*)   characteristic
nowStoredMovementState  : (NSMutableArray *)    now_Stored_Movement_State
storedDevices           : (NSMutableArray *)    StoredDevices
movementScanTime        : (NSInteger)           MovementScanTime
index                   : (NSUInteger)          index {
    
        
        NSInteger Location_X = [self get_Location_X:[characteristic value]];
        NSInteger Location_Y = [self get_Location_Y:[characteristic value]];
        NSInteger Location_Z = [self get_Location_Z:[characteristic value]];
        
        NSData *Previous_Characteristic = [[StoredDevices objectAtIndex:index] getPreviousCharacteristic];
        
        NSInteger Previous_Location_X = [self get_Location_X:Previous_Characteristic];
        NSInteger Previous_Location_Y = [self get_Location_Y:Previous_Characteristic];
        NSInteger Previous_Location_Z = [self get_Location_Z:Previous_Characteristic];
        
        Boolean now_Movement_Status = [self get_Movement_Status    :Location_X
                                               y                      :Location_Y
                                               z                      :Location_Z
                                               previous_x             :Previous_Location_X
                                               previous_y             :Previous_Location_Y
                                               previous_z             :Previous_Location_Z];
        
        now_Stored_Movement_State = [[StoredDevices objectAtIndex:index] getStoredMovementState];
        
        /**
         * 建立一個儲存十五秒位置變化是否正常的 array
         */
        // 如果未滿的時候
        if([now_Stored_Movement_State count] < MovementScanTime) {
            NSLog(@"now_Movement_Statusacc = %hhu", now_Movement_Status);
            [now_Stored_Movement_State addObject: [NSNumber numberWithBool:now_Movement_Status]];
            NSLog(@"now_Stored_Movement_State_Inside = %@", now_Stored_Movement_State);
        }
        // 如果滿位置的時候
        else {
            for(NSInteger i = 0; i < [now_Stored_Movement_State count] - 1; i++) {
                [now_Stored_Movement_State replaceObjectAtIndex:i
                                                     withObject:[now_Stored_Movement_State
                                                  objectAtIndex:i + 1]];
            }
            [now_Stored_Movement_State replaceObjectAtIndex:[now_Stored_Movement_State count] - 1
                                                 withObject:[NSNumber numberWithBool:now_Movement_Status]];
        }
    NSLog(@"now_Stored_Movement_State_Inside = %@", now_Stored_Movement_State);
    return now_Stored_Movement_State;
}
@end
