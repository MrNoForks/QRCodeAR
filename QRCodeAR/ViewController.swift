//
//  ViewController.swift
//  QRCodeAR
//
//  Created by Boppo on 30/04/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate {

    var captureSession  = AVCaptureSession()
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCamera()
    }

    func prepareCamera(){
        
        //Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {print("Failed to get camera"); return}
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            createQRCodeDetectionBox()
            
        } catch let error {
            print(error)
        }
        
        
    }
    
    func createQRCodeDetectionBox(){
        qrCodeFrameView = UIView()
        
        qrCodeFrameView?.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        qrCodeFrameView?.layer.borderWidth = 5
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    

    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == .qr{
//            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
//
//            qrCodeFrameView?.frame = barCodeObject!.bounds
//
//            if metadataObj.stringValue != nil{
//                let alert = UIAlertController(title: "QRCode", message: metadataObj.stringValue, preferredStyle: .actionSheet)
//
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//                    print(action)
//                }
//
//                alert.addAction(okAction)
//
//                self.present(alert,animated: true)
//            }
            performSegue(withIdentifier: "ARSegue", sender: self)
        }
    }

}

