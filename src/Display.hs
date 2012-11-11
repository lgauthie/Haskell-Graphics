module Display (idle, display) where
 
import Graphics.Rendering.OpenGL
import Graphics.UI.GLUT
 
import Cube

points :: Int -> [(GLfloat,GLfloat,GLfloat)]
points n' = let n = fromIntegral n' in
    map (\k -> let t = 2*pi*k/n in (sin(t),0,cos(t)))  [1..n]
 
display angle = do 
    clear [DepthBuffer, ColorBuffer]
    loadIdentity
    a <- get angle
    rotate a $ Vector3 1 1 (1::GLfloat)
    scale 0.5 0.5 (0.5 :: GLfloat)
    scube <- defineNewList Compile $ do
        renderObject Solid $ Cube (0.1)
    lcube <- defineNewList Compile $ do
        renderObject Wireframe $ Cube (0.1)
    mapM_ (\(x,y,z) -> preservingMatrix $ do
        color $ Color3 ((x+1.0)/2.0) ((y+1.0)/2.0) ((z+1.0)/2.0)
        translate $ Vector3 x y z
        callList scube
        color $ Color3 0.0 0.0 (0.0::GLfloat)
        callList lcube
        ) $ points 17
    swapBuffers
 
idle angle = do
    a <- get angle
    angle $=! (a + 0.04)
    postRedisplay Nothing
