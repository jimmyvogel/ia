
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

#include "vtkCutter.h"

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

#include "vtkPlane.h"

int main(int argc, char **argv)
{
    //Data file
    vtkDataSetReader *reader = vtkDataSetReader::New();
    reader->SetFileName("../noise.vtk");

    //Plane un objet de type plan
	vtkPlane *plane = vtkPlane::New();
	plane->SetNormal(1,1,1);
	plane->SetOrigin(0,0,0);

    /*  FILTERS */
    
    //Filter 1 filtre utilisant un plan pour faire une découpe
    vtkCutter *cf = vtkCutter::New();
    cf->SetInputConnection(reader->GetOutputPort());
    cf->SetCutFunction(plane);

    //Mapper and texture(visualisation color)
    vtkDataSetMapper *mapper = vtkDataSetMapper::New();
    mapper->SetInputConnection(cf->GetOutputPort());

    //Color
    vtkLookupTable *lut = vtkLookupTable::New();
    double vals[4] = {0.75,0,0.05,1};
  	int i;
  	for (i = 0; i < 256; ++i){
  		double vals[4] = {(256.0-i)/256.0,0.0,i/256.0,1.0};
  		lut->SetTableValue(i, vals);
    }
    mapper->SetLookupTable(lut);
    mapper->SetScalarRange(1,6);

    //Filter 2
    vtkContourFilter *cf2 = vtkContourFilter::New();
    cf2->SetInputConnection(reader->GetOutputPort());
    cf2->SetNumberOfContours(2);
    cf2->SetValue(1,1.4);
    cf2->SetValue(2,2.4);

    //Mapper and texture(visualisation color)
    vtkDataSetMapper *mapper2 = vtkDataSetMapper::New();
    mapper2->SetInputConnection(cf2->GetOutputPort());
    mapper2->SetLookupTable(lut);
    mapper2->SetScalarRange(1,6);

    //Affichage de la couleur
    lut->Build();

    //Actors
    vtkActor *actor = vtkActor::New();
    vtkActor *actor2 = vtkActor::New();
    actor->SetMapper(mapper);
    actor2->SetMapper(mapper2);

    //Renderer
    vtkRenderer *ren = vtkRenderer::New();
    vtkRenderer *ren2 = vtkRenderer::New();
    ren->AddActor(actor);
    ren->SetViewport (0.0, 0.0, 0.5, 1.0);
    ren2->AddActor(actor2);
    ren2->SetViewport (0.5, 0.0, 1.0, 1.0);

    //Window
    vtkRenderWindow *renwin = vtkRenderWindow::New();
    renwin->SetSize(768, 768);
    renwin->AddRenderer(ren);
    renwin->AddRenderer(ren2);

    renwin->Render();
    cf2->SetNumberOfContours(1);
    for (i = 1; i < 6.0; i=i+0.01){

        cf2->SetValue(1,i);
        renwin->Render();
    }

}

