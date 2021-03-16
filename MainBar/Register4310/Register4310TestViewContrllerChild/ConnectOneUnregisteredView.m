//
//  ConnectOneUnregisteredView.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/16.
//

#import "ConnectOneUnregisteredView.h"

@interface ConnectOneUnregisteredView ()

@property (strong, nonatomic) UIView *Register_View;
@end

@implementation ConnectOneUnregisteredView

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [self connectOneUnregisteredView:self.Register_View];
}

- (void) connectOneUnregisteredView : (UIView *) Content_View {
    
    UILabel *MessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    MessageLabel.tag = 1;
    [MessageLabel setText:@"已連接未註冊裝置"];
    [MessageLabel sizeToFit];
    [Content_View addSubview:MessageLabel];
    
    UITextField *Name_TextField = [[UITextField alloc] initWithFrame:CGRectZero];
    Name_TextField.tag = 2;
    [Name_TextField setText:@"Name"];
    [Name_TextField sizeToFit];
    [Content_View addSubview:Name_TextField];
    
    UIButton *RegisterButton = [[UIButton alloc] initWithFrame:CGRectZero];
    RegisterButton.tag = 3;
    [RegisterButton setTitle:@"註冊" forState:UIControlStateNormal];
    [RegisterButton addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [Content_View addSubview:RegisterButton];
    //--------------------- Message label -----------------------
    [MessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(Content_View.mas_centerX);
        make.top.equalTo(Content_View.mas_top);
    }];
    
    //--------------------- Name text field -----------------------
    [Name_TextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(Content_View.mas_centerX);
        make.centerY.equalTo(Content_View.mas_centerY);
    }];
    
    //--------------------- Register View -----------------------
    [RegisterButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(Content_View.mas_centerX);
        make.bottom.equalTo(Content_View.mas_bottom);
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

/*
- (void) connectOneUnregisteredView {
    
    UILabel *MessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    MessageLabel.tag = 1;
    [MessageLabel setText:@"已連接未註冊裝置"];
    [MessageLabel sizeToFit];
    [self.RegisterView addSubview:MessageLabel];
    
    UIButton *RegisterButton = [[UIButton alloc] initWithFrame:CGRectZero];
    RegisterButton.tag = 2;
    [RegisterButton setTitle:@"註冊" forState:UIControlStateNormal];
    [self.RegisterView addSubview:RegisterButton];
    //--------------------- Label View -----------------------
    [MessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.RegisterView.mas_centerX);
        make.top.equalTo(self.RegisterView.mas_top);
    }];
    
    //--------------------- Register View -----------------------
    [RegisterButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.RegisterView.mas_centerX);
        make.bottom.equalTo(self.RegisterView.mas_bottom);
    }];
}

- (void) notYetConnectUnregisteredView {
    UILabel *MessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    MessageLabel.tag = 1;
    [MessageLabel setText:@"未連接未註冊裝置"];
    [MessageLabel sizeToFit];
    [self.RegisterView addSubview:MessageLabel];
    //--------------------- Collection View -----------------------
    [MessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.RegisterView.mas_centerX);
        make.centerY.equalTo(self.RegisterView.mas_centerY);
    }];
}

- (void) connectTooMuchUnregisteredView {
    UILabel *MessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    MessageLabel.tag = 1;
    [MessageLabel setText:@"連接超過一個未註冊裝置 請同時間最多連接一個未註冊裝置"];
    [self.RegisterView addSubview:MessageLabel];
    //--------------------- Collection View -----------------------
    [MessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RegisterView.mas_top);
        make.bottom.equalTo(self.RegisterView.mas_bottom);
        make.left.equalTo(self.RegisterView.mas_left);
        make.right.equalTo(self.RegisterView.mas_right);
    }];
}
*/

#pragma mark - Button delegate
- (void) buttonBeClicked:(UIButton *) sender {
    NSLog(@"sender = %@", sender);
}
@end
