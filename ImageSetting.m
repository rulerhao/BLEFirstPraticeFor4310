//
//  ImageSetting.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/13.
//

#import "ImageSetting.h"

@interface ImageSetting ()

@end

@implementation ImageSetting

- (instancetype) init {
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    NSLog(@"window.safeAreaInsetstest2_height = %f", window.safeAreaLayoutGuide.layoutFrame.size.height);
    NSLog(@"window.safeAreaInsetstest2_width = %f", window.safeAreaLayoutGuide.layoutFrame.size.width);
    
//    ScreenWidth = [[UIScreen mainScreen] bounds].size.width;
//    ScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    ScreenWidth = window.safeAreaLayoutGuide.layoutFrame.size.width;
    ScreenHeight = window.safeAreaLayoutGuide.layoutFrame.size.height;
    
    NSLog(@"ScreenHeight = %f", ScreenHeight);
    Edge_Length = 15;
    
    Kjump_Background_Image = [UIImage imageNamed:@"background.png"];
    Kjump_Background_Image_Width = 480;
    Kjump_Background_Image_Height = 800;
    
    Width_Multi = ScreenWidth / Kjump_Background_Image_Width;
    Height_Multi = ScreenHeight / Kjump_Background_Image_Height;
    
    Kjump_Background_Title_Bar_Height = 84 * Height_Multi;
    Kjump_Background_Function_Bar_Height = 88 * Height_Multi;
    Kjump_Background_Main_Bar_Height = 540 * Height_Multi;
    Kjump_Background_Ad_Bar_Height = 88 * Height_Multi;
    
    return self;
}

@synthesize ScreenWidth;
@synthesize ScreenHeight;

@synthesize Edge_Length;

@synthesize Width_Multi;
@synthesize Height_Multi;

@synthesize Kjump_Background_Image;
@synthesize Kjump_Background_Image_Width;
@synthesize Kjump_Background_Image_Height;

@synthesize Kjump_Background_Title_Bar_Height;
@synthesize Kjump_Background_Function_Bar_Height;
@synthesize Kjump_Background_Main_Bar_Height;
@synthesize Kjump_Background_Ad_Bar_Height;


@end
