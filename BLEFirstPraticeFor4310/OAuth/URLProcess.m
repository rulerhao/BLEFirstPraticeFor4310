//
//  URLProcess.m
//  MQTTTest
//
//  Created by louie on 2020/12/7.
//

#import "URLProcess.h"

@interface URLProcess ()

@end

@implementation URLProcess

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (nullable NSMutableArray *) getURLParameters : (NSString *) query {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    NSString *Now_String = query;
    while(true) {
        NSInteger Equal_Location = [Now_String rangeOfString:@"="].location;
        NSInteger Equal_Length = [Now_String rangeOfString:@"="].length;
        NSInteger And_Location = [Now_String rangeOfString:@"&"].location;
        NSInteger And_Length = [Now_String rangeOfString:@"&"].length;
        //NSLog(@"NowStringHere = %@", Now_String);
        // 如果出現異常時
        if (Equal_Length == 0) {
            return nil;
        }
        // 如果這是最後的參數了
        else if (And_Length == 0) {
            NSUInteger Start_Index = 0;
            NSString *Key = [Now_String substringWithRange:NSMakeRange(Start_Index, Equal_Location)];
            NSString *Value = [Now_String substringWithRange:NSMakeRange(Equal_Location + Equal_Length, [Now_String length] - 1 - Equal_Location)];
            NSMutableDictionary *Parameter = [[NSMutableDictionary alloc] init];
            [Parameter setValue:Value forKey:Key];
            [Parameters addObject:Parameter];
            return Parameters;
        }
        // 正常狀況且不是最後一個參數時
        else {
            NSUInteger Start_Index = 0;
            NSString *Key = [Now_String substringWithRange:NSMakeRange(Start_Index, Equal_Location)];
            NSString *Value = [Now_String substringWithRange:NSMakeRange(Equal_Location + Equal_Length, And_Location - Equal_Location - 1)];
            NSMutableDictionary *Parameter = [[NSMutableDictionary alloc] init];
            [Parameter setValue:Value forKey:Key];
            [Parameters addObject:Parameter];
            Now_String = [Now_String substringWithRange:NSMakeRange(And_Location + 1, [Now_String length] - And_Location - 1)];
        }
    }
}
@end
