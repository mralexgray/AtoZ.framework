

@import AtoZUniversal;

@interface             WebSocketView : NSObject
@property (NATOM)         NSUInteger       port;
+  (instancetype) onPort:(NSUInteger)p baseHTML:(NSString*)html;
@end


