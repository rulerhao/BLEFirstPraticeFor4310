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

@interface ShowViewController : UIViewController

@property (readwrite, nonatomic) NSInteger CurrentController;

@end

NS_ASSUME_NONNULL_END
