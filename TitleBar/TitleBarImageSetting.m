//
//  TitleBarImageSetting.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/13.
//

#import "TitleBarImageSetting.h"

@implementation TitleBarImageSetting

- (instancetype) init {
    ImageSetting *imageSetting = [[ImageSetting alloc] init];
    
    Title_User_Image = [UIImage imageNamed:@"title_user.png"];
    NSLog(@"aimaimaidm = %f", imageSetting.Edge_Length);
    Title_User_ImageView_Height = imageSetting.Kjump_Background_Title_Bar_Height - 2 * imageSetting.Edge_Length * imageSetting.Height_Multi;
    Title_User_ImageView_Width = Title_User_ImageView_Height * Title_User_Image.size.width / Title_User_Image.size.height;
    NSLog(@"Title_User_ImageView_Height = %f", Title_User_ImageView_Height);
    NSLog(@"Title_User_ImageView_Width = %f", Title_User_ImageView_Width);
    OUCare_IC_Logo_Image = [UIImage imageNamed:@"oucare_ic_logo.png"];
    OUCare_IC_Logo_ImageView_Height = imageSetting.Kjump_Background_Title_Bar_Height - 2 * imageSetting.Edge_Length * imageSetting.Height_Multi;
    OUCare_IC_Logo_ImageView_Width = OUCare_IC_Logo_ImageView_Height * OUCare_IC_Logo_Image.size.width / OUCare_IC_Logo_Image.size.height;
    return self;
}
@synthesize Title_User_Image;
@synthesize Title_User_ImageView_Height;
@synthesize Title_User_ImageView_Width;

@synthesize OUCare_IC_Logo_Image;
@synthesize OUCare_IC_Logo_ImageView_Height;
@synthesize OUCare_IC_Logo_ImageView_Width;

@end
