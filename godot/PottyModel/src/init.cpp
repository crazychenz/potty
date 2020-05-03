/*
mkdir SimpleLibrary
cd SimpleLibrary
mkdir bin
mkdir src

git submodule add https://github.com/GodotNativeTools/godot-cpp
git submodule update --init --recursive

godot --gdnative-generate-json-api api.json

cd godot-cpp
scons platform=<your platform> generate_bindings=yes
cd ..

# For Android: scons platform=android generate_bindings=yes ANDROID_NDK_ROOT="/PATH-TO-ANDROID-NDK/" android_arch=<arch>

# Linux Build
cd SimpleLibrary
clang -fPIC -o src/init.os -c src/init.cpp -g -O3 -std=c++14 -Igodot-cpp/include -Igodot-cpp/include/core -Igodot-cpp/include/gen -Igodot-cpp/godot_headers
clang -o bin/libtest.so -shared src/init.os -Lgodot-cpp/bin -l<name of the godot-cpp>

# Windows Build
cd SimpleLibrary
cl /Fosrc/init.obj /c src/init.cpp /nologo -EHsc -DNDEBUG /MDd /Igodot-cpp\include /Igodot-cpp\include\core /Igodot-cpp\include\gen /Igodot-cpp\godot_headers
link /nologo /dll /out:bin\libtest.dll /implib:bin\libsimple.lib src\init.obj godot-cpp\bin\<name of the godot-cpp>

# Android Build
cd SimpleLibrary
aarch64-linux-android29-clang -fPIC -o src/init.os -c src/init.cpp -g -O3 -std=c++14 -Igodot-cpp/include -Igodot-cpp/include/core -Igodot-cpp/include/gen -Igodot-cpp/godot_headers
aarch64-linux-android29-clang -o bin/libtest.so -shared src/init.os -Lgodot-cpp/bin -l<name of the godot-cpp>

# iOS Build
Statically build into godot.

# HTML5
Statically build into godot.



*/

#include <Godot.hpp>
#include <Reference.hpp>

#include "PottyModel.hpp"

using namespace godot;

/** GDNative Initialize **/
extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o) {
    godot::Godot::gdnative_init(o);
}

/** GDNative Terminate **/
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o) {
    godot::Godot::gdnative_terminate(o);
}

/** NativeScript Initialize **/
extern "C" void GDN_EXPORT godot_nativescript_init(void *handle) {
    godot::Godot::nativescript_init(handle);

    godot::register_class<PottyModel>();
}
