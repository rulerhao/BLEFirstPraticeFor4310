//
//  DoSomeThingFunction.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/26.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalFunc : UIViewController

- (NSString *) getHEX:(NSData *) data_Bytes;
- (NSInteger) getIntegerFromHexString:(NSString *) str;
- (NSString *) HexStringToASCIIString:(NSString *) HexString;
- (char) getASCIICharThroughInteger:(NSInteger) Integer;
- (NSString *) getStringFromChar :(char) ch;
- (NSString *)
MergeTwoString  : (NSString *) First_Str
SecondStr       : (NSString *) Second_Str;
- (NSString *)
getSubString    : (NSString *) Ori_String
length          : (NSUInteger) Length
location        : (NSUInteger) Location
;

@end

NS_ASSUME_NONNULL_END
