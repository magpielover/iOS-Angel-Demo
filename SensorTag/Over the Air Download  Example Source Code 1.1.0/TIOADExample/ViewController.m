/*
 ViewController.m
 TIOADExample

 Created by Ole Andreas Torvmark on 1/7/13.
 Copyright (c) 2013 Texas Instruments. All rights reserved.

 */

#import "ViewController.h"
#import "BLEDevice.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.dSVC = [[deviceSelectorViewController alloc]initWithStyle:UITableViewStyleGrouped];
    self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.dSVC.manager = self.manager;
    self.dSVC.delegate = self;
    [self.button2 setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button functions

- (IBAction)button1Selected:(id)sender {
    NSLog(@"Opening device selector");
    [self presentViewController:self.dSVC animated:YES completion:nil];
}

- (IBAction)button2Selected:(id)sender {
    BLEDevice *dev = [[BLEDevice alloc]init];
    dev.p = self.dSVC.p;
    dev.manager = self.manager;
    self.oadProfile = [[BLETIOADProfile alloc]initWithDevice:dev];
    self.oadProfile.progressView = [[BLETIOADProgressViewController alloc]init];
    [self.oadProfile makeConfigurationForProfile];
    self.oadProfile.navCtrl = self.navigationController;
    [self.oadProfile configureProfile];
    self.oadProfile.view = self.view;
    [self.oadProfile selectImagePressed:self];

    
}


#pragma mark - deviceSelectorDelegate Callbacks

-(void)didSelectDevice {
    [self.button1 setTitle:[NSString stringWithFormat:@"%@ selected",self.dSVC.p.name] forState:UIControlStateNormal];
    self.dSVC.p.delegate = self;
    self.manager.delegate = self;
    if (!self.dSVC.p.isConnected) [self.manager connectPeripheral:self.dSVC.p options:nil];
}

#pragma mark - CBCentralManagerDelegate Callbacks

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *aV = [[UIAlertView alloc]initWithTitle:@"Bluetooth Smart not available on this device" message:@"Bluetooth Smart is not available on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [aV show];
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral discoverServices:nil];
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self.oadProfile deviceDisconnected:peripheral];
}

#pragma mark - CBPeripheralDelegate Callbacks

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error  {
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"Service : %@",service.UUID);
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"0xF000FFC0-0451-4000-B000-000000000000"]]) {
         [self.button2 setEnabled:YES];
         [self.button2 setTitle:@"Select file" forState:UIControlStateNormal];
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    [self.oadProfile didUpdateValueForProfile:characteristic];
}



@end
