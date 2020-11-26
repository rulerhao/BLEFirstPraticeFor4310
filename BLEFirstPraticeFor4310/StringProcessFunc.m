//
//  StringProcessFunc.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/28.
//

#import "StringProcessFunc.h"

@interface StringProcessFunc ()

@end

@implementation StringProcessFunc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*!
 * @param First_Str : 在前方被結合的 String
 * @param Second_Str : 在後方被結合的 String
 *  @discussion
 *   將兩個 String 結合為單一 String
 *
 */
- (NSString *)
MergeTwoString: (NSString *) First_Str
SecondStr     : (NSString *) Second_Str {
    NSString *Merged_String = [NSString stringWithFormat:@"%@%@", First_Str, Second_Str];
    return Merged_String;
}
/*!
 * @param Ori_String : 要被切的 string
 * @param Length : 切下的長度
 * @param Location : 由第幾個開始切
 *  @discussion
 *      取得指定長度和位置的 Substring of string
 *
 */
- (NSString *)
getSubString    : (NSString *) Ori_String
length          : (NSUInteger) Length
location        : (NSUInteger) Location {
    NSRange search_Range;
    if(Length < 0 || Location < 0)
    {
        return @"";
    }
    
    if(Length + Location > [Ori_String length])
    {
        Length = [Ori_String length] - Location;
    }
    
    search_Range.length = Length;
    search_Range.location = Location;
    NSString *new_String = [Ori_String substringWithRange:search_Range];
    
    return new_String;
}

- (BOOL) getIntegerForAll    : (NSString *) Str {
    BOOL IntegerForAll = true;
    for(NSInteger i = 0;i < [Str length]; i++) {
        NSString *Now_Char = [self getSubString:Str length:1 location:i];
        if(![Now_Char  isEqual: @"0"] &&
           ![Now_Char  isEqual: @"1"] &&
           ![Now_Char  isEqual: @"2"] &&
           ![Now_Char  isEqual: @"3"] &&
           ![Now_Char  isEqual: @"4"] &&
           ![Now_Char  isEqual: @"5"] &&
           ![Now_Char  isEqual: @"6"] &&
           ![Now_Char  isEqual: @"7"] &&
           ![Now_Char  isEqual: @"8"] &&
           ![Now_Char  isEqual: @"9"]) {
            IntegerForAll = false;
        }
    }
    return IntegerForAll;
}
@end
