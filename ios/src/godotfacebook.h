#ifndef __GODOTFACEBOOK_H__
#define __GODOTFACEBOOK_H__

#include "core/reference.h"

class GodotFacebook: public Reference{

    GDCLASS(GodotFacebook, Reference);

    bool initialized;
    int callbackId;

    GodotFacebook *instance;

protected:
    static void _bind_methods();

public:

    void init(const String &fbAppId);
    void login();
    void logout();
    void setFacebookCallbackId(int instanceId);
    int  getFacebookCallbackId();
    void isLoggedIn();
    void shareLink(const String &url, const String &quote);
    void shareLinkWithoutQuote(const String &url);
    void sendEvent(const String &eventName);
    void sendEventWithParams(const String &eventName, const Dictionary& key_values);
    void sendContentViewEvent();
    void sendAchieveLevelEvent(const String &level);

    GodotFacebook();
    ~GodotFacebook();
};

#endif
