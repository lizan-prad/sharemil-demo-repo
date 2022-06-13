//
//  QueueConfig.swift
//  Sharemil
//
//  Created by Lizan on 08/06/2022.
//

import Foundation


enum QueueConfig {
    static let qualityOfServiceClass = DispatchQoS.QoSClass.background
    static let backgroundQueue = DispatchQueue.global(qos: QueueConfig.qualityOfServiceClass)
}




