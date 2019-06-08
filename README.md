# MelLandmarkRecApp
This iOS application is built on iPhone 6s Plus, iOS 12.2.
## Connect to the Server
To connect to your local web server, simply set the following variables in LandmarksRecApp/ViewController.swift:
```swift
let URL_PATH_RECEIVE : String = "http://your_ip_addr:5000/receive"
let URL_PATH_INITIALIZE : String = "http://your_ip_addr:5000/initialize"
```
## Start a Classification
Make sure your iPhone is connected to the same LAN with your web server. After launch the app, select/capture a photo then press "Start Journey" and wait for the result. Click "Check Map" to display the map and navigate to that location.
