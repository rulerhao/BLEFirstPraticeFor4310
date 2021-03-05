//
//  Sensor4310CellViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/2.
//

#import "Sensor4310CellViewController.h"

@interface Sensor4310CellViewController ()

@end

@implementation Sensor4310CellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UICollectionViewCell *) createReadCell : (UICollectionViewCell *) cell
                           propertyOfCell : (NSDictionary *) PropertyOfCell {
    UIImageView *Background_ImageView = [cell viewWithTag:1];
    UIImageView *Baby_Photo_Background_ImageView = [cell viewWithTag:2];
    UITextView *Serial_TextView = [cell viewWithTag:4];
    UITextView *Baby_Name_TextView = [cell viewWithTag:8];
    
    UIImageView *Baby_Information_Bar1_ImageView = [cell viewWithTag:9];
    UIImageView *Baby_Information_Bar2_ImageView = [cell viewWithTag:10];
    UIImageView *Baby_Information_Bar3_ImageView = [cell viewWithTag:11];
    
    UITextView *Movement_TextView = [cell viewWithTag:5];
    UITextView *Temperature_TextView = [cell viewWithTag:6];
    UITextView *Battery_TextView = [cell viewWithTag:7];
    
    NSString *Model = [PropertyOfCell valueForKey:@"Model"];
    NSString *Serial = [PropertyOfCell valueForKey:@"Serial"];
    NSString *UUID = [PropertyOfCell valueForKey:@"UUID"];
    
    NSNumber *T1_NSNumber = [PropertyOfCell valueForKey:@"T1"];
    float T1 = [T1_NSNumber floatValue];
    
    NSNumber *T2_NSNumber = [PropertyOfCell valueForKey:@"T2"];
    float T2 = [T2_NSNumber floatValue];
    
    NSNumber *T3_NSNumber = [PropertyOfCell valueForKey:@"T3"];
    float T3 = [T3_NSNumber floatValue];
    
    NSNumber *Breath_NSNumber = [PropertyOfCell valueForKey:@"Breath"];
    BOOL Breath = [Breath_NSNumber boolValue];
    
    NSNumber *Battery_NSNumber = [PropertyOfCell valueForKey:@"Battery"];
    int Battery = [Battery_NSNumber intValue];
    
    NSLog(@"------------ MQTT Message In Watcher Mode ------------");
    NSLog(@"Model = %@", Model);
    NSLog(@"Serial = %@", Serial);
    NSLog(@"UUID = %@", UUID);
    NSLog(@"T1 = %f", T1);
    NSLog(@"T2 = %f", T2);
    NSLog(@"T3 = %f", T3);
    // NSLog(@"Breath = %@", Breath);
    NSLog(@"Battery = %d", Battery);
    
    Serial_TextView.text = Serial;
    
    if([Breath_NSNumber intValue] == 0) Movement_TextView.text = @"Abnormal";
    else Movement_TextView.text = @"Normal";
    
    Temperature_TextView.text = [T1_NSNumber stringValue];
    Battery_TextView.text = [Battery_NSNumber stringValue];
    return cell;
}


@end
