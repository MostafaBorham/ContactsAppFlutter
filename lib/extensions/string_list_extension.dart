extension StringListExtent on List<String>{
  String parse(){
    String result='';
    for (var element in this) {
      result+=element;
    }
    return result;
  }
}