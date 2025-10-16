# ee/iop-toolchain
for tool in addr2line ar as cpp c++ gcc g++ ld nm gcov gcov-dump gcov-tool objcopy objdump ranlib readelf strip strings; do
    bash -c "rm -f /usr/bin/ee-$tool"
    bash -c "rm -f /usr/bin/iop-$tool"

    bash -c "cat > /usr/bin/ee-$tool << 'EOF'
#!/usr/bin/env bash
MSYSTEM=MINGW32 exec /c/msys64/usr/bin/bash.exe --login -c \"$PS2DEV/ee/bin/mips64r5900el-ps2-elf-$tool \$*\"
EOF"

    bash -c "cat > /usr/bin/iop-$tool << 'EOF'
#!/usr/bin/env bash
MSYSTEM=MINGW32 exec /c/msys64/usr/bin/bash.exe --login -c \"$PS2DEV/iop/bin/mipsel-none-elf-$tool \$*\"
EOF"
    
    bash -c "chmod +x /usr/bin/ee-$tool"
    bash -c "chmod +x /usr/bin/iop-$tool"
done

# dvp-toolchain
for tool in addr2line as ar nm elfedit objcopy objdump ranlib readelf size strip strings; do
    bash -c "rm -f /usr/bin/dvp-$tool"
    
    bash -c "cat > /usr/bin/dvp-$tool << 'EOF'
#!/usr/bin/env bash
MSYSTEM=MINGW32 exec /c/msys64/usr/bin/bash.exe --login -c \"$PS2DEV/dvp/bin/dvp-$tool \$*\"
EOF"

    bash -c "chmod +x /usr/bin/dvp-$tool"
done

# pcsx2-qt
bash -c "rm -f /usr/bin/pcsx2-qt"
bash -c "cat > /usr/bin/pcsx2-qt << 'EOF'
#!/usr/bin/env bash
exec '/c/Program Files/PCSX2/pcsx2-qt.exe' \$*
EOF"
bash -c "chmod +x /usr/bin/pcsx2-qt"
