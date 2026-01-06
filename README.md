# Apex Island 🏝️

**Apex Island** brings the "Dynamic Island" experience to macOS. It transforms the area around your MacBook's notch (or the top of your screen) into a smart, interactive hub for media control, system status, and notifications.

Designed to be cleaner, faster, and more integrated than other alternatives like Alcove, Apex Island feels like a native part of macOS.

## ✨ Features

*   **Smart Media Controls:** Automatically detects playing music from Spotify, Apple Music, and more.
    *   **Pro Control:** Expand the island to access a full media center with Play/Pause, Next/Previous track buttons, and a volume slider.
    *   **Live Updates:** Shows track name, artist, and playback status in real-time.
    *   **Native Integration:** Uses private `MediaRemote` APIs for reliable control without scripting delays.
*   **Context Awareness:** intelligently changes its icon and color based on your active application (Coding, Design, Terminal, Browsing).
*   **Rubber-Like Animation:** Smooth, physics-based animations that feel incredibly satisfying.
*   **Notifications:** Receive lightweight notifications directly in the island via a built-in webhook server.
*   **System Monitoring:** (Coming Soon) Keep an eye on battery life and other vitals.
*   **Notch Integration:** Perfectly aligns with the MacBook notch for a seamless look, or sits elegantly at the top of the screen on other displays.

## 🚀 Installation & Usage

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/Apex-Island.git
    ```
2.  **Open in Xcode:**
    Double-click `Apex Island.xcodeproj`.
3.  **Build and Run:**
    Press `Cmd + R` to build and run the application.

**Note:** Upon first launch, you may need to grant accessibility permissions for media controls to function correctly.

## 🛠️ How it Works

*   **SwiftUI:** The entire UI is built with SwiftUI for modern, responsive performance.
*   **MediaRemote:** Leverages macOS internal frameworks to control media reliably across all apps.
*   **NSPanel:** Uses a custom floating window level (`.screenSaver`) to stay above all other windows, including full-screen apps.

## 🤝 Contributing

Contributions are welcome! Whether it's bug fixes, new features, or design tweaks, feel free to open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
