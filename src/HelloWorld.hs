import Graphics.Rendering.OpenGL
import Graphics.UI.GLUT
import Data.IORef
 
import Bindings

lightDiffuse :: Color4 GLfloat
lightDiffuse = Color4 1.0 1.0 0.0 1.0

lightPosition :: Vertex4 GLfloat
lightPosition = Vertex4 1.0 1.0 1.0 1.0
 
main = do
    (progname,_) <- getArgsAndInitialize
    initOpenGL
    reshapeCallback $= Just reshape
    keyboardMouseCallback $= Just keyboardMouse
    angle <- newIORef 0.0
    displayCallback $= (display angle)
    idleCallback $= Just (idle angle)
    mainLoop

initOpenGL = let light0 = Light 0 in do
    initialDisplayMode $= [RGBMode,WithDepthBuffer,DoubleBuffered]

    initialWindowSize $= Size 1024 786 
    initialWindowPosition $= Position 0 0
    createWindow "Hello World"

    depthFunc $= Just Lequal
    matrixMode $= Projection
    depthMask $= Enabled
    viewport $= (Position 0 0 , Size 1024 786)
    perspective 90 ((fromIntegral 1024)/(fromIntegral 786)) 0.01 1000
    lookAt (Vertex3 0.0 0.0 1.0) (Vertex3 0.0 0.0 0.0) (Vector3 0.0 1.0 0.0)
    matrixMode $= Modelview 0

    clearColor $= Color4 0.0 0.0 0.0 1.0
    blendFunc $= (SrcAlpha, OneMinusSrcAlpha)
    colorMaterial $= Just (FrontAndBack, AmbientAndDiffuse)
    texture Texture3D $= Enabled
    diffuse light0 $= lightDiffuse
    position light0 $= lightPosition
    light light0 $= Enabled
    lighting $= Enabled
