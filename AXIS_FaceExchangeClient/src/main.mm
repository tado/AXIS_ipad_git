#include "ofMain.h"
#include "faceExchangeController.h"

int main(){
	ofSetupOpenGL(1024,768, OF_FULLSCREEN);			// <-------- setup the GL context

	ofRunApp(new faceExchangeController);
}
