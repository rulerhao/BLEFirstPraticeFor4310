//
//  EncodeOrguitsUUIDAndTimeStamp.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/2/5.
//

#import "EncodeOrguitsUUIDAndTimeStamp.h"

@implementation EncodeOrguitsUUIDAndTimeStamp

- (NSString *) StringToCrc32Format : (NSString *) Input_String {
    // nsstring to nsdata
//    NSString *UUIDString = @"091cca66-181c-11eb-8cca-0242ac160004";
    NSString *UUIDString = Input_String;
    NSData* UUIDData = [UUIDString dataUsingEncoding:NSUTF8StringEncoding];
    
    //-------------- NSData to NSString -------------
    // NSString* newStr = [[NSString alloc] initWithData:UUIDData encoding:NSUTF8StringEncoding];
    // NSLog(@"ReverseData = %@", newStr);
    //-------------- NSData to NSString -------------
    
    // to crc32 checksum
    uLong crc = crc32(0L, Z_NULL, 0);
    NSUInteger result = crc32_z(crc, [UUIDData bytes], (unsigned int)[UUIDData length]);
    
    // int to hex
    NSString *CRC32HexString = [[NSString stringWithFormat:@"%02lx", (unsigned long)result] uppercaseString];
    NSLog(@"ResultString = %@", CRC32HexString);
    return CRC32HexString;
}

- (NSString *) getHexTimeStamp : (NSTimeInterval) timeInterval {
    //time interval
    NSLog(@"timeInterveral = %f", timeInterval);
    long Time = timeInterval * 1000 * 1000;
    
    NSString *TimeString = [[NSString stringWithFormat:@"%02lx", (long)Time] uppercaseString];
    NSLog(@"TimeString = %@", TimeString);
    return TimeString;
}

- (NSString *) getSerialString : (NSString *) InputString timeInterval : (NSTimeInterval) timeInterval {
    NSMutableString *SerialString = [[NSMutableString alloc] init];
    [SerialString appendString:[self StringToCrc32Format:InputString]];
    [SerialString appendString:@"0"];
    [SerialString appendString:[self getHexTimeStamp:timeInterval]];
    
    return [SerialString uppercaseString];
}

- (NSMutableDictionary *) getDeviceSerialDictionary : (NSString *) Model
                                           orgunits : (NSString *) Orgunits
                                       timeInterval : (NSTimeInterval) timeInterval {
    
    NSMutableDictionary *Dict = [[NSMutableDictionary alloc] init];

    // Serial
    NSMutableString *SerialString = [[NSMutableString alloc] init];
    [SerialString appendString:[self StringToCrc32Format:Orgunits]];
    [SerialString appendString:@"0"];
    [SerialString appendString:[self getHexTimeStamp:timeInterval]];
    
    [Dict setValue:Model forKey:@"model"];
    [Dict setValue:SerialString forKey:@"serial"];
    [Dict setValue:[NSNumber numberWithDouble:timeInterval] forKey:@"time"];
    
    return Dict;
}
@end
