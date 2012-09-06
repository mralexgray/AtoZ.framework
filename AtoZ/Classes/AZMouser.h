
#import "AtoZ.h"


/* pathForArc : Adds an arc (a segment of an oval) fitting inside a rectangle to the path.

context : The CG context to render to.
r : The CG rectangle that defines the arc's boundary..
startAngle : The angle indicating the start of the arc.
arcAngle : The angle indicating the arcÕs extent.
*/


void pathForArc(CGContextRef context, CGRect r, int startAngle, int arcAngle);
void typeString(char *str);
void keyHit(CGKeyCode kc, CGEventFlags flags);
void keyPress(CGKeyCode kc, CGEventFlags flags);
void keyRelease(CGKeyCode kc, CGEventFlags flags);
void toKey(CGKeyCode kc, CGEventFlags flags, bool upOrDown);

// iGetKey crap
typedef struct {
	short kchrID;
	Str255 KCHRname;
	short transtable[256];
} Ascii2KeyCodeTable;

enum {
	kTableCountOffset = 256+2,
	kFirstTableOffset = 256+4,
	kTableSize = 128
};
/*
//static OSStatus InitAscii2KeyCodeTable(Ascii2KeyCodeTable* ttable);
//static short AsciiToKeyCode(Ascii2KeyCodeTable* ttable, short asciiCode);
//static char KeyCodeToAscii(short virtualKeyCode);
*/
void processCommand(const char *cmd);

//void print_msg(const char *msg);
CGPoint mouseLoc();
void warpTo ( CGPoint dest );
void moveVia( int x, int y );
void moveTo ( CGPoint dest );
void dragTo ( CGPoint dest );
//
//
//void mouseUp(    int btn, int clickType);
//void mouseDow(   int btn, int clickType);
//void mouseUpDown(int btn, int clickType);

CGEventType getMouseButton(int btn, int btnState);
void mouseEvent(int btn, int btnState, int clickType);

//void mouseMove(int posX, int posY);
//void mouseMoveTo(int posX, int posY, float speed);
//void mousePress(int btn, int clickType);
//void mouseRelease(int btn, int clickType);
//void mouseClick(int btn, int clickType);
//void mouseDrag(int btn, int posX, int posY);

//CGPoint AZMousePoint();

typedef enum {
	AZDockOrientLeft,
	AZDockOrientBottom,
	AZDockOrientRight,
} 	AZDockOrientation;

#define MOUSE_SPEED 	 4000 	// bigger = slower
#define MOUSE_RESOLUTION  2.5 	//how much to move the cursor each interval

#define NO_MOUSE_BUTTON 0
#define LEFT_MOUSE 		 1
#define RIGHT_MOUSE 	  2

#define MOUSE_DOWN 	  0
#define MOUSE_UP	   1
#define MOUSE_DRAGGED 	2
#define MOUSE_MOVED 	 2

#define SINGLE_CLICK  1
#define DOUBLE_CLICK   2
#define TRIPLE_CLICK 	3

@interface  AZMouser : BaseModel


@property (assign, nonatomic) AZDockOrientation orientation;
@property (assign, nonatomic) NSSize screenSize;
@property (assign, nonatomic) BOOL debug;
//+ (AZMouser*)sharedInstance;

- (void) moveTo: (CGPoint) point;
- (CGPoint) mouseLocation;
- (void) dragFrom:(CGPoint)a to:(CGPoint)b;
@end


//@implementation AUWindowExtend :NSWindow
//@end


