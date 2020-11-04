class Favorite {
  int _id;
  String _title;
  String _description;
  String _organizer;
  String _location;
  String _imageurl;
 
  Favorite(this._title, this._description, this._organizer, this._location, this._imageurl);
 
  Favorite.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._description = obj['description'];
    this._organizer = obj['organizer'];
    this._location = obj['location'];
    this._imageurl = obj['imageurl'];
  }
 
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get imageurl => _imageurl;
  String get location => _location;
  String get organizer => _organizer;
  
 
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
     map['organizer'] = _organizer;
    map['location'] = _location;
     map['imageurl'] = _imageurl;
    
    
 
    return map;
  }
 
  Favorite.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._organizer = map['organizer'];
    this._imageurl = map['imageurl'];
    this._location = map['location'];
    
  }
}