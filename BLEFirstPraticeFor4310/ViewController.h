//
//  ViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/9/25.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "cellData.h"
#import "CalFunc.h"
#import "StringProcessFunc.h"
#import "CameraFunc.h"
#import "SketchView.h"
#import "ChangeBetweenWriteStringViewController.h"
#import "InformationRunAvailable.h"

@interface ViewController : UIViewController <
CBCentralManagerDelegate,
CBPeripheralDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UICollectionViewDragDelegate,
UICollectionViewDropDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (strong, nonatomic) CBCentralManager *myCBCentralManager;
@property (strong, nonatomic) CBPeripheral *myCBPeripheral;
@property (strong, nonatomic) NSMutableArray *Scanned;
@property (strong, nonatomic) NSMutableArray *StoredDevices;
@property (strong, nonatomic) NSMutableArray *DevicesInformation;
@property (strong, nonatomic) NSArray<CBService *> *services;
@property (strong, nonatomic) NSMutableArray *Order_Items_Index;
@property (readwrite, assign) NSIndexPath *NowClickIndexPath;


@end
