//
//  4310SenseViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/5.
//

#import <UIKit/UIKit.h>
#import "OAuthTest.h"
#import "BLEFor4310Test.h"
#import "MQTTFor4310Test.h"
#import "Sensor4310TestViewController.h"
#import "Register4310TestViewController.h"
#import <Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface Sensor4310TestController : UIViewController <BLEFor4310TestDelegate, OAuthTestDelegate, MQTTFor4310TestDelegate, Sensor4310TestViewControllerDelegate, Register4310TestViewControllerDelegate>

@property(readwrite, nonatomic) NSInteger CurrentController;

- (void) controllerInit;
- (void) registerButtonBeClicked;
@end

NS_ASSUME_NONNULL_END
