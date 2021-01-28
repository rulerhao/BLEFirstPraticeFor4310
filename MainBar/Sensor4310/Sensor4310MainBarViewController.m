//
//  Sensor4310MainBarViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/26.
//

#import "Sensor4310MainBarViewController.h"

@interface Sensor4310MainBarViewController ()

@property (strong, nonatomic) UICollectionView *myCollectionView;

@end

@implementation Sensor4310MainBarViewController

- (void)viewDidLoad {
    NSLog(@"NowController = Sensor4310MainBarViewController");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)controllerInit {
    [self viewInit];

    [self updateConstraints];
}

#pragma mark - CollectionView Delegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCollectionViewIdentifier" forIndexPath:indexPath];
    
    UIImageView *BackGroundImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_card_background.png"]];
    [cell addSubview:BackGroundImageVIew];
    //--------------------- Constraint -----------------------
    [BackGroundImageVIew mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top);
        make.bottom.equalTo(cell.mas_bottom);
        make.left.equalTo(cell.mas_left);
        make.right.equalTo(cell.mas_right);
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}

// ---------------------- Cell 大小 ------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

// ---------------------- 左右 cell 的間距 ------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// ---------------------- 上下 cell 的間距 ------------------------
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// ---------------------- 上左下右距離邊界距離 ------------------------
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 50);
}
#pragma mark - View Initial

- (void) viewInit {
    //--------------------- View -----------------------
    
    //--------------------- Collection View -----------------------
    UICollectionViewFlowLayout *myCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    myCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myCollectionViewLayout];
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionViewIdentifier"];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    [self.view addSubview: self.myCollectionView];
    NSLog(@"FirstTestmyTableView = %@", self.myCollectionView);
}
    
#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- Collection View -----------------------
    [self.myCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}
@end
