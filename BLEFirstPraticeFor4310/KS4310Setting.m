//
//  KS4310Setting.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/25.
//

#import "KS4310Setting.h"

@interface KS4310Setting ()

@end

@implementation KS4310Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) InitKS4310Setting
{
    Movement_Scan_Time = 15;
    HighTemperatureword = 27;
    LowTemperature = 25;
    
    Identifier_Characteristic_Bytes_String_Cut_Start_Location = 0;
    
    Identifier_Characteristic_Bytes_String_Head_Length = 2;
    
    Identifier_From_Write_Characteristic_Bytes_String = @"05";
    Identifier_From_Write_Characteristic_Full_Bytes_String = @"0555aa";
    Identifier_From_Write_Characteristic_Full_Bytes_Length = 3;
    
    Identifier_From_Read_Characteristic_Bytes_String = @"04";
    
    Identifier_From_Recieve_Characteristic_Bytes_String = @"00";
    Identifier_From_Recieve_Characteristic_Full_Bytes_String = @"0000F8FA";
    Identifier_From_Recieve_Characteristic_Full_Bytes_String_Length = 8;
    Identifier_From_Recieve_Characteristic_Bytes_String_Cut_Location = 0;
}

@synthesize Movement_Scan_Time;
@synthesize HighTemperatureword;
@synthesize LowTemperature;

@synthesize Identifier_Characteristic_Bytes_String_Cut_Start_Location;

@synthesize Identifier_Characteristic_Bytes_String_Head_Length;

@synthesize Identifier_From_Write_Characteristic_Bytes_String;
@synthesize Identifier_From_Write_Characteristic_Full_Bytes_String;
@synthesize Identifier_From_Write_Characteristic_Full_Bytes_Length;

@synthesize Identifier_From_Read_Characteristic_Bytes_String;

@synthesize Identifier_From_Recieve_Characteristic_Bytes_String;
@synthesize Identifier_From_Recieve_Characteristic_Full_Bytes_String;
@synthesize Identifier_From_Recieve_Characteristic_Full_Bytes_String_Length;
@synthesize Identifier_From_Recieve_Characteristic_Bytes_String_Cut_Location;

@end
