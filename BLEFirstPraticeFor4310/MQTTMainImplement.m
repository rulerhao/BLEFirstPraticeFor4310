//
//  MQTTMain.m
//  MQTTTest
//
//  Created by louie on 2020/11/24.
//

#import "MQTTMainImplement.h"

@interface MQTTMainImplement ()

@end

@implementation MQTTMainImplement

MQTTSession *Session;
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) MQTTStart
{
    MQTTSetting *MqttSetting = [[MQTTSetting alloc] init];
    [MqttSetting InitMQTTSetting];
    
    [MqttSetting.Session setDelegate:self];
    
    NSLog(@"Selfefleefef = %@", self);
    [MqttSetting.Session setKeepAliveInterval:5];
    
    [MqttSetting.Session connectAndWaitTimeout:15];
}

/**
 * 當執行 [MySeccion connectAndWaitTimeout:time]; 時觸發
 */
-(void)
handleEvent:(MQTTSession *)session
      event:(MQTTSessionEvent)eventCode
      error:(NSError *)error
{
    Session = session;
    NSLog(@"actuallyScssion:%ld ", (long)eventCode);
    if (eventCode == MQTTSessionEventConnected)
    {
        NSLog(@"MQTTStatus : Connected");
        // Subscribe part
        
        [session subscribeToTopic:@"/ouhub/requests"
                            atLevel:MQTTQosLevelAtMostOnce
                   subscribeHandler:
         ^(NSError *error,
           NSArray<NSNumber *> *gQoss)
        {
            if (error)
            {
                NSLog(@"MQTTStatuserror:%@",error);
            }
            else
            {
                Session = session;
                NSLog(@"MQTTStatusOK:%@",gQoss);
            }
        }];
         
    }
    else if (eventCode == MQTTSessionEventConnectionRefused)
    {
        NSLog(@"MQTTStatus : refused");
    }
    else if (eventCode == MQTTSessionEventConnectionClosed)
    {
        NSLog(@"MQTTStatus : closed");
        [session connectAndWaitTimeout:15];
    }
    else if (eventCode == MQTTSessionEventConnectionError)
    {
        NSLog(@"MQTTStatus : error");
    }
    else if (eventCode == MQTTSessionEventProtocolError)
    {
        NSLog(@"MQTTStatus : MQTTSessionEventProtocolError");
    }
    else{//MQTTSessionEventConnectionClosedByBroker
        NSLog(@"MQTTStatus : other");
    }
    if (error)
    {
        NSLog(@"MQTTStatus error  -- %@",error);
    }
}

/**
 * 當 Subscribe 方被 Publish 時觸發
 */
- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid
{
    TypesConversion *typesConversion = [[TypesConversion alloc] init];
    NSLog(@"IntoNewMessage");
    NSLog(@"DataForReturn:%@", [typesConversion getHEX:data]);
    NSLog(@"DataForReturn:%lu", (unsigned long)[[typesConversion getHEX:data] length]);
    NSString *NewString = @"";
    StringProcessFunc *stringProcessFunction = [[StringProcessFunc alloc] init];
    for(int i = 0; i < [[typesConversion getHEX:data] length]; i = i + 2)
    {
        NewString = [stringProcessFunction MergeTwoString:NewString
                                                SecondStr:[stringProcessFunction getSubString:[typesConversion getHEX:data]
                                                                                       length:2
                                                                                     location:i]];
        NewString = [stringProcessFunction MergeTwoString:NewString SecondStr:@" "];
        
    }
    NSLog(@"NewString :%@", NewString);
    
}

@end
