

@interface Observers : NSObject {

@private
    NSMutableArray* observers;

}

- (void) addObserver: (id)observer;
- (void) removeObserver: (id)observer;

@end


@protocol Observable <NSObject>

- (void) addObserver:(id)observer;
- (void) removeObserver:(id)observer;
@property Observers * observers;





@interface ObservableProtocol : NSObjec

@end
