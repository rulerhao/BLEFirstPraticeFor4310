//
//  ChangeBetweenWriteStringViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/9.
//

#import "ChangeBetweenWriteStringViewController.h"

@interface ChangeBetweenWriteStringViewController ()

@end

@implementation ChangeBetweenWriteStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSMutableData *)
getWriteStringThroughAlertView : (UIAlertController *) alert {
    StringProcessFunc *Str_Process_Func = [[StringProcessFunc alloc] init];
    
    NSMutableData *Merged_Information_MutableData = [[NSMutableData alloc] initWithCapacity:0];
    
    NSString *New_Device_Name = [[[alert textFields] objectAtIndex:0] text];
    NSString *New_Device_ID = [[[alert textFields] objectAtIndex:1] text];
    NSString *New_Device_Sex = [[[alert textFields] objectAtIndex:2] text];
    
    if(     !([New_Device_Name length] > 8)        &&
            !([New_Device_ID length] > 2)) {
        //
        NSUInteger Length_Of_Information = 17;
        NSUInteger Length_Of_Head_Bytes = 1;
        NSUInteger Length_Of_Device_Name = 8;
        NSUInteger Length_Of_Device_ID = 2;
        //NSUInteger Length_Of_Device_Sex = 1 * 2;
        
        //
        
        const uint8_t Head_Bytes[] = {0x05};
        NSMutableData *Head_Bytes_Mutable_Data = [NSMutableData dataWithBytes:Head_Bytes
                                                               length:sizeof(Head_Bytes)];
        const uint8_t Zero_Bytes[] = {0x00};
        NSMutableData *Zero_Bytes_Mutable_Data = [NSMutableData dataWithBytes:Zero_Bytes
                                                               length:sizeof(Zero_Bytes)];
        // Name
        
        // 如果超過大小 則擷取最前方
        if([New_Device_Name length] > Length_Of_Device_Name) {
            New_Device_Name = [Str_Process_Func getSubString:New_Device_Name
                                                      length:Length_Of_Device_ID
                                                    location:0];
        }
        NSData *Device_Name_Data = [New_Device_Name dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *Device_Name_Mutable_Data = [Device_Name_Data mutableCopy];
        // ID
        if([New_Device_ID length] == 1) {
            New_Device_ID = [Str_Process_Func MergeTwoString:@"0"
                                                    SecondStr:New_Device_ID];
            NSLog(@"New_Device_ID:%@", New_Device_ID);
        }
        // 如果超過大小 則擷取最前方
        if([New_Device_ID length] > Length_Of_Device_ID) {
            New_Device_ID = [Str_Process_Func getSubString:New_Device_ID
                                                    length:Length_Of_Device_ID
                                                  location:0];
        }
        NSData *Device_ID_Data = [New_Device_ID dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *Device_ID_Mutable_Data = [Device_ID_Data mutableCopy];
        
        // Sex
        
        NSLog(@"TestTTT");
        // 如果非Ｂ非Ｇ 則設為Ｂ
        if(![New_Device_Sex isEqual:@"B"] && ![New_Device_Sex isEqual:@"G"]) {
            NSLog(@"SexNow:%@", New_Device_Sex);
            New_Device_Sex = @"B";
        }
        
        if([New_Device_Sex isEqual:@"B"]) {
            New_Device_Sex = @"1";
        }
        else if([New_Device_Sex isEqual:@"G"]) {
            New_Device_Sex = @"0";
        }
        else {
            New_Device_Sex = @"1";
        }
        
        NSData *Device_Sex_Data = [New_Device_Sex dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *Device_Sex_Mutable_Data = [Device_Sex_Data mutableCopy];
        
        [Merged_Information_MutableData appendData:Head_Bytes_Mutable_Data];
        [Merged_Information_MutableData appendData:Device_Name_Mutable_Data];
        
        while([Merged_Information_MutableData length] < Length_Of_Head_Bytes + Length_Of_Device_Name) {
            [Merged_Information_MutableData appendData:Zero_Bytes_Mutable_Data];
        }
        [Merged_Information_MutableData appendData:Device_ID_Mutable_Data];
        while(Merged_Information_MutableData.length < Length_Of_Head_Bytes + Length_Of_Device_Name + Length_Of_Device_ID) {
            [Merged_Information_MutableData appendData:Zero_Bytes_Mutable_Data];
        }
        [Merged_Information_MutableData appendData:Device_Sex_Mutable_Data];
        while(Merged_Information_MutableData.length < Length_Of_Information) {
            [Merged_Information_MutableData appendData:Zero_Bytes_Mutable_Data];
        }
        
        NSLog(@"Merged_Information_MutableData:%@", Merged_Information_MutableData);
         
    }
    return Merged_Information_MutableData;
}
- (NSString *) DeviceNameProcess : (NSString *) un_Processed_Name_String
{
    // 回傳的新名稱字串
    NSString *processed_Name_String;
    if([un_Processed_Name_String length] > 8)
    {
        
    }
    return processed_Name_String;
}

- (BOOL) DeviceNameAvailable : (NSString *) un_Processed_Name_String
{
    BOOL be_Available = false;
    if([un_Processed_Name_String length] > 8)
    {
        be_Available = false;
    }
    else
    {
        be_Available = true;
    }
    return be_Available;
}

- (BOOL) DeviceIDAvailable : (NSString *) un_Processed_ID_String
{
    BOOL be_Available = false;
    NSInteger length_Of_ID = 2;
    if([un_Processed_ID_String length] > 2 ||
       [un_Processed_ID_String length] < 0)
    {
        be_Available = false;
    }
    else
    {
        be_Available = true;
    }
    return be_Available;
}
@end
