import qualified Graphics.Rendering.OpenGL as GL
import qualified Graphics.UI.GLUT as GLUT
import Data.IORef

import Bindings (reshape, keyboardMouse)
import Display (idle, display)

($=) :: (GL.HasSetter s) => s a -> a -> IO ()
($=) = (GL.$=)

lightDiffuse :: GLUT.Color4 GL.GLfloat
lightDiffuse = GLUT.Color4 1.0 1.0 0.0 1.0

lightPosition :: GLUT.Vertex4 GL.GLfloat
lightPosition = GLUT.Vertex4 1.0 1.0 1.0 1.0
 
main :: IO ()
main = do
    (progname,_) <- GLUT.getArgsAndInitialize
    initOpenGL
    angle <- newIORef 0.0 -- A nice "Mutable" IO Monad

    GLUT.reshapeCallback $= Just reshape
    GLUT.keyboardMouseCallback $= Just keyboardMouse -- TODO: Something fun with this
    GLUT.displayCallback $= (display angle)
    GLUT.idleCallback $= Just (idle angle)

    GLUT.mainLoop

initOpenGL :: IO ()
initOpenGL = let light0 = GL.Light 0 in do
    GLUT.initialDisplayMode $= [GLUT.RGBMode,GLUT.WithDepthBuffer,GLUT.DoubleBuffered]

    GLUT.initialWindowSize $= GL.Size 1024 786
    GLUT.initialWindowPosition $= GL.Position 0 0
    GLUT.createWindow "Hello World"

    GL.depthFunc $= Just GL.Lequal
    GL.matrixMode $= GL.Projection
    GL.depthMask $= GL.Enabled
    GL.viewport $= (GL.Position 0 0 , GL.Size 1024 786)
    GL.perspective 90 ((fromIntegral 1024)/(fromIntegral 786)) 0.01 1000
    GL.lookAt (GL.Vertex3 0.0 0.0 1.0) (GL.Vertex3 0.0 0.0 0.0) (GL.Vector3 0.0 1.0 0.0)
    GL.matrixMode $= GL.Modelview 0

    GL.clearColor $= GL.Color4 0.0 0.0 0.0 1.0
    GL.blendFunc $= (GL.SrcAlpha, GL.OneMinusSrcAlpha)
    GL.colorMaterial $= Just (GL.FrontAndBack, GL.AmbientAndDiffuse)
    GL.texture GLUT.Texture3D $= GL.Enabled
    GL.diffuse light0 $= lightDiffuse
    GL.position light0 $= lightPosition
    GL.light light0 $= GL.Enabled
    GL.lighting $= GL.Enabled
