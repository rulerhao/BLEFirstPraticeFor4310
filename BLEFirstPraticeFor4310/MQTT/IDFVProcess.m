//
//  UUIDVProcess.m
//  MQTTTest
//
//  Created by louie on 2020/11/23.
//

#import "IDFVProcess.h"

@interface IDFVProcess ()

@end

@implementation IDFVProcess

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSString *)
getClientIDFromIDFV
{
    /**
     * 取得 Vendor Identifier
     * 長度為 32 的 十六進位 String
     * AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE
     * 此 identifier 會依據app 的發行商而變更
     * 也因此單一對於想取得手機的身份卻又不希望他變更時可以選用這個
    */
    StringProcessFunc * stringProcessFunc = [[StringProcessFunc alloc] init];
    
    uint8_t Maximum_Length_Of_Client_ID = 23;
    NSString *VendorIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSString *VendorIdentifier_After_Process = [stringProcessFunc deleteSubString:VendorIdentifier
                                                                        subString:@"-"];
    
    NSString *VendorIdentifier_For_Client_ID = [stringProcessFunc getSubString:VendorIdentifier_After_Process
                                                                        length:Maximum_Length_Of_Client_ID
                                                                      location:0];
    return VendorIdentifier_For_Client_ID;
}
@end
