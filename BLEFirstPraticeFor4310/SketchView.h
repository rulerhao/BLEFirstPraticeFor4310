//
//  SketchView.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/2.
//

#import "ViewController.h"
#import "Convert4310Information.h"

NS_ASSUME_NONNULL_BEGIN

@interface SketchView : UIViewController

- (void)
setDeviceReturnInformation   : (__kindof UICollectionViewCell *)    cell
storedDevices                : (NSMutableArray *)                   StoredDevices
movementScanTime             : (NSInteger)                          MovementScanTime
highTemperature              : (float)                              HighTemperature
lowTemperature               : (float)                              LowTemperature
IndexPath                    : (NSIndexPath *)                      Index_Path;
    
- (void)
setDeviceInformation            : (__kindof UICollectionViewCell *)    cell
storedDevices                   : (NSMutableArray *)                   StoredDevices
indexPath                       : (NSIndexPath *)                      Index_Path;

- (void)
setLoadingView   : (__kindof UICollectionViewCell *)    cell;

- (void)
setNotLoadingView   : (__kindof UICollectionViewCell *)    cell ;

- (void) setTrasparentView   : (__kindof UICollectionViewCell *)    cell;

- (void) setNotTrasparentView   : (__kindof UICollectionViewCell *)    cell;

@end
NS_ASSUME_NONNULL_END
