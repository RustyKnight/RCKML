//
//  KMLLineStyle.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

struct KMLLineStyle {
    var id: String?
    var width: Double
    var color: String
}

extension KMLLineStyle: KmlElement {
    static var kmlTag: String {
        "LineStyle"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.id = xml.attributes["id"]
        self.width = try xml.requiredXmlChild(name: "width").double!
        self.color = try xml.requiredXmlChild(name: "color").string
    }
}

extension KMLLineStyle: KMLColorStyle {}
