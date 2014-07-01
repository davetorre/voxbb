//
//  VoxBBViewController.h
//  VoxBB
//
//  Created by David Torre on 6/30/14.
//  Copyright (c) 2014 David Torre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

@interface VoxBBViewController : UIViewController

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (IBAction)audioRecord:(UIButton *)sender;
- (IBAction)audioStop:(UIButton *)sender;
- (IBAction)audioPlay:(UIButton *)sender;

@property (strong, nonatomic) NSMutableArray* audioTracks;
@property (strong, nonatomic) NSMutableArray* audioTrackFiles;

@end
