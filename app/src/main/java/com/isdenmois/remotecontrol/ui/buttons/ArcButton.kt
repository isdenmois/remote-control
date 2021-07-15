package com.isdenmois.remotecontrol.ui.buttons

import android.content.Context
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.graphics.Path
import android.graphics.Rect
import android.graphics.PointF
import android.util.AttributeSet
import androidx.core.content.withStyledAttributes
import com.isdenmois.remotecontrol.R
import kotlin.math.atan2
import kotlin.math.pow
import kotlin.math.sqrt

class ArcButton @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyle: Int = 0
) : PathButton(context, attrs, defStyle) {
    var startRadians = 45f

    init {
        context.withStyledAttributes(attrs, R.styleable.ArcButton) {
            paint.color = getInt(R.styleable.ArcButton_arcColor, Color.GREEN)
            startRadians = getInt(R.styleable.ArcButton_arcStart, 45).toFloat()
            drawable = getDrawable(R.styleable.ArcButton_arcDrawable)
        }
        paint.style = Paint.Style.FILL
    }

    override fun isTouched(x: Float, y: Float): Boolean {
        val size = getSize()
        val outerRadius = size / 2
        val innerRadius = size * 0.3f

        val touchRadius = sqrt(x.pow(2) + y.pow(2))
        var touchAngle = Math.toDegrees(atan2(y, x).toDouble()).toFloat()

        if (y < 0 && touchAngle < -135) {
            touchAngle += 360f
        }

        if (touchRadius > outerRadius || touchRadius < innerRadius) {
            return false
        }

        if (touchAngle < startRadians || touchAngle > startRadians + 90f) {
            return false
        }

        return true
    }

    override fun createPath(width: Int, height: Int): Path {
        val size = getSize()
        val centerX = size / 2
        val centerY = size / 2
        val outerRadius = size / 2
        val innerRadius = size * 0.3f

        val endRadians = startRadians + 90f

        val startLine = getPositionOnCircle(centerX, centerY, startRadians, innerRadius);
        val endLine = getPositionOnCircle(centerX, centerY, endRadians, outerRadius);

        val outerRect = RectF(0f, 0f, size, size)
        val innerRect = RectF(
            centerX - innerRadius,
            centerY - innerRadius,
            innerRadius + outerRadius,
            innerRadius + outerRadius
        )

        return Path().apply {
            arcTo(outerRect, endRadians, startRadians - endRadians)
            lineTo(startLine.x, startLine.y)
            arcTo(innerRect, startRadians, endRadians - startRadians)
            lineTo(endLine.x, endLine.y)
        }
    }

    override fun getDrawableBounds(): Rect {
        val size = getSize()
        val centerX = size / 2
        val centerY = size / 2
        val outerRadius = size / 2
        val innerRadius = size * 0.3f
        val radius = (innerRadius + outerRadius) / 2f
        val drawableSize = size / 10
        val point = getPositionOnCircle(centerX, centerY, startRadians + 45, radius);

        return Rect(
            (point.x - drawableSize / 2).toInt(),
            (point.y - drawableSize / 2).toInt(),
            (point.x + drawableSize / 2).toInt(),
            (point.y + drawableSize / 2).toInt(),
        )
    }

    private fun getPositionOnCircle(centerX: Float, centerY: Float, radians: Float, radius: Float): PointF = PointF(
        (centerX + Math.cos(Math.toRadians(radians.toDouble())) * radius).toFloat(),
        (centerY + Math.sin(Math.toRadians(radians.toDouble())) * radius).toFloat(),
    )
}
