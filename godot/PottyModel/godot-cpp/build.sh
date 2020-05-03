#!/bin/sh

docker run -ti -v $(pwd):/home/user/godot --rm crazychenz/godot_builder /bin/bash -c "scons platform=windows generate_bindings=yes use_mingw=yes -j8"


#"cd godot ; ./debugpotty.sh"



#"cd godot ; x86_64-w64-mingw32-g++ -o bin/libpotty_model.windows.tools.64.so -static -shared core/os/mutex.windows.tools.64.o core/string_name.windows.tools.64.o core/reference.windows.tools.64.o core/object.windows.tools.64.o core/os/memory.windows.tools.64.o core/array.windows.tools.64.o core/variant.windows.tools.64.o core/error_macros.windows.tools.64.o core/ustring.windows.tools.64.o core/crypto/crypto_core.windows.tools.64.o thirdparty/mbedtls/library/sha1.windows.tools.64.o core/dictionary.windows.tools.64.o thirdparty/mbedtls/library/md5.windows.tools.64.o thirdparty/mbedtls/library/sha256.windows.tools.64.o thirdparty/mbedtls/library/aes.windows.tools.64.o thirdparty/mbedtls/library/aesni.windows.tools.64.o thirdparty/mbedtls/library/platform_util.windows.tools.64.o"



#"core/libcore.windows.tools.64.a modules/potty_model/register_types.os modules/potty_model/PottyModel.os platform/libplatform.windows.tools.64.a drivers/libdrivers.windows.tools.64.a editor/libeditor.windows.tools.64.a scene/libscene.windows.tools.64.a servers/libservers.windows.tools.64.a -lmingw32 -lopengl32 -ldsound -lole32 -ld3d9 -lwinmm -lgdi32 -liphlpapi -lshlwapi -lwsock32 -lws2_32 -lkernel32 -loleaut32 -ldinput8 -ldxguid -lksuser -limm32 -lbcrypt -lavrt -luuid -ldwmapi"
#"scons -C godot -j8 platform=windows potty_model_shared=yes dev=yes bin/libpotty_model.windows.tools.64.so"
#bin/libpotty_model.windows.tools.64.dll
