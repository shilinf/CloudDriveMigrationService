//
//  ViewController.m
//  CloudDriveMigrationServiceIOSClient
//
//  Created by Bochun Zhang on 7/27/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (strong) UIButton* onedriveSignInBtn;
@property (strong) UIButton* dropboxSignInBtn;

@end

@implementation ViewController
@synthesize liveClient;
@synthesize infoLabel;

NSString* APP_CLIENT_ID=@"0000000048160A9A";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.onedriveSignInBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.onedriveSignInBtn.frame = CGRectMake((self.view.frame.size.width-200)/2, 100, 200, 50);
    [self.onedriveSignInBtn setTitle:@"OneDrive Sign In" forState:UIControlStateNormal];
    [self.onedriveSignInBtn addTarget:self action:@selector(onedriveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.onedriveSignInBtn];
    
    self.dropboxSignInBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.dropboxSignInBtn.frame = CGRectMake((self.view.frame.size.width-200)/2, 150, 200, 50);
    [self.dropboxSignInBtn setTitle:@"Dropbox Sign In" forState:UIControlStateNormal];
    [self.dropboxSignInBtn addTarget:self action:@selector(dropboxBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dropboxSignInBtn];
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];

    infoLabel.text = @"aaa";
    //[self.view addSubview:infoLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onedriveBtnPressed: (UIButton*) sender {
    NSLog(@"onedriveBtnPressed");
    self.liveClient = [[LiveConnectClient alloc] initWithClientId:APP_CLIENT_ID
                                                         delegate:self
                                                        userState:@"initialize"];
}

- (void)dropboxBtnPressed: (UIButton*) sender {
    NSLog(@"dropboxBtnPressed");
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
}

- (void)authCompleted:(LiveConnectSessionStatus) status
              session:(LiveConnectSession *) session
            userState:(id) userState
{
    NSLog(@"authCompleted");
    if ([userState isEqual:@"initialize"])
    {
        NSLog(@"authCompleted - initialize");
        [self.infoLabel setText:@"Initialized."];
        NSMutableArray* scopes = [[NSMutableArray alloc]init];
        [scopes addObject:@"wl.signin"];
        [scopes addObject:@"wl.offline_access"];
        [scopes addObject:@"onedrive.readwrite"];
        [scopes addObject:@"wl.skydrive"];
        [self.liveClient login:self
                        scopes:[[NSArray alloc] initWithArray:scopes]
                      delegate:self
                     userState:@"signin"];
    }
    if ([userState isEqual:@"signin"])
    {
        NSLog(@"authCompleted - sign in");
        if (session != nil)
        {
            [self.infoLabel setText:@"Signed in."];
            NSLog(self.liveClient.session.accessToken);
        }
    }
}

- (void)authFailed:(NSError *) error
         userState:(id)userState
{
    NSLog(@"authFailed"); 
    NSLog([NSString stringWithFormat:@"Error: %@", [error localizedDescription]]);
    [self.infoLabel setText:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
}

@end
