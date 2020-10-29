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

@interface ViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong, nonatomic) CBCentralManager *myCBCentralManager;
@property(strong, nonatomic) CBPeripheral *myCBPeripheral;
@property(strong, nonatomic) NSMutableArray *Scanned;
@property(strong, nonatomic) NSMutableArray *StoredDevices;
@property(strong, nonatomic) NSMutableArray *DevicesInformation;
@property(strong, nonatomic) NSArray<CBService *> *services;


@end
