import qualified Graphics.Rendering.OpenGL as GL
import qualified Graphics.UI.GLUT as GL
import Data.IORef

($=) :: (GL.HasSetter s) => s a -> a -> IO ()
($=) = (GL.$=)

reshape s@(GL.Size w h) = do 
    GL.viewport $= (GL.Position 0 0, s)

main = do
    (progname,_) <- GL.getArgsAndInitialize
    initOpenGL
    GL.reshapeCallback $= Just reshape
    GL.displayCallback $= display
    GL.mainLoop

display = do
    GL.clear [GL.DepthBuffer, GL.ColorBuffer]
    renderPrimitive Quads
    GL.swapBuffers

initOpenGL = do
    GL.initialDisplayMode $= [GL.DoubleBuffered, GL.RGBMode]
    GL.initialWindowSize $= GL.Size 1024 786
    GL.initialWindowPosition $= GL.Position 100 100
    GL.createWindow "Tutorial 1"
