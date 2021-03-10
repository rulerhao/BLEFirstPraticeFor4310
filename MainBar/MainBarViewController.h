//
//  MainBarViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/22.
//

#import "ViewController.h"
#import <Masonry.h>
#import "Sensor4310MainBarViewController.h"
#import "OrganizationMainBarViewController.h"
#import "Register4310ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MainBarViewController;

@protocol MainBarViewControllerDelegate <NSObject>

@optional
- (NSInteger)getCurrentController_MainBarViewControlelr;
@end
//
@interface MainBarViewController : UIViewController

@property (assign) id <MainBarViewControllerDelegate> delegate;
@property(readwrite, nonatomic) NSInteger CurrentController;
- (void)controllerInit;

@end

NS_ASSUME_NONNULL_END
