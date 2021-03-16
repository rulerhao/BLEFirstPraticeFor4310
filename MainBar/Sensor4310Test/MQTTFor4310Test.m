//
//  MQTTFor4310Test.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/15.
//

#import "MQTTFor4310Test.h"
#import "RequestOAuth2Steps.h"
@interface MQTTFor4310Test ()
{
    PublishDataFor4320 *publishDataFor4320;
    RequestOAuth2Steps *requestOAuth2Steps;
}
@property (readwrite, nonatomic) MQTTSession *Session;
@property (readwrite, nonatomic) NSString *Client_ID;
@end

@implementation MQTTFor4310Test

- (instancetype) init
{
    self = [super init];
    if (self) {
        publishDataFor4320 = [PublishDataFor4320 alloc];
        requestOAuth2Steps = [RequestOAuth2Steps alloc];
    }
    return self;
}

#pragma mark - MQTT Methods
- (void) mqttConnect : (NSString *) Client_ID
           User_Name : (NSString *) User_Name
                 OTP : (NSString *) OTP
         OTP_Expired : (NSInteger) OTP_Expired
{
    NSLog(@"MQTTConnect");
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
    
    NSLog(@"TestOTPForDisconnect = %@", OTP);
    //vln_IYImYM_B8NaX

    self.Client_ID = Client_ID;
    [MySession setClientId:Client_ID];
    [MySession setUserName:User_Name];
    [MySession setPassword:OTP];
    
    [MySession setKeepAliveInterval:5];
    
    NSLog(@"Session Before Connect = %@", MySession);
    [MySession connectAndWaitTimeout:15];
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

//    NSString *Type = @"KS-4310";
//    NSString *Serial = @"S10";
//    NSString *Baby_UUID = @"92ee96a5-ff9a-11ea-8fd3-0242ac160004";
    NSLog(@"PublishData-Device_Type = %@", Device_Type);
    NSLog(@"PublishData-Device_Serial = %@", Device_Serial);
    NSLog(@"PublishData-Device_UUID = %@", Device_UUID);
    NSLog(@"PublishData-ClientID = %@", self.Client_ID);
    
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
    [self.Session publishData:PublishData
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
#pragma mark - MQTT Delegate
/**
 * 當執行 [MySeccion connectAndWaitTimeout:time]; 時觸發
 */
-(void)
handleEvent:(MQTTSession *)     session
      event:(MQTTSessionEvent)  eventCode
      error:(NSError *)         error {
    self.Session = session;
    if (eventCode == MQTTSessionEventConnected)
    {
        RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
        // 更新手機狀態
        [requestOAuth2Steps refreshPhoneInformation:[self.delegate getAccessToken]
                                             status:1
                                          client_ID:[self.delegate getClientID]
                                          wKWebView:[self.delegate getWebView]];
        NSLog(@"ChangeStatus");
        
        NSLog(@"MQTTStatus : Connected");
        // Subscribe part
        NSLog(@"SessionBeforeSubscribe = %@", session);
        //[session setTransport:nil];
        NSString *ORGTOPIC = @"/ouhub/orgs/7da0f976-f732-11ea-b7aa-0242ac160004";
//        NSString *ClientTopic = @"/ouhub/clients/zfawrs3MWIcqmv8mx3tD";
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

- (void)newMessage : (MQTTSession *) session
              data : (NSData *) data
           onTopic : (NSString *) topic
               qos : (MQTTQosLevel) qos
          retained : (BOOL) retained
               mid : (unsigned int) mid {
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
        
//        int SerialSameIndex = -1;
//        for(int i = 0; i < self.MQTTMessage.count; i++) {
//            if([Serial isEqual:[[self.MQTTMessage objectAtIndex:i] valueForKey:@"Serial"]]) {
//                SerialSameIndex = i;
//                break;
//            }
//        }
//        if(SerialSameIndex == -1) {
//            [self.MQTTMessage addObject:MessageDict];
//        }
//        else {
//            [self.MQTTMessage replaceObjectAtIndex:SerialSameIndex withObject:MessageDict];
//        }
//        NSLog(@"MEssage Dict = %@", MessageDict);
//        NSLog(@"MEssage Dict Array = %@", self.MQTTMessage);
    }
    else {
    }
}
#pragma mark - Delegate

@end
