import AVFoundation

@available(iOS 13.0, *)
class CameraManager: NSObject, ObservableObject {
    @Published var session: AVCaptureSession?

    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    func configure() {
        checkPermission { granted in
            if granted {
                self.setupSession()
            } else {
                print("Permission denied")
            }
        }
    }

    private func checkPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
        default:
            completion(false)
        }
    }

    private func setupSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input)
        else {
            return
        }

        session.beginConfiguration()
        session.addInput(input)

        let previewOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(previewOutput) {
            session.addOutput(previewOutput)
        }

        session.commitConfiguration()
        session.startRunning()

        DispatchQueue.main.async {
            self.session = session
        }
    }
}
