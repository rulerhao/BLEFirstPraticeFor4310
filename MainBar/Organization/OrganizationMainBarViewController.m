//
//  OrganizationViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/22.
//

#import "OrganizationMainBarViewController.h"

@interface OrganizationMainBarViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation OrganizationMainBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"OrganizationTableView");
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrganizationCell"];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
@end
