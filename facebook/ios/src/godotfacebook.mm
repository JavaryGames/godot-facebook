#include "godotfacebook.h"
#import "app_delegate.h"

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
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
}

void GodotFacebook::login(){
    NSLog(@"GodotFacebook Module login");
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
    return initialized;
}

void GodotFacebook::shareLink(const String &url, const String &quote){
    NSLog(@"GodotFacebook Module share link content");
}

void GodotFacebook::shareLinkWithoutQuote(const String &url){
    NSLog(@"GodotFacebook Module share link without quote");
}



void GodotFacebook::_bind_methods() {
    ObjectTypeDB::bind_method("init",&GodotFacebook::init);
    ObjectTypeDB::bind_method("login",&GodotFacebook::login);
    ObjectTypeDB::bind_method("logout",&GodotFacebook::logout);
    ObjectTypeDB::bind_method("setFacebookCallbackId",&GodotFacebook::setFacebookCallbackId);
    ObjectTypeDB::bind_method("getFacebookCallbackId",&GodotFacebook::getFacebookCallbackId);
    ObjectTypeDB::bind_method("isLoggedIn",&GodotFacebook::isLoggedIn);
    ObjectTypeDB::bind_method("shareLink",&GodotFacebook::shareLink);
    ObjectTypeDB::bind_method("shareLinkWithoutQuote",&GodotFacebook::shareLinkWithoutQuote);
}