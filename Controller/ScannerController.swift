
import UIKit
import Vision
import AVFoundation


class ScannerController : UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate, UIWindowSceneDelegate {
    
    //MARK: - Properties
     let session = AVCaptureSession()
     var requests = [VNRequest]()
    
    var nameOfMatchedAdditive = [String]() {
        didSet  {
            resultsView.handleSwipeUp()
            resultsView.arr = nameOfMatchedAdditive
            
        }
    }
      lazy var resultsView = ResultsView()
     let foodAdditivesDescription = DataLoader().foodAdditivesDescription
    
    
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {

        

        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        
        
        view.addSubview(resultsView)
        resultsView.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingBottom: -(view.frame.height - 200)) 
        resultsView.setHeight(view.frame.height)
        startTextDetection()
       startLiveVideo()

    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.startRunning()
    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.stopRunning()
    }
    
    
  

    
    
    
    
    //MARK: - Actions
    
    
    
   
    //MARK: - Helpers
    
    func configure() {
        
    }
     
    func startLiveVideo() {
        //1
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        //2
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
       
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
           
        //3
       let imageLayer = AVCaptureVideoPreviewLayer(session: session)

      
        imageLayer.frame = view.bounds
        imageLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(imageLayer, below: resultsView.layer)
       
        session.startRunning()
        
        
    }
    
    func startTextDetection() {
        let textRequest = VNRecognizeTextRequest(completionHandler: self.detectTextHandler)
        textRequest.recognitionLevel = .accurate
        textRequest.recognitionLanguages = ["english"]
        self.requests = [textRequest]
      }
    
    
   
    func detectTextHandler(request: VNRequest,error: Error?) {

        guard let observations =
                    request.results as? [VNRecognizedTextObservation] else {
                   return
               }

            let recognizedStrings = observations.compactMap { observation in
                // Return the string of the top VNRecognizedText instance.
                return observation.topCandidates(1).first?.string
            }
            DispatchQueue.main.async() {
                self.render(Detectedtext: recognizedStrings)
              }




    }
    
    private func inferOrientation() -> CGImagePropertyOrientation {
        switch UIDevice.current.orientation.rawValue  {
        case 0:
            return CGImagePropertyOrientation.right
      case 3:
        return CGImagePropertyOrientation.up

      case 4:
        return CGImagePropertyOrientation.down

      case 2:
        return CGImagePropertyOrientation.left

      case 1:
        return CGImagePropertyOrientation.right

        default:
            return CGImagePropertyOrientation.right
        }
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
            
        var requestOptions:[VNImageOption : Any] = [:]
            
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
            
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: inferOrientation(), options: requestOptions)
            
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
  
    func render(Detectedtext:[String]) {
        Detectedtext.forEach { word in
          
            foodAdditivesDescription.forEach { additive in
                
                if word.lowercased().contains(additive.lowercased()) {
                    if self.nameOfMatchedAdditive.firstIndex(of: additive) == nil {
                        self.nameOfMatchedAdditive.append(additive)
                    }
                 
                }
                
            }
        }
        

        
        
        
    }
    
  
}









    
    

