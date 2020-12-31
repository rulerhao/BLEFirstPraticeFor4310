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
//--------------- 按下開啟官網按鈕 ---------------
- (IBAction)Button_To_Ouhealthcare:(id)sender {
//    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    OuhealthcareWebViewController *Ouhealthcare_WebView = [StoryBoard instantiateViewControllerWithIdentifier:@"OuhealthcareWebView"];
//    [RootNavigationView pushViewController:Ouhealthcare_WebView animated:NO];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://healthcare.oucare.com"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
             NSLog(@"Opened url");
        }
    }];
}
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
    NSMutableArray *Floor = [[NSMutableArray alloc] init];
    if([Now_Navigation_Name isEqual:@"1樓"]) {
        [Floor addObject:@"Room-101"];
        [Floor addObject:@"Room-102"];
        [Floor addObject:@"Room-103"];
    } else if ([Now_Navigation_Name isEqual:@"2樓"]) {
        [Floor addObject:@"Room-201"];
        [Floor addObject:@"Room-202"];
        [Floor addObject:@"Room-203"];
    } else {
        [Floor addObject:@"Room-301"];
        [Floor addObject:@"Room-302"];
        [Floor addObject:@"Room-303"];
    }
    
    [Stored_Rooms addObject:Floor];
    
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
    // ---------------------- Now Navigation Name -------------------
    Now_Navigation_Name = [[Stored_Rooms objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    NSLog(@"Now_Navigation_Name = %@", Now_Navigation_Name);
    
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RoomController *SensorController = [StoryBoard instantiateViewControllerWithIdentifier:@"SensorUIViewController"];
    [RootNavigationView pushViewController:SensorController animated:NO];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.Collection_View.contentOffset.x / self.Collection_View.frame.size.width;
    NSLog(@"currentIndex = %ld", (long)currentIndex);
}
@end
