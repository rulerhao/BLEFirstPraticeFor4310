//
//  OrganizationViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/22.
//

#import "OrganizationMainBarViewController.h"

@interface OrganizationMainBarViewController ()

@property (strong, nonatomic) UITableView *myTableView;

@end

@implementation OrganizationMainBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)controllerInit {
    [self viewInit];

    [self updateConstraints];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = UITableViewCell.new;
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %tu", indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- View -----------------------
    
    //--------------------- Table View -----------------------
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;

    [self.view addSubview: self.myTableView];
    NSLog(@"FirstTestmyTableView = %@", self.myTableView);
}
    
#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- Table View -----------------------
    [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}
@end
