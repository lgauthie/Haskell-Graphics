module Display (idle, display) where
 
import qualified Graphics.Rendering.OpenGL as GL
import qualified Graphics.UI.GLUT as GLUT

($=!) :: (GL.HasSetter s) => s a -> a -> IO ()
($=!) = (GL.$=!)

points :: Int -> [(GL.GLfloat,GL.GLfloat,GL.GLfloat)]
points n' = let n = fromIntegral n' in
    map (\k -> let t = 2*pi*k/n in (sin(t),0,cos(t)))  [1..n]
 
display angle = do 
    GL.clear [GL.DepthBuffer, GL.ColorBuffer]
    GL.loadIdentity
    a <- GLUT.get angle
    GL.rotate a $ GL.Vector3 1 1 (1 :: GL.GLfloat)
    GL.scale 0.5 0.5 (0.5 :: GL.GLfloat)
    scube <- GL.defineNewList GL.Compile $ do
        GLUT.renderObject GLUT.Solid $ GLUT.Cube (0.1)
    lcube <- GLUT.defineNewList GLUT.Compile $ do
        GLUT.renderObject GLUT.Wireframe $ GLUT.Cube (0.1)
    mapM_ (\(x,y,z) -> GL.preservingMatrix $ do
        GL.color $ GL.Color3 ((x+1.0)/2.0) ((y+1.0)/2.0) ((z+1.0)/2.0)
        GL.translate $ GL.Vector3 x y z
        GL.callList scube
        GL.color $ GL.Color3 0.0 0.0 (0.0 :: GL.GLfloat)
        GL.callList lcube
        ) $ points 17
    GLUT.swapBuffers
 
idle angle = do
    a <- GLUT.get angle
    angle $=! (a + 0.04)
    GLUT.postRedisplay Nothing
