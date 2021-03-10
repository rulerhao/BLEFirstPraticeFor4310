//
//  Register4310ViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/9.
//

#import "Register4310ViewController.h"

@interface Register4310ViewController () <BLEFor4310Delegate, OAuth2MainDelegate>
{
    NSTimer *GetRegisterDevicesTimer;

}
@end

@implementation Register4310ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void) controllerInit {
    BLE.delegate = self;
    OAuth.delegate = self;
    GetRegisterDevicesTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(getRegisterDevices:)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- Init -----------------------
    //--------------------- View -----------------------
    //--------------------- Collection View -----------------------
}


#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- Collection View -----------------------
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - Timer
- (void) getRegisterDevices : (NSTimer *) sender {
    NSInteger Been_Register_Devices_Number = 0;
    NSInteger Not_Been_register_Devices_Number = 0;
    for(int i = 0; i < BLE.Stored_Data.count; i++) {
        StoredDevicesCell *cell = [StoredDevicesCell alloc];
        cell = [BLE.Stored_Data objectAtIndex:i];
        switch (cell.Serial_Been_Register) {
            case 0:
                Not_Been_register_Devices_Number++;
                break;
            case 1:
                Been_Register_Devices_Number++;
                break;
            default:
                break;
        }
    }
    NSLog(@"Been_Register_Devices_Number = %ld", Been_Register_Devices_Number);
    NSLog(@"Not_Been_register_Devices_Number = %ld", Not_Been_register_Devices_Number);
}
 

- (void) synchronizeStoredDevices : (NSMutableArray *) Stored_Data {
    
}

@end
