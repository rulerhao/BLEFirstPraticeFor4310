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
    UICollectionViewCell *cell;
    Convert4310Information *convert_Characteristic;
    KS4310Setting *ks4310Setting;
}
@property (strong, nonatomic) UICollectionView *myCollectionView;
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
}

#pragma mark - CollectionView Delegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCollectionViewIdentifier" forIndexPath:indexPath];
    //--------------------- Background ImageVIew -----------------------
    UIImageView *Background_ImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_background.png"]];
    [cell addSubview:Background_ImageVIew];
    
    //--------------------- Baby Photo Background ImageView -----------------------
    UIImageView *Baby_Photo_Background_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_boy_photo_background2.png"]];
    [cell addSubview:Baby_Photo_Background_ImageView];
    
    //--------------------- Baby Name TextView -----------------------
    UITextView *Baby_Name_TextView = [[UITextView alloc] init];
    Baby_Name_TextView.text = @"Fan";
    Baby_Name_TextView.scrollEnabled = NO;
    Baby_Name_TextView.editable = NO;
    [cell addSubview:Baby_Name_TextView];
    
    //--------------------- Information Bar -----------------------
    UIImageView *Baby_Information_Bar1_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_boy_information_bar_background.png"]];
    UIImageView *Baby_Information_Bar2_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_boy_information_bar_background.png"]];
    UIImageView *Baby_Information_Bar3_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_boy_information_bar_background.png"]];
    [cell addSubview:Baby_Information_Bar1_ImageView];
    [cell addSubview:Baby_Information_Bar2_ImageView];
    [cell addSubview:Baby_Information_Bar3_ImageView];
    
    //--------------------- Temperature TextView -----------------------
    UITextView *Temperature_TextView = [[UITextView alloc] init];
    Temperature_TextView.text = @"0";
    Temperature_TextView.scrollEnabled = NO;
    Temperature_TextView.editable = NO;
    Temperature_TextView.backgroundColor = [UIColor clearColor];
    Temperature_TextView.textAlignment = NSTextAlignmentCenter;
    [Temperature_TextView setTag:5];
    [cell addSubview:Temperature_TextView];
    
    
    // ---------------------- 該次的 Cell ----------------------
    StoredDevicesCell *Previous_Stored_Deivce_Cell = [[StoredDevicesCell alloc] init];
    Previous_Stored_Deivce_Cell = [Stored_Devices objectAtIndex:[indexPath row]];

    if([[[Previous_Stored_Deivce_Cell Peripheral] name] isEqual:@"KS-4310"]) {
        // ---------------------- 判別這次手機發出的模式 ----------------------
        NSData *Mode_Identifier = [[Previous_Stored_Deivce_Cell Characteristic] subdataWithRange:NSMakeRange(0, 1)];
        // ---------------------- Mode_Identifier == @"00" ----------------------
        if([Mode_Identifier isEqual:ks4310Setting.Sense_Identifier]) {
            float T1 = [convert_Characteristic getTemperature_1:[Previous_Stored_Deivce_Cell Characteristic]];
            NSLog(@"Temp1 = %f", T1);
            Temperature_TextView.text = [[NSNumber numberWithFloat:T1] stringValue];
        }
        // ---------------------- Mode_Identifier == @"04" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Baby_Information_Identifier]) {
        }
        // ---------------------- Mode_Identifier == @"05" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Write_Identifier]) {
        }
    }
    
    
    //--------------------- Constraint -----------------------
    //--------------------- Background ImageVIew -----------------------
    [Background_ImageVIew mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top);
        make.bottom.equalTo(cell.mas_bottom);
        make.left.equalTo(cell.mas_left);
        make.right.equalTo(cell.mas_right);
    }];
    //--------------------- Baby Photo Background ImageView -----------------------
    [Baby_Photo_Background_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Background_ImageVIew.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Photo_Background_Top_Constraint);
        make.bottom.equalTo(Background_ImageVIew.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Photo_Background_Bottom_Constraint);
        make.left.equalTo(Background_ImageVIew.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Photo_Background_Left_Constraint);
        make.right.equalTo(Background_ImageVIew.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Photo_Background_Right_Constraint);
    }];
    //--------------------- Information Bar -----------------------
    [Baby_Information_Bar3_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Background_ImageVIew.mas_bottom).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar3_Top_Constraint);
        make.bottom.equalTo(Background_ImageVIew.mas_bottom).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar3_Bottom_Constraint);
        make.left.equalTo(Background_ImageVIew.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar3_Left_Constraint);
        make.right.equalTo(Background_ImageVIew.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar3_Right_Constraint);
    }];
    
    [Baby_Information_Bar2_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Information_Bar3_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar2_Top_Constraint);
        make.bottom.equalTo(Baby_Information_Bar3_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar2_Bottom_Constraint);
        make.left.equalTo(Background_ImageVIew.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar2_Left_Constraint);
        make.right.equalTo(Background_ImageVIew.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar2_Right_Constraint);
    }];
    
    [Baby_Information_Bar1_ImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Information_Bar2_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar1_Top_Constraint);
        make.bottom.equalTo(Baby_Information_Bar2_ImageView.mas_top).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar1_Bottom_Constraint);
        make.left.equalTo(Background_ImageVIew.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar1_Left_Constraint);
        make.right.equalTo(Background_ImageVIew.mas_left).offset(sensor4310Setting.Baby_Card_Boy_Information_Bar1_Right_Constraint);
    }];
    
    //--------------------- Temperature TextView -----------------------
    [Temperature_TextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Baby_Information_Bar2_ImageView.mas_top);
        make.bottom.equalTo(Baby_Information_Bar2_ImageView.mas_bottom);
        make.left.equalTo(Baby_Information_Bar2_ImageView.mas_centerX);
        make.right.equalTo(Baby_Information_Bar2_ImageView.mas_right);
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return Stored_Devices.count;
}

// ---------------------- Cell 大小 ------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RequestOAuth2Steps *requestOAuth2Steps = [[RequestOAuth2Steps alloc] init];
    [requestOAuth2Steps takeDevicesInformation:OAuth.Access_Token wKWebView:OAuth.WKWeb_View];
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

- (void)addNewDevice:(CBPeripheral *)peripheral {
    
}

- (void)updateCharacteristic:(CBPeripheral *)peripheral characteristic :(CBCharacteristic *)characteristic {
    NSLog(@"TestBleDeleage = %@", characteristic);
}

- (void)synchronizeStoredDevices:(NSMutableArray *)stored_Devices {
    Stored_Devices = stored_Devices;
}

- (void)updateForBusy:(NSMutableArray *)stored_Devices {
    Stored_Devices = stored_Devices;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.myCollectionView reloadData];
    }];
}
@end
