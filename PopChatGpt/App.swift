
import SwiftUI
import Cocoa

import KeyboardShortcuts


extension KeyboardShortcuts.Name
{
	static let toggleApp = Self( "toggleApp" , default: .init( .three, modifiers: [ .command, .shift ] ) )
	static let reloadWeb = Self( "reloadWeb" , default: .init( .r, modifiers: [ .command, .shift ] ) )
	
	public static func resetAll()
	{
		KeyboardShortcuts.reset([ .toggleApp, .reloadWeb ])
	}
}




@main
struct iApp: App
{
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	//@StateObject private var appState = AppState()
	
	static let initSize = NSSize(width: 675, height: 730)
	
	var body: some Scene
	{
		Settings { EmptyView() }
	}
}


//@MainActor
//final class AppState: ObservableObject
//{
//	init()
//	{
//	}
//	
//	deinit
//	{
//		print( "release!" )
//	}
//}

