import Foundation
import AppKit
import Combine

class MediaManager: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTrack: String = "No Media"
    @Published var currentArtist: String = ""
    @Published var artwork: NSImage? = nil
    
    typealias MRMediaRemoteSendCommandFunction = @convention(c) (Int32, CFDictionary?) -> Bool
    private var sendCommandFunction: MRMediaRemoteSendCommandFunction?

    init() {
        loadMediaRemote()
        setupNotifications()
    }
    
    private func loadMediaRemote() {
        let path = "/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote"
        
        if let handle = dlopen(path, RTLD_NOW) {
            if let sym = dlsym(handle, "MRMediaRemoteSendCommand") {
                sendCommandFunction = unsafeBitCast(sym, to: MRMediaRemoteSendCommandFunction.self)
                print("✅ MediaRemote loaded successfully")
            } else {
                print("❌ Symbol MRMediaRemoteSendCommand not found")
            }
        } else {
            if let error = dlerror() {
                let errorString = String(cString: error)
                print("❌ Failed to load library: \(errorString)")
            } else {
                 print("❌ Failed to load library: Unknown error")
            }
        }
    }

    func togglePlayPause() { sendCommand(2) } // 2 = Play/Pause
    func nextTrack() { sendCommand(4) }        // 4 = Next
    func previousTrack() { sendCommand(5) }    // 5 = Previous

    private func sendCommand(_ id: Int32) {
        guard let function = sendCommandFunction else {
            print("❌ Control function unavailable")
            return
        }
        _ = function(id, nil)
    }

    func setSystemVolume(to value: Double) {
        let script = "set volume output volume \(Int(value * 100))"
        NSAppleScript(source: script)?.executeAndReturnError(nil)
    }
    
    private func setupNotifications() {
        let center = DistributedNotificationCenter.default()
        center.addObserver(forName: NSNotification.Name("com.apple.Music.playerInfo"), object: nil, queue: .main) { [weak self] n in
            self?.updateInfo(n)
        }
        center.addObserver(forName: NSNotification.Name("com.spotify.client.PlaybackStateChanged"), object: nil, queue: .main) { [weak self] n in
            self?.updateInfo(n)
        }
    }
    
    private func updateInfo(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        DispatchQueue.main.async {
            self.isPlaying = (userInfo["Player State"] as? String == "Playing")
            self.currentTrack = userInfo["Name"] as? String ?? "Unknown"
            self.currentArtist = userInfo["Artist"] as? String ?? ""
            self.artwork = NSImage(systemSymbolName: "music.note", accessibilityDescription: nil)
        }
    }
}
