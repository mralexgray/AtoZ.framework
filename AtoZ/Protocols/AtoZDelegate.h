

#import <AtoZ/AtoZ.h>

@protocol AtoZDelegate <NSObject,NSApplicationDelegate>


/*!
 * @method hasNetworkClientEntitlement
 * @abstract Used only in sandboxed situations since we don't know whether the app has com.apple.security.network.client entitlement
 * @discussion GrowlDelegate calls to find out if we have the com.apple.security.network.client entitlement,
 *  since we can't find this out without hitting the sandbox.  We only call it if we detect that the application is sandboxed.
- (BOOL) hasNetworkClientEntitlement;
*/

@concrete
@property (readonly) NSBundle *bundle;
/*!
 *	@method growlIsReady
 *	@abstract Informs the delegate that Growl has launched.
 *	@discussion Informs the delegate that Growl (specifically, the
 *	 GrowlHelperApp) was launched successfully. The application can take actions
 *   with the knowledge that Growl is installed and functional.
 */
- (void) atozIsReady:(AtoZ*)atoz;

@end
