def can_build(plat):
	return plat=="android"

def configure(env):
	if (env['platform'] == 'android'):
		env.android_add_dependency("compile 'com.facebook.android:facebook-android-sdk:4.27.0'")
		env.android_add_to_manifest("android/AndroidManifestChunk.xml")
		env.android_add_java_dir("android/src/")
		env.android_add_default_config("minSdkVersion 15")
		env.android_add_default_config("targetSdkVersion 24")
		env.android_add_default_config("compileSdkVersion 24")
		env.disable_module()

