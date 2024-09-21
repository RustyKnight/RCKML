//
//  KMLLookAt.swift
//  RCKML
//
//  Created by Shane Whitehead on 21/9/2024.
//

import AEXML
import Foundation

public enum KMLAltitudeMode: String {
    case clampToGround
    case relativeToGround
    case absolute

    case clampToSeaFloor
    case relativeToSeaFloor
}

/// Defines a virtual camera that is associated with any element derived from Feature.
/// The LookAt element positions the "camera" in relation to the object that is being viewed.
/// In Google Earth, the view "flies to" this LookAt viewpoint when the user double-clicks
/// an item in the Places panel or double-clicks an icon in the 3D viewer.
///
/// For reference, see [KML Abstract View Spec](https://developers.google.com/kml/documentation/kmlreference#abstractview)
/// and [KML Look At Spec](https://developers.google.com/kml/documentation/kmlreference#lookat)
public struct KMLLookAt {
    public var longitude: Double // kml:angle180
    public var latitude: Double // kml:angle90
    public var altitude: Double?
    public var heading: Double? // kml:angle360
    public var tilt: Double? // kml:anglepos90
    public var range: Double?
    public var altitudeMode: KMLAltitudeMode?

    public init(longitude: Double, latitude: Double, altitude: Double?, heading: Double?, tilt: Double?, range: Double?, altitudeMode: KMLAltitudeMode?) {
        self.longitude = longitude
        self.latitude = latitude
        self.altitude = altitude
        self.heading = heading
        self.tilt = tilt
        self.range = range
        self.altitudeMode = altitudeMode
    }
}

// MARK: - KmlElement

extension KMLLookAt: KmlElement {
    public static var kmlTag: String {
        "LookAt"
    }

    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)

        guard let longitude = try xml.requiredXmlChild(name: "longitude").double else {
            throw KMLError.missingRequiredElement(elementName: "Longitude")
        }
        guard let latitude = try xml.requiredXmlChild(name: "latitude").double else {
            throw KMLError.missingRequiredElement(elementName: "Latitude")
        }

        self.longitude = longitude
        self.latitude = latitude

        self.altitude = xml.optionalXmlChild(name: "altitude")?.double
        self.heading = xml.optionalXmlChild(name: "heading")?.double
        self.tilt = xml.optionalXmlChild(name: "tilt")?.double
        self.range = xml.optionalXmlChild(name: "range")?.double

        guard let value = xml.optionalXmlChild(name: "altitudeMode")?.string, let mode = KMLAltitudeMode(rawValue: value) else {
            return
        }

        self.altitudeMode = mode
    }

    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild(name: "longitude", value: String(format: "%.6f", longitude))
        element.addChild(name: "latitude", value: String(format: "%.6f", latitude))
        element.addChild(name: "altitude", value: String(format: "%.1f", latitude))
        element.addChild(name: "heading", value: String(format: "%.6f", latitude))
        element.addChild(name: "tilt", value: String(format: "%.6f", latitude))
        element.addChild(name: "range", value: String(format: "%.6f", latitude))
        element.addChild(name: "altitudeMode", value: altitudeMode?.rawValue)
        return element
    }
}
