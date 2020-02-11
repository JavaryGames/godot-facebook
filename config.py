def can_build(plat):
    return plat=="android" or plat=="iphone"

def configure(env):
    if (env['platform'] == 'android'):
        env.disable_module()	
        return
        env.android_add_dependency("implementation 'com.facebook.android:facebook-android-sdk:4.39.0'")
        env.android_add_to_manifest("android/AndroidManifestChunk.xml")
        env.android_add_java_dir("android/src/")
        
    if env['platform'] == "iphone":
        env.Append(FRAMEWORKPATH=['ios/lib'])
        env.Append(LINKFLAGS=['-ObjC', '-framework', 'FBSDKCoreKit', '-framework', 'FBSDKLoginKit', '-framework', 'FBSDKShareKit', '-framework', 'Bolts'])
