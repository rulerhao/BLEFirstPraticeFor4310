//
//  SaveInformation.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/25.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaveInformationFunc : UIViewController

- (NSString *)
saveInformation : (UIAlertController *) alert
storedDevices   : (NSMutableArray *)    StoredDevices
indexPath       : (NSIndexPath *)       indexPath;

@end

NS_ASSUME_NONNULL_END
