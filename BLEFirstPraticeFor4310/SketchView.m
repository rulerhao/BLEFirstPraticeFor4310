//
//  SketchView.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/2.
//

#import "SketchView.h"
@interface SketchView ()

@end

@implementation SketchView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)
setDeviceReturnInformation   : (__kindof UICollectionViewCell *)    cell
storedDevices                : (NSMutableArray *)                   StoredDevices
movementScanTime             : (NSInteger)                          MovementScanTime
highTemperature              : (float)                              HighTemperature
lowTemperature               : (float)                              LowTemperature
IndexPath                    : (NSIndexPath *)                      Index_Path {
    NSLog(@"setDevicereturnInformation");
    Convert4310Information *convert_Characteristic = [[Convert4310Information alloc] init];
    
    cellData *CD = [[cellData alloc] init];
    
    CD = [StoredDevices objectAtIndex:[Index_Path row]];
    
    NSData *characteristic_Data = [CD getCurrentCharacteristic];
    
    NSLog(@"NSDataCharac:%@", characteristic_Data);
    
    BOOL Movement_Normal = false;
    BOOL Temperature_Normal = false;
    
    for(int i = 1;i <= 11;i++) {
        switch (i) {
                /**
                 * Movement 的燈號判斷
                 */
            case 1: {
                UIImageView *Movement_ImageView = [cell viewWithTag:1];
                
                NSMutableArray *MovementRecordArray = [CD getStoredMovementState];
                
                // 取得移動正常或異常
                BOOL Movement_Normal = [self getMovementNormal :   MovementRecordArray
                                             ScanTime          :   MovementScanTime];
                
                // 設定移動紅燈或綠燈
                [self setMovementImageView  :Movement_ImageView
                      movementStatus        :Movement_Normal];
                
                break;
            }
                /**
                 * 溫度字串顏色和 string 顯示
                 */
            case 2: {
                UILabel *Temperature_Label = [cell viewWithTag:2];
                float T1 = [convert_Characteristic getTemperature_1:characteristic_Data];
                
                NSInteger Temperature_Status;
            
                /**
                 * 取得目前溫度狀況
                 * 1 : 過高
                 * 2 : 正常
                 * 3 : 過低
                 */
                
                Temperature_Status = [self temperatureStatus    :   T1
                                           highTemperature      :   HighTemperature
                                           lowTemperature       :   LowTemperature];
                NSLog(@"Temperature_TTBefore:%@", characteristic_Data);
                NSLog(@"Temperature_TT:%f", T1);
                // 設定溫度 Label 的溫度和顏色
                
                [self setTempoeratureLabel  :   Temperature_Label
                      temperature           :   T1
                      temperatureStatus     :   Temperature_Status];
                
                Temperature_Normal = [self temperatureNormal:Temperature_Status];
                
                break;
            }
                /**
                 * 顯示裝置電池電量 以25%為區間分為四等份
                 */
            case 3: {
                UIImageView *Battery_ImageView = [cell viewWithTag:3];

                NSUInteger Battery_Volume = [convert_Characteristic getBattery_Volume:characteristic_Data];
                
                // 設定電池圖片
                [self setBatteryImage   : Battery_ImageView
                      battery_Volume    : Battery_Volume];
                
                break;
            }
                
            case 4: {
                UIImageView *Warning_ImageView = [cell viewWithTag:4];
                UIImage *Ima = [UIImage imageNamed:@"baby_card_warning.png"];
                [Warning_ImageView setImage:Ima];
                /**
                 * 當呼吸和溫度都為正常時使警告消失
                 */
                if(Movement_Normal && Temperature_Normal) {
                    [Warning_ImageView setHidden:true];
                }
                else {
                    [Warning_ImageView setHidden:false];
                }
                break;
            }
            case 7 : {
                /*
                NSLog(@"IntoPicture");
                UIImageView *Photo_Label = [cell viewWithTag:7];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"temp_Image.png"];
                UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",filePath]];
                [Photo_Label setImage:img];
                 */
            }
            case 11 : {
                UILabel *Temperature_Label = [cell viewWithTag:11];
                Temperature_Label.hidden = YES;
            }
        }
    }
}
/*!
 * @param cell : 目前所選的 cell 用來 set imageView 和 label
 * @param StoredDevices : 目前 cell 所有的資訊
 * @param Index_Path : 目前 cell 所在的位置
 *  @discussion
 *  當寫入 04 05 時所出現的裝置資訊並把他們畫入 cell 中
 *
 */

- (void)
setDeviceInformation            : (__kindof UICollectionViewCell *)    cell
storedDevices                   : (NSMutableArray *)                   StoredDevices
indexPath                       : (NSIndexPath *)                      Index_Path {
    
    cellData *CD = [[cellData alloc] init];
    
    CD = [StoredDevices objectAtIndex:[Index_Path row]];
    
    NSInteger index = [Index_Path row];
    
    // Device Name
    NSString *Device_Name_Str = [[StoredDevices objectAtIndex:index] getDeviceName];
    
    NSLog(@"Write05DeviceName:%@", Device_Name_Str);
    UILabel *Device_Name_Label = [cell viewWithTag:5];
    
    [Device_Name_Label setText : Device_Name_Str];
    
    // Device ID
    NSString *Device_ID_Str = [[StoredDevices objectAtIndex:index] getDeviceID];
    
    StringProcessFunc *StrProcessFunc = [[StringProcessFunc alloc] init];
    
    Device_ID_Str = [StrProcessFunc MergeTwoString:@"A0" SecondStr:Device_ID_Str];
    
    UILabel *Device_Id_Label = [cell viewWithTag:6];
    
    [Device_Id_Label setText:Device_ID_Str];
    
    // Device Sex
    NSString *Device_Sex_Str = [[StoredDevices objectAtIndex:index] getDeviceSex];
    
    // 預設圖片
    UIImage *PhotoBackground_Image = [UIImage imageNamed:@"baby_card_girl_photo_background2.png"];
    UIImage *Information_Bar_Image = [UIImage imageNamed:@"baby_card_girl_information_bar_background.png"];
    
    NSLog(@"Sexis:%@", Device_Sex_Str);
    if([Device_Sex_Str isEqual:@"0"]) {
        PhotoBackground_Image = [UIImage imageNamed:@"baby_card_girl_photo_background2.png"];
        Information_Bar_Image = [UIImage imageNamed:@"baby_card_girl_information_bar_background.png"];
    }
    else {
        PhotoBackground_Image = [UIImage imageNamed:@"baby_card_boy_photo_background2.png"];
        Information_Bar_Image = [UIImage imageNamed:@"baby_card_boy_information_bar_background.png"];
    }
    
    // 讀取圖片並放入圖片
    UIImageView *Photo_ImageView = [cell viewWithTag:7];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *Image_Name = [StrProcessFunc MergeTwoString:Device_Name_Str SecondStr:@".png"];
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Image_Name];
    
    UIImage *PhotoImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",filePath]];
    
    if(PhotoImage.size.height == 0 & PhotoImage.size.width == 0) {
        PhotoImage = [UIImage imageNamed:@"Baby_1.jpg"];
    }
    
    [Photo_ImageView setImage:PhotoImage];
    
    Photo_ImageView.layer.cornerRadius = 35;
    //Photo_ImageView.layer.bounds = CGRectMake(0, 0, 70, 70);
    
    // BarImageView
    UIImageView *Device_Bar_ImageView;
    
    for(int i = 8; i <= 10; i++) {
        Device_Bar_ImageView = [cell viewWithTag:i];
        [Device_Bar_ImageView setImage:Information_Bar_Image];
    }
}

- (BOOL)
    getMovementNormal       : (NSMutableArray *)    Movement_Recode_Array
    ScanTime                : (NSUInteger)          ScanTime {
    /**
     * 檢查時間內如果連續三分之一呼吸不正常則設 Movement Abnormal = true;
     */
    BOOL Continue_Normal = false;
    NSUInteger Total_Continue_Normal_Count = 0;
    
    NSUInteger ContinueScanLength = ScanTime / 3;
    
    if([Movement_Recode_Array count] > ContinueScanLength) {
        for(NSUInteger j = [Movement_Recode_Array count] - 1; j >= [Movement_Recode_Array count] - ContinueScanLength;j--) {
            if([[Movement_Recode_Array objectAtIndex:j] isEqualToNumber:[NSNumber numberWithBool:true]]) {
                Total_Continue_Normal_Count++;
            }
            else {
                Total_Continue_Normal_Count = 0;
                break;
            }
            if(Total_Continue_Normal_Count >= ContinueScanLength) {
                Continue_Normal = true;
            }
        }
    }
    /**
     * 檢查時間內如果有超過三分之二呼吸不正常則設為 Movement Abnormal = true;
     */
    // TODO: 修改為每次進入再增加而不是每次都從零開始重算 進而增加效能
    
    BOOL Total_Normal = false;
    NSUInteger Total_Normal_Count = 0;
    
    for(NSUInteger j = 0; j < [Movement_Recode_Array count];j++) {
        if([[Movement_Recode_Array objectAtIndex:j] isEqualToNumber:[NSNumber numberWithBool:true]]) {
            Total_Normal_Count++;
        }
    }
    if(Total_Normal_Count >= ScanTime * 2 / 3) {
        Total_Normal = true;
    }
    
    if(Continue_Normal && Total_Normal) {
        return true;
    }
    
    else {
        return false;
    }
}

- (void)
setMovementImageView    : (UIImageView *)       imageView
movementStatus          : (BOOL)                Movement_Status {
    UIImage *Ima;
    if(Movement_Status) {
        Ima = [UIImage imageNamed:@"list_level_2.png"];
    }
    else {
        Ima = [UIImage imageNamed:@"list_level_4.png"];
    }
    [imageView setImage:Ima];
}

- (NSInteger)
temperatureStatus : (float) Temperature
highTemperature   : (float) HighTemperature
lowTemperature    : (float) LowTemperature {
    if (Temperature > HighTemperature) {
        return 1;
    }
    else if(Temperature >LowTemperature) {
        return 2;
    }
    else {
        return 3;
    }
}

- (BOOL)
temperatureNormal : (NSInteger) Temperature_Status {
    switch (Temperature_Status) {
        case 2:
            return true;
            break;
        default:
            return false;
    }
}

- (void)
setTempoeratureLabel    : (UILabel *)   textLabel
temperature             : (float)       Temperature
temperatureStatus       : (NSInteger)   Temp_Status {
    NSString *T1_String = [[NSString alloc] initWithFormat:@"%0.1f", Temperature];
    switch (Temp_Status) {
            /**
             * 高於發燒溫度視為發燒 轉為紅字
             */
        case 1:
            textLabel.textColor = [UIColor redColor];
            break;
            /**
             * 高於冷冷溫度和低於發燒溫度視為正常 轉為橘色
             */
        case 2:
            textLabel.textColor = [UIColor brownColor];
            break;
            /**
             * 低於冷冷溫度視為冷冷 轉為藍色
             */
        case 3:
            textLabel.textColor = [UIColor blueColor];
            break;
    }
    
    textLabel.text = T1_String;
    textLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)
setBatteryImage : (UIImageView *) ImageView
battery_Volume  : (NSUInteger) Battery_Volume{
    UIImage *Ima;
    if (Battery_Volume >= 75) {
        Ima = [UIImage imageNamed:@"Battery-1-Bak.png"];
    }
    else if (Battery_Volume >= 50) {
        Ima = [UIImage imageNamed:@"Battery-2-Bak.png"];
    }
    else if(Battery_Volume >= 25) {
        Ima = [UIImage imageNamed:@"Battery-3-Bak.png"];
    }
    else {
        Ima = [UIImage imageNamed:@"Battery-4-Bak.png"];
    }
    [ImageView setImage:Ima];
}


- (void)
setLoadingView   : (__kindof UICollectionViewCell *)    cell {
        // 顯示資訊
        UIImageView *Movement_Light_ImageView = [cell viewWithTag:1];
        [Movement_Light_ImageView setHidden:true];
        UILabel *Temperature_Label = [cell viewWithTag:2];
        [Temperature_Label setHidden:true];
        UIImageView *Battery_Light_ImageView = [cell viewWithTag:3];
        [Battery_Light_ImageView setHidden:true];
    
        // 警告特效
        UIImageView *Warning_ImageView = [cell viewWithTag:4];
        [Warning_ImageView setHidden:true];
        
        UILabel *Name_Label = [cell viewWithTag:5];
        [Name_Label setHidden:true];
        UILabel *ID_Label = [cell viewWithTag:6];
        [ID_Label setHidden:true];
        
        // 照片背景
        UIImageView *Photo_Background_ImageView = [cell viewWithTag:7];
        [Photo_Background_ImageView setHidden:true];
        
        // 資訊欄背景
        UIImageView *Movement_Bar_ImageView = [cell viewWithTag:8];
        [Movement_Bar_ImageView setHidden:true];
        UIImageView *Temperature_Bar_ImageView = [cell viewWithTag:9];
        [Temperature_Bar_ImageView setHidden:true];
        UIImageView *Battery_Bar_ImageView = [cell viewWithTag:10];
        [Battery_Bar_ImageView setHidden:true];
        
        // 讀取中圖示
        UILabel *Loading_Label = [cell viewWithTag:11];
        [Loading_Label setHidden:false];
        
        // 資訊欄標題
        UIImageView *Movement_Title_ImageView = [cell viewWithTag:12];
        [Movement_Title_ImageView setHidden:true];
        UIImageView *Temperature_Title_ImageView = [cell viewWithTag:13];
        [Temperature_Title_ImageView setHidden:true];
        UIImageView *Battery_Title_ImageView = [cell viewWithTag:14];
        [Battery_Title_ImageView setHidden:true];
}

- (void) setNotLoadingView   : (__kindof UICollectionViewCell *)    cell {
    // 顯示資訊
    UIImageView *Movement_Light_ImageView = [cell viewWithTag:1];
    [Movement_Light_ImageView setHidden:false];
    UILabel *Temperature_Label = [cell viewWithTag:2];
    [Temperature_Label setHidden:false];
    UIImageView *Battery_Light_ImageView = [cell viewWithTag:3];
    [Battery_Light_ImageView setHidden:false];

    // 警告特效
    UIImageView *Warning_ImageView = [cell viewWithTag:4];
    [Warning_ImageView setHidden:false];
    
    UILabel *Name_Label = [cell viewWithTag:5];
    [Name_Label setHidden:false];
    UILabel *ID_Label = [cell viewWithTag:6];
    [ID_Label setHidden:false];
    
    // 照片背景
    UIImageView *Photo_Background_ImageView = [cell viewWithTag:7];
    [Photo_Background_ImageView setHidden:false];
    
    // 資訊欄背景
    UIImageView *Movement_Bar_ImageView = [cell viewWithTag:8];
    [Movement_Bar_ImageView setHidden:false];
    UIImageView *Temperature_Bar_ImageView = [cell viewWithTag:9];
    [Temperature_Bar_ImageView setHidden:false];
    UIImageView *Battery_Bar_ImageView = [cell viewWithTag:10];
    [Battery_Bar_ImageView setHidden:false];
    
    // 讀取中圖示
    UILabel *Loading_Label = [cell viewWithTag:11];
    [Loading_Label setHidden:true];
    
    // 資訊欄標題
    UIImageView *Movement_Title_ImageView = [cell viewWithTag:12];
    [Movement_Title_ImageView setHidden:false];
    UIImageView *Temperature_Title_ImageView = [cell viewWithTag:13];
    [Temperature_Title_ImageView setHidden:false];
    UIImageView *Battery_Title_ImageView = [cell viewWithTag:14];
    [Battery_Title_ImageView setHidden:false];
}

- (void) setTrasparentView   : (__kindof UICollectionViewCell *)    cell {
    // 顯示資訊
    UIImageView *Movement_Light_ImageView = [cell viewWithTag:1];
    [Movement_Light_ImageView setAlpha:0.8];
    UILabel *Temperature_Label = [cell viewWithTag:2];
    [Temperature_Label setAlpha:0.8];
    UIImageView *Battery_Light_ImageView = [cell viewWithTag:3];
    [Battery_Light_ImageView setAlpha:0.8];

    // 警告特效
    UIImageView *Warning_ImageView = [cell viewWithTag:4];
    [Warning_ImageView setAlpha:0.8];
    
    UILabel *Name_Label = [cell viewWithTag:5];
    [Name_Label setAlpha:0.8];
    UILabel *ID_Label = [cell viewWithTag:6];
    [ID_Label setAlpha:0.8];
    
    // 照片背景
    UIImageView *Photo_Background_ImageView = [cell viewWithTag:7];
    [Photo_Background_ImageView setAlpha:0.8];
    
    // 資訊欄背景
    UIImageView *Movement_Bar_ImageView = [cell viewWithTag:8];
    [Movement_Bar_ImageView setAlpha:0.8];
    UIImageView *Temperature_Bar_ImageView = [cell viewWithTag:9];
    [Temperature_Bar_ImageView setAlpha:0.8];
    UIImageView *Battery_Bar_ImageView = [cell viewWithTag:10];
    [Battery_Bar_ImageView setAlpha:0.8];
    
    // 讀取中圖示
    UILabel *Loading_Label = [cell viewWithTag:11];
    [Loading_Label setAlpha:0.8];
    
    // 資訊欄標題
    UIImageView *Movement_Title_ImageView = [cell viewWithTag:12];
    [Movement_Title_ImageView setAlpha:0.8];
    UIImageView *Temperature_Title_ImageView = [cell viewWithTag:13];
    [Temperature_Title_ImageView setAlpha:0.8];
    UIImageView *Battery_Title_ImageView = [cell viewWithTag:14];
    [Battery_Title_ImageView setAlpha:0.8];
    
    // 背景
    UIImageView *Background_ImageView = [cell viewWithTag:15];
    [Background_ImageView setAlpha:0.8];
}

- (void) setNotTrasparentView   : (__kindof UICollectionViewCell *)    cell {
    // 顯示資訊
    UIImageView *Movement_Light_ImageView = [cell viewWithTag:1];
    [Movement_Light_ImageView setAlpha:1];
    UILabel *Temperature_Label = [cell viewWithTag:2];
    [Temperature_Label setAlpha:1];
    UIImageView *Battery_Light_ImageView = [cell viewWithTag:3];
    [Battery_Light_ImageView setAlpha:1];

    // 警告特效
    UIImageView *Warning_ImageView = [cell viewWithTag:4];
    [Warning_ImageView setAlpha:1];
    
    UILabel *Name_Label = [cell viewWithTag:5];
    [Name_Label setAlpha:1];
    UILabel *ID_Label = [cell viewWithTag:6];
    [ID_Label setAlpha:1];
    
    // 照片背景
    UIImageView *Photo_Background_ImageView = [cell viewWithTag:7];
    [Photo_Background_ImageView setAlpha:1];
    
    // 資訊欄背景
    UIImageView *Movement_Bar_ImageView = [cell viewWithTag:8];
    [Movement_Bar_ImageView setAlpha:1];
    UIImageView *Temperature_Bar_ImageView = [cell viewWithTag:9];
    [Temperature_Bar_ImageView setAlpha:1];
    UIImageView *Battery_Bar_ImageView = [cell viewWithTag:10];
    [Battery_Bar_ImageView setAlpha:1];
    
    // 讀取中圖示
    UILabel *Loading_Label = [cell viewWithTag:11];
    [Loading_Label setAlpha:1];
    
    // 資訊欄標題
    UIImageView *Movement_Title_ImageView = [cell viewWithTag:12];
    [Movement_Title_ImageView setAlpha:1];
    UIImageView *Temperature_Title_ImageView = [cell viewWithTag:13];
    [Temperature_Title_ImageView setAlpha:1];
    UIImageView *Battery_Title_ImageView = [cell viewWithTag:14];
    [Battery_Title_ImageView setAlpha:1];
    
    // 背景
    UIImageView *Background_ImageView = [cell viewWithTag:15];
    [Background_ImageView setAlpha:1];
}
@end
