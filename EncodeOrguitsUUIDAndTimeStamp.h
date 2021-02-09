//
//  EncodeOrguitsUUIDAndTimeStamp.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/2/5.
//

#import <Foundation/Foundation.h>
#import <zlib.h>
NS_ASSUME_NONNULL_BEGIN

@interface EncodeOrguitsUUIDAndTimeStamp : NSObject

- (NSString *) getSerialString : (NSString *) InputString timeInterval : (NSTimeInterval) timeInterval;
- (NSMutableDictionary *) getDeviceSerialDictionary : (NSString *) Model
                                        inputString : (NSString *) InputString
                                       timeInterval : (NSTimeInterval) timeInterval;
@end

NS_ASSUME_NONNULL_END
