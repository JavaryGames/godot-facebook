# Facebook module for [Godot Game Engine](http://godotengine.org/) (Android only)(iOS coming soon). 

Highlights of this fork:

+ Tested on Godot 2.1.4 
+ Added ShareDialog methods
+ No need to change build.gradle.template anymore

## How to use it (Android)

1. Clone the repo
2. Copy the `facebook` folder to `godot/modules/` of your clone of [Godot-source](https://github.com/godotengine/godot). 
3. Edit `/facebook/android/AndroidManifestChunk.xml` and change ´fb123456789123456´ with your Facebook App Id
4. Compile the Godot Android template [like you'll normally would](http://docs.godotengine.org/en/latest/reference/compiling_for_android.html)
5. You'll find your APK in `godot/bin` then [you must reference them on your Godot project](http://docs.godotengine.org/en/latest/development/compiling/compiling_for_android.html#using-the-export-templates)
6. Be sure to edit your `engine.cfg` and add this line:
```
[android]

modules="org/godotengine/godot/GodotFacebook"
```
In case you are using more than one module just separate them with a comma, here's an example:
```
[android]

modules="org/godotengine/godot/GodotAdMob,org/godotengine/godot/GodotFacebook"
```
## Using the API

This fork Added 1 extra function to call the ShareDialog API of Facebook SDK, you use that function as follows:

```python
# Init like this
# Declare an Identifier
var fb = null

# Somewhere else init it like this func _ready(): would be a good place to do it
if(Globals.has_singleton("GodotFacebook")):
	fb = Globals.get_singleton("GodotFacebook")
	fb.init("FACEBOOK_APP_ID") 

# Then to use the shareLink Api you call it like this:

if fb != null:
	fb.shareLink("https://godotengine.org", "I love Godot!!")

```
The other APIs work as described on the original Readme(check it out below).

## Things to know

This module changes `minSdkVersion` to 15, `compileSdkVersion`to 24 and `targetSdkVersion` to 24. The Facebook SDK version is fixed due to some issues with the newest version of everything not playing along well for some reason, once Godot 3.0 stable is released I'm going to try with the newest tools.

If you want to change some of those values for wathever reason you might have you can just edit them in `/GodotFacebook/config.py` and compile again.

Be sure to change the Facebook Id or you'll get an error related to `Duplicated Provider Authority` when installing other Godot game with the same Facebook Id.


Original README:
---

To use it, make sure you're able to compile the Godot android template, you can find the instructions [here](http://docs.godotengine.org/en/latest/reference/compiling_for_android.html). As the latest Facebook SDK needs Android SDK 15+, edit the file godot/platform/android/build.gradle.template and set minSdkVersion to 15. After that, just copy the the GodotFacebook folder to godot/modules and recompile it.


**Module name (engine.cfg):**
```
[android]
modules="org/godotengine/godot/GodotFacebook"
```

**Functions:**
* init(app_id)
* appInvite(app_link_url, preview_image_url)
* setFacebookCallbackId(get_instance_ID())
* getFacebookCallbackId()
* login()
* logout()
* isLoggedIn()
* sendEvent(eventName)

**Callback functions:**
* login_success(token)
* login_cancelled()
* login_failed(error)

**Example:**
```python
func _ready():
    if(Globals.has_singleton("GodotFacebook")):
        fb = Globals.get_singleton("GodotFacebook")
        fb.init(‘YOUR_APP_ID’)
        fb.setFacebookCallbackId(get_instance_ID())

func login_success(token):
    print('Facebook login success: %s'%token)

func login_cancelled():
    print('Facebook login cancelled')

func login_failed(error):
    print('Facebook login failed: %s'%error)

(...)

func _on_share_button_pressed():
    if fb != null:
        fb.appInvite(“YOUR_APP_URL”, ‘YOUR_APP_IMG_URL’)

func _on_login_button_pressed():
    if fb != null:
        fb.login()
```        

