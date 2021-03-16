//
//  RegisterViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/16.
//

#import "Register4310TestViewController.h"
#import "ConnectOneUnregisteredView.h"
#import "NotYetConnectUnregisteredView.h"
#import "ConnectTooMuchUnregisteredView.h"

@interface Register4310TestViewController ()

@property (strong, nonatomic) ConnectOneUnregisteredView *connectOneUnregisteredView;
@property (strong, nonatomic) NotYetConnectUnregisteredView *notYetConnectUnregisteredView;
@property (strong, nonatomic) ConnectTooMuchUnregisteredView *connectTooMuchUnregisteredView;


@end

@implementation Register4310TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) controllerInit {
    [self viewInit];
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- Init -----------------------
    //--------------------- View -----------------------
    //--------------------- Collection View -----------------------
    UICollectionViewFlowLayout *cardCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    cardCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.connectOneUnregisteredView = [ConnectOneUnregisteredView alloc];
    self.connectOneUnregisteredView.ParentView = self.view;
    [self.connectOneUnregisteredView controllerInit];
    
//    self.notYetConnectUnregisteredView = [NotYetConnectUnregisteredView alloc];
//    self.notYetConnectUnregisteredView.ParentView = self.view;
//    [self.notYetConnectUnregisteredView controllerInit];
    
//    self.connectTooMuchUnregisteredView = [ConnectTooMuchUnregisteredView alloc];
//    self.connectTooMuchUnregisteredView.ParentView = self.view;
//    [self.connectTooMuchUnregisteredView controllerInit];
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

@end
