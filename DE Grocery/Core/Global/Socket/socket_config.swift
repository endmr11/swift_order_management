//
//  socket_config.swift
//  DE Grocery
//
//  Created by Eren Demir on 25.05.2022.
//

import Foundation
import SocketIO

class SocketConfig {
    static let socketManager = SocketManager(socketURL: URL(string: "http://localhost:8083")!, config: [.log(false), .forcePolling(false), .forceWebsockets(false)])
    let socket = socketManager.defaultSocket
    func initSocket() {
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.socket.emit("isConnected", "yes")
        }
        socket.on("connectionStatus") { data, ack in
            print("connectionStatus: Result => \(data)")
        }
    }
    
    func closeSocket() {
        socket.disconnect()
    }
}

/*
 
 
 let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
 let socket = manager.defaultSocket

 socket.on(clientEvent: .connect) {data, ack in
     print("socket connected")
 }

 socket.on("currentAmount") {data, ack in
     guard let cur = data[0] as? Double else { return }
     
     socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
         if data.first as? String ?? "passed" == SocketAckValue.noAck {
             // Handle ack timeout
         }

         socket.emit("update", ["amount": cur + 2.50])
     }

     ack.with("Got your currentAmount", "dude")
 }

 socket.connect()
 
 
 */
