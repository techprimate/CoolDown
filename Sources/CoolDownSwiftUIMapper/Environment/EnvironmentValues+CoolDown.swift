import SwiftUI
import CoolDownParser

public struct CDLinkActionKey: EnvironmentKey {

    public static var defaultValue: ((LinkNode) -> Void)?

}

@available(iOS 13.0, *)
extension EnvironmentValues {

    public var cooldownLinkAction: CDLinkActionKey.Value {
        get { self[CDLinkActionKey.self] }
        set { self[CDLinkActionKey.self] = newValue }
    }
}
