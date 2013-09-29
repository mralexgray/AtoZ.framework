


typedef NSString AZBlockToken;
typedef void(^AZBlockTask)(id obj, NSD *change);

@interface 						NSObject   (AZBlockObservation)

- (void) removeObserverTokens;

// Dont forget to save returned array of tokens and in Dealloc [self removeObserverTokens] OR
// [tokens do:^(id t) { [observed removeObserverWithBlockToken:t]; }];

//- (AZBlockToken*) observeKeyPath:(NSS*) keyPath task:(AZBlockTask)task;
// Dont forget to save returned token and in Dealloc [self removeObserverTokens] OR
//	[observed removeObserverWithBlockToken:t];

- (AZBlockToken*) observeKeyPath:(NSS*)keyPath 							  task:(AZBlockTask)task;
- (AZBlockToken*) observeKeyPath:(NSS*)keyPath onQueue:(NSOQ*)queue task:(AZBlockTask)task;
-  		  (NSA*) observeKeyPaths:(NSA*)keyPaths 						  task:(AZBlockTask)task;

- 			  (void) removeObserverWithBlockToken:(AZBlockToken *)token;
/* USAGE
	[AZNOTCENTER observeNotificationsUsingBlocks: 
		NSViewFrameDidChangeNotification, ^(NSNOT *m){	
			m.object == self ? [self highlightLineContainingRange:self.selectedRange] : nil; 
		},
		NSTextViewDidChangeSelectionNotification,	^(NSNOT *z) {
			[self addItemToApplicationMenu];
			if (z.object != self) return;
			[self removeHighlightFromLineContainingRange:[z.userInfo[@"NSOldSelectedCharacterRange"] rangeValue]];
			self.selectedRange.length  ? nil : [self highlightLineContainingRange:self.selectedRange]; // not a multi-line selection
		}, nil];
*/
- (void) observeNotificationsUsingBlocks:(NSS*) firstNotificationName, ... NS_REQUIRES_NIL_TERMINATION;
@end
