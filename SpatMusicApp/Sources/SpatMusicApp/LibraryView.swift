import SwiftUI
import MusicKit

struct LibraryView: View {
    @State private var musicAuthorization: MusicAuthorization.Status = .notDetermined
    @State private var librarySongs: [Song] = []
    @State private var sortOrder: SortOrder = .title

    enum SortOrder: String, CaseIterable, Identifiable {
        case title, artist, album
        var id: String { rawValue }
        var descriptor: MusicCatalogSearchableAttribute {
            switch self {
            case .title: return .title
            case .artist: return .artistName
            case .album: return .albumTitle
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if librarySongs.isEmpty {
                    Text("No Music")
                } else {
                    List(librarySongs) { song in
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            Text(song.artistName)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $sortOrder) {
                            ForEach(SortOrder.allCases) { order in
                                Text(order.rawValue.capitalized).tag(order)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
        .task(id: sortOrder) {
            await loadLibrary()
        }
    }

    func loadLibrary() async {
        if musicAuthorization != .authorized {
            musicAuthorization = await MusicAuthorization.request()
        }
        guard musicAuthorization == .authorized else { return }
        var request = MusicLibraryRequest<Song>()
        request.sort(by: sortOrder.descriptor, ascending: true)
        do {
            let response = try await request.response()
            librarySongs = response.items
        } catch {
            print("Failed to load library: \(error)")
        }
    }
}
