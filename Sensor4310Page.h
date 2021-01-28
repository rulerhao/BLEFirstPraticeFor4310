//
//  Sensor4310ViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/26.
//

#import "ViewController.h"
#import "ShowViewController.h"
NS_ASSUME_NONNULL_BEGIN

@class Sensor4310Page;

@protocol Sensor4310PageDelegate <NSObject>

@optional
- (NSInteger)getCurrentController_Sensor4310Page;
@end

@interface Sensor4310Page : UIViewController

@property (assign) id <Sensor4310PageDelegate> delegate;
@property(readwrite, nonatomic) NSInteger CurrentController;

@end

NS_ASSUME_NONNULL_END
