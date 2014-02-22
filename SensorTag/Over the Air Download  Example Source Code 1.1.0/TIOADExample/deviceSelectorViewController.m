/*
 deviceSelectorViewController.m
 TIOADExample
 Created by Ole Andreas Torvmark on 1/7/13.
 Copyright (c) 2013 Texas Instruments. All rights reserved.
 
 */
 
#import "deviceSelectorViewController.h"

@interface deviceSelectorViewController ()

@end

@implementation deviceSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.devices = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    self.manager.delegate = self;
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"Actions";
    else if (section == 1) return @"Devices Found";
    else return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) return 1;
    else if (section == 1) return self.devices.count;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Cancel";
    }
    if (indexPath.section == 1) {
        CBPeripheral *p = [self.devices objectAtIndex:indexPath.row];
        cell.textLabel.text = p.name;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        self.p = [self.devices objectAtIndex:indexPath.row];
        [self.delegate didSelectDevice];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CBCentralManagerDelegate Callbacks

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if ([self.devices containsObject:peripheral]) return;
    else {
        [self.devices addObject:peripheral];
        [self.manager connectPeripheral:peripheral options:nil];
    }
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

#pragma mark - CBPeripheralDelegate Callbacks

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    [self.manager cancelPeripheralConnection:peripheral];
    [self.tableView reloadData];
}

@end
