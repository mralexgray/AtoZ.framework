//#import "/Library/Frameworks/AtoZ.framework/Headers/BaseModel.h"
//#import "/Library/Frameworks/AtoZ.framework/Headers/AutoCoding.h"



@protocol StdOutDelegate <NSObject>
- (void) stdOutDidOutput:(NSString*)s;
@end

@interface          		 NotifyingOperation : BaseModel	{ NSBlockOperation *_notifyBlock;	}
@property (assign)		id <StdOutDelegate>   stdOutDelegate;
@property (nonatomic) 	   NSBlockOperation * notifyBlock;
@property (readonly) 	  	      NSUInteger   elapsed;
@property (readonly)               NSString * elapsedTime;
@property (strong)	              NSNumber * exitStatus;
@property (strong)                   NSDate * startDate,
									  			        * endDate;
@end

@interface 				  		 NSTaskOperation : NotifyingOperation
@property (nonatomic, copy) 		  NSString * commandOutput;
@property (strong) 				  	  NSString * executable,
														  * launchPath,
														  * args;
@end

@interface          NotifyingOperationQueue : NSOperationQueue <NSUserNotificationCenterDelegate>
//@property 							 NSStatusItem * statusItem;
@property                          NSNumber * lastCommandExitStatus;

- (void) deliverNotificationForCommandCompletion:(NotifyingOperation*)p;
- (void) removeExistingNotifications:				 (NotifyingOperation*)p;
- (void) addProjectWithPath:							             (NSS*)path;
@end

@interface NotifyingOperationQueueStatusView : NSView <StdOutDelegate>
@property                         NSTextView * tv;
@property                      NSOutlineView * ov;
//@property 					 NSProgressIndicator * prog;
@property (weak) 		NotifyingOperationQueue * queue; 
@property (readonly)      NSAttributedString * displayString;
@property (nonatomic)               NSWindow * stdOutWindow;
@property (nonatomic)                NSColor * statusColor;

@end



//NSNumber *_exitStatus;
//NSDate *_startDate, *_endDate;
//NSString * _elapsedTime;
//NSUInteger   _elapsed;
//__unsafe_unretained id<StdOutDelegate> _stdOutDelegate;
//}
