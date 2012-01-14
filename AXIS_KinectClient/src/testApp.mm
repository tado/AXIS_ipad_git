#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	ofSetFrameRate(60);
	ofSetOrientation(OF_ORIENTATION_90_LEFT);
	ofBackgroundHex(0x000000);
	
	// open an outgoing connection to HOST:PORT
	sender.setup( HOST, PORT );
	
	targetScale = scale = 2.5;
	
	ofxOscMessage m;
	m.setAddress( "/app/init" );
	m.addIntArg( 1 );
	sender.sendMessage( m );
	
	ofSetLineWidth(2);
	ofEnableSmoothing();
	light.enable();
}

//--------------------------------------------------------------
void testApp::update(){
	
}

//--------------------------------------------------------------
void testApp::draw(){
//	// display instructions
//	string buf;
//	buf = "sending osc messages to" + string( HOST ) + ofToString( PORT );
//	ofDrawBitmapString( buf, 10, 20 );
	
	//draw box
	glEnable(GL_DEPTH_TEST);
	ofNoFill();
	ofSetHexColor(0xFFFFFF);
	ofPushMatrix();
	ofTranslate(ofGetWidth()/2, ofGetHeight()/2);
	ofScale(scale, scale, scale);
	ofRotateX(-rotY / 2.0);
	ofRotateY(rotX / 1.5);
	ofBox(0, 0, 0, 100);
	ofPopMatrix();
}

//--------------------------------------------------------------
void testApp::exit(){
	//send exit message via OSC
	ofxOscMessage m;
	m.setAddress( "/app/init" );
	m.addIntArg( 2 );
	sender.sendMessage( m );
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	if (touch.numTouches > 1) {
		touchLoc[touch.id].set(touch.x, touch.y);
		currentDist = ofDist(touchLoc[0].x, touchLoc[0].y, touchLoc[1].x, touchLoc[1].y);
		scale = targetScale;
	}
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	
	if (touch.numTouches == 1) {
		
		rotX = (touch.x - (float)ofGetWidth()/2.0) / 4.0;
		rotY = (touch.y - (float)ofGetHeight()/2.0) / 4.0;
		
		ofxOscMessage m;
		m.setAddress( "/touch/position" );
		m.addFloatArg(rotX);
		m.addFloatArg(rotY);
		sender.sendMessage( m );
	}
	
	if (touch.numTouches > 1) {
		touchLoc[touch.id].set(touch.x, touch.y);
		float dist = ofDist(touchLoc[0].x, touchLoc[0].y, touchLoc[1].x, touchLoc[1].y);
		float diff = dist - currentDist;
		cout << "Touch Distance = " << diff << ", Scale = " << scale << ", TargetScale = " << targetScale << endl;
		
		if (abs(diff) < 10) {
			scale += diff * 0.01;
			//targetScale += (scale - targetScale) * 0.01;
			if (scale < 0.5) scale = 0.5;
			if (scale > 8.0) scale = 8.0;
			
			ofxOscMessage m;
			m.setAddress( "/touch/scale" );
			m.addFloatArg(scale);
			sender.sendMessage( m ); 

		}
		currentDist = dist;
	}
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
	if (touch.numTouches > 1) {
		touchLoc[touch.id].set(touch.x, touch.y);
		currentDist = ofDist(touchLoc[0].x, touchLoc[0].y, touchLoc[1].x, touchLoc[1].y);
	}
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	ofxOscMessage m;
	m.setAddress( "/touch/position" );
	m.addFloatArg(0);
	m.addFloatArg(0);
	sender.sendMessage( m );
	
	ofxOscMessage mc;
	mc.setAddress( "/touch/scale" );
	mc.addFloatArg(2.5);
	sender.sendMessage( mc );
	
	rotX = rotY = 0;
	scale = 2.5;
}

//--------------------------------------------------------------
void testApp::lostFocus(){
	
}

//--------------------------------------------------------------
void testApp::gotFocus(){
	
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
	
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
	
}


//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){
	
}

