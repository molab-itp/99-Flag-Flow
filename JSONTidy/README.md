# JSONTidy

Swift command line app to read and reformat JSON file from
[hackingwithswift](https://www.hackingwithswift.com)

- https://www.hackingwithswift.com/plus/command-line-apps/json-tidy

JSON is one of the most common file formats we deal with, so we can write a
little macOS utility to make it nicer to work with – compressing the data,
formatting the data, and even sorting the key names.

```

Product menu and choose Show Build Folder
Products > Debug directory, you should see “JSONTidy”

Copy Build Folder Path

/Users/jht2/Library/Developer/Xcode/DerivedData/JSONTidy-fcztekwrdmchbuegnwyyperiqwpt/Build

Make a release build of your app, rather than always using the debug version.

Copy the final release binary into /user/local/bin/jsontidy, so that it’s accessible from anywhere on your system.

Archive Build
Show Package Contents

<../../../../../Library/Developer/Xcode/Archives/2023-11-11/JSONTidy 11-11-23, 12.16 PM.xcarchive/Products/usr/local/bin/JSONTidy>

# ls -la /usr/local/bin

total 351720
drwxr-xr-x@ 9 root  wheel        288 Aug  8 19:41 .
drwxr-xr-x  6 root  wheel        192 Oct  5 18:29 ..
lrwxr-xr-x  1 root  wheel         68 Oct 31  2021 code -> /Applications/Visual Studio Code.app/Contents/Resources/app/bin/code
-rwxr-xr-x  1 root  wheel        606 Oct 12  2021 fuzzy_match
-rwxr-xr-x  1 root  wheel        600 Oct 12  2021 httpclient
-rwxr-xr-x  1 root  wheel  180064496 Feb  1  2023 node
lrwxr-xr-x  1 root  wheel         38 Feb  3  2023 npm -> ../lib/node_modules/npm/bin/npm-cli.js
lrwxr-xr-x  1 root  wheel         38 Feb  3  2023 npx -> ../lib/node_modules/npm/bin/npx-cli.js
-rwxr-xr-x  1 root  wheel        594 Oct 12  2021 xcodeproj

sudo cp /Users/jht2/Library/Developer/Xcode/Archives/2023-11-11/JSONTidy\ 11-11-23\,\ 12.16\ PM.xcarchive/Products/usr/local/bin/JSONTidy /usr/local/bin/jsontidy

which jsontidy
/usr/local/bin/jsontidy

# ls -la /usr/local/bin/jsontidy

-rwxr-xr-x  1 root  wheel  1497952 Nov 11 12:21 /usr/local/bin/jsontidy

# jsontidy sample.json

{"info":{"version":1,"author":"xcode"}}

# jsontidy -p sample.json
{
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}

```
