import SwiftUI
import AppKit

@main
struct Apex_IslandApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings { EmptyView() }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: FloatingPanel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupIsland()
    }
    
    func setupIsland() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.frame
        
        let windowWidth: CGFloat = 360
        let xOffset: CGFloat = 0
        let panelHeight: CGFloat = 130
        
        let rect = NSRect(
            x: ((screenFrame.width - windowWidth) / 2) + xOffset,
            y: screenFrame.height - panelHeight,
            width: windowWidth,
            height: panelHeight
        )
        
        if panel == nil {
            panel = FloatingPanel(contentRect: rect)
            panel?.contentView = NSHostingView(rootView: IslandView())
            panel?.level = .screenSaver
            panel?.backgroundColor = .clear
        }
        panel?.setFrame(rect, display: true)
        panel?.orderFrontRegardless()
    }
}