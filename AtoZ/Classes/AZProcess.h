
/* AZProcess.h Copyright (c) 2002 Aram Greenman. All rights reserved.
  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
  3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.
  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAZES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAZE.
*/


/// @constant AZProcessValueUnknown Indicates that the value of a statistic couldn't be determined.
enum {
	AZProcessValueUnknown = UINT_MAX
};
/*!
@discussion Possible return values for -[AZProcess state].
@constant AZProcessStateUnknown         The state couldn't be determined.
@constant AZProcessStateRunnable        The process is runnable.
@constant AZProcessStateUninterruptible The process is in disk or other uninterruptible wait.
@constant AZProcessStateSleeping        The process has been sleeping for 20 seconds or less.
@constant AZProcessStateIdle            The process has been sleeping for more than 20 seconds.
@constant AZProcessStateSuspended       The process is suspended.
@constant AZProcessStateZombie          The process has exited but the parent has not yet waited for it.
@constant AZProcessStateExited          The process has exited.
*/
JREnumDeclare(AZProcessState, 	AZProcessStateUnknown,					AZProcessStateRunnable,
                                AZProcessStateUninterruptible,	AZProcessStateSleeping,
                                AZProcessStateIdle,             AZProcessStateSuspended,
                                AZProcessStateZombie,           AZProcessStateExited)

/*!
@abstract A class for reporting Unix process statistics.
@discussion AZProcess is a class for reporting Unix process statistics. It is similar to NSProcessInfo except that it provides more information, and can represent any process, not just the current process. Additionally it provides methods for sending signals to processes. 
Instances are created with -initWithProcessIdentifier: or +processForProcessIdentifier:, but several convenience methods exist for obtaining instances based on other information, the most useful being +currentProcess, +allProcesses, and +userProcess.
The level of information an AZProcess can return depends on the user's permission. In general, a user can obtain general information like the arguments or process ID for any process, but can only obtain CPU and memory usage statistics for their own processes, unless they are root. Also, no information is available after the process has exited except the process ID and the state (AZProcessStateZombie or AZProcessStateExited). Methods which return a numerical value will return AZProcessValueUnknown if the statistic can't be obtained. 
*/
@interface AZProcess : NSObject <ClassKeyGet>

+ (NSS*)pathOfProcessWithIdentifier:(int)pid;

/// Initializes the receiver with the given process identifier. Returns nil if no such process exists.
- initWithProcessIdentifier:(int)pid;

/// Returns the current process.
+ (INST) currentProcess;

/// An array of all processes.
+ (NSA*) allProcesses;

/// An array of all processes running for the current user.
+ (NSA*) userProcesses;

/// The process for the given process identifier, or nil if no such process exists.
+ (INST) processForProcessIdentifier:(int)pid;

/// An array of all processes in the given process group.
+ (NSA*) processesForProcessGroup:(int)pgid;

/// An array of all processes running on the given terminal. Takes a terminal device number.
+ (NSA*) processesForTerminal:(int)tdev;

/// An array of all processes for the given user.
+ (NSA*) processesForUser:(int)uid;

/// An array of all processes for the given real user.
+ (NSA*) processesForRealUser:(int)ruid;

/*! The process for the given command, or nil if no such process exists.
    @note If there is more than one process with the same command, there is no guarantee which will be returned.
 */
+ (INST) processForCommand:(NSString*)comm;

/// An array of all processes for the given command.
+ (NSA*) processesForCommand:(NSString *)comm;

/// An array of all processes for the given command. 
+ (NSA*) processesForCommandInsensitive:(NSString*)comm;

/// The process identifier.
@prop_RO int processIdentifier;

/// The parent process identifier.
@prop_RO  int parentProcessIdentifier;

/// he process group.
@prop_RO int processGroup;

/// The terminal device number.
@prop_RO int terminal;

/// the terminal process group.
@prop_RO int terminalProcessGroup;

/// The user identifier.
@prop_RO int userIdentifier;

/// The real user identifier.
@prop_RO int realUserIdentifier;

/// The current CPU usage in the range 0.0 - 1.0.
@prop_RO double percentCPUUsage;

/// The accumulated CPU time in seconds.
@prop_RO double totalCPUTime;

/// The accumulated user CPU time in seconds.
@prop_RO double userCPUTime;

/// The accumulated system CPU time in seconds.
@prop_RO double systemCPUTime;

/// Tresident memory usage as a fraction of the host's physical memory in the range 0.0 - 1.0.
@prop_RO double percentMemoryUsage;

/// The virtual memory size in bytes.
@prop_RO unsigned virtualMemorySize;

/// The resident memory size in bytes.
@prop_RO unsigned residentMemorySize;

/// The current state. Possible values are defined by AZProcessState.
@prop_RO AZProcessState state;

/// The current priority.
@prop_RO int priority;

/// The base priority.
@prop_RO int basePriority;

/// The number of threads.
@prop_RO int threadCount;

/*! Attempts to return the command that was called to execute the process. 
    @note If that fails, attempts to return the accounting name. If that fails, returns an empty string. 
 */
@prop_RO NSS * command;

@prop_RO NSS * path;

/*! An annotation that can be used to distinguish multiple instances of a process name.
    @note The current implementation does this by examining the command line arguments for "DashboardClient" and "java" processes. If there is no annotation, the method returns nil. 
 */
@prop_RO NSS * annotation;

/// Returns a composite string consisting of the command name and its annotation
@prop_RO NSS * annotatedCommand;

/// An array containing the command line arguments called to execute the process. This method is not perfectly reliable.
@prop_RO NSA * arguments;

/// Dictionary containing the environment variables of the process. This method is not perfectly reliable.
@prop_RO NSD * environment;

/// The parent process.
- (INST) parent;

/// An array containing the process's children, if any.
@prop_RO NSA * children;

/// An array containing the process's siblings, if any.
@prop_RO NSA* siblings;

+ process:(NSString*) property;

@end

/// @category AZProcess (Signals) @abstract Extends AZProcess to send UNIX signals.
@interface AZProcess (Signals)

/// Sends SIGSTOP.
@property (readonly) BOOL suspend;

/// Sends SIGCONT.
@property (readonly) BOOL resume;

/// Sends SIGINT.
@property (readonly) BOOL interrupt;

/// Sends SIGTERM.
@property (readonly) BOOL terminate;

/// Sends the given kill signal, see man 3 signal for possible values. Returns NO if the signal couldn't be sent.
- (BOOL) kill:(int)signal;

/// Sends the given signal, see man 3 signal for possible values. Returns NO if the signal couldn't be sent.
+ (BOOL) killAllProcessesForCommand:(NSString*)comm insensitive:(BOOL)insensitive;

@end

/// @abstract Extends AZProcess to get information about Mach task events.

@interface AZProcess (MachTaskEvents)

/// The number of page faults.
@prop_RO int faults;

/// The number of pageins.
@prop_RO int pageins;

/// The number of copy on write faults.
@prop_RO int copyOnWriteFaults;

/// The number of Mach messages sent.
@prop_RO int messagesSent;

/// The number of Mach messages received.
@prop_RO int messagesReceived;

/// The number of Mach system calls.
@prop_RO int machSystemCalls;

/// The number of Unix system calls.
@prop_RO int unixSystemCalls;

/// The number of context switches.
@prop_RO int contextSwitches;

@end
