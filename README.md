# QuestLogger

![GitHub](https://img.shields.io/github/license/ghall89/questlogger-mac)

A macOS application for managing you video game collection. Written in SwiftUI, and uses [IGDB](https://api-docs.igdb.com/#getting-started) as a data source.

## Setting Up

__Important:__ QuestLogger is considered in early alpha.

Follow the instructions [here](https://api-docs.igdb.com/#account-creation) if you don't already have a Twitch developer account.

In order to fully use the app, you will need to enter your Twitch client ID and client secret by going to `QuestLogger → Settings...` in the app's menu bar, or with the following keyboard shortcut: `⌘ + '`.

## Compile From Source

### Prerequisites

- MacOS 13.5+
- Xcode 14.3+
- An [Apple Developer Account](https://developer.apple.com)

### Instructions

1. Clone this repo with `git clone git@github.com:ghall89/questlogger-mac.git`
2. Open `QuestLogger.xcodeproj` from the project directory
3. Wait for package dependencies to download
4. From the menubar, go to `Product → Archive`
5. When archive is complete, click `Distribute App` and select either `Direct Distribution` or `Custom` and follow the prompts

## Packages

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftfulLoadingIndicators](https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators)
- [SwiftUI CachedAsyncImage](https://github.com/lorenzofiamingo/swiftui-cached-async-image)

## License

MIT License

Copyright (c) 2023 Graham Hall

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
