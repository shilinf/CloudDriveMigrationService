//
//  ViewController.h
//  CloudDriveMigrationServiceIOSClient
//
//  Created by Bochun Zhang on 7/27/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LiveSDK/LiveConnectClient.h>
#import <DropboxSDK/DropboxSDK.h>

@interface ViewController : UIViewController<LiveAuthDelegate, LiveOperationDelegate,
LiveDownloadOperationDelegate, LiveUploadOperationDelegate>
@property (strong, nonatomic) LiveConnectClient *liveClient;
@property (strong, nonatomic) UILabel *infoLabel;


@end

