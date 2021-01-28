//
//  Sensor4310MainBarViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/26.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Sensor4310MainBarViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(readwrite, nonatomic) NSInteger CurrentController;
- (void)controllerInit;
@end

NS_ASSUME_NONNULL_END
