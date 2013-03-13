//
//  PythonOperation.m
//  AtoZ
//
//  Created by Alex Gray on 09/03/2013.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//
/**
	PyTerminalTask* task = [[PyTerminalTask alloc] init];
    setup_tty_param(&term, &win, [screen width], [screen height]);
	_rl_set_screen_size(25, 80);
    int ret = openpty(&shell->FILDES, &task->TTY_SLAVE, ttyname, &term, &win);
	if(ret != 0) {
		fprintf(stderr, "PyTerminal: openpty failed: %s\n", strerror(errno));
		int fildes[2] = {-1,-1};
		ret = socketpair(AF_UNIX, SOCK_STREAM, 0, fildes);
		if(ret != 0) {
			fprintf(stderr, "PyTerminal: socketpair failed: %s\n", strerror(errno));
			return;
		}
		shell->FILDES = fildes[0];
		task->TTY_SLAVE = fildes[1];
	}
	
    int one = 1;
	int sts = ioctl(shell->FILDES, TIOCPKT, &one);
    if(sts < 0)
		fprintf(stderr, "PyTerminal: ioctl TIOCPKT failed: %s\n", strerror(errno));
	
    shell->TTY = [[NSString stringWithUTF8String:ttyname] retain];
    NSParameterAssert(shell->TTY != nil);
	
	// spawn a thread to do the read task
    [NSThread detachNewThreadSelector:@selector(_processReadThread:)
            	             toTarget:[PTYTask class]
						   withObject:shell];
	
	// spawn a thread for Python
    [NSThread detachNewThreadSelector:@selector(_runPython:)
            	             toTarget:self
						   withObject:task];
	
    [aSession release];
}


*/
#import "PythonOperation.h"
#import "AtoZ.h"

static int32_t usedPythonInterpreterNum = 0;

static BOOL _initedPython = NO;
void initPython() {
	if(_initedPython) return;
	if(!Py_IsInitialized()) {
		fprintf(stderr, "Python not initialized, initializing...\n");
		Py_InitializeEx(0);
		PyEval_InitThreads();
		PyEval_ReleaseThread(PyThreadState_Get()); // the main thread doesn't use Python; we would recreate it
	}
	else
		OSAtomicIncrement32(&usedPythonInterpreterNum); // it might be more but that doesn't matter
	_initedPython = YES;
}


@implementation PYRunner
//+ (PYRunner*)sharedInstance	{ static PYRunner *sharedInstance = nil;
//
//	dispatch_once(&sharedInstance.interpreter, ^{
//		sharedInstance = PYRunner.new;
//	});
//	return sharedInstance;
//}

-(id) init
{
	if (self != super.init ) return nil;
	if (!Py_IsInitialized()) {
		static dispatch_once_t once;
		dispatch_once(&once, ^{
			Py_Initialize();
			Py_SetProgramName("/usr/bin/python");
			Py_Initialize();
			PyImport_AddModule("lib");
			PyImport_AddModule("app");
		});
	}
	return self;
}
@end
@interface  PythonOperation ()

// Read/write versions of public properties
//@property (copy,   readwrite) NSString *    imageFilePath;
@property (readwrite, assign) int    exitStatus;
@property (nonatomic, assign) 	PyThreadState* pyThread;
@end

static dispatch_once_t once;

@implementation PythonOperation
@synthesize exitStatus = _exitStatus;
+ (instancetype) inDir:(NSS*)d withPath:(NSS*)p pythonPATH:(NSS*)py optArgs:(NSA*)a;
{
	return [PythonOperation.alloc initInDir:d withPath:p pythonPATH:py optArgs:a];
}

- (id)	 initInDir:(NSS*)d withPath:(NSS*)p pythonPATH:(NSS*)py optArgs:(NSA*)a;
{
//	assert(p) != nil);
	if (self != super.init ) return nil;

	_spriptP 	= p;
	_pyPATH		= py;
	_optArgs 	= a;
	_workingD	= d;
	if (!Py_IsInitialized()) {
		NSLog(@"initializing Python");
		dispatch_once(&once, ^{
			Py_Initialize();
//			Py_SetProgramName("/usr/bin/python");
//			Py_Initialize();
//			PyImport_AddModule("lib");
//			PyImport_AddModule("app");
			NSLog(@"Python ready!");
		});
	}
	return self;
}
	// get the global lock
//	PyEval_AcquireLock();

//// swap in my thread state
//PyThreadState_Swap(myThreadState);
//// execute some python code

//		// get a reference to the PyInterpreterState
//		PyInterpreterState * mainInterpreterState = mainThreadState->interp<\n>;
//	// create a thread state object for this thread
//	PyThreadState * myThreadState = PyThreadState_New(mainInterpreterState);
//	// free the lock
//	PyEval_ReleaseLock();



- (void) start {

	NSLog(@"Operation START: %@.  Python thread %@", NSThread.currentThread, _optArgs);

//	@autoreleasepool {
//
//	[[NSThread currentThread] setName:@"runPython"];

//	FILE* fp_in = fdopen(task->TTY_SLAVE, "r");
//	FILE* fp_out = fdopen(task->TTY_SLAVE, "w");
//	FILE* fp_err = fdopen(task->TTY_SLAVE, "w");
//	setbuf(fp_in,  (char *)NULL);
//	setbuf(fp_out, (char *)NULL);
//	setbuf(fp_err, (char *)NULL);
//	
//	BOOL createdNewInterp = NO;
//	PyThreadState* tstate = NULL;
//	PyInterpreterState* interp = NULL;
//	if(OSAtomicIncrement32(&usedPythonInterpreterNum) == 1) {
//		interp = PyInterpreterState_Head();
//		tstate = PyThreadState_New(interp);
//		PyEval_AcquireThread(tstate);
//	}
//	else {
//		PyEval_AcquireLock();
//		createdNewInterp = YES;
//		tstate = Py_NewInterpreter();
//		interp = tstate->interp;
//	}
//	NSLog(@"Operation START: %@.  Python thread %@", AZPROCINFO, _optArgs);

	
//    PyObject *sysin, *sysout, *syserr;
//	sysin = PyFile_FromFile(fp_in, "<stdin>", "r", NULL);
//    sysout = PyFile_FromFile(fp_out, "<stdout>", "w", _check_and_flush);
//    syserr = PyFile_FromFile(fp_err, "<stderr>", "w", _check_and_flush);
//    NSParameterAssert(!PyErr_Occurred());
//	
//	PySys_SetObject("stdin", sysin);
//	PySys_SetObject("stdout", sysout);
//	PySys_SetObject("stderr", syserr);

//	overwritePyRawInput(interp->builtins);
	dispatch_async(dispatch_get_current_queue(), ^{

//    Py_SetProgramName("/usr/bin/python");
//    Py_Initialize();
//	PySys_SetArgv(argc, (char **)argv);
//	if (_workingD)
//		setenv 				("PYTHONPATH", _workingD.UTF8String, 1);

		NSArray *args = _optArgs ? [@[_spriptP] arrayByAddingObjectsFromArray:_optArgs] : @[_spriptP];
		char **cargs;
		int x = [args createArgv:&cargs];//cArrayFromNSArray(array);	////{ "weather.py", "10011" };
		PySys_SetArgv(args.count,cargs); //argc, (char **)argv);
	//			Py_SetProgramName(cargs[0]);
//		PySys_SetArgv(x, cargs);

//	FILE* file;
	PyObject* PyFileObject = PyFile_FromString((char*)_spriptP.UTF8String, "r");
	PyRun_SimpleFile(PyFile_AsFile(PyFileObject), _spriptP.UTF8String);//lastPathComponent.UTF8String);
});
//		file = fopen(_spriptP.UTF8String,"r");
//		int i = PyRun_SimpleFile(file,(char*)_spriptP.lastPathComponent.UTF8String); // "mypy.py");
//	});
//		self.exitStatus = createdNewInterp;
//	PyRun_SimpleString(
//					   "import sys\n"
//					   "sys.argv = []\n"
//					   "from IPython.Shell import IPShellEmbed,IPShell\n"
//					   "ipshell = IPShell(argv=[])\n"
//					   "ipshell.mainloop()\n"
//					   );

//	
//	}
//	[NSThread exit];


//		dispatch_once(&_once, ^{
//
//		_operationsRunner = [OperationsRunner ]
// _pyThread = Py_NewInterpreter();

//	_pyThread = Py_NewInterpreter();
//	NSLog(@"Operation START: %@.  Python thread %c", AZPROCINFO, _pyThread->interp->modules);

//	[NSThread.mainThread performBlock:^{
//	[AZSOQ addOperationWithBlock:^{
//		if (_workingD)
//		setenv 				("PYTHONPATH", _workingD.UTF8String, 1);
//
//		NSArray *args = _optArgs ? [@[_spriptP] arrayByAddingObjectsFromArray:_optArgs] : @[_spriptP];
//		char **cargs;
//		int x = [args createArgv:&cargs];//cArrayFromNSArray(array);	////{ "weather.py", "10011" };
//		PySys_SetArgv(args.count,cargs); //argc, (char **)argv);
//	//			Py_SetProgramName(cargs[0]);
////		PySys_SetArgv(x, cargs);
//		FILE* file;
//		file = fopen(_spriptP.UTF8String,"r");
//		self.exitStatus = PyRun_SimpleFile(file,(char*)_spriptP.lastPathComponent.UTF8String); // "mypy.py");
//	}];
//	}

}

- (int) exitStatus { return  _exitStatus; }

- (void) setExitStatus:(int)exitStatus {
	_exitStatus = exitStatus;

	PyCompilerFlags cf;
	cf.cf_flags = 0;
	
	// We cannot use PyRun_InteractiveLoopFlags because in Python/Parser/tokenizer.c,
	// there is `PyOS_Readline(stdin, stdout, tok->prompt)` hardcoded, so it ignores our fp_in.
	//PyRun_InteractiveLoopFlags(fp_in, "<stdin>", &cf);
	
	if(_exitStatus) {//createdNewInterp) {
		Py_EndInterpreter(_pyThread);//tstate);
		PyEval_ReleaseLock();
	}
	else
		PyEval_ReleaseThread(_pyThread);//tstate);
	
	OSAtomicDecrement32(&usedPythonInterpreterNum);

//
//	Py_EndInterpreter(_pyThread);
//	Py_Finalize();
}
//		if ( result != 0 )	NSLog(@"%s:%d main() PyRun_SimpleFile failed with file '%@'.  See console for errors.", __FILE__, __LINE__, script);
//			return;
//				pyRunWithArgsInDirPythonPath(_spriptP, _optArgs ?: nil, _workingD ?: nil, _pyPATH ?: nil);
//			NSLog(@"%s:%d main() PyRun_ with file '%@' See console for errors.", __FILE__, __LINE__, _spriptP);
//			return;// success == 0;



/**
    BOOL            success;
	Py_SetProgramName("/usr/bin/python");
    Py_Initialize();
	PyImport_AddModule("lib");
   	PyImport_AddModule("app");
//	char strs[NUMBER_OF_STRINGS][STRING_LENGTH+1] = {"foo", "bar", "bletch", ...};
	NSLog(@"Arguments: %@", _optArgs);
//	if (_optArgs) {
//		char **cargs = cArrayFromNSArray(_optArgs);	////{ "weather.py", "10011" };
//		NSLog(@"command string: %s", cargs);
//		PySys_SetArgv(_optArgs.count,(char **)cargs);//argc, (char **)argv);
//	}
//		const char** args[array.count] =
//		size_t t;
//		strnlen(t,&cargs);
//		cargs[array.count +1] = NULL;

	FILE* file;
	int argc = 1 + _optArgs.count;	//	char * argv[3];

	NSA *aA = (!_optArgs) ? @[ _spriptP.lastPathComponent]
						  : [NSA arrayWithArrays:@[@[_spriptP], _optArgs]];

	char **argv;
	int v = [aA createArgv:&argv];	// ](char*)cArrayFromNSArray(aA);
	for ( int j = 0; j < argc; j++ ) {
		NSLog(@"ARG #%i, %s", j, argv[j]);    //%s", aA, argv);
	}

//    argv[0] = (char*)path.lastPathComponent.UTF8String;
//    argv[1] = "10011";//"-m";
//    argv[2] = "/tmp/targets.list";

//    Py_SetProgramName(argv[0]);
//    Py_Initialize();
    PySys_SetArgv(argc, (char**)argv);

    file = fopen(_spriptP.UTF8String,"r");
    success = PyRun_SimpleFile(file,(char*)_spriptP.lastPathComponent.UTF8String);// "mypy.py");
    Py_Finalize();

//    const char *mainFilePathPtr = [path UTF8String];
//    FILE *mainFile = fopen(mainFilePathPtr, "r");
//	NSLog(@"running simple file... %s", mainFilePathPtr);
//    int result = PyRun_SimpleFile(mainFile, (char *)[[path lastPathComponent] UTF8String]);
//	Py_Finalize();
*/
//    if ( success != 0 )
//		[NSException raise: NSInternalInconsistencyException format:
//			NSLog(@"%s:%d main() PyRun_SimpleFile failed with file '%@'.  See console for errors.", __FILE__, __LINE__, _spriptP);

- (void)stopWithError:(NSError *)error
    // An internal method called to stop the fetch and clean things up.
{
//    assert(error != nil);
//    [self.queue invalidate];
//    [self.queue cancelAllOperations];
//    self.error = error;
//    // When we set done our client's KVO might release us, meaning that we end 
//    // up running with an invalid self.  This can cause all sorts of problems, 
//    // so we do my standard retain/autorelease technique to avoid it.
//    [[self retain] autorelease];
//    self.done = YES;
}
 
- (void)stop
    // See comment in header.
{
    [self stopWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}


@end

