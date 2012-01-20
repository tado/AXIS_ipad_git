#include "faceExchangeController.h"

const int num_face = 15;
const int size_img = 200;
//const int gap = 10;
const int margin_top = 84;
const int margin_left = 10;
//--------------------------------------------------------------
void faceExchangeController::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
	ofSetOrientation(OF_ORIENTATION_90_RIGHT);
	
	ofBackground(0);
    
    // open an outgoing connection to HOST:PORT
	//sender.setup( HOST, PORT );
	
	//get ip address from Settings.bundle
	string host;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *addr = [prefs stringForKey:@"host_ip"];
    if (addr) host = [addr UTF8String];
	sender.setup( host, PORT );
	cout << "send OSC, host = " << host << ", port = " << PORT << endl;
    
	ofxOscMessage m;
	m.setAddress( "/app/init" );
	m.addIntArg( 0 );
	sender.sendMessage( m );
    
    faceImages = new ofImage [num_face];
    
    for (int i = 0; i < num_face; i++) {
        
        char * imageName = new char [255];
        sprintf(imageName,"images/%03d.png",i+1);
		faceImages[i].loadImage(imageName);
    }
    
	selectNum = 0;
}

//--------------------------------------------------------------
void faceExchangeController::update(){
    
}

//--------------------------------------------------------------
void faceExchangeController::draw(){
	
    ofSetColor(255, 255, 255);
    
    for (int i =0; i < num_face; i++) {  
        float imageX = i % 5 * size_img + margin_left;
        float imageY = i / 5 * size_img + margin_top;
        faceImages[i].draw(imageX, imageY);
    }
    ofSetColor(255, 0, 0);
	
	if (selectNum < num_face) {
		ofNoFill();
		ofSetLineWidth(3);
		ofRect(selectNum % 5 * size_img + margin_left, selectNum / 5 * size_img + margin_top,
			   size_img, size_img);
		ofFill();
	}
	
    //ofDrawBitmapString("test" , 10, 20);
    
}

//--------------------------------------------------------------
void faceExchangeController::exit(){
//    
//    ofxOscMessage exitMessage;
//    exitMessage.addStringArg("/app/exit");
//    sender.sendMessage(exitMessage);
	ofxOscMessage m;
	m.setAddress( "/app/init" );
	m.addIntArg( 2 );
	sender.sendMessage( m );
}

//--------------------------------------------------------------
void faceExchangeController::touchDown(ofTouchEventArgs &touch){
    
    
}

//--------------------------------------------------------------
void faceExchangeController::touchMoved(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void faceExchangeController::touchUp(ofTouchEventArgs &touch){
    
    
    ofxOscMessage num;
    num.setAddress("/face/number");
    
    if (touch.id == 0) {
//        if (touch.y >= gap && touch.y <= size_img) {
//            
//            if (touch.x >=0 && touch.x < size_img) {
//                //send 1  
//                printf("1\n");
//                num.addIntArg(0);
//				selectNum = 1;
//			}else if(touch.x >=gap + size_img && touch.x < size_img * 2){
//                //send 2 
//                printf("2\n");
//                num.addIntArg(1);
//				selectNum = 2;   
//            }else if(touch.x >=gap + size_img *2 && touch.x < size_img * 3){
//                //send 3 
//                printf("3\n");
//                num.addIntArg(2);
//				selectNum = 3;
//            }else if(touch.x >=gap + size_img *3 && touch.x < size_img * 4){
//                //send 4 
//                printf("4\n");
//                num.addIntArg(3);
//				selectNum = 4;
//            }else if(touch.x >=gap + size_img *4 && touch.x < size_img * 5){
//                //send 5 
//                printf("5\n");
//                num.addIntArg(4);
//				selectNum = 5;
//            }
//            
//        }
        
        selectNum = ((int)touch.x - margin_left) / size_img + ((int)touch.y - margin_top) / size_img * 5;
        cout << "xpos = " << (int)touch.x / size_img << ", ypos = " << (int)touch.y / size_img << endl;
        cout << "select num = " << selectNum << endl;
        if (selectNum < num_face) {
            num.addIntArg(selectNum);
            sender.sendMessage(num);
        }
    }
}

//--------------------------------------------------------------
void faceExchangeController::touchDoubleTap(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void faceExchangeController::lostFocus(){
    
}

//--------------------------------------------------------------
void faceExchangeController::gotFocus(){
    
}

//--------------------------------------------------------------
void faceExchangeController::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void faceExchangeController::deviceOrientationChanged(int newOrientation){
    
}


//--------------------------------------------------------------
void faceExchangeController::touchCancelled(ofTouchEventArgs& args){
    
}

void faceExchangeController::sendMessage(int num){
    
    ofxOscMessage imageNum;
    imageNum.addIntArg(num);
    sender.sendMessage(imageNum);
}


