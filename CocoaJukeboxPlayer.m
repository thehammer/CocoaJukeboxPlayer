#import <Foundation/Foundation.h>
#import <AppKit/NSSound.h>
#import "Jukebox.h"
#import "Hammertime.h"

NSString* status = @"";
NSSound* currentTrack = nil;
Hammertime* hammertime = nil;

BOOL playing() {
	return [status isEqual: @"play"];
}

BOOL play(id track) {
	if (track == nil)
		return false;
	
	return ([track play] || [track resume]);
}

BOOL pausePlaying(id track) {
	if (track == nil)
		return false;
	
	return [track pause];
}

BOOL handleStateChange() {
	NSString* jukeboxStatus = [Jukebox status];
	if ([jukeboxStatus isEqual: status])
		return false;

	status = jukeboxStatus;
	
	if (playing()) {
		play(hammertime) || play(currentTrack);
	} else {
		pausePlaying(hammertime);
		pausePlaying(currentTrack);
	}
	
	return true;
}

BOOL stopHammertime() {
	if (hammertime == nil || ![hammertime finished])
		return false;
	
	if ([hammertime pauseAfter])
		[Jukebox pause];
		
	[hammertime stop];
	NSMakeCollectable(hammertime);
	[hammertime release];
	hammertime = nil;
	
	return play(currentTrack);
}

BOOL playHammertime() {
	if (!playing())
		return false;
	
	if (hammertime != nil && [hammertime isPlaying])
		return true;
	
	hammertime = [Jukebox nextHammertime];
	
	if (hammertime == nil)
		return false;
	
	pausePlaying(currentTrack);
	play(hammertime);
	
	return true;
}

BOOL handleHammertime() {
	return (stopHammertime() || playHammertime());
}

BOOL skipCurrentTrack() {
	if (currentTrack == nil || ![currentTrack isPlaying] || ![Jukebox skip])
		return false;
	
	[currentTrack stop];
	NSMakeCollectable(currentTrack);
	[currentTrack release];
	currentTrack = nil;
	
	return true;
}

BOOL playJukeboxTrack() {
	if (!playing())
		return false;
	
	if (currentTrack != nil && [currentTrack isPlaying])
		return true;
	
	currentTrack = [Jukebox nextPlaylistEntry];

	return play(currentTrack);
}

BOOL handlePlaylist() {
	return (skipCurrentTrack() || playJukeboxTrack());
}

BOOL rest() {
	sleep(1);
	return true;
}

int	playFromJukebox() {
	while (true) {
		handleStateChange() || handleHammertime() || handlePlaylist() || rest();
	}
	
	return 0;
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	int rc = playFromJukebox();
	[pool drain];

    return rc;
}