package com.isdenmois.remotecontrol.ui.buttons

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.Rect
import android.graphics.drawable.Drawable
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View

abstract class PathButton(context: Context, attrs: AttributeSet? = null, defStyle: Int = 0) :
    View(context, attrs, defStyle) {
    protected var path = Path()
    protected val paint = Paint(Paint.ANTI_ALIAS_FLAG)
    protected fun getSize() = Math.min(width, height).toFloat()
    protected var drawable: Drawable? = null

    private val touchEffectAnimator = TouchEffectAnimator(this).apply {
        setHasRippleEffect(true)
        setEffectColor(Color.LTGRAY)
    }

    private var touched = false
    private var listener: OnClickListener? = null

    protected abstract fun isTouched(x: Float, y: Float): Boolean
    protected abstract fun createPath(width: Int, height: Int): Path
    protected abstract fun getDrawableBounds(): Rect

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)

        canvas.drawPath(path, paint)
        touchEffectAnimator.onDraw(canvas, path)
        drawable?.draw(canvas)
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)

        path = createPath(w, h)
        drawable?.let {
            it.bounds = getDrawableBounds()
        }
    }

    override fun setOnClickListener(l: OnClickListener?) {
        listener = l;
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        val x = event.x - width / 2f
        val y = event.y - height / 2f

        if (event.action == MotionEvent.ACTION_UP) {
            touchEffectAnimator.onTouchEvent(event)
        }

        if (!isTouched(x, y)) {
            touched = false
            return false
        }

        if (touched && event.action == MotionEvent.ACTION_UP) {
            listener?.onClick(this)
        }

        touched = event.action != MotionEvent.ACTION_UP
        touchEffectAnimator.onTouchEvent(event);

        return true
    }
}
