
import AppKit

func openSettings() {
    NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
}
