//
//  InformationRunAvailable.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/9.
//

#import "InformationRunnable.h"

@interface InformationRunnable ()

@end

@implementation InformationRunnable

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL) InformationRunnable : (UIAlertController *) alert
{
    BOOL Can_Run = false;
    
    BOOL Name_Can_Run = [self NameRunnable:alert];
    BOOL ID_Can_Run = [self IDRunnable:alert];
    BOOL Sex_Can_Run = [self SexRunnable:alert];
    
    if(Name_Can_Run && ID_Can_Run && Sex_Can_Run)
    {
        Can_Run = true;
    }
    return Can_Run;
}

- (BOOL) NameRunnable : (UIAlertController *) alert
{
    NSString *Now_Device_name = [[[alert textFields] objectAtIndex:0] text];
    BOOL Name_Can_Run = false;
    if([Now_Device_name length] <= 8 ) {
        Name_Can_Run = true;
    } else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Modify Information"
                                       message:nil
                                       preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Name";
            textField.text = @"BBC";
        }];
        
        // Cancel按鍵的部分
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {
        }];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    return Name_Can_Run;
}

- (BOOL) IDRunnable : (UIAlertController *) alert
{
    NSString *Now_Device_ID = [[[alert textFields] objectAtIndex:1] text];
    BOOL ID_Can_Run = false;
    StringProcessFunc *Str_Process_Func = [[StringProcessFunc alloc] init];
    if([Now_Device_ID length] <= 2 &&
       [Now_Device_ID length] > 0 )
    {
        if([Str_Process_Func getIntegerForAll:Now_Device_ID])
        {
            ID_Can_Run = true;
        }
    }
    return ID_Can_Run;
}

- (BOOL) SexRunnable : (UIAlertController *) alert
{
    NSString *Now_Device_Sex = [[[alert textFields] objectAtIndex:2] text];

    BOOL Sex_Can_Run = false;
    if([Now_Device_Sex length] == 1 &&
       ([Now_Device_Sex  isEqual: @"G"] ||
       [Now_Device_Sex  isEqual: @"g"] ||
       [Now_Device_Sex  isEqual: @"B"] ||
       [Now_Device_Sex  isEqual: @"b"]))
    {
        Sex_Can_Run = true;
    }
    return Sex_Can_Run;
}

@end
