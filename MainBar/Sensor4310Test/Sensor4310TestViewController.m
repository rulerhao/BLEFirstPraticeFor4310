//
//  Sensor4310TestViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/15.
//

#import "Sensor4310TestViewController.h"
#import "StoredDevicesCell.h"
#import "KS4310Setting.h"
#import "Convert4310Information.h"
#import <Masonry.h>
@interface Sensor4310TestViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    Sensor4310Setting *sensor4310Setting;
    KS4310Setting *ks4310Setting;
    Convert4310Information *convert_Characteristic;
}
@property (strong, nonatomic) UICollectionView *cardCollectionView;

@end

@implementation Sensor4310TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) controllerInit {
    ks4310Setting = [[KS4310Setting alloc] init];
    [ks4310Setting InitKS4310Setting];
    convert_Characteristic = [Convert4310Information alloc];
    sensor4310Setting = [[Sensor4310Setting alloc] init];
    
    [self viewInit];
    
    [self updateConstraints];
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- Init -----------------------
    //--------------------- View -----------------------
    //--------------------- Collection View -----------------------
    UICollectionViewFlowLayout *cardCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    cardCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.cardCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:cardCollectionViewLayout];
    [self.cardCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cardCollectionViewIdentifier"];
    self.cardCollectionView.delegate = self;
    self.cardCollectionView.dataSource = self;
    self.cardCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: self.cardCollectionView];
    NSLog(@"FirstTestmyTableView = %@", self.cardCollectionView);
}

#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- Collection View -----------------------
    [self.cardCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - Collection View Delegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCollectionViewIdentifier" forIndexPath:indexPath];
    NSLog(@"TestViewWithTagOutSide");
    
    NSLog(@"ContentViewOfCell = %lu", (unsigned long)[[cell subviews] count]);
    //NSLog(@"ContentViews = %@", [cell subviews]);
    // 1 為 原本的 UIVIEW
    // 藉此判定是否要新增 Cell 中的 View
    if ([[cell subviews] count] == 1 || [[cell subviews] count] == 0) {
        NSLog(@"createCollectionViewCell");
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
    NSDictionary *BLEMessageCell = [[NSDictionary alloc] init];
    
    StoredDevicesCell *Stored_Deivce_Cell = [[StoredDevicesCell alloc] init];
    Stored_Deivce_Cell = [self.delegate getStoredDevicesCell:[indexPath row]];
    
    NSLog(@"[[[Stored_Deivce_Cell Peripheral] name] isEqual:@\"KS-4310\"] = %@", [[Stored_Deivce_Cell Peripheral] name]);
    
    if([[[Stored_Deivce_Cell Peripheral] name] isEqual:@"KS-4310"]) {
        // ---------------------- 判別這次手機發出的模式 ----------------------
        NSData *Mode_Identifier = [[Stored_Deivce_Cell Characteristic] subdataWithRange:NSMakeRange(0, 1)];
        NSLog(@"ks4310Setting.Sense_Identifier = %@", Mode_Identifier);
        NSLog(@"ks4310Setting.Sense_Identifier2 = %@", ks4310Setting.Sense_Identifier);
        // ---------------------- Mode_Identifier == @"00" ----------------------
        if([Mode_Identifier isEqual:ks4310Setting.Sense_Identifier]) {
            Serial_TextView.text = [Stored_Deivce_Cell.Device_EPROM uppercaseString] ;
            
            Movement_TextView.text = @"Normal";
            
            float T1 = [convert_Characteristic getTemperature_1:[Stored_Deivce_Cell Characteristic]];
            NSLog(@"Temp1 = %f", T1);
            Temperature_TextView.text = [[NSNumber numberWithFloat:T1] stringValue];
            NSLog(@"Temp in collectionview = %f", T1);
            NSUInteger Battery = [convert_Characteristic getBattery_Volume:[Stored_Deivce_Cell Characteristic]];
            Battery_TextView.text = [[NSNumber numberWithLong:Battery] stringValue ];
        }
        // ---------------------- Mode_Identifier == @"04" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Baby_Information_Identifier]) {
        }
        // ---------------------- Mode_Identifier == @"05" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Write_Identifier]) {
        }
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 監測模式
    return [self.delegate getSotredDataCount];
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
    NSLog(@"indexPath = %@", indexPath);
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

#pragma mark - Reload Data
- (void) reloadCellAt : (NSInteger) Index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:Index inSection:0];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    [indexPaths addObject:indexPath];
    NSLog(@"Test reload cell at");
    [self.cardCollectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void) insertCellAt : (NSInteger) Index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:Index inSection:0];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    [indexPaths addObject:indexPath];
    
    [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];
}

- (void) deleteCellAt : (NSInteger) Index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:Index inSection:0];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    [indexPaths addObject:indexPath];
    
    [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
}
@end
