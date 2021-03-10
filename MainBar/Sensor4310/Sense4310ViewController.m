//
//  4310SenseViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/5.
//

#import "Sense4310ViewController.h"

@interface Sense4310ViewController ()
@property (nonatomic, strong) UICollectionView *myCollectionView;
@end

@implementation Sense4310ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"a" forIndexPath:indexPath];
    if (!cell) {
//        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    }

    return cell;
}
@end
