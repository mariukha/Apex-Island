import SwiftUI

struct IslandView: View {
    @StateObject var media = MediaManager()
    @State private var isHovered = false
    @State private var isExpanded = false
    @State private var volume: Double = 0.5

    let notchWidth: CGFloat = 185
    let expandedWidth: CGFloat = 260
    let notchHeight: CGFloat = 30
    let expandedHeight: CGFloat = 160

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                ZStack(alignment: .top) {
                    VisualEffectView(material: .hudWindow, blendingMode: .withinWindow)
                    Color.black.opacity(0.95)
                }
                .frame(width: isExpanded ? expandedWidth : (media.isPlaying ? 215 : notchWidth))
                .frame(height: isExpanded ? expandedHeight : notchHeight + 10)
                .offset(y: -5)
                .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 24, bottomTrailingRadius: 24))
                .shadow(color: .black.opacity(0.5), radius: isExpanded ? 20 : 5, y: isExpanded ? 10 : 2)

                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "music.note")
                            .foregroundColor(.pink)
                            .font(.system(size: 13, weight: .bold))
                            .frame(width: 30)
                        
                        Spacer()
                        
                        if !isExpanded && media.isPlaying {
                            Text(media.currentTrack)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        musicWaveAnimation.frame(width: 30)
                    }
                    .frame(height: notchHeight)
                    .padding(.horizontal, 15)

                    if isExpanded {
                        VStack(spacing: 15) {
                            VStack(spacing: 2) {
                                Text(media.currentTrack)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                Text(media.currentArtist)
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 5)

                            HStack(spacing: 25) {
                                Button(action: { media.previousTrack() }) {
                                    Image(systemName: "backward.fill")
                                }
                                .buttonStyle(.plain)

                                Button(action: { media.togglePlayPause() }) {
                                    Image(systemName: media.isPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: 20))
                                }
                                .buttonStyle(.plain)

                                Button(action: { media.nextTrack() }) {
                                    Image(systemName: "forward.fill")
                                }
                                .buttonStyle(.plain)
                            }
                            .foregroundColor(.white)

                            HStack {
                                Image(systemName: "speaker.fill").font(.system(size: 10))
                                
                                Slider(value: Binding(
                                    get: { self.volume },
                                    set: { newValue in
                                        self.volume = newValue
                                        media.setSystemVolume(to: newValue)
                                    }
                                ), in: 0...1)
                                .accentColor(.white)
                                
                                Image(systemName: "speaker.wave.3.fill").font(.system(size: 10))
                            }
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .frame(width: isExpanded ? expandedWidth : (media.isPlaying ? 215 : notchWidth))
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                isExpanded.toggle()
            }
        }
        .onHover { h in
            if !h && isExpanded { withAnimation { isExpanded = false } }
        }
    }
    
    private var musicWaveAnimation: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.pink)
                    .frame(width: 2, height: media.isPlaying ? CGFloat.random(in: 8...14) : 4)
                    .animation(.easeInOut(duration: 0.5).repeatForever().delay(Double(i) * 0.1), value: media.isPlaying)
            }
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
