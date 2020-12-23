//
//  StampTimeProcess.m
//  MQTTTest
//
//  Created by louie on 2020/11/19.
//

#import "StampTimeProcess.h"

@interface StampTimeProcess ()

@end

@implementation StampTimeProcess

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (UInt32) getTimeStampSecond
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    UInt32 timeStampLong = timeStamp;
    NSLog(@"timeStampLong:%lu", (unsigned long)timeStampLong);
    return timeStampLong;
}

- (UInt32) getTimeStampNanosecond
{
    StringProcessFunc *stringProcessFunctioc = [[StringProcessFunc alloc] init];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    NSString *timeStampString = [timeStampObj stringValue];
    
    // 取包含小數點的字串長度
    NSUInteger timeStampInt = [timeStampObj integerValue];
    NSString* timeStampIntString = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)timeStampInt];
    NSUInteger Length_Before_Point = [timeStampIntString length];
    NSUInteger Length_Before_And_Contain_Point = Length_Before_Point + 1;
    
    NSLog(@"timeStampString:%@", timeStampString);
    
    // 小數點後的字串
    NSString *StringAfterPoint = [stringProcessFunctioc getSubString:timeStampString
                                                              length:[timeStampString length] - Length_Before_And_Contain_Point
                                                            location:Length_Before_And_Contain_Point];
    UInt32 NanoSecond = [StringAfterPoint intValue] * 1000;
    NSLog(@"timeStampLong:%lu", (unsigned long)NanoSecond);
    return NanoSecond;
}

@end
