//
//  CoreUI_Swift.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Bartosz Janda
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

let CoreUIErrorDomain = "CoreUIErrorDomain"

enum CoreUIErrorCodes: Int {
    case RenditionMissingData
    case RenditionMissingImage
    case RenditionMissingPDF
    case CannotCreatePDFDocument
}

enum NamedImageBasicType {
    case Universal1x
    case Universal2x
    case Universal3x
    case UniversalVector
    
    case iPhone1x
    case iPhone1x_4Inch
    case iPhone2x
    case iPhone2x_4Inch
    case iPhone3x
    case iPhone3x_4Inch
    case iPhoneVector
    case iPhoneVector_4Inch
    
    case iPad1x
    case iPad2x
    case iPad3x
    case iPadVector
    
    case AppleWatch
    case AppleWatch38
    case AppleWatch42
    
    case NotRecognized
}

extension CUIImageInsets: CustomStringConvertible {
    public var description: String {
        return "(\(top),\(left),\(bottom),\(right))"
    }
}

extension CUIDeviceIdiom: CustomStringConvertible {
    public var description: String {
        switch self {
        case .IdiomUniversal:
            return "universal"
        case .IdiomiPhone:
            return "iPhone"
        case .IdiomiPad:
            return "iPad"
        case .IdiomAppleWatch:
            return "AppleWatch"
        }
    }
}

extension CUISubtype: CustomStringConvertible {
    public var description: String {
        switch self {
        case .SubtypeNormal:
            return "normal"
        case .SubtypeiPhone4Inch:
            return "-568h"
        case .SubtypeAppleWarch38:
            return "-38"
        case .SubtypeAppleWarch42:
            return "-42"
        }
    }
}

extension CUIUserInterfaceSizeClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Any:
            return "any"
        case .Compact:
            return "compact"
        case .Regular:
            return "regular"
        }
    }
}

extension CUIRenderMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Original:
            return "original"
        case .Template:
            return "template"
        case .Default:
            return "default"
        }
    }
}

extension CUIResizingMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Tiles:
            return "tiles"
        case .Stretches:
            return "stretches"
        }
    }
}

extension CUIImageType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .None:
            return "none"
        case .Horizontal:
            return "horizontal"
        case .Vertical:
            return "vertical"
        case .HorizontalAndVertical:
            return "horizontal & vertical"
        }
    }
}

extension CUINamedImage {
    var ac_basicType: NamedImageBasicType {
        switch self.idiom() {
        // Universal / Mac
        case .IdiomUniversal:
            assert(self.subtype() == .SubtypeNormal, "Not recognized subtype.")
            if self.isVectorBased && self.size == CGSizeZero {
                return .UniversalVector
            } else {
                switch self.scale {
                case 1.0:
                    return .Universal1x
                case 2.0:
                    return .Universal2x
                case 3.0:
                    return .Universal3x
                default:
                    assert(false, "Not recognized scale.")
                }
            }
        // iPhone
        case .IdiomiPhone:
            if self.isVectorBased && self.size == CGSizeZero {
                if self.subtype() == .SubtypeiPhone4Inch {
                    return .iPhoneVector_4Inch
                } else {
                    return .iPhoneVector
                }
            } else {
                switch self.scale {
                case 1.0:
                    if self.subtype() == .SubtypeiPhone4Inch {
                        return .iPhone1x_4Inch
                    } else {
                        return .iPhone1x
                    }
                case 2.0:
                    if self.subtype() == .SubtypeiPhone4Inch {
                        return .iPhone2x_4Inch
                    } else {
                        return .iPhone2x
                    }
                case 3.0:
                    if self.subtype() == .SubtypeiPhone4Inch {
                        return .iPhone3x_4Inch
                    } else {
                        return .iPhone3x
                    }
                default:
                    assert(false, "Not recognized scale.")
                }
            }
        // iPad
        case .IdiomiPad:
            if self.isVectorBased && self.size == CGSizeZero {
                assert(self.subtype() == .SubtypeNormal, "Not recognized subtype.")
                return .iPadVector
            } else {
                assert(self.subtype() == .SubtypeNormal, "Not recognized subtype.")
                switch self.scale {
                case 1.0:
                    return .iPad1x
                case 2.0:
                    return .iPad2x
                case 3.0:
                    return .iPad3x
                default:
                    assert(false, "Not recognized scale.")
                }
            }
        // Aplpe Watch.
        case .IdiomAppleWatch:
            switch self.subtype() {
            case .SubtypeNormal:
                return .AppleWatch
            case .SubtypeAppleWarch38:
                return .AppleWatch38
            case .SubtypeAppleWarch42:
                return .AppleWatch42
            default:
                assert(false, "Not recognized subtype.")
            }
        default:
            assert(false, "Not recognized idiom.")
        }
        
        return .NotRecognized
    }
    
    var ac_sizeClassString: String? {
        switch (self.sizeClassHorizontal(), self.sizeClassVertical()) {
        case (.Any, .Any):
            return nil
        case (.Any, .Compact):
            return "*-"
        case (.Any, .Regular):
            return "*+"
        case (.Compact, .Any):
            return "-*"
        case (.Compact, .Compact):
            return "--"
        case (.Compact, .Regular):
            return "-+"
        case (.Regular, .Any):
            return "+*"
        case (.Regular, .Compact):
            return "+-"
        case (.Regular, .Regular):
            return "++"
        }
    }
    
    var ac_isPDF: Bool {
        if self.isVectorBased && self.size == CGSizeZero {
            return true
        }
        return false
    }
    
    var ac_imageName: String {
        // Size class suffix.
        var sizeClassSuffix = ""
        if let sc = self.ac_sizeClassString {
            sizeClassSuffix = "_\(sc)"
        }
        
        // Scale.
        var scale = ""
        switch self.scale {
        case 1.0:
            scale = ""
        case 2.0:
            scale = "@2x"
        case 3.0:
            scale = "@3x"
        default:
            assert(false, "Not recognized idiom.")
        }
        
        // Vector.
        var fileExtension = "png"
        if self.ac_isPDF {
            fileExtension = "pdf"
        }
        
        // Subtype (4 inch).
        var subtype = ""
        switch self.subtype() {
        case .SubtypeNormal:
            subtype = ""
        case .SubtypeiPhone4Inch:
            subtype = "-568h"
        case .SubtypeAppleWarch38:
            subtype = "-38"
        case .SubtypeAppleWarch42:
            subtype = "-42"
        }
        
        // Idiom.
        var idiom = ""
        switch self.idiom() {
        case .IdiomUniversal:
            idiom = ""
        case .IdiomiPhone:
            idiom = "~iphone"
        case .IdiomiPad:
            idiom = "~ipad"
        case .IdiomAppleWatch:
            idiom = "~watch"
        }
        
        return "\(self.name)\(sizeClassSuffix)\(subtype)\(scale)\(idiom).\(fileExtension)"
    }
    
    var ac_renditionName: String {
        let rendition = self._rendition()
        let realName = rendition.name()
        return realName
    }
    
    var ac_renditionSrcData: NSData {
        let rendition = self._rendition()
        let data = GetRenditionSrcData(rendition)
        return data
    }
    
    func ac_saveAtPath(filePath: String) throws {
        if self._rendition().pdfDocument() != nil {
            try self.ac_savePDFToDirectory(filePath)
            return
        } else if self._rendition().unslicedImage() != nil {
            try self.ac_saveImageToDirectory(filePath)
            return
        } else {
            throw NSError(domain: CoreUIErrorDomain, code: CoreUIErrorCodes.RenditionMissingData.rawValue, userInfo: nil)
        }
    }
    
    func ac_saveImageToDirectory(filePath: String) throws {
        let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        let filePathURL = NSURL(fileURLWithPath: filePath)
        let cgImage = self._rendition().unslicedImage().takeUnretainedValue()
        let cgDestination = CGImageDestinationCreateWithURL(filePathURL, kUTTypePNG, 1, nil)
        CGImageDestinationAddImage(cgDestination!, cgImage, nil)
        
        if !CGImageDestinationFinalize(cgDestination!) {
            throw error
        }
    }
    
    func ac_savePDFToDirectory(filePath: String) throws {
        let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        // Based on:
        // http://stackoverflow.com/questions/3780745/saving-a-pdf-document-to-disk-using-quartz
        
        let cgPDFDocument = self._rendition().pdfDocument().takeUnretainedValue()
        //Create the pdf context
        let cgPage = CGPDFDocumentGetPage(cgPDFDocument, 1);
        var cgPageRect = CGPDFPageGetBoxRect(cgPage, CGPDFBox.MediaBox);
        let mutableData = NSMutableData()
        
        let cgDataConsumer = CGDataConsumerCreateWithCFData(mutableData);
        let cgPDFContext = CGPDFContextCreate(cgDataConsumer, &cgPageRect, nil);
        
        if (CGPDFDocumentGetNumberOfPages(cgPDFDocument) > 0)
        {
            CGPDFContextBeginPage(cgPDFContext, nil);
            CGContextDrawPDFPage(cgPDFContext, cgPage);
            CGPDFContextEndPage(cgPDFContext);
        }
        else
        {
            throw NSError(domain: CoreUIErrorDomain, code: CoreUIErrorCodes.CannotCreatePDFDocument.rawValue, userInfo: nil)
        }
        
        CGPDFContextClose(cgPDFContext)
        
        let success = mutableData.writeToFile(filePath, atomically: true)
        if success {
            return
        }
        throw error
    }
}
