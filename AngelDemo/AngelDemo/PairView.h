//
//  PairView.h
//  AngelDemo
//
//  Created by Ugur Kirbac on 20/02/14.
//  Copyright (c) 2014 Ugur Kirbac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDevice.h"
#import "SensorTagApplicationViewController.h"

@interface PairView : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate>{
     IBOutlet UITableView *tagTable;
    IBOutlet UIButton *angelIcon;
   
}

@property (strong,nonatomic) CBCentralManager *m;
@property (strong,nonatomic) NSMutableArray *nDevices;
@property (strong,nonatomic) NSMutableArray *sensorTags;

/*
- (IBAction)makeVisible:(id)sender;
- (IBAction)makeInvisible:(id)sender;
 */
- (IBAction)switchView:(id)sender;
- (IBAction)showIcon;
- (IBAction)hideIcon;

-(NSMutableDictionary *) makeSensorTagConfiguration;

@end

