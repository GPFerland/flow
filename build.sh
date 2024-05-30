#!/bin/bash
# Install dependencies
flutter pub get

# Build Flutter web app with tree shaking disabled
flutter build web --release --no-tree-shake-icons
