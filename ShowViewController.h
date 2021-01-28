//
//  ShowViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/13.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "ViewController.h"
#import "ImageSetting.h"

#import "TitleBarViewController.h"
#import "FunctionBarViewController.h"
#import "MainBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ShowViewController;

@protocol ShowViewControllerDelegate <NSObject>

@optional
- (NSInteger)getCurrentController_ShowViewController;
@end

@interface ShowViewController : UIViewController

@property (assign) id <ShowViewControllerDelegate> delegate;
@property (readwrite, nonatomic) NSInteger CurrentController;
- (void) controllerInit;

@end

NS_ASSUME_NONNULL_END
