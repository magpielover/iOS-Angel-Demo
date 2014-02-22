/*
  ViewController.h
  TIOADExample

  Created by Ole Andreas Torvmark on 1/7/13.
  Copyright (c) 2013 Texas Instruments. All rights reserved.

 */

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "deviceSelectorViewController.h"
#import "BLETIOADProfile.h"
#import "BLETIOADProgressViewController.h"


@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, deviceSelectorDelegate>

@property (strong, nonatomic) CBCentralManager *manager;
@property (strong,nonatomic) CBPeripheral *p;
@property (strong, nonatomic) deviceSelectorViewController *dSVC;
@property (strong,nonatomic) BLETIOADProfile *oadProfile;


//In case of iOS 7.0
@property (strong,nonatomic) BLETIOADProgressViewController *progressView;

- (IBAction)button1Selected:(id)sender;
- (IBAction)button2Selected:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end
