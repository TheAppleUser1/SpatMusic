import SwiftUI
import MusicKit

struct NowPlayingView: View {
    @Environment(MusicPlayer.self) private var player
    @State private var nowPlayingItem: Song?
    @State private var queue: MusicPlayer.Queue?

    var body: some View {
        VStack {
            if let song = nowPlayingItem {
                VStack {
                    Text(song.title)
                        .font(.title)
                    Text(song.artistName)
                        .font(.headline)
                }
                .padding()
            }
            if let queue = queue {
                List(queue.entries, id: \._entryID) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.item.title)
                        Text(entry.item.artistName)
                            .font(.subheadline)
                    }
                }
            } else {
                Text("Queue empty")
            }
        }
        .onAppear(perform: updatePlayerInfo)
        .navigationTitle("Now Playing")
    }

    func updatePlayerInfo() {
        nowPlayingItem = player.nowPlayingItem as? Song
        queue = player.queue
    }
}
