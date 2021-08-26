import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network{


  final String _url = 'http://localhost/wfm-main/api';

  var token;
  var alldata;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
  }

  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
     alldata = jsonDecode(localStorage.getString('allData'));
  }


  Mobile_NO_Check(apiUrl) async{
    var fullUrl = _url + apiUrl;
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.post(
        fullUrl,
        headers: _setHeaders()
    );
  }

  organizationsList(apiUrl) async {
    await _loadUserData();
    var personId = alldata['person_id'];
    apiUrl+= "/$personId";
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }

  categoryList(apiUrl) async {
    var fullUrl = _url + apiUrl;

    await _getToken();
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }

  categorySave(data, apiUrl) async {
    await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  categoryUpdate(data, apiUrl) async {
    await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  projectList(apiUrl) async {
    var fullUrl = _url + apiUrl;

    await _getToken();
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }

  projectCreate(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }

  ProjectStore(data, apiUrl) async {
    await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  taskList(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };

}