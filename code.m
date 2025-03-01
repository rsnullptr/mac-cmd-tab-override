#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

#define SCRIPT_PATH "open -g 'raycast://extensions/raycast/navigation/switch-windows'"

CGEventRef eventTapCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if (type != kCGEventKeyDown) return event;
    
    CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    CGEventFlags flags = CGEventGetFlags(event);
    
    if ((flags & kCGEventFlagMaskCommand) && (keycode == 48)) {
        const char *scriptPath = getenv("SCRIPT_PATH");
        if (!scriptPath) {
            scriptPath = SCRIPT_PATH;
        }
        
        system(scriptPath);
        return NULL;
    }
    
    return event;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CGEventMask eventMask = CGEventMaskBit(kCGEventKeyDown);
        CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap,
                                                  kCGHeadInsertEventTap,
                                                  kCGEventTapOptionDefault,
                                                  eventMask,
                                                  eventTapCallback,
                                                  NULL);
        if (!eventTap) {
            fprintf(stderr, "Error: Unable to create event tap. (Are you running with accessibility privileges?)\n");
            exit(1);
        }
        
        CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        
    
        CGEventTapEnable(eventTap, true);
        CFRunLoopRun();
        CFRelease(eventTap);
        CFRelease(runLoopSource);
    }
    return 0;
}
