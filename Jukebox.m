#import <AppKit/NSSound.h>
#import "Jukebox.h"
#import "Hammertime.h"

@implementation Jukebox

+ (NSString*) status {
	return [self get: @"status"];
}

+ (BOOL) skip {
	return ([[self get: @"skip_requested"] isEqualToString: @"true"]);
}

+ (void) pause {
	[self post: @"pause"];
}

+ (NSSound*) nextPlaylistEntry {
	NSSound* playlistEntry = [[NSSound alloc] initWithContentsOfFile:[self get: @"next_entry"] byReference:YES];
	NSMakeCollectable(playlistEntry);
	
	return [playlistEntry autorelease];
}

+ (Hammertime*) nextHammertime {
	NSArray* components = [[self get: @"next_hammertime"] componentsSeparatedByString: @"|"];
	
	if ([components count] != 4)
		return nil;
	
	NSString*      file  = [components objectAtIndex:0];
	NSTimeInterval start = (NSTimeInterval) [[components objectAtIndex:1] doubleValue];
	NSTimeInterval end   = (NSTimeInterval) [[components objectAtIndex:2] doubleValue];
	BOOL           pause = [[components objectAtIndex:3] isEqual:@"pause"];

	Hammertime* hammertime = [[Hammertime alloc] initWithFile:file StartTime:start endTime:end pauseAfter:pause];
	NSMakeCollectable(hammertime);
	
	return [hammertime autorelease];
}

+ (NSString*) get: (NSString*) element {
	return [self request:element withMethod:@"GET"];
}

+ (NSString*) post: (NSString*) element {
	return [self request:element withMethod:@"POST"];
}

+ (NSString*) request: (NSString*) element withMethod: (NSString*) method {
	NSString *urlString = [NSString stringWithFormat:@"http://localhost:3000/playlist/%@", element];
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSURLResponse *response;
	NSError *error;
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	[urlRequest setHTTPMethod:method];
	NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

	NSString* responseString = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSMakeCollectable(responseString);
	
	return [responseString autorelease];
}
@end
