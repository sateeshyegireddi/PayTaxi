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
    
    //MARK: - Emitters from User
    func connectUser(with data: [String: Any]) {

        socket.emit(GlobalConstants.SocketEventEmitters.userConnect, data)
    }
    
    func requestToFindNearByCabs(with data: [String: Any]) {
        
        socket.emit(GlobalConstants.SocketEventEmitters.findNearCabs, data)
    }
    
    //MARK: - Listners from User
    func fetchNearByCabs(completionHandler handler: @escaping(_ data: [Any]) -> ()) {
        
        socket.on(GlobalConstants.SocketEventListeners.nearCabs) { (data, ack) in
            
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
    
    //MARK: - Location Tracking
    
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
    
    // MARK: - Drivers list monitoring
    
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
    
}
