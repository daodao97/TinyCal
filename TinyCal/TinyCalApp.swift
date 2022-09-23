import Cron
import SwiftUI

@main
struct TinyCalApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
//        WindowGroup {
//            ContentView(vm: HolidayViewModel())
//        }
        #if os(macOS)
            Settings {
                SettingsView()
            }
        #endif
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    var eventMonitor: EventMonitor?
    private var stockListVM: HolidayViewModel!
    @ObservedObject var settings = AppSettings()
   
    func firstOpen() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.togglePopover()
            }
        }
    }
    
    func rebuideStateBar() {
        var tpl = ""
        if self.settings.showMdInBar {
            tpl += "M月d日"
        }
        if self.settings.showEInBar {
            tpl += "E"
        }
        if self.settings.showHMInBar {
            tpl += "HH:mm"
        }
        if let button = self.statusItem.button {
            if tpl == "" {
                button.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "TinyCal")
                button.title = ""
            } else {
                button.title = Date().toDate(format: tpl)
                button.image = nil
            }
        }
    }
    
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        self.stockListVM = HolidayViewModel()
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = self.statusItem.button {
            button.action = #selector(self.onTapBar)
            self.rebuideStateBar()
        }
        
        let popover = NSPopover()
        
        popover.animates = true
        popover.contentSize = NSSize(width: 300, height: 1)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView(vm: self.stockListVM))
        
        self.popover = popover
        
        self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if let strongSelf = self, strongSelf.popover.isShown {
                self?.togglePopover()
            }
        }
        
        self.firstOpen()
        
        EventBus.onMainThread(self, name: "bar_conf_change") { _ in
            self.rebuideStateBar()
        }
        
        _ = try? CronJob(pattern: "0 * * * * *") { () -> Void in
            self.rebuideStateBar()
        }
        
        Task {
            await self.stockListVM.populateStocks(year: Date().toDate(format: "YYYY"))
        }
    }
    
    @objc func onTapBar() {
        self.popover.contentViewController = NSHostingController(rootView: ContentView(vm: self.stockListVM))
        self.togglePopover()
    }
    
    @objc func togglePopover() {
        if let button = statusItem.button {
            if self.popover.isShown {
                self.popover.performClose(nil)
                self.eventMonitor?.stop()
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.eventMonitor?.start()
            }
        }
    }
}
