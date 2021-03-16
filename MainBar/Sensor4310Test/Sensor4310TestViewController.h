//
//  Sensor4310TestViewController.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/15.
//

#import <UIKit/UIKit.h>
#import "StoredDevicesCell.h"

NS_ASSUME_NONNULL_BEGIN
@class Sensor4310TestViewController;

@protocol Sensor4310TestViewControllerDelegate <NSObject>

@optional

- (StoredDevicesCell *) getStoredDevicesCell : (NSInteger) Index;
- (NSInteger) getSotredDataCount;

@end

@interface Sensor4310TestViewController : UIViewController

@property(readwrite, nonatomic) NSInteger CurrentController;

@property(assign) id <Sensor4310TestViewControllerDelegate> delegate;

- (void) controllerInit;

- (void) reloadCellAt : (NSInteger) Index;
- (void) insertCellAt : (NSInteger) Index;
- (void) deleteCellAt : (NSInteger) Index;
    
@end

NS_ASSUME_NONNULL_END
