//
//  4310SenseViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/5.
//

#import "Sensor4310TestController.h"
#import "Sensor4310TestViewController.h"
#import "Register4310TestViewController.h"

@interface Sensor4310TestController ()

@property(readwrite, nonatomic) NSMutableArray *Stored_Data;

@property (strong, nonatomic) OAuthTest *OAuth;
@property (strong, nonatomic) BLEFor4310Test *BLE;
@property (strong, nonatomic) MQTTFor4310Test *MQTT;

@property (strong, nonatomic) Sensor4310TestViewController *sensor4310TestViewController;
@property (strong, nonatomic) Register4310TestViewController *register4310TestViewController;


@end

@implementation Sensor4310TestController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) controllerInit {
    self.Stored_Data = [[NSMutableArray alloc] init];
    NSLog(@"self.Stored_Data.count For First = %lu", self.Stored_Data.count);
    self.OAuth = [[OAuthTest alloc] init];
    self.OAuth.delegate = self;
    [self.OAuth startOAuth];

    self.BLE = [[BLEFor4310Test alloc] init];
    self.BLE.delegate = self;
    [self.BLE startBLE];

    self.MQTT = [[MQTTFor4310Test alloc] init];
    self.MQTT.delegate = self;
    
    [self addCardViewController];
    
    [self addRegisterViewController];
    NSLog(@"self.Stored_Data.count For After = %lu", self.Stored_Data.count);
}

- (NSMutableArray *) getStoredData {
    return self.Stored_Data;
}

#pragma mark - Delegate
// 增加新的
- (void) addStoredData : (StoredDevicesCell *) Cell {
    NSLog(@"ViewController addData = %@", Cell.Peripheral);
    NSLog(@"self.Stored_Data.count Before = %lu", self.Stored_Data.count);
    [self.Stored_Data addObject:Cell];
    NSLog(@"self.Stored_Data.count = %lu", self.Stored_Data.count);
    for(int i = 0; i < self.Stored_Data.count; i++) {
        NSLog(@"Self.Stored_Data %d = %@", i, [self.Stored_Data objectAtIndex:i]);
        NSLog(@"Self.Stored_Data %d.peripheral = %@", i, [[[self.Stored_Data objectAtIndex:i] Peripheral] identifier]);
    }
    [self.sensor4310TestViewController insertCellAt:self.Stored_Data.count - 1];
}
// 去掉一個
- (void) removeStoredData : (NSInteger) Index {
    NSLog(@"ViewController removeData = %ld", (long)Index);
    [self.Stored_Data removeObjectAtIndex:Index];
    [self.sensor4310TestViewController deleteCellAt:Index];
}
// 更新一個
- (void) replaceStoredData : (NSInteger) Index
                      cell : (StoredDevicesCell *) Cell {
    NSLog(@"ViewController replaceData = %@", Cell);
    [self.Stored_Data replaceObjectAtIndex:Index withObject:Cell];
    [self.sensor4310TestViewController reloadCellAt:Index];
}

// 取得OTP Time
- (NSTimeInterval) getOTPTimeInterval {
    return self.OAuth.OTP_Expired;
}

- (void) mqttConnect : (NSString *) Client_ID
            userName : (NSString *) User_Name
                 otp : (NSString *) OTP
          otpExpired : (NSInteger) OTP_Expired {
    [self.MQTT mqttConnect:Client_ID User_Name:User_Name OTP:OTP OTP_Expired:OTP_Expired];
}

- (NSString *) getAccessToken {
    return self.OAuth.Access_Token;
}
- (NSString *) getClientID {
    return self.OAuth.Client_ID;
}
- (WKWebView *) getWebView {
    return self.OAuth.WKWeb_View;
}

- (StoredDevicesCell *) getStoredDevicesCell: (NSInteger) Index {
    StoredDevicesCell *storedDevicesCell = [StoredDevicesCell alloc];
    storedDevicesCell = [self.Stored_Data objectAtIndex:Index];
    return storedDevicesCell;
}
- (NSInteger)getSotredDataCount {
    return self.Stored_Data.count;
}
# pragma mark - View Controller
- (void) addCardViewController {
    self.sensor4310TestViewController = [[Sensor4310TestViewController alloc] init];
    self.sensor4310TestViewController.delegate = self;
    self.sensor4310TestViewController.CurrentController = self.CurrentController;
    [self.sensor4310TestViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.sensor4310TestViewController.view setUserInteractionEnabled:YES];
    [self.sensor4310TestViewController setCurrentController:self.CurrentController];
    [self addChildViewController:self.sensor4310TestViewController];
    
    [self.view addSubview:self.sensor4310TestViewController.view];
    [self.sensor4310TestViewController didMoveToParentViewController:self];
    
    [self.sensor4310TestViewController.view setHidden:NO];
    //--------------------- Constraints -----------------------
    [self.sensor4310TestViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.sensor4310TestViewController controllerInit];
}

- (void) addRegisterViewController {
    self.register4310TestViewController = [[Register4310TestViewController alloc] init];
    self.register4310TestViewController.delegate = self;
    self.register4310TestViewController.CurrentController = self.CurrentController;
    [self.register4310TestViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.register4310TestViewController.view setUserInteractionEnabled:YES];
    [self.register4310TestViewController setCurrentController:self.CurrentController];
    [self addChildViewController:self.register4310TestViewController];
    
    [self.view addSubview:self.register4310TestViewController.view];
    [self.register4310TestViewController didMoveToParentViewController:self];
    
    [self.register4310TestViewController.view setHidden:YES];
    //--------------------- Constraints -----------------------
    [self.register4310TestViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.register4310TestViewController controllerInit];
}

- (void) mqttPublish : (NSString *) Device_Type
        deviceSerial : (NSString *) Device_Serial
          deviceUUID : (NSString *) Device_UUID
                  t1 : (NSInteger) T1
                  t2 : (NSInteger) T2
                  t3 : (NSInteger) T3
             battery : (int) Battery
              breath : (BOOL) Breath
             motionX : (float) Motion_X
             motionY : (float) Motion_Y
             motionZ : (float) Motion_Z {
    [self.MQTT publishTest : Device_Type
              deviceSerial : Device_Serial
                deviceUUID : Device_UUID
                        t1 : T1
                        t2 : T2
                        t3 : T3
                   battery : Battery
                    breath : Breath
                   motionX : Motion_X
                   motionY : Motion_Y
                   motionZ : Motion_Z];
}

- (void) registerButtonBeClicked {
    NSLog(@"RegisterButtonBeClicked");
    if(self.sensor4310TestViewController.view.isHidden) {
        self.sensor4310TestViewController.view.hidden = NO;
        self.register4310TestViewController.view.hidden = YES;
    }
    else {
        self.sensor4310TestViewController.view.hidden = YES;
        self.register4310TestViewController.view.hidden = NO;
    }
}
@end
