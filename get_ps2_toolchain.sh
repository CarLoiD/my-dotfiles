rm -rf .tmp/

mkdir -p .tmp/
cd .tmp/

echo "Downloading ps2dev toolchain..."
wget -q --show-progress https://github.com/ps2dev/ps2dev/releases/download/latest/ps2dev-ubuntu-latest.tar.gz

echo "Deleting existent toolchain..."
rm -rf /usr/local/ps2dev

echo "Extracting and copying contents..."
tar -xvzf ps2dev-ubuntu-latest.tar.gz -C /usr/local/

echo "Cleaning up..."
rm -f /usr/local/ps2dev/test.tmp
rm -rf /usr/local/ps2dev/gsKit

cd ../
rm -rf .tmp/
