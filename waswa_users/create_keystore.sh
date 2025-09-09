#!/bin/bash

echo "Creating new keystore for JLW Foundation app..."
echo ""

# Create new keystore with default values
keytool -genkey -v \
  -keystore android/app/jlw-foundation-new-key.keystore \
  -alias jlw-foundation-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass jlwfoundation123 \
  -keypass jlwfoundation123 \
  -dname "CN=JLW Foundation, OU=Development, O=JLW Foundation, L=Webuye, S=Western, C=KE"

echo ""
echo "Keystore created successfully!"
echo ""

# Update key.properties file
cat > android/app/key.properties << EOF
storePassword=jlwfoundation123
keyPassword=jlwfoundation123
keyAlias=jlw-foundation-key
storeFile=jlw-foundation-new-key.keystore
EOF

echo "Updated key.properties with new keystore configuration"
echo ""
echo "Keystore details:"
echo "- File: android/app/jlw-foundation-new-key.keystore"
echo "- Alias: jlw-foundation-key"
echo "- Store Password: jlwfoundation123"
echo "- Key Password: jlwfoundation123"
echo ""
echo "You can now build your release APK with: flutter build apk --release"