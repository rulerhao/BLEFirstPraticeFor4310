//
//  WatcherViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/2/25.
//

#import "WatcherViewController.h"

@interface WatcherViewController ()

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *StoredData;

@end

@implementation WatcherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewInit];

    [self updateConstraints];
    
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- Init -----------------------
    //--------------------- View -----------------------
    //--------------------- Collection View -----------------------
    UICollectionViewFlowLayout *myCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    myCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview: self.myTableView];
    NSLog(@"FirstTestmyTableView = %@", self.myTableView);
}
    
#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- Collection View -----------------------
    [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

@end
