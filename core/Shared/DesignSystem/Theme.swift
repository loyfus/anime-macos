import SwiftUI

enum DS {
    enum Color {
        static var background: SwiftUI.Color {
            SwiftUI.Color(nsColor: .windowBackgroundColor)
        }
        static var surface: SwiftUI.Color {
            SwiftUI.Color(nsColor: .controlBackgroundColor)
        }
        static var surfaceElevated: SwiftUI.Color {
            SwiftUI.Color(nsColor: .underPageBackgroundColor)
        }
        static var border: SwiftUI.Color {
            SwiftUI.Color.primary.opacity(0.08)
        }
        static var brand: SwiftUI.Color { .indigo }
        static var accent: SwiftUI.Color { .accentColor }
        static var muted: SwiftUI.Color { .secondary }
        static var warning: SwiftUI.Color { .orange }
        static var success: SwiftUI.Color { .green }
        static var danger: SwiftUI.Color { .red }
    }

    enum Radius {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 14
        static let lg: CGFloat = 18
        static let xl: CGFloat = 24
    }

    enum Space {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    enum Shadow {
        static let subtle = SwiftUI.Color.black.opacity(0.08)
        static let lifted = SwiftUI.Color.black.opacity(0.14)
    }
}

// MARK: - Card Modifier

struct CardBackground: ViewModifier {
    var hoverScale: CGFloat = 1.0
    func body(content: Content) -> some View {
        content
            .padding(DS.Space.md)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous)
                    .fill(DS.Color.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous)
                            .stroke(DS.Color.border, lineWidth: 0.5)
                    )
                    .shadow(color: DS.Shadow.subtle, radius: 10, x: 0, y: 4)
            )
            .scaleEffect(hoverScale)
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: hoverScale)
    }
}

extension View {
    func cardBackground(hoverScale: CGFloat = 1.0) -> some View {
        modifier(CardBackground(hoverScale: hoverScale))
    }
}

// MARK: - Section Container

struct SectionContainer<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Space.md) {
            Text(title)
                .font(.title3).bold()
                .foregroundColor(.primary)
            content
        }
        .padding(DS.Space.lg)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.lg, style: .continuous)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.lg, style: .continuous)
                        .stroke(DS.Color.border, lineWidth: 0.5)
                )
        )
    }
}

