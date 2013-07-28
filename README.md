SJOPaperboy
===========
An easy to use library that lets you implement background updates in your app that run 
whenever the user enters or exits a specified location.

On iOS7 and above, an addition setting is displayed if you have the `UIBackgroundMode` `fetch` enabled in your `Info.plist`. This allows you to optionally run the new style background updates depending on the user's preference, as well as still having access to the old-style location based updates.

![SJOPaperboyViewController](https://raw.github.com/blork/SJOPaperboy/master/screenshot.png)
![SJOPaperboyViewController](https://raw.github.com/blork/SJOPaperboy/master/screenshot-ios7.png)

Setup
=====

If you are using [CocoaPods](http://cocoapods.org), just add the following to your Podspec:
```
pod 'SJOPaperboy', '~> 2.0.0'
```

Setup (without CocoaPods)
=====

Copy the following files to your Xcode project:
```
IPInsetLabel.h
IPInsetLabel.m
SJOPaperboyLocationManager.h
SJOPaperboyLocationManager.m
SJOPaperboyViewController.h
SJOPaperboyViewController.m
```

Usage
=====

Have your `AppDelegate` class have a `CLLocationManager` as a property.

```
@property (strong, nonatomic) CLLocationManager *paperboyLocationManager;
```

Then, in `application:didFinishLaunchingWithOptions:` add the following:

```
self.paperboyLocationManager = [SJOPaperboyLocationManager sharedLocationManager];
[[SJOPaperboyLocationManager sharedInstance] setLocationChangedBlock:^{
  //Perform your background updates here.
}];
```

To allow users to add geofencing locations, display `SJOPaperboyViewController`:

```
SJOPaperboyViewController* paperboyViewController = [[SJOPaperboyViewController alloc] init];
```

You can customise elements of the view controller by editing `Paperboy.strings`.

See the included example project for more implementation details.

Dependancies
============
`SJOPaperboy` requires the `CoreLocation` (for determining user location) and `AddressBookUI`
(for formatting address strings) frameworks. If you aren't using CocoaPods make sure to add them to 'Link Binary with Libraries'
under 'Build Phases' of your target.


Acknowledgements
================
Thanks to [Marco Arment](http://marco.org) for [`IPInsetLabel`](https://gist.github.com/marcoarment/2596057).

Inspired by the feature in [News.me](http://blog.news.me/post/24126549507/developing-stories-paperboy), 
Digg, and [Instapaper](http://blog.instapaper.com/post/24293729146) (plus many others).

License
=======
This project made available under the MIT License.

Copyright (C) 2013 Sam Oakley

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
