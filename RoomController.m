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
@property (strong, nonatomic) IBOutlet UITextView *Time_Text_Field;
@property (strong, nonatomic) IBOutlet UITextView *Now_Navigation_Name_TextView;

@end

@implementation RoomController
//--------------- 按下回前個畫面按鈕 ---------------
- (IBAction)Touch_Back_Button:(id)sender {
    [RootNavigationView popViewControllerAnimated:NO];
}
//--------------- 按下回登入畫面按鈕 ---------------
- (IBAction)Button_To_Return_LogIn:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [RootNavigationView popToViewController:[array objectAtIndex:1] animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ------------------- Button Bar ----------------------
    self.Now_Navigation_Name_TextView.text = Now_Navigation_Name;
    
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
    
    self.Time_Text_Field.text = Now_Time;
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
    NSLog(@"Touchchchcchch = %@", indexPath);
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RoomController *SensorController = [StoryBoard instantiateViewControllerWithIdentifier:@"SensorUIViewController"];
    [RootNavigationView pushViewController:SensorController animated:NO];
    
    // ---------------------- Now Navigation Name -------------------
    Now_Navigation_Name = [[Stored_Rooms objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    NSLog(@"Now_Navigation_Name = %@", Now_Navigation_Name);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.Collection_View.contentOffset.x / self.Collection_View.frame.size.width;
    NSLog(@"currentIndex = %ld", (long)currentIndex);
}
@end
