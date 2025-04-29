import SwiftUI
import AVFoundation

@available(iOS 13.0, *)
struct CameraView: View {
    @StateObject private var cameraManager = CameraManager()

    @available(iOS 14.0, *)
    var body: some View {
        ZStack {
            if let session = cameraManager.session {
             
                    CameraPreview(session: session)
                        .ignoresSafeArea()
                
            } else {
                Text("Không thể khởi động camera")
            }
        }
        .onAppear {
            cameraManager.configure()
        }
    }
}
