//
//  Sensor4310Setting.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/28.
//

#import "Sensor4310Setting.h"

@interface Sensor4310Setting ()
{
    float Container_Height;
    float Container_Width;
    float Interitem_Spacing; // 上下間距
    float Line_Spacing; // 左右間距
    UIEdgeInsets Edge_Insets; // 上下左右邊界距離
}
@end

@implementation Sensor4310Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"viewDidDisappear");
}

- (instancetype) init {
    ImageSetting *imageSetting = [[ImageSetting alloc] init];
    
    float Container_Width = imageSetting.ScreenWidth;
    float Container_Height = imageSetting.Kjump_Background_Main_Bar_Height;

    float Container_Width_Origin = 375;
    float Container_Hieght_Origin = 450;
    
    float Width_Multi = Container_Width / Container_Width_Origin;
    float Height_Multi = Container_Height / Container_Hieght_Origin;
    
    BOOL isPortrait;
    if(Height_Multi >= Width_Multi) {
        isPortrait = YES;
    } else {
        isPortrait = NO;
    }
    
    float Cell_Width_Origin = 165;
    float Cell_Height_Origin = 186;
    
    float LineSpacing_Origin = 15;
    float InteritemSpacing_Origin = 26;
    
    float Inset_Left_Right_Origin = 15;
    float Inset_Top_Down_Origin = 26;
    
    float Baby_Card_Background_Width_Origin = 462;
    float Baby_Card_Background_Height_Origin = 519;
    
    float Baby_Card_Boy_Photo_Background_Width_Origin = 207;
    float Baby_Card_Boy_Photo_Background_Height_Origin = 207;
    
    float Baby_Card_Boy_Information_Bar_Width_Origin = 425;
    float Baby_Card_Boy_Information_Bar_Height_Origin = 63;
    
    float Baby_Card_Girl_Photo_Background_Width_Origin = 207;
    float Baby_Card_Girl_Photo_Background_Height_Origin = 207;
    
    float Baby_Card_Girl_Information_Bar_Width_Origin = 425;
    float Baby_Card_Girl_Information_Bar_Height_Origin = 63;
    
    float Baby_Card_Warnging_Image_Width_Origin = 148;
    float Baby_Card_Warnging_Image_Height_Origin = 148;

    float Multi;
    // 高 > 寬
    if(isPortrait) {
        Multi = Width_Multi;
    } else {
        Multi = Height_Multi;
    }
    
    Baby_Card_Background_Width = Cell_Width_Origin * Multi;
    Baby_Card_Background_Height = Cell_Height_Origin * Multi;
    
    // 高 > 寬
    if(isPortrait) {
        LineSpacing = LineSpacing_Origin * Multi;
        Inset_Left_Right = Inset_Left_Right_Origin * Multi;
        
        InteritemSpacing = (Container_Height - 2 * Baby_Card_Background_Height) / 3 - 1;
        Inset_Top_Down = (Container_Height - 2 * Baby_Card_Background_Height) / 3 - 1;
        NSLog(@"InteritemSpacing = %f", InteritemSpacing);
        NSLog(@"Inset_Top_Down = %f", Inset_Top_Down);
    } else {
        InteritemSpacing = InteritemSpacing_Origin * Multi;
        Inset_Top_Down = Inset_Top_Down_Origin * Multi;
        
        LineSpacing = (Container_Width - 2 * Baby_Card_Background_Width) / 3;
        Inset_Left_Right = (Container_Width - 2 * Baby_Card_Background_Width) / 3;
    }
    
    float Cell_Multi = Baby_Card_Background_Width / Baby_Card_Background_Width_Origin;
    
    // -------------------- Photo background -------------------------
    Baby_Card_Boy_Photo_Background_Width = Baby_Card_Boy_Photo_Background_Width_Origin * Cell_Multi;
    Baby_Card_Boy_Photo_Background_Height = Baby_Card_Boy_Photo_Background_Height_Origin * Cell_Multi;
    
    Baby_Card_Boy_Photo_Background_Top_Constraint = 10 * Cell_Multi;
    Baby_Card_Boy_Photo_Background_Bottom_Constraint = Baby_Card_Boy_Photo_Background_Top_Constraint + Baby_Card_Boy_Photo_Background_Height;
    Baby_Card_Boy_Photo_Background_Left_Constraint = (Baby_Card_Background_Width - Baby_Card_Boy_Photo_Background_Width) / 2;
    Baby_Card_Boy_Photo_Background_Right_Constraint = Baby_Card_Boy_Photo_Background_Left_Constraint + Baby_Card_Boy_Photo_Background_Width;
    
    // -------------------- Information bar background -------------------------
    Baby_Card_Boy_Information_Bar_Width = Baby_Card_Boy_Information_Bar_Width_Origin * Cell_Multi;
    Baby_Card_Boy_Information_Bar_Height = Baby_Card_Boy_Information_Bar_Height_Origin * Cell_Multi;
    
    Baby_Card_Boy_Information_Bar3_Top_Constraint = - (Baby_Card_Boy_Information_Bar_Height + 10 * Cell_Multi);
    Baby_Card_Boy_Information_Bar3_Bottom_Constraint =  - 10 * Cell_Multi;
    Baby_Card_Boy_Information_Bar3_Left_Constraint = (Baby_Card_Background_Width - Baby_Card_Boy_Information_Bar_Width) / 2;
    Baby_Card_Boy_Information_Bar3_Right_Constraint = Baby_Card_Boy_Information_Bar3_Left_Constraint + Baby_Card_Boy_Information_Bar_Width;
    
    Baby_Card_Boy_Information_Bar2_Top_Constraint = - (Baby_Card_Boy_Information_Bar_Height + 5 * Cell_Multi);
    Baby_Card_Boy_Information_Bar2_Bottom_Constraint =  - 5 * Cell_Multi;
    Baby_Card_Boy_Information_Bar2_Left_Constraint = Baby_Card_Boy_Information_Bar3_Left_Constraint;
    Baby_Card_Boy_Information_Bar2_Right_Constraint = Baby_Card_Boy_Information_Bar3_Right_Constraint;
    
    Baby_Card_Boy_Information_Bar1_Top_Constraint = - (Baby_Card_Boy_Information_Bar_Height + 5 * Cell_Multi);
    Baby_Card_Boy_Information_Bar1_Bottom_Constraint =  - 5 * Cell_Multi;
    Baby_Card_Boy_Information_Bar1_Left_Constraint = Baby_Card_Boy_Information_Bar3_Left_Constraint;
    Baby_Card_Boy_Information_Bar1_Right_Constraint = Baby_Card_Boy_Information_Bar3_Right_Constraint;
    
    return self;
}

- (CGRect) babyCardBackgroundWidth : (float) Image_Width
                       imageHeight : (float) Image_Height {
    float Container_Height;
    return CGRectZero;
}

@synthesize Baby_Card_Background_Width;
@synthesize Baby_Card_Background_Height;

@synthesize LineSpacing;
@synthesize InteritemSpacing;

@synthesize Inset_Left_Right;
@synthesize Inset_Top_Down;

// -------------------- Photo background -------------------------
@synthesize Baby_Card_Boy_Photo_Background_Width;
@synthesize Baby_Card_Boy_Photo_Background_Height;

@synthesize Baby_Card_Boy_Photo_Background_Top_Constraint;
@synthesize Baby_Card_Boy_Photo_Background_Bottom_Constraint;
@synthesize Baby_Card_Boy_Photo_Background_Left_Constraint;
@synthesize Baby_Card_Boy_Photo_Background_Right_Constraint;

// -------------------- Information bar background -------------------------
@synthesize Baby_Card_Boy_Information_Bar_Width;
@synthesize Baby_Card_Boy_Information_Bar_Height;

@synthesize Baby_Card_Boy_Information_Bar3_Top_Constraint;
@synthesize Baby_Card_Boy_Information_Bar3_Bottom_Constraint;
@synthesize Baby_Card_Boy_Information_Bar3_Left_Constraint;
@synthesize Baby_Card_Boy_Information_Bar3_Right_Constraint;

@synthesize Baby_Card_Boy_Information_Bar2_Top_Constraint;
@synthesize Baby_Card_Boy_Information_Bar2_Bottom_Constraint;
@synthesize Baby_Card_Boy_Information_Bar2_Left_Constraint;
@synthesize Baby_Card_Boy_Information_Bar2_Right_Constraint;

@synthesize Baby_Card_Boy_Information_Bar1_Top_Constraint;
@synthesize Baby_Card_Boy_Information_Bar1_Bottom_Constraint;
@synthesize Baby_Card_Boy_Information_Bar1_Left_Constraint;
@synthesize Baby_Card_Boy_Information_Bar1_Right_Constraint;

@end
