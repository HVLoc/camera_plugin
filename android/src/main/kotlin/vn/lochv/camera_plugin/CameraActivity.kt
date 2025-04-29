package vn.lochv.camera_plugin

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.ui.Modifier
import androidx.compose.ui.viewinterop.AndroidView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.camera.core.Preview as CameraPreview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.core.CameraSelector
import androidx.camera.view.PreviewView
import androidx.compose.runtime.Composable

class CameraActivity : ComponentActivity() {
    private val CAMERA_PERMISSION_REQUEST_CODE = 100

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Kiểm tra quyền camera
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            // Nếu đã cấp quyền, tiếp tục mở camera
            setContent {
                CameraScreen(this)
            }
        } else {
            // Nếu chưa cấp quyền, yêu cầu quyền
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), CAMERA_PERMISSION_REQUEST_CODE)
        }
    }

    // Xử lý kết quả yêu cầu quyền camera
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Nếu quyền được cấp, mở camera
                setContent {
                    CameraScreen(this)
                }
            } else {
                // Nếu quyền không được cấp, có thể thông báo cho người dùng
                // Ví dụ: Toast.makeText(this, "Permission Denied", Toast.LENGTH_SHORT).show()
            }
        }
    }
}

@Composable
fun CameraScreen(cameraActivity: CameraActivity) {
    Box(modifier = Modifier.fillMaxSize()) {
        AndroidView(
            factory = { context ->
                PreviewView(context).apply {
                    val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
                    cameraProviderFuture.addListener({
                        val cameraProvider = cameraProviderFuture.get()
                        val preview = CameraPreview.Builder().build()

                        // Cung cấp giao diện SurfaceProvider cho PreviewView
                        preview.setSurfaceProvider(this.surfaceProvider)

                        // Chọn camera (ở đây là camera sau)
                        val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

                        // Gắn camera vào lifecycle của Activity
                        cameraProvider.bindToLifecycle(
                            cameraActivity,  // Đây là cách tham chiếu Activity
                            cameraSelector,
                            preview
                        )
                    }, ContextCompat.getMainExecutor(context))
                }
            },
            modifier = Modifier.fillMaxSize()
        )
    }
}
