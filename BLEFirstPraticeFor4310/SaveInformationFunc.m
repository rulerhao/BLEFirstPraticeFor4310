//
//  SaveInformation.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/25.
//

#import "SaveInformationFunc.h"

@interface SaveInformationFunc ()

@end

@implementation SaveInformationFunc

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)
saveInformation : (UIAlertController *) alert
storedDevices   : (NSMutableArray *)    StoredDevices
indexPath       : (NSIndexPath *)       indexPath
{
    NSLog(@"Write05");

    NSString *ErrorMsg = @"";
    
    // 由 alert view 中取得輸入資訊
    ChangeBetweenWriteStringViewController *ChangeWriteReadString = [[ChangeBetweenWriteStringViewController alloc] init];
    
    NSMutableData *Merged_InformationsAgain = [ChangeWriteReadString getWriteStringThroughAlertView:alert];
    
    //  判斷輸入格式是否正確
    InformationRunnable *informationRunnable = [[InformationRunnable alloc ]init];
    if([informationRunnable InformationRunnable:alert]) {
        NSLog(@"Merged_InformationsAgain : %@", Merged_InformationsAgain);
        
        // write 05 和要賦予的裝置資訊
        CBPeripheral *peri = [[StoredDevices objectAtIndex:[indexPath row]] getPheripheral];
        CBService *ser = [[peri services] objectAtIndex:2];
        CBCharacteristic *chara = [[ser characteristics] objectAtIndex:2];

        //wirte to get information setting in device.
        [peri writeValue:Merged_InformationsAgain
       forCharacteristic:chara
                    type:CBCharacteristicWriteWithResponse];
        
        NSString *Now_Device_name = [[[alert textFields] objectAtIndex:0] text];
        
        NSString *Previous_Device_Name = [[StoredDevices objectAtIndex:[indexPath row]] getDeviceName];
        
        CameraController *cameraFunc = [[CameraController alloc] init];
        [cameraFunc saveChangedNameImage:Now_Device_name
                      delete_Device_Name:Previous_Device_Name];
    } else {
        NSString *NameErrorMsg = @"Name Input Formate Error!\n";
        NSString *IDErrorMsg = @"ID Input Formate Error!\n";
        NSString *SexErrorMsg = @"Sex Input Formate Error!\n";
        
        StringProcessFunc *stringProcessFunc = [[StringProcessFunc alloc] init];
        if(![informationRunnable NameRunnable:alert]) {
            ErrorMsg = [stringProcessFunc MergeTwoString:ErrorMsg
                                               SecondStr:NameErrorMsg];
        }
        
        if(![informationRunnable IDRunnable:alert]) {
            ErrorMsg = [stringProcessFunc MergeTwoString:ErrorMsg
                                               SecondStr:IDErrorMsg];
        }
        
        if(![informationRunnable SexRunnable:alert]) {
            ErrorMsg = [stringProcessFunc MergeTwoString:ErrorMsg
                                               SecondStr:SexErrorMsg];
        }
    }
    return ErrorMsg;
}

@end
