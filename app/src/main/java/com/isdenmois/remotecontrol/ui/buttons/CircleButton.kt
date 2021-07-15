package com.isdenmois.remotecontrol.ui.buttons

import android.content.Context
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.Rect
import android.util.AttributeSet
import androidx.core.content.withStyledAttributes
import com.isdenmois.remotecontrol.R
import kotlin.math.pow
import kotlin.math.sqrt

class CircleButton @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyle: Int = 0
) : PathButton(context, attrs, defStyle) {
    init {
        context.withStyledAttributes(attrs, R.styleable.CircleButton) {
            paint.color = getInt(R.styleable.CircleButton_circleColor, Color.GREEN)
            drawable = getDrawable(R.styleable.CircleButton_circleDrawable)
        }
        paint.style = Paint.Style.FILL
    }

    override fun isTouched(x: Float, y: Float): Boolean {
        val size = getSize()

        val circleRadius = size / 5
        val touchRadius = sqrt(x.pow(2) + y.pow(2))

        return touchRadius < circleRadius
    }

    override fun createPath(width: Int, height: Int): Path {
        val size = getSize()
        val radius = size / 5

        return Path().apply {
            addCircle(size / 2, size /2, radius, Path.Direction.CW)
        }
    }

    override fun getDrawableBounds(): Rect {
        val size = getSize()
        val centerX = size / 2
        val centerY = size / 2
        val drawableSize = size / 7

        return Rect(
            (centerX - drawableSize / 2).toInt(),
            (centerY - drawableSize / 2).toInt(),
            (centerX + drawableSize / 2).toInt(),
            (centerY + drawableSize / 2).toInt(),
        )
    }
}
