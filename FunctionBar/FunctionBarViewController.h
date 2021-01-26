//
//  FunctionBarViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/14.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

#import "ShowViewController.h"
#import "TitleBarImageSetting.h"
#import "ImageSetting.h"
#import "FunctionBarImagesSetting.h"

NS_ASSUME_NONNULL_BEGIN

@class FunctionBarViewController;

@protocol FunctionBarViewControllerDelegate <NSObject>

@optional
- (void)backButtonBeClciked;
- (void)exitButtonBeClciked;
- (void)informationWebSiteButtonBeClciked;
@end

@interface FunctionBarViewController : UIViewController

@property (assign) id <FunctionBarViewControllerDelegate> delegate;
@property(readwrite, nonatomic) NSInteger CurrentController;

@end

NS_ASSUME_NONNULL_END
