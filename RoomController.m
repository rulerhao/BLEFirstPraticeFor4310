//
//  RoomController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/17.
//

#import "RoomController.h"

@interface RoomController ()
{
    NSMutableArray *Stored_Rooms;
}
@property (strong, nonatomic) IBOutlet UICollectionView *Collection_View;

@end

@implementation RoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    Stored_Rooms = [[NSMutableArray alloc] init];
    NSMutableArray *Floor1 = [[NSMutableArray alloc] init];
    [Floor1 addObject:@"101-Room"];
    [Floor1 addObject:@"102-Room"];
    [Floor1 addObject:@"103-Room"];
    NSMutableArray *Floor2 = [[NSMutableArray alloc] init];
    [Floor2 addObject:@"201-Room"];
    [Floor2 addObject:@"202-Room"];
    [Floor2 addObject:@"203-Room"];
    NSMutableArray *Floor3 = [[NSMutableArray alloc] init];
    [Floor3 addObject:@"301-Room"];
    [Floor3 addObject:@"302-Room"];
    [Floor3 addObject:@"303-Room"];
    
    [Stored_Rooms addObject:Floor1];
    [Stored_Rooms addObject:Floor2];
    [Stored_Rooms addObject:Floor3];
    
}
- (NSInteger)
collectionView          :(UICollectionView *)   collectionView
numberOfItemsInSection  :(NSInteger)            section {
    return [[Stored_Rooms objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [Stored_Rooms count];
}
- (__kindof UICollectionViewCell *)
collectionView          :(UICollectionView *)   collectionView
cellForItemAtIndexPath  :(NSIndexPath *)        indexPath {
    __kindof UICollectionViewCell *cell;
    NSLog(@"indexPathForThisTime = %@", indexPath);
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                     forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UITextView *Organization_Name = [cell viewWithTag:1];
    Organization_Name.text = [[Stored_Rooms objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    return cell;
}
/**
 * 當點擊指定item時執行此
 */
-(void)
collectionView          :(UICollectionView *)   collectionView
didSelectItemAtIndexPath:(NSIndexPath *)        indexPath {
    NSLog(@"Touchchchcchch");
}

@end
