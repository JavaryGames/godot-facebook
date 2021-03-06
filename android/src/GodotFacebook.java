package org.godotengine.godot;

import android.app.Activity;
import android.os.Bundle;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.FacebookSdkNotInitializedException;
import com.facebook.LoginStatusCallback;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.widget.AppInviteDialog;
import com.facebook.share.model.AppInviteContent;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.appevents.AppEventsConstants;

public class GodotFacebook extends Godot.SingletonBase {

    private Godot activity = null;
    private Integer facebookCallbackId = 0;
    private CallbackManager callbackManager;
    private ShareDialog shareDialog;
    private AppEventsLogger logger;

    static public Godot.SingletonBase initialize(Activity p_activity) {
        return new GodotFacebook(p_activity);
    }

    public GodotFacebook(Activity p_activity) {
        registerClass("GodotFacebook", new String[]{"init", "setFacebookCallbackId",
         "getFacebookCallbackId", "login", "logout", "isLoggedIn", "shareLink",
         "shareLinkWithoutQuote", "sendEvent", "sendEventWithParams", "sendContentViewEvent", "sendAchieveLevelEvent"});
        activity = (Godot)p_activity;
        callbackManager = CallbackManager.Factory.create();
        shareDialog = new ShareDialog(p_activity);
        logger = AppEventsLogger.newLogger(p_activity);

        LoginManager.getInstance().registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
                @Override
                public void onSuccess(LoginResult loginResult) {
                    AccessToken at = loginResult.getAccessToken();
                    GodotLib.calldeferred(facebookCallbackId, "login_success", new Object[]{at.getToken()});
                }

                @Override
                public void onCancel() {
                    GodotLib.calldeferred(facebookCallbackId, "login_cancelled", new Object[]{});
                }

                @Override
                public void onError(FacebookException exception) {
                    GodotLib.calldeferred(facebookCallbackId, "login_failed", new Object[]{exception.toString()});
                }
            });

        // Share Dialog callbacks

        shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                GodotLib.calldeferred(facebookCallbackId, "login_success", new Object[]{result.getPostId()});
            }

            @Override
            public void onCancel() {
                GodotLib.calldeferred(facebookCallbackId, "share_cancelled", new Object[]{});
            }

            @Override
            public void onError(FacebookException error) {
                GodotLib.calldeferred(facebookCallbackId, "share_failed", new Object[]{error.toString()});
            }
        });

    }

    // Public methods

    public void init(final String key){
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    FacebookSdk.setApplicationId(key);
                    FacebookSdk.sdkInitialize(activity.getApplicationContext());
                } catch (FacebookSdkNotInitializedException e) {
                    Log.e("godot", "Failed to initialize FacebookSdk: " + e.getMessage());
                } catch (Exception e) {
                    Log.e("godot", "Exception: " + e.getMessage());
                }
            }
        });
    }

    public void sendEvent(final String eventName) {
        logger.logEvent(eventName);
    }

    public void sendEventWithParams(final String eventName, final Dictionary keyValues) {
		// Generate bundle out of keyValues
		Bundle params = new Bundle();
		if (!keyValues.isEmpty()){
			GodotFacebook.putAllInDict(params, keyValues);
		}
		logger.logEvent(eventName, params);
	}

    public void sendContentViewEvent() {
        logger.logEvent(AppEventsConstants.EVENT_NAME_VIEWED_CONTENT);
    }

    public void sendAchieveLevelEvent(String level) {
        Bundle params = new Bundle();
        // Using string here because facebook docs say so
        params.putString(AppEventsConstants.EVENT_PARAM_LEVEL, level);
        logger.logEvent(AppEventsConstants.EVENT_NAME_ACHIEVED_LEVEL, params);
    }

    public void setFacebookCallbackId(int facebookCallbackId) {
        this.facebookCallbackId = facebookCallbackId;
    }

    public int getFacebookCallbackId() {
		return facebookCallbackId;
	}

    public void login() {
        Log.i("godot", "Facebook login");
        AccessToken accessToken = AccessToken.getCurrentAccessToken();
        if(accessToken != null && !accessToken.isExpired()) {
            GodotLib.calldeferred(facebookCallbackId, "login_success", new Object[]{accessToken.getToken()});
        } else {
            LoginManager.getInstance().logInWithPublishPermissions(activity, null);
        }
    }

    public void logout() {
        Log.i("godot", "Facebook logout");
        LoginManager.getInstance().logOut();
    }

    public void isLoggedIn() {
        Log.i("godot", "Facebook isLoggedIn");
        AccessToken accessToken = AccessToken.getCurrentAccessToken();
        if(accessToken == null) {
            GodotLib.calldeferred(facebookCallbackId, "login_failed", new Object[]{"No token"});
        } else if(accessToken.isExpired()) {
            GodotLib.calldeferred(facebookCallbackId, "login_failed", new Object[]{"No expired"});
        } else {
            GodotLib.calldeferred(facebookCallbackId, "login_success", new Object[]{accessToken.getToken()});
        }
    }

    public void shareLinkWithoutQuote(final String link){
        Log.i("godot", "Facebook shareLink");
        if (ShareDialog.canShow(ShareLinkContent.class)) {
        	ShareLinkContent linkContent = new ShareLinkContent.Builder()
        		.setContentUrl(Uri.parse(link))
        		.build();
        	shareDialog.show(linkContent);
        }
    }

    public void shareLink(final String link, final String quote){
        Log.i("godot", "Facebook shareLink");
        if (ShareDialog.canShow(ShareLinkContent.class)) {
        	ShareLinkContent linkContent = new ShareLinkContent.Builder()
        		.setContentUrl(Uri.parse(link))
                .setQuote(quote)
        		.build();
        	shareDialog.show(linkContent);
        }
    }

    // Internal methods

    public void callbackSuccess(String ticket, String signature, String sku) {
		//GodotLib.callobject(facebookCallbackId, "purchase_success", new Object[]{ticket, signature, sku});
        //GodotLib.calldeferred(purchaseCallbackId, "consume_fail", new Object[]{});
	}

    @Override protected void onMainActivityResult (int requestCode, int resultCode, Intent data){
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    public static void putAllInDict(Bundle bundle, Dictionary keyValues) {
        String[] keys = keyValues.get_keys();
        for (int i = 0; i < keys.length; i++) {
            String key = keys[i];
            GodotFacebook.putGodotValue(bundle, key, keyValues.get(key));
        }
    }

    public static void putGodotValue(Bundle bundle, String key, Object value) {

        if (value instanceof Boolean) {
            bundle.putBoolean(key, (Boolean) value);

        } else if (value instanceof Integer) {
            bundle.putInt(key, (Integer) value);

        } else if (value instanceof Double) {
            bundle.putDouble(key, (Double) value);

        } else if (value instanceof String) {
            bundle.putString(key, (String) value);

        } else {

            if (value != null) {
                bundle.putString(key, value.toString());
            }

        }
    }

}
