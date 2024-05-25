//
//  SettingView.swift
//  Macboard
//
//  Created by raz on 2024/3/31.
//

import SwiftUI
import Settings
import KeyboardShortcuts

struct SettingView: View
{
	@AppStorage("showPreview") private var showPreview = true
	@AppStorage("fontSize") private var fontSize = 12.0
	
	@State private var shortcutKey = ""
	@AppStorage("value") private var value = 0.0
	
	var body: some View 
	{
		
		Form
		{
			LabeledContent("Toggle App") { KeyboardShortcuts.Recorder(for: .toggleApp) }
			.frame(width: 300)
			.padding(5)
			.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.gray, lineWidth: 2)
			)
			
			
			LabeledContent("Reload Web") { KeyboardShortcuts.Recorder(for: .reloadWeb) }
			.frame(width: 300)
			.padding(5)
			.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.gray, lineWidth: 2)
			)
		}
		.padding(20)
		.frame(width: 360, height: 100)
		
	}
}


let BaseSettingsViewController: () -> SettingsPane = {
	/**
	Wrap your custom view into `Settings.Pane`, while providing necessary toolbar info.
	*/
	let paneView = Settings.Pane(
		identifier: .general,
		title: "general",
		toolbarIcon: NSImage(systemSymbolName: "person.crop.circle", accessibilityDescription: "Accounts settings")!
	) {
		SettingView()
	}

	return Settings.PaneHostingController(pane: paneView)
}


#Preview {
	SettingView()
}
