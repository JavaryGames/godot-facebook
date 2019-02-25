#include "register_types.h"
#include "object_type_db.h"
#include "core/globals.h"
#include "ios/src/godotfacebook.h"

void register_facebook_types(){
    Globals::get_singleton()->add_singleton(Globals::Singleton("GodotFacebook", memnew(GodotFacebook)));
}

void unregister_facebook_types(){
}
