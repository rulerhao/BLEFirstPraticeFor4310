//
//  StampTimeProcess.h
//  MQTTTest
//
//  Created by louie on 2020/11/19.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StampTimeProcess : UIViewController

- (UInt32) getTimeStampSecond;
- (UInt32) getTimeStampNanosecond;

@end

NS_ASSUME_NONNULL_END
