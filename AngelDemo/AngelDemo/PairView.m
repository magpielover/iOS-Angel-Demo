//
//  PairView.m
//  AngelDemo
//
//  Created by Ugur Kirbac on 20/02/14.
//  Copyright (c) 2014 Ugur Kirbac. All rights reserved.
//

#import "PairView.h"
@interface PairView ()

@end

@implementation PairView
- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)addImageView{
    UIImageView *imgview = [[UIImageView alloc]
                            initWithFrame:CGRectMake(10, 10, 300, 400)];
    [imgview setImage:[UIImage imageNamed:@"AppleUSA1.jpg"]];
    [imgview setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addImageView];
}
@end


