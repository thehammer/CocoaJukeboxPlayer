#import <AppKit/NSSound.h>
#import "Hammertime.h"

@implementation Hammertime

@synthesize startTime;
@synthesize endTime;
@synthesize pauseAfter;

- (id) initWithFile: (NSString*) file StartTime: (NSTimeInterval) start endTime: (NSTimeInterval) end pauseAfter: (BOOL) pause {
	self = [super initWithContentsOfFile:file byReference:YES];
	if (self != nil) {
		startTime = start;
		endTime = end;
		pauseAfter = pause;
		[self setCurrentTime: startTime];
	}

	return self;
}

- (BOOL) finished {
	if ([self currentTime] >= endTime) {
		return true;
	}
	
	return false;
}
@end
