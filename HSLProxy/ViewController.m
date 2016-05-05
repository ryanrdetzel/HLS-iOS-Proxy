//
//  ViewController.m
//  HSLProxy
//
//  Created by Detzel Family on 5/5/16.
//  Copyright © 2016 Ryan Detzel. All rights reserved.
//

#import "ViewController.h"

@import AVFoundation;
@import AVKit;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)go:(id)sender
{
    // Local url, server or client could replace this.
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/vevo/ch1/appleman.m3u8"];

    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = self.view.frame;
    [self.view.layer addSublayer:layer];
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
