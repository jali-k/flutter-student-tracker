import '../model/all_mark_data_model.dart';
import 'api_provider.dart';

class PaperMarkService{

  static getPaperMarks(String paperID) async{
    try {
      final response = await APIProvider.instance.get('/mark/paper/$paperID');
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        AllMarkDataModel allMarkDataModel = AllMarkDataModel.fromJson(response.data);
        return allMarkDataModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}