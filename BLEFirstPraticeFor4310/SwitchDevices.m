//
//  SwitchDevices.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/26.
//

#import "SwitchDevices.h"

@interface SwitchDevices ()

@end

@implementation SwitchDevices

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)
switchDevices   : (UICollectionView *)  myCollectionView
orderItemsIndex : (NSMutableArray *)    Order_Items_Index
storedDevices   : (NSMutableArray *)    StoredDevices
indexPath       : (NSIndexPath *)       IndexPath
{
    NSLog(@"[Order_Items_Index]:%lu", (unsigned long)[Order_Items_Index count]);
    // 因為不能在 switch 內宣告變數 所以在這邊宣告
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger First_Index;
    NSInteger Second_Index;
    id First_Object;
    id Second_Object;
    
    switch ([Order_Items_Index count])
    {
        case 0:
        {
            [Order_Items_Index addObject:IndexPath];
            // 更新畫面
            [indexPaths addObject:IndexPath];
            [UIView performWithoutAnimation:^{
                [myCollectionView reloadItemsAtIndexPaths:indexPaths];
            }];
            break;
        }
        case 1:
        {
            First_Index = [[Order_Items_Index objectAtIndex:0] row];
            Second_Index = [IndexPath row];
            First_Object = [StoredDevices objectAtIndex:First_Index];
            Second_Object = [StoredDevices objectAtIndex:Second_Index];
            [StoredDevices removeObjectAtIndex:First_Index];
            [StoredDevices insertObject:Second_Object atIndex:First_Index];
            [StoredDevices removeObjectAtIndex:Second_Index];
            [StoredDevices insertObject:First_Object atIndex:Second_Index];
            
            [indexPaths addObject:[Order_Items_Index objectAtIndex:0]];
            [indexPaths addObject:IndexPath];
            NSLog(@"IndexPath = %@", IndexPath);
            [UIView performWithoutAnimation:^{
                [myCollectionView reloadData];
            }];
            
            [Order_Items_Index removeAllObjects];
            break;
        }
    }
}

@end
