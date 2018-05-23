
#include <vtkPolyData.h>
#include <vtkPLYReader.h>
#include <vtkSmartPointer.h>
#include <vtkPolyDataMapper.h>

#include <vtkRenderWindow.h>
#include <vtkRenderer.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkDataSetReader.h>
#include <vtkDataSetMapper.h>
#include <vtkActor.h>
#include <vtkLookupTable.h>


#include <vtkInteractorStyleTrackballCamera.h>
#include <vtkInteractorStyleTerrain.h>
#include <vtkInteractorStyleJoystickCamera.h>
#include <vtkInteractorStyleFlight.h>


#include <vtkElevationFilter.h>
#include <vtkTransform.h>
#include <vtkTransformFilter.h>

#include "vtkCamera.h"
#include "vtkProperty.h"

#include "vtkSphereSource.h"
#include "vtkConeSource.h"

#include <vtkRenderWindow.h>
#include <vtkRenderer.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkDataSetReader.h>
#include <vtkDataSetMapper.h>
#include <vtkActor.h>
#include <vtkLookupTable.h>
#include <vtkContourFilter.h>


int main(int argc, char **argv)
{
    //Data file
    vtkDataSetReader *reader = vtkDataSetReader::New();
    reader->SetFileName("../noise.vtk");

    //Filter
    vtkContourFilter *cf = vtkContourFilter::New();
    cf->SetInputConnection(reader->GetOutputPort());
    cf->SetNumberOfContours(3);
    cf->SetValue(1,2.4);
    cf->SetValue(2,4.0);
    cf->SetValue(3,5.0);

    //Mapper and texture(visualisation color)
    vtkDataSetMapper *mapper = vtkDataSetMapper::New();
    mapper->SetInputConnection(cf->GetOutputPort());

    //Utiliser pour la couleur
    vtkLookupTable *lut = vtkLookupTable::New();
    mapper->SetLookupTable(lut);
    mapper->SetScalarRange(1,6);
    lut->Build();

    //Actor
    vtkActor *actor = vtkActor::New();
    actor->SetMapper(mapper);

    //Renderer
    vtkRenderer *ren = vtkRenderer::New();
    ren->AddActor(actor);
    
    //Window
    vtkRenderWindow *renwin = vtkRenderWindow::New();
    renwin->SetSize(768, 768);
    renwin->AddRenderer(ren);
    
    
    //Interaction
    vtkRenderWindowInteractor *iren = vtkRenderWindowInteractor::New();
    iren->SetRenderWindow(renwin);
    renwin->Render();
    iren->Start();
}

