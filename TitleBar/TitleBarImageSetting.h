//
//  TitleBarImageSetting.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageSetting.h"
NS_ASSUME_NONNULL_BEGIN

@interface TitleBarImageSetting : NSObject
{
    UIImage *Title_User_Image;
    float Title_User_ImageView_Height;
    float Title_User_ImageView_Width;

    UIImage *OUCare_IC_Logo_Image;
    float  OUCare_IC_Logo_ImageView_Height;
    float  OUCare_IC_Logo_ImageView_Width;
    
}
@property (readwrite, nonatomic) UIImage *Title_User_Image;
@property (readwrite, nonatomic) float Title_User_ImageView_Height;
@property (readwrite, nonatomic) float Title_User_ImageView_Width;

@property (readwrite, nonatomic) UIImage *OUCare_IC_Logo_Image;
@property (readwrite, nonatomic) float  OUCare_IC_Logo_ImageView_Height;
@property (readwrite, nonatomic) float  OUCare_IC_Logo_ImageView_Width;

@end

NS_ASSUME_NONNULL_END
