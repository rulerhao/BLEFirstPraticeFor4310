//
//  TypesCoversion.m
//  MQTTTest
//
//  Created by louie on 2020/11/20.
//

#import "TypesConversion.h"

@interface TypesConversion ()

@end

@implementation TypesConversion

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*!
 * @param data_bytes : 要被轉換為 Hex String 的 NSData
 *  @discussion
 *      將 NSData 轉換為 HexString
 *
 */
- (NSString *)getHEX:(NSData *)data_bytes
{
    const unsigned char *dataBytes = [data_bytes bytes];
    NSMutableString *ret = [NSMutableString stringWithCapacity:[data_bytes length] * 2];
    for (int i = 0; i<[data_bytes length]; ++i)
    [ret appendFormat:@"%02lX", (unsigned long)dataBytes[i]];
    return ret;
}
@end
