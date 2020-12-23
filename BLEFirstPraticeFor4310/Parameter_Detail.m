//
//  Parameter_Detail.m
//  MQTTTest
//
//  Created by louie on 2020/12/2.
//

#import "Parameter_Detail.h"

@interface Parameter_Detail ()

@end

@implementation Parameter_Detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)
URLParameter : (NSString *) Title
value : (NSString *) Value
{
    title = Title;
    value = Value;
}

- (NSString *) getTitle
{
    return title;
}

- (NSString *) getValue
{
    return value;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
