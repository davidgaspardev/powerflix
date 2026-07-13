package team.squill.moveflix

import android.app.ActivityManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onResume() {
        super.onResume()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            setTaskDescription(
                ActivityManager.TaskDescription.Builder()
                    .setIcon(R.mipmap.ic_launcher)
                    .build()
            )
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            @Suppress("DEPRECATION")
            setTaskDescription(ActivityManager.TaskDescription(null, R.mipmap.ic_launcher, 0))
        }
    }
}
