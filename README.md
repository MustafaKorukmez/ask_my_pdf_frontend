# Ask My PDF - AI-Powered PDF Chat Application

Ask My PDF is a modern Flutter web application that enables intelligent conversations with your PDF documents. Leveraging advanced AI technology, it analyzes PDF content and provides contextual responses to your queries.

## 🚀 Key Features

- 📁 Advanced PDF Processing
  - Drag-and-drop functionality
  - Multi-file upload support
  - Automated format validation
  - Real-time processing status
  
- 💬 Intelligent Document Interaction
  - Natural Language Processing (NLP)
  - Context-aware responses
  - Persistent chat history
  - Multi-threaded conversations
  
- 🎨 Enterprise-Grade UI/UX
  - Material Design 3 implementation
  - Responsive cross-platform design
  - Dark/Light theme support
  - Accessibility features
  
- 🌐 Web-First Architecture
  - Cross-browser compatibility
  - Progressive Web App (PWA) support
  - Mobile-optimized interface
  - Offline capabilities
  
- 🔍 Advanced Content Analysis
  - OCR technology integration
  - Metadata extraction & indexing
  - Smart content summarization
  - Keyword highlighting
  
- ⚡ Performance Optimization
  - Intelligent caching system
  - Optimized API communication
  - Lazy loading implementation
  - Request throttling

## 🛠️ Technical Stack

- **Frontend Architecture**
  - Flutter Web 3.x
  - Dart 3.x
  - Material Design 3
  - Provider (State Management)
  - GetIt (Dependency Injection)
  
- **API Integration**
  - RESTful architecture
  - HTTP/HTTPS protocols
  - JSON serialization
  - Multipart form handling
  
- **Core Dependencies**
  ```yaml
  file_picker: ^5.0.0
  provider: ^6.0.0
  http: ^1.0.0
  shared_preferences: ^2.0.0
  get_it: ^7.0.0
  ```

## 📋 Prerequisites

- Flutter SDK (≥3.5.0)
- Dart SDK (≥3.0.0)
- Git
- Modern web browser (Chrome recommended)
- IDE (VS Code or Android Studio recommended)

## 🔧 Installation & Setup

1. Install Flutter SDK:
```bash
# Download and install Flutter SDK
https://flutter.dev/docs/get-started/install

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

2. Clone the repository:
```bash
# Clone the repository
git clone https://github.com/MustafaKorukmez/ask_my_pdf_frontend.git

# Navigate to project directory
cd ask_my_pdf_frontend
```

3. Install dependencies:
```bash
# Install pub dependencies
flutter pub get
```

4. Launch the application:
```bash
# Run in debug mode
flutter run -d chrome

# Run in release mode
flutter run -d chrome --release
```

## 🔨 Development Guide

### Project Structure
```
lib/
├── core/           # Core components & utilities
├── features/       # Feature modules
├── config/         # Configuration files
└── main.dart       # Application entry point
```

### CORS Configuration
To prevent CORS issues during development:
```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

### API Configuration
Configure API endpoints in `lib/core/constants/api_constants.dart`:
```dart
class ApiConstants {
  static const String baseUrl = 'YOUR_API_URL';
  static const String uploadEndpoint = '/upload-pdf/';
  static const String chatEndpoint = '/chat-with-pdf/';
}
```

### Development Standards
- Utilize Dart Analysis
- Maintain consistent code formatting
- Include comprehensive documentation
- Implement unit tests
- Follow SOLID principles

### Build & Test
```bash
# Run analysis
flutter analyze

# Execute tests
flutter test

# Build for web
flutter build web
```


## 📧 Contact

Project Lead - [Mustafa Korukmez](https://github.com/MustafaKorukmez)
- Email: [korukmezm@gmail.com](mailto:korukmezm@gmail.com)
- LinkedIn: [Mustafa Korukmez](https://www.linkedin.com/in/mustafakorukmez/)
- GitHub: [@MustafaKorukmez](https://github.com/MustafaKorukmez)

Project Repository: [GitHub](https://github.com/MustafaKorukmez/ask_my_pdf_frontend)

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) team
- All contributors
- Open-source package maintainers

