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
addObj                  :(nullable CBPeripheral *)   Pheripheral
nowCharacteristic       :(nullable CBCharacteristic *)         Now_Charact
previousCharacteristic  :(nullable CBCharacteristic *)         Previous_Charact
nowBabyInformation      :(nullable CBCharacteristic *)         Now_Baby_Infor
previousBabyInformation :(nullable CBCharacteristic *)         Previous_Baby_Infor {
    peripheral = Pheripheral;
    now_Charact = Now_Charact;
    previous_Charact = Previous_Charact;
    now_Baby_Infor = Now_Baby_Infor;
    previous_Baby_Infor = Previous_Baby_Infor;
}

- (CBPeripheral *) getPheripheral {
    return peripheral;
}

- (CBCharacteristic *) getNowCharacteristic {
    return now_Charact;
}

- (CBCharacteristic *) getPreviousCharacteristic {
    return previous_Charact;
}

- (CBCharacteristic *) getNowBabyInformation {
    return now_Baby_Infor;
}

- (CBCharacteristic *) getPreviousBabyInformation {
    return previous_Baby_Infor;
}

@end
