//
//  KS4310Setting.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/25.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KS4310Setting : UIViewController
{
    NSUInteger Movement_Scan_Time;
    NSUInteger HighTemperatureword;
    NSUInteger LowTemperature;
    
    NSUInteger Identifier_Characteristic_Bytes_String_Cut_Start_Location;
    
    NSUInteger Identifier_Characteristic_Bytes_String_Head_Length;
    
    NSString *Identifier_From_Write_Characteristic_Bytes_String;
    NSString *Identifier_From_Write_Characteristic_Full_Bytes_String;
    NSUInteger Identifier_From_Write_Characteristic_Full_Bytes_Length;
    
    NSString *Identifier_From_Read_Characteristic_Bytes_String;
    
    NSString *Identifier_From_Recieve_Characteristic_Bytes_String;
    NSString *Identifier_From_Recieve_Characteristic_Full_Bytes_String;
    NSUInteger Identifier_From_Recieve_Characteristic_Full_Bytes_String_Length;
    NSUInteger Identifier_From_Recieve_Characteristic_Bytes_String_Cut_Location;
    
    NSData *Sense_Identifier;
    NSData *Write_Identifier;
    NSData *Baby_Information_Identifier;
}
@property (readwrite, nonatomic) NSUInteger Movement_Scan_Time;
@property (readwrite, nonatomic) NSUInteger HighTemperatureword;
@property (readwrite, nonatomic) NSUInteger LowTemperature;

@property (readwrite, nonatomic) NSUInteger Identifier_Characteristic_Bytes_String_Cut_Start_Location;

@property (readwrite, nonatomic) NSUInteger Identifier_Characteristic_Bytes_String_Head_Length;

@property (readwrite, nonatomic) NSString *Identifier_From_Write_Characteristic_Bytes_String;
@property (readwrite, nonatomic) NSString *Identifier_From_Write_Characteristic_Full_Bytes_String;
@property (readwrite, nonatomic) NSUInteger Identifier_From_Write_Characteristic_Full_Bytes_Length;

@property (readwrite, nonatomic) NSString *Identifier_From_Read_Characteristic_Bytes_String;

@property (readwrite, nonatomic) NSString *Identifier_From_Recieve_Characteristic_Bytes_String;
@property (readwrite, nonatomic) NSString *Identifier_From_Recieve_Characteristic_Full_Bytes_String;
@property (readwrite, nonatomic) NSUInteger Identifier_From_Recieve_Characteristic_Full_Bytes_String_Length;
@property (readwrite, nonatomic) NSUInteger Identifier_From_Recieve_Characteristic_Bytes_String_Cut_Location;

@property (readwrite, nonatomic) NSData *Sense_Identifier;
@property (readwrite, nonatomic) NSData *Write_Identifier;
@property (readwrite, nonatomic) NSData *Baby_Information_Identifier;

- (void) InitKS4310Setting;

@end

NS_ASSUME_NONNULL_END
