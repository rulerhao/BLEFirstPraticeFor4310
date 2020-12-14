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
#import "CameraController.h"
#import "SketchView.h"
#import "ChangeBetweenWriteStringViewController.h"
#import "InformationRunnable.h"
#import "SaveInformationFunc.h"
#import "KS4310Setting.h"
#import "SwitchDevices.h"

#import <MQTTClient.h>
#import <MQTTWebsocketTransport.h>
#import "Message.pbobjc.h"
#import "Sensor.pbobjc.h"
#import "Device.pbobjc.h"
#import "StampTimeProcess.h"
#import "TypesConversion.h"
#import "IDFVProcess.h"
#import "MQTTSetting.h"
#import "MQTTMain.h"
#import "OAuth2Main.h"
#import <OIDAuthorizationRequest.h>
#import "PublishDataFor4320.h"
@interface ViewController : UIViewController <
CBCentralManagerDelegate,
CBPeripheralDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UICollectionViewDragDelegate,
UICollectionViewDropDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (strong, nonatomic) CBCentralManager *myCBCentralManager;
@property (strong, nonatomic) CBPeripheral *myCBPeripheral;
@property (strong, nonatomic) NSMutableArray *Scanned;
@property (strong, nonatomic) NSMutableArray *StoredDevices;
@property (strong, nonatomic) NSMutableArray *DevicesInformation;
@property (strong, nonatomic) NSArray<CBService *> *services;
@property (strong, nonatomic) NSMutableArray *Order_Items_Index;
@property (readwrite, assign) NSIndexPath *NowClickIndexPath;


@end
