#ifndef __GODOTFACEBOOK_H__
#define __GODOTFACEBOOK_H__

#include "reference.h"

class GodotFacebook: public Reference{

    OBJ_TYPE(GodotFacebook, Reference);

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
    bool isLoggedIn();
    void shareLink(const String &url, const String &quote);
    void shareLinkWithoutQuote(const String &url);

    GodotFacebook();
    ~GodotFacebook();
};

#endif
