import 'package:flutter/cupertino.dart';
import 'package:spt/model/all_papers_data_model.dart';

import '../util/toast_util.dart';
import 'api_provider.dart';

class PaperService{

  static getAllPaperList(BuildContext context) async {
    final response = await APIProvider.instance.get('/paper/all');
    if(response.statusCode == 200){
      return AllPapersDataModel.fromJson(response.data);
    }else{
      return null;
    }
  }


}