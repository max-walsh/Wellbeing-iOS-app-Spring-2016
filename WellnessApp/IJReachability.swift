//
//  IJReachability.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 5/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//
// take form original :  Created by Isuru Nanayakkara 

import Foundation
import SystemConfiguration

public enum IJReachabilityType {
	case WWAN,
	WiFi,
	NotConnected
}

public class IJReachability {
	
	/**
	:see: Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
	*/
	public class func isConnectedToNetwork() -> Bool {
		
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
        
		/* Original
		let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
			SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
		}
        */
        
        /* Swift2
        
        :see: http://stackoverflow.com/questions/25623272/how-to-use-scnetworkreachability-in-swift
        */
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
		
		var flags: SCNetworkReachabilityFlags = []
        // Original
		//if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
        // Swift2
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
			return false
		}
		
        // Original
		//let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        // Swift2
        let isReachable = flags.contains(.Reachable)
        // Original
		//let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        // Swift2
        let needsConnection = flags.contains(.ConnectionRequired)
		
		return (isReachable && !needsConnection) ? true : false
	}
	
	public class func isConnectedToNetworkOfType() -> IJReachabilityType {
		
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		/* Original
		let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
			SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
		}
        */
        // Swift2
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return .NotConnected
        }
        
		
		var flags: SCNetworkReachabilityFlags = []
        // Original
		//if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
        // Swift2
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
			return .NotConnected
		}
		
        // Original
		//let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        // Swift2
        let isReachable = flags.contains(.Reachable)
		let isWWAN = (flags.intersect(SCNetworkReachabilityFlags.IsWWAN)) != []
		//let isWifI = (flags & UInt32(kSCNetworkReachabilityFlagsReachable)) != 0
		
		if(isReachable && isWWAN){
			return .WWAN
		}
		if(isReachable && !isWWAN){
			return .WiFi
		}
		
		return .NotConnected
		//let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		
		//return (isReachable && !needsConnection) ? true : false
	}
	
}
