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

/*!
 * @discussion
 *  刪除所有 Origin_String 內所包含的 Sub_String
 *  運用 Recursive 來刪去所有的 Sub_String
 *  Delete all Sub_String in Origin_String through recutsive method.
 *
 *  Example :
 *  Origin_String = @"ababab";
 *  Sub_String = @"ba";
 *  ans : @"ab";
 *
 *  @param Origin_String :
 *  原本完整的 String
 *  The origin string that was not yet processed
 *  @param Sub_String : 要被切割的 String
 *  The string that we want to cut from origin string
 */
- (NSString *)
deleteSubString : (NSString *) Origin_String
subString       : (NSString *) Sub_String
{
    NSUInteger Sub_String_Location = [Origin_String rangeOfString:Sub_String].location;
    if(Sub_String_Location == NSNotFound)
    {
        return Origin_String;
    }
    else
    {
        NSLog(@"Inner = %@", Origin_String);
        NSString *Front_Part_String = [self getSubString:Origin_String
                                                  length:Sub_String_Location
                                                location:0];
        
        NSString *Back_Part_String = [self getSubString:Origin_String
                                                 length:[Origin_String length] - Sub_String_Location - [Sub_String length]
                                               location:Sub_String_Location + [Sub_String length]];
        
        NSString *New_String = [self MergeTwoString:Front_Part_String
                                          SecondStr:Back_Part_String];
        
        return [self deleteSubString:New_String
                           subString:Sub_String];
    }
}
@end
