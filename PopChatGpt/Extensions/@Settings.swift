import SwiftUI
import Settings
import enum Settings.Settings

extension Settings.PaneIdentifier {
    static let general = Self("general")
}

public extension SettingsWindowController 
{
    override func keyDown(with event: NSEvent) 
	{
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command, let key = event.charactersIgnoringModifiers 
		{
            if key == "w" {
                self.close()
            }
        }
    }
}
