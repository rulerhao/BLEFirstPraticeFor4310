//
//  ImageSetting.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageSetting : NSObject
{
    float ScreenWidth;
    float ScreenHeight;
    
    float Edge_Length;
    
    float Width_Multi;
    float Height_Multi;
    
    UIImage *Kjump_Background_Image;
    float Kjump_Background_Image_Width;
    float Kjump_Background_Image_Height;
    
    float Kjump_Background_Title_Bar_Height;
    float Kjump_Background_Function_Bar_Height;
    float Kjump_Background_Main_Bar_Height;
    float Kjump_Background_Ad_Bar_Height;
}

@property (readwrite, nonatomic) NSInteger CurrentController;

@property (readwrite, nonatomic) float ScreenWidth;
@property (readwrite, nonatomic) float ScreenHeight;

@property (readwrite, nonatomic) float Edge_Length;

@property (readwrite, nonatomic) float  Width_Multi;
@property (readwrite, nonatomic) float  Height_Multi;

@property (readwrite, nonatomic) UIImage *Kjump_Background_Image;
@property (readwrite, nonatomic) float Kjump_Background_Image_Width;
@property (readwrite, nonatomic) float Kjump_Background_Image_Height;

@property (readwrite, nonatomic) float Kjump_Background_Title_Bar_Height;
@property (readwrite, nonatomic) float Kjump_Background_Function_Bar_Height;
@property (readwrite, nonatomic) float Kjump_Background_Main_Bar_Height;
@property (readwrite, nonatomic) float Kjump_Background_Ad_Bar_Height;
@end

NS_ASSUME_NONNULL_END
