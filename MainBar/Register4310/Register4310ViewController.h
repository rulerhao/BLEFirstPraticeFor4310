//
//  Register4310ViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/9.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "BLEForRegister.h"

NS_ASSUME_NONNULL_BEGIN

@interface Register4310ViewController : UIViewController

@property(readwrite, nonatomic) NSInteger CurrentController;

- (void)controllerInit;

@end

NS_ASSUME_NONNULL_END
