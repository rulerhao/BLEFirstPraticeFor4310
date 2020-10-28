//
//  cellData.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/8.
//

#import "cellData.h"

@interface cellData ()

@end

@implementation cellData

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)
addObj                  :(nullable CBPeripheral *)             Pheripheral
nowCharacteristic       :(nullable NSData *)         Now_Charact
previousCharacteristic  :(nullable NSData *)         Previous_Charact
nowBabyInformation      :(nullable NSData *)         Now_Baby_Infor
CurrentCharacteristic :(nullable NSData *)         Current_Characteristic
storedMovementState     :(nullable NSMutableArray *)           Stored_Movement_State {
    peripheral = Pheripheral;
    now_Charact = Now_Charact;
    previous_Charact = Previous_Charact;
    now_Baby_Infor = Now_Baby_Infor;
    current_Characteristic = Current_Characteristic;
    stored_Movemebt_State = Stored_Movement_State;
    /*
    NSLog(@"Right_Inside_now_before_char_nice: %p", &Now_Charact);
    NSLog(@"Right_Inside_pre_before_char_nice: %p", &Previous_Charact);
    NSLog(@"Inside_now_before_char_nice: %p", &now_Charact);
    NSLog(@"Inside_pre_before_char_nice: %p", &previous_Charact);
     */
    NSLog(@"------------------------------before_char_nice------------------------------------------");

}

- (CBPeripheral *) getPheripheral {
    return peripheral;
}

- (NSData *) getNowCharacteristic {
    return now_Charact;
}

- (NSData *) getPreviousCharacteristic {
    return previous_Charact;
}

- (NSData *) getNowBabyInformation {
    return now_Baby_Infor;
}

- (NSData *) getCurrentCharacteristic {
    return current_Characteristic;
}

- (NSMutableArray *) getStoredMovementState {
    return stored_Movemebt_State;
}
@end
