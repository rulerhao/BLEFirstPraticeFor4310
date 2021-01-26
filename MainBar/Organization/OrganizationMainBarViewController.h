//
//  OrganizationViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/22.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrganizationMainBarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(readwrite, nonatomic) NSInteger CurrentController;

@end

NS_ASSUME_NONNULL_END
