import AppKit
import Combine
import SwiftUI

enum AppContext {
    case coding      // Xcode, VS Code
    case design      // Figma, Photoshop
    case terminal    // Terminal, iTerm
    case music       // Spotify, Music
    case browsing    // Safari, Chrome
    case general     // Others
}

class ContextManager: ObservableObject {
    @Published var currentContext: AppContext = .general
    @Published var activeAppName: String = ""
    var mediaManager = MediaManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(appChanged),
            name: NSWorkspace.didActivateApplicationNotification,
            object: nil
        )
        
        mediaManager.$isPlaying
            .sink { [weak self] isPlaying in
                if isPlaying {
                    DispatchQueue.main.async {
                        self?.currentContext = .music
                    }
                } else {
                    self?.appChanged()
                }
            }
            .store(in: &cancellables)
            
        appChanged()
    }
    
    @objc private func appChanged() {
        if mediaManager.isPlaying {
            DispatchQueue.main.async {
                self.currentContext = .music
            }
            return
        }
        
        guard let app = NSWorkspace.shared.frontmostApplication else { return }
        
        let appName = app.localizedName ?? ""
        let bundleID = app.bundleIdentifier?.lowercased() ?? ""
        
        DispatchQueue.main.async {
            self.activeAppName = appName
            if bundleID.contains("xcode") || bundleID.contains("vscode") {
                self.currentContext = .coding
            } else if bundleID.contains("figma") || bundleID.contains("adobe") {
                self.currentContext = .design
            } else if bundleID.contains("terminal") || bundleID.contains("iterm") {
                self.currentContext = .terminal
            } else if bundleID.contains("spotify") || bundleID.contains("music") {
                self.currentContext = .music
            } else if bundleID.contains("safari") || bundleID.contains("chrome") {
                self.currentContext = .browsing
            } else {
                self.currentContext = .general
            }
        }
    }
}