//
//  PublishDataFor4320.h
//  MQTTTest
//
//  Created by louie on 2020/11/19.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublishDataImplement : UIViewController
- (NSData *)
getPublishData        : (NSString *) Model
Device_Serial         : (NSString *) Serial
Device_UUID           : (NSString *) UUID
Temperature1          : (NSInteger)  t1
Temperature2          : (NSInteger)  t2
Temperature3          : (NSInteger)  t3
Battery               : (int)        bat
Breath                : (BOOL)       bre
Motion_X              : (float)      motion_X
Motion_Y              : (float)      motion_Y
Motion_Z              : (float)      motion_Z;

- (void) publishData : (NSData *) Publish_Data
             session : (MQTTSession *) Session;

@end

NS_ASSUME_NONNULL_END
