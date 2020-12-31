//
//  CameraFunc.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/2.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CameraController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate> 

@property (strong, nonatomic) NSMutableArray *StoredDevices;
@property (strong, nonatomic) NSIndexPath *NowClickIndexPath;

- (void)
initCamera          : (NSIndexPath *)        indexPath
storedDevices       : (NSMutableArray *)     StoredDevices
viewControllerSelf  : (id)                   ViewControllerSelf;

- (void)
saveChangedNameImage    : (NSString *) now_Device_Name
delete_Device_Name       : (NSString *) delete_Device_Name;

@end

NS_ASSUME_NONNULL_END
