//
//  TestView.swift
//  PopChatGpt
//
//  Created by raz on 2024/4/4.
//

import SwiftUI

struct TestBasicView: View
{
	@State private var enableLogging = false
	@State private var selectedColor = "Red"
	@State private var colors = ["Red", "Green", "Blue"]
	
	var body: some View
	{
		
//		GeometryReader { geometry in
//			Text("Hello, SwiftUI!")
//				.frame(width: geometry.size.width * 0.5, height:100, alignment: .center)
//				.border(Color.red)
//		}
//		.frame(maxWidth: .infinity, minHeight: 30, maxHeight: 110, alignment: .center)
//		
		GeometryReader { geometry in
			HStack {
				Spacer()
				Text("Hello, SwiftUI!")
					.frame(width: geometry.size.width * 0.5, height: 100)
					.border(Color.red)
				Spacer()
			}
		}
		.frame(maxWidth: .infinity, minHeight: 110, maxHeight: 110, alignment: .center)
		
		
		GroupBox( label: Label( "test", systemImage: "building" ) )
		{
			Text( "this is Group" )
		}
		.frame( maxWidth: .infinity )
		.padding(5)
		
		Section( footer: Text("Note: Enabling logging may slow down the app") )
		{
			Picker("Select a color", selection: $selectedColor) {
				ForEach(colors, id: \.self) {
					Text($0)
				}
			}
			.pickerStyle(.segmented)
			
			Toggle("Enable Logging", isOn: $enableLogging)
		}
		
		Section
		{
			Button("Save changes") {
				// activate theme!
			}
		}
		
		
		Section( header: Text( "Inner Form" ) )
		{
			Form
			{
				LabeledContent( "test" )
				{
					Text( "zz" )
				}
			}
		}
		.border(Color.yellow)
		
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

#Preview {
	TestBasicView()
}
