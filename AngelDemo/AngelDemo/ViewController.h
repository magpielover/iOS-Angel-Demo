//
//  ViewController.h
//  AngelDemo
//
//  Created by Ugur Kirbac on 20/02/14.
//  Copyright (c) 2014 Ugur Kirbac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
IBOutlet UITextField *usernameField;
IBOutlet UITextField *passwordField;
    NSDictionary *credentialsDictionary;
}

- (IBAction)enterCredentials;
- (IBAction)backgroundTouched;

@end
