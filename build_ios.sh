scons p=iphone -j4 target=release tools=no arch=arm64 bits=64 IPHONESDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS11.2.sdk"
scons p=iphone -j4 target=release tools=no arch=arm bits=32 IPHONESDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS11.2.sdk"
lipo -create bin/godot.iphone.opt.arm bin/godot.iphone.opt.arm64 -output bin/godot_opt.iphone

