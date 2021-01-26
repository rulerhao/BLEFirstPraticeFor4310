//
//  FunctionBarImagesSetting.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/15.
//

#import <Foundation/Foundation.h>
#import "ImageSetting.h"
NS_ASSUME_NONNULL_BEGIN

@interface FunctionBarImagesSetting : NSObject
{
    float Edge_Length;
    float Heigth_Edge_Length;
    float Width_Edge_Length;
    
    float Button_Height;
    float Button_Width;
    
    float Interval_Length;
}


@property (readwrite, nonatomic) float Edge_Length;
@property (readwrite, nonatomic) float Heigth_Edge_Length;
@property (readwrite, nonatomic) float Width_Edge_Length;

@property (readwrite, nonatomic) float Button_Height;
@property (readwrite, nonatomic) float Button_Width;
@property (readwrite, nonatomic) float Interval_Length;
@end
NS_ASSUME_NONNULL_END
