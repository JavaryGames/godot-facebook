def can_build(plat):
    return plat=="android" or plat=="iphone"

def configure(env):
    if (env['platform'] == 'android'):
        env.android_add_dependency("implementation 'com.facebook.android:facebook-android-sdk:4.39.0'")
        env.android_add_to_manifest("android/AndroidManifestChunk.xml")
        env.android_add_java_dir("android/src/")
        env.disable_module()	
        
    if env['platform'] == "iphone":
        env.Append(FRAMEWORKPATH=['modules/godot_facebook/ios/lib'])
        env.Append(LINKFLAGS=['-ObjC', '-framework', 'FBSDKCoreKit', '-framework', 'FBSDKLoginKit', '-framework', 'FBSDKShareKit', '-framework', 'Bolts'])
