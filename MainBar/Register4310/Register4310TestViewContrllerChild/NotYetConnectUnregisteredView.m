//
//  NotYetConnectUnregisteredView.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/16.
//

#import "NotYetConnectUnregisteredView.h"

@interface NotYetConnectUnregisteredView ()

@property (strong, nonatomic) UIView *Register_View;

@end

@implementation NotYetConnectUnregisteredView

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
    
    [self notYetConnectUnregisteredView:self.Register_View];
}

- (void) notYetConnectUnregisteredView  : (UIView *) Content_View {
    UILabel *MessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    MessageLabel.tag = 1;
    [MessageLabel setText:@"未連接未註冊裝置"];
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
