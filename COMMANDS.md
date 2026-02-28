# 🚀 CityCare - Command Reference

## 📦 Installation & Setup

### Install Dependencies
```bash
flutter pub get
```

### Check Flutter Setup
```bash
flutter doctor
```

### Clean Build (if needed)
```bash
flutter clean
flutter pub get
```

## 🏃 Running the Application

### Development Mode
```bash
# Run on Chrome
flutter run -d chrome

# Run with hot reload
flutter run -d chrome --hot

# Run on specific port
flutter run -d chrome --web-port=8080
```

### Debug Mode
```bash
# Run with verbose logging
flutter run -d chrome -v

# Run with debug info
flutter run -d chrome --debug
```

## 🔨 Building

### Development Build
```bash
flutter build web
```

### Production Build
```bash
flutter build web --release
```

### Build with Optimizations
```bash
flutter build web --release --web-renderer html
```

## 🔥 Firebase Commands

### Login to Firebase
```bash
firebase login
```

### Initialize Firebase
```bash
firebase init
```

### Deploy Everything
```bash
firebase deploy
```

### Deploy Specific Services
```bash
# Deploy hosting only
firebase deploy --only hosting

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage:rules

# Deploy multiple
firebase deploy --only hosting,firestore:rules
```

### Test Locally
```bash
firebase serve
```

### View Logs
```bash
firebase functions:log
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Run Specific Test
```bash
flutter test test/widget_test.dart
```

### Test with Coverage
```bash
flutter test --coverage
```

## 🔍 Analysis & Formatting

### Analyze Code
```bash
flutter analyze
```

### Format Code
```bash
flutter format .
```

### Format Specific File
```bash
flutter format lib/main.dart
```

## 📱 Device Management

### List Devices
```bash
flutter devices
```

### List Emulators
```bash
flutter emulators
```

### Launch Emulator
```bash
flutter emulators --launch chrome
```

## 🐛 Debugging

### Enable DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### Run with DevTools
```bash
flutter run -d chrome --devtools
```

### Clear Cache
```bash
flutter clean
flutter pub cache repair
```

## 📊 Performance

### Build with Profile Mode
```bash
flutter build web --profile
```

### Analyze Bundle Size
```bash
flutter build web --analyze-size
```

## 🔧 Troubleshooting Commands

### Fix Pub Issues
```bash
flutter pub cache clean
flutter pub get
```

### Fix Build Issues
```bash
flutter clean
rm -rf build/
flutter pub get
flutter build web
```

### Reset Flutter
```bash
flutter clean
flutter pub cache repair
flutter doctor
```

### Update Flutter
```bash
flutter upgrade
```

### Update Dependencies
```bash
flutter pub upgrade
```

## 🌐 Web-Specific Commands

### Run on Different Browser
```bash
# Chrome
flutter run -d chrome

# Edge
flutter run -d edge

# Web Server
flutter run -d web-server
```

### Build with Web Renderer
```bash
# HTML renderer (better compatibility)
flutter build web --web-renderer html

# CanvasKit renderer (better performance)
flutter build web --web-renderer canvaskit

# Auto (default)
flutter build web --web-renderer auto
```

## 📦 Package Management

### Add Package
```bash
flutter pub add package_name
```

### Remove Package
```bash
flutter pub remove package_name
```

### Update Package
```bash
flutter pub upgrade package_name
```

### List Outdated Packages
```bash
flutter pub outdated
```

## 🔐 Firebase Security

### Test Firestore Rules
```bash
firebase emulators:start --only firestore
```

### Validate Rules
```bash
firebase deploy --only firestore:rules --dry-run
```

## 📝 Git Commands (Bonus)

### Initialize Git
```bash
git init
git add .
git commit -m "Initial commit: CityCare app"
```

### Push to GitHub
```bash
git remote add origin <your-repo-url>
git branch -M main
git push -u origin main
```

## 🎯 Quick Workflows

### Fresh Start
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Build & Deploy
```bash
flutter build web --release
firebase deploy --only hosting
```

### Update & Test
```bash
flutter pub upgrade
flutter analyze
flutter test
flutter run -d chrome
```

### Production Release
```bash
flutter clean
flutter pub get
flutter test
flutter analyze
flutter build web --release
firebase deploy
```

## 🆘 Emergency Commands

### App Won't Run
```bash
flutter clean
flutter pub cache clean
flutter pub get
flutter doctor
flutter run -d chrome
```

### Firebase Issues
```bash
firebase logout
firebase login
firebase use --add
firebase deploy
```

### Build Errors
```bash
rm -rf build/
flutter clean
flutter pub get
flutter build web --release
```

## 📱 Useful Shortcuts

### In Running App
- `r` - Hot reload
- `R` - Hot restart
- `h` - Help
- `q` - Quit
- `d` - Detach
- `c` - Clear screen
- `v` - Open DevTools

## 🎓 Learning Commands

### Get Help
```bash
flutter help
flutter help run
flutter help build
```

### Check Version
```bash
flutter --version
firebase --version
```

### View Config
```bash
flutter config
firebase projects:list
```

## 🔗 Useful URLs

### Local Development
```
http://localhost:5000  (default Flutter web)
http://localhost:8080  (custom port)
```

### Firebase Console
```
https://console.firebase.google.com/
```

### Deployed App
```
https://citizen-issue-system-web.web.app
https://citizen-issue-system-web.firebaseapp.com
```

---

## 💡 Pro Tips

1. **Always run `flutter pub get` after changing pubspec.yaml**
2. **Use `flutter clean` when facing weird build issues**
3. **Run `flutter analyze` before committing code**
4. **Test on multiple browsers before deploying**
5. **Keep Firebase CLI updated: `npm update -g firebase-tools`**
6. **Use `--release` flag for production builds**
7. **Check `flutter doctor` regularly**
8. **Clear browser cache when testing**

---

## 🎯 Most Used Commands

```bash
# Development
flutter pub get
flutter run -d chrome

# Production
flutter build web --release
firebase deploy --only hosting

# Troubleshooting
flutter clean
flutter doctor
```

---

**Keep this file handy during development! 📌**
