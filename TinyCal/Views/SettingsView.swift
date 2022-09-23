
import Combine
import LaunchAtLogin
import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("showChinese") public var showChinese = true
    @AppStorage("showHoliday") public var showHoliday = true
    @AppStorage("showMdInBar") public var showMdInBar = true
    @AppStorage("showEInBar") public var showEInBar = true
    @AppStorage("showHMInBar") public var showHMInBar = false
}

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
        }
        .padding(20)
        .frame(width: 375, alignment: .leading)
    }
}

struct GeneralSettingsView: View {
    @StateObject var settings = AppSettings()

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                Text("菜单栏")
                Toggle("在图标中显示月份", isOn: settings.$showMdInBar)
                    .onChange(of: settings.showMdInBar) { _ in
                        EventBus.post("bar_conf_change", sender: self.settings)
                    }
                Toggle("在图标中显示周几", isOn: settings.$showEInBar)
                    .onChange(of: settings.showEInBar) { _ in
                        EventBus.post("bar_conf_change", sender: self.settings)
                    }
                Toggle("在图标中显示小时分钟", isOn: settings.$showHMInBar)
                    .onChange(of: settings.showHMInBar) { _ in
                        EventBus.post("bar_conf_change", sender: self.settings)
                    }
//                TextField("hh:ss", text: settings.$timeFormat)
//                    .textFieldStyle(.roundedBorder)
            }
            Section {
                Text("日历")
                Toggle("显示农历", isOn: settings.$showChinese)
                Toggle("显示假期", isOn: settings.$showHoliday)
            }
            Section {
                Text("其他")
                LaunchAtLogin.Toggle {
                    Text("开机登录")
                }
            }

            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
