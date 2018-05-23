
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

#include "vtkBoxWidget.h"

#include <vtkCommand.h>

class vtkMyCallback : public vtkCommand

 {

public:

  static vtkMyCallback *New()
    { 
      return new vtkMyCallback;
    }


  //Method made by the prof
  virtual void Execute(vtkObject *caller, unsigned long, void*)
    {
      vtkTransform *t = vtkTransform::New();
      vtkBoxWidget *widget = reinterpret_cast<vtkBoxWidget*>(caller);
      widget->GetTransform(t);
      widget->GetProp3D()->SetUserTransform(t);
      t->Delete();
    }
 };


int main(int argc, char **argv)
{
  //Object cone: height, radios, resolution
  vtkConeSource *cone = vtkConeSource::New();
  cone->SetHeight( 3.0 );
  cone->SetRadius( 1.0 );
  cone->SetResolution( 10 );

  /*  Mapper */

  //A mapper surrounded an object
  vtkDataObject* input = cone->GetOutput();
  vtkDataSetMapper *mapper = vtkDataSetMapper::New();
  mapper->SetInputConnection(cone->GetOutputPort());

    
  /*  Actor */

  //An actor is used to position the object, to specify color...
  vtkActor *actor = vtkActor::New();
  actor->SetMapper(mapper);

  vtkActor *actor2 = vtkActor::New();
  actor2->SetMapper(mapper);
  actor2->SetPosition(0.0,-2.0,0.0);
  actor2->GetProperty()->SetColor(0.0,1.0,0.0);

  /*  Renderer */

  //The renderer surrounded the actors and set the background of the image.
  vtkRenderer *renderer = vtkRenderer::New();	
  renderer->AddActor(actor);
  renderer->AddActor(actor2);
  renderer->SetBackground(0,0,0);
 
  /*  Windows */
	vtkRenderWindow *renWin = vtkRenderWindow::New();
  renWin->AddRenderer(renderer);
	renWin->SetSize(450,450);

  //Interaction

  //Interaction manipulable a la souris de l'utilisateur.
  vtkRenderWindowInteractor *iren = vtkRenderWindowInteractor::New();
  iren->SetRenderWindow(renWin);

  //Ajout d'une boite manipulable
  vtkBoxWidget *boxWidget = vtkBoxWidget::New();
  boxWidget->SetInteractor(iren);
  boxWidget->SetPlaceFactor(1.25);
  boxWidget->SetProp3D(actor);
  boxWidget->PlaceWidget();
  vtkMyCallback *callback = vtkMyCallback::New();
  boxWidget->AddObserver(vtkCommand::InteractionEvent, callback);
  boxWidget->On();
  iren->Initialize();
  iren->Start();

  /*  Transformation */

  //cone 1
  vtkTransform* transform = vtkTransform::New();
  transform->RotateZ(1);
  actor->SetUserMatrix(transform->GetMatrix());

  //Affichage initiale
  renWin->Render();

  int i;
  for (i = 0; i < 3000; ++i)
  {
     // render the image
     renWin->Render();

     //rotate the camera by on degre only for for the actor one.
     transform->RotateZ(1);
     actor->SetUserMatrix(transform->GetMatrix());
  }

  // Clean up
  renderer->Delete();
  renWin->Delete();

  cone->Delete();
  
  mapper->Delete();
  actor->Delete();
}


