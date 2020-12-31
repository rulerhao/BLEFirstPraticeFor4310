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
    
    // ---------------------- Identifier_NSData -----------------
    Sense_Identifier = [self stringToNSData:@"00"];
    Write_Identifier = [self stringToNSData:@"05"];
    Baby_Information_Identifier = [self stringToNSData:@"04"];
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

@synthesize Sense_Identifier;
@synthesize Write_Identifier;
@synthesize Baby_Information_Identifier;

// ---------------------- 將 String 轉換為 NSData -----------------
- (NSData *) stringToNSData : (NSString *) data_String {
    NSString *command = data_String;

    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSLog(@"commandToSend = %@", commandToSend);
    return commandToSend;
}

@end
