//
//  MQTTMain.m
//  MQTTTest
//
//  Created by louie on 2020/11/24.
//

#import "MQTTMain.h"

@interface MQTTMain ()
{
    UIViewController *View_Controller_For_Notify;
}
@end

@implementation MQTTMain

MQTTSession *Session;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) mqttStart : (NSArray *) OAuth_Information
    viewController : (UIViewController *) View_Controller {
    View_Controller_For_Notify = View_Controller;
    [self mqttConnect : OAuth_Information];
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
    
    // UserName 和 Password OTP
    NSString *Client_ID = [[OAuth_Information objectAtIndex:0] objectAtIndex:0];
    NSString *User_Name = [[OAuth_Information objectAtIndex:0] objectAtIndex:1];
    NSString *OTP = [[OAuth_Information objectAtIndex:0] objectAtIndex:2];
    //NSString *OTP_Expired = [OAuth_Information objectAtIndex:3];

    [MySession setUserName:User_Name];
    [MySession setPassword:OTP];
    [MySession setClientId:Client_ID];
    
    [MySession setKeepAliveInterval:5];
    
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
            if (error) {
                NSLog(@"MQTTStatuserror:%@",error);
            } else {
                Session = session;
                NSLog(@"MQTTStatusOK:%@",gQoss);
                NSDictionary *Information_Dictionary = [NSDictionary dictionaryWithObject:Session
                                                                                   forKey:@"Session"];
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"getMQTTSubscribing" //Notification以一個字串(Name)下去辨別
                    object:self->View_Controller_For_Notify
                    userInfo:Information_Dictionary];
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
    for(int i = 0; i < [[typesConversion getHEX:data] length]; i = i + 2) {
        NewString = [stringProcessFunction MergeTwoString:NewString
                                                SecondStr:[stringProcessFunction getSubString:[typesConversion getHEX:data]
                                                                                       length:2
                                                                                     location:i]];
        NewString = [stringProcessFunction MergeTwoString:NewString SecondStr:@" "];
        
    }
    NSLog(@"NewString :%@", NewString);
}
@end
