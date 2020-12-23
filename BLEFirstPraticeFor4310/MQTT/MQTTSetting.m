//
//  MQTTSetting.m
//  MQTTTest
//
//  Created by louie on 2020/11/23.
//

#import "MQTTSetting.h"

@interface MQTTSetting ()

@end

@implementation MQTTSetting

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) InitMQTTSetting
{
    NSLog(@"Selfefleefef = %@", ViewController.self);
    // User Information Setting
    User_Name = @"kjump";
    Password = @"1234qwer";
    
    // Clien ID Setting
    IDFVProcess *idfvProcess = [[IDFVProcess alloc] init];
    ClientID = [idfvProcess getClientIDFromIDFV];
    
    // Transport Setting
    Transport = [[MQTTWebsocketTransport alloc] init];
    Transport.host = @"healthng.oucare.com";
    Transport.port = 1885;
    Transport.tls = YES;
    Transport.path = @"/ws";
    
    // Session Setting
    Session = [[MQTTSession alloc] init];
    [Session setUserName:User_Name];
    [Session setPassword:Password];
    [Session setClientId:ClientID];
    [Session setTransport:Transport];
}

@synthesize User_Name;
@synthesize Password;
@synthesize ClientID;
@synthesize Session;
@synthesize Transport;

@end
