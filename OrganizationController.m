//
//  OrganizationController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/17.
//

#import "OrganizationController.h"

@interface OrganizationController ()
{
    NSMutableArray *Stored_Organizations;
}
@property (strong, nonatomic) IBOutlet UICollectionView *MyOrgCollectView;

@end

@implementation OrganizationController
- (IBAction)Touch_Back_Button:(id)sender {
    [RootNavigationView popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Stored_Organizations = [[NSMutableArray alloc] init];
    [Stored_Organizations addObject:@"凱健企業股份有限公司"];
}
- (NSInteger)
collectionView          :(UICollectionView *)   collectionView
numberOfItemsInSection  :(NSInteger)            section {
    return [Stored_Organizations count];
}

- (__kindof UICollectionViewCell *)
collectionView          :(UICollectionView *)   collectionView
cellForItemAtIndexPath  :(NSIndexPath *)        indexPath {
    __kindof UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                     forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UITextView *Organization_Name = [cell viewWithTag:1];
    Organization_Name.text = [Stored_Organizations objectAtIndex:[indexPath row]];
    
    return cell;
}
/**
 * 當點擊指定item時執行此
 */
-(void)
collectionView          :(UICollectionView *)   collectionView
didSelectItemAtIndexPath:(NSIndexPath *)        indexPath {
    NSLog(@"didSelectItem");
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RoomController *RoomController = [StoryBoard instantiateViewControllerWithIdentifier:@"RoomUIViewController"];
    [RootNavigationView pushViewController:RoomController animated:NO];
}
@end
