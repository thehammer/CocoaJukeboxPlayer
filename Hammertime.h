#import <Cocoa/Cocoa.h>


@interface Hammertime : NSSound {
	NSTimeInterval startTime;
	NSTimeInterval endTime;
	BOOL pauseAfter;
}

@property (assign) NSTimeInterval startTime;
@property (assign) NSTimeInterval endTime;
@property (assign) BOOL pauseAfter;

- (id) initWithFile: (NSString*) file StartTime: (NSTimeInterval) start endTime: (NSTimeInterval) end pauseAfter: (BOOL) pause;
- (BOOL) finished;
@end
