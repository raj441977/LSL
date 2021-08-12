vector BasePos;
rotation BaseRot;
integer amdChanel = 5555;

default{
    state_entry(){
        string data = llGetObjectDesc();
        if(data != ""){
            BasePos = llList2Vector(llParseString2List(data, "|", []), 0);
            BaseRot = llList2Rot(llParseString2List(data, "|", []), 1);
        }
        llSetKeyframedMotion([], []);
        llSetPrimitiveParams([PRIM_POSITION, BasePos, PRIM_ROTATION, BaseRot]);
        llListen(amdChanel, "", llGetOwner(), "");
    }
    
    on_rez(integer num){
        BasePos = llGetPos();
        BaseRot = llGetRot();
        llSetKeyframedMotion([], []);
        llSetObjectDesc((string)BasePos +"|"+ (string)BaseRot);
        llSetPrimitiveParams([PRIM_POSITION, BasePos, PRIM_ROTATION, BaseRot]);
    }
    
    listen(integer chanel, string name, key senderId, string msg){
        if(chanel == amdChanel){
            llOwnerSay("\n/"+ (string)chanel +" "+ msg);
            if(msg == "reset"){
                string data = llGetObjectDesc();
                if(data != ""){
                    BasePos = llList2Vector(llParseString2List(data, "|", []), 0);
                    BaseRot = llList2Rot(llParseString2List(data, "|", []), 1);
                }
                llSetKeyframedMotion([], []);
                llSetPrimitiveParams([PRIM_POSITION, BasePos, PRIM_ROTATION, BaseRot]);
            }
            else{
                string type = llList2String(llParseString2List(msg, "|", []), 0);
                integer FPS = llList2Integer(llParseString2List(msg, "|", []), 1);
                float tSecond = llList2Float(llParseString2List(msg, "|", []), 2);
                vector degree = llList2Vector(llParseString2List(msg, "|", []), 3);
                vector distance = llList2Vector(llParseString2List(msg, "|", []), 4);
                
                integer index;
                list frames = [];
                integer tFrame = FPS * tSecond;
                float frameTime = (float)tSecond / tFrame;
                
                if(type == "play"){
                    for(index = 1; index <= tFrame; index++){frames += [<(distance.x / tFrame), (distance.y / tFrame), (distance.z / tFrame)>, llEuler2Rot((degree * DEG_TO_RAD) / tFrame), frameTime];}
                    llSetKeyframedMotion(frames,[KFM_MODE, KFM_FORWARD]);
                }
                else if(type == "back"){
                    for(index = 1; index <= tFrame; index++){frames += [<(distance.x / tFrame), (distance.y / tFrame), (distance.z / tFrame)>, llEuler2Rot((degree * DEG_TO_RAD) / tFrame), frameTime];}
                    llSetKeyframedMotion(frames,[KFM_MODE, KFM_REVERSE]);
                }
                else if(type == "pong"){
                    for(index = 1; index <= tFrame; index++){frames += [<(distance.x / tFrame), (distance.y / tFrame), (distance.z / tFrame)>, llEuler2Rot((degree * DEG_TO_RAD) / tFrame), frameTime];}
                    llSetKeyframedMotion(frames,[KFM_MODE, KFM_PING_PONG]);
                }
            }
        }
    }
}
