import Foundation

extension TimeProvider {
    static let live: Self = TimeProvider(
        date: { Date() }
    )
}
