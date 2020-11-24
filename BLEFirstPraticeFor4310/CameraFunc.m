//
//  CameraFunc.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/11/2.
//

#import "CameraFunc.h"

@interface CameraFunc ()

@end

@implementation CameraFunc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) SaveChangedNameImage : (NSString *) now_Device_Name
           Delete_Device_Name : (NSString *) delete_Device_Name
{
    StringProcessFunc *Str_Process_Func = [[StringProcessFunc alloc] init];
    
    // 開始儲存檔名
    
    // 照片更名功能
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // NSString *Previous_Device_Name = [[self->_StoredDevices objectAtIndex:[self->_NowClickIndexPath row]] getDeviceName];
    NSString *Previous_Device_Name = delete_Device_Name;
    
    NSString *Previous_Device_Name_With_Extension = [Str_Process_Func MergeTwoString:Previous_Device_Name SecondStr:@".png"];
    
    NSString *Previous_filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Previous_Device_Name_With_Extension];
 
    UIImage *PhotoImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",Previous_filePath]];
    
    NSString *Now_Device_Name_With_Extension = [Str_Process_Func MergeTwoString:now_Device_Name SecondStr:@".png"];
    
    NSString *Now_filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Now_Device_Name_With_Extension];
    
    // 儲存現在檔名的圖片
    
    [UIImagePNGRepresentation(PhotoImage) writeToFile:Now_filePath atomically:YES];
    
    if(![Previous_filePath isEqual:Now_filePath]) {
        // 刪除之前檔名的圖片
        [[NSFileManager defaultManager ] removeItemAtPath:Previous_filePath
                                                    error:nil];
    }
}
@end
