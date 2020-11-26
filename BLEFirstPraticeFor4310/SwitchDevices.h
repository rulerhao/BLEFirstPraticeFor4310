//
//  SwitchDevices.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/26.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SwitchDevices : UIViewController

- (void)
switchDevices   : (UICollectionView *)  myCollectionView
orderItemsIndex : (NSMutableArray *)    Order_Items_Index
storedDevices   : (NSMutableArray *)    StoredDevices
indexPath       : (NSIndexPath *)       IndexPath;

@end

NS_ASSUME_NONNULL_END
