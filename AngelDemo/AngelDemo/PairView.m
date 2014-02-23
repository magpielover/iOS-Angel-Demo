//
//  PairView.m
//  AngelDemo
//
//  Created by Ugur Kirbac on 20/02/14.
//  Copyright (c) 2014 Ugur Kirbac. All rights reserved.
//

#import "PairView.h"
#import "deviceSelector.h"
@interface PairView ()

@end

@implementation PairView
@synthesize m,nDevices,sensorTags;

-(id)init{
    
  

    self =[super init];
    {
        // superclass successfully initialized, further
        // initialization happens here ...
        self.m = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.nDevices = [[NSMutableArray alloc]init];
        self.sensorTags = [[NSMutableArray alloc]init];
        [self.m  scanForPeripheralsWithServices:nil options:nil];


        NSLog(@"PairViewCreated");
        
    }
    return self;
}

/*
- (IBAction)makeVisible{
    
    [angelIcon setHidden:NO];
}

- (IBAction)makeInvisible{

    [angelIcon setHidden:YES];

}
 */

- (IBAction)hideIcon{

 
     [angelIcon setHidden:YES];
       NSLog(@"Icon hidden");

}


- (IBAction)showIcon{
    
     [angelIcon setHidden:NO];
     NSLog(@"Icon shown");
    
}

- (IBAction)switchView:(id)sender {
    PairView *pairview = [[PairView alloc] init];
    [self presentViewController:pairview animated:YES completion:NULL];
}


-(void) viewWillAppear:(BOOL)animated {
    self.m.delegate = self;
    
}

#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *p = [self.sensorTags objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BLEDevice *d = [[BLEDevice alloc]init];
    
    d.p = p;
    d.manager = self.m;
    d.setupData = [self makeSensorTagConfiguration];
    
    SensorTagApplicationViewController *vC = [[SensorTagApplicationViewController alloc]initWithStyle:UITableViewStyleGrouped andSensorTag:d];
    [self.navigationController pushViewController:vC animated:YES];
    
}




#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat:@"CoreBluetooth return state: %d",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}




-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Found a BLE Device : %@",peripheral);
    
    /* iOS 6.0 bug workaround : connect to device before displaying UUID !
     The reason for this is that the CFUUID .UUID property of CBPeripheral
     here is null the first time an unkown (never connected before in any app)
     peripheral is connected. So therefore we connect to all peripherals we find.
     */
    
    peripheral.delegate = self;
    [central connectPeripheral:peripheral options:nil];
    
    [self.nDevices addObject:peripheral];
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral discoverServices:nil];
         NSLog(@"dicConnectPeripheral girdi");
}

#pragma  mark - CBPeripheral delegate

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    BOOL replace = NO;
    BOOL found = NO;
    NSLog(@"Services scanned !");
    [self.m cancelPeripheralConnection:peripheral];
    for (CBService *s in peripheral.services) {
        NSLog(@"Service found : %@",s.UUID);
        if ([s.UUID isEqual:[CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"]])  {
            NSLog(@"This is a SensorTag !");
            found = YES;
        }
    }
    if (found) {
        // Match if we have this device from before
        for (int ii=0; ii < self.sensorTags.count; ii++) {
            CBPeripheral *p = [self.sensorTags objectAtIndex:ii];
            if ([p isEqual:peripheral]) {
                [self.sensorTags replaceObjectAtIndex:ii withObject:peripheral];
                replace = YES;
            }
        }
        if (!replace) {
            [self.sensorTags addObject:peripheral];
           // [self.tableView reloadData];
            // SHOULD BE WRITTEN UGUR ----
        }
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}


#pragma mark - SensorTag configuration

-(NSMutableDictionary *) makeSensorTagConfiguration {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    // First we set ambient temperature
    [d setValue:@"1" forKey:@"Ambient temperature active"];
    // Then we set IR temperature
    [d setValue:@"1" forKey:@"IR temperature active"];
    // Append the UUID to make it easy for app
    [d setValue:@"F000AA00-0451-4000-B000-000000000000"  forKey:@"IR temperature service UUID"];
    [d setValue:@"F000AA01-0451-4000-B000-000000000000" forKey:@"IR temperature data UUID"];
    [d setValue:@"F000AA02-0451-4000-B000-000000000000"  forKey:@"IR temperature config UUID"];
    // Then we setup the accelerometer
    [d setValue:@"1" forKey:@"Accelerometer active"];
    [d setValue:@"500" forKey:@"Accelerometer period"];
    [d setValue:@"F000AA10-0451-4000-B000-000000000000"  forKey:@"Accelerometer service UUID"];
    [d setValue:@"F000AA11-0451-4000-B000-000000000000"  forKey:@"Accelerometer data UUID"];
    [d setValue:@"F000AA12-0451-4000-B000-000000000000"  forKey:@"Accelerometer config UUID"];
    [d setValue:@"F000AA13-0451-4000-B000-000000000000"  forKey:@"Accelerometer period UUID"];
    
    //Then we setup the rH sensor
    [d setValue:@"1" forKey:@"Humidity active"];
    [d setValue:@"F000AA20-0451-4000-B000-000000000000"   forKey:@"Humidity service UUID"];
    [d setValue:@"F000AA21-0451-4000-B000-000000000000" forKey:@"Humidity data UUID"];
    [d setValue:@"F000AA22-0451-4000-B000-000000000000" forKey:@"Humidity config UUID"];
    
    //Then we setup the magnetometer
    [d setValue:@"1" forKey:@"Magnetometer active"];
    [d setValue:@"500" forKey:@"Magnetometer period"];
    [d setValue:@"F000AA30-0451-4000-B000-000000000000" forKey:@"Magnetometer service UUID"];
    [d setValue:@"F000AA31-0451-4000-B000-000000000000" forKey:@"Magnetometer data UUID"];
    [d setValue:@"F000AA32-0451-4000-B000-000000000000" forKey:@"Magnetometer config UUID"];
    [d setValue:@"F000AA33-0451-4000-B000-000000000000" forKey:@"Magnetometer period UUID"];
    
    //Then we setup the barometric sensor
    [d setValue:@"1" forKey:@"Barometer active"];
    [d setValue:@"F000AA40-0451-4000-B000-000000000000" forKey:@"Barometer service UUID"];
    [d setValue:@"F000AA41-0451-4000-B000-000000000000" forKey:@"Barometer data UUID"];
    [d setValue:@"F000AA42-0451-4000-B000-000000000000" forKey:@"Barometer config UUID"];
    [d setValue:@"F000AA43-0451-4000-B000-000000000000" forKey:@"Barometer calibration UUID"];
    
    [d setValue:@"1" forKey:@"Gyroscope active"];
    [d setValue:@"F000AA50-0451-4000-B000-000000000000" forKey:@"Gyroscope service UUID"];
    [d setValue:@"F000AA51-0451-4000-B000-000000000000" forKey:@"Gyroscope data UUID"];
    [d setValue:@"F000AA52-0451-4000-B000-000000000000" forKey:@"Gyroscope config UUID"];
    
    NSLog(@"%@",d);
    
    return d;
}


@end
