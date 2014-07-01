//
//  VoxBBViewController.m
//  VoxBB
//
//  Created by David Torre on 6/30/14.
//  Copyright (c) 2014 David Torre. All rights reserved.
//

#import "VoxBBViewController.h"
#import <mach/mach_time.h> // for mach_absolute_time
#import "objectAl.h"

@interface VoxBBViewController ()

@end

@implementation VoxBBViewController

- (void)addTrack:(NSString*)filename
{
	// Make the audio tracks auto-preload so that they start as fast
	// as possible when the button is pressed, even after stopping
	// playback.
	OALAudioTrack* track = [OALAudioTrack track];
	[track preloadFile:filename];
    
	track.autoPreload = YES;
	
	track.numberOfLoops = 0;
    
	[self.audioTrackFiles addObject:filename];
	[self.audioTracks addObject:track];
}

- (IBAction)startMachine:(UIButton *)sender
{
    self.audioTracks = [NSMutableArray arrayWithCapacity:10];
    self.audioTrackFiles = [NSMutableArray arrayWithCapacity:10];
    
    // You could do all mp3 or any other format supported by iOS software decoding.
    // Any format requiring the hardware will only work on the first track that starts playing.
    [self addTrack:@"Kick707_2.mp3"];
    
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    uint64_t currentTime = mach_absolute_time();
    
    currentTime *= info.numer;
    currentTime /= info.denom;
    
    uint64_t interval = (1000 * 1000 * 1000) / 2; //120 bpm
    uint64_t nextTime = currentTime + interval;
    
    OALAudioTrack* track = [self.audioTracks objectAtIndex:0];
    
    while (TRUE) {
        if (currentTime >= nextTime) {
            // Do some work, play the sound files or whatever you like
            NSLog(@"Current time: %lld", currentTime);
            
            [track play];
            
            nextTime += interval;
        }
        
        currentTime = mach_absolute_time();
        currentTime *= info.numer;
        currentTime /= info.denom;
    }
}

- (IBAction)audioRecord:(UIButton *)sender
{
    
}

- (IBAction)audioStop:(UIButton *)sender
{
    
}

- (IBAction)audioPlay:(UIButton *)sender
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
