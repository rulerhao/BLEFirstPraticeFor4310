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
    search_Range.length = Length;
    search_Range.location = Location;
    NSString *new_String = [Ori_String substringWithRange:search_Range];
    
    return new_String;
}

@end
