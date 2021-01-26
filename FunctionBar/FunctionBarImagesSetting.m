//
//  FunctionBarImagesSetting.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/15.
//

#import "FunctionBarImagesSetting.h"

@implementation FunctionBarImagesSetting
- (instancetype) init {
    ImageSetting *imageSetting = [[ImageSetting alloc] init];
    
    float ScreenWidth = [[UIScreen mainScreen] bounds].size.width ;
    float Button_Width_Origin = 92;
    float Button_Height_Origin = 80;
    
    Edge_Length = imageSetting.Kjump_Background_Function_Bar_Height / 20;
    Heigth_Edge_Length = imageSetting.Kjump_Background_Function_Bar_Height / 20;
    Width_Edge_Length = [[UIScreen mainScreen] bounds].size.width / 80;
    
    Button_Height = imageSetting.Kjump_Background_Function_Bar_Height - Heigth_Edge_Length * 2;
    Button_Width = Button_Height * Button_Width_Origin / Button_Height_Origin;
    Interval_Length = (ScreenWidth - 5 * Button_Width - 2 * Width_Edge_Length) / 4;
    // 4 interval
    // 2 edge
    // 5 button
    return self;
}
@synthesize Edge_Length;
@synthesize Heigth_Edge_Length;
@synthesize Width_Edge_Length;

@synthesize Button_Height;
@synthesize Button_Width;
@synthesize Interval_Length;

@end
