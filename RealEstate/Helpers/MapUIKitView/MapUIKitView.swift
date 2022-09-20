//
//  MapUIKitView.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-20.
//

import Foundation
import MapKit
import SwiftUI

//// UIViewRepresentable used for UIKit Views
//struct MapUIKitView: UIViewRepresentable {
//
//    let mapView = MKMapView()
//    @Binding var realEstate: RealEstate
//
//    func makeUIView(context: Context) -> MKMapView {
//        mapView.delegate = context.coordinator
//        mapView.setRegion(.init(center: realEstate.city.coordinate,
//                                span: realEstate.city.zoomLevel),
//                          animated: true)
//        return mapView
//    }
//
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
//
//        var parent: MapUIKitView
//        var gestureRecognizer = UILongPressGestureRecognizer()
//
//        init(_ parent: MapUIKitView) {
//            self.parent = parent
//            super.init()
//            // if you want to make the user tap and hold to get the location
//        }
//
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            self.parent.realEstate.location = mapView.centerCoordinate
//            print("DEBUG: User Coordinate \(mapView.centerCoordinate) ")
//        }
//    }
//}
