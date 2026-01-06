import Foundation
import Network
import Combine

class WebhookServer: ObservableObject {
    @Published var lastMessage: String = "Apex Online"
    private var listener: NWListener?

    init() {
        startServer()
    }

    func startServer() {
        do {
            listener = try NWListener(using: .tcp, on: 8080)
            listener?.newConnectionHandler = { connection in
                connection.start(queue: .main)
                self.receive(on: connection)
            }
            listener?.start(queue: .main)
        } catch {
            print("Server error: \(error)")
        }
    }

    private func receive(on connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, isComplete, _ in
            if let data = data, let message = String(data: data, encoding: .utf8) {
                if let bodyRange = message.range(of: "\r\n\r\n") {
                    let body = String(message[bodyRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
                    if !body.isEmpty {
                        DispatchQueue.main.async {
                            self.lastMessage = body
                        }
                    }
                }
            }
            if isComplete { connection.cancel() }
        }
    }
}