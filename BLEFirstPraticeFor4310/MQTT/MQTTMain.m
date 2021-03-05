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
    self.MQTTMessage = [[NSMutableArray alloc] init];
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
    
    self.Client_ID = Client_ID;
    self.User_Name = User_Name;
    self.OTP = OTP;
    self.OTP_Expired = OTP_Expired;
    
    NSLog(@"TestOTPForDisconnect = %@", OTP);
    //vln_IYImYM_B8NaX

    
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
        // 監測模式
        if(Mode == 0) {
            // 更新手機狀態 -- 監測中
            RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
            [requestOAuth2Steps refreshPhoneInformation:OAuth.Access_Token
                                                 status:1
                                              client_ID:self.Client_ID
                                              wKWebView:OAuth.WKWeb_View];
        }
        // 訂閱模式
        else if(Mode == 1) {
            
        }
        
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

- (void) publishTest : (NSString *) Device_Type
        deviceSerial : (NSString *) Device_Serial
          deviceUUID : (NSString *) Device_UUID
                  t1 : (NSInteger) T1
                  t2 : (NSInteger) T2
                  t3 : (NSInteger) T3
             battery : (int) Battery
              breath : (BOOL) Breath
             motionX : (float) Motion_X
             motionY : (float) Motion_Y
             motionZ : (float) Motion_Z
{
    PublishDataFor4320 *publishDataFor4320 = [[PublishDataFor4320 alloc] init];

//    NSString *Type = @"KS-4310";
//    NSString *Serial = @"S10";
//    NSString *Baby_UUID = @"92ee96a5-ff9a-11ea-8fd3-0242ac160004";
    NSLog(@"PublishData-Device_Type = %@", Device_Type);
    NSLog(@"PublishData-Device_Serial = %@", Device_Serial);
    NSLog(@"PublishData-Device_UUID = %@", Device_UUID);
    NSLog(@"PublishData-ClientID = %@", self.Client_ID);

    RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
    //[requestOAuth2Steps refreshDevicesInformation:OAuth.Access_Token status:1 deviceUUID:Device_UUID wKWebView:OAuth.WKWeb_View];
    
                                 
    NSData *PublishData = [publishDataFor4320 getPublishData:Device_Type
                                               Device_Serial:[Device_Serial uppercaseString]
                                                 Device_UUID:Device_UUID
                                                   client_ID:self.Client_ID
                                                Temperature1:T1
                                                Temperature2:T2
                                                Temperature3:T3
                                                     Battery:Battery
                                                      Breath:Breath
                                                    Motion_X:Motion_X
                                                    Motion_Y:Motion_Y
                                                    Motion_Z:Motion_Z];
    NSLog(@"PublishData = %@", PublishData);
    [Session publishData:PublishData
                 onTopic:@"/ouhub/requests"
                  retain:NO
                     qos:MQTTQosLevelAtMostOnce
          publishHandler:^(NSError *error) {
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
        
        NSMutableDictionary *MessageDict = [[NSMutableDictionary alloc] init];
        
        // Model
        NSString *Model = [[[message.postMeasureRequest.recordArray objectAtIndex:0] deviceProperty] model];
        [MessageDict setValue:Model forKey:@"Model"];
        NSLog(@"ModelForMessage = %@", Model);
        
        // Serial
        NSString *Serial = [[[message.postMeasureRequest.recordArray objectAtIndex:0] deviceProperty] serial];
        [MessageDict setValue:Serial forKey:@"Serial"];
        NSLog(@"SerialForMessage = %@", Serial);
        
        // UUID
        NSString *UUID = [[[message.postMeasureRequest.recordArray objectAtIndex:0] deviceProperty] uuid];
        [MessageDict setValue:UUID forKey:@"UUID"];
        NSLog(@"UUIDForMessage = %@", UUID);

        // Temperature 1
        float T1 = [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:0] temperatureProperty] value];
        NSNumber *T1_Number = [[NSNumber alloc] initWithFloat:T1];
        [MessageDict setValue:T1_Number forKey:@"T1"];
        NSLog(@"Temp1ForMessage = %f", T1);
        // Temperature 2
        float T2 = [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:1] temperatureProperty] value];
        NSNumber *T2_Number = [[NSNumber alloc] initWithFloat:T2];
        [MessageDict setValue:T2_Number forKey:@"T2"];
        NSLog(@"Temp2ForMessage = %f", T2);
        // Temperature 3
        float T3 = [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:2] temperatureProperty] value];
        NSNumber *T3_Number = [[NSNumber alloc] initWithFloat:T3];
        [MessageDict setValue:T3_Number forKey:@"T3"];
        NSLog(@"Temp3ForMessage = %f", T3);
        
        // Battery
        int Battery = [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:3] batteryProperty] value];
        NSNumber *Battery_Number = [[NSNumber alloc] initWithInt:Battery];
        [MessageDict setValue:Battery_Number forKey:@"Battery"];
        NSLog(@"BatteryForMessage = %d", Battery);
        
        // Breath normal
        BOOL Breath = [[[[[message.postMeasureRequest.recordArray objectAtIndex:0] sensorArray] objectAtIndex:4] breathProperty] value];
        [MessageDict setValue:[NSNumber numberWithBool:Breath] forKey:@"Breath"];
        NSLog(@"BreathForMessage = %d", Breath);
        
        int SerialSameIndex = -1;
        for(int i = 0; i < self.MQTTMessage.count; i++) {
            if([Serial isEqual:[[self.MQTTMessage objectAtIndex:i] valueForKey:@"Serial"]]) {
                SerialSameIndex = i;
                break;
            }
        }
        if(SerialSameIndex == -1) {
            [self.MQTTMessage addObject:MessageDict];
        }
        else {
            [self.MQTTMessage replaceObjectAtIndex:SerialSameIndex withObject:MessageDict];
        }
        NSLog(@"MEssage Dict = %@", MessageDict);
        NSLog(@"MEssage Dict Array = %@", self.MQTTMessage);
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
