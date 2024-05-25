//
//  TestView.swift
//  PopChatGpt
//
//  Created by raz on 2024/4/4.
//

import SwiftUI

struct TestFormView: View
{
	@State private var enableLogging = false
	@State private var selectedColor = "Red"
	@State private var colors = ["Red", "Green", "Blue"]
	
	var body: some View 
	{
		Form {
			Section( footer: Text("Note: Enabling logging may slow down the app").font(.subheadline) )
			{
				Picker("Select a color", selection: $selectedColor) {
					ForEach(colors, id: \.self) {
						Text($0)
					}
				}
				.pickerStyle(.segmented)
				
				Toggle("Enable Logging", isOn: $enableLogging)
			}
			
			Section {
				Button("Save changes") {
					// activate theme!
				}
			}
			
			Section( "testme" )
			{
				Button("Save changes")
				{
				}
			}
			.frame( maxWidth:.infinity )
			.border(Color.white)
		}
	}
}

#Preview {
	TestFormView()
}
