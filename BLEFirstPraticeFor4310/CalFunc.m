//
//  DoSomeThingFunction.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/26.
//

#import "CalFunc.h"
#import "StringProcessFunc.h"

@interface CalFunc ()

@end

@implementation CalFunc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

/*!
 * @param str : 要被轉換為 Integer 的 NSString
 *  @discussion
 *      將 NSString 轉換為 Integer
 *      例如 @"16" = 1 * 16 ^ 1 + 6 * 16 ^ 0
 *
 */
- (NSInteger)getIntegerFromHexString:(NSString *) str {
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner scanHexInt:&outVal];
    NSInteger IntegerValue = outVal;
    return IntegerValue;
}

/*!
 * @param HexString : 要被轉換為 ASCII String 的 Hex String
 *  @discussion
 *      將 Hex String 轉換為 ASCII String
 *
 */
- (NSString *)
HexStringToASCIIString:(NSString *)HexString {
    NSString *Merged_String = [[NSString alloc] init];
    
    for(int i = 0; i < [HexString length]; i = i + 2) {
        StringProcessFunc *str_Process_Func = [[StringProcessFunc alloc] init];
        
        NSString *Per_SubString = [str_Process_Func getSubString:HexString
                                                    length      :2
                                                    location    :i];
        /**
         * 假如十六進位為00則不轉換
         */
        if([Per_SubString isEqual:@"00"]) {
            break;
        }
        NSInteger IntegerFromHex = [self getIntegerFromHexString:Per_SubString];
        
        // ASCII to NSString
        
        char ASCIIChar = [self getASCIICharThroughInteger:IntegerFromHex];
        NSString *ASCIIString = [self getStringFromChar:ASCIIChar];
        // Merge String
        Merged_String = [str_Process_Func MergeTwoString : Merged_String
                                          SecondStr      : ASCIIString];
    }
    return Merged_String;
}

/*!
 * @param Integer : 要被轉換為ASCII的十進位數
 *  @discussion
 *      將十進位整數轉換為ASCII char
 *      例如
 *      49->1
 *      50->2
 *      83->3
 *
 */
- (char)
getASCIICharThroughInteger: (NSInteger) Integer {
    // ASCII to NSString
    char ASCIIChar = (char) Integer;
    return ASCIIChar;
}

/*!
 * @param ch : 要被轉換為 String 的 char
 *  @discussion
 *   將 char 轉換為 NSString
 *
 */
- (NSString *)
getStringFromChar: (char) ch {
    NSString *ASCIIString = [NSString stringWithFormat:@"%c", ch];
    return ASCIIString;
}

@end
