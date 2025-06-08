import SwiftUI
import MusicKit

struct SearchView: View {
    @State private var query: String = ""
    @State private var searchResults: MusicCatalogSearchResponse<Song>?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search songs", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                if let songs = searchResults?.songs, !songs.isEmpty {
                    List(songs) { song in
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            Text(song.artistName)
                                .font(.subheadline)
                        }
                    }
                } else {
                    Spacer()
                    Text("No results")
                    Spacer()
                }
            }
            .navigationTitle("Search")
        }
        .searchable(text: $query)
        .onSubmit(of: .search) {
            Task { await performSearch() }
        }
    }

    func performSearch() async {
        do {
            let request = MusicCatalogSearchRequest(term: query, types: [Song.self])
            searchResults = try await request.response()
        } catch {
            print("Search failed: \(error)")
        }
    }
}
