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
@property (strong) UIButton* sendBtn;
@property (strong) NSString* onedriveToken;
@property (strong) NSString* dropboxToken;

@end

@implementation ViewController
@synthesize liveClient;
@synthesize infoLabel;

NSString* APP_CLIENT_ID=@"0000000048160A9A";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // OneDrive Button
    self.onedriveSignInBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.onedriveSignInBtn.frame = CGRectMake((self.view.frame.size.width-200)/2, 100, 200, 50);
    [self.onedriveSignInBtn setTitle:@"OneDrive Sign In" forState:UIControlStateNormal];
    [self.onedriveSignInBtn addTarget:self action:@selector(onedriveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.onedriveSignInBtn];
    
    // Dropbox Button
    self.dropboxSignInBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.dropboxSignInBtn.frame = CGRectMake((self.view.frame.size.width-200)/2, 150, 200, 50);
    [self.dropboxSignInBtn setTitle:@"Dropbox Sign In" forState:UIControlStateNormal];
    [self.dropboxSignInBtn addTarget:self action:@selector(dropboxBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dropboxSignInBtn];
    
    // Send Button
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendBtn.frame = CGRectMake((self.view.frame.size.width-200)/2, 200, 200, 50);
    [self.sendBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendBtn];
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];

    infoLabel.text = @"aaa";
    //[self.view addSubview:infoLabel];
    
    /*
    [[NSUserDefaults standardUserDefaults]setObject:@"EwB4Aq1DBAAUGCCXc8wU/zFu9QnLdZXy+YnElFkAAfDywFbVvQgKoV4QDBTGUCyp3JggPHm87nMF0qbQ7z79yFJImX38icGI67nEQZgsO5MSw+leN8anmTal30XNlabwsr7jqWkjUzytPwkEfgdZLgXEfPYKpHpwaHRR6Ut7FBIEdE6EiKlqXCmIYwCt0wBBu+G7646FsaOYCgfSgtCo8gH0RzGD5aIoNfnG/vVKbyfG15lu1suXx9dqPMfFj9bv8b50bMjwxoZdRVxhi5Jp4BvJOHm7TPw7uG8kQ7lcohQupiGvY4A51g5b/J6bAzo5H62XoAlV/o/oAo8LPeMtBmhT4eo2CMy+xMyHUtwRGb4XVZULJYp24C02rK9wM5UDZgAACI6SM2oJ+0bdSAE8huhnq3krXAqn8N93yKenuP4usjeMtdzQzHNno6+qaRH2V3/Mub3twTj3wHDvurdCsNQyvZs9tyzNo/sbMB8DcfPmDnBp8yCGQaGOGLm91vVyziH7ThGvFs8aoHS9l3B1aPi2cv+ZGeDo30tJqvl5wA6HrOAvwoct0lgdJBwgEEbG0m+02ZzC00tjn9e3e+HQAcXjCuulHkY71DezvZWVfcnL70WuMgI13bMWRpT+WssyIrLNXQP2jgpst6mSY4yjfkFqPvuLwU6aakRpw1BvbuQ8JSAAiSAJPUZTMDLX6V5y/CkM7QZAKm2f6SHSKDf8Vz59+Nh+bnQMfYYE/3sNApjoLSZi1bo7FhebEvGKQF1X6dtfpxcWsSoC7KGz6jwSHhniKcAkoTClCLcMRrvBB9Ug1cyxDMv/vruQaXMiwsoKkhTxMw4OYwE=" forKey:@"onedriveToken"];
    [[NSUserDefaults standardUserDefaults]setObject:@"3ydFc4zVO4AAAAAAAAAABkzEqshhVNQv-C2LQu1Zx4mF4SVLq5rsiAzvvoxVbvju" forKey:@"dropboxToken"];
    */
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
    [[DBSession sharedSession] linkFromController:self];
}

- (void)sendBtnPressed: (UIButton*) sender {
    NSLog(@"sendBtnPressed");
    // build json
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"onedriveToken"] forKey:@"onedriveToken"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"dropboxToken"] forKey:@"dropboxToken"];
    [dict setObject:@"dropbox" forKey:@"fromDrive"];
    [dict setObject:@"onedrive" forKey:@"toDrive"];
    [dict setObject:@"/" forKey:@"fromPath"];
    [dict setObject:@"/" forKey:@"toPath"];
    NSData* postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    // request
    //NSString *post = @"key1=val1&key2=val2";
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://sushaoxiang.cloudapp.net:5050"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
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
            [[NSUserDefaults standardUserDefaults]setObject: self.liveClient.session.accessToken forKey:@"onedriveToken"];
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
