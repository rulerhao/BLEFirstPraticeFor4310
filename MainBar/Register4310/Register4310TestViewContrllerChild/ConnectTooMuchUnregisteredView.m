//
//  ConnectTooMuchUnregisteredView.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/16.
//

#import "ConnectTooMuchUnregisteredView.h"

@interface ConnectTooMuchUnregisteredView ()

@property (strong, nonatomic) UIView *Register_View;

@end

@implementation ConnectTooMuchUnregisteredView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) controllerInit {
    [self viewInit];
    [self updateConstraints];
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- Init -----------------------
    //--------------------- View -----------------------
    //--------------------- Collection View -----------------------
    
    self.Register_View = [[UIView alloc] initWithFrame:CGRectZero];
    [self.ParentView addSubview:self.Register_View];
    
    [self connectTooMuchUnregisteredView:self.Register_View];
}

- (void) connectTooMuchUnregisteredView  : (UIView *) Content_View {
    UILabel *MessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    MessageLabel.tag = 1;
    [MessageLabel setText:@"連接超過一個未註冊裝置 請同時間最多連接一個未註冊裝置"];
    [MessageLabel sizeToFit];
    [Content_View addSubview:MessageLabel];
    
    //--------------------- Message label -----------------------
    [MessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(Content_View.mas_centerX);
        make.top.equalTo(Content_View.mas_top);
    }];
}

#pragma mark - Constraints
- (void) updateConstraints {
    //--------------------- Collection View -----------------------
    [self.Register_View mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ParentView.mas_top);
        make.bottom.equalTo(self.ParentView.mas_bottom);
        make.left.equalTo(self.ParentView.mas_left);
        make.right.equalTo(self.ParentView.mas_right);
    }];
}
@end
