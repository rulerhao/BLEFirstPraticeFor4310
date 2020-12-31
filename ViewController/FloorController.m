//
//  FloorController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/22.
//

#import "FloorController.h"

@interface FloorController ()
{
    NSMutableArray *Stored_Floor;
}
@property (strong, nonatomic) IBOutlet UITextView *Now_Navigation_Name_TextView;
@property (strong, nonatomic) IBOutlet UITextView *Time_Text_Field;
@end

@implementation FloorController
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
    //NSLog(@"ContorllerList = %@", [[array objectAtIndex:1] ]);
    [RootNavigationView popToViewController:[array objectAtIndex:1] animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ------------------- Button Bar ----------------------
    self.Now_Navigation_Name_TextView.text = Now_Navigation_Name;
    
    Stored_Floor = [[NSMutableArray alloc] init];
    [Stored_Floor addObject:@"1樓"];
    [Stored_Floor addObject:@"2樓"];
    [Stored_Floor addObject:@"3樓"];
    self.Time_Text_Field.text = Now_Time;
    NSLog(@"EnterOrgController");
}

- (NSInteger)
collectionView          :(UICollectionView *)   collectionView
numberOfItemsInSection  :(NSInteger)            section {
    return [Stored_Floor count];
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
    [Organization_Name setText:[Stored_Floor objectAtIndex:[indexPath row]]];
    
    return cell;
}
/**
 * 當點擊指定item時執行此
 */
-(void)
collectionView          :(UICollectionView *)   collectionView
didSelectItemAtIndexPath:(NSIndexPath *)        indexPath {
    NSLog(@"didSelectItem");
    // ---------------------- Now Navigation Name -------------------
    Now_Navigation_Name = [Stored_Floor objectAtIndex:[indexPath row]];
    
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RoomController *RoomController = [StoryBoard instantiateViewControllerWithIdentifier:@"RoomUIViewController"];
    [RootNavigationView pushViewController:RoomController animated:NO];
    NSLog(@"Now_Navigation_Name = %@", Now_Navigation_Name);
}
@end
