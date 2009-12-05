#import <Cocoa/Cocoa.h>
#import <AppKit/NSSound.h>
#import "Hammertime.h"

@interface Jukebox : NSObject {

}

+ (NSString*) status;
+ (BOOL) skip;
+ (void) pause;
+ (NSSound*) nextPlaylistEntry;
+ (Hammertime*) nextHammertime;
+ (NSString*) get: (NSString*) element;
+ (NSString*) post: (NSString*) element;
+ (NSString*) request: (NSString*) element withMethod: (NSString*) method;
@end
