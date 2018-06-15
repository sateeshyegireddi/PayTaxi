//
//  SocketsManager.swift
//  PayTaxi
//
//  Created by Sateesh on 5/8/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import SocketIO

class SocketsManager: NSObject {

    //MARK: - Properties
    
    ///The shared instance of Socket Manager
    static let sharedInstance = SocketsManager()
    
    ///A manager for a socket.io connection
    var socketManager = SocketManager(socketURL: URL.init(string: GlobalConstants.API.socketUrl)!, config: [.log(true), .compress])
    
    ///The socket associated with the default namespace
    var socket: SocketIOClient!
    
    ///Socket connection status (Connected, Disconnected, etc)
    var connectionStatus: SocketIOStatus {
        
        return socket.status
    }
    
    //MARK: - Initialisation
    override init() {
        
        super.init()
        socket = socketManager.defaultSocket
    }
    
    //MARK: - Socket Connection
    
    ///Connect to the socket server
    func establishConnection() {
        
        socket.connect()
    }
    
    ///Disconnect from the socket server
    func closeConnection() {
        
        socket.disconnect()
    }
    
    ///Listen to connection changes and respond accordingly
    ///- parameter onConnectHandler: The callback that will execute when the socket is connected.
    ///- parameter onDisconnectHandler: The callback that will execute when the socket is disconnected.
    func listenToConnectionChanges(onConnectHandler: @escaping ()->Void, onDisconnectHandler: @escaping ()->Void) {
        
        socket.on(clientEvent: .connect) {  ( dataArray, ack) -> Void in
            onConnectHandler()
        }
        
        socket.on(clientEvent: .disconnect) {  ( dataArray, ack) -> Void in
            onDisconnectHandler()
        }
    }
    
    //MARK: - >>>>>------->>  User Socket Functions  <<-------<<<<< -
    
    //MARK: Emitters from User
    
    ///Authenticate user with socket server.
    ///- parameter data: The authentication data to be sent to server.
    ///eg. `{key:"paytaxi@development@app",id:"P@yT@xi143"}`
    func authenticateUser(with data: [String: Any]) {
      
        socket.emit(GlobalConstants.SocketEventEmitters.authenticate, data)
    }
    
    ///Request socket server to connect user.
    ///- parameter data: The location to be sent to server.
    ///eg. `{"id": "userid", "type": "driver", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func connectUser(with data: [String: Any]) {

        socket.emit(GlobalConstants.SocketEventEmitters.userConnect, data)
    }
    
    ///Send the request for fetching the nearby cabs information to socket server.
    ///
    ///Basically, the request information contains type of the cab and user's current location.
    ///- parameter data: The data of current user's location and type of the cab to be sent to server.
    ///eg. `{cabType:"mini",lat:'17.3850',lng:'78.4867'}`
    func requestToFindNearByCabs(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.findNearCabs, data)
    }
    
    ///Send the request for confirming the ride with driver to socket server.
    ///
    ///Basically, the request information contains user details, ride details and the type of the cab.
    ///- parameter data: The data of current user details, ride details and type of the cab to be sent to server.
    ///eg. `{"id": "userid", "rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func requestARide(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.requestARide, data)
    }
    
    ///Send the request for cancelling the ride with driver to socket server.
    ///
    ///Basically, the request information contains user details and ride specific details
    ///- parameter data: The data of current user and ride info to be sent to server.
    ///eg. `{"id": "userid", "rideId": "1234"}`
    func cancelARideFromUser(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.cancelARideFromUser, data)
    }
    
    //MARK: - Listners for User
    
    ///Fetch the nearby available cabs information by listening to socket server.
    ///This service will get called after the `findNearCabs` request sent to socket server.
    ///
    ///Basically, the response information contains drivers current locations.
    ///- parameter completionHandler: The callback get called after the socket server responds to the request `findNearCabs`.
    ///- parameter data: The data of drivers current locations to be recieved from socket server.
    ///eg. `[{"lat": "12.34", "lng": "14.232"}, {"lat": "15.34", "lng": "18.232"}]`
    func fetchNearByCabs(completionHandler handler: @escaping(_ data: [Any]) -> ()) {
        
        socket.on(GlobalConstants.SocketEventListeners.nearCabs) { (data, ack) in
            
            print(data)
            handler(data)
        }
    }
    
    ///Fetch the information regarding the driver accepted the ride or not by listening to socket server.
    ///This service will get called after the `requestRide` request sent to socket server.
    ///
    ///Basically, the response information contains ride details and drivers current location.
    ///- parameter completionHandler: The callback get called after the socket server responds to the request `requestRide`.
    ///- parameter data: The data of driver's information update to be recieved from socket server.
    ///eg. `{"cabType": "mini", "distanceFromUser": "1.7752", "id": "PAY2", "lat" :"17.45400041341781616", "lng": "78.38313034344933783", "rideId": "RIDE423", "riderUserId": "PAY8"}`
    func rideDidAcceptByDriver(completionHandler handler: @escaping(_ data: [Any]) -> ()) {
        
        socket.on(GlobalConstants.SocketEventListeners.rideAcceptedByDriver) { (data, ack) in
            
            print(data)
            handler(data)
        }
    }
    
    ///Fetch the information regarding the driver completed the ride or not by listening to socket server.
    ///This service will get called after the driver has emitted the request `rideComplete`.
    ///
    ///Basically, the response information contains user and ride information.
    ///- parameter completionHandler: The callback get called after the socket server responds to the request `requestRide`.
    ///- parameter data: The data of ride information to be recieved from socket server.
    ///eg. `{"rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func rideDidCompleteByDriver(completionHandler handler: @escaping(_ data: [Any]) -> ()) {
        
        socket.on(GlobalConstants.SocketEventListeners.rideCompletedByUser) { (data, ack) in
            
            print(data)
            handler(data)
        }
    }
    
    ///Fetch the information regarding the driver cancelled the ride or not by listening to socket server.
    ///This service will get called after the driver has emitted the request `ridecanclusr`.
    ///
    ///Basically, the response information contains user and ride information.
    ///- parameter completionHandler: The callback get called after the socket server responds to the request `ridecanclusr`.
    ///- parameter data: The data of ride information to be recieved from socket server.
    ///eg. `{"rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func rideDidCancelByDriver(completionHandler handler: @escaping(_ data: [Any]) -> ()) {
        
        socket.on(GlobalConstants.SocketEventListeners.driverCancelRide) { (data, ack) in
            
            print(data)
            handler(data)
        }
    }
    
    //MARK: - >>>>>------->>  Driver Socket Functions  <<-------<<<<< -
    
    //MARK: Emitters from Driver
    
    ///Authenticate driver with socket server.
    ///- parameter data: The authentication data to be sent to server.
    ///eg. `{key:"paytaxi@development@app",id:"P@yT@xi143"}`
    func authenticateDriver(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.authenticate, data)
    }
    
    ///Request socket server to connect driver.
    ///- parameter data: The driver's information to be sent to server.
    ///eg. `{"id": "userid", "type": "driver", "cabType": "mini", "lat": "17.3850", "lng": "78.4867", "enabled": "false"}`
    func connectDriver(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.userConnect, data)
    }
    
    ///Request socket server to update the driver is available for the current ride booking.
    ///- parameter data: The driver's information to be sent to server.
    ///eg. `{"id": "userid", "type": "driver", "cabType": "mini", "lat": "17.3850", "lng": "78.4867", "enabled": "true"}`
    func driverAvailableForRide(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.availableDriverLocation, data)
    }
    
    ///Request socket server to update the ride has timed out or driver has cancelled the ride.
    ///- parameter data: The driver's information to be sent to server.
    ///eg. `{"id": "userid", "rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func rideDidCancel(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.rideCancel, data)
    }
    
    ///Request socket server to update the ride has been accepted by the driver.
    ///- parameter data: The ride's information to be sent to server.
    ///eg. `{"id": "userid", "rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func driverDidAcceptRide(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.acceptRide, data)
    }
    
    ///Request socket server to update the ride has been completed by the driver.
    ///- parameter data: The ride's information to be sent to server.
    ///eg. `{"rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func driverDidCompleteRide(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.completeRide, data)
    }
    
    //MARK: - Listeners for Driver
    
    ///Fetch the information of the ride request that has been requested to driver by listening to socket server.
    ///This service will get called after the `request ride` request sent to socket server.
    ///
    ///Basically, the response information contains ride request details.
    ///- parameter completionHandler: The callback get called after the socket server responds to the request `request ride`.
    ///- parameter data: The detailed information of ride request to be recieved from socket server.
    ///eg. `{"rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func driverDidGetRide(completionHandler handler: @escaping(_ data: [Any]) -> ()) {
        
        socket.on(GlobalConstants.SocketEventListeners.nearCabs) { (data, ack) in
            
            print(data)
            handler(data)
        }
    }
    
    ///Fetch the information of the ride that has been requested to driver by listening to socket server.
    ///This service will get called after the `request ride` request sent to socket server.
    ///
    ///Basically, the response information contains ride details.
    ///- parameter completionHandler: The callback get called after the socket server responds to the request `request ride`.
    ///- parameter data: The detailed information of ride request to be recieved from socket server.
    ///eg. `{"id": "userid", "rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func getRideDetails(completionHandler handler: @escaping(_ data: [Any]) -> ()) {
        
        socket.on(GlobalConstants.SocketEventListeners.rideDetails) { (data, ack) in
            
            print(data)
            handler(data)
        }
    }
    
    ///Fetch the information of the ride that has been cancelled by user by listening to socket server.
    ///This service will get called after the `ridecancldri` request sent to socket server.
    ///
    ///Basically, the response information contains cancellation of the ride.
    ///- parameter completionHandler: The callback get called after the socket server responds to the request `ridecancldri`.
    ///- parameter data: The detailed information of cancellation of the ride to be recieved from socket server.
    ///eg. `{"rideId": "1234", "cabType": "mini", "lat": "17.3850", "lng": "78.4867"}`
    func rideDidCancelByUser(completionHandler handler: @escaping(_ data: [Any]) -> ()) {
        
        socket.on(GlobalConstants.SocketEventListeners.userCancelRide) { (data, ack) in
            
            print(data)
            handler(data)
        }
    }
    
    //MARK: - Location Sharing
    
    ///Share user's started location with socket server
    ///- parameter location: The location to be sent to server.
    func shareUserStartingLocation(_ location: Location) {
        
        socket.emit("connectDriver", location.userId)
    }
    
    ///Share user's current location coordinates with socket server
    ///- parameter location: The location to be sent to server.
    func shareUserCurrentLocation(_ location: Location) {
        
        socket.emit("driverCoordinates", location.userId, location.userName, location.latitude, location.longitude)
    }
    
    ///Share user's stop location with socket server
    ///- parameter location: The location to be sent to server.
    func shareUserStopLocation(_ location: Location) {
        
        socket.emit("disconnectDriver", location.userId)
    }
    
    /*
    //MARK Location Tracking
    
    ///Send the status to server user started tracking a driver
    ///- parameter trackedUserSocketId: the id of user to be tracked.
    ///- parameter coordinatesUpdateHandler: The callback that will execute when the driver coordinates are being updated.
    ///- parameter trackedUserCoordinatesUpdate: the dictionary of updated coordinates for the driver.
    ///- parameter trackedUserStoppedTrackingHandler: The callback that will execute when the driver stops sharing location.
    ///- parameter userId: the id of the driver.
    func userStartedTracking(driverSocketId: String, coordinatesUpdateHandler: @escaping (_ driverCoordinatesUpdate: [String: AnyObject]?) -> Void, driverStoppedTrackingHandler: @escaping (_ userId: String?) -> Void) {
        socket.emit("connectDriverTracker", driverSocketId)
        
        //Listen to the driver coordinates update
        socket.on("DriverCoordinatesUpdate") { ( dataArray, ack) -> Void in
            coordinatesUpdateHandler(dataArray[0] as? [String: AnyObject])
        }
        
        //Listen to whenever the driver stops sharing location
        socket.on("driverHasStoppedUpdate") { ( dataArray, ack) -> Void in
            driverStoppedTrackingHandler(dataArray[0] as? String)
        }
    }
    
    ///Send the status to server a user stopped tracking the driver
    ///- parameter driverSocketId: id of the driver.
    func userStoppedTracking(driverSocketId: String) {
        
        socket.emit("disconnectDriverTracker", driverSocketId)
    }
    
    // MARK Drivers list monitoring
    
    ///Send to server a message requesting the updated drivers list
    func checkForUpdatedDriversList() {
        socket.emit("requestUpdatedDriversList")
    }
    
    //Listen to updated in the tracked users list
    func listenToTrackedUsersListUpdate(completionHandler: @escaping (_ trackedUsersListUpdate: [[String: AnyObject]]?) -> Void) {
        socket.on("driversListUpdate") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
    }
    */
}
