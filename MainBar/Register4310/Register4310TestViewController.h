//
//  RegisterViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/16.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
NS_ASSUME_NONNULL_BEGIN
@class Register4310TestViewController;

@protocol Register4310TestViewControllerDelegate <NSObject>

@optional

@end

@interface Register4310TestViewController : UIViewController

@property(readwrite, nonatomic) NSInteger CurrentController;

@property(assign) id <Register4310TestViewControllerDelegate> delegate;

- (void) controllerInit;

@end

NS_ASSUME_NONNULL_END
