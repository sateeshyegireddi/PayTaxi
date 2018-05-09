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
    
    //MARK: - Location Sharing
    
    ///Share user's started location with socket server
    ///- parameter location: The location to be sent to server.
    func shareUserStartingLocation(_ location: Location) {
        
        socket.emit("connectTrackedUser", location.userId)
    }
    
    ///Share user's current location coordinates with socket server
    ///- parameter location: The location to be sent to server.
    func shareUserCurrentLocation(_ location: Location) {
        
        socket.emit("disconnectTrackedUser", location.userId, location.userName, location.latitude, location.longitude)
    }
    
    ///Share user's stop location with socket server
    ///- parameter location: The location to be sent to server.
    func shareUserStopLocation(_ location: Location) {
        
        socket.emit("disconnectTrackedUser", location.userId)
    }
    
    //MARK: - Location Tracking
    
    ///Send the status to server user started tracking a sharing location user
    ///- parameter trackedUserSocketId: the id of user to be tracked.
    ///- parameter coordinatesUpdateHandler: The callback that will execute when the tracked user coordinates are being updated.
    ///- parameter trackedUserCoordinatesUpdate: the dictionary of updated coordinates for tracked user.
    ///- parameter trackedUserStoppedTrackingHandler: The callback that will execute when the tracked user stops sharing location.
    ///- parameter userId: the id of tracked user.
    func userStartedTracking(trackedUserSocketId: String, coordinatesUpdateHandler: @escaping (_ trackedUserCoordinatesUpdate: [String: AnyObject]?) -> Void, trackedUserStoppedTrackingHandler: @escaping (_ userId: String?) -> Void) {
        socket.emit("connectTrackedUserTracker", trackedUserSocketId)
        
        //Listen to tracked user coordinates update
        socket.on("trackedUserCoordinatesUpdate") { ( dataArray, ack) -> Void in
            coordinatesUpdateHandler(dataArray[0] as? [String: AnyObject])
        }
        
        //Listen to whenever tracked user stops sharing location
        socket.on("trackedUserHasStoppedUpdate") { ( dataArray, ack) -> Void in
            trackedUserStoppedTrackingHandler(dataArray[0] as? String)
        }
    }
    
    ///Send the status to server a user stopped tracking a sharing location user
    ///- parameter trackedUserSocketId: the id of user to be tracked.
    func userStoppedTracking(trackedUserSocketId: String) {
        
        socket.emit("disconnectTrackedUserTracker", trackedUserSocketId)
    }
    
}
