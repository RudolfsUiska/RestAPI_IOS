//
//  PDFViewController.swift
//  RestAPI
//
//  Created by Rūdolfs Uiska on 09/04/2019.
//  Copyright © 2019 Rūdolfs Uiska. All rights reserved.
//
//nesanāca kā tutā https://medium.com/mindorks/rendering-pdf-documents-using-pdfkit-9ac4944a6dfb
import UIKit
import PDFKit
var fileNamePDF: URL?
class PDFViewerController: UIViewController {

    //@IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pdfView: PDFView!
    //@IBOutlet var pdfView: PDFView!
   // var fileName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(fileNamePDF ?? "Nan")
        
        let fileName = fileNamePDF?.lastPathComponent
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let docURL = docDir.appendingPathComponent(fileName ?? "random.pdf")

        if let path = Bundle.main.path(forResource: "random", ofType: "pdf") {
            let url = URL(fileURLWithPath: path)
            if let pdfDocument = PDFDocument(url: url) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                // pdfView.displayDirection = .horizontal
                pdfView.document = pdfDocument
            }
        }
    }


}
