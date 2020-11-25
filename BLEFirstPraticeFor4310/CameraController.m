//
//  CameraFunc.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/2.
//

#import "CameraController.h"

@interface CameraController ()

@end

@implementation CameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SucessToDoThis");
    NSLog(@"SucessToDoThis ed = %@", [self presentedViewController]);
    NSLog(@"SucessToDoThis ing = %@", [self presentingViewController]); // 從哪裡來的
    NSLog(@"SucessToDoThis tion = %@", [self presentationController]);
    NSLog(@"SucessToDoThis self = %@", self); // 目前所在的
    // Do any additional setup after loading the view.
    [self initCamera:_NowClickIndexPath
       storedDevices:_StoredDevices];
}

- (void)
initCamera      : (NSIndexPath *)        indexPath
storedDevices   : (NSMutableArray *)     StoredDevices
{
    NSLog(@"initCamera");
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        //檢查是否支援此Source Type(相機)
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"Access Camera Device");
            
            //設定影像來源為相機
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            
            // 顯示UIImagePickerController
            
            [self presentViewController:imagePicker
                               animated:NO
                             completion:nil];
        }
        else {
            //提示使用者，目前設備不支援相機
            NSLog(@"No Camera Device");
        }
    });
    
}

// Camera 的 delegate method
// 使用者按下確定時
- (void)
imagePickerController           :   (UIImagePickerController *) picker
didFinishPickingMediaWithInfo   :   (NSDictionary *)            info {
    NSString *Now_Device_Name = [[_StoredDevices objectAtIndex:[_NowClickIndexPath row]] getDeviceName];

    StringProcessFunc *Str_Process_Func = [[StringProcessFunc alloc] init];
    NSString *Now_Device_Name_With_Extension = [Str_Process_Func
                                                MergeTwoString:Now_Device_Name
                                                SecondStr:@".png"];

    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Now_Device_Name_With_Extension];

    NSLog(@"Picture_Directory:%lu", (unsigned long)NSDocumentDirectory);
    NSLog(@"Picture_Mask:%lu", (unsigned long)NSUserDomainMask);
    NSLog(@"Picture_Path:%@", filePath);

    //取得剛拍攝的相片(或是由相簿中所選擇的相片)
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Save image.
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];

    [picker dismissViewControllerAnimated:YES completion:^{}];
}


// Camera 的 delegate method
// 使用者按下取消時
- (void)
imagePickerControllerDidCancel  :   (UIImagePickerController *) picker {
    //一般情況下沒有什麼特別要做的事情
    [picker dismissViewControllerAnimated:YES completion:^{}];

}

/**
 * @discussion
 *  更改照片檔名
 * @param Now_Device_Name : 要改變成的檔名
 * @param Delete_Device_Name : 要刪除的檔名 也就是原檔名
 */
- (void) saveChangedNameImage : (NSString *) Now_Device_Name
           delete_Device_Name : (NSString *) Delete_Device_Name
{
    StringProcessFunc *Str_Process_Func = [[StringProcessFunc alloc] init];

    // 開始儲存檔名

    // 照片更名功能

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    // NSString *Previous_Device_Name = [[self->_StoredDevices objectAtIndex:[self->_NowClickIndexPath row]] getDeviceName];
    NSString *Previous_Device_Name = Delete_Device_Name;

    NSString *Previous_Device_Name_With_Extension = [Str_Process_Func MergeTwoString:Previous_Device_Name SecondStr:@".png"];

    NSString *Previous_filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Previous_Device_Name_With_Extension];

    UIImage *PhotoImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",Previous_filePath]];

    NSString *Now_Device_Name_With_Extension = [Str_Process_Func MergeTwoString:Now_Device_Name SecondStr:@".png"];

    NSString *Now_filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Now_Device_Name_With_Extension];

    // 儲存現在檔名的圖片

    [UIImagePNGRepresentation(PhotoImage) writeToFile:Now_filePath atomically:YES];

    if(![Previous_filePath isEqual:Now_filePath])
    {
        // 刪除之前檔名的圖片
        [[NSFileManager defaultManager ] removeItemAtPath:Previous_filePath
                                                    error:nil];
    }
}
@end
