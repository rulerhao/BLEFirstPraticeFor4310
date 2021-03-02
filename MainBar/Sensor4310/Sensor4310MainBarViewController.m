//
//  Sensor4310MainBarViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/26.
//

#import "Sensor4310MainBarViewController.h"

@interface Sensor4310MainBarViewController () <BLEFor4310Delegate>
{
    Sensor4310Setting *sensor4310Setting;
    StoredDevicesCell *storedDevicesCell;
    NSMutableArray *Stored_Devices;
    UICollectionViewCell *myCollectionViewCell;
    Convert4310Information *convert_Characteristic;
    KS4310Setting *ks4310Setting;
    // Sensor = 0
    // Watcher = 1
    NSMutableArray *Mqtt_Message_Watcher_Mode;
    //NSUInteger Mode;
    NSTimer *StatusWatcherTimer;
    NSTimer *ReadSubscribeMessageTimer;

}
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UICollectionViewCell *myCollectionViewCell;
@property (strong, nonatomic) NSMutableArray *StoredData;
@end

@implementation Sensor4310MainBarViewController

- (void)viewDidLoad {
    NSLog(@"NowController = Sensor4310MainBarViewController");
    [super viewDidLoad];
    
}

-(void)viewWillLayoutSubviews {
    NSLog(@"HeightOfContainer = %f", self.view.frame.size.height);
    NSLog(@"WidthOfContainer = %f", self.view.frame.size.width);
}

- (void)controllerInit {

    sensor4310Setting = [[Sensor4310Setting alloc] init];
    convert_Characteristic = [[Convert4310Information alloc] init];
    ks4310Setting = [[KS4310Setting alloc] init];
    [ks4310Setting InitKS4310Setting];
    
    self.StoredData = [[NSMutableArray alloc] init];
    
    [self viewInit];

    [self updateConstraints];
    
    //[self initCollectionViewCell];
    NSLog(@"ModeTestForSensorViewController = %d" , Mode);
    // 監測模式
    if(Mode == 0) {
        StatusWatcherTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                         target:self
                                       selector:@selector(StatusWatcher:)
                                       userInfo:nil
                                        repeats:YES];
    }
    // 訂閱模式
    else if(Mode == 1){
        Mqtt_Message_Watcher_Mode = [[NSMutableArray alloc] init];
        ReadSubscribeMessageTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(ReadSubscribeMessage:)
                                       userInfo:nil
                                        repeats:YES];
    }
}

#pragma mark - CollectionView Delegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCollectionViewIdentifier" forIndexPath:indexPath];
    NSLog(@"TestViewWithTagOutSide");
    
    NSLog(@"ContentViewOfCell = %lu", (unsigned long)[[cell subviews] count]);

    // 1 為 原本的 UIVIEW
    // 藉此判定是否要新增 Cell 中的 View
    if ([[cell subviews] count] == 1) {
        cell = [self createCollectionViewCell:cell];
    }
    else {
    }
    
    UIImageView *Background_ImageView = [cell viewWithTag:1];
    UIImageView *Baby_Photo_Background_ImageView = [cell viewWithTag:2];
    UITextView *Serial_TextView = [cell viewWithTag:4];
    UITextView *Baby_Name_TextView = [cell viewWithTag:8];
    
    UIImageView *Baby_Information_Bar1_ImageView = [cell viewWithTag:9];
    UIImageView *Baby_Information_Bar2_ImageView = [cell viewWithTag:10];
    UIImageView *Baby_Information_Bar3_ImageView = [cell viewWithTag:11];
    
    UITextView *Movement_TextView = [cell viewWithTag:5];
    UITextView *Temperature_TextView = [cell viewWithTag:6];
    UITextView *Battery_TextView = [cell viewWithTag:7];
    
    // ---------------------- 該次的 Cell ----------------------
    // 監測模式
    if (Mode == 0) {
        StoredDevicesCell *Previous_Stored_Deivce_Cell = [[StoredDevicesCell alloc] init];
        Previous_Stored_Deivce_Cell = [Stored_Devices objectAtIndex:[indexPath row]];

        if([[[Previous_Stored_Deivce_Cell Peripheral] name] isEqual:@"KS-4310"]) {
            // ---------------------- 判別這次手機發出的模式 ----------------------
            NSData *Mode_Identifier = [[Previous_Stored_Deivce_Cell Characteristic] subdataWithRange:NSMakeRange(0, 1)];
            // ---------------------- Mode_Identifier == @"00" ----------------------
            if([Mode_Identifier isEqual:ks4310Setting.Sense_Identifier]) {
                Serial_TextView.text = [Previous_Stored_Deivce_Cell.Device_EPROM uppercaseString] ;
                
                Movement_TextView.text = @"Normal";
                
                float T1 = [convert_Characteristic getTemperature_1:[Previous_Stored_Deivce_Cell Characteristic]];
                NSLog(@"Temp1 = %f", T1);
                Temperature_TextView.text = [[NSNumber numberWithFloat:T1] stringValue];
                
                NSUInteger Battery = [convert_Characteristic getBattery_Volume:[Previous_Stored_Deivce_Cell Characteristic]];
                Battery_TextView.text = [[NSNumber numberWithLong:Battery] stringValue ];
            }
            // ---------------------- Mode_Identifier == @"04" ----------------------
            else if([Mode_Identifier isEqual:ks4310Setting.Baby_Information_Identifier]) {
            }
            // ---------------------- Mode_Identifier == @"05" ----------------------
            else if([Mode_Identifier isEqual:ks4310Setting.Write_Identifier]) {
            }
        }
    }
    // 訂閱模式
    else if (Mode == 1) {
        NSDictionary *MqttMessageCell = [MqttMain.MQTTMessage objectAtIndex:[indexPath row]];
        NSString *Model = [MqttMessageCell valueForKey:@"Model"];
        NSString *Serial = [MqttMessageCell valueForKey:@"Serial"];
        NSString *UUID = [MqttMessageCell valueForKey:@"UUID"];
        
        NSNumber *T1_NSNumber = [MqttMessageCell valueForKey:@"T1"];
        float T1 = [T1_NSNumber floatValue];
        
        NSNumber *T2_NSNumber = [MqttMessageCell valueForKey:@"T2"];
        float T2 = [T2_NSNumber floatValue];
        
        NSNumber *T3_NSNumber = [MqttMessageCell valueForKey:@"T3"];
        float T3 = [T3_NSNumber floatValue];
        
        NSNumber *Breath_NSNumber = [MqttMessageCell valueForKey:@"Breath"];
        BOOL Breath = [Breath_NSNumber boolValue];
        
        NSNumber *Battery_NSNumber = [MqttMessageCell valueForKey:@"Battery"];
        int Battery = [Battery_NSNumber intValue];
        
        NSLog(@"------------ MQTT Message In Watcher Mode ------------");
        NSLog(@"Model = %@", Model);
        NSLog(@"Serial = %@", Serial);
        NSLog(@"UUID = %@", UUID);
        NSLog(@"T1 = %f", T1);
        NSLog(@"T2 = %f", T2);
        NSLog(@"T3 = %f", T3);
        // NSLog(@"Breath = %@", Breath);
        NSLog(@"Battery = %d", Battery);
        
        Serial_TextView.text = Serial;
        
        switch ([Breath_NSNumber intValue]) {
            case 0:
                Movement_TextView.text = @"Abnormal";
                break;
            case 1:
                Movement_TextView.text = @"Normal";
            default:
                break;
        }
        Temperature_TextView.text = [T1_NSNumber stringValue];
        Battery_TextView.text = [Battery_NSNumber stringValue];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 監測模式
    if(Mode == 0)
        return Stored_Devices.count;
    // 訂閱模式
    else if(Mode == 1)
        return Mqtt_Message_Watcher_Mode.count;
    else
        return 0;
}

// ---------------------- Cell 大小 ------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ReSizeCollectionView");
    return CGSizeMake(sensor4310Setting.Baby_Card_Background_Width, sensor4310Setting.Baby_Card_Background_Height);
}
// ---------------------- 上下 cell 的間距 ------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return sensor4310Setting.InteritemSpacing;
}

// ---------------------- 左右 cell 的間距 ------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return sensor4310Setting.LineSpacing;
}

// ---------------------- 上左下右距離邊界距離 ------------------------
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(sensor4310Setting.Inset_Top_Down, sensor4310Setting.Inset_Left_Right, sensor4310Setting.Inset_Top_Down, sensor4310Setting.Inset_Left_Right);
}

// ---------------------- 被點擊時觸發 ------------------------

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // -------------- 註冊裝置
//    RequestOAuth2Steps *requestOAuth2Steps = [[RequestOAuth2Steps alloc] init];
//
//    [requestOAuth2Steps signUpDevices:OAuth.Access_Token orgunits:@"7da0f976-f732-11ea-b7aa-0242ac160004" wKWebView:OAuth.WKWeb_View];
    // -------------- MQTT Publish
//    [MqttMain publishTest];
    
    //[OAuth identifyDeviceBeenSignUp:EPROM];
    // -------------- 像伺服器求 Device UUID
//    NSData *TestSignUpData = [[NSData alloc] initWithBase64EncodedString:@"123" options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    [OAuth signUpDevice:TestSignUpData];
    
//    // ------------ Write 05 Test
//    StoredDevicesCell *cell = [StoredDevicesCell alloc];
//    cell = [BLE.Stored_Data objectAtIndex:[indexPath row]];
//
//    NSString *Serial = @"C76DA75B05BBFC55806DE2";
//    NSData *data = [self hexStringToData:[NSString stringWithFormat:@"%@%@%@", @"05", Serial, @"AA"]];
//    NSLog(@"TestWRiteData = %@", data);
//    [BLE write05ToKS4310EPROM:cell.Peripheral data:data];
    
    // -------------- 註冊裝置
    //[OAuth signUpDevice];
    
    // take 裝置資訊
    if (Mode == 0) {
        StoredDevicesCell *storedDevicesCell = [StoredDevicesCell alloc];
        Convert4310Information *convert4310Information = [Convert4310Information alloc];
        storedDevicesCell = [BLE.Stored_Data objectAtIndex:[indexPath row]];
        [MqttMain publishTest:@"KS-4310"
                 deviceSerial:storedDevicesCell.Device_EPROM
                   deviceUUID:storedDevicesCell.Device_UUID
                           t1:[convert4310Information getTemperature_1:storedDevicesCell.Characteristic]
                           t2:[convert4310Information getTemperature_2:storedDevicesCell.Characteristic]
                           t3:[convert4310Information getTemperature_3:storedDevicesCell.Characteristic]
                      battery:(int) [convert4310Information getBattery_Volume:storedDevicesCell.Characteristic]
                       breath:NO
                      motionX:10
                      motionY:20
                      motionZ:30];
    }
    else if (Mode == 1) {
        NSDictionary *MqttMessageCell = [MqttMain.MQTTMessage objectAtIndex:[indexPath row]];
        NSString *UUID = [MqttMessageCell valueForKey:@"UUID"];
        [OAuth refreshDevicesInformation:OAuth.Access_Token status:2 deviceUUID:UUID wKWebView:OAuth.WKWeb_View];
        //[OAuth takeDevicesInformation:OAuth.Access_Token deviceUUID:UUID wKWebView:OAuth.WKWeb_View];
    }
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- Init -----------------------
    BLE.delegate = self;
    storedDevicesCell = [[StoredDevicesCell alloc] init];
    Stored_Devices = [[NSMutableArray alloc] init];
    //--------------------- View -----------------------
    //--------------------- Collection View -----------------------
    UICollectionViewFlowLayout *myCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    myCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myCollectionViewLayout];
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionViewIdentifier"];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: self.myCollectionView];
    NSLog(@"FirstTestmyTableView = %@", self.myCollectionView);
}
    
- (UICollectionViewCell *) createCollectionViewCell : (UICollectionViewCell *) cell {
    UIImageView *Background_ImageView;
    UIImageView *Baby_Photo_Background_ImageView;
    UITextView *Serial_TextView;
    UITextView *Baby_Name_TextView;
    
    UIImageView *Baby_Information_Bar1_ImageView;
    UIImageView *Baby_Information_Bar2_ImageView;
    UIImageView *Baby_Information_Bar3_ImageView;
    
    UITextView *Movement_TextView;
    UITextView *Temperature_TextView;
    UITextView *Battery_TextView;
    
    //--------------------- Background ImageVIew -----------------------
    Background_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_background.png"]];
    Background_ImageView.tag = 1;
    [cell addSubview:Background_ImageView];
    
    //--------------------- Baby Photo Background ImageView -----------------------
    Baby_Photo_Background_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_boy_photo_background2.png"]];
    Baby_Photo_Background_ImageView.tag = 2;
    [cell addSubview:Baby_Photo_Background_ImageView];
    
    //--------------------- Serial TextView -----------------------
    Serial_TextView = [[UITextView alloc] init];
    Serial_TextView.text = @"0";
    Serial_TextView.scrollEnabled = NO;
    Serial_TextView.editable = NO;
    Serial_TextView.backgroundColor = [UIColor clearColor];
    Serial_TextView.textAlignment = NSTextAlignmentCenter;
    Serial_TextView.tag = 4;
    [cell addSubview:Serial_TextView];
    
    //--------------------- Baby Name TextView -----------------------
    Baby_Name_TextView = [[UITextView alloc] init];
    Baby_Name_TextView.text = @"Fan";
    Baby_Name_TextView.scrollEnabled = NO;
    Baby_Name_TextView.editable = NO;
    Baby_Name_TextView.tag = 8;
    [cell addSubview:Baby_Name_TextView];
    
    //--------------------- Information Bar -----------------------
    Baby_Information_Bar1_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_boy_information_bar_background.png"]];
    Baby_Information_Bar2_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_boy_information_bar_background.png"]];
    Baby_Information_Bar3_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_boy_information_bar_background.png"]];
    Baby_Information_Bar1_ImageView.tag = 9;
    Baby_Information_Bar2_ImageView.tag = 10;
    Baby_Information_Bar3_ImageView.tag = 11;
    [cell addSubview:Baby_Information_Bar1_ImageView];
    [cell addSubview:Baby_Information_Bar2_ImageView];
    [cell addSubview:Baby_Information_Bar3_ImageView];
    
    //--------------------- Movement TextView -----------------------
    Movement_TextView = [[UITextView alloc] init];
    Movement_TextView.text = @"0";
    Movement_TextView.scrollEnabled = NO;
    Movement_TextView.editable = NO;
    Movement_TextView.backgroundColor = [UIColor clearColor];
    Movement_TextView.textAlignment = NSTextAlignmentCenter;
    [Movement_TextView setTag:5];
    [cell addSubview:Movement_TextView];
    
    //--------------------- Temperature TextView -----------------------
    Temperature_TextView = [[UITextView alloc] init];
    Temperature_TextView.text = @"0";
    Temperature_TextView.scrollEnabled = NO;
    Temperature_TextView.editable = NO;
    Temperature_TextView.backgroundColor = [UIColor clearColor];
    Temperature_TextView.textAlignment = NSTextAlignmentCenter;
    [Temperature_TextView setTag:6];
    [cell addSubview:Temperature_TextView];
    
    //--------------------- Battery TextView -----------------------
    Battery_TextView = [[UITextView alloc] init];
    Battery_TextView.text = @"0";
    Battery_TextView.scrollEnabled = NO;
    Battery_TextView.editable = NO;
    Battery_TextView.backgroundColor = [UIColor clearColor];
    Battery_TextView.textAlignment = NSTextAlignmentCenter;
    [Battery_TextView setTag:7];
    [cell addSubview:Battery_TextView];
    
    //--------------------- Constraint -----------------------
    //--------------------- Background ImageVIew -----------------------
    [Background_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top);
        make.bottom.equalTo(cell.mas_bottom);
        make.left.equalTo(cell.mas_left);
        make.right.equalTo(cell.mas_right);
    }];
    //--------------------- Baby Photo Background ImageView -----------------------
    [Baby_Photo_Background_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Background_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Photo_Background_Top_Constraint);
        make.bottom.equalTo(Background_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Photo_Background_Bottom_Constraint);
        make.left.equalTo(Background_ImageView.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Photo_Background_Left_Constraint);
        make.right.equalTo(Background_ImageView.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Photo_Background_Right_Constraint);
    }];

    //--------------------- Serial TextView -----------------------
    [Serial_TextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Photo_Background_ImageView.mas_top);
        make.bottom.equalTo(Baby_Photo_Background_ImageView.mas_bottom);
        make.left.equalTo(Baby_Photo_Background_ImageView.mas_left);
        make.right.equalTo(Baby_Photo_Background_ImageView.mas_right);
    }];

    //--------------------- Information Bar -----------------------
    [Baby_Information_Bar3_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Background_ImageView.mas_bottom).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar3_Top_Constraint);
        make.bottom.equalTo(Background_ImageView.mas_bottom).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar3_Bottom_Constraint);
        make.left.equalTo(Background_ImageView.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar3_Left_Constraint);
        make.right.equalTo(Background_ImageView.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar3_Right_Constraint);
    }];

    [Baby_Information_Bar2_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Information_Bar3_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar2_Top_Constraint);
        make.bottom.equalTo(Baby_Information_Bar3_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar2_Bottom_Constraint);
        make.left.equalTo(Background_ImageView.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar2_Left_Constraint);
        make.right.equalTo(Background_ImageView.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar2_Right_Constraint);
    }];

    [Baby_Information_Bar1_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Information_Bar2_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar1_Top_Constraint);
        make.bottom.equalTo(Baby_Information_Bar2_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar1_Bottom_Constraint);
        make.left.equalTo(Background_ImageView.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar1_Left_Constraint);
        make.right.equalTo(Background_ImageView.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar1_Right_Constraint);
    }];

    //--------------------- Movement TextView -----------------------
    [Movement_TextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Information_Bar1_ImageView.mas_top);
        make.bottom.equalTo(Baby_Information_Bar1_ImageView.mas_bottom);
        make.left.equalTo(Baby_Information_Bar1_ImageView.mas_centerX);
        make.right.equalTo(Baby_Information_Bar1_ImageView.mas_right);
    }];

    //--------------------- Temperature TextView -----------------------
    [Temperature_TextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Information_Bar2_ImageView.mas_top);
        make.bottom.equalTo(Baby_Information_Bar2_ImageView.mas_bottom);
        make.left.equalTo(Baby_Information_Bar2_ImageView.mas_centerX);
        make.right.equalTo(Baby_Information_Bar2_ImageView.mas_right);
    }];

    //--------------------- Battery TextView -----------------------
    [Battery_TextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Information_Bar3_ImageView.mas_top);
        make.bottom.equalTo(Baby_Information_Bar3_ImageView.mas_bottom);
        make.left.equalTo(Baby_Information_Bar3_ImageView.mas_centerX);
        make.right.equalTo(Baby_Information_Bar3_ImageView.mas_right);
    }];
    
    return cell;
}
#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- Collection View -----------------------
    [self.myCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - Methods
// ---------------------- 找出 Stored_Devices 在這次的 index -----------------
- (int8_t) getIndexOfStoredDevices : (CBPeripheral *) peripheral {
    for(uint8_t i = 0; i < [Stored_Devices count]; i++)
        if([[Stored_Devices objectAtIndex:i] Peripheral] == peripheral)
            return i;
    return -1;
}

#pragma mark - BLE Delegate

- (void) addNewDevice:(CBPeripheral *)peripheral {
    
}

- (void) updateCharacteristic:(CBPeripheral *)peripheral characteristic :(CBCharacteristic *)characteristic {
    NSLog(@"TestBleDeleage = %@", characteristic);
}

- (void) synchronizeStoredDevices:(NSMutableArray *)stored_Devices {
    Stored_Devices = stored_Devices;
}

- (void) updateForBusy:(NSMutableArray *)stored_Devices {
    Stored_Devices = stored_Devices;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.myCollectionView reloadData];
    }];
}

- (NSData *) hexStringToData : (NSString *) Hex_String {
    NSString *command = Hex_String;

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
    NSLog(@"%@", commandToSend);
    return commandToSend;
}

- (void) ReadSubscribeMessage : (NSTimer *) sender{
    NSLog(@"ReadSubscribeMessage");
    Mqtt_Message_Watcher_Mode = MqttMain.MQTTMessage;
    [self.myCollectionView reloadData];
}

- (void) StatusWatcher : (NSTimer *) sender {
    for(int i = 0; i < BLE.Stored_Data.count; i++) {
        StoredDevicesCell *storedDevicesCell = [StoredDevicesCell alloc];
        storedDevicesCell = [BLE.Stored_Data objectAtIndex:i];
        
        Convert4310Information *convert4310Information = [Convert4310Information alloc];
        if(storedDevicesCell.Characteristic) {
            if([convert4310Information getTemperature_1:storedDevicesCell.Characteristic] < 26) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"異常狀況"
                                                                               message:[[NSString alloc] initWithFormat:@"%@%d%@%@", @"第", i, @"床", @"溫度太低啦"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                // OK按鍵的部分
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction * action) {
                }];
                
                [alert addAction:okAction];
                
                [self presentViewController:alert
                                   animated:YES
                                 completion:nil];
            }
        }
    }
}
@end
