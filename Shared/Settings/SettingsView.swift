//
//  SettingsView.swift
//  Tendr (iOS)
//
//  Created by Vince on 2021-02-19.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("NSFW") var nsfwEnabled = false
    
    private var releaseVersion: String { return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var body: some View {
        Form {
            Section(header: Text("User")) {
                Toggle(isOn: $nsfwEnabled) {
                    Text("NSFW")
                }
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("2.2.1")
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
