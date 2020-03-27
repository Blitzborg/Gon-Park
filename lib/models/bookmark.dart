
class Bookmark{
  String _LocationName;
  String _LocationID;
  double _cX;
  double _cY;


  Bookmark(this._LocationName,this._LocationID,this._cX,this._cY);

  String get LocationName=>_LocationName;
  String get LocationID=>_LocationID;
  double get cX=>_cX;
  double get cY=>_cY;


  set LocationName(String newName){
    this._LocationName=newName;
  }
  set LocationID(String newID){
    this._LocationID=newID;
  }
  set cX(double newX){
    this._cX=newX;
  }
  set cY(double newY){
    this._cY=newY;
  }


  Map<String,dynamic> toMap(){

    var map= Map<String,dynamic>();
    map['LocationName']=_LocationName;
    map['LocationID']=_LocationID;
    map['cX']=_cX;
    map['cY']=_cY;

    return map;
  }

  Bookmark.fromMapObject(Map<String,dynamic>map){
        this._LocationID=map['LocationID'];
        this._LocationName=map['LocationName'];
        this._cX=map['cX'];
        this._cY=map['cY'];

  }
}