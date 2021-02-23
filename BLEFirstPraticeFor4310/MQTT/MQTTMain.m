//
//  MQTTMain.m
//  MQTTTest
//
//  Created by louie on 2020/11/24.
//

#import "MQTTMain.h"

@interface MQTTMain ()
{
    //UIViewController *View_Controller_For_Notify;
    NSString *SubscribeURL;
    
    NSString *G_Client_ID;
    NSString *G_User_Name;
    NSString *G_OTP;
    NSString *G_OTP_Expired;
    
    MQTTSession *Session;
}
@end

@implementation MQTTMain

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) mqttStart : (NSArray *) OAuth_Information
    viewController : (nullable UIViewController *) View_Controller {
    //View_Controller_For_Notify = View_Controller;
    [self mqttConnect : OAuth_Information];
    SubscribeURL = [NSString alloc];
}

- (void) mqttConnect : (NSArray *) OAuth_Information {
    MQTTSession *MySession;

    MQTTWebsocketTransport *Transport = [[MQTTWebsocketTransport alloc] init];
    
    Transport.host = @"healthng.oucare.com";
    Transport.port = 1885;
    Transport.path = @"/ws";
    Transport.tls = YES;
    //Transport.url = [NSURL URLWithString:@"wss://healthng.oucare.com:1885/ws"];
    
    MySession = [[MQTTSession alloc] init];
    
    [MySession setTransport:Transport];
    [MySession setDelegate:self];
    
    NSLog(@"MySession.delegate = %@", MySession.delegate);
    // UserName 和 Password OTP
    NSLog(@"OAuth_Information = %@", OAuth_Information);
    NSString *Client_ID = [[OAuth_Information objectAtIndex:0] objectAtIndex:0];
    NSString *User_Name = [[OAuth_Information objectAtIndex:0] objectAtIndex:1];
    NSString *OTP = [[OAuth_Information objectAtIndex:0] objectAtIndex:2];
    NSString *OTP_Expired = [[OAuth_Information objectAtIndex:0] objectAtIndex:3];
    
    G_Client_ID = Client_ID;
    G_User_Name = User_Name;
    G_OTP = OTP;
    G_OTP_Expired = OTP_Expired;

    [MySession setClientId:Client_ID];
    [MySession setUserName:User_Name];
    [MySession setPassword:OTP];
    
    [MySession setKeepAliveInterval:5];
    
    NSLog(@"Session Before Connect = %@", MySession);
    [MySession connectAndWaitTimeout:15];
}

- (void) mqttSubscribe {
    
}

/**
 * 當執行 [MySeccion connectAndWaitTimeout:time]; 時觸發
 */
-(void)
handleEvent:(MQTTSession *)     session
      event:(MQTTSessionEvent)  eventCode
      error:(NSError *)         error {
    Session = session;
    if (eventCode == MQTTSessionEventConnected)
    {
        NSLog(@"MQTTStatus : Connected");
        // Subscribe part
        NSLog(@"SessionBeforeSubscribe = %@", session);
        //[session setTransport:nil];
        NSString *ORGTOPIC = @"/ouhub/orgs/7da0f976-f732-11ea-b7aa-0242ac160004";
        NSString *ClientTopic = @"/ouhub/clients/zfawrs3MWIcqmv8mx3tD";
        [session subscribeToTopic:ORGTOPIC
                          atLevel:MQTTQosLevelAtLeastOnce
                 subscribeHandler:
         ^(NSError *error,
           NSArray<NSNumber *> *gQoss)
        {
            if (error) {
                NSLog(@"MQTTStatuserror:%@",error);
            } else {
                NSLog(@"SessionAfterSubscribe = %@", session);
//                Session = session;
                NSLog(@"MQTTStatusOK:%@",gQoss);
//                NSDictionary *Information_Dictionary = [NSDictionary dictionaryWithObject:Session
//                                                                                   forKey:@"Session"];
//                [[NSNotificationCenter defaultCenter]
//                    postNotificationName:@"getMQTTSubscribing" //Notification以一個字串(Name)下去辨別
//                    object:self->View_Controller_For_Notify
//                    userInfo:Information_Dictionary];
            }
        }];
        [session subscribeToTopic:ClientTopic
                          atLevel:MQTTQosLevelAtLeastOnce
                 subscribeHandler:
         ^(NSError *error,
           NSArray<NSNumber *> *gQoss)
        {
            if (error) {
            } else {
            }
        }];
    } else if (eventCode == MQTTSessionEventConnectionRefused) {
        NSLog(@"MQTTStatus : refused");
    } else if (eventCode == MQTTSessionEventConnectionClosed) {
        NSLog(@"MQTTStatus : closed");
        [session connectAndWaitTimeout:15];
    } else if (eventCode == MQTTSessionEventConnectionError) {
        NSLog(@"MQTTStatus : error");
    } else if (eventCode == MQTTSessionEventProtocolError) {
        NSLog(@"MQTTStatus : MQTTSessionEventProtocolError");
    } else {//MQTTSessionEventConnectionClosedByBroker
        NSLog(@"MQTTStatus : other");
    }
    
    if (error) {
        NSLog(@"MQTTStatus error  -- %@",error);
    }
}

- (void) publishTest {
    PublishDataFor4320 *publishDataFor4320 = [[PublishDataFor4320 alloc] init];

    NSString *Device_Type = @"KS-4310";
    NSString *Serial = @"S10";
    NSString *Baby_UUID = @"92ee96a5-ff9a-11ea-8fd3-0242ac160004";
    
    NSData *PublishData = [publishDataFor4320 getPublishData:Device_Type
                                               Device_Serial:Serial
                                                 Device_UUID:Baby_UUID
                                                   client_ID:G_Client_ID
                                                Temperature1:40
                                                Temperature2:50
                                                Temperature3:60
                                                     Battery:70
                                                      Breath:YES
                                                    Motion_X:123.1
                                                    Motion_Y:252.6
                                                    Motion_Z:929.1];
    NSLog(@"PublishData = %@", PublishData);
    [Session publishData:PublishData
                 onTopic:@"/ouhub/requests"
                  retain:NO
                     qos:MQTTQosLevelAtMostOnce
          publishHandler:^(NSError *error) {
        NSLog(@"subviewInPublish = %@",  self.view.subviews);
        if (error) {
            NSLog(@"失去MQTT Subscribe");
            // 重新讀取
            NSLog(@"PulbishForSameTimeerror - %@",error);
        } else {
            NSLog(@"send ok");
        }}];
}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid {
    NSLog(@"Get Message From MQTT");
    
    NSString *ORGTOPIC = @"/ouhub/orgs/";
    NSString *ClientTopic = @"/ouhub/clients/";
    if ([topic rangeOfString:ORGTOPIC].location != NSNotFound) {
        // 由 data 反序列化 protobuf
        Message *message = [Message parseFromData:data error:nil];
        // Temperature 1
        NSLog(@"Temp1ForMessage = %f", [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:0] temperatureProperty] value]);
        // Temperature 2
        NSLog(@"Temp2ForMessage = %f", [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:1] temperatureProperty] value]);
        // Temperature 3
        NSLog(@"Temp3ForMessage = %f", [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:2] temperatureProperty] value]);
        // Battery
        NSLog(@"BatteryForMessage = %d", [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:3] batteryProperty] value]);
        // Breath normal
        NSLog(@"BreathForMessage = %d", [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:4] breathProperty] value]);
    }
    else {
    }
}
//- (void)newMessage:(MQTTSession *)session
//              data:(NSData *)data
//           onTopic:(NSString *)topic
//               qos:(MQTTQosLevel)qos
//          retained:(BOOL)retained
//               mid:(unsigned int)mid
//{
//    TypesConversion *typesConversion = [[TypesConversion alloc] init];
//    NSLog(@"IntoNewMessage");
//    NSLog(@"DataForReturn:%@", [typesConversion getHEX:data]);
//    NSLog(@"DataForReturn:%lu", (unsigned long)[[typesConversion getHEX:data] length]);
//    NSString *NewString = @"";
//    StringProcessFunc *stringProcessFunction = [[StringProcessFunc alloc] init];
//    for(int i = 0; i < [[typesConversion getHEX:data] length]; i = i + 2) {
//        NewString = [stringProcessFunction MergeTwoString:NewString
//                                                SecondStr:[stringProcessFunction getSubString:[typesConversion getHEX:data]
//                                                                                       length:2
//                                                                                     location:i]];
//        NewString = [stringProcessFunction MergeTwoString:NewString SecondStr:@" "];
//
//    }
//    NSLog(@"NewString :%@", NewString);
//}
@end
