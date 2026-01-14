# pcsx2-qt
bash -c "rm -f /usr/bin/pcsx2-qt"
bash -c "cat > /usr/bin/pcsx2-qt << 'EOF'
#!/usr/bin/env bash
exec '/mnt/c/Program Files/PCSX2/pcsx2-qt.exe' \$*
EOF"
bash -c "chmod +x /usr/bin/pcsx2-qt"
