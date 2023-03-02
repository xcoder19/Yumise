
import UIKit
import Vision
import AVFoundation


class ScannerController : UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate, UIWindowSceneDelegate {
    
    //MARK: - Properties
    
     let session = AVCaptureSession()
     var requests = [VNRequest]()
    
    var nameOfMatchedAdditive = [String]() {
        didSet  {
          
            if (nameOfMatchedAdditive.count > 0)
            {
                let vc =  ResultsViewController()
                
                vc.array = nameOfMatchedAdditive
                
                let nc = UINavigationController(rootViewController: vc)
                nc.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(nc, animated: true)
            }
           
          
            
        }
    }
      
     let foodAdditivesDescription = DataLoader().foodAdditivesDescription
    
    private lazy var scanButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Scan", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapScanButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.setWidth(100)
        button.setHeight(70)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var stopButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.setWidth(100)
        button.setHeight(70)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        
        return button
    }()
    
    var scanButtonShown : Bool = true
    var stopButtonShown : Bool = false
   
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        view.backgroundColor = .white
       
        startLiveVideo()
         
        
        view.addSubview(stopButton)
        stopButton.anchor(  bottom: view.bottomAnchor , paddingBottom: 100)
        
        view.addSubview(scanButton)
        scanButton.anchor( bottom: view.bottomAnchor , paddingBottom: 100)
        
        stopButton.centerX(inView: self.view)
        scanButton.centerX(inView: self.view)
        
        self.navigationController?.title = "Scan"
        self.navigationItem.title = "Scan Ingredients"
        

    }
    
 
    
   
    
    

  
    

    
    
    
    
    
    //MARK: - Actions
    
    @objc func didTapScanButton()
    {
        
        
        if (!session.isRunning)
       {
           session.startRunning()
        }
        
        startTextDetection()
        
        scanButton.isEnabled = false
        scanButton.isHidden = true
        
        
        stopButton.isEnabled = true
        stopButton.isHidden = false
        
    }
    
    
    @objc func didTapStopButton()
    {
        
        stopButton.isEnabled = false
        stopButton.isHidden = true
        
        scanButton.isEnabled = true
        scanButton.isHidden = false
       if (session.isRunning)
       {
            session.stopRunning()
        }

        
        
    }
    
    
    
    
   
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
        view.layer.insertSublayer(imageLayer, below: self.view.layer)
        
        
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
        var arr = [String]()
        Detectedtext.forEach { word in
          
            foodAdditivesDescription.forEach { additive in
                
                if word.lowercased().contains(additive.lowercased()) {
                    if arr.firstIndex(of: additive) == nil {
                        arr.append(additive)
                    }
                 
                }
                
            }
        }
        

        
        self.nameOfMatchedAdditive = arr
        
    }
    
  
}









    
    

