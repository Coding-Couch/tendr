// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Alerts {
    internal enum Error {
      /// Please send us a screenshot of this alert!\nTime Occured: %@\nError Details: %@
      internal static func standard(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "Alerts.Error.Standard", String(describing: p1), String(describing: p2))
      }
    }
  }

  internal enum App {
    /// Tendr
    internal static let name = L10n.tr("Localizable", "App.Name")
  }

  internal enum ContextMenu {
    internal enum Action {
      /// Open in Browser
      internal static let browser = L10n.tr("Localizable", "ContextMenu.Action.Browser")
      /// Open
      internal static let `open` = L10n.tr("Localizable", "ContextMenu.Action.Open")
      /// Share
      internal static let share = L10n.tr("Localizable", "ContextMenu.Action.Share")
    }
  }

  internal enum Credits {
    internal enum Author {
      /// Ahmed Al-Hulaibi - Back End, Golang Developer
      internal static let ahmed = L10n.tr("Localizable", "Credits.Author.Ahmed")
      /// Brent Mifsud - Team Lead, iOS Developer
      internal static let brent = L10n.tr("Localizable", "Credits.Author.Brent")
      /// Sahand Nayebaziz - Floating Designer
      internal static let sahand = L10n.tr("Localizable", "Credits.Author.Sahand")
      /// Vince Romani - iOS Developer
      internal static let vince = L10n.tr("Localizable", "Credits.Author.Vince")
    }
    internal enum Body {
      /// Tendr was created by team Coding Couch for 2021 #SwiftTO SwiftUIJam
      internal static let description = L10n.tr("Localizable", "Credits.Body.Description")
    }
    internal enum NavBar {
      /// About Us
      internal static let title = L10n.tr("Localizable", "Credits.NavBar.Title")
    }
    internal enum Section {
      /// Team Members
      internal static let teamMembers = L10n.tr("Localizable", "Credits.Section.TeamMembers")
    }
  }

  internal enum History {
    internal enum Error {
      internal enum Generic {
        /// Something Went Wrong
        internal static let title = L10n.tr("Localizable", "History.Error.Generic.Title")
      }
      internal enum Tendr {
        /// HTTP Status Code: %@
        internal static func message(_ p1: Any) -> String {
          return L10n.tr("Localizable", "History.Error.Tendr.Message", String(describing: p1))
        }
        /// Tendr Api Returned an Error
        internal static let title = L10n.tr("Localizable", "History.Error.Tendr.Title")
      }
    }
    internal enum NavBar {
      /// My Memes
      internal static let title = L10n.tr("Localizable", "History.NavBar.Title")
    }
    internal enum Segment {
      /// Disliked Memes
      internal static let disliked = L10n.tr("Localizable", "History.Segment.Disliked")
      /// Liked Memes
      internal static let liked = L10n.tr("Localizable", "History.Segment.Liked")
    }
    internal enum State {
      /// Fetching More Memes...
      internal static let initialLoad = L10n.tr("Localizable", "History.State.InitialLoad")
      /// Fetching More Memes...
      internal static let paging = L10n.tr("Localizable", "History.State.Paging")
    }
  }

  internal enum LandingPage {
    internal enum Button {
      /// Skip Signup
      internal static let skip = L10n.tr("Localizable", "LandingPage.Button.Skip")
    }
  }

  internal enum Meme {
    internal enum Text {
      /// Reddit Downvote Count: 
      internal static let downvotes = L10n.tr("Localizable", "Meme.Text.Downvotes")
      /// Source: 
      internal static let source = L10n.tr("Localizable", "Meme.Text.Source")
      /// Meme Details
      internal static let title = L10n.tr("Localizable", "Meme.Text.Title")
      /// Reddit Upvote Count: 
      internal static let upvotes = L10n.tr("Localizable", "Meme.Text.Upvotes")
      /// Image Url: 
      internal static let url = L10n.tr("Localizable", "Meme.Text.Url")
    }
  }

  internal enum Settings {
    internal enum NavBar {
      /// Settings
      internal static let title = L10n.tr("Localizable", "Settings.NavBar.Title")
    }
    internal enum Row {
      /// About Us
      internal static let about = L10n.tr("Localizable", "Settings.Row.About")
      /// Logout 
      internal static let logout = L10n.tr("Localizable", "Settings.Row.Logout")
      /// Show NSFW Memes
      internal static let nsfw = L10n.tr("Localizable", "Settings.Row.NSFW")
      /// Your UserId:
      internal static let userID = L10n.tr("Localizable", "Settings.Row.UserID")
      /// Version: 
      internal static let version = L10n.tr("Localizable", "Settings.Row.Version")
    }
    internal enum Section {
      /// About
      internal static let about = L10n.tr("Localizable", "Settings.Section.About")
      /// User Preferences
      internal static let userPreferences = L10n.tr("Localizable", "Settings.Section.UserPreferences")
    }
  }

  internal enum TabBar {
    internal enum Tab {
      /// History
      internal static let history = L10n.tr("Localizable", "TabBar.Tab.History")
      /// Home
      internal static let home = L10n.tr("Localizable", "TabBar.Tab.Home")
      /// Settings
      internal static let settings = L10n.tr("Localizable", "TabBar.Tab.Settings")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
