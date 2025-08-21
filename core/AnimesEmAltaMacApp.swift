import SwiftUI

@main
struct AnimesEmAltaMacApp: App {
    var body: some Scene {
        WindowGroup {
            AnimeListView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .commands {
            // Custom commands
            CommandGroup(replacing: .newItem) {
                Button("Atualizar Lista") {
                    NotificationCenter.default.post(name: .refreshAnimeList, object: nil)
                }
                .keyboardShortcut("r", modifiers: .command)
            }
            
            CommandGroup(replacing: .help) {
                Button("Sobre o AniList") {
                    NSWorkspace.shared.open(URL(string: "https://anilist.co/about")!)
                }
                
                Divider()
                
                Button("Documentação da API") {
                    NSWorkspace.shared.open(URL(string: "https://anilist.gitbook.io/anilist-apiv2-docs/")!)
                }
            }
        }
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let refreshAnimeList = Notification.Name("refreshAnimeList")
}
