//
//  TitleBarViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/13.
//

#import "TitleBarViewController.h"
#import "RoomController.h"
@interface TitleBarViewController ()
{
    TitleBarImageSetting *titleBarImageSetting;
    ImageSetting *imageSetting;
    
}
@property(nonatomic, strong) UIImageView *titleUserImageView;
@property(nonatomic, strong) UIImageView *ouCareICLogoImageView;

@end

@implementation TitleBarViewController
// 按下時觸發
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"asdasdadtouchesBegan");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    titleBarImageSetting = [[TitleBarImageSetting alloc] init];
    imageSetting = [[ImageSetting alloc] init];
    switch (currentController) {
        case ViewController_Root:
            NSLog(@"Now is ROOT");
            break;
        case ViewController_Organization:
            NSLog(@"Now is organization");
            break;
    }
    //--------------------- View Init -----------------------
    [self viewInit];
    //--------------------- Constraints set -----------------------
    [self updateConstraints];
    
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"titleBarHeight = %f", self.view.bounds.size.height);
}
#pragma mark - View Initial

- (void) viewInit {
    //--------------------- View -----------------------
    NSLog(@"self = %@", self);
    NSLog(@"self.width = %f", self.view.bounds.size.width);
    NSLog(@"self.height = %f", self.view.bounds.size.height);
    //--------------------- Title User ImageView -----------------------
    self.titleUserImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.titleUserImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.titleUserImageView setImage:titleBarImageSetting.Title_User_Image];
    
    [self.view addSubview: self.titleUserImageView];
    
    //--------------------- OUCare IC Logo ImageView -----------------------
    self.ouCareICLogoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.ouCareICLogoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.ouCareICLogoImageView setImage:titleBarImageSetting.OUCare_IC_Logo_Image];
    
    [self.view addSubview: self.ouCareICLogoImageView];
}
#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- Title User ImageView -----------------------
    [self.titleUserImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(imageSetting.Edge_Length * imageSetting.Height_Multi);
        make.bottom.equalTo(self.view.mas_top).offset(titleBarImageSetting.Title_User_ImageView_Height + imageSetting.Edge_Length * imageSetting.Height_Multi);
        make.left.equalTo(self.view.mas_left).offset(imageSetting.Edge_Length * imageSetting.Width_Multi);
        make.right.equalTo(self.view.mas_left).offset(titleBarImageSetting.Title_User_ImageView_Width + imageSetting.Edge_Length * imageSetting.Width_Multi);
    }];
    //--------------------- Title Bar View -----------------------
    [self.ouCareICLogoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(imageSetting.Edge_Length * imageSetting.Height_Multi);
        make.bottom.equalTo(self.view.mas_bottom).offset(- imageSetting.Edge_Length * imageSetting.Height_Multi);
        make.left.equalTo(self.view.mas_centerX).offset(- titleBarImageSetting.OUCare_IC_Logo_ImageView_Width / 2);
        make.right.equalTo(self.view.mas_centerX).offset(titleBarImageSetting.OUCare_IC_Logo_ImageView_Width / 2);
    }];
}
@end
