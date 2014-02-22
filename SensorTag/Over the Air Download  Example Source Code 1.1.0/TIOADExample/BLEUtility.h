/*
 BLEUtility.h
 TIOADExample

 Created by Ole Andreas Torvmark on 9/22/12.
 Copyright (c) 2013 Texas Instruments. All rights reserved.

 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface BLEUtility : NSObject

+(void)readCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID;

+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable;

+(void)writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data;
+(void)writeCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data;

+(void)writeNoResponseCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data;
+(void)writeNoResponseCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data;


+(void)readCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID;
+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID enable:(BOOL)enable;

+(bool) isCharacteristicNotifiable:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID;
+(BOOL) runningiOSSeven;
@end
