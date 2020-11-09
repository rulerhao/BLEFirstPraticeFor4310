//
//  StringProcessFunc.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/28.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StringProcessFunc : UIViewController

- (NSString *)
MergeTwoString  : (NSString *) First_Str
SecondStr       : (NSString *) Second_Str;

- (NSString *)
getSubString    : (NSString *) Ori_String
length          : (NSUInteger) Length
location        : (NSUInteger) Location;

- (BOOL) getIntegerForAll    : (NSString *) Str;
@end

NS_ASSUME_NONNULL_END
