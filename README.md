# AutToolkit

**AutToolkit** is a comprehensive Flutter app (developed primarily for Android devices) designed to support individuals with autism, as well as their parents, caregivers, and educators. It provides tools for tracking habits, creating visual sequences, and using augmentative and alternative communication (AAC) boards, making daily routines more structured and accessible. While primarily aimed at parents and children with autism, the app is also fully functional for adults using it independently.

---
## How to run

### 1. Download the official release
The official release of the application is available to download on [Google Play](https://play.google.com/store/apps/details?id=sk.krib.aut_toolkit&pcampaignid=web_share)

### 2. Run locally
To run the application locally, clone the repository and open the project through Android Studio. A local copy of .env file is needed for the Firebase integration (keys needed: FIREBASE_API_KEY, FIREBASE_APP_ID, FIREBASE_MESSAGING_SENDER_ID, FIREBASE_PROJECT_ID). You have to provide your own keys if you want to run the application by yourself. You also have to edit the [firebase.json](firebase.json) file, and change the appId and configurations for your Firebase project. To run the application within the Android Studio, simply run a virtual device and start the application. To generate an .apk file, use the top ribbon and Build->Flutter->Build APK.


## Features

### 1. Habit Tracking
- **Eating Habits:** Track meals, snacks, and dietary patterns.
- **Challenging Behaviors:** Monitor occurrences and patterns of challenging behaviors by tracking their frequency.
- **Good Habits:** Track positive behaviors and routines.
- **Export to PDF:** All tracked habits, behaviors, and summaries can be exported as PDF reports for documentation or sharing with caregivers and professionals.

### 2. AAC Board
- Supports communication for children and adults.
- Optionally uses a **modified Fitzgerald Key** layout for structured sentence building.
- Cards are customizable with personal images or ARASAAC symbols.
- Multi-language support with Slovak and Czech translations.
- **Export to PDF:** The AAC board setup can also be exported as a PDF for printing or offline use.

### 2. Visual Sequence Board
- **Create Visual Sequences:** Build step-by-step visual guides for tasks, routines, or activities.
- **Show Sequences:** Display sequences on connected devices for easy guidance.
- **Cross-Device Functionality:** Parents can prompt the child's phone to open a visual sequence board.
- **Export to PDF:** Visual sequences can also be exported as PDF for printing or offline use.

### 3. Card Management
- **Existing Cards:** Browse and organize cards easily.
- **Create New Cards:** Add custom cards by:
    - browsing personal images
    - in-app search that implements the ARASAAC API, providing the user with more than 10 000 additional symbols
- **AAC Board Integration:** Cards can be used for communication within the app's AAC system.

### 4. Cloud Sync
- **Multi-Device Access:** Users can access their data on multiple devices.
- **Firebase Firestore Integration:** All habits, behaviours, visual sequences, and AAC boards are synchronised securely in the cloud.
- **Offline Support:** Data is stored locally and synced automatically when the device reconnects to the internet.
---
## Contributing

We welcome contributions from developers, designers, and users to enhance AutToolkit.

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request

Please ensure all new features maintain accessibility and usability for neurodiverse users, and are thoroughly tested in real-life scenarios.

---

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

---

## Contact

- **Project Maintainer:** Jakub Krištof
- **Email:** kristof.jacobb@gmail.com
- **GitHub:** https://github.com/gingerbraden/aut-toolkit

