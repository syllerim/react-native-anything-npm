#import "AnythingNpm.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOSAlertMessage : NSObject
-(void) showMessage:(NSString*) msg;
-(void) showMessage:(NSString*) msg duration:(double) duration;
@end

NS_ASSUME_NONNULL_END

@implementation IOSAlertMessage

static double const DEFAULT_TOAST_DURATION = 3.5;

-(void) showMessage:(NSString*) msg
{
    [self showMessage:msg duration:DEFAULT_TOAST_DURATION];
}

-(void) showMessage:(NSString*) msg duration:(double) duration
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIViewController* rootVC = [[UIViewController alloc] init];
    if (rootVC == nil || window == nil)
    {
        return;
    }
    
    window.backgroundColor = [UIColor clearColor];
    window.rootViewController = rootVC;
    [window makeKeyAndVisible];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    
    [rootVC presentViewController:alert animated:YES completion:nil];
    
    [self closeMessage:window alert:alert duration:duration];
}

- (void) closeMessage:(UIWindow*) window alert:(UIAlertController*) alert duration:(double) duration
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
        [window removeFromSuperview];
    });
}

@end

@interface AnythingNpm()
    @property (nonatomic, retain) IOSAlertMessage *toast;
@end

@implementation AnythingNpm

- (instancetype)init {
    self = [super init];
    if (self) {
        self.toast = [[IOSAlertMessage alloc] init];
    }
    return self;
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(show:(NSString *)text) {
    [self.toast showMessage:text];
}

@end
