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
@property (strong, nonatomic) NSMutableArray *grid;

@end

bool playMetronome = false;
NSThread* metronome;
uint64_t interval = ((1000 * 1000 * 1000) / 2) / 4; //16th notes at 120 bpm
uint64_t intervalMax = (1000 * 1000 * 1000) / 4;
int numDrums = 2;
int numSteps = 16;

@implementation VoxBBViewController

- (NSMutableArray *)grid
{
    if (!_grid) {
        _grid = [[NSMutableArray alloc] init];
        
        for (int drum = 0; drum < numDrums; drum++) {
            _grid[drum] = [[NSMutableArray alloc] initWithCapacity:numDrums];
            for (int step = 0; step < numSteps; step++)
                _grid[drum][step] = @NO;
        }
        
        _grid[0][0] = _grid[0][8]  = @YES;
        _grid[1][4] = _grid[1][12] = @YES;
    }
    return _grid;
}

- (void)addTrack:(NSString*)filename
{
	// Make the audio tracks auto-preload so that they start as fast
	// as possible when the button is pressed, even after stopping
	// playback.
	OALAudioTrack* track = [OALAudioTrack track];
	[track preloadFile:filename];
    
	track.autoPreload = YES;
	
	track.numberOfLoops = 0;
    
	[_audioTrackFiles addObject:filename];
	[_audioTracks addObject:track];
}

- (IBAction)startMachine:(UIButton *)sender
{
    _audioTracks = [NSMutableArray arrayWithCapacity:10];
    _audioTrackFiles = [NSMutableArray arrayWithCapacity:10];
    
    // You could do all mp3 or any other format supported by iOS software decoding.
    // Any format requiring the hardware will only work on the first track that starts playing.
    
    if (!playMetronome)
    {
        [sender setTitle:@"Stop Machine" forState:UIControlStateNormal];
        playMetronome = true;
        metronome = [[NSThread alloc] initWithTarget:self
                                            selector:@selector(runMetronome)
                                              object:nil];
        [metronome start];
    }
    else
    {
        [sender setTitle:@"Start Machine" forState:UIControlStateNormal];
        playMetronome = false;
        [metronome cancel];
    }
    
}

- (void) runMetronome {
    [self addTrack:@"Kick707_2.mp3"];
    [self addTrack:@"Snare707_2.mp3"];
    
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    uint64_t currentTime = mach_absolute_time();
    
    currentTime *= info.numer;
    currentTime /= info.denom;
    
    uint64_t nextTime = currentTime + interval;
    int step = 0;
    while (playMetronome) {
        if (currentTime >= nextTime) {
            
            for (int drum = 0; drum < numDrums; drum++) {
                if ([self.grid[drum][step] isEqual: @YES]) {
                    [(OALAudioTrack*)self.audioTracks[drum] play];
                }
            }
            
            nextTime += interval;
            step++;
            if (step == numSteps) step = 0;
        }
        
        currentTime = mach_absolute_time();
        currentTime *= info.numer;
        currentTime /= info.denom;
    }
}

- (IBAction)sliderValueChanged:(id)sender {
    if (sender == _slider) {
        interval = intervalMax - _slider.value;
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
    
    _slider.maximumValue = interval*1.80;
    _slider.value = interval;
    _slider.minimumValue = interval/2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
