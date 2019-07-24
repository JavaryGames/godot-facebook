#include "godotfacebook.h"
#import "app_delegate.h"

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKAppEvents.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Bolts/Bolts.h>


GodotFacebook::GodotFacebook() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;
    initialized = false;
    callbackId = 0;
}

GodotFacebook::~GodotFacebook() {
    instance = NULL;
}


void GodotFacebook::init(const String &fbAppId){
    NSLog(@"GodotFacebook Module initialized");
    NSDictionary *launchOptions = @{};
    [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication]
    didFinishLaunchingWithOptions:launchOptions];
    initialized = true;
}

void GodotFacebook::login(){
    NSLog(@"GodotFacebook Module login");
    if ([FBSDKAccessToken currentAccessTokenIsActive]){
        FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
        Object *obj = ObjectDB::get_instance(callbackId);
        Array params = Array();
        params.push_back(accessToken.tokenString);
        obj->call_deferred(String("login_success"), params);
    }else{
        [[[FBSDKLoginManager alloc] init] logInWithPublishPermissions: @[]
        fromViewController: [AppDelegate getViewController]
        handler: ^ (FBSDKLoginManagerLoginResult *result, NSError *error){
            Object *obj = ObjectDB::get_instance(callbackId);
            Array params = Array();
            if (error != nil){
                params.push_back(error.localizedDescription);
                obj->call_deferred(String("login_failed"), params);
            }else if (result.isCancelled){
                obj->call_deferred(String("login_cancelled"));
            }else{
                FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
                params.push_back(accessToken.tokenString);
                obj->call_deferred(String("login_success"), params);
            }
        }];
    }

}

void GodotFacebook::logout(){
    NSLog(@"GodotFacebook Module logout");
}

void GodotFacebook::setFacebookCallbackId(int cbackId){
    NSLog(@"GodotFacebook Module set callback id");
    callbackId = cbackId;
}

int GodotFacebook::getFacebookCallbackId(){
    NSLog(@"GodotFacebook Module get callback id");
    return callbackId;
}

bool GodotFacebook::isLoggedIn(){
    NSLog(@"GodotFacebook Module is logged in");
    return false;
}

void GodotFacebook::shareLink(const String &url, const String &quote){
    NSLog(@"GodotFacebook Module share link content");
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.quote = [NSString stringWithCString:quote.utf8().get_data() encoding: NSUTF8StringEncoding];
    content.contentURL = [NSURL URLWithString:[NSString stringWithCString:url.utf8().get_data() encoding: NSUTF8StringEncoding]];
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
    shareDialog.fromViewController = [AppDelegate getViewController];
    shareDialog.shareContent = content;
    [shareDialog show];
}

void GodotFacebook::shareLinkWithoutQuote(const String &url){
    NSLog(@"GodotFacebook Module share link without quote");
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://www.facebook.com/FacebookDevelopers"];
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
    shareDialog.fromViewController = [AppDelegate getViewController];
    shareDialog.shareContent = content;
    [shareDialog show];
}

void GodotFacebook::sendEvent(const String &eventName) {
    [FBSDKAppEvents logEvent:[NSString stringWithCString:eventName.utf8().get_data() encoding: NSUTF8StringEncoding]];
}

void GodotFacebook::sendContentViewEvent(){
    [FBSDKAppEvents logEvent: FBSDKAppEventNameViewedContent];
}

void GodotFacebook::sendAchieveLevelEvent(const String &level){
    NSDictionary *params = @{ FBSDKAppEventParameterNameLevel : [NSString stringWithCString:level.utf8().get_data() encoding: NSUTF8StringEncoding] };
    [FBSDKAppEvents logEvent:FBSDKAppEventNameAchievedLevel parameters:params];
}


void GodotFacebook::_bind_methods() {
    ClassDB::bind_method("init",&GodotFacebook::init);
    ClassDB::bind_method("login",&GodotFacebook::login);
    ClassDB::bind_method("logout",&GodotFacebook::logout);
    ClassDB::bind_method("setFacebookCallbackId",&GodotFacebook::setFacebookCallbackId);
    ClassDB::bind_method("getFacebookCallbackId",&GodotFacebook::getFacebookCallbackId);
    ClassDB::bind_method("isLoggedIn",&GodotFacebook::isLoggedIn);
    ClassDB::bind_method("shareLink",&GodotFacebook::shareLink);
    ClassDB::bind_method("shareLinkWithoutQuote",&GodotFacebook::shareLinkWithoutQuote);
    ClassDB::bind_method("sendEvent", &GodotFacebook::sendEvent);
    ClassDB::bind_method("sendContentViewEvent", &GodotFacebook::sendContentViewEvent);
    ClassDB::bind_method("sendAchieveLevelEvent", &GodotFacebook::sendAchieveLevelEvent);
}
